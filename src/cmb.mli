module Make(B : HardCaml.Comb.S)(Ifs : Interfaces.S) : sig

  module Fetch : module type of Fetch.Make(Ifs)(B)
  module Decoder : module type of Decoder.Make(Ifs)(B)
  module Alu : module type of Alu.Make(Ifs)(B)
  module Mem : module type of Mem.Make(Ifs)(B)
  module Commit : module type of Commit.Make(Ifs)(B)
  module Rf : module type of Rf.Make(Ifs)

  type stage = B.t Ifs.Stage.t

  type stages = B.t Ifs.Stages.t

  type 'a f = inp:B.t Ifs.I.t -> comb:stages -> pipe:stages -> 'a

  type 'a f_output = 
    ctrl:B.t Ifs.Ctrl.t -> 
    mi:B.t Ifs.Mo_instr.t ->
    md:B.t Ifs.Mo_data.t ->
    'a f

  val hack_junk : B.t Ifs.Stage.t -> B.t Ifs.Stage.t -> B.t Ifs.Stage.t

  val ctrl : inp:'a -> B.t Ifs.Ctrl.t

  val c : 
    inp:B.t Ifs.I.t ->
    state:B.t Ifs.Stage.t ->
    async_rf:(dec:B.t Ifs.Stage.t -> B.t Rf.O.t) ->
    csrs_q:B.t Ifs.Csr_regs.t ->
    csr_rdata:B.t ->
    B.t Ifs.Mo_instr.t *
    B.t Ifs.Mo_data.t *
    B.t Ifs.Stage.t * 
    B.t Rf.O.t * 
    B.t Ifs.Ctrl.t * 
    (B.t * B.t) Ifs.Csr_regs.t

end

