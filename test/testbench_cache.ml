(* test the cache implementation *)

open HardCaml.Api
open Printf

module Waveterm_waves = HardCamlWaveTerm.Wave.Make(HardCamlWaveTerm.Wave.Bits(B))
module Waveterm_sim = HardCamlWaveTerm.Sim.Make(B)(Waveterm_waves)
module Waveterm_ui = HardCamlWaveLTerm.Ui.Make(B)(Waveterm_waves)

module Cfg = struct
  let data = 32
  let addr = 32
  let line = 2 (* 4 words / line *)
  let size = 4 (* 16 lines *)
end

module Cache = Cache.Make(Cfg)

let wave_cfg = 
  let f (n,b) = n, Waveterm_waves.(if b=1 then B else H) in
  Some(Cache.I.(to_list @@ map f t) @ Cache.O.(to_list @@ map f t))

let testbench () = 

  let module G = Interface.Gen(Cache.I)(Cache.O) in

  let circ,sim,i,o,_ = G.make "direct_mapped_cache" Cache.direct_mapped in
  let sim, waves = Waveterm_sim.wrap ?cfg:wave_cfg sim in

  Cs.reset sim;
 
  let open Cache.I in
  let open Cache.O in

  i.clr := B.vdd;
  Cs.cycle sim;
  i.clr := B.gnd;

  let ldbits = HardCaml.Utils.clog2 Cfg.data - 3 in
  let cache_line_words = 1 lsl Cfg.line in
  let cache_line_addr = 
    let mask = lnot ((1 lsl (Cfg.line+ldbits)) - 1) in
    fun addr -> addr land mask
  in
  let mem = Array.init (16*1024) (fun i -> i) in

  let mem_get_cache_line addr = 
    let addr = cache_line_addr addr in
    Array.init cache_line_words (fun i -> mem.(i + (addr / (Cfg.data/8))))
  in
  let mem_set_cache_line addr data = 
    let addr = cache_line_addr addr in
    for i=0 to cache_line_words-1 do
      mem.(i + (addr / (Cfg.data/8))) <- data.(i)
    done
  in

  let mem_write_cache_line addr data = 
    i.men := B.vdd;
    i.mrw := B.gnd;
    for j=0 to (1 lsl Cfg.line)-1 do
      i.maddr := B.consti Cfg.addr (addr + (j * (Cfg.data/8)));
      i.mdata := B.consti Cfg.data data.(j);
      Cs.cycle sim;
    done;
    i.men := B.gnd;
  in

  let mem_read_cache_line addr = 
    let data = Array.init cache_line_words (fun _ -> 0) in
    i.men := B.vdd;
    i.mrw := B.vdd;
    i.maddr := B.consti Cfg.addr addr;
    Cs.cycle sim;
    for j=1 to cache_line_words-1 do
      i.maddr := B.consti Cfg.addr (addr+(j * (Cfg.data/8)));
      Cs.cycle sim;
      data.(j-1) <- B.to_int !(o.data);
    done;
    Cs.cycle sim;
    data.(cache_line_words-1) <- B.to_int !(o.data);
    i.men := B.gnd;
    data;
  in

  let dump d = 
    for i=0 to Array.length d - 1 do printf "%i " d.(i) done;
    printf "\n"
  in

  (* XXX this doesn't allow pipelining.  we need to test that too.
   *     there are some issues with overlapping reads/writes I think *)
  let rec pipe_read_cache addr =
    i.pen := B.vdd;
    i.prw := B.vdd;
    i.paddr := B.consti Cfg.addr addr;
    Cs.cycle sim;
    i.pen := B.gnd;
    Cs.cycle sim;
    let hit = B.to_int !(o.hit) in
    if hit = 1 then
      let data = B.to_int !(o.data) in
      printf "hit=%i\n" data;
      data
    else begin
      printf "miss...";
      mem_write_cache_line addr (mem_get_cache_line addr);
      pipe_read_cache addr
    end
  in

  (*i.pen := B.vdd;
  i.paddr := B.consti 32 0;
  Cs.cycle sim;
  i.pen := B.gnd;
  if B.to_int !(o.hit) = 1 then begin
    printf "hit!\n";
  end else begin
    printf "miss!\n";
  end;*)

  (*mem_write_cache_line 0 [| 10; 20; 30; 40 |];
  mem_write_cache_line 32 [| 11; 21; 31; 41 |];

  dump (mem_read_cache_line 0);
  dump (mem_read_cache_line 32);*)

  pipe_read_cache 0;
  pipe_read_cache 16;
  pipe_read_cache 0;
  pipe_read_cache 4;

  for j=0 to 10 do
    Cs.cycle sim;
  done;

  printf "%!";
  Lwt_main.run (Waveterm_ui.run Waveterm_waves.({ cfg=default; waves }));
  printf "%!done.\n%!"

let () = testbench ()

