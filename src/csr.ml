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

module Make(B : HardCaml.Comb.S)(Ifs : Interfaces.S) = struct

  let xlen = Ifs.xlen

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

  module Regs = interface

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

  module Regs_ex = Interface_ex.Make(Regs)

  type timer_spec = [ `cycle | `time | `instret | `mtime ]
  type csr_ospec = 
    [ `zero | `ones | `const of B.t | `consti of int
    | `counter64 of timer_spec
    | `counter64h of timer_spec
    | `writeable of Config.csr * int * B.t * B.t 
    | `writeable_ext of Config.csr * int * B.t * B.t * B.t * B.t ] 
  type csr_ispec = B.t * B.t

  let csr_spec i = 
    let module X = Xlen.F in
    let open B in
    let instr_set = if xlen=32 then `rv32i else `rv64i in
    let zero' _ = `zero in
    let writeable ~csr ~ofs ~cv ~e = `writeable(csr,ofs,cv,e) in
    let writeable_ext ~csr ~ofs ~cv ~e i = 
      let ext_we, ext_data = i in
      `writeable_ext(csr,ofs,cv,e,ext_we,ext_data) 
    in

    let ofs = Regs_ex.(map (fun x -> x mod 32) (offsets ~rev:false ())) in

    let regs = 
      { 
        Regs.cycle  = { X.data = `counter64 `cycle };
        time        = { X.data = `counter64 `time };
        instret     = { X.data = `counter64 `instret };
        Regs.cycleh = { X.data = `counter64h `cycle }; 
        timeh       = { X.data = `counter64h `time };
        instreth    = { X.data = `counter64h `instret };

        mcpuid      = 
          { Mcpuid.F.(map zero' t) with
              Mcpuid.F.base = `consti (Mcpuid.base instr_set);
              extensions    = `const (Mcpuid.extensions ~base:instr_set ['U']); };
        mimpid      = { Mimpid.F.(map zero' t) with Mimpid.F.vendor = `consti(Mimpid.vendor) };
        mhartid     = { Mhartid.F.hartid = `zero };

        mstatus     = 
          { Mstatus.F.(map zero' t) with
              Mstatus.F.sd = `zero;
              vm           = `zero; (* Mbare *)
              mprv         = `zero;
              xs           = `zero;
              fs           = `zero;
              prv3         = `ones; (* XXX TODO; priv stack, interrupt support *)
              ie3          = `zero;
              prv2         = `ones;
              ie2          = `zero;
              prv1         = `ones;
              ie1          = `zero;
              prv          = `ones;
              ie           = `zero;
          };
        mtvec       = { Mtvec.F.(map zero' t) with Mtvec.F.addr = `consti (Mtvec.Lo.trap/4) };
        mtdeleg     = Mtdeleg.F.(map zero' t);
        mie         = Mie.F.(map zero' t);
        mtimecmp    = { Mtimecmp.F.(map zero' t) with 
                          Mtimecmp.F.mtimecmp = writeable ~csr:`mtimecmp ~ofs:0 
                                                          ~cv:(zero 32) ~e:vdd };
        mtime       = { Mtime.F.mtime = `counter64 `mtime };
        mtimeh      = { Mtime.F.mtime = `counter64h `mtime };
        mscratch    = { Mscratch.F.mscratch = writeable ~csr:`mscratch ~ofs:0 
                                                        ~cv:(zero xlen) ~e:vdd };
        mepc        = { Mepc.F.mepc = writeable_ext ~csr:`mepc ~ofs:0 ~cv:(zero xlen) ~e:vdd
                                                    i.Regs.mepc.Mepc.F.mepc };
        mcause      = 
          { Mcause.F.(map zero' t) with 
            Mcause.F.interrupt = writeable_ext ~csr:`mcause ~cv:gnd ~e:vdd
                                  ~ofs:ofs.Regs.mcause.Mcause.F.interrupt
                                  i.Regs.mcause.Mcause.F.interrupt;
            cause              = writeable_ext ~csr:`mcause ~cv:(zero 4) ~e:vdd
                                  ~ofs:ofs.Regs.mcause.Mcause.F.cause
                                  i.Regs.mcause.Mcause.F.cause;
                                   
          };

        mbadaddr    = { Mbadaddr.F.mbadaddr = 
                          writeable_ext ~csr:`mbadaddr ~ofs:0 ~cv:(zero xlen) ~e:vdd
                            i.Regs.mbadaddr.Mbadaddr.F.mbadaddr };
        mip         = Mip.F.(map zero' t);

        mbase       = { Xlen.F.data = writeable ~csr:`mbase ~ofs:0 ~cv:(zero xlen) ~e:vdd };
        mbound      = { Xlen.F.data = writeable ~csr:`mbound ~ofs:0 ~cv:(zero xlen) ~e:vdd };
        mibase      = { Xlen.F.data = writeable ~csr:`mbase ~ofs:0 ~cv:(zero xlen) ~e:vdd };
        mibound     = { Xlen.F.data = writeable ~csr:`mbound ~ofs:0 ~cv:(zero xlen) ~e:vdd };
        mdbase      = { Xlen.F.data = writeable ~csr:`mbase ~ofs:0 ~cv:(zero xlen) ~e:vdd };
        mdbound     = { Xlen.F.data = writeable ~csr:`mbound ~ofs:0 ~cv:(zero xlen) ~e:vdd };

      }
    in
    regs

  let csr_read_mux dec regs csrs = 
    let rec read csr = 
      let to_vec csr l = 
        let csr_name = 
          try 
            let str = Config.Show_csr.show csr in
            String.sub str 1 (String.length str - 1)
          with _ -> "XXX"
        in
        let check w = 
          if w <> xlen then begin
            failwith (Printf.sprintf "CSR bad width %s[%i]" csr_name w)
          end
        in
        let x = B.concat_e l in
        check (B.width x);
        B.(x -- ("csr_" ^ csr_name))
      in
      match csr with
      | `cycle    -> to_vec csr @@ Xlen.F.to_list @@ regs.Regs.cycle
      | `time     -> to_vec csr @@ Xlen.F.to_list @@ regs.Regs.time
      | `instret  -> to_vec csr @@ Xlen.F.to_list @@ regs.Regs.instret
      | `cycleh   -> to_vec csr @@ Xlen.F.to_list @@ regs.Regs.cycleh
      | `timeh    -> to_vec csr @@ Xlen.F.to_list @@ regs.Regs.timeh
      | `instreth -> to_vec csr @@ Xlen.F.to_list @@ regs.Regs.instreth

      | `mcpuid   -> to_vec csr @@ Mcpuid.F.to_list @@ regs.Regs.mcpuid
      | `mimpid   -> to_vec csr @@ Mimpid.F.to_list @@ regs.Regs.mimpid
      | `mhartid  -> to_vec csr @@ Mhartid.F.to_list @@ regs.Regs.mhartid

      | `mstatus  -> to_vec csr @@ Mstatus.F.to_list @@ regs.Regs.mstatus
      | `mtvec    -> to_vec csr @@ Mtvec.F.to_list @@ regs.Regs.mtvec
      | `mtdeleg  -> to_vec csr @@ Mtdeleg.F.to_list @@ regs.Regs.mtdeleg
      | `mie      -> to_vec csr @@ Mie.F.to_list @@ regs.Regs.mie
      | `mtimecmp -> to_vec csr @@ Mtimecmp.F.to_list @@ regs.Regs.mtimecmp

      | `mtime    -> to_vec csr @@ Mtime.F.to_list @@ regs.Regs.mtime
      | `mtimeh   -> to_vec csr @@ Mtime.F.to_list @@ regs.Regs.mtimeh

      | `mscratch -> to_vec csr @@ Mscratch.F.to_list @@ regs.Regs.mscratch
      | `mepc     -> to_vec csr @@ Mepc.F.to_list @@ regs.Regs.mepc
      | `mcause   -> to_vec csr @@ Mcause.F.to_list @@ regs.Regs.mcause
      | `mbadaddr -> to_vec csr @@ Mbadaddr.F.to_list @@ regs.Regs.mbadaddr
      | `mip      -> to_vec csr @@ Mip.F.to_list @@ regs.Regs.mip

      | `mbase    -> to_vec csr @@ Xlen.F.to_list @@ regs.Regs.mbase
      | `mbound   -> to_vec csr @@ Xlen.F.to_list @@ regs.Regs.mbound
      | `mibase   -> to_vec csr @@ Xlen.F.to_list @@ regs.Regs.mibase
      | `mibound  -> to_vec csr @@ Xlen.F.to_list @@ regs.Regs.mibound
      | `mdbase   -> to_vec csr @@ Xlen.F.to_list @@ regs.Regs.mdbase
      | `mdbound  -> to_vec csr @@ Xlen.F.to_list @@ regs.Regs.mdbound

      | _ -> failwith "unsupported CSR"
    in
    let read_csrs = List.mapi 
      (fun i x -> B.(dec.[i:i]), read x) 
      csrs
    in
    B.(pmux read_csrs (B.zero xlen) -- "csr_rdata")

end

module Build(Ifs : Interfaces.S) = struct

  module B = HardCaml.Signal.Comb
  module Machine = Make(B)(Ifs)

  let xlen = Ifs.xlen

  let csr_index csr = 
    let rec find idx = function 
      | [] -> -1 
      | x::t when x=csr -> idx 
      | _::t -> find (idx+1) t 
    in
    find 0 Ifs.csrs 

  (* all the logic for csrs goes here *)
  let make ~clk ~clr ~csr_ctrl ~ext ~wdata = 
    let module Seq = Utils.Regs(struct let clk=clk let clr=clr end) in
    let open HardCaml.Signal.Comb in
    let open Machine in
    let module X = Xlen.F in
 
    let spec = Machine.csr_spec ext in

    (* set, clear or write bits to a register *)
    let csr_reg ~cv ~e ~clr ~set ~write ~data ~f = 
      Seq.reg_fb ~e:(e &: (clr |: set |: write)) ~cv ~w:(width cv) 
        (fun dprev ->
          pmux [
            clr, (dprev &: (~: data));
            set, (dprev |: data);
            write, data;
          ] (f dprev))
    in

    (* R/W csr register *)
    let writeable_fb ~csr ~ofs ~cv ~e ~f =
      let open Ifs.Csr_ctrl in
      let csr_index = csr_index csr in
      if csr_index = -1 then cv
      else
        csr_reg ~cv 
          ~e:(e &: csr_ctrl.csr_dec.[csr_index:csr_index])
          ~clr:csr_ctrl.csr_clr
          ~set:csr_ctrl.csr_set
          ~write:csr_ctrl.csr_write
          ~data:(wdata.[(width cv)+ofs-1:ofs]) (* XXX ... from pipeline *)
          ~f
    in
    let writeable = writeable_fb ~f:(fun x -> x) in

    (* R/W csr register that can also be set externally.
     * XXX which should get priority??? *)
    let writeable_ext ~ext_we ~ext_data = writeable_fb ~f:(fun x -> mux2 ext_we ext_data x) in

    (* split 32/32 counter *)
    let counter64 =
      if xlen = 64 then
        writeable_fb ~csr:`mtime ~ofs:0 ~cv:(zero 64) ~e:vdd ~f:(fun d -> d +:. 1)
      else
        let open Ifs.Csr_ctrl in
        let csr_index0 = csr_index `mtime in
        let csr_index1 = csr_index `mtimeh in
        if csr_index0 = (-1) || csr_index1 = (-1) then (zero 64)
        else
          let w = wire 64 in
          let reg ~cv ~e ~clr ~set ~write ~data ~w = 
            Seq.reg_fb ~e:e ~cv ~w:(width cv) 
              (fun dprev ->
                pmux [
                  clr, (dprev &: (~: data));
                  set, (dprev |: data);
                  write, data;
                ] w)
          in
          let rlo = 
            let wr = csr_ctrl.csr_dec.[csr_index0:csr_index0] in
            reg
              ~cv:(zero 32)
              ~e:vdd
              ~clr:(wr &: csr_ctrl.csr_clr)
              ~set:(wr &: csr_ctrl.csr_set)
              ~write:((wr &: csr_ctrl.csr_write) -- "csr_counter_write0")
              ~data:wdata
              ~w:w.[31:0]
          in
          let rhi = 
            let wr = csr_ctrl.csr_dec.[csr_index1:csr_index1] in
            reg
              ~cv:(zero 32)
              ~e:vdd
              ~clr:(wr &: csr_ctrl.csr_clr)
              ~set:(wr &: csr_ctrl.csr_set)
              ~write:((wr &: csr_ctrl.csr_write) -- "csr_counter_write1")
              ~data:wdata
              ~w:w.[63:32]
          in
          let q = rhi @: rlo in
          let () = w <== q +:. 1 in
          q
    in
 
    let regs = 
      Machine.Regs.(map2 
        (fun (n,b) r ->
          let open B in
          match r with
          | `zero -> zero b
          | `ones -> ones b
          | `consti x -> consti b x
          | `const x -> x
          | `counter64 _ -> counter64.[xlen-1:0]
          | `counter64h _ -> if xlen=32 then counter64.[63:32] else zero 64
          | `writeable(csr, ofs, cv, e) -> writeable ~csr ~ofs ~cv ~e
          | `writeable_ext(csr, ofs, cv, e, ext_we, ext_data) -> 
            writeable_ext ~csr ~ofs ~cv ~e ~ext_we ~ext_data)
        t spec)
    in
    regs, Machine.csr_read_mux csr_ctrl.Ifs.Csr_ctrl.csr_dec regs Ifs.csrs
  
end

