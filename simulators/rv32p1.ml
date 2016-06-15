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

let test () = 
  let memory = Mem.init (32*1024) in 
  let () = Asm_gen.test ~memory ~start_addr:0x10 "csrs" in
  Testbench.run get_core memory 

let elf () = 
  let module E = Load_elf.Make(Mem32.Mem) in
  let memory = Mem.init (32*1024*1024) in 
  let _ = E.to_mem "firmware/firmware.elf" memory in
  Testbench.run get_core memory

let () = test ()

