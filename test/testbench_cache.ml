(* test the cache implementation *)

open HardCaml.Api
open Printf

let show_waves = ref false

let () = Arg.parse [
  "-w", Arg.Set(show_waves), "show waveform";
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

exception Timeout

let testbench () = 
  let module C = Scache.Make_direct_mapped(Cfg) in

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
  printf "%!testbench done.\n%!"

(* run test *)
let () = testbench ()


