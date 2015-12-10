module Make(Ifs : Interfaces.S) = struct

  open HardCaml.Signal.Comb
  open Ifs

  let name = "com"

  let f ~inp ~comb ~pipe = 
    let open Stage in
    let open Stages in
    let open Class in
    let p = pipe.mem in
    let i = p.iclass in
    let branch = i.jal |: i.jalr |: (i.bra &: p.branch) in
    let rdd = mux2 (i.jal |: i.jalr) (p.pc +:. 4) p.rdd in
    let pc = p.rdd in (* jal + jalr *)

    { pipe.mem with branch; rdd; pc; }

end
