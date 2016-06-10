(* The CSR instructions encode an immediate address in the top 12 bits.  Not
   all addresses are valid, however; it depends on what registers are implemented.

   Here, we expand the csrrX instructions into multiple mask/match pairs that
   encode the valid addresses.  Further, care has to be taken not to generate
   patterns which write to read-only registers (when rs1=0, the write is diabled
   for csrrs and csrrc).
 *)
let rec filter_none = function [] -> [] 
                             | None::t -> filter_none t 
                             | Some(x)::t -> x::filter_none t

let is_ro = 
  let open Csr.Specs in 
  function URO | SRO | HRO | MRO -> true | _ -> false 
let is_rw x = not (is_ro x)

let get_ro_csrs csrs = 
  List.map (fun csr -> List.assoc csr Csr.Specs.all_csrs) csrs
  |> List.filter (fun csr -> is_ro csr.Csr.Specs.priv) 

let get_rw_csrs csrs = 
  List.map (fun csr -> List.assoc csr Csr.Specs.all_csrs) csrs
  |> List.filter (fun csr -> is_rw csr.Csr.Specs.priv) 

let ro_csrs csrs = 
  let csrs = get_ro_csrs csrs in
  List.map (fun csr -> csr.Csr.Specs.addr) csrs

let rw_csrs csrs = 
  let csrs = get_rw_csrs csrs in
  List.map (fun csr -> csr.Csr.Specs.addr) csrs

let get_csrs insns csrs (csr_insns : Config.V.t list) = 
 
  let insns = 
    List.filter (fun x -> not (List.mem x csr_insns)) Config.V.list |>
    List.map (fun x -> List.assoc x Config.T.mask_match) 
  in

  let csrs csr_insn = 
    let mask, mat = List.assoc csr_insn Config.T.mask_match in
    filter_none @@
    List.map 
      (fun csr -> 
        let csr = List.assoc csr Csr.Specs.all_csrs in
        let addr = Int32.of_int csr.Csr.Specs.addr in
        let ro = (csr.Csr.Specs.addr lsr 10) = 3 in
        if ro && (csr_insn = `csrrw || csr_insn = `csrrwi) then None
        else 
          let addr_mask = if ro then 0xFFFF_8000l else 0xFFF0_0000l in
          let addr = Int32.shift_left addr 20 in
          Some(Int32.logor mask addr_mask, Int32.logor mat addr)) 
      csrs
  in

  insns, List.map csrs csr_insns

let get_simple_csrs insns csrs = 
  get_csrs insns csrs [ `csrrs ]

let get_full_csrs insns csrs = 
  get_csrs insns csrs [ `csrrw; `csrrs; `csrrc; `csrrwi; `csrrsi; `csrrci ]


