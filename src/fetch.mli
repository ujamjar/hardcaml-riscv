module Make(Ifs : Interfaces.S)(B : HardCaml.Comb.S) : sig

  open B

  val name : string

  val fetch : 
    inp:t Ifs.I.t -> 
    com:t Ifs.Stage.t -> fet:t Ifs.Stage.t -> 
    t Ifs.Stage.t * t Ifs.Mo_instr.t

  val f : 
    inp:t Ifs.I.t -> 
    comb:t Ifs.Stages.t -> pipe:t Ifs.Stages.t -> 
    t Ifs.Stage.t * t Ifs.Mo_instr.t

  val m : 
    ctrl: t Ifs.Ctrl.t ->
    inp:t Ifs.I.t -> 
    comb:t Ifs.Stages.t -> pipe:t Ifs.Stages.t -> 
    t Ifs.Mo_instr.t

end

