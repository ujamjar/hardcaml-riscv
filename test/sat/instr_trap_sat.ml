(* Use a SAT checker to ensure the instruction
 * decoder is valid.
 *
 * We check on a vector which encodes a bit for
 * each of the base RV32I instructions and a 
 * trap bit.
 *
 * In the 'riscv' project we have a mask/match 
 * specification of all the instructions generated
 * from https://github.com/riscv/riscv-opcodes/blob/master/opcodes
 * This allows us to build a simple model of expected
 * instruction decodings with the trap simply being
 * nothing valid was decoded.
 *
 *
 * We then put the formula:
 *
 * (reference_model <> rtl_model) 
 *
 * through the SAT checker - if it produces UNSAT then
 * the checker cannot find any inputs which make
 * the circuits differ and they must therefore be
 * equivalent.
 *)

module B = HardCamlBloop.Gates.Comb

let instr = B.input "instr" 32

(* circuit we want to ensure is correct *)
module Rtl = struct

  module Ifs = Interfaces.Make(Config.RV32I_base)
  module I = Decoder.Make_insn_decoder(Ifs)(B)

  let insn = I.((decoder instr).insn) 

end

(* reference implementation *)
module Ref = struct

  let insn = 
    let x = List.map (fun x -> List.assoc x Riscv.RV32I.T.mask_match) Insn.V.list in
    let open B in
    let f (mask,mat) = 
      (instr &: (consti32 32 mask)) ==: consti32 32 mat
    in
    let insn = List.map f x in
    let trap = ~: (reduce (|:) insn) in
    B.concat (trap :: List.rev insn)

end

(* if we can find a case where they are not equal then we failed *)
let insn_ok = B.(Rtl.insn <>: Ref.insn)

(* should print UNSAT if the circuits are equivalent *)
let ok = HardCamlBloop.Sat.(report @@ of_signal insn_ok)

