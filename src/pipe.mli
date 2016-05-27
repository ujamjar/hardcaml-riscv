open HardCaml.Signal

module Make(C : Config.S) : sig

  module Ifs : Interfaces.S

  type stage = Comb.t Ifs.Stage.t
  type stages = Comb.t Ifs.Stages.t

  type 'a f = inp:Comb.t Ifs.I.t -> comb:stages -> pipe:stages -> 'a
  type f_stage = stage f
  type 'a f_output = 
    ctrl:Comb.t Ifs.Ctrl.t -> 
    mi:Comb.t Ifs.Mo_instr.t ->
    md:Comb.t Ifs.Mo_data.t ->
    'a f

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


