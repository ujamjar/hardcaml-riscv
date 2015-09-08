(* check the various immediate encodings *)

open HardCaml.Api
open HardCamlRiscV
open Riscv.RV32I

module Ifs = Interfaces.Make(struct
  let xlen = 32
  let start_addr = 0x10
end)
module D = Decoder.Make_insn_decoder(Ifs)(B)

let dec instr = 
  let instr = B.consti32 32 instr in
  let t = D.decoder instr in 
  let instr = D.imm ~c:t.D.iclass ~instr ~imm_uj:(D.imm_uj instr) in
  B.to_sint instr

let () = 
  let myassert a b = 
    if a <> b then failwith (Printf.sprintf "ASSERT: %i %i\n" a b)
  in
 
  (* exhaustively check the ranges of all constants *)

  (* i-type; basic signed 12 bit constant *) 
  for i=(-2048) to 2047 do
    myassert (dec (Asm.addi ~rd:0 ~rs1:0 ~imm:i)) i;
  done;

  (* s-type; 12 bit store offset *)
  for i=(-2048) to 2047 do
    myassert (dec (Asm.sw ~rs1:0 ~rs2:0 ~imm:i)) i;
  done;

  (* sb-type; 12 bit conditional branch offset, multiplied by 2 *)
  for i=(-2048) to 2047 do
    myassert (dec (Asm.beq ~rs1:0 ~rs2:0 ~imm:(i*2))) (i*2);
  done;

  (* u-type; lui, auipc - loads upper 20 bits of dest *)
  for i=(-(1 lsl 19)) to (1 lsl 19)-1 do
    myassert (dec (Asm.lui ~rd:0 ~imm:(i*4096))) (i*4096);
  done;

  (* uj-type; 20 bit constant for jal, multiplied by 2 *)
  for i=(-(1 lsl 19)) to (1 lsl 19)-1 do
    myassert (dec (Asm.jal ~rd:0 ~imm:(i*2))) (i*2);
  done;

  Printf.printf "OK\n"

