module Simple : sig
  module I : module type of Avalon.Master_clk with type 'a t = 'a Avalon.Master_clk.t
  module O : interface leds (slave : Avalon.Slave) end
end

val make_simple_vjtag_mm : string -> string -> HardCaml.Structural.circuit

val generate_simple_vjtag_mm : (string -> unit) -> string -> string -> 
  (HardCaml.Signal.Comb.t Simple.I.t -> HardCaml.Signal.Comb.t Simple.O.t) -> unit

