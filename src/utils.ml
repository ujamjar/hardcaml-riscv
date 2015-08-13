open HardCaml
open Signal.Comb

module Regs (X : sig
  val clk : t
  val clr : t
end) = struct

  include Signal.Make_seq(struct
    open Signal.Types
    open Signal.Seq
    let reg_spec = { r_sync with reg_clock = X.clk; reg_clear = X.clr; }
    let ram_spec = { r_none with reg_clock = X.clk; }
  end)

end


