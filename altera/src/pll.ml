(* pll used with de0-nano.
 *
 * 50 Mhz input.  
 *
 * Outputs
 *
 * 1) in-phase 50 Mhz output for core
 * 2) -3 ns offset 50 Mhz output for SDRAM
 *)

module I = interface inclk0[1] end
module O = interface c0[1] c1[1] locked[1] end

let pll50_inst i = 
  let module Pll = HardCaml.Interface.Inst(I)(O) in
  Pll.make "pll50" i

