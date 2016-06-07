(** Control and Status registers *)

(* register specs *)
module Specs = struct

  type level_rw = URW|URO|SRW|SRO|HRW|HRO|MRW|MRO

  type csr = 
    {
      addr : int;
      priv : level_rw;
      tag : Config.csr;
      name : string;
      desc : string;
    }

  let mk addr priv tag name desc = { addr; priv; tag; name; desc }

  (* User level CSRs - table 2.2 *)

  (* Floating point *)
  let fflags = mk 0x001 URW `fflags "fflags" "Floating-Point Accrued Exceptions."
  let frm = mk 0x002 URW `frm "frm" "Floating-Point Dynamic Rounding Mode."
  let fcsr = mk 0x003 URW `fcsr "fcsr" "Floating-Point Control and Status Register (frm + fflags)."

  (* User counters/times *)
  let cycle = mk 0xC00 URO `cycle "cycle" "Cycle counter for RDCYCLE instruction."
  let time = mk 0xC01 URO `time "time" "Timer for RDTIME instruction."
  let instret = mk 0xC02 URO `instret "instret" "Instructions-retired counter for RDINSTRET instruction."
  let cycleh = mk 0xC80 URO `cycleh "cycleh" "Upper 32 bits of cycle, RV32I only."
  let timeh = mk 0xC81 URO `timeh "timeh" "Upper 32 bits of time, RV32I only."
  let instreth = mk 0xC82 URO `instreth "instreth" "Upper 32 bits of instret, RV32I only."

  (* Supervisor level CSRs - table 2.3 *)

  (* Supervisor Trap Setup*)
  let sstatus = mk 0x100 SRW `sstatus "sstatus" "Supervisor status register."
  let stvec = mk 0x101 SRW `stvec "stvec" "Supervisor trap handler base address."
  let sie = mk 0x104 SRW `sie "sie" "Supervisor interrupt-enable register."
  let stimecmp = mk 0x121 SRW `stimecmp "stimecmp" "Wall-clock timer compare value."

  (* Supervisor Timer *)
  let stime = mk 0xD01 SRO `stime "stime" "Supervisor wall-clock time register."
  let stimeh = mk 0xD81 SRO `stimeh "stimeh" "Upper 32 bits of stime, RV32I only."

  (* Supervisor Trap Handling *)
  let sscratch = mk 0x140 SRW `sscratch "sscratch" "Scratch register for supervisor trap handlers."
  let sepc = mk 0x141 SRW `sepc "sepc" "Supervisor exception program counter."
  let scause = mk 0xD42 SRO `scause "scause" "Supervisor trap cause."
  let sbadaddr = mk 0xD43 SRO `sbadaddr "sbadaddr" "Supervisor bad address."
  let sip = mk 0x144 SRW `sip "sip" "Supervisor interrupt pending."

  (* Supervisor Protection and Translation *)
  let sptbr = mk 0x180 SRW `sptbr "sptbr" "Page-table base register."
  let sasid = mk 0x181 SRW `sasid "sasid" "Address-space ID."

  (* Supervisor Read/Write Shadow of User Read-Only registers *)
  let cyclew = mk 0x900 SRW `cyclew "cyclew" "Cycle counter for RDCYCLE instruction."
  let timew = mk 0x901 SRW `timew "timew" "Timer for RDTIME instruction."
  let instretw = mk 0x902 SRW `instretw "instretw" "Instructions-retired counter for RDINSTRET instruction."
  let cyclehw = mk 0x980 SRW `cyclehw "cyclehw" "Upper 32 bits of cycle, RV32I only."
  let timehw = mk 0x981 SRW `timehw "timehw" "Upper 32 bits of time, RV32I only."
  let instrethw = mk 0x982 SRW `instrethw "instrethw" "Upper 32 bits of instret, RV32I only."

  (* Hypervisor level CSRs - table 2.4 *)

  (* Hypervisor Trap Setup *)
  let hstatus = mk 0x200 HRW `hstatus "hstatus" "Hypervisor status register."
  let htvec = mk 0x201 HRW `htvec "htvec" "Hypervisor trap handler base address."
  let htdeleg = mk 0x202 HRW `htdeleg "htdeleg" "Hypervisor trap delegation register."
  let htimecmp = mk 0x221 HRW `htimecmp "htimecmp" "Hypervisor wall-clock timer compare value."

  (* Hypervisor Timer *)
  let htime = mk 0xE01 HRO `htime "htime" "Hypervisor wall-clock time register."
  let htimeh = mk 0xE81 HRO `htimeh "htimeh" "Upper 32 bits of htime, RV32I only."

  (* Hypervisor Trap Handling *)
  let hscratch = mk 0x240 HRW `hscratch "hscratch" "Scratch register for hypervisor trap handlers."
  let hepc = mk 0x241 HRW `hepc "hepc" "Hypervisor exception program counter."
  let hcause = mk 0x242 HRW `hcause "hcause" "Hypervisor trap cause."
  let hbadaddr = mk 0x243 HRW `hbadaddr "hbadaddr" "Hypervisor bad address."

  (* Hypervisor Protection and Translation *)
  (*0x28X TBD "TBD" "TBD."*)

  (* Hypervisor Read/Write Shadow of Supervisor Read-Only Registers *)
  let stimew = mk 0xA01 HRW `stimew "stimew" "Supervisor wall-clock timer."
  let stimehw = mk 0xA81 HRW `stimehw "stimehw" "Upper 32 bits of supervisor wall-clock timer, RV32I only."

  (* Machine level CSRs - table `. 2.4 *)

  (* Machine Information Registers *)
  let mcpuid = mk 0xF00 MRO `mcpuid "mcpuid" "CPU description."
  let mimpid = mk 0xF01 MRO `mimpid "mimpid" "Vendor ID and version number."
  let mhartid = mk 0xF10 MRO `mhartid "mhartid" "Hardware thread ID."

  (* Machine Trap Setup *)
  let mstatus = mk 0x300 MRW `mstatus "mstatus" "Machine status register."
  let mtvec = mk 0x301 MRW `mtvec "mtvec" "Machine trap-handler base address."
  let mtdeleg = mk 0x302 MRW `mtdeleg "mtdeleg" "Machine trap delegation register."
  let mie = mk 0x304 MRW `mie "mie" "Machine interrupt-enable register."
  let mtimecmp = mk 0x321 MRW `mtimecmp "mtimecmp" "Machine wall-clock timer compare value."

  (* Machine Timers and Counters *)
  let mtime = mk 0x701 MRW `mtime "mtime" "Machine wall-clock time."
  let mtimeh = mk 0x741 MRW `mtimeh "mtimeh" "Upper 32 bits of mtime, RV32I only."

  (* Machine Trap Handling *)
  let mscratch = mk 0x340 MRW `mscratch "mscratch" "Scratch register for machine trap handlers."
  let mepc = mk 0x341 MRW `mepc "mepc" "Machine exception program counter."
  let mcause = mk 0x342 MRW `mcause "mcause" "Machine trap cause."
  let mbadaddr = mk 0x343 MRW `mbadaddr "mbadaddr" "Machine bad address."
  let mip = mk 0x344 MRW `mip "mip" "Machine interrupt pending."

  (* Machine Protection and Translation *)
  let mbase = mk 0x380 MRW `mbase "mbase" "Base register."
  let mbound = mk 0x381 MRW `mbound "mbound" "Bound register."
  let mibase = mk 0x382 MRW `mibase "mibase" "Instruction base register."
  let mibound = mk 0x383 MRW `mibound "mibound" "Instruction bound register."
  let mdbase = mk 0x384 MRW `mdbase "mdbase" "Data base register."
  let mdbound = mk 0x385 MRW `mdbound "mdbound" "Data bound register."

  (* Machine Read-Write Shadow of Hypervisor Read-Only Registers *)
  let htimew = mk 0xB01 MRW `htimew "htimew" "Hypervisor wall-clock timer."
  let htimehw = mk 0xB81 MRW `htimehw "htimehw" "Upper 32 bits of hypervisor wall-clock timer, RV32I only."

  (* Machine Host-Target Interface `Non (Non-Standard Berkeley Extension) *)
  let mtohost = mk 0x780 MRW `mtohost "mtohost" "Output register to host."
  let mfromhost = mk 0x781 MRW `mfromhost "mfromhost" "Input register from host."

  let all_csrs = List.map (fun x -> x.tag, x)
    [
      fflags;
      frm;
      fcsr;
      cycle;
      time;
      instret;
      cycleh;
      timeh;
      instreth;
      sstatus;
      stvec;
      sie;
      stimecmp;
      stime;
      stimeh;
      sscratch;
      sepc;
      scause;
      sbadaddr;
      sip;
      sptbr;
      sasid;
      cyclew;
      timew;
      instretw;
      cyclehw;
      timehw;
      instrethw;
      hstatus;
      htvec;
      htdeleg;
      htimecmp;
      htime;
      htimeh;
      hscratch;
      hepc;
      hcause;
      hbadaddr;
      stimew;
      stimehw;
      mcpuid;
      mimpid;
      mhartid;
      mstatus;
      mtvec;
      mtdeleg;
      mie;
      mtimecmp;
      mtime;
      mtimeh;
      mscratch;
      mepc;
      mcause;
      mbadaddr;
      mip;
      mbase;
      mbound;
      mibase;
      mibound;
      mdbase;
      mdbound;
      htimew;
      htimehw;
      mtohost;
      mfromhost;
    ]

end

module Machine(B : HardCaml.Comb.S) = struct

  let xlen = 32

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
      B.constibl @@
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
        interrupts[xlen-32]
        synchronous_exceptions[16]
    end
    module Fx = Interface_ex.Make(F)
  end

  (* 3.1.11 *)
  module Mip = struct
    module F = interface 
      z0[xlen-8]
      mtip[1] htip[1] stip[1] z1[0]
      msip[1] hsip[1] ssip[1] z2[0]
    end
    module Fx = Interface_ex.Make(F)
  end
  
  module Mie = struct
    module F = interface 
      z0[xlen-8]
      mtie[1] htie[1] stie[1] z1[0]
      msie[1] hsie[1] ssie[1] z2[0]
    end
    module Fx = Interface_ex.Make(F)
  end

  (* 3.1.12 *)
  module Mtime = struct
    module F = interface addr[xlen] end
    module Fx = Interface_ex.Make(F)
  end
  module Mtimecmp = struct
    module F = interface z[xlen-32] mtimecmp[32] end
    module Fx = Interface_ex.Make(F)
  end

  (* 3.1.13 *)
  module Mscratch = struct
    module F = interface mtimecmp[xlen] end
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

end


