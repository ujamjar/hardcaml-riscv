open HardCaml

module Regs (X : sig
  val clk : Signal.Comb.t
  val clr : Signal.Comb.t
end) : Signal.Seq

