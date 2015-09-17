open HardCaml.Signal

module Make(C : Config.S) : sig

  module Ifs : Interfaces.S

  type stage = Comb.t Ifs.Stage.t
  type stages = Comb.t Ifs.Stages.t
  type f_stage = inp:Comb.t Ifs.I.t -> comb:stages -> pipe:stages -> stage
  type 'a f_output = stages -> 'a

  module type Stage = sig
    val name : string
    val f : f_stage
  end

  module Fetch : Stage
  module Decoder : Stage
  module Alu : Stage
  module Mem : Stage
  module Commit : Stage

  module Build : sig
    val p5 : inp:Comb.t Ifs.I.t -> f_output:'a f_output -> 'a
  end

  module Output : sig
    val f : stages -> Comb.t Ifs.O.t
  end

  module Output_debug : sig
    val f : stages -> Comb.t Ifs.O_debug.t
  end

end


