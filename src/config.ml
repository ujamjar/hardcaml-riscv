type csr = 
  [ 
    (* user *)
    `ustatus | `uie | `utvec | `uscratch | `uepc | `ucause | `ubadaddr | 
    `uip | `fflags | `frm | `fcsr | `cycle | `time | `instret | `cycleh | 
    `timeh | `instreth |
    (* supervisor *)
    `sstatus | `sedeleg | `sideleg | `sie | `stvec | `sscratch | `sepc |
    `scause | `sbadaddr | `sip | `sptbr | `scycle | `stime | `sinstret |
    `scycleh | `stimeh | `sinstreth |
    (* hypervisor *)
    `hstatus | `hedeleg | `hideleg | `hie | `htvec | `hscratch | `hepc |
    `hcause | `hbadaddr | `hcycle | `htime | `hinstret | `hcycleh |
    `htimeh | `hinstreth |
    (* machine *)
    `misa | `mvendorid | `marchid | `mimpid | `mhartid |
    `mstatus | `medeleg | `mideleg | `mie | `mtvec | `mscratch |
    `mepc | `mcause | `mbadaddr | `mip | `mbase | `mbound |
    `mibase | `mibound | `mdbase | `mdbound | `mcycle |
    `mtime | `minstret | `mcycleh | `mtimeh | `minstreth | 
    `mucounteren | `mscounteren | `mhcounteren | 
    `mucycle | `mutime | `muinstret |
    `mscycle | `mstime | `msinstret | 
    `mhcycle | `mhtime | `mhinstret |
    `mucycleh | `mutimeh | `muinstreth | 
    `mscycleh | `mstimeh | `msinstreth | 
    `mhcycleh | `mhtimeh | `mhinstreth 

  ]
  deriving(Enum,Bounded,Show)

module type S = sig
  val xlen : int 
  val start_addr : int
  val support_wfi : bool
  val support_eret : bool
  val support_csrs : bool
  val csrs : csr list
end

module RV32I_base = struct
  let xlen = 32
  let start_addr = 0x10
  let support_wfi = false
  let support_eret = false
  let support_csrs = false
  let csrs = 
    [ 
      `cycle; `time; `instret;
      `cycleh; `timeh; `instreth;
    ]
end

module RV32I_machine = struct
  let xlen = 32
  let start_addr = 0x10 (* XXX 0x200 *)
  let support_wfi = true
  let support_eret = true
  let support_csrs = true
  let csrs = 
    [ 
      (* user *)
      `ustatus; `uie; `utvec; `uscratch; `uepc; `ucause; `ubadaddr; 
      `uip; `fflags; `frm; `fcsr; `cycle; `time; `instret; `cycleh; 
      `timeh; `instreth;
      (* supervisor *)
      `sstatus; `sedeleg; `sideleg; `sie; `stvec; `sscratch; `sepc;
      `scause; `sbadaddr; `sip; `sptbr; `scycle; `stime; `sinstret;
      `scycleh; `stimeh; `sinstreth;
      (* hypervisor *)
      `hstatus; `hedeleg; `hideleg; `hie; `htvec; `hscratch; `hepc;
      `hcause; `hbadaddr; `hcycle; `htime; `hinstret; `hcycleh;
      `htimeh; `hinstreth;
      (* machine *)
      `misa; `mvendorid; `marchid; `mimpid; `mhartid;
      `mstatus; `medeleg; `mideleg; `mie; `mtvec; `mscratch;
      `mepc; `mcause; `mbadaddr; `mip; `mbase; `mbound;
      `mibase; `mibound; `mdbase; `mdbound; `mcycle;
      `mtime; `minstret; `mcycleh; `mtimeh; `minstreth; `mucounteren;
      `mscounteren; `mhcounteren; `mucycle; `mutime; `muinstret;
      `mscycle; `mstime; `msinstret; `mhcycle; `mhtime; `mhinstret;
      `mucycle; `mutime; `muinstret; `mscycle; `mstime;
      `msinstret; `mhcycle; `mhtime; `mhinstret;
    ]
end

module T = Riscv.RV32I_MACHINE.T
module V = Utils.BVec(T)

