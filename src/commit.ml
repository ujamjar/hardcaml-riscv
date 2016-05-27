module Make(Ifs : Interfaces.S) = struct

  open HardCaml.Signal.Comb
  open Ifs

  let name = "com"

  let (--) s n = s -- ("com_" ^ n)

  let commit ~mem =
    let open Stage in
    let open Stages in
    let open Class in
    let p = mem in
    let i = p.iclass in
    let branch = (i.jal |: i.jalr |: (i.bra &: p.branch)) -- "branch" in
    let pc_next = p.pc +:. 4 in
    let rdd = mux2 (i.jal |: i.jalr) pc_next p.rdd in
    let pc = mux2 branch p.rdd pc_next in

    { mem with branch; rdd; pc; }

  let f ~inp ~comb ~pipe = 
    let open Stages in
    commit ~mem:pipe.mem

end
