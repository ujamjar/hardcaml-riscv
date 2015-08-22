open HardCamlRiscV
open HardCaml.Signal.Comb

module Cfg = struct
  let xlen = 32
  let start_addr = 0x10
end

module Rv = Pipe.Make(Cfg)
module B = HardCaml.Api.B
(*
module Rv_o = Rv.Ifs.O_debug
module Rv_output = Rv.Output_debug
*)
module Rv_o = Rv.Ifs.O
module Rv_output = Rv.Output

let f_stages = [| 
  (module Rv.Fetch : Rv.Stage); 
  (module Rv.Decoder : Rv.Stage); 
  (module Rv.Alu : Rv.Stage); 
  (module Rv.Mem : Rv.Stage); 
  (module Rv.Commit : Rv.Stage);
|]

let pipeline = Rv.build_pipeline ~f_stages ~f_output:Rv_output.f
let comb = Rv.build_comb ~f_stages ~f_output:Rv_output.f

let write_circ name circ = 
  let f = open_out ("test/rv32i_rtl/" ^ name ^ ".v") in
  HardCaml.Rtl.Verilog.write (output_string f) circ;
  close_out f

let write_pipe_stage name stage p = 
  let module P = (val p : Rv.Stage) in
  let inp = Rv.Ifs.I.(map (fun (n,b) -> input n b) t) in
  let module Seq = Utils.Regs(struct let clk=inp.Rv.Ifs.I.clk let clr=inp.Rv.Ifs.I.clr end) in
  let pipe = Array.init 5 (fun j -> 
    Rv.Ifs.Stage.(map (fun (n,b) -> Seq.reg ~e:vdd (input (n^"_p_"^string_of_int j) b)) t)) 
  in
  let comb = Array.init 5 (fun j -> 
    Rv.Ifs.Stage.(map (fun (n,b) -> Seq.reg ~e:vdd (input (n^"_c_"^string_of_int j) b)) t)) 
  in
  let o = P.f ~n:stage ~inp ~comb ~pipe in
  let o = Rv.Ifs.Stage.(map2 (fun o (n,b) -> n,o) o t) in
  let o = 
    Rv.Ifs.Stage.to_list o 
    (*|> List.filter (fun (n,o) -> not (is_const x)) o*) 
    |> List.map (fun (n,o) -> output n (Seq.reg ~e:vdd o))
  in
  let circ = HardCaml.Circuit.make name o in
  write_circ name circ

let write_core () = 
  let module G = HardCaml.Interface.Circ(Rv.Ifs.I)(Rv_o) in
  let circ = G.make "rv32i" comb in
  write_circ "rv32i" circ

let () = write_pipe_stage "fetch" 0 (module Rv.Fetch : Rv.Stage)
let () = write_pipe_stage "decoder" 1 (module Rv.Decoder : Rv.Stage)
let () = write_pipe_stage "alu" 2 (module Rv.Alu : Rv.Stage)
let () = write_pipe_stage "memory" 3 (module Rv.Mem : Rv.Stage)
let () = write_pipe_stage "commit" 4 (module Rv.Commit : Rv.Stage)
let () = write_core()

