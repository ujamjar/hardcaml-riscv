open HardCaml.Signal

module Make(C : Config.S) : sig

  module Ifs : Interfaces.S

  val wired_stage : 'a -> Comb.t Ifs.Stage.t

  type stage = Comb.t Ifs.Stage.t
  type stages = stage array
  type f_stage = n:int -> inp:Comb.t Ifs.I.t -> comb:stages -> pipe:stages -> stage
  type 'a f_output = stages -> 'a

  module type Stage = sig
    val name : string
    val f : f_stage
  end

  val build_pipeline : f_stages:(module Stage) array -> f_output:'a f_output -> 
    Comb.t Ifs.I.t -> 'a

  val build_comb : f_stages:(module Stage) array -> f_output:'a f_output -> 
    Comb.t Ifs.I.t -> 'a

  module Fetch : Stage
  module Decoder : Stage
  module Alu : Stage
  module Mem : Stage
  module Commit : Stage

  module Output : sig
    val f : stages -> Comb.t Ifs.O.t
  end

  module Output_debug : sig
    val f : stages -> Comb.t Ifs.O_debug.t
  end

end

