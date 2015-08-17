module Make(Ifs : Interfaces.S) : sig
  
  open HardCaml.Signal

  val alu : Comb.t Ifs.Stage.t -> Comb.t Ifs.Stage.t

end
