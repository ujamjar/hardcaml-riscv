module Specs : sig

  type level_rw = URW|URO|SRW|SRO|HRW|HRO|MRW|MRO

  type csr = 
    {
      addr : int;
      priv : level_rw;
      tag : Config.csr;
      name : string;
      desc : string;
    }

  val fflags : csr
  val frm : csr
  val fcsr : csr
  val cycle : csr
  val time : csr
  val instret : csr
  val cycleh : csr
  val timeh : csr
  val instreth : csr
  val sstatus : csr
  val stvec : csr
  val sie : csr
  val stimecmp : csr
  val stime : csr
  val stimeh : csr
  val sscratch : csr
  val sepc : csr
  val scause : csr
  val sbadaddr : csr
  val sip : csr
  val sptbr : csr
  val sasid : csr
  val cyclew : csr
  val timew : csr
  val instretw : csr
  val cyclehw : csr
  val timehw : csr
  val instrethw : csr
  val hstatus : csr
  val htvec : csr
  val htdeleg : csr
  val htimecmp : csr
  val htime : csr
  val htimeh : csr
  val hscratch : csr
  val hepc : csr
  val hcause : csr
  val hbadaddr : csr
  val stimew : csr
  val stimehw : csr
  val mcpuid : csr
  val mimpid : csr
  val mhartid : csr
  val mstatus : csr
  val mtvec : csr
  val mtdeleg : csr
  val mie : csr
  val mtimecmp : csr
  val mtime : csr
  val mtimeh : csr
  val mscratch : csr
  val mepc : csr
  val mcause : csr
  val mbadaddr : csr
  val mip : csr
  val mbase : csr
  val mbound : csr
  val mibase : csr
  val mibound : csr
  val mdbase : csr
  val mdbound : csr
  val htimew : csr
  val htimehw : csr
  val mtohost : csr
  val mfromhost : csr

  val all_csrs : (Config.csr * csr) list

end

module Make(B : HardCaml.Comb.S) : sig

  module Mcpuid : sig
    module F : interface base z extensions end
    module Fx : module type of Interface_ex.Make(F)
    val base : [ `rv32i | `rv32e | `rv64i | `rv128 ] -> int
    val extensions : base:[ `rv32i | `rv32e | `rv64i | `rv128 ] -> char list -> B.t
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

  module Regs : interface

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

end

module Machine : module type of Make(HardCaml.Signal.Comb)

