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
    junk
  end

  module Class : interface
    trap
    lui auipc
    jal jalr
    bra
    ld st
    opi opr
    fen sys csr 
    ecall eret
    f3 f7
  end
  module Class_ex : module type of Interface_ex.Make(Class) 

  module Csr_ctrl : interface
    csr_use_imm csr_imm 
    csr_we_n csr_re_n csr_invalid_we 
    csr_dec
    csr_clr csr_set csr_write
  end

  module Stage : interface
    insn pc instr 
    ra1 ra2 rad
    rd1 rd2 rdd 
    imm is_imm 
    branch rwe
    ra1_zero ra2_zero rad_zero
    (iclass : Class)
    (csr : Csr_ctrl)
    junk
  end
  module Stage_ex : module type of Interface_ex.Make(Stage) 

  module Stages : interface
    (fet : Stage)
    (dec : Stage)
    (alu : Stage)
    (mem : Stage)
    (com : Stage)
  end
  module Stages_ex : module type of Interface_ex.Make(Stages) 
  
  module Ctrl : interface
    en bubble
  end

  module O_debug : interface
    (o : O)
    (dbg : Stages)
  end

  module Mcpuid : sig
    module F : interface base z extensions end
    module Fx : module type of Interface_ex.Make(F)
    val base : [ `rv32i | `rv32e | `rv64i | `rv128 ] -> int
    val extensions : base:[ `rv32i | `rv32e | `rv64i | `rv128 ] -> char list -> 
      HardCaml.Bits.Comb.IntbitsList.t
  end

  module Mimpid : sig
    module F : interface implementation vendor end
    module Fx : module type of Interface_ex.Make(F)
    val vendor : int
  end

  module Mhartid : sig
    module F : interface hartid end
    module Fx : module type of Interface_ex.Make(F)
    val hartid : int
  end

  module Mstatus : sig
    module F : interface sd z vm mprv xs fs prv3 ie3 prv2 ie2 prv1 ie1 prv ie end
    module Fx : module type of Interface_ex.Make(F)
    type ext_ctx = Off | Initial | Clean | Dirty
    val ext_ctx_status_of_code : int -> ext_ctx
    val code_of_ext_ctx_status : ext_ctx -> int
    type vm = Mbare | Mbb | Mbbid 
            | Sv32 | Sv39 | Sv48 | Sv57 | Sv64
            | Reserved
    val vm_of_code : int -> vm
    val code_of_vm : vm -> int
  end

  module Mtvec : sig
    module F : interface addr z end
    module Fx : module type of Interface_ex.Make(F)
    module Hi : sig
      val trap : int
      val reset : int
      val trap_user : int
      val trap_super : int
      val trap_hyper : int
      val trap_machine : int
      val nmi : int
    end
    module Lo : sig
      val trap : int
      val reset : int
      val trap_user : int
      val trap_super : int
      val trap_hyper : int
      val trap_machine : int
      val nmi : int
    end
  end

  module Mtdeleg : sig
    module F : interface 
        interrupts
        synchronous_exceptions
    end
    module Fx : module type of Interface_ex.Make(F)
  end

  (* 3.1.11 *)
  module Mip : sig
    module F : interface 
      z0
      mtip htip stip z1
      msip hsip ssip z2
    end
    module Fx : module type of Interface_ex.Make(F)
  end
  
  module Mie : sig
    module F : interface 
      z0
      mtie htie stie z1
      msie hsie ssie z2
    end
    module Fx : module type of Interface_ex.Make(F)
  end

  (* 3.1.12 *)
  module Mtime : sig
    module F : interface mtime end
    module Fx : module type of Interface_ex.Make(F)
  end
  module Mtimecmp : sig
    module F : interface z mtimecmp end
    module Fx : module type of Interface_ex.Make(F)
  end

  (* 3.1.13 *)
  module Mscratch : sig
    module F : interface mscratch end
    module Fx : module type of Interface_ex.Make(F)
  end

  (* 3.1.14 *)
  module Mepc : sig
    module F : interface mepc end
    module Fx : module type of Interface_ex.Make(F)
    (* lsb always zero *)
  end

  module Mcause : sig
    module F : interface interrupt z cause end
    module Fx : module type of Interface_ex.Make(F)

    type exception_code = 
      | Instruction_address_misaligned
      | Instruction_access_fault
      | Illegal_instruction
      | Breakpoint
      | Load_address_misaligned
      | Load_access_fault
      | Store_AMO_address_misaligned
      | Store_AMO_access_fault
      | Environment_call_from_U_mode
      | Environment_call_from_S_mode
      | Environment_call_from_H_mode
      | Environment_call_from_M_mode
      | EReserved
    
    val exception_of_code : int -> exception_code
    
    val code_of_exception : exception_code -> int

    type interrupt_code =
      | Software
      | Timer
      | IReserved
    
    val interrupt_of_code : int -> interrupt_code
    val code_of_interrupt : interrupt_code -> int

  end

  module Mbadaddr : sig
    module F : interface mbadaddr end
    module Fx : module type of  Interface_ex.Make(F)
  end

  module Xlen : sig
    module F : interface data end
    module Fx : module type of Interface_ex.Make(F)
  end

  module Csr_regs : interface

    (cycle : Xlen.F)
    (time : Xlen.F)
    (instret : Xlen.F)
    (cycleh : Xlen.F)
    (timeh : Xlen.F)
    (instreth : Xlen.F)

    (mcpuid : Mcpuid.F)
    (mimpid : Mimpid.F)
    (mhartid : Mhartid.F)

    (mstatus : Mstatus.F)
    (mtvec : Mtvec.F)
    (mtdeleg : Mtdeleg.F)
    (mie : Mie.F)
    (mtimecmp : Mtimecmp.F)

    (mtime : Mtime.F)
    (mtimeh : Mtime.F)

    (mscratch : Mscratch.F)
    (mepc : Mepc.F)
    (mcause : Mcause.F)
    (mbadaddr : Mbadaddr.F)
    (mip : Mip.F)

    (mbase : Xlen.F) (* XXX max addr? *)
    (mbound : Xlen.F) 
    (mibase : Xlen.F) 
    (mibound : Xlen.F) 
    (mdbase : Xlen.F) 
    (mdbound : Xlen.F) 

  end

  module Csr_regs_ex : module type of Interface_ex.Make(Csr_regs)

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
    junk[1]
  end

  module Class = interface
    trap[1]
    lui[1] auipc[1]
    jal[1] jalr[1]
    bra[1]
    ld[1] st[1]
    opi[1] opr[1]
    fen[1] sys[1] csr[1] 
    ecall[1] eret[1]
    f3[3] f7[1]
  end
  module Class_ex = Interface_ex.Make(Class)

  module Csr_ctrl = interface
    csr_use_imm[1] csr_imm[5] 
    csr_we_n[1] csr_re_n[1] csr_invalid_we[1]
    csr_dec[List.length csrs]
    csr_clr[1] csr_set[1] csr_write[1]
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
    (* decoded instruction *)
    insn[Config.V.n+1]
    (* program counter *)
    pc[C.xlen] 
    (* instruction from memory *)
    instr[32]
    (* register addresses *)
    ra1[log_regs] ra2[log_regs] rad[log_regs]
    (* data to/from register file *)
    rd1[C.xlen] rd2[C.xlen] rdd[C.xlen]
    (* immediate *)
    imm[C.xlen] is_imm[1] 
    (* take a branch *)
    branch[1]
    (* reg file write enable *)
    rwe[1]
    (* register address zero detection *)
    ra1_zero[1] ra2_zero[1] rad_zero[1]
    (* instruction class *)
    (iclass : Class)
    (* csr control *)
    (csr : Csr_ctrl)
    (* junk TO BE REMOVED  *)
    junk[1]
  end
  module Stage_ex = Interface_ex.Make(Stage)

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
  module Stages_ex = Interface_ex.Make(Stages)

  module Ctrl = interface
    en[5] bubble[5]
  end

  module O_debug = interface
    (o : O)
    (dbg : Stages)
  end

  (* CSRs *)

  (* 3.1.1 *)
  module Mcpuid = struct
    module F = interface
      base[2] z[xlen-28] extensions[26]
    end
    module Fx = Interface_ex.Make(F)

    let base' = function
      | `rv32i -> 0
      | `rv32e -> 1
      | `rv64i -> 2
      | `rv128 -> 3

    let extensions ~base ext = 
      let open HardCaml.Bits.Comb.IntbitsList in
      let idx c = 
        sll (one 26) (Char.code (Char.lowercase c) - Char.code 'a')
      in
      List.fold_left (fun acc c -> acc |: idx c)
        (if (base' base) = 1 then idx 'e' else idx 'i') ext

    let base = base'
  end

  (* 3.1.2 *)
  module Mimpid = struct
    module F = interface
      implementation[xlen-16] vendor[16]
    end
    module Fx = Interface_ex.Make(F)
    (* 1 < vendor <= 0x7fff *)
    let vendor = 0x2307
    (* implementation register describes the system - no given semantics *)
  end

  (* 3.1.4 *)
  module Mhartid = struct
    module F = interface
      hartid[xlen]
    end
    module Fx = Interface_ex.Make(F)
    let hartid = 0x0 (* unless we have a multi-processor system...*)
  end

  (* 3.1.5  .... *)
  module Mstatus = struct
    module F = interface
        sd[1] (* 3.1.8 ... *)
        z[xlen-23] 
        vm[5] (* 3.1.6 virtualization management *)
        mprv[1] (* 3.1.7 memory priviledge *)
        xs[2] fs[2] (* 3.1.8 extension context *)
        prv3[2] ie3[1] (* 3.1.5 priv and global interrupt-enable stack *)
        prv2[2] ie2[1]
        prv1[2] ie1[1]
        prv[2] ie[1]
    end
    module Fx = Interface_ex.Make(F)
    (* XXX ... interrupt bits (and stack) ... check implementation *)

    type ext_ctx = Off | Initial | Clean | Dirty

    let ext_ctx_status_of_code = function
      | 0 -> Off
      | 1 -> Initial
      | 2 -> Clean
      | _ -> Dirty

    let code_of_ext_ctx_status = function
      | Off -> 0
      | Initial -> 1
      | Clean -> 2
      | Dirty -> 3

    type vm = Mbare | Mbb | Mbbid 
            | Sv32 | Sv39 | Sv48 | Sv57 | Sv64
            | Reserved

    let vm_of_code = function
      | 0 -> Mbare 
      | 1 -> Mbb
      | 2 -> Mbbid
      | 8 -> Sv32
      | 9 -> Sv39
      | 10 -> Sv48
      | 11 -> Sv57
      | 12 -> Sv64
      | _ -> Reserved

    let code_of_vm = function
      | Mbare -> 0
      | Mbb -> 1
      | Mbbid -> 2
      | Sv32 -> 8
      | Sv39 -> 9
      | Sv48 -> 10
      | Sv57 -> 11
      | Sv64 -> 12
      | Reserved -> 31
  end

  (* 3.1.9 *)
  module Mtvec = struct
    module F = interface addr[xlen-2] z[2] end
    module Fx = Interface_ex.Make(F)
    module Hi = struct
      let trap = (-1) lsl 9
      let reset = (-1) lsl 8
      let trap_user = trap
      let trap_super = trap + 0x40
      let trap_hyper = trap + 0x80
      let trap_machine = trap + 0xc0
      let nmi = trap + 0xFC
    end
    module Lo = struct
      let trap = 0x200
      let reset = 0x100
      let trap_user = trap
      let trap_super = trap + 0x40
      let trap_hyper = trap + 0x80
      let trap_machine = trap + 0xc0
      let nmi = trap + 0xFC
    end
  end

  (* 3.1.10 *)
  module Mtdeleg = struct
    module F = interface 
        interrupts[xlen-16]
        synchronous_exceptions[16]
    end
    module Fx = Interface_ex.Make(F)
  end

  (* 3.1.11 *)
  module Mip = struct
    module F = interface 
      z0[xlen-8]
      mtip[1] htip[1] stip[1] z1[1]
      msip[1] hsip[1] ssip[1] z2[1]
    end
    module Fx = Interface_ex.Make(F)
  end
  
  module Mie = struct
    module F = interface 
      z0[xlen-8]
      mtie[1] htie[1] stie[1] z1[1]
      msie[1] hsie[1] ssie[1] z2[1]
    end
    module Fx = Interface_ex.Make(F)
  end

  (* 3.1.12 *)
  module Mtime = struct
    module F = interface mtime[xlen] end
    module Fx = Interface_ex.Make(F)
  end
  module Mtimecmp = struct
    module F = interface z[xlen-32] mtimecmp[32] end
    module Fx = Interface_ex.Make(F)
  end

  (* 3.1.13 *)
  module Mscratch = struct
    module F = interface mscratch[xlen] end
    module Fx = Interface_ex.Make(F)
  end

  (* 3.1.14 *)
  module Mepc = struct
    module F = interface mepc[xlen] end
    module Fx = Interface_ex.Make(F)
    (* lsb always zero *)
  end

  (* 3.1.15 *)
  module Mcause = struct
    module F = interface 
      interrupt[1]
      z[xlen-5]
      cause[4]
    end
    module Fx = Interface_ex.Make(F)

    type exception_code = 
      | Instruction_address_misaligned
      | Instruction_access_fault
      | Illegal_instruction
      | Breakpoint
      | Load_address_misaligned
      | Load_access_fault
      | Store_AMO_address_misaligned
      | Store_AMO_access_fault
      | Environment_call_from_U_mode
      | Environment_call_from_S_mode
      | Environment_call_from_H_mode
      | Environment_call_from_M_mode
      | EReserved
    
    let exception_of_code = function
      | 0 -> Instruction_address_misaligned
      | 1 -> Instruction_access_fault
      | 2 -> Illegal_instruction
      | 3 -> Breakpoint
      | 4 -> Load_address_misaligned
      | 5 -> Load_access_fault
      | 6 -> Store_AMO_address_misaligned
      | 7 -> Store_AMO_access_fault
      | 8 -> Environment_call_from_U_mode
      | 9 -> Environment_call_from_S_mode
      | 10 -> Environment_call_from_H_mode
      | 11 -> Environment_call_from_M_mode
      | _ -> EReserved
    
    let code_of_exception = function
      | Instruction_address_misaligned -> 0
      | Instruction_access_fault -> 1
      | Illegal_instruction -> 2
      | Breakpoint -> 3
      | Load_address_misaligned -> 4
      | Load_access_fault -> 5
      | Store_AMO_address_misaligned -> 6
      | Store_AMO_access_fault -> 7
      | Environment_call_from_U_mode -> 8
      | Environment_call_from_S_mode -> 9
      | Environment_call_from_H_mode -> 10
      | Environment_call_from_M_mode -> 11
      | EReserved -> 12

    type interrupt_code =
      | Software
      | Timer
      | IReserved
    
    let interrupt_of_code = function
      | 0 -> Software
      | 1 -> Timer
      | _ -> IReserved

    let code_of_interrupt = function
      | Software -> 0
      | Timer -> 1
      | IReserved -> 2
  end

  module Mbadaddr = struct 
    module F = interface mbadaddr[xlen] end
    module Fx = Interface_ex.Make(F)
  end

  (* generic xlen bits wide register *)
  module Xlen = struct
    module F = interface data[xlen] end
    module Fx = Interface_ex.Make(F)
  end

  module Csr_regs = interface

    (cycle : Xlen.F)
    (time : Xlen.F)
    (instret : Xlen.F)
    (cycleh : Xlen.F)
    (timeh : Xlen.F)
    (instreth : Xlen.F)

    (mcpuid : Mcpuid.F)
    (mimpid : Mimpid.F)
    (mhartid : Mhartid.F)

    (mstatus : Mstatus.F)
    (mtvec : Mtvec.F)
    (mtdeleg : Mtdeleg.F)
    (mie : Mie.F)
    (mtimecmp : Mtimecmp.F)

    (mtime : Mtime.F)
    (mtimeh : Mtime.F)

    (mscratch : Mscratch.F)
    (mepc : Mepc.F)
    (mcause : Mcause.F)
    (mbadaddr : Mbadaddr.F)
    (mip : Mip.F)

    (mbase : Xlen.F) (* XXX max addr? *)
    (mbound : Xlen.F) 
    (mibase : Xlen.F) 
    (mibound : Xlen.F) 
    (mdbase : Xlen.F) 
    (mdbound : Xlen.F) 

  end

  module Csr_regs_ex = Interface_ex.Make(Csr_regs)

end

