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
module Ui = Ui.Make(B)
open Ui

(* memory model *)
module D = Utils.D32(B) 
module Mem = Utils.Mem(D) 

module Waves = struct

  let decode_insn b = 
    if B.(to_int (b ==:. 0) = 1) then "---"
    else if B.(to_int (msb b)) = 1 then "TRAP"
    else
      let idx = B.(to_int (onehot_to_binary b)) in
      Insn.T.(Show_t.show (Enum_t.to_enum idx))

  let signal_display = function (n,b) -> 
    let open Waveterm_waves in
    match n with
    | "dec_insn" | "fet_insn" | "alu_insn" | "mem_insn" | "com_insn" ->
      n, F(decode_insn)
    | _ -> 
      if b=1 then n, B
      else n, H

  (* configure waveform display *)
  let wave_cfg = 
    let open Waveterm_waves in

    let interleave = true in
    let stage_sigs1 = Rv.Ifs.Stages.(to_list @@ map signal_display t) in
    let stage_sigs2 = List.concat @@ 
      Rv.Ifs.Stage.(to_list @@ 
        map (fun (n,b) ->
          List.map signal_display
            [ "fet_" ^ n, b; "dec_" ^ n, b; "alu_" ^ n, b; 
              "mem_" ^ n, b; "com_" ^ n, b; ]) t)
    in
    let stage_sigs = if interleave then stage_sigs2 else stage_sigs1 in

    Some( 
      [signal_display ("clk",1); signal_display ("clr",1)] @
      Rv.Ifs.I.(to_list @@ map signal_display t) @ 
      Rv_o.(to_list @@ map signal_display t) @
      [ ("pipe_en",B); ("pipe_bubble",B) ] @
      stage_sigs @ 
      (Array.to_list @@ Array.init 31 (fun i -> sprintf "reg_%.2i" (i+1), H)) 
    )

  let is_prefixed pre str = 
    (String.length pre <= String.length str) && 
      (String.sub str 0 (String.length pre) = pre)

  let get_wave_class pre waves =
    let open Waveterm_waves in
    let get_waves = List.filter (function
      | Clock _ -> true
      | Binary(n,_) when is_prefixed pre n -> true
      | Data(n,_,_) when is_prefixed pre n -> true
      | _ -> false)
    in
    Array.of_list @@ get_waves @@ Array.to_list waves

  let wave_classes waves = 
    [
      `all, waves;
      `regs, get_wave_class "reg_" waves;
      `fetch, get_wave_class "fet_" waves;
      `decode, get_wave_class "dec_" waves;
      `execute, get_wave_class "alu_" waves;
      `memory, get_wave_class "mem_" waves;
      `commit, get_wave_class "com_" waves;
    ]

  let init_waves sim = 
    let sim, waves = Waveterm_sim.wrap ?cfg:wave_cfg sim in
    sim, waves

  let show_waves waves = 
    let ui = Ui.make_ui (wave_classes waves) in
    Lwt_main.run (Waveterm_ui.run_widget ui.vbox)

end

let get_core () = 
  let pipeline inp = Rv.Build.p5 ~inp ~f_output:Rv_output.o in
  let module G = HardCaml.Interface.Gen(B)(Rv.Ifs.I)(Rv_o) in
  G.make "rv32i" pipeline 

open HardCaml.Api 
open Rv.Ifs 
open I 
open O 
open Rv_o 

let mio_data i o memory = 
  let open Mi_data in
  let open Mo_data in
  (*let o = o.o in*)
  let o = o.md in
  i.I.md.Mi_data.vld := B.gnd;
  if B.to_int !(o.req) = 1 then begin
    i.md.vld := B.vdd;
    if B.to_int !(o.rw) = 1 then begin
      i.md.rdata := D.to_signal @@ Mem.read ~memory ~addr:!(o.addr)
    end else begin
      Mem.write ~memory ~addr:!(o.addr) ~data:!(o.wdata) ~strb:!(o.wmask)
    end
  end

let mio_instr i o memory = 
  let open Mi_instr in
  let open Mo_instr in
  (*let o = o.o in*)
  let o = o.mi in
  (* XXX memif must hold data *)
  if B.to_int !(o.req) = 1 then begin
    i.I.mi.Mi_instr.rdata := D.to_signal @@ Mem.read ~memory ~addr:!(o.addr)
  end

(* test data path of 5 stage pipeline *)
let testbench_5 memory = 

  let circ,sim,i,o,o' = get_core () in

  (* waveform viewer *)
  let sim, waves = Waves.init_waves sim in

  let cycle () = 
    mio_instr i o memory;
    mio_data i o memory;
    Cs.cycle sim 
  in

  Cs.reset sim;
  i.clr := B.vdd;
  cycle();
  i.clr := B.gnd;
  for i=0 to 20 do
    cycle();
  done;

  Waves.show_waves waves

let testbench_5_lwt memory = 

  let circ,sim,i,o,o' = get_core () in

  (* waveform viewer *)
  let sim, waves = Waves.init_waves sim in

  let ctrl, incr_cycles = Lwt_stream.create () in

  let cycle_count = ref 0 in
  let testbench () = 

    let cycle () = 
      cycle_count := !cycle_count + 1;
      mio_instr i o memory;
      mio_data i o memory;
      Cs.cycle sim;
      Lwt_unix.yield () 
    in
    let rec cycles () = 
      let run n_cycles = 
        let start = !cycle_count in
        let end_ = !cycle_count + n_cycles - 1 in
        for_lwt i=start to end_ do
          cycle ()
        done
      in
      lwt n_cycles = Lwt_stream.next ctrl in
      lwt () = run n_cycles in
      cycles ()
    in

    Cs.reset sim;
    i.clr := B.vdd;
    lwt () = cycle() in
    i.clr := B.gnd;

    cycles ()
  in

  let (waiter, wakener) as exit = Lwt.wait () in
  let ui = Ui.make_ui (Waves.wave_classes waves) in

  (* various events related to setting the cycle *)
  Ui.(ui.wave_ctrl.quit)#on_click (Lwt.wakeup wakener);
  Ui.(ui.wave_ctrl.step.right)#on_click (fun () -> incr_cycles @@ Some 1);

  (* update the waveform every 1/4 second. *)
  let open Lwt in
  let prev_cycle_count = ref 0 in
  let rec update_loop () = 
    begin (* monitor the cycle count, and update as necessary *)
      if !cycle_count <> !prev_cycle_count then begin
        prev_cycle_count := !cycle_count;
        ui.Ui.waveform#update_wave_cycles; ui.Ui.waveform#queue_draw
      end;
    end;
    Lwt_unix.sleep 0.25 >> update_loop ()
  in

  let run = 
    lwt r = testbench () and () = update_loop () in
    Lwt.return r
  in

  let main () = Waveterm_ui.run_widget_testbench ~exit ui.Ui.vbox run in
  ignore @@ Lwt_main.run (main ()) 

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
  testbench_5_lwt memory



