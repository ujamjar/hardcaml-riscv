(* test the cache implementation *)

open HardCaml.Api
open Printf

let show_waves = ref false
let test_num = ref 0

let () = Arg.parse [
  "-w", Arg.Set(show_waves), "show waveform";
  "-t", Arg.Set_int(test_num), "test number";
] (fun arg -> raise (Failure arg)) "cache testbench"

module Waveterm_waves = HardCamlWaveTerm.Wave.Make(HardCamlWaveTerm.Wave.Bits(B))
module Waveterm_sim = HardCamlWaveTerm.Sim.Make(B)(Waveterm_waves)
module Waveterm_ui = HardCamlWaveLTerm.Ui.Make(B)(Waveterm_waves)

module Cfg = struct
  let data = 32
  let addr = 32
  let line = 2 (* 4 words / line *)
  let size = 4 (* 16 lines *)
end

module Dmap = Cache.Direct_mapped(Cfg)
module Ctrl = Cache.Controller(Cfg)

module type IO = sig
  module I : HardCaml.Interface.S
  module O : HardCaml.Interface.S
  val f : Comb.t I.t -> Comb.t O.t
end

module Gen(C : IO) = struct

  module G = Interface.Gen(C.I)(C.O) 

  let wave_cfg =
    let f (n,b) = n, Waveterm_waves.(if b=1 then B else H) in
    Some(C.I.(to_list @@ map f t) @ C.O.(to_list @@ map f t))

  let circ,sim,i,o,_ = G.make "cache" C.f
  let sim, waves = Waveterm_sim.wrap ?cfg:wave_cfg sim 

  let show_waves () = 
    if !show_waves then begin 
      Lwt_main.run (Waveterm_ui.run Waveterm_waves.({ cfg=default; waves })) 
    end

  (*let reset_and_clear () = 
    let open C.I in
    Cs.reset sim;
    i.clr := B.vdd;
    Cs.cycle sim;
    i.clr := B.gnd*)

end


let ldbits = HardCaml.Utils.clog2 Cfg.data - 3 
let cache_line_words = 1 lsl Cfg.line 
let cache_line_addr = 
  let mask = lnot ((1 lsl (Cfg.line+ldbits)) - 1) in
  fun addr -> addr land mask

let cache_word_idx = 
  let mask = lnot (((1 lsl Cfg.line)-1) lsl ldbits) in
  (fun addr -> (addr land mask) lsr ldbits)

let dump d = 
  for i=0 to Array.length d - 1 do printf "%i " d.(i) done;
  printf "\n"

