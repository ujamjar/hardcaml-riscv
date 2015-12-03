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

exception Timeout
let testbench_3 () = 

  let module C = struct
    module Dm = Scache.Direct_mapped(Cfg) 
    module Ctrl = Scache.Controller(Cfg) 

    module I = interface
      clk[1] clr[1]
      (* pipeline interface *)
      paddr[Cfg.addr] pdata[Cfg.data] pre[1] pwe[1]
      (* memory interface *)
      mvld[1] mdata_i[Cfg.data]
      txfer_i[32]
    end
    module O = interface
      stall[1] data_o[Cfg.data]
      mreq[1] maddr[Cfg.addr] mdata_o[Cfg.data] mrw[1]
      state[4] (* XXX *)
      txfer_o[32] (* XXX *)
    end

    open Comb

    let f i = 
      let open I in
      let module Seq = Utils.Regs(struct let clk=i.clk let clr=i.clr end) in

      let dm_msel = wire 1 in
      let dm_maddr = wire Cfg.addr -- "dm_maddr" in
      let dm_mdata = wire Cfg.data -- "dm_mdata" in
      let dm_mre = wire 1 in
      let dm_mwe = wire 1 in

      let dm_i = {
        Dm.I.clk = i.clk;
        clr = i.clr;
        msel = dm_msel;
        paddr = i.paddr;
        pdata = i.pdata;
        pre = i.pre;
        pwe = i.pwe;
        maddr = dm_maddr;
        mdata = dm_mdata;
        mre = dm_mre;
        mwe = dm_mwe;
      } in
      let dm_o = Dm.f dm_i in

      let ctrl_i = {
        Ctrl.I.clk = i.clk;
        clr = i.clr;
        miss = dm_o.Dm.O.miss -- "MISS";
        rw = i.pre;
        dirty = dm_o.Dm.O.dirty;
        addr = i.paddr;
        evict_addr = dm_o.Dm.O.evict_addr;
        mvld = i.mvld;
        mdata_i = i.mdata_i;
        cdata_i = Seq.reg ~e:vdd dm_o.Dm.O.data_o; (* XXX *)
      } in
      let ctrl_o = Ctrl.f ctrl_i in

      let () = 
        let open Ctrl.O in
        dm_msel <== ctrl_o.msel;
        dm_maddr <== ctrl_o.caddr;
        dm_mdata <== ctrl_o.cdata_o;
        dm_mre <== ctrl_o.cre;
        dm_mwe <== ctrl_o.cwe;
      in

      let open Ctrl.O in
      O.{
        stall = ctrl_o.stall;
        data_o = dm_o.Dm.O.data_o;
        mreq = ctrl_o.mreq;
        maddr = ctrl_o.maddr;
        mdata_o = ctrl_o.mdata_o;
        mrw = ctrl_o.mrw;
        state = ctrl_o.state;
        txfer_o = i.txfer_i;
      }
  end in
  (*let module G = Gen(C) in*)
  let module G = Interface.Gen(C.I)(C.O)  in

  let get_state x = 
    try
      let i = B.to_int x in
      match i with
      | 0 -> "RESET"
      | _ -> 
        let s = (HardCaml.Utils.nbits i) - 1 in
        C.Ctrl.Sm.(Show_t.show (Enum_t.to_enum s)) ^ string_of_int i
    with _ -> "XXX"
  in

  let wave_cfg =
    let open Waveterm_waves in
    let f (n,b) = 
      match n with
      | "state" -> n, (F get_state)
      | _ -> n, (if b=1 then B else H) 
    in
    let x = [ "dm_mdata", H; "dm_maddr", H ] in
    Some(C.I.(to_list @@ map f t) @ C.O.(to_list @@ map f t) @ x)
  in

  let circ,sim,i,o,_ = G.make "cache" C.f in
  let sim, waves = Waveterm_sim.wrap ?cfg:wave_cfg sim in

  let show_waves () = 
    if !show_waves then begin 
      Lwt_main.run (Waveterm_ui.run Waveterm_waves.({ cfg=default; waves })) 
    end
  in

  let open C.I in
  let open C.O in

  (* initialised with the byte address *)
  let mem = Array.init (16*1024) (fun j -> B.consti Cfg.data (j*4)) in
  let mem_ref = Array.init (16*1024) (fun j -> B.consti Cfg.data (j*4)) in
  let dump_mem () = 
    let ofs = ref 0 in
    for i=0 to 2 do (* XXX whole cache *)
      for s=0 to (1 lsl Cfg.size) - 1 do
        let ofs' = ref !ofs in
        for l=0 to (1 lsl Cfg.line) - 1 do
          printf "%.8x " (B.to_int mem.(!ofs'));
          incr ofs'
        done;
        printf "| ";
        let ofs' = ref !ofs in
        for l=0 to (1 lsl Cfg.line) - 1 do
          printf "%.8x " (B.to_int mem_ref.(!ofs'));
          incr ofs'
        done;
        printf "| ";
        let ofs' = ref !ofs in
        for l=0 to (1 lsl Cfg.line) - 1 do
          printf "%.8x " B.(to_int (mem.(!ofs') ^: mem_ref.(!ofs')));
          incr ofs'
        done;
        ofs := !ofs';
        printf "\n"
      done;
      printf "\n"
    done
  in

  let cycle () = 
    if !(o.mreq) = B.vdd && !(i.mvld) = B.gnd then begin
      let addr = B.to_int !(o.maddr) in
      assert (addr land 3 = 0);
      i.mvld := B.vdd;
      if !(o.mrw) = B.vdd then begin
        printf "  RD %.8x %.8x\n" addr (B.to_int mem.(addr/4));
        i.mdata_i := mem.(addr/4)
      end else begin
        printf "  WR %.8x %.8x\n" addr (B.to_int !(o.mdata_o));
        mem.(addr/4) <- !(o.mdata_o)
      end
    end else begin
      i.mvld := B.gnd;
    end;
    Cs.cycle sim;
  in

  Cs.reset sim;
  i.clr := B.vdd;
  Cs.cycle sim;
  i.clr := B.gnd;

  let words_per_cline = 1 lsl (Cfg.line+Cfg.size) in
  let bytes_per_cline = words_per_cline * Cfg.data/8 in
  let num_clines = 1 lsl Cfg.line in
  let transfer_no = ref 0 in
  let transfers = [|
    (* reads from 1st cache line *)
    Some(`rd 12); (* load line into cache *)
    Some(`rd 0);
    Some(`rd 8);
    (* 2nd cache line *)
    Some(`rd 16); (* load line into cache *)
    Some(`rd 20);
    Some(`rd 24);
    (* reload 1st cache line from 2nd set of aliased pages *)
    Some(`rd bytes_per_cline);
    Some(`wr (bytes_per_cline+4, 0x23)); (* write, set dirty *)
    Some(`rd (bytes_per_cline+4)); (* read back just written data *)
    (* evict (dirty) 1st cache line with a read *)
    Some(`rd (2*bytes_per_cline));
(*    Some(`rd (bytes_per_cline+4)); (* read back just written data *)*)
  |] in

  i.pre := B.gnd;
  i.pwe := B.gnd;

  let set_rd addr = 
    i.pre := B.vdd;
    i.paddr := B.consti Cfg.addr addr;
  in
  let set_wr addr data = 
    i.pwe := B.vdd;
    i.paddr := B.consti Cfg.addr addr;
    i.pdata := B.consti Cfg.data data;
  in
  let do_txfer () = 
    let timeout = ref 0 in
    Cs.cycle_comb0 sim;
    if B.to_int !(o.stall) = 1 then begin
      while B.to_int !(o.stall) = 1 do
        cycle ();
        incr timeout;
        if !timeout > 100 then raise Timeout
      done;
    end else begin
      cycle ();
    end;
    i.pre := B.gnd;
    i.pwe := B.gnd;
  in

  let run_transfer transfer = 
    match transfer with
    | None -> begin
      cycle ();
    end
    | Some(`rd addr) -> begin
      set_rd addr;
      do_txfer ();
      printf "* RD %.8x %.8x [%.8x]\n" addr (B.to_int !(o.data_o)) (B.to_int mem_ref.(addr/4))
    end
    | Some(`wr(addr,data)) -> begin
      set_wr addr data;
      do_txfer ();
      printf "* WR %.8x %.8x\n" addr data;
      mem_ref.(addr/4) <- B.consti 32 data;
    end
    | _ -> failwith "unexpected transfer" 
  in

  let tests () = 
    for j=0 to Array.length transfers-1 do
      printf "TRANSFER[%i]\n%!" !transfer_no;
      i.txfer_i := B.consti 32 !transfer_no;
      run_transfer transfers.(!transfer_no);
      transfer_no := !transfer_no + 1;
    done
  in

  let flush () = 
    (* perform reads to each cacheline at 2 different addresses to
     * ensure whatever was in there got flushed.  XXX need proper HW support! *)
    i.txfer_i := B.consti32 32 0xdeadbeefl;
    for j=0 to (2*num_clines)-1 do
      printf "FLUSHING %i\n%!" j;
      run_transfer (Some(`rd(j*bytes_per_cline)))
    done
  in

  begin try 
    tests ();
    for i=0 to 25 do cycle () done;
    flush ();
    for i=0 to 25 do cycle () done;
    dump_mem ();
  with Timeout -> printf "XXX TIMEOUT XXX\n" end;

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


