(* requires hardcaml-bloop *)

open HardCamlRiscV
open Printf 

module B = HardCamlBloop.Gates.Comb
(*module B = HardCaml.Signal.Comb*)

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
let st_zero = Ifs.Stage.(map z t)
let sts_zero = Ifs.Stages.(map z t)
let inp_zero = Ifs.I.(map z t)
let mi_zero = Ifs.Mi_instr.(map z t)
let md_zero = Ifs.Mi_data.(map z t)

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

  (*let rd1,rd2 = rf dec.ra1 dec.ra2 in
  let dec = { dec with rd1; rd2 } in*)
  let rd1, rd2 = B.input "reg_rd1" 32, B.input "reg_rd2" 32 in
  let dec = { dec with rd1; rd2 } in

  let alu = X.f ~inp:inp_zero ~comb:sts_zero 
    ~pipe:{ sts_zero with dec }
  in
(*
  let mem, md = M.f 
    ~inp:{ inp_zero with Ifs.I.md = { md_zero with Ifs.Mi_data.rdata = rdata } }
    ~comb:sts_zero 
    ~pipe:{ sts_zero with alu }
  in

  let com = C.f ~inp:inp_zero ~comb:sts_zero 
    ~pipe:{ sts_zero with mem }
  in

  mi, md, com
*)
  alu, rd1, rd2

let check x = HardCamlBloop.Sat.(report @@ of_signal ~sharing:false ~verbose:true (B.(~:) x))

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

let mask_match = Riscv.RV32I.T.mask_match

open Ifs.Stage
open B

let test_addi () = 
  let _,match' = List.assoc `addi mask_match in
  let rdata = B.input "rdata" 32 in
  let pc = B.input "pc" 32 in
  let instr, data = I.make match' in
  let x,rd1,rd2 = build_cpu ~pc ~instr ~rdata in
  printf "addi...%!";
  check 
    (x.rdd ==: (rd1 +: (sresize data.I.imm 32)))
  
let () = test_addi ()

