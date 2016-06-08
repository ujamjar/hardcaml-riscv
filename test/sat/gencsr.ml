(* we need to treat csr's specially depending on how the core was built *)

let get_csrs insns csrs (csr_insns : Config.V.t list) = 
 
  let insns = 
    List.filter (fun x -> not (List.mem x csr_insns)) Config.V.list |>
    List.map (fun x -> List.assoc x Config.T.mask_match) 
  in

  let csrs csr = 
    let mask, mat = List.assoc csr Config.T.mask_match in
    List.map (fun csr -> 
        let csr = List.assoc csr Csr.Specs.all_csrs in
        let addr = Int32.of_int csr.Csr.Specs.addr in
        let ro = (csr.Csr.Specs.addr lsr 10) = 3in
        let addr_mask = if ro then 0xFFFF_8000l else 0xFFF0_0000l in
        let addr = Int32.shift_left addr 20 in
        Int32.logor mask addr_mask, Int32.logor mat addr) csrs
  in

  insns, List.map csrs csr_insns

let get_simple_csrs insns csrs = 
  get_csrs insns csrs [ `csrrs ]

let get_full_csrs insns csrs = 
  get_csrs insns csrs [ `csrrw; `csrrs; `csrrc; `csrrwi; `csrrsi; `csrrci ]


