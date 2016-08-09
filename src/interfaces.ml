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

  (* 3.1.11 *)
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
  module Isa = struct
    module F = interface
      base[2] 
      z[xlen-28] (* WIRI *)
      extensions[26]
    end
    module Fx = Interface_ex.Make(F)

    let base' = function
      | `rv32  -> 1
      | `rv32e -> 1
      | `rv64  -> 2
      | `rv128 -> 3

    let extensions ~base ext = 
      let open HardCaml.Bits.Comb.IntbitsList in
      let idx c = 
        sll (one 26) (Char.code (Char.lowercase c) - Char.code 'a')
      in
      List.fold_left (fun acc c -> acc |: idx c)
        (if base = `rv32e then idx 'e' else idx 'i') ext

    let base = base'
  end

  (* 3.1.5  .... *)
  module Status = struct
    module F = interface
        sd[1] (* 3.1.8 ... *)
        z0[xlen-30] (* WPRI *)
        vm[5] (* WARL *)
        z1[4] (* WPRI *)
        mxr[1]
        pum[1]
        mprv[1]
        xs[2]
        fs[2]
        mpp[2] (* prior priviledge mode *)
        hpp[2]
        spp[1]
        mpie[1] (* prior interrupt enable *)
        hpie[1]
        spie[1]
        upie[1]
        mie[1] (* interrupt enable *)
        hie[1]
        sie[1]
        uie[1]
    end
    module Fx = Interface_ex.Make(F)

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
  module Tvec = struct
    module F = interface addr[xlen-2] z[2] end
    module Fx = Interface_ex.Make(F)
  end

  (* 3.1.11 *)
  module Ip = struct
    module F = interface 
      z[xlen-12]
      meip[1] heip[1] seip[1] ueip[1]
      mtip[1] htip[1] stip[1] utip[1]
      msip[1] hsip[1] ssip[1] usip[1]
    end
    module Fx = Interface_ex.Make(F)
  end
  
  module Ie = struct
    module F = interface 
      z[xlen-12]
      meie[1] heie[1] seie[1] ueie[1]
      mtie[1] htie[1] stie[1] utie[1]
      msie[1] hsie[1] ssie[1] usie[1]
    end
    module Fx = Interface_ex.Make(F)
  end

  (* 3.1.12 *)
  module Time = struct
    module F = interface mtime[xlen] end
    module Fx = Interface_ex.Make(F)
  end

  (* 3.1.15 *)
  module Cause = struct
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
      | _ -> failwith "exception_of_code"
    
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
    
    let interrupt_of_code = function
      | 0  -> USoftware
      | 1  -> SSoftware
      | 2  -> HSoftware
      | 3  -> MSoftware
      | 4  -> UTimer
      | 5  -> STimer
      | 6  -> HTimer
      | 7  -> MTimer
      | 8  -> UExt
      | 9  -> SExt
      | 10 -> HExt
      | 11 -> MExt
      | _ -> failwith "invalid interrupt_of_code"

    let code_of_interrupt = function
      | USoftware -> 0
      | SSoftware -> 1
      | HSoftware -> 2
      | MSoftware -> 3
      | UTimer -> 4
      | STimer -> 5
      | HTimer -> 6
      | MTimer -> 7
      | UExt -> 8
      | SExt -> 9
      | HExt -> 10
      | MExt -> 11
  end

  (* generic xlen bits wide register *)
  module Xlen = struct
    module F = interface data[xlen] end
    module Fx = Interface_ex.Make(F)
  end

  module Trap = interface
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

  module Counteren = struct
    module F = interface z[xlen-3] ir[1] tm[1] cy[1] end
    module Fx = Interface_ex.Make(F)
  end

  module Ptbr = struct
    module F = interface 
      asid[if xlen=64 then 26 else 10] 
      ppn[if xlen=64 then 38 else 22] 
    end
    module Fx = Interface_ex.Make(F)
  end

  module X64 = interface
    (lo : Xlen.F)
    (hi : Xlen.F)
  end 

  module Timers = interface
    (cycle : X64)
    (time : X64)
    (instret : X64)
  end

  module Machine = interface
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

  module Hypervisor = interface
    (trap : Trap)
    (timers : Timers)
  end

  module Supervisor = interface
    (trap : Trap)
    (timers : Timers)
    (ptbr : Ptbr.F) 
  end

  module User = interface
    (trap : Trap)
    (timers : Timers)
    (fflags : Xlen.F)  (* XXX *)
    (frm : Xlen.F)
    (fcsr : Xlen.F)
  end

  module Csr_regs = interface
    (m : Machine)
    (h : Hypervisor)
    (s : Supervisor)
    (u : User)
  end


  module Csr_regs_ex = Interface_ex.Make(Csr_regs)

end

