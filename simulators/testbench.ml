(* shared testbench code *)

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

let run get_core memory = 

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

    (*Cs.reset sim;*)
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

