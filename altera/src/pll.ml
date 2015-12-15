module I = interface inclk0[1] end
module O = interface c0[1] locked[1] end

let pll50_inst i = 
  let module Pll = HardCaml.Interface.Inst(I)(O) in
  Pll.make "pll50" i