let testbench_0 () = 

  let module G = Gen(Dmap) in
  let open G in
  let open Dmap.I in
  let open Dmap.O in

  Cs.reset sim;
  i.clr := B.vdd;
  Cs.cycle sim;
  i.clr := B.gnd;

  let mem = Array.init 128 (fun i -> i) in

  let mem_get_cache_line addr = 
    let addr = cache_line_addr addr in
    printf "mgcl: %i - " addr;
    let x = Array.init cache_line_words (fun i -> mem.(i + (addr / (Cfg.data/8)))) in
    dump x;
    x
  in
  let mem_set_cache_line addr data = 
    let addr = cache_line_addr addr in
    for i=0 to cache_line_words-1 do
      mem.(i + (addr / (Cfg.data/8))) <- data.(i)
    done
  in

  let mem_write_cache_line addr data = 
    let addr = cache_line_addr addr in
    i.msel := B.vdd;
    i.mwe := B.gnd;
    for j=0 to (1 lsl Cfg.line)-1 do
      let addr = addr + (j * (Cfg.data/8)) in
      printf "wcl: %i %i\n" addr data.(j);
      i.maddr := B.consti Cfg.addr addr;
      i.mdata := B.consti Cfg.data data.(j);
      Cs.cycle sim;
    done;
    i.msel := B.gnd;
  in

  let mem_read_cache_line addr = 
    let addr = cache_line_addr addr in
    let data = Array.init cache_line_words (fun _ -> 0) in
    i.msel := B.vdd;
    i.mre := B.vdd;
    i.maddr := B.consti Cfg.addr addr;
    Cs.cycle sim;
    for j=1 to cache_line_words-1 do
      i.maddr := B.consti Cfg.addr (addr+(j * (Cfg.data/8)));
      Cs.cycle sim;
      data.(j-1) <- B.to_int !(o.data);
    done;
    Cs.cycle sim;
    data.(cache_line_words-1) <- B.to_int !(o.data);
    i.msel := B.gnd;
    data;
  in

  let read_all_cache () = 
    Array.concat @@
    Array.to_list @@ 
    Array.init (1 lsl Cfg.size) 
      (fun j -> 
        let addr = j lsl (Cfg.line + ldbits) in
        mem_read_cache_line addr)
  in

  (*let flush_cache () = 
    (* XXX but only for valid cache lines !!! *)
    for j=0 to 1 lsl Cfg.line do
      let addr = j lsl (Cfg.line + ldbits) in
      mem_set_cache_line addr (mem_read_cache_line addr); 
    done
  in*)

  (* XXX this doesn't allow pipelining.  we need to test that too.
   *     there are some issues with overlapping reads/writes I think *)
  let rec pipe_read_cache addr =
    i.pre := B.vdd;
    i.paddr := B.consti Cfg.addr addr;
    Cs.cycle sim;
    Cs.cycle_comb0 sim;
    let hit = B.to_int !(o.hit) in
    if hit = 1 then begin
      let data = B.to_int !(o.data) in
      printf "rd hit  addr=%i data=%i\n" addr data;
      data
    end else begin
      printf "rd miss addr=%i\n" addr;
      mem_write_cache_line addr (mem_get_cache_line addr);
      pipe_read_cache addr
    end
  in

  let rec pipe_write_cache addr data = 
    i.pwe := B.gnd;
    i.paddr := B.consti Cfg.addr addr;
    i.pdata := B.consti Cfg.data data;
    Cs.cycle sim;
    Cs.cycle_comb0 sim;
    let hit = B.to_int !(o.hit) in
    if hit = 1 then begin
      printf "wr hit  adder=%i\n" addr
    end else begin
      let waddr = B.to_int !(o.waddr) in
      let wdata = B.to_int !(o.data) in
      printf "wr miss addr=%i waddr=%i\n" addr waddr;
      (* write the old cache line back into memory (XXX if dirty) *)
      let cdata = mem_read_cache_line waddr in
      cdata.(cache_word_idx waddr) <- wdata;
      mem_set_cache_line waddr cdata;
      (* load new cache line *)
      mem_write_cache_line addr (mem_get_cache_line addr);
      pipe_write_cache addr data
    end
  in

  (*pipe_read_cache (3*4) |> ignore;*)

  (* cycle through the cache *)
  for j=0 to 63 do
    pipe_read_cache (j*4) |> ignore;
  done;
(*
  (* load the first cache line *)
  pipe_read_cache 0 |> ignore;
  pipe_write_cache 4 77;
*)

  pipe_write_cache 256 7;
  (*pipe_write_cache (256+2*4) 7;*)

  dump (read_all_cache ());

  dump mem;

  for j=0 to 10 do Cs.cycle sim; done;

  printf "%!";
  show_waves();
  printf "%!testbench_0 done.\n%!"

(* basic tests on the front end cache logic *)
let testbench_1 () = 
  let module G = Gen(Dmap) in
  let open G in
  let open Dmap.I in
  let open Dmap.O in

  Cs.reset sim;
  i.clr := B.vdd;
  Cs.cycle sim;
  i.clr := B.gnd;

  let cycle () = 
    Cs.cycle sim;
    Cs.cycle_comb0 sim;
    let hit, miss, dirty = 
      B.(to_int !(o.hit)),
      B.(to_int !(o.miss)),
      B.(to_int !(o.dirty))
    in
    printf "hit=%i miss=%i dirty=%i " hit miss dirty;
    if hit=1 then begin
      printf "data = %i\n" B.(to_int !(o.data))
    end else if miss=1 then begin
      printf "DO SOMETHING!\n"
    end else begin
      printf "\n"
    end
  in

  i.pre := B.vdd;
  i.paddr := B.consti Cfg.addr 0;
  cycle();
  i.pre := B.gnd;
  for j=0 to 10 do Cs.cycle sim; done;

  printf "%!";
  show_waves ();
  printf "%!testbench_1 done.\n%!"

