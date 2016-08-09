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

  module Isa : sig
    module F : interface base z extensions end
    module Fx : module type of Interface_ex.Make(F)
    val base : [ `rv32 | `rv32e | `rv64 | `rv128 ] -> int
    val extensions : base:[ `rv32 | `rv32e | `rv64 | `rv128 ] -> char list -> 
      HardCaml.Bits.Comb.IntbitsList.t
  end

  module Status : sig
    module F : interface 
        sd z0 vm z1 
        mxr pum mprv
        xs fs
        mpp hpp spp
        mpie hpie spie upie
        mie hie sie uie
    end
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

  module Tvec : sig
    module F : interface addr z end
    module Fx : module type of Interface_ex.Make(F)
  end

  module Ip : sig
    module F : interface 
      z
      meip heip seip ueip
      mtip htip stip utip
      msip hsip ssip usip
    end
    module Fx : module type of Interface_ex.Make(F)
  end
  
  module Ie : sig
    module F : interface 
      z
      meie heie seie ueie
      mtie htie stie utie
      msie hsie ssie usie
    end
    module Fx : module type of Interface_ex.Make(F)
  end

  module Cause : sig
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
    
    val exception_of_code : int -> exception_code
    
    val code_of_exception : exception_code -> int

    type interrupt_code =
      | USoftware
      | SSoftware
      | HSoftware
      | MSoftware
      | UTimer
      | STimer
      | HTimer
      | MTimer
      | UExt
      | SExt
      | HExt
      | MExt
    
    val interrupt_of_code : int -> interrupt_code
    val code_of_interrupt : interrupt_code -> int

  end

  module Xlen : sig
    module F : interface data end
    module Fx : module type of Interface_ex.Make(F)
  end

  module Trap : interface
    (* setup *)
    (status : Status.F)
    (edeleg : Xlen.F)
    (ideleg : Xlen.F)
    (ie : Ie.F)
    (tvec : Tvec.F)
    (* handling *)
    (scratch : Xlen.F)
    (epc : Xlen.F)
    (cause : Cause.F)
    (badaddr : Xlen.F)
    (ip : Ip.F)
  end

  module Counteren : sig
    module F : interface z ir tm cy end
    module Fx : module type of Interface_ex.Make(F)
  end

  module Ptbr : sig
    module F : interface asid ppn end
    module Fx : module type of Interface_ex.Make(F)
  end

  module X64 : interface
    (lo : Xlen.F)
    (hi : Xlen.F)
  end 

  module Timers : interface
    (cycle : X64)
    (time : X64)
    (instret : X64)
  end

  module Machine : interface
    (isa : Isa.F)
    (vendorid : Xlen.F)
    (archid : Xlen.F)
    (impid : Xlen.F)
    (hartid : Xlen.F)

    (trap : Trap)

    (timers : Timers)

    (base : Xlen.F) (* XXX max addr? *)
    (bound : Xlen.F) 
    (ibase : Xlen.F) 
    (ibound : Xlen.F) 
    (dbase : Xlen.F) 
    (dbound : Xlen.F) 

    (ucounteren : Counteren.F)
    (scounteren : Counteren.F)
    (hcounteren : Counteren.F)

    (udelta : Timers)
    (sdelta : Timers)
    (hdelta : Timers)
  end

  module Hypervisor : interface
    (trap : Trap)
    (timers : Timers)
  end

  module Supervisor : interface
    (trap : Trap)
    (timers : Timers)
    (ptbr : Ptbr.F) 
  end

  module User : interface
    (trap : Trap)
    (timers : Timers)
    (fflags : Xlen.F)  (* XXX *)
    (frm : Xlen.F)
    (fcsr : Xlen.F)
  end

  module Csr_regs : interface
    (m : Machine)
    (h : Hypervisor)
    (s : Supervisor)
    (u : User)
  end

  module Csr_regs_ex : module type of Interface_ex.Make(Csr_regs)

end

module Make(C : Config.S) : S

