(* requires hardcaml-bloop *)

open HardCamlRiscV
open Printf 

module B = HardCamlBloop.Gates.Make_comb(HardCamlBloop.Gates.Basic_gates)
(*module B = HardCaml.Signal.Comb*)

module Make(B : HardCaml.Comb.S) = struct

  module Cfg = struct
    let xlen = 32
    let start_addr = 0x10
  end

  module Ifs = Interfaces.Make(Cfg)
  module F = Fetch.Make(Ifs)(B)
  module D = Decoder.Make(Ifs)(B)
  module X = Alu.Make(Ifs)(B)
  module M = Mem.Make(Ifs)(B)
  module C = Commit.Make(Ifs)(B)

  let z (_,b) = B.zero b
  let inp (n,b) = B.input n b

  let st_zero = Ifs.Stage.(map z t)
  let sts_zero = Ifs.Stages.(map z t)
  let inp_zero = Ifs.I.(map z t)
  let mi_zero = Ifs.Mi_instr.(map z t)
  let md_zero = Ifs.Mi_data.(map z t)

  let st_inp = Ifs.Stage.(map inp t)
  let inp_inp = Ifs.I.(map inp t)
  let mi_inp = Ifs.Mi_instr.(map inp t)
  let md_inp = Ifs.Mi_data.(map inp t)
  let reduce_st st = Ifs.Stage.(B.reduce B.(|:) @@ B.bits @@ B.concat @@ to_list st)

  let rf ra1 ra2 =
    let open B in
    let regs = 
      Array.to_list @@
      Array.init 32 
        (fun i -> 
          if i=0 then zero 32
          else input ("r"^string_of_int i) 32)
    in
    mux ra1 regs,
    mux ra2 regs

  let build_cpu ~pc ~instr ~rdata = 
    let open Ifs.Stage in
    let open Ifs.Stages in
    
    let fet, mi = F.f ~inp:inp_zero ~comb:sts_zero 
      ~pipe:{ sts_zero with com = { st_zero with pc } }
    in
    
    let dec = D.f 
      ~inp:{ inp_zero with Ifs.I.mi =  { mi_zero with Ifs.Mi_instr.rdata = instr } }
      ~comb:sts_zero 
      ~pipe:{ sts_zero with fet }
    in

    (* model register file as inputs (apart from r0 they are basically like inputs) *)
    let rd n ra = B.(mux2 (ra ==:. 0) (zero 32) (input ("reg_rd"^n) 32)) in
    let rd1, rd2 = rd "1" dec.ra1, rd "2" dec.ra2 in
    let dec = { dec with rd1; rd2 } in

    let alu = X.f ~inp:inp_zero ~comb:sts_zero 
      ~pipe:{ sts_zero with dec }
    in

    let mem, md = M.f 
      ~inp:{ inp_zero with Ifs.I.md = { md_zero with Ifs.Mi_data.rdata = rdata } }
      ~comb:sts_zero 
      ~pipe:{ sts_zero with alu }
    in

    let com = C.f ~inp:inp_zero ~comb:sts_zero 
      ~pipe:{ sts_zero with mem }
    in

    com, rd1, rd2

  (*******************************************************************************)

  let funct3 m = B.select m 14 12
  let funct7 m = B.select m 31 25
  let opcode m = B.select m 6 0

  module I = struct

    type 'a t = 
      {
        rd : 'a;
        rs1 : 'a;
        imm : 'a;
      }

    let make m = 
      let rd = B.input "rd" 5 in
      let rs1 = B.input "rs1" 5 in
      let imm = B.input "imm" 12 in
      let m = B.consti32 32 m in
      let instr = 
        B.concat [
          imm;
          rs1;
          funct3 m;
          rd;
          opcode m;
        ]
      in
      instr, { rd; rs1; imm }

  end

  module I_shift = struct

    type 'a t = 
      {
        rd : 'a;
        rs1 : 'a;
        imm : 'a;
      }

    let make m = 
      let rd = B.input "rd" 5 in
      let rs1 = B.input "rs1" 5 in
      let imm = B.input "imm" 5 in
      let m = B.consti32 32 m in
      let instr = 
        B.concat [
          B.select m 31 25;
          imm;
          rs1;
          funct3 m;
          rd;
          opcode m;
        ]
      in
      instr, { rd; rs1; imm }

  end

  module R = struct

    type 'a t = 
      {
        rd : 'a;
        rs1 : 'a;
        rs2 : 'a;
      }

    let make m = 
      let rd = B.input "rd" 5 in
      let rs1 = B.input "rs1" 5 in
      let rs2 = B.input "rs2" 5 in
      let instr = 
        B.concat [
          funct7 m;
          rs2;
          rs1;
          funct3 m;
          rd;
          opcode m;
        ]
      in
      instr, { rd; rs1; rs2 }

  end

  open B
  open Ifs.Stage

  let imm instr f = 
    let _,match' = List.assoc instr Riscv.RV32I.T.mask_match in
    let rdata = B.input "rdata" 32 in
    let pc = B.input "pc" 32 in
    let instr, data = I.make match' in
    let x,rd1,rd2 = build_cpu ~pc ~instr ~rdata in
    (x.rdd ==: (f rd1 (sresize data.I.imm 32))) &:
    (x.rad ==: data.I.rd) &:
    x.rwe

  let imm_shift instr f = 
    let _,match' = List.assoc instr Riscv.RV32I.T.mask_match in
    let rdata = B.input "rdata" 32 in
    let pc = B.input "pc" 32 in
    let instr, data = I_shift.make match' in
    let x,rd1,rd2 = build_cpu ~pc ~instr ~rdata in
    (x.rdd ==: (f rd1 data.I_shift.imm)) &:
    (x.rad ==: data.I_shift.rd) &:
    x.rwe

  let reg instr f = 
    let _,match' = List.assoc instr Riscv.RV32I.T.mask_match in
    let rdata = B.input "rdata" 32 in
    let pc = B.input "pc" 32 in
    let instr, data = I.make match' in
    let x,rd1,rd2 = build_cpu ~pc ~instr ~rdata in
    (x.rdd ==: (f rd1 rd2)) &:
    (x.rad ==: data.I.rd) &:
    x.rwe

end

module Core = Make(B)

(*******************************************************************************)

let verbose = false
let check x = HardCamlBloop.Sat.(report @@ of_signal ~solver:`minisat ~verbose (B.(~:) x))

(*******************************************************************************)

open Core
open Ifs.Stage
open B

let test core name instr f = 
  let cost c = HardCamlBloop.(Expr.cost (snd @@ counts Expr.Uset.empty c)) in
  let core = core instr f in
  printf "%s[%i]...%!" name (cost core);
  check core

(* Register-immediate instructions *)

let () = test Core.imm "addi" `addi (+:)
let () = test Core.imm "andi" `andi (&:)
let () = test Core.imm "ori" `ori (|:)
let () = test Core.imm "xori" `xori (^:)
let () = test Core.imm "slti" `slti (fun a b -> uresize (a <+ b) 32)
let () = test Core.imm "sltiu" `sltiu (fun a b -> uresize (a <: b) 32)

let () = test Core.imm_shift "slli" `slli (fun a b -> log_shift sll a b)
let () = test Core.imm_shift "srli" `srli (fun a b -> log_shift srl a b)
let () = test Core.imm_shift "srai" `srai (fun a b -> log_shift sra a b)
(* LUI AUIPC *)

(* Register-Register instructions *)

let () = test Core.reg "add" `add (+:)

