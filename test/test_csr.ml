open HardCamlRiscV
  
module B = HardCaml.Signal.Comb
module Ifs = Interfaces.Make(Config.RV32I_machine)
module X = Csr.Build(Ifs)

let ext = Ifs.Csr_regs.(map (fun (n,b) -> B.gnd, B.zero b) t) 

let csr_ctrl = Ifs.Csr_ctrl.(map (fun (n,b) -> B.zero b) t)

let wdata = B.zero 32

let x,y = X.make ~clk:B.gnd ~clr:B.gnd ~ext ~csr_ctrl ~wdata

