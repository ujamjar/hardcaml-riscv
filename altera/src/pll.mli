module I : interface inclk0 end
module O : interface c0 locked end

val pll50_inst : HardCaml.Signal.Comb.t I.t -> HardCaml.Signal.Comb.t O.t

