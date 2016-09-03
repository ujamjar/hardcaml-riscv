(** Control and Status registers (1.9) *)

(* table 2.1 address ranges
 
CSR Address           | Hex         | Use and Accessibility
[11:10] [9:8] [7:6]   |             |
----------------------------------------------------------------------
User CSRs             |             |
----------------------------------------------------------------------
00      00    XX      | 0x000-0x0FF | Standard read/write
01      00    XX      | 0x400-0x4FF | Standard read/write
10      00    XX      | 0x800-0x8FF | Non-standard read/write
11      00    00-10   | 0xC00-0xCBF | Standard read-only
11      00    11      | 0xCC0-0xCFF | Non-standard read-only
----------------------------------------------------------------------
Supervisor CSRs       |             |
----------------------------------------------------------------------
00      01    XX      | 0x100-0x1FF | Standard read/write
01      01    00-10   | 0x500-0x5BF | Standard read/write
01      01    11      | 0x5C0-0x5FF | Non-standard read/write
10      01    00-10   | 0x900-0x9BF | Standard read/write shadows
10      01    11      | 0x9C0-0x9FF | Non-standard read/write shadows
11      01    00-10   | 0xD00-0xDBF | Standard read-only
11      01    11      | 0xDC0-0xDFF | Non-standard read-only
----------------------------------------------------------------------
Hypervisor CSRs       |             |
----------------------------------------------------------------------
00      10    XX      | 0x200-0x2FF | Standard read/write
01      10    00-10   | 0x600-0x6BF | Standard read/write
01      10    11      | 0x6C0-0x6FF | Non-standard read/write
10      10    00-10   | 0xA00-0xABF | Standard read/write shadows
10      10    11      | 0xAC0-0xAFF | Non-standard read/write shadows
11      10    00-10   | 0xE00-0xEBF | Standard read-only
11      10    11      | 0xEC0-0xEFF | Non-standard read-only
----------------------------------------------------------------------
Machine CSRs          |             |
----------------------------------------------------------------------
00      11    XX      | 0x300-0x3FF | Standard read/write
01      11    00-10   | 0x700-0x79F | Standard read/write
01      11    10      | 0x7A0-0x7BF | Standard read/write debug CSRs
01      11    11      | 0x7C0-0x7FF | Non-standard read/write
10      11    00-10   | 0xB00-0xBBF | Standard read/write shadows
10      11    11      | 0xBC0-0xBFF | Non-standard read/write shadows
11      11    00-10   | 0xF00-0xFAF | Standard read-only
11      11    11      | 0xFC0-0xFFF | Non-standard read-only
----------------------------------------------------------------------

*)

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

  (* Table 2.2: Currently allocated RISC-V user-level CSR addresses. *)

  (* User Trap Setup *)
  let ustatus = mk 0x000 URW `ustatus "ustatus" "User status register."
  let uie = mk 0x004 URW `uie "uie" "User interrupt-enable register."
  let utvec = mk 0x005 URW `utvec "utvec" "User trap handler base address."

  (* User Trap Handling *)
  let uscratch = mk 0x040 URW `uscratch "uscratch" "Scratch register for user trap handlers."
  let uepc = mk 0x041 URW `uepc "uepc" "User exception program counter."
  let ucause = mk 0x042 URW `ucause "ucause" "User trap cause."
  let ubadaddr = mk 0x043 URW `ubadaddr "ubadaddr" "User bad address."
  let uip = mk 0x044 URW `uip "uip" "User interrupt pending."

  (* User Floating-Point CSRs *)
  let fflags = mk 0x001 URW `fflags "fflags" "Floating-Point Accrued Exceptions."
  let frm = mk 0x002 URW `frm "frm" "Floating-Point Dynamic Rounding Mode."
  let fcsr = mk 0x003 URW `fcsr "fcsr" "Floating-Point Control and Status Register (frm + fflags)."

  (* User Counter/Timers *)
  let cycle = mk 0xC00 URO `cycle "cycle" "Cycle counter for RDCYCLE instruction."
  let time = mk 0xC01 URO `time "time" "Timer for RDTIME instruction."
  let instret = mk 0xC02 URO `instret "instret" "Instructions-retired counter for RDINSTRET instruction."
  let cycleh = mk 0xC80 URO `cycleh "cycleh" "Upper 32 bits of cycle, RV32I only."
  let timeh = mk 0xC81 URO `timeh "timeh" "Upper 32 bits of time, RV32I only."
  let instreth = mk 0xC82 URO `instreth "instreth" "Upper 32 bits of instret, RV32I only."

  (* Table 2.3: Currently allocated RISC-V supervisor-level CSR addresses. *)

  (* Supervisor Trap Setup *)
  let sstatus = mk 0x100 SRW `sstatus "sstatus" "Supervisor status register."
  let sedeleg = mk 0x102 SRW `sedeleg "sedeleg" "Supervisor exception delegation register."
  let sideleg = mk 0x103 SRW `sideleg "sideleg" "Supervisor interrupt delegation register."
  let sie = mk 0x104 SRW `sie "sie" "Supervisor interrupt-enable register."
  let stvec = mk 0x105 SRW `stvec "stvec" "Supervisor trap handler base address."

  (* Supervisor Trap Handling *)
  let sscratch = mk 0x140 SRW `sscratch "sscratch" "Scratch register for supervisor trap handlers."
  let sepc = mk 0x141 SRW `sepc "sepc" "Supervisor exception program counter."
  let scause = mk 0x142 SRW `scause "scause" "Supervisor trap cause."
  let sbadaddr = mk 0x143 SRW `sbadaddr "sbadaddr" "Supervisor bad address."
  let sip = mk 0x144 SRW `sip "sip" "Supervisor interrupt pending."

  (* Supervisor Protection and Translation *)
  let sptbr = mk 0x180 SRW `sptbr "sptbr" "Page-table base register."

  (* Supervisor Counter/Timers *)
  let scycle = mk 0xD00 SRO `scycle "scycle" "Supervisor cycle counter."
  let stime = mk 0xD01 SRO `stime "stime" "Supervisor wall-clock time."
  let sinstret = mk 0xD02 SRO `sinstret "sinstret" "Supervisor instructions-retired counter."
  let scycleh = mk 0xD80 SRO `scycleh "scycleh" "Upper 32 bits of scycle, RV32I only."
  let stimeh = mk 0xD81 SRO `stimeh "stimeh" "Upper 32 bits of stime, RV32I only."
  let sinstreth = mk 0xD82 SRO `sinstreth "sinstreth" "Upper 32 bits of sinstret, RV32I only."

  (* Table 2.4: Currently allocated RISC-V hypervisor-level CSR addresses. *)

  (* Hypervisor Trap Setup *)
  let hstatus = mk 0x200 HRW `hstatus "hstatus" "Hypervisor status register."
  let hedeleg = mk 0x202 HRW `hedeleg "hedeleg" "Hypervisor exception delegation register."
  let hideleg = mk 0x203 HRW `hideleg "hideleg" "Hypervisor interrupt delegation register."
  let hie = mk 0x204 HRW `hie "hie" "Hypervisor interrupt-enable register."
  let htvec = mk 0x205 HRW `htvec "htvec" "Hypervisor trap handler base address."

  (* Hypervisor Trap Handling *)
  let hscratch = mk 0x240 HRW `hscratch "hscratch" "Scratch register for hypervisor trap handlers."
  let hepc = mk 0x241 HRW `hepc "hepc" "Hypervisor exception program counter."
  let hcause = mk 0x242 HRW `hcause "hcause" "Hypervisor trap cause."
  let hbadaddr = mk 0x243 HRW `hbadaddr "hbadaddr" "Hypervisor bad address."

  (* Hypervisor Protection and Translation *)
  (*0x28X TBD TBD TBD.*)

  (* Hypervisor Counter/Timers *)
  let hcycle = mk 0xE00 HRO `hcycle "hcycle" "Hypervisor cycle counter."
  let htime = mk 0xE01 HRO `htime "htime" "Hypervisor wall-clock time."
  let hinstret = mk 0xE02 HRO `hinstret "hinstret" "Hypervisor instructions-retired counter."
  let hcycleh = mk 0xE80 HRO `hcycleh "hcycleh" "Upper 32 bits of hcycle, RV32I only."
  let htimeh = mk 0xE81 HRO `htimeh "htimeh" "Upper 32 bits of htime, RV32I only."
  let hinstreth = mk 0xE82 HRO `hinstreth "hinstreth" "Upper 32 bits of hinstret, RV32I only."

  (* Number Privilege Name Description *)

  (* Machine Information Registers *)
  let misa = mk 0xF10 MRO `misa "misa" "ISA and extensions supported."
  let mvendorid = mk 0xF11 MRO `mvendorid "mvendorid" "Vendor ID."
  let marchid = mk 0xF12 MRO `marchid "marchid" "Architecture ID."
  let mimpid = mk 0xF13 MRO `mimpid "mimpid" "Implementation ID."
  let mhartid = mk 0xF14 MRO `mhartid "mhartid" "Hardware thread ID."

  (* Machine Trap Setup *)
  let mstatus = mk 0x300 MRW `mstatus "mstatus" "Machine status register."
  let medeleg = mk 0x302 MRW `medeleg "medeleg" "Machine exception delegation register."
  let mideleg = mk 0x303 MRW `mideleg "mideleg" "Machine interrupt delegation register."
  let mie = mk 0x304 MRW `mie "mie" "Machine interrupt-enable register."
  let mtvec = mk 0x305 MRW `mtvec "mtvec" "Machine trap-handler base address."

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

  (* Machine Timers and Counters *)
  let mcycle = mk 0xF00 MRO `mcycle "mcycle" "Machine cycle counter."
  let mtime = mk 0xF01 MRO `mtime "mtime" "Machine wall-clock time."
  let minstret = mk 0xF02 MRO `minstret "minstret" "Machine instructions-retired counter."
  let mcycleh = mk 0xF80 MRO `mcycleh "mcycleh" "Upper 32 bits of mcycle, RV32I only."
  let mtimeh = mk 0xF81 MRO `mtimeh "mtimeh" "Upper 32 bits of mtime, RV32I only."
  let minstreth = mk 0xF82 MRO `minstreth "minstreth" "Upper 32 bits of minstret, RV32I only."

  (* Machine Counter Setup *)
  let mucounteren = mk 0x310 MRW `mucounteren "mucounteren" "User-mode counter enable."
  let mscounteren = mk 0x311 MRW `mscounteren "mscounteren" "Supervisor-mode counter enable."
  let mhcounteren = mk 0x312 MRW `mhcounteren "mhcounteren" "Hypervisor-mode counter enable."

  (* Machine Counter-Delta Registers *)
  let mucycle = mk 0x700 MRW `mucycle "mucycle" "delta cycle counter delta."
  let mutime = mk 0x701 MRW `mutime "mutime" "delta time counter delta."
  let muinstret = mk 0x702 MRW `muinstret "muinstret" "delta instret counter delta."
  let mscycle = mk 0x704 MRW `mscycle "mscycle" "delta scycle counter delta."
  let mstime = mk 0x705 MRW `mstime "mstime" "delta stime counter delta."
  let msinstret = mk 0x706 MRW `msinstret "msinstret" "delta sinstret counter delta."
  let mhcycle = mk 0x708 MRW `mhcycle "mhcycle" "delta hcycle counter delta."
  let mhtime = mk 0x709 MRW `mhtime "mhtime" "delta htime counter delta."
  let mhinstret = mk 0x70A MRW `mhinstret "mhinstret" "delta hinstret counter delta."
  let mucycleh = mk 0x780 MRW `mucycleh "mucycleh" "deltah Upper 32 bits of cycle counter delta, RV32I only."
  let mutimeh = mk 0x781 MRW `mutimeh "mutimeh" "deltah Upper 32 bits of time counter delta, RV32I only."
  let muinstreth = mk 0x782 MRW `muinstreth "muinstreth" "deltah Upper 32 bits of instret counter delta, RV32I only."
  let mscycleh = mk 0x784 MRW `mscycleh "mscycleh" "deltah Upper 32 bits of scycle counter delta, RV32I only."
  let mstimeh = mk 0x785 MRW `mstimeh "mstimeh" "deltah Upper 32 bits of stime counter delta, RV32I only."
  let msinstreth = mk 0x786 MRW `msinstreth "msinstreth" "deltah Upper 32 bits of sinstret counter delta, RV32I only."
  let mhcycleh = mk 0x788 MRW `mhcycleh "mhcycleh" "deltah Upper 32 bits of hcycle counter delta, RV32I only."
  let mhtimeh = mk 0x789 MRW `mhtimeh "mhtimeh" "deltah Upper 32 bits of htime counter delta, RV32I only."
  let mhinstreth = mk 0x78A MRW `mhinstreth "mhinstreth" "deltah Upper 32 bits of hinstret counter delta, RV32I only."

  let all_csrs = List.map (fun x -> x.tag, x) 
    [
      ustatus; uie; utvec; uscratch; uepc; ucause; ubadaddr; 
      uip; fflags; frm; fcsr; cycle; time; instret; cycleh; 
      timeh; instreth;

      sstatus; sedeleg; sideleg; sie; stvec; sscratch; sepc;
      scause; sbadaddr; sip; sptbr; scycle; stime; sinstret;
      scycleh; stimeh; sinstreth;

      hstatus; hedeleg; hideleg; hie; htvec; hscratch; hepc;
      hcause; hbadaddr; hcycle; htime; hinstret; hcycleh;
      htimeh; hinstreth;

      misa; mvendorid; marchid; mimpid; mhartid;
      mstatus; medeleg; mideleg; mie; mtvec; mscratch;
      mepc; mcause; mbadaddr; mip; mbase; mbound;
      mibase; mibound; mdbase; mdbound; 
      mcycle; mtime; minstret; 
      mcycleh; mtimeh; minstreth; 
      mucounteren; mscounteren; mhcounteren; 
      mucycle; mutime; muinstret;
      mscycle; mstime; msinstret; 
      mhcycle; mhtime; mhinstret;
      mucycleh; mutimeh; muinstreth; 
      mscycleh; mstimeh; msinstreth; 
      mhcycleh; mhtimeh; mhinstreth;
    ]

