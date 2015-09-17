module type S = sig

  include Config.S

  val num_regs : int
  val log_regs : int

  module Mi : interface
    rdata vld
  end
  module Mi_instr : module type of Mi
  module Mi_data : module type of Mi

  module I : interface
    clk clr
    (mi : Mi_instr)
    (md : Mi_data)
  end

  module Mo : interface
    addr wdata req rw wmask  
  end
  module Mo_instr : module type of Mo
  module Mo_data : module type of Mo

  module O : interface
    (mi : Mo_instr)
    (md : Mo_data)
  end

  module Class : interface
    trap
    lui auipc
    jal jalr
    bra
    ld st
    opi opr
    fen sys rdc rdco
    f3 f7
  end

  module Stage : interface
    pen 
    ra1 ra2 rad
    ra1_zero ra2_zero rad_zero
    rd1 rd2 rdd rdm imm
    pc 
    instr insn (iclass : Class)
    branch
    rwe
    (mi : Mo_instr)
    (md : Mo_data)
    junk
  end

  module Stages : interface
    (fet : Stage)
    (dec : Stage)
    (alu : Stage)
    (mem : Stage)
    (com : Stage)
  end
  
  module O_debug : interface
    (o : O)
    (dbg : Stages)
  end

end

module Make(C : Config.S) = struct

  include C

  (* various (derived) constants *)
  let num_regs = 32
  let log_regs = HardCaml.Utils.clog2 num_regs

  let prefix name (n,b) = name^"_"^n, b 

  module Mi = interface
    rdata[C.xlen] vld[1]
  end
  module Mi_instr = struct include Mi let t = map (prefix "mio_instr") t end
  module Mi_data = struct include Mi let t = map (prefix "mio_data") t end

  (* interface to core *)
  module I = interface
    clk[1] clr[1]
    (mi : Mi_instr)
    (md : Mi_data)
  end

  module Mo = interface
    addr[C.xlen] wdata[C.xlen] req[1] rw[1] wmask[C.xlen/8]   
  end
  module Mo_instr = struct include Mo let t = map (prefix "mio_instr") t end
  module Mo_data = struct include Mo let t = map (prefix "mio_data") t end

  module O = interface
    (mi : Mo_instr)
    (md : Mo_data)
  end

  module Class = interface
    trap[1]
    lui[1] auipc[1]
    jal[1] jalr[1]
    bra[1]
    ld[1] st[1]
    opi[1] opr[1]
    fen[1] sys[1]
    rdc[1] rdco[3]
    f3[3] f7[1]
  end

  (* this stores the information needed at any stage of the
   * pipeline.  In some stages the information may or may not
   * have been calculated or needed.  Some values could just 
   * skip a stage or stop being required.  
   *
   * This will allow us to pass pipeline info from all stages
   * to all other stages which will make operations like bypassing 
   * easier without having to carefully track every bit of data
   * that is or isnt needed at a particular stage. 
   *
   * This will probably get pretty big, but not to worry as 
   * elaborating the design will remove stuff that's not needed.
   * On the other hand it will make it more difficult to 
   * produce a hierarchy of modules. *)
  module Stage = interface
    (* pipeline stage enable and clear *)
    pen[1] 
    (* register addresses *)
    ra1[log_regs] ra2[log_regs] rad[log_regs]
    (* register address zero detection *)
    ra1_zero[1] ra2_zero[1] rad_zero[1]
    (* data to/from register file *)
    rd1[C.xlen] rd2[C.xlen] rdd[C.xlen] rdm[C.xlen]
    (* immediate *)
    imm[C.xlen]
    (* program counter *)
    pc[C.xlen] 
    (* instruction from memory *)
    instr[32]
    (* decoded instruction *)
    insn[Insn.V.n+1]
    (* instruction class *)
    (iclass : Class)
    (* take a branch *)
    branch[1]
    (* reg file write enable *)
    rwe[1]
    (* instruction/data memory i/o *)
    (mi : Mo_instr)
    (md : Mo_data)
    (* junk TO BE REMOVED  *)
    junk[1]
  end

  module Stage_fet = struct include Stage let t = map (prefix "fet") t end
  module Stage_dec = struct include Stage let t = map (prefix "dec") t end
  module Stage_alu = struct include Stage let t = map (prefix "alu") t end
  module Stage_mem = struct include Stage let t = map (prefix "mem") t end
  module Stage_com = struct include Stage let t = map (prefix "com") t end

  module Stages = interface
    (fet : Stage_fet)
    (dec : Stage_dec)
    (alu : Stage_alu)
    (mem : Stage_mem)
    (com : Stage_com)
  end

  module O_debug = interface
    (o : O)
    (dbg : Stages)
  end

end

