open HardCamlRiscV
open HardCaml.Signal.Comb

module Cfg = struct
  let xlen = 32
  let start_addr = 0x10
end

module Rv = Pipe.Make(Cfg)
module B = HardCaml.Api.B

module Rv_o = Rv.Ifs.O
module Rv_output = Rv.Output

let pipeline inp = Rv.Build.p5 ~inp ~f_output:Rv_output.o 

module G = HardCaml.Interface.Circ(Rv.Ifs.I)(Rv_o) 
let circ = G.make "rv32i" pipeline 
let () = HardCaml.Rtl.Verilog.write print_string circ

