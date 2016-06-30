module Make(Ifs : Interfaces.S)(B : HardCaml.Comb.S) : sig

  open B

  val name : string

  val commit : 
    mem:t Ifs.Stage.t -> 
    csrs:t Ifs.Csr_regs.t ->
    csr_rdata:t -> 
    t Ifs.Stage.t

  val f : 
    inp:t Ifs.I.t -> 
    comb:t Ifs.Stages.t -> pipe:t Ifs.Stages.t -> 
    t Ifs.Stage.t

end


