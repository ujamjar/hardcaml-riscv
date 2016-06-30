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

module Make(C : Config.S) : S

