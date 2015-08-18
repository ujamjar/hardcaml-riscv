open HardCamlRiscV

module Cfg = struct
  let xlen = 32
  let start_addr = 0x10
end

module Rv = Pipe.Make(Cfg)
module B = HardCaml.Api.B
module Rv_o = Rv.Ifs.O_debug
module Rv_output = Rv.Output_debug

let pipeline = 
  Rv.build_pipeline
    ~f_stages:[| 
      (module Rv.Fetch : Rv.Stage); 
      (module Rv.Decoder : Rv.Stage); 
      (module Rv.Alu : Rv.Stage); 
      (module Rv.Mem : Rv.Stage); 
      (module Rv.Commit : Rv.Stage);
    |]
    ~f_output:Rv_output.f

module Waveterm_waves = HardCamlWaveTerm.Wave.Make(HardCamlWaveTerm.Wave.Bits(B))
module Waveterm_sim = HardCamlWaveTerm.Sim.Make(B)(Waveterm_waves)
module Waveterm_ui = HardCamlWaveLTerm.Ui.Make(B)(Waveterm_waves)

let waves = true

let testbench () = 

  let open HardCaml.Api in
  let module G = HardCaml.Interface.Gen(B)(Rv.Ifs.I)(Rv_o) in
  let circ,sim,i,o,o' = G.make "rv32i" pipeline in

  (* waveform viewer *)
  let wave_cfg = 
    let decode_insn b = 
      if B.(to_int (b ==:. 0) = 1) then "---"
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
      [f ( "clk",1); f ("clr",1)] @
      Rv.Ifs.I.(to_list @@ map f t) @ 
      Rv_o.(to_list @@ map f t) )
  in
  let sim, waves = 
    if waves then 
      let sim, waves = Waveterm_sim.wrap ?cfg:wave_cfg sim in
      sim, Some(waves)
    else sim, None
  in

  let open Rv.Ifs.I in
  let open Rv.Ifs.O in
  let open Rv_o in

  let module D = Utils.D32(B) in
  let module Mem = Utils.Mem(D) in
  let memory = Mem.init (8*1024) in (* 32 Kib *)

  let () = begin
    let open Riscv.RV32I.Asm in
    memory.(4) <- addi ~rd:1 ~rs1:0 ~imm12:100;
    memory.(5) <- addi ~rd:2 ~rs1:0 ~imm12:50;
    memory.(6) <- add ~rd:3 ~rs1:1 ~rs2:2;
  end in

  let mio () = 
    let o = o.o in
    i.mio_vld := B.gnd;
    if B.to_int !(o.mio_req) = 1 then begin
      i.mio_vld := B.vdd;
      if B.to_int !(o.mio_rw) = 1 then begin
        i.mio_rdata := D.to_signal @@ Mem.read ~memory ~addr:!(o.mio_addr)
      end else begin
        Mem.write ~memory ~addr:!(o.mio_addr) ~data:!(o.mio_wdata) ~strb:!(o.mio_wmask)
      end
    end;
  in

  let mio_temp () = 
    let o = o.o in
    i.mio_rdata := D.to_signal @@ Mem.read ~memory ~addr:!(o.mio_addr)
  in

  let cycle () = 
    mio_temp();
    Cs.cycle sim 
  in

  Cs.reset sim;
  i.clr := B.vdd;
  cycle();
  i.clr := B.gnd;
  for i=0 to 20 do
    cycle();
  done;

  begin
    match waves with
    | None -> ()
    | Some(waves) ->
      Lwt_main.run (Waveterm_ui.run Waveterm_waves.({ cfg=default; waves }))
  end

let () = testbench()
