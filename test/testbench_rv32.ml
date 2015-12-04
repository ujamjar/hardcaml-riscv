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
      n, Waveterm_waves.F(decode_insn)
    | _ -> 
      if b=1 then n, Waveterm_waves.B
      else n, Waveterm_waves.H
  in
  Some( 
    [f ("clk",1); f ("clr",1)] @
    Rv.Ifs.I.(to_list @@ map f t) @ 
    Rv_o.(to_list @@ map f t) @
    Rv.Ifs.Stages.(to_list @@ map f t) @
    (Array.to_list @@ Array.init 31 (fun i -> sprintf "reg_%.2i" (i+1), Waveterm_waves.H)) )

let init_waves sim = 
    if waves then 
      let sim, waves = Waveterm_sim.wrap ?cfg:wave_cfg sim in
      sim, Some(waves)
    else sim, None

let show_waves = function
  | None -> ()
  | Some(waves) ->
    Lwt_main.run (Waveterm_ui.run Waveterm_waves.({ cfg=default; waves }))
(*
(* test single stage core *)
let testbench_1 () = 

  let pipeline = 
    Rv.build_comb
      ~f_stages:[| 
        (module Rv.Fetch : Rv.Stage); 
        (module Rv.Decoder : Rv.Stage); 
        (module Rv.Alu : Rv.Stage); 
        (module Rv.Mem : Rv.Stage); 
        (module Rv.Commit : Rv.Stage);
      |]
      ~f_output:Rv_output.f
  in

  let open HardCaml.Api in
  let module G = HardCaml.Interface.Gen(B)(Rv.Ifs.I)(Rv_o) in
  let circ,sim,i,o,o' = G.make "rv32i" pipeline in

  (* waveform viewer *)
  let sim, waves = init_waves sim in

  let open Rv.Ifs in
  let open I in
  let open O in
  let open Rv_o in

  let memory = Mem.init (8*1024) in (* 32 Kib *)

  let () = begin
    let open Riscv.RV32I.Asm in
    (*for i=0 to 1024-1 do
      memory.(i) <- Int32.of_int (i*4);
    done;*)
    let nop = addi ~rd:0 ~rs1:0 ~imm:0 in
    memory.( 4) <- addi ~rd:1 ~rs1:0 ~imm:100;
    memory.( 5) <- addi ~rd:2 ~rs1:0 ~imm:50;
    memory.( 6) <- add ~rd:3 ~rs1:1 ~rs2:2;
    memory.( 7) <- sw ~rs1:2 ~rs2:3 ~imm:0; 
    memory.( 8) <- lw ~rs1:1 ~rd:4 ~imm:300; 
    memory.( 9) <- jal ~rd:5 ~imm:8;
    memory.(10) <- 0l; 
    memory.(11) <- jalr ~rd:6 ~rs1:5 ~imm:12;
    memory.(12) <- 0l; 
    memory.(13) <- xor_ ~rd:0 ~rs1:0 ~rs2:0;
    memory.(14) <- bne ~rs1:1 ~rs2:2 ~imm:8; (* skip next *)
    memory.(15) <- 0l;
    memory.(16) <- beq ~rs1:1 ~rs2:2 ~imm:8; (* dont jump *)
    memory.(17) <- and_ ~rd:0 ~rs1:0 ~rs2:0;
    (* check lui and auipc *)
    memory.(18) <- lui ~rd:10 ~imm:(12*4096);
    memory.(19) <- auipc ~rd:11 ~imm:(13*4096);
    memory.(100) <- 0x999l;
  end in

  let mio_data () = 
    let open Mi_data in
    let open Mo_data in
    let o = o.o.md in
    (*let o = o.md in*)
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
    let o = o'.o.mi in
    (*let o = o'.mi in*)
    i.mi.rdata := D.to_signal @@ Mem.read ~memory ~addr:!(o.addr)
  in

  let cycle () = 
    mio_instr();
    Cs.cycle_comb0 sim;
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
*)
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


