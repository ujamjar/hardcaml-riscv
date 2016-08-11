open HardCaml.Signal

module Make(C : Config.S) : sig

  module Ifs : Interfaces.S
  module Csr : module type of Csr.Build(Ifs)
  module Cmb : module type of Cmb.Make(Comb)(Ifs)

  type stage = Comb.t Ifs.Stage.t
  type stages = Comb.t Ifs.Stages.t
  type 'a f = 'a Cmb.f
  type f_stage = stage f
  type 'a f_output = 'a Cmb.f_output

  module Build : sig
    val p1 : inp:Comb.t Ifs.I.t -> f_output:'a f_output -> 'a
    val p5 : inp:Comb.t Ifs.I.t -> f_output:'a f_output -> 'a
  end

  module Output : sig
    val o : Comb.t Ifs.O.t f_output
  end

  module Output_debug : sig
    val o : Comb.t Ifs.O_debug.t f_output
  end

end


