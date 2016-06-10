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
  let pipeline inp = Rv.Build.p1 ~inp ~f_output:Rv_output.o in
  let module G = HardCaml.Interface.Gen(B)(Rv.Ifs.I)(Rv_o) in
  G.make "rv32p1" pipeline 

let old () = 
  (* memory *)
  let memory = Mem.init (32*1024) in 
  (* test program *)
  let () = 
    let open Riscv.RV32I_MACHINE.Asm in
    (*memory.(4) <- addi ~rd:1 ~rs1:0 ~imm:10;
    memory.(5) <- addi ~rd:2 ~rs1:0 ~imm:20;
    memory.(6) <- andi ~rd:3 ~rs1:2 ~imm:20;
    memory.(7) <- add ~rd:7 ~rs1:1 ~rs2:2;
    memory.(8) <- sub ~rd:8 ~rs1:2 ~rs2:1;
    memory.(9) <- jal ~rd:9 ~imm:8;*)

    (*memory.(4) <- addi ~rd:1 ~rs1:0 ~imm:10;
    memory.(5) <- jalr ~rd:2 ~rs1:1 ~imm:10; *)
    for i=0 to 100 do
      memory.(i) <- xori ~rd:0 ~rs1:0 ~imm:0;
    done;
    memory.(4) <- addi ~rd:1 ~rs1:0 ~imm:0x2AD;
    memory.(5) <- addi ~rd:2 ~rs1:0 ~imm:0x1F8;
    memory.(6) <- csrrw ~rd:3 ~rs1:1 ~imm:0x701;
    memory.(7) <- csrrw ~rd:4 ~rs1:2 ~imm:0x741;
    memory.(8) <- csrrw ~rd:5 ~rs1:0 ~imm:0x701;
    memory.(9) <- csrrw ~rd:6 ~rs1:0 ~imm:0x741;
    memory.(9) <- csrrc ~rd:17 ~rs1:1 ~imm:0x741;
  in
  Testbench.run get_core memory

let elf () = 
  let module E = Load_elf.Make(Mem32.Mem) in
  let memory = Mem.init (32*1024*1024) in 
  let _ = E.to_mem "firmware/firmware.elf" memory in
  Testbench.run get_core memory

let () = old ()

