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
  
  (* 32 or 64 bit *)
  val xlen : int 
  
  (* processor start address *)
  val start_addr : int

  (* various options *)

  (* add support for wait for interrupt instruction *)
  val support_wfi : bool

  (* add support for eret instruction *)
  val support_eret : bool

  (* add support for all csr instructions (csrrc is always supported) *)
  val support_csrs : bool

  (* csrs which can be decoded *)
  val csrs : csr list
end

module RV32I_base : S
module RV32I_machine : S

module T : module type of Riscv.RV32I_MACHINE.T
module V : Utils.BVec_S with type t = T.t

