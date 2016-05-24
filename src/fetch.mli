module Make(Ifs : Interfaces.S) : sig

  open HardCaml.Signal.Comb

  val name : string

  val fetch : 
    inp:t Ifs.I.t -> 
    com:t Ifs.Stage.t -> fet:t Ifs.Stage.t -> 
    t Ifs.Stage.t

  val f : 
    inp:t Ifs.I.t -> 
    comb:t Ifs.Stages.t -> pipe:t Ifs.Stages.t -> 
    t Ifs.Stage.t

  val m : 
    ctrl: t Ifs.Ctrl.t ->
    inp:t Ifs.I.t -> 
    comb:t Ifs.Stages.t -> pipe:t Ifs.Stages.t -> 
    t Ifs.Mo_instr.t

end