(* test the cache controller *)
let testbench_2 () = 
  let module G = Gen(Ctrl) in
  let open G in
  let open Ctrl.I in
  let open Ctrl.O in

  (* initialised with the byte address *)
  let mem = Array.init (16*1024) (fun j -> B.consti Cfg.data (j*4)) in

  Cs.reset sim;
  i.clr := B.vdd;
  Cs.cycle sim;
  i.clr := B.gnd;
  
  let pipe_read addr = 
    i.miss := B.vdd;
    i.addr := B.consti Cfg.addr addr;
    i.rw := B.vdd;
    i.dirty := B.gnd;
  in

  let pipe_write addr data = 
    i.miss := B.vdd;
    i.addr := B.consti Cfg.addr addr;
    i.rw := B.gnd;
    i.dirty := B.vdd;
  in

  pipe_write 20 0;

  let cycle () = 
    if !(o.mreq) = B.vdd && !(i.mvld) = B.gnd then begin
      let addr = B.to_int !(o.maddr) in
      i.mvld := B.vdd;
      if !(o.mrw) = B.vdd then begin
        i.mdata_i := mem.(addr)
      end else begin
        mem.(addr) <- !(o.mdata_o)
      end
    end else begin
      i.mvld := B.gnd;
    end;
    Cs.cycle sim;
    i.miss := B.gnd;
  in

  for i=0 to 25 do
    cycle ()
  done;

  printf "%!";
  show_waves ();
  printf "%!testbench_2 done.\n%!"

(*module Mux(B : HardCaml.Comb.S)(X : HardCaml.Interface.S) = struct
  let lists n = 
    let e = X.map (fun _ -> []) X.t in
    let rec f n l = 
      match n with
      | [] -> l
      | h::t -> f t (X.map2 (fun e l -> e :: l) h l)
    in
    X.map List.rev (f n e)

  let mux s x = X.map (B.mux s) (lists x)
  let mux2 s x y = mux s [y; x]
end*)

let testbench_3 () = 

  let module C = struct
    module I = interface
      clk[1] clr[1]
      (* pipeline interface *)
      paddr[Cfg.addr] pdata[Cfg.data] pre[1] pwe[1]
      (* memory interface *)
      mvld[1] mdata_i[Cfg.data]
    end
    module O = interface
      stall[1] data_o[Cfg.data]
      mreq[1] maddr[Cfg.addr] mdata_o[Cfg.data] mrw[1]
    end
    open Comb
    let f i = 
      let module Dm = Cache.Direct_mapped(Cfg) in
      let module Ctrl = Cache.Controller(Cfg) in
      let open I in

      let dm_i = {
        Dm.I.clk = i.clk;
        clr = i.clr;
        paddr = i.paddr;
        pdata = i.pdata;
        pre = i.pre;
        pwe = i.pwe;
        msel = gnd;
        maddr = zero Cfg.addr;
        mdata = zero Cfg.data;
        mre = gnd;
        mwe = gnd;
      } in
      let dm_o = Dm.f dm_i in

      let ctrl_i = {
        Ctrl.I.clk = i.clk;
        clr = i.clr;
        miss = dm_o.Dm.O.miss;
        rw = gnd;
        dirty = dm_o.Dm.O.dirty;
        addr = zero Cfg.addr;
        paddr = zero Cfg.addr;
        mvld = gnd;
        mdata_i = zero Cfg.data;
        cdata_i = zero Cfg.data;
      } in
      let ctrl_o = Ctrl.f ctrl_i in

      O.{
        stall = gnd;
        data_o = zero Cfg.data;
        mreq = gnd;
        maddr = zero Cfg.addr;
        mdata_o = zero Cfg.data;
        mrw = gnd;
      }
  end in
  let module G = Gen(C) in
  let open G in
  let open C.I in
  let open C.O in

  (* initialised with the byte address *)
  let mem = Array.init (16*1024) (fun j -> B.consti Cfg.data (j*4)) in

  Cs.reset sim;
  i.clr := B.vdd;
  Cs.cycle sim;
  i.clr := B.gnd;

  let cycle () = Cs.cycle sim in

  for i=0 to 25 do
    cycle ()
  done;

  printf "%!";
  show_waves ();
  printf "%!testbench_3 done.\n%!"

(* run test *)
let () = [|
  testbench_0;
  testbench_1;
  testbench_2;
  testbench_3;
|].(!test_num) ()


