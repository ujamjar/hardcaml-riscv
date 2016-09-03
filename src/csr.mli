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

  val ustatus : csr
  val ustatus : csr
  val uie : csr
  val utvec : csr
  val uscratch : csr
  val uepc : csr
  val ucause : csr
  val ubadaddr : csr
  val uip : csr
  val fflags : csr
  val frm : csr
  val fcsr : csr
  val cycle : csr
  val time : csr
  val instret : csr
  val cycleh : csr
  val timeh : csr
  val instreth : csr
  val ustatus : csr
  val uie : csr
  val utvec : csr
  val uscratch : csr
  val uepc : csr
  val ucause : csr
  val ubadaddr : csr
  val uip : csr
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
  val sedeleg : csr
  val sideleg : csr
  val sie : csr
  val stvec : csr
  val sscratch : csr
  val sepc : csr
  val scause : csr
  val sbadaddr : csr
  val sip : csr
  val sptbr : csr
  val scycle : csr
  val stime : csr
  val sinstret : csr
  val scycleh : csr
  val stimeh : csr
  val sinstreth : csr
  val hstatus : csr
  val hedeleg : csr
  val hideleg : csr
  val hie : csr
  val htvec : csr
  val hscratch : csr
  val hepc : csr
  val hcause : csr
  val hbadaddr : csr
  val hcycle : csr
  val htime : csr
  val hinstret : csr
  val hcycleh : csr
  val htimeh : csr
  val hinstreth : csr
  val misa : csr
  val mvendorid : csr
  val marchid : csr
  val mimpid : csr
  val mhartid : csr
  val mstatus : csr
  val medeleg : csr
  val mideleg : csr
  val mie : csr
  val mtvec : csr
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
  val mcycle : csr
  val mtime : csr
  val minstret : csr
  val mcycleh : csr
  val mtimeh : csr
  val minstreth : csr
  val mucounteren : csr
  val mscounteren : csr
  val mhcounteren : csr
  val mucycle : csr
  val mutime : csr
  val muinstret : csr
  val mscycle : csr
  val mstime : csr
  val msinstret : csr
  val mhcycle : csr
  val mhtime : csr
  val mhinstret : csr
  val mucycleh : csr
  val mutimeh : csr
  val muinstreth : csr
  val mscycleh : csr
  val mstimeh : csr
  val msinstreth : csr
  val mhcycleh : csr
  val mhtimeh : csr
  val mhinstreth : csr

  val all_csrs : (Config.csr * csr) list

end

module Make(B : HardCaml.Comb.S)(Ifs : Interfaces.S) : sig

  type timer_spec = [ `cycle | `time | `instret | `mtime ]
  type csr_ospec = 
    [ `const of B.t | `consti of int
    | `counter64 of bool * timer_spec
    | `writeable of Config.csr * int * B.t 
    | `writeable_ext of Config.csr * int * B.t * B.t * B.t ] 
  type csr_ispec = B.t * B.t

  val csr_spec : csr_ispec Ifs.Csr_regs.t -> csr_ospec Ifs.Csr_regs.t

  val csr_read_mux : B.t -> B.t Ifs.Csr_regs.t -> Config.csr list -> B.t

end

module Build(Ifs : Interfaces.S) : sig
  module B : HardCaml.Comb.S with type t = HardCaml.Signal.Comb.t
  module M : module type of Make(B)(Ifs)

  val make : clk:B.t -> clr:B.t -> 
             csr_ctrl:B.t Ifs.Csr_ctrl.t -> 
             ext:(B.t * B.t) Ifs.Csr_regs.t ->
             wdata:B.t ->
             B.t Ifs.Csr_regs.t * B.t

end
