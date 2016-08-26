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

let solver = ref `mini
let () = 
  let solver_args = [
    "mini", (fun () -> solver := `mini);
    (*"pico", (fun () -> solver := `pico);*)
    "crypto", (fun () -> solver := `crypto);
    "dimacs-mini", (fun () -> solver := `dimacs `mini);
    "dimacs-pico", (fun () -> solver := `dimacs `pico);
    "dimacs-crypto", (fun () -> solver := `dimacs `crypto);
  ] in
  Arg.parse
  [
    "-solver", Arg.Symbol(List.map fst solver_args, 
                         (fun s -> (List.assoc s solver_args)())),
              "select solver"
  ]
  (fun _ -> ())
  "HardCamlRiscV instruction decoder+trap SAT tests"

module G = HardCamlBloop.Gates.Comb
module B = HardCaml.Bits.Comb.IntbitsList
module Ifs = Interfaces.Make(Config.RV32I_machine)

(* circuit we want to ensure is correct *)
module Rtl(B : HardCaml.Comb.S) = struct

  module I = Decoder.Make_insn_decoder(Ifs)(B)

  let insn instr = 
    let i,trap = I.decoder instr in
    B.(i.I.insn @: trap)

end

(* reference implementation *)
module Ref(B : HardCaml.Comb.S) = struct

  let insn instr = 
    let open B in
    let f (mask,mat) = (instr &: (consti32 32 mask)) ==: consti32 32 mat in
    let insn, csrs = Gencsr.get_full_csrs Config.V.list Ifs.csrs in
    let insn = List.map f insn in
    let csrs = List.map (List.map f) csrs in
    let reduce_or l = if l=[] then gnd else reduce (|:) l in
    let insn = insn @ (List.map (reduce_or) csrs) in (* hack; ordering is subtle *)
    let trap = ~: (reduce (|:) insn) in
    B.(concat (List.rev insn) @: trap)

end

module Rtl_g = Rtl(G)
module Ref_g = Ref(G)
module Rtl_b = Rtl(B)
module Ref_b = Ref(B)

(* if we can find a case where they are not equal then we failed *)
let insn_ok = 
  let instr = G.input "instr" 32 in
  G.(Rtl_g.insn instr <>: Ref_g.insn instr)

let qed = 
"   ____    __________ 
  / __ \\  / ____/ __ \\
 / / / / / __/ / / / /
/ /_/ / / /___/ /_/ / 
\\___\\_\\/_____/_____/  "

let myreport x = 
  let open Printf in
  let open HardCamlBloop in
  let open Sat in
  match x with
  | `unsat -> printf "%s\n" qed
  | `sat(soln,_) -> begin
      let open B in
      let vec = List.assoc "instr" soln in
      let ins = string_of_vec_result ("",vec) |> const in
      let print s i = printf "%-8s = %s [%x]\n" s (to_bstr i) (to_int i) in
      print "instr"  ins;
      print "opcode" ins.[6:0];
      print "rd"     ins.[11:7];
      print "rs1"    ins.[19:15];
      print "rs2"    ins.[24:20];
      print "funct3" ins.[14:12];
      print "funct7" ins.[31:25];
      print "imm12"  ins.[31:20];
      print "imm20"  ins.[31:12];
      print "ref"    (Ref_b.insn ins);
      print "rtl"    (Rtl_b.insn ins)
  end

(* should print UNSAT if the circuits are equivalent *)
let ok = HardCamlBloop.Sat.(myreport @@ of_signal ~solver:!solver insn_ok)

