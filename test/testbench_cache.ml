(* test the cache implementation *)

open HardCaml.Api
open Printf

module Waveterm_waves = HardCamlWaveTerm.Wave.Make(HardCamlWaveTerm.Wave.Bits(B))
module Waveterm_sim = HardCamlWaveTerm.Sim.Make(B)(Waveterm_waves)
module Waveterm_ui = HardCamlWaveLTerm.Ui.Make(B)(Waveterm_waves)

module C = Cache.Make(struct
  let data = 32
  let addr = 32
  let line = 2 (* 4 words / line *)
  let size = 4 (* 16 lines *)
end)

let wave_cfg = 
  let f (n,b) = n, Waveterm_waves.(if b=1 then B else H) in
  Some(C.I.(to_list @@ map f t) @ C.O.(to_list @@ map f t))

let testbench () = 

  let module G = Interface.Gen(C.I)(C.O) in

  let circ,sim,i,o,_ = G.make "direct_mapped_cache" C.direct_mapped in
  let sim, waves = Waveterm_sim.wrap ?cfg:wave_cfg sim in

  Cs.reset sim;
 
  let open C.I in
  let open C.O in

  i.clr := B.vdd;
  Cs.cycle sim;
  i.clr := B.gnd;

  i.en := B.vdd;
  i.addr := B.consti 32 0;
  Cs.cycle sim;
  if !(o.hit) = [1] then begin
    printf "hit!\n";
  end else begin
    printf "miss!\n";
  end;

  for j=0 to 10 do
    Cs.cycle sim;
  done;

  Lwt_main.run (Waveterm_ui.run Waveterm_waves.({ cfg=default; waves }));
  Printf.printf "done.\n%!"

let () = testbench ()

