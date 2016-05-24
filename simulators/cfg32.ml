open HardCamlRiscV
open Printf

(* rv32 core *)
module Cfg = struct
  let xlen = 32
  let start_addr = 0x10
end
module Rv = Pipe.Make(Cfg)
module B = HardCaml.Api.B

(*
module Rv_o = Rv.Ifs.O_debug
module Rv_output = Rv.Output_debug
*)

module Rv_o = Rv.Ifs.O
module Rv_output = Rv.Output

module Ui = Ui.Make(B)
