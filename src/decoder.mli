module Make_insn_decoder(Ifs : Interfaces.S)(B : HardCaml.Comb.S) : sig

  type t = 
    {
      insn : B.t;
      iclass : B.t Ifs.Class.t;
    }

  val imm_uj : instr:B.t -> B.t

  val imm : c:B.t Ifs.Class.t -> instr:B.t -> imm_uj:B.t -> B.t

  val decoder : B.t -> t

end

module Make(Ifs : Interfaces.S) : sig

  open HardCaml.Signal.Comb

  val name : string

  val decoder : inp:t Ifs.I.t -> fet:t Ifs.Stage.t -> t Ifs.Stage.t

  val f : 
    inp:t Ifs.I.t -> 
    comb:t Ifs.Stages.t -> pipe:t Ifs.Stages.t -> 
    t Ifs.Stage.t

end

