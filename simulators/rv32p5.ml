open HardCamlRiscV
open Printf

(* 32 bit core *)
open Cfg32
open Mem32

open HardCaml.Api 
open Rv.Ifs 
open I 
open O 
open Rv_o 

let get_core () = 
  let pipeline inp = Rv.Build.p5 ~inp ~f_output:Rv_output.o in
  let module G = HardCaml.Interface.Gen(B)(Rv.Ifs.I)(Rv_o) in
  G.make "rv32p5" pipeline 

let () = 
  (* memory *)
  let memory = Mem.init (32*1024) in 
  (* test program *)
  let () = 
    let open Riscv.RV32I.Asm in
    memory.(4) <- addi ~rd:1 ~rs1:0 ~imm:10;
    memory.(5) <- addi ~rd:2 ~rs1:0 ~imm:20;
    memory.(6) <- add ~rd:3 ~rs1:1 ~rs2:2;
    memory.(7) <- sub ~rd:4 ~rs1:2 ~rs2:1;
    memory.(8) <- jal ~rd:0 ~imm:8;
  in
  Testbench.run get_core memory

