open HardCamlRiscV
open Printf

(* rv32 core *)
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

(* waveform viewer *)
module Waveterm_waves = HardCamlWaveTerm.Wave.Make(HardCamlWaveTerm.Wave.Bits(B))
module Waveterm_sim = HardCamlWaveTerm.Sim.Make(B)(Waveterm_waves)
module Waveterm_ui = HardCamlWaveLTerm.Ui.Make(B)(Waveterm_waves)
let waves = true

(* memory model *)
module D = Utils.D32(B) 
module Mem = Utils.Mem(D) 

(* configure waveform display *)
let wave_cfg = 
  let open Waveterm_waves in

  let decode_insn b = 
    if B.(to_int (b ==:. 0) = 1) then "---"
    else if B.(to_int (msb b)) = 1 then "TRAP"
    else
      let idx = B.(to_int (onehot_to_binary b)) in
      Insn.T.(Show_t.show (Enum_t.to_enum idx))
  in

  let f = function (n,b) -> 
    match n with
    | "dec_insn" | "fet_insn" | "alu_insn" | "mem_insn" | "com_insn" ->
      n, F(decode_insn)
    | _ -> 
      if b=1 then n, B
      else n, H
  in

  let interleave = true in
  let stage_sigs1 = Rv.Ifs.Stages.(to_list @@ map f t) in
  let stage_sigs2 = List.concat @@ 
    Rv.Ifs.Stage.(to_list @@ 
      map (fun (n,b) ->
        List.map f
          [ "fet_" ^ n, b; "dec_" ^ n, b; "alu_" ^ n, b; 
             "mem_" ^ n, b; "com_" ^ n, b; ]) t)
  in
  let stage_sigs = if interleave then stage_sigs2 else stage_sigs1 in

  Some( 
    [f ("clk",1); f ("clr",1)] @
    Rv.Ifs.I.(to_list @@ map f t) @ 
    Rv_o.(to_list @@ map f t) @
    [ ("pipe_en",B); ("pipe_bubble",B) ] @
    stage_sigs @ 
    (Array.to_list @@ Array.init 31 (fun i -> sprintf "reg_%.2i" (i+1), H)) 
  )

let init_waves sim = 
    if waves then 
      let sim, waves = Waveterm_sim.wrap ?cfg:wave_cfg sim in
      sim, Some(waves)
    else sim, None

let show_waves = function
  | None -> ()
  | Some(waves) ->
    Lwt_main.run (Waveterm_ui.run Waveterm_waves.({ cfg=default; waves }))

(* test data path of 5 stage pipeline *)
let testbench_5 () = 

  let pipeline inp = Rv.Build.p5 ~inp ~f_output:Rv_output.f in

  let open HardCaml.Api in
  let module G = HardCaml.Interface.Gen(B)(Rv.Ifs.I)(Rv_o) in
  let circ,sim,i,o,o' = G.make "rv32i" pipeline in

  (* waveform viewer *)
  let sim, waves = init_waves sim in

  let sim = 
    let module Vcd = HardCaml.Vcd.Make(B) in
    let f = open_out "dump.vcd" in
    Vcd.wrap (output_string f) sim
  in

  let open Rv.Ifs in
  let open I in
  let open O in
  let open Rv_o in

  (* memory *)
  let memory = Mem.init (8*1024) in (* 32 Kib *)

  (* test program *)
  let () = 
    let open Riscv.RV32I.Asm in
    memory.(4) <- addi ~rd:1 ~rs1:0 ~imm:10;
    memory.(5) <- addi ~rd:2 ~rs1:0 ~imm:20;
    memory.(6) <- add ~rd:3 ~rs1:1 ~rs2:2;
  in

  (* todo; fix me *)
  let mio_data () = 
    let open Mi_data in
    let open Mo_data in
    (*let o = o.o in*)
    let o = o.md in
    i.md.vld := B.gnd;
    if B.to_int !(o.req) = 1 then begin
      i.md.vld := B.vdd;
      if B.to_int !(o.rw) = 1 then begin
        i.md.rdata := D.to_signal @@ Mem.read ~memory ~addr:!(o.addr)
      end else begin
        Mem.write ~memory ~addr:!(o.addr) ~data:!(o.wdata) ~strb:!(o.wmask)
      end
    end
  in

  let mio_instr () = 
    let open Mi_instr in
    let open Mo_instr in
    (*let o = o.o in*)
    let o = o.mi in
    (* note; ignoring req signal, which is not properly generated here *)
    i.mi.rdata := D.to_signal @@ Mem.read ~memory ~addr:!(o.addr)
  in

  let cycle () = 
    mio_instr();
    mio_data();
    Cs.cycle sim 
  in


  Cs.reset sim;
  i.clr := B.vdd;
  cycle();
  i.clr := B.gnd;
  for i=0 to 20 do
    cycle();
  done;

  show_waves waves;
  printf "Done.\n"

let () = testbench_5 ()


