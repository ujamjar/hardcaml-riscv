module Make(Ifs : Interfaces.S) : sig

  open HardCaml.Signal.Comb

  val f : 
    inp:t Ifs.I.t -> 
    comb:t Ifs.Stages.t -> pipe:t Ifs.Stages.t -> 
    t Ifs.Stage.t

end

