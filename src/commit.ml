module Make(Ifs : Interfaces.S) = struct

  open HardCaml.Signal.Comb
  open Ifs

  let name = "com"

  let commit ~mem =
    let open Stage in
    let open Stages in
    let open Class in
    let p = mem in
    let i = p.iclass in
    let branch = i.jal |: i.jalr |: (i.bra &: p.branch) in
    let rdd = mux2 (i.jal |: i.jalr) (p.pc +:. 4) p.rdd in
    let pc = p.rdd in (* jal + jalr *)

    { mem with branch; rdd; pc; }

  let f ~inp ~comb ~pipe = 
    let open Stages in
    commit ~mem:pipe.mem

end