end

module Make(B : HardCaml.Comb.S)(Ifs : Interfaces.S) = struct

  open Ifs

  type timer_spec = [ `cycle | `time | `instret | `mtime ]
  type csr_ospec = 
    [ `const of B.t | `consti of int
    | `counter64 of bool * timer_spec
    | `writeable of Config.csr * int * B.t 
    | `writeable_ext of Config.csr * int * B.t * B.t * B.t ] 
  type csr_ispec = B.t * B.t

  let csr_spec i = 
    let open B in
    let instr_set = if xlen=32 then `rv32 else `rv64 in
    let writeable ~csr ~ofs ~cv = `writeable(csr,ofs,cv) in
    let writeable_ext ~csr ~ofs ~cv i = 
      let ext_we, ext_data = i in
      `writeable_ext(csr,ofs,cv,ext_we,ext_data) 
    in
    let writeable_xlen csr = { Xlen.F.data = writeable ~csr ~ofs:0 ~cv:(zero xlen) } in
  
    let counter64 c = 
      Xlen.F.{ X64.hi = { data = `counter64(true, c) }; lo = { data = `counter64(false, c) } }
    in

    let ofs = Csr_regs_ex.(map (fun x -> x mod 32) (offsets ~rev:false ())) in

    let regs = 
      let open Xlen.F in
      let zero = `consti 0 in
      {
        Csr_regs.m = 
          {
            Machine.isa = 
              {
                Isa.F.base = `consti (Isa.base instr_set);
                z = zero;
                extensions = `const (constibl @@ Isa.extensions ~base:instr_set ['U']); 
              };
            vendorid = { data = zero };
            archid = { data = zero };
            impid = { data = zero };
            hartid = { data = zero };
            trap = 
              {
                Trap.status = 
                  {
                    Status.F.sd = zero;
                    z0 = zero;
                    vm = zero;
                    z1 = zero;
                    mxr = zero;
                    pum = zero;
                    mprv = zero;
                    xs = zero;
                    fs= zero;
                    mpp = zero;
                    hpp = zero;
                    spp = zero;
                    mpie = zero;
                    hpie = zero;
                    spie = zero;
                    upie = zero;
                    mie = zero;
                    hie = zero;
                    sie = zero;
                    uie = zero;
                  };
                edeleg  = { data = zero };
                ideleg  = { data = zero };
                ie =
                  {
                    Ie.F.z = zero;
                    meie = zero;
                    heie = zero;
                    seie = zero;
                    ueie = zero;
                    mtie = zero;
                    htie = zero;
                    stie = zero;
                    utie = zero;
                    msie = zero;
                    hsie = zero;
                    ssie = zero;
                    usie = zero;
                  };
                tvec =
                  {
                    Tvec.F.addr = `consti (256/4); (* ??? *)
                    z = zero;
                  };
                scratch  = writeable_xlen `mscratch;
                epc  = 
                  { 
                    data = writeable_ext ~csr:`mepc ~cv:(B.zero xlen) ~ofs:0
                                         i.Csr_regs.m.Machine.trap.Trap.epc.data;
                  };
                cause =
                  {
                    Cause.F.interrupt = 
                      writeable_ext ~csr:`mcause ~cv:gnd 
                                    ~ofs:ofs.Csr_regs.m.Machine.trap.Trap.cause.Cause.F.interrupt
                                    i.Csr_regs.m.Machine.trap.Trap.cause.Cause.F.interrupt;
                    z = zero;
                    cause = 
                      writeable_ext ~csr:`mcause ~cv:(B.zero 4) 
                                    ~ofs:ofs.Csr_regs.m.Machine.trap.Trap.cause.Cause.F.cause
                                    i.Csr_regs.m.Machine.trap.Trap.cause.Cause.F.cause;
                  };
                badaddr  = 
                  { 
                    data = writeable_ext ~csr:`mbadaddr ~cv:(B.zero xlen) ~ofs:0
                                         i.Csr_regs.m.Machine.trap.Trap.badaddr.data;
                  };
                ip = 
                  {
                    Ip.F.z = zero;
                    meip = zero; 
                    heip = zero; 
                    seip = zero; 
                    ueip = zero;
                    mtip = zero; 
                    htip = zero; 
                    stip = zero; 
                    utip = zero;
                    msip = zero; 
                    hsip = zero; 
                    ssip = zero; 
                    usip = zero;
                  };
              };
            timers = 
              {
                Timers.cycle = { X64.hi = { data = zero }; lo = { data = zero } };
                time = { X64.hi = { data = zero }; lo = { data = zero } };
                instret = { X64.hi = { data = zero }; lo = { data = zero } };
              };
            base = writeable_xlen `mbase;
            bound = writeable_xlen `mbound;
            ibase = writeable_xlen `mibase;
            ibound = writeable_xlen `mibound;
            dbase = writeable_xlen `mdbase;
            dbound = writeable_xlen `mdbound;
            ucounteren = 
              {
                Counteren.F.z = zero;
                ir = zero;
                tm = zero;
                cy = zero;
              };
            scounteren = 
              {
                Counteren.F.z = zero;
                ir = zero;
                tm = zero;
                cy = zero;
              };
            hcounteren = 
              {
                Counteren.F.z = zero;
                ir = zero;
                tm = zero;
                cy = zero;
              };
            udelta = 
              Timers.{
                cycle = { X64.hi = { data = zero }; lo = { data = zero } };
                time = { X64.hi = { data = zero }; lo = { data = zero } };
                instret = { X64.hi = { data = zero }; lo = { data = zero } };
              };
            sdelta = 
              Timers.{
                cycle = { X64.hi = { data = zero }; lo = { data = zero } };
                time = { X64.hi = { data = zero }; lo = { data = zero } };
                instret = { X64.hi = { data = zero }; lo = { data = zero } };
              };
            hdelta = 
              Timers.{
                cycle = { X64.hi = { data = zero }; lo = { data = zero } };
                time = { X64.hi = { data = zero }; lo = { data = zero } };
                instret = { X64.hi = { data = zero }; lo = { data = zero } };
              };
          };
        s = 
          {
            Supervisor.trap = 
              {
                Trap.status = 
                  {
                    Status.F.sd = zero;
                    z0 = zero;
                    vm = zero;
                    z1 = zero;
                    mxr = zero;
                    pum = zero;
                    mprv = zero;
                    xs = zero;
                    fs= zero;
                    mpp = zero;
                    hpp = zero;
                    spp = zero;
                    mpie = zero;
                    hpie = zero;
                    spie = zero;
                    upie = zero;
                    mie = zero;
                    hie = zero;
                    sie = zero;
                    uie = zero;
                  };
                edeleg  = { data = zero };
                ideleg  = { data = zero };
                ie =
                  {
                    Ie.F.z = zero;
                    meie = zero;
                    heie = zero;
                    seie = zero;
                    ueie = zero;
                    mtie = zero;
                    htie = zero;
                    stie = zero;
                    utie = zero;
                    msie = zero;
                    hsie = zero;
                    ssie = zero;
                    usie = zero;
                  };
                tvec =
                  {
                    Tvec.F.addr = `consti (256/4); (* ??? *)
                    z = zero;
                  };
                scratch  = writeable_xlen `sscratch;
                epc  = 
                  { 
                    data = writeable_ext ~csr:`sepc ~cv:(B.zero xlen) ~ofs:0
                                         i.Csr_regs.m.Machine.trap.Trap.epc.data;
                  };
                cause =
                  {
                    Cause.F.interrupt = 
                      writeable_ext ~csr:`scause ~cv:gnd 
                                    ~ofs:ofs.Csr_regs.m.Machine.trap.Trap.cause.Cause.F.interrupt
                                    i.Csr_regs.m.Machine.trap.Trap.cause.Cause.F.interrupt;
                    z = zero;
                    cause = 
                      writeable_ext ~csr:`scause ~cv:(B.zero 4) 
                                    ~ofs:ofs.Csr_regs.m.Machine.trap.Trap.cause.Cause.F.cause
                                    i.Csr_regs.m.Machine.trap.Trap.cause.Cause.F.cause;
                  };
                badaddr  = 
                  { 
                    data = writeable_ext ~csr:`sbadaddr ~cv:(B.zero xlen) ~ofs:0
                                         i.Csr_regs.m.Machine.trap.Trap.badaddr.data;
                  };
                ip = 
                  {
                    Ip.F.z = zero;
                    meip = zero; 
                    heip = zero; 
                    seip = zero; 
                    ueip = zero;
                    mtip = zero; 
                    htip = zero; 
                    stip = zero; 
                    utip = zero;
                    msip = zero; 
                    hsip = zero; 
                    ssip = zero; 
                    usip = zero;
                  };
              };
            timers = 
              {
                Timers.cycle = counter64 `cycle;
                time = counter64 `time;
                instret = counter64 `instret;
              };
            ptbr = 
              {
                Ptbr.F.asid = zero;
                ppn = zero;
              };
          };
        h = 
          {
            Hypervisor.trap = 
              {
                Trap.status = 
                  {
                    Status.F.sd = zero;
                    z0 = zero;
                    vm = zero;
                    z1 = zero;
                    mxr = zero;
                    pum = zero;
                    mprv = zero;
                    xs = zero;
                    fs= zero;
                    mpp = zero;
                    hpp = zero;
                    spp = zero;
                    mpie = zero;
                    hpie = zero;
                    spie = zero;
                    upie = zero;
                    mie = zero;
                    hie = zero;
                    sie = zero;
                    uie = zero;
                  };
                edeleg  = { data = zero };
                ideleg  = { data = zero };
                ie =
                  {
                    Ie.F.z = zero;
                    meie = zero;
                    heie = zero;
                    seie = zero;
                    ueie = zero;
                    mtie = zero;
                    htie = zero;
                    stie = zero;
                    utie = zero;
                    msie = zero;
                    hsie = zero;
                    ssie = zero;
                    usie = zero;
                  };
                tvec =
                  {
                    Tvec.F.addr = `consti (256/4); (* ??? *)
                    z = zero;
                  };
                scratch  = writeable_xlen `hscratch;
                epc  = 
                  { 
                    data = writeable_ext ~csr:`hepc ~cv:(B.zero xlen) ~ofs:0
                                         i.Csr_regs.m.Machine.trap.Trap.epc.data;
                  };
                cause =
                  {
                    Cause.F.interrupt = 
                      writeable_ext ~csr:`hcause ~cv:gnd 
                                    ~ofs:ofs.Csr_regs.m.Machine.trap.Trap.cause.Cause.F.interrupt
                                    i.Csr_regs.m.Machine.trap.Trap.cause.Cause.F.interrupt;
                    z = zero;
                    cause = 
                      writeable_ext ~csr:`hcause ~cv:(B.zero 4) 
                                    ~ofs:ofs.Csr_regs.m.Machine.trap.Trap.cause.Cause.F.cause
                                    i.Csr_regs.m.Machine.trap.Trap.cause.Cause.F.cause;
                  };
                badaddr  = 
                  { 
                    data = writeable_ext ~csr:`hbadaddr ~cv:(B.zero xlen) ~ofs:0
                                         i.Csr_regs.m.Machine.trap.Trap.badaddr.data;
                  };
                ip = 
                  {
                    Ip.F.z = zero;
                    meip = zero; 
                    heip = zero; 
                    seip = zero; 
                    ueip = zero;
                    mtip = zero; 
                    htip = zero; 
                    stip = zero; 
                    utip = zero;
                    msip = zero; 
                    hsip = zero; 
                    ssip = zero; 
                    usip = zero;
                  };
              };
            timers = 
              {
                Timers.cycle = counter64 `cycle;
                time = counter64 `time;
                instret = counter64 `instret;
              };
          };
        u = 
          {
            User.trap = 
              {
                Trap.status = 
                  {
                    Status.F.sd = zero;
                    z0 = zero;
                    vm = zero;
                    z1 = zero;
                    mxr = zero;
                    pum = zero;
                    mprv = zero;
                    xs = zero;
                    fs= zero;
                    mpp = zero;
                    hpp = zero;
                    spp = zero;
                    mpie = zero;
                    hpie = zero;
                    spie = zero;
                    upie = zero;
                    mie = zero;
                    hie = zero;
                    sie = zero;
                    uie = zero;
                  };
                edeleg  = { data = zero };
                ideleg  = { data = zero };
                ie =
                  {
                    Ie.F.z = zero;
                    meie = zero;
                    heie = zero;
                    seie = zero;
                    ueie = zero;
                    mtie = zero;
                    htie = zero;
                    stie = zero;
                    utie = zero;
                    msie = zero;
                    hsie = zero;
                    ssie = zero;
                    usie = zero;
                  };
                tvec =
                  {
                    Tvec.F.addr = `consti (256/4); (* ??? *)
                    z = zero;
                  };
                scratch  = writeable_xlen `uscratch;
                epc  = 
                  { 
                    data = writeable_ext ~csr:`uepc ~cv:(B.zero xlen) ~ofs:0
                                         i.Csr_regs.m.Machine.trap.Trap.epc.data;
                  };
                cause =
                  {
                    Cause.F.interrupt = 
                      writeable_ext ~csr:`ucause ~cv:gnd 
                                    ~ofs:ofs.Csr_regs.m.Machine.trap.Trap.cause.Cause.F.interrupt
                                    i.Csr_regs.m.Machine.trap.Trap.cause.Cause.F.interrupt;
                    z = zero;
                    cause = 
                      writeable_ext ~csr:`ucause ~cv:(B.zero 4) 
                                    ~ofs:ofs.Csr_regs.m.Machine.trap.Trap.cause.Cause.F.cause
                                    i.Csr_regs.m.Machine.trap.Trap.cause.Cause.F.cause;
                  };
                badaddr  = 
                  { 
                    data = writeable_ext ~csr:`ubadaddr ~cv:(B.zero xlen) ~ofs:0
                                         i.Csr_regs.m.Machine.trap.Trap.badaddr.data;
                  };
                ip = 
                  {
                    Ip.F.z = zero;
                    meip = zero; 
                    heip = zero; 
                    seip = zero; 
                    ueip = zero;
                    mtip = zero; 
                    htip = zero; 
                    stip = zero; 
                    utip = zero;
                    msip = zero; 
                    hsip = zero; 
                    ssip = zero; 
                    usip = zero;
                  };
              };
            timers = 
              {
                Timers.cycle = counter64 `cycle;
                time = counter64 `time;
                instret = counter64 `instret;
              };
            fflags = { data = zero };
            frm = { data = zero };
            fcsr = { data = zero };
          };
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
      let open Csr_regs in
      match csr with
      | `ustatus -> to_vec csr @@ Status.F.to_list @@ regs.u.User.trap.Trap.status 
      | `uie -> to_vec csr @@ Ie.F.to_list @@ regs.u.User.trap.Trap.ie 
      | `utvec -> to_vec csr @@ Tvec.F.to_list @@ regs.u.User.trap.Trap.tvec 
      | `uscratch -> to_vec csr @@ Xlen.F.to_list @@ regs.u.User.trap.Trap.scratch 
      | `uepc -> to_vec csr @@ Xlen.F.to_list @@ regs.u.User.trap.Trap.epc 
      | `ucause -> to_vec csr @@ Cause.F.to_list @@ regs.u.User.trap.Trap.cause 
      | `ubadaddr -> to_vec csr @@ Xlen.F.to_list @@ regs.u.User.trap.Trap.badaddr 
      | `uip -> to_vec csr @@ Ip.F.to_list @@ regs.u.User.trap.Trap.ip 
      | `fflags -> to_vec csr @@ Xlen.F.to_list @@ regs.u.User.fflags 
      | `frm -> to_vec csr @@ Xlen.F.to_list @@ regs.u.User.frm 
      | `fcsr -> to_vec csr @@ Xlen.F.to_list @@ regs.u.User.fcsr 
      | `cycle -> to_vec csr @@ Xlen.F.to_list @@ regs.u.User.timers.Timers.cycle.X64.lo
      | `time -> to_vec csr @@ Xlen.F.to_list @@ regs.u.User.timers.Timers.time.X64.lo
      | `instret -> to_vec csr @@ Xlen.F.to_list @@ regs.u.User.timers.Timers.instret.X64.lo
      | `cycleh -> to_vec csr @@ Xlen.F.to_list @@ regs.u.User.timers.Timers.cycle.X64.hi
      | `timeh -> to_vec csr @@ Xlen.F.to_list @@ regs.u.User.timers.Timers.time.X64.hi
      | `instreth -> to_vec csr @@ Xlen.F.to_list @@ regs.u.User.timers.Timers.instret.X64.hi
      
      | `sstatus -> to_vec csr @@ Status.F.to_list @@ regs.s.Supervisor.trap.Trap.status 
      | `sedeleg -> to_vec csr @@ Xlen.F.to_list @@ regs.s.Supervisor.trap.Trap.edeleg 
      | `sideleg -> to_vec csr @@ Xlen.F.to_list @@ regs.s.Supervisor.trap.Trap.ideleg 
      | `sie -> to_vec csr @@ Ie.F.to_list @@ regs.s.Supervisor.trap.Trap.ie 
      | `stvec -> to_vec csr @@ Tvec.F.to_list @@ regs.s.Supervisor.trap.Trap.tvec 
      | `sscratch -> to_vec csr @@ Xlen.F.to_list @@ regs.s.Supervisor.trap.Trap.scratch 
      | `sepc -> to_vec csr @@ Xlen.F.to_list @@ regs.s.Supervisor.trap.Trap.epc
      | `scause -> to_vec csr @@ Cause.F.to_list @@ regs.s.Supervisor.trap.Trap.cause 
      | `sbadaddr -> to_vec csr @@ Xlen.F.to_list @@ regs.s.Supervisor.trap.Trap.badaddr 
      | `sip -> to_vec csr @@ Ip.F.to_list @@ regs.s.Supervisor.trap.Trap.ip 
      | `sptbr -> to_vec csr @@ Ptbr.F.to_list @@ regs.s.Supervisor.ptbr 
      | `scycle -> to_vec csr @@ Xlen.F.to_list @@ regs.s.Supervisor.timers.Timers.cycle.X64.lo
      | `stime -> to_vec csr @@ Xlen.F.to_list @@ regs.s.Supervisor.timers.Timers.time.X64.lo
      | `sinstret -> to_vec csr @@ Xlen.F.to_list @@ regs.s.Supervisor.timers.Timers.instret.X64.lo
      | `scycleh -> to_vec csr @@ Xlen.F.to_list @@ regs.s.Supervisor.timers.Timers.cycle.X64.hi
      | `stimeh -> to_vec csr @@ Xlen.F.to_list @@ regs.s.Supervisor.timers.Timers.time.X64.hi
      | `sinstreth -> to_vec csr @@ Xlen.F.to_list @@ regs.s.Supervisor.timers.Timers.instret.X64.hi

      | `hstatus -> to_vec csr @@ Status.F.to_list @@ regs.h.Hypervisor.trap.Trap.status 
      | `hedeleg -> to_vec csr @@ Xlen.F.to_list @@ regs.h.Hypervisor.trap.Trap.edeleg 
      | `hideleg -> to_vec csr @@ Xlen.F.to_list @@ regs.h.Hypervisor.trap.Trap.ideleg 
      | `hie -> to_vec csr @@ Ie.F.to_list @@ regs.h.Hypervisor.trap.Trap.ie 
      | `htvec -> to_vec csr @@ Tvec.F.to_list @@ regs.h.Hypervisor.trap.Trap.tvec 
      | `hscratch -> to_vec csr @@ Xlen.F.to_list @@ regs.h.Hypervisor.trap.Trap.scratch 
      | `hepc -> to_vec csr @@ Xlen.F.to_list @@ regs.h.Hypervisor.trap.Trap.epc
      | `hcause -> to_vec csr @@ Cause.F.to_list @@ regs.h.Hypervisor.trap.Trap.cause 
      | `hbadaddr -> to_vec csr @@ Xlen.F.to_list @@ regs.h.Hypervisor.trap.Trap.badaddr 
      (*| `hip -> to_vec csr @@ Ip.F.to_list @@ regs.h.Hypervisor.trap.Trap.ip*) (* XXX *)
      | `hcycle -> to_vec csr @@ Xlen.F.to_list @@ regs.h.Hypervisor.timers.Timers.cycle.X64.lo
      | `htime -> to_vec csr @@ Xlen.F.to_list @@ regs.h.Hypervisor.timers.Timers.time.X64.lo
      | `hinstret -> to_vec csr @@ Xlen.F.to_list @@ regs.h.Hypervisor.timers.Timers.instret.X64.lo
      | `hcycleh -> to_vec csr @@ Xlen.F.to_list @@ regs.h.Hypervisor.timers.Timers.cycle.X64.hi
      | `htimeh -> to_vec csr @@ Xlen.F.to_list @@ regs.h.Hypervisor.timers.Timers.time.X64.hi
      | `hinstreth -> to_vec csr @@ Xlen.F.to_list @@ regs.h.Hypervisor.timers.Timers.instret.X64.hi

      | `misa -> to_vec csr @@ Isa.F.to_list @@ regs.m.Machine.isa 
      | `mvendorid -> to_vec csr @@ Xlen.F.to_list @@ regs.m.Machine.vendorid 
      | `marchid -> to_vec csr @@ Xlen.F.to_list @@ regs.m.Machine.archid 
      | `mimpid -> to_vec csr @@ Xlen.F.to_list @@ regs.m.Machine.impid 
      | `mhartid -> to_vec csr @@ Xlen.F.to_list @@ regs.m.Machine.hartid
      | `mstatus -> to_vec csr @@ Status.F.to_list @@ regs.m.Machine.trap.Trap.status 
      | `medeleg -> to_vec csr @@ Xlen.F.to_list @@ regs.m.Machine.trap.Trap.edeleg 
      | `mideleg -> to_vec csr @@ Xlen.F.to_list @@ regs.m.Machine.trap.Trap.ideleg 
      | `mie -> to_vec csr @@ Ie.F.to_list @@ regs.m.Machine.trap.Trap.ie 
      | `mtvec -> to_vec csr @@ Tvec.F.to_list @@ regs.m.Machine.trap.Trap.tvec 
      | `mscratch -> to_vec csr @@ Xlen.F.to_list @@ regs.m.Machine.trap.Trap.scratch
      | `mepc -> to_vec csr @@ Xlen.F.to_list @@ regs.m.Machine.trap.Trap.epc 
      | `mcause -> to_vec csr @@ Cause.F.to_list @@ regs.m.Machine.trap.Trap.cause 
      | `mbadaddr -> to_vec csr @@ Xlen.F.to_list @@ regs.m.Machine.trap.Trap.badaddr 
      | `mip -> to_vec csr @@ Ip.F.to_list @@ regs.m.Machine.trap.Trap.ip 
      | `mbase -> to_vec csr @@ Xlen.F.to_list @@ regs.m.Machine.base 
      | `mbound -> to_vec csr @@ Xlen.F.to_list @@ regs.m.Machine.bound
      | `mibase -> to_vec csr @@ Xlen.F.to_list @@ regs.m.Machine.ibase 
      | `mibound -> to_vec csr @@ Xlen.F.to_list @@ regs.m.Machine.ibound 
      | `mdbase -> to_vec csr @@ Xlen.F.to_list @@ regs.m.Machine.dbase 
      | `mdbound -> to_vec csr @@ Xlen.F.to_list @@ regs.m.Machine.dbound 
      | `mcycle -> to_vec csr @@ Xlen.F.to_list @@ regs.m.Machine.timers.Timers.cycle.X64.lo 
      | `mtime -> to_vec csr @@ Xlen.F.to_list @@ regs.m.Machine.timers.Timers.time.X64.lo 
      | `minstret -> to_vec csr @@ Xlen.F.to_list @@ regs.m.Machine.timers.Timers.instret.X64.lo 
      | `mcycleh -> to_vec csr @@ Xlen.F.to_list @@ regs.m.Machine.timers.Timers.cycle.X64.hi
      | `mtimeh -> to_vec csr @@ Xlen.F.to_list @@ regs.m.Machine.timers.Timers.time.X64.hi
      | `minstreth -> to_vec csr @@ Xlen.F.to_list @@ regs.m.Machine.timers.Timers.instret.X64.hi
      | `mucounteren -> to_vec csr @@ Counteren.F.to_list @@ regs.m.Machine.ucounteren 
      | `mscounteren -> to_vec csr @@ Counteren.F.to_list @@ regs.m.Machine.scounteren 
      | `mhcounteren -> to_vec csr @@ Counteren.F.to_list @@ regs.m.Machine.hcounteren 

      | `mucycle -> to_vec csr @@ Xlen.F.to_list    @@ regs.m.Machine.udelta.Timers.cycle.X64.lo
      | `mutime -> to_vec csr @@ Xlen.F.to_list     @@ regs.m.Machine.udelta.Timers.time.X64.lo
      | `muinstret -> to_vec csr @@ Xlen.F.to_list  @@ regs.m.Machine.udelta.Timers.instret.X64.lo
      | `mscycle -> to_vec csr @@ Xlen.F.to_list    @@ regs.m.Machine.sdelta.Timers.cycle.X64.lo
      | `mstime -> to_vec csr @@ Xlen.F.to_list     @@ regs.m.Machine.sdelta.Timers.time.X64.lo
      | `msinstret -> to_vec csr @@ Xlen.F.to_list  @@ regs.m.Machine.sdelta.Timers.instret.X64.lo
      | `mhcycle -> to_vec csr @@ Xlen.F.to_list    @@ regs.m.Machine.hdelta.Timers.cycle.X64.lo
      | `mhtime -> to_vec csr @@ Xlen.F.to_list     @@ regs.m.Machine.hdelta.Timers.time.X64.lo
      | `mhinstret -> to_vec csr @@ Xlen.F.to_list  @@ regs.m.Machine.hdelta.Timers.instret.X64.lo
      | `mucycleh -> to_vec csr @@ Xlen.F.to_list   @@ regs.m.Machine.udelta.Timers.cycle.X64.hi 
      | `mutimeh -> to_vec csr @@ Xlen.F.to_list    @@ regs.m.Machine.udelta.Timers.time.X64.hi 
      | `muinstreth -> to_vec csr @@ Xlen.F.to_list @@ regs.m.Machine.udelta.Timers.instret.X64.hi 
      | `mscycleh -> to_vec csr @@ Xlen.F.to_list   @@ regs.m.Machine.sdelta.Timers.cycle.X64.hi 
      | `mstimeh -> to_vec csr @@ Xlen.F.to_list    @@ regs.m.Machine.sdelta.Timers.time.X64.hi 
      | `msinstreth -> to_vec csr @@ Xlen.F.to_list @@ regs.m.Machine.sdelta.Timers.instret.X64.hi 
      | `mhcycleh -> to_vec csr @@ Xlen.F.to_list   @@ regs.m.Machine.hdelta.Timers.cycle.X64.hi 
      | `mhtimeh -> to_vec csr @@ Xlen.F.to_list    @@ regs.m.Machine.hdelta.Timers.time.X64.hi 
      | `mhinstreth -> to_vec csr @@ Xlen.F.to_list @@ regs.m.Machine.hdelta.Timers.instret.X64.hi 

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
  module M = Make(B)(Ifs)

  open Ifs

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
    let open Ifs.Csr_ctrl in
 
    let spec = M.csr_spec ext in
  
    let wdata = 
      (mux2 csr_ctrl.csr_use_imm (uresize csr_ctrl.csr_imm 32) wdata) -- "csr_wdata" 
    in

    (* set, clear or write bits to a register *)
    let csr_reg ~cv ~ext_we ~csr_we ~clr ~set ~write ~data ~ext_f = 
      Seq.reg_fb ~e:(ext_we |: csr_we) ~cv ~w:(width cv) 
        (fun dprev ->
          pmux [
            clr, (dprev &: (~: data));
            set, (dprev |: data);
            write, data;
          ] (ext_f dprev))
    in

    (* R/W csr register *)
    let writeable_fb ~csr ~ofs ~cv ~ext_we ~ext_f =
      let csr_index = csr_index csr in
      if csr_index = -1 then cv
      else
        csr_reg ~cv 
          ~ext_we
          ~csr_we:(csr_ctrl.csr_dec.[csr_index:csr_index] &: csr_ctrl.csr_file_write)
          ~clr:csr_ctrl.csr_clr
          ~set:csr_ctrl.csr_set
          ~write:csr_ctrl.csr_write
          ~data:(wdata.[(width cv)+ofs-1:ofs]) (* XXX ... from pipeline *)
          ~ext_f
    in
    let writeable = writeable_fb ~ext_we:gnd ~ext_f:(fun x -> x) in

    (* R/W csr register that can also be set externally.
     * XXX which should get priority??? *)
    let writeable_ext ~ext_we ~ext_data = 
      writeable_fb ~ext_we ~ext_f:(fun x -> mux2 ext_we ext_data x) 
    in

    (* split 32/32 counter *)
    let counter64 =
      if xlen = 64 then
        writeable_fb ~csr:`mtime ~ofs:0 ~cv:(zero 64) ~ext_we:vdd ~ext_f:(fun d -> d +:. 1)
      else
        let open Ifs.Csr_ctrl in
        let csr_index0 = csr_index `mtime in
        let csr_index1 = csr_index `mtimeh in
        if csr_index0 = (-1) || csr_index1 = (-1) then (zero 64)
        else
          let w = wire 64 in
          (*let reg ~cv ~e ~clr ~set ~write ~data ~w = 
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
          in*)
          let rlo = writeable_fb ~csr:`mtime  ~ofs:0 ~cv:(zero 32) 
                                 ~ext_we:vdd ~ext_f:(fun d -> w.[31:0])
          in
          let rhi = writeable_fb ~csr:`mtimeh ~ofs:0 ~cv:(zero 32) 
                                 ~ext_we:vdd ~ext_f:(fun d -> w.[63:32])
          in
          let q = rhi @: rlo in
          let () = w <== q +:. 1 in
          q
    in
 
    let regs = 
      Ifs.Csr_regs.(map2 
        (fun (n,b) r ->
          let open B in
          match r with
          | `consti x -> consti b x
          | `const x -> x
          | `counter64 (false,_) -> counter64.[xlen-1:0]
          | `counter64 (true,_) -> if xlen=32 then counter64.[63:32] else zero 64
          | `writeable(csr, ofs, cv) -> writeable ~csr ~ofs ~cv 
          | `writeable_ext(csr, ofs, cv, ext_we, ext_data) -> 
            writeable_ext ~csr ~ofs ~cv ~ext_we ~ext_data)
        t spec)
    in
    regs, M.csr_read_mux csr_ctrl.Ifs.Csr_ctrl.csr_dec regs Ifs.csrs
  
end


