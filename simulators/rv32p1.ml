open HardCamlRiscV
open Printf

(* 32 bit core *)
open Cfg32
open Mem32

let test = ref (List.assoc "csrs" Asm_gen.tests)
let elf = ref ""
let mem_kb = ref 32

let () = 
  Arg.parse
    [
      "-test", Arg.Symbol(List.map fst Asm_gen.tests,
                         fun s -> test := List.assoc s Asm_gen.tests), "asm test";
      "-elf", Arg.Set_string(elf), "load elf file";
      "-mem", Arg.Set_int(mem_kb), "memory size in KiB";
    ]
    (fun _ -> ())
    "HardCamlRiscV simulator"

let get_core () = 
  let pipeline inp = Rv.Build.p1 ~inp ~f_output:Rv_output.o in
  let module G = HardCaml.Interface.Gen(B)(Rv.Ifs.I)(Rv_o) in
  G.make "rv32p1" pipeline 

let test () = 
  let memory = Mem.init (!mem_kb*1024) in 
  let () = 
    if !elf = "" then begin
      !test ~memory ~start_addr:0x10;
    end else begin
      let module E = Load_elf.Make(Mem32.Mem) in
      ignore @@ E.to_mem "firmware/firmware.elf" memory;
    end
  in
  Testbench.run get_core memory 

let () = test ()

