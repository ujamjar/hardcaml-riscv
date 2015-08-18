module type S = sig

  include Config.S

  val num_regs : int
  val log_regs : int

  module I : interface
    clk clr
    mio_rdata mio_vld
  end

  module O : interface
    mio_addr mio_wdata mio_req mio_rw mio_wmask  
  end

  module Class : interface
    trap
    lui auipc
    jal jalr
    bra
    ld st
    opi opr
    fen sys
    f3 f7
  end

  module Stage : interface
    pen 
    ra1 ra2 rad
    ra1_zero ra2_zero rad_zero
    rd1 rd2 rdd rdm imm
    pc next_pc
    instr insn (iclass : Class)
    cond_branch
    junk
  end

  module O_debug : interface
    (o : O)
    (fet : Stage)
    (dec : Stage)
    (alu : Stage)
    (mem : Stage)
    (com : Stage)
  end

end

module Make(C : Config.S) = struct

  include C

  (* various (derived) constants *)
  let num_regs = 32
  let log_regs = HardCaml.Utils.clog2 num_regs

  (* interface to core *)
  module I = interface
    clk[1] clr[1]
    mio_rdata[C.xlen] mio_vld[1]
  end

  module O = interface
    mio_addr[C.xlen] mio_wdata[C.xlen] mio_req[1] mio_rw[1] mio_wmask[C.xlen/8]   
  end

  module Class = interface
    trap[1]
    lui[1] auipc[1]
    jal[1] jalr[1]
    bra[1]
    ld[1] st[1]
    opi[1] opr[1]
    fen[1] sys[1]
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
    pc[C.xlen] next_pc[C.xlen]
    (* instruction from memory *)
    instr[32]
    (* decoded instruction *)
    insn[Insn.V.n]
    (* instruction class *)
    (iclass : Class)
    (* take a conditional branch *)
    cond_branch[1]
    (* junk TO BE REMOVED  *)
    junk[1]
  end

  let pipename name (n,b) = name^"_"^n, b 
  module Stage_fet = struct include Stage let t = map (pipename "fet") t end
  module Stage_dec = struct include Stage let t = map (pipename "dec") t end
  module Stage_alu = struct include Stage let t = map (pipename "alu") t end
  module Stage_mem = struct include Stage let t = map (pipename "mem") t end
  module Stage_com = struct include Stage let t = map (pipename "com") t end
  module O_debug = interface
    (o : O)
    (fet : Stage_fet)
    (dec : Stage_dec)
    (alu : Stage_alu)
    (mem : Stage_mem)
    (com : Stage_com)
  end

end

