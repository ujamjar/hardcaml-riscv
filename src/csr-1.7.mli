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

module Make(B : HardCaml.Comb.S)(Ifs : Interfaces.S) : sig

  type timer_spec = [ `cycle | `time | `instret | `mtime ]
  type csr_ospec = 
    [ `zero | `ones | `const of B.t | `consti of int
    | `counter64 of timer_spec
    | `counter64h of timer_spec
    | `writeable of Config.csr * int * B.t * B.t 
    | `writeable_ext of Config.csr * int * B.t * B.t * B.t * B.t ] 
  type csr_ispec = B.t * B.t

  val csr_spec : csr_ispec Ifs.Csr_regs.t -> csr_ospec Ifs.Csr_regs.t

  val csr_read_mux : B.t -> B.t Ifs.Csr_regs.t -> Config.csr list -> B.t

end

module Build(Ifs : Interfaces.S) : sig
  module B : HardCaml.Comb.S with type t = HardCaml.Signal.Comb.t
  module Machine : module type of Make(B)(Ifs)

  val make : clk:B.t -> clr:B.t -> 
             csr_ctrl:B.t Ifs.Csr_ctrl.t -> 
             ext:(B.t * B.t) Ifs.Csr_regs.t ->
             wdata:B.t ->
             B.t Ifs.Csr_regs.t * B.t

end

