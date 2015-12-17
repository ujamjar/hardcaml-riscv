module Simple : sig
  module I : module type of Avalon.Master_clk with type 'a t = 'a Avalon.Master_clk.t
  module O : interface leds (slave : Avalon.Slave) end
end

val make_simple_vjtag_mm : string -> string -> HardCaml.Structural.circuit

val generate_simple_vjtag_mm : (string -> unit) -> string -> string -> 
  (HardCaml.Signal.Comb.t Simple.I.t -> HardCaml.Signal.Comb.t Simple.O.t) -> unit

module Sdram_mm : sig
  module I : interface clk rst (vjtag_master : Avalon.Master) (sdram_slave : Avalon.Slave) end
  module O : interface leds (vjtag_slave : Avalon.Slave) (sdram_master : Avalon.Master) end
end

val make_sdram_vjtag_mm : string -> string -> HardCaml.Structural.circuit

val generate_sdram_vjtag_mm : (string -> unit) -> string -> string -> 
  (HardCaml.Signal.Comb.t Sdram_mm.I.t -> HardCaml.Signal.Comb.t Sdram_mm.O.t) -> unit

