open HardCaml.Signal.Comb

module W = interface a[1] b[3] end
module X = HardCamlRiscV.Interface_ex.Make(W)

let i = W.{a=consti 1 0; b=consti 3 2 } 
let j = W.{a=consti 1 1; b=consti 3 3 } 


