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

  module Ifs = Interfaces.Make(struct
    let xlen = 32
    let start_addr = 0
  end)
  module I = Decoder.Make_insn_decoder(Ifs)(B)

  let insn = I.((decoder instr).insn) 

end

module Ref = struct

  let idxs = [ (* in insn vector order...arghh *)
    `lui; `auipc; `jal; `jalr;
    `beq; `bne; `blt; `bge; `bltu; `bgeu;
    `lb; `lh; `lw; `lbu; `lhu;
    `sb; `sh; `sw;
    `addi; `slti; `sltiu; `xori; `ori; `andi;
    `slli; `srli; `srai;
    `add; `sub; `sll; `slt; `sltu; `xor_; `srl; `sra; `or_; `and_;
    `fence; `fence_i;
  ]

  (* fix up the shift immediate instructions *)
  let rv32i_mask_match = 
    let mm = Riscv.RV32I.T.mask_match in
    let fix x = 
      let ms,mt = List.assoc x mm in
      x, (Int32.(logor ms 0x02000000l), mt) in
    let mm' = List.map (fun x -> fix x) [ `slli; `srli; `srai ] in
    mm' @ mm

  (* simple reference implementation *)
  let insn = 
    let x = List.map (fun x -> List.assoc x rv32i_mask_match) idxs in
    let x = x @ 
      List.map (fun i -> List.assoc i Riscv.RVSYS.T.mask_match) [
        `scall; `sbreak
      ] 
    in
    let x = x @ 
      List.map (fun i -> List.assoc i Riscv.RVPSEUDO.T.mask_match) [
        `_rdcycle; `_rdcycleh; `_rdtime; `_rdtimeh; `_rdinstret; `_rdinstreth; 
      ] 
    in
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

