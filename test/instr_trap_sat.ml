(*
 * It is fairly easy to decode the instruction
 * set - we must also ensure that we trap on illegal
 * instructions and this can be a little bit subtle.
 *
 * In the 'riscv' project we have a mask/match 
 * specification of all the instructions generated
 * from https://github.com/riscv/riscv-opcodes/blob/master/opcodes
 * This allows us to build a simple model of when to
 * expect a trap (the input is not one of the listed
 * instructions).
 *
 * We compare our proper RTL implementation with
 * this reference version using a sat checker to
 * check if they are equivalent.  If they are then
 * we have not bugs!  Pretty cool stuff actually...
 *
 *)

module B = HardCamlBloop.Gates.Comb
module D = HardCamlRiscV.Pipe.Make(struct
  let xlen = 32
  let start_addr = 0
end)
module I = D.Decoder2.Make(B)

let instr = B.input "instr" 32

(* circuit we want to ensure is correct *)
let trap = I.decoder instr

(* simple reference implementation *)
let trap_ref = 
  let x = List.map snd Riscv.RV32I.T.mask_match in
  let x = x @ 
    List.map (fun i -> List.assoc i Riscv.RVPSEUDO.T.mask_match) [
      `_rdtime; `_rdinstret; `_rdcycle;
      `_rdtimeh; `_rdinstreth; `_rdcycleh;
    ] 
  in
  let x = x @ 
    List.map (fun i -> List.assoc i Riscv.RVSYS.T.mask_match) [
      `scall; `sbreak
    ] 
  in
  let open B in
  let f (mask,mat) = 
    (instr &: (consti32 32 mask)) ==: consti32 32 mat
  in
  ~: (reduce (|:) (List.map f x)) 

(* if we can find a case where they are not equal then we failed *)
let trap_ok = B.(trap <>: trap_ref)

(* should print UNSAT if the circuits are equivalent *)
let ok = HardCamlBloop.Sat.(report @@ of_signal trap_ok)

