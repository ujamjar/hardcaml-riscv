type csr = 
  (* Floating point *)
  [ `fflags
  | `frm
  | `fcsr
  (* User counters/times *)
  | `cycle
  | `time
  | `instret
  | `cycleh
  | `timeh
  | `instreth
  (* Supervisor Trap Setup*)
  | `sstatus 
  | `stvec 
  | `sie 
  | `stimecmp 
  (* Supervisor Timer *)
  | `stime 
  | `stimeh 
  (* Supervisor Trap Handling *)
  | `sscratch 
  | `sepc 
  | `scause 
  | `sbadaddr 
  | `sip 
  (* Supervisor Protection and Translation *)
  | `sptbr 
  | `sasid 
  (* Supervisor Read/Write Shadow of User Read-Only registers *)
  | `cyclew 
  | `timew 
  | `instretw 
  | `cyclehw 
  | `timehw 
  | `instrethw 
  (* Hypervisor level CSRs - table 2.4 *)
  (* Hypervisor Trap Setup *)
  | `hstatus 
  | `htvec 
  | `htdeleg 
  | `htimecmp 
  (* Hypervisor Timer *)
  | `htime 
  | `htimeh 
  (* Hypervisor Trap Handling *)
  | `hscratch 
  | `hepc 
  | `hcause 
  | `hbadaddr 
  (* Hypervisor Protection and Translation *)
  (*0x28X TBD "TBD" "TBD."*)
  (* Hypervisor Read/Write Shadow of Supervisor Read-Only Registers *)
  | `stimew 
  | `stimehw 
  (* Machine Information Registers *)
  | `mcpuid 
  | `mimpid 
  | `mhartid 
  (* Machine Trap Setup *)
  | `mstatus 
  | `mtvec 
  | `mtdeleg 
  | `mie 
  | `mtimecmp 
  (* Machine Timers and Counters *)
  | `mtime 
  | `mtimeh 
  (* Machine Trap Handling *)
  | `mscratch 
  | `mepc 
  | `mcause 
  | `mbadaddr 
  | `mip 
  (* Machine Protection and Translation *)
  | `mbase 
  | `mbound 
  | `mibase 
  | `mibound 
  | `mdbase 
  | `mdbound 
  (* Machine Read-Write Shadow of Hypervisor Read-Only Registers *)
  | `htimew 
  | `htimehw 
  (* Machine Host-Target Interface (Non-Standard Berkeley Extension) *)
  | `mtohost 
  | `mfromhost ]

module type S = sig
  (* 32 or 64 bit *)
  val xlen : int 
  (* processor start address *)
  val start_addr : int

  (* various options *)
  val support_wfi : bool
  val support_eret : bool
  val support_csrs : bool
end

module RV32I_base : S
module RV32I_machine : S
