module Make(Ifs : Interfaces.S) : sig
  
  open HardCaml.Signal.Comb

  val alu : t Ifs.Stage.t -> t Ifs.Stage.t

  val name : string

  val f : 
    inp:t Ifs.I.t -> 
    comb:t Ifs.Stages.t -> pipe:t Ifs.Stages.t -> 
    t Ifs.Stage.t

end
