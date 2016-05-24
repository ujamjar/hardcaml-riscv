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
  G.make "rv32i" pipeline 

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

  Ui.make_ui_events ui cycle_count incr_cycles;

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

  let main () = Ui.Waveterm_ui.run_widget_testbench ~exit ui.Ui.vbox run in
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

