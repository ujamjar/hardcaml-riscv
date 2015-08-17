open HardCaml.Signal
open Comb

module U = HardCaml.Utils

module Make(C : Config.S) = struct

  module Ifs = Interfaces.Make(C)
  open Ifs

  let wired_stage _ = Stage.(map (fun (n,b) -> wire b) t)
  let zero_stage _ = Stage.(map (fun (n,b) -> zero b) t)

  type stage = Comb.t Stage.t
  type stages = stage array
  type f_stage = n:int -> inp:Comb.t I.t -> comb:stages -> pipe:stages -> stage
  type 'a f_output = stages -> 'a
  
  module type Stage = sig
    val name : string
    val f : f_stage
  end

  let build_pipeline ~f_stages ~f_output inp = 
    let module Seq = Utils.Regs(struct let clk=inp.I.clk let clr=inp.I.clr end) in
    (* number of stages *)
    let n_stages = Array.length f_stages in
    (* pipeline stage after registering *)
    let p_stages = Array.init n_stages wired_stage in
    (* pipeline stage before registering *)
    let w_stages = Array.init n_stages wired_stage in

    (* generate the stages *)
    let o_stages = 
      Array.mapi 
        (fun n f -> 
          let module F = (val f : Stage) in
          F.f ~n ~inp ~comb:w_stages ~pipe:p_stages) 
        f_stages 
    in

    (* wiring *)
    let () = 
      let open Stage in
      let internal_names = false in
      for i=0 to n_stages-1 do
        let module F = (val f_stages.(i) : Stage) in
        (* get pipeline enable and clear *)
        let e = o_stages.(i).pen in
        let map f st = 
          let st = Stage.map2 (fun a b -> a,b) st o_stages.(i) in
          let st = Stage.map2 (fun (a,b) (n,_) -> a,b,n) st t in
          ignore @@ Stage.map f st
        in
        let map name f st = map (* optional internal naming *)
          (fun (w,o,n) -> 
            w <== if internal_names then (f o) -- (F.name ^ name ^ n)
                  else f o) st 
        in
        (* wire up combinatorial output of stages *)
        map "_c_" (fun o -> o) w_stages.(i);
        (* wire up pipelined output of stages *)
        map "_p_" (Seq.reg ~e) p_stages.(i)
      done
    in
    
    f_output p_stages

  (* ideally we would parameterise each of the pipeline stages somehow
   * so they can refer to other pipeline stages without needing to actually
   * know the pipeline number.  The goal would then to be able to generate
   * different pipeline lengths and have the core adapt itself (ie for bypassing,
   * interlocking etc).  As yet I'm not sure how this will work, so we'll stick
   * to static numbers for the first iteration of the core *)
  let fet = 0 (* fetch *)
  let dec = 1 (* decode *)
  let exe = 2 (* execute *)
  let mem = 3 (* memory *)
  let com = 4 (* commit *)

  module Fetch = struct
    let name = "fet"
    let f ~n ~inp ~comb ~pipe = 
      let open Stage in
      let module Seq = Utils.Regs(struct let clk=inp.I.clk let clr=inp.I.clr end) in
      let pc = Seq.reg_fb ~cv:(consti C.xlen C.start_addr) ~e:vdd ~w:C.xlen (fun d -> d +:. 4) in
      let pc = pc -- "fetch_pc" in
      let junk = I.to_list inp |> concat |> bits |> reduce (|:) in (* XXX TO BE REMOVED *)
      { zero_stage () with 
        pc; junk; pen=vdd }
  end

  module Decoder = struct
    let name = "dec"
    let f ~n ~inp ~comb ~pipe = 
      let module D = Decoder.Make(Ifs) in
      D.decoder ~n ~inp ~pipe:pipe.(n-1)
  end

  module Alu = struct
    let name = "alu"
    let f ~n ~inp ~comb ~pipe = 
      let module Alu = Alu.Make(Ifs) in
      Alu.alu pipe.(n-1)
  end

  module Mem = struct
    let name = "mem"
    let f ~n ~inp ~comb ~pipe = pipe.(n-1)
  end

  module Commit = struct
    let name = "com"
    let f ~n ~inp ~comb ~pipe = pipe.(n-1)
  end

  module Output = struct
    let f pipe = 
      let open Stage in
      O.({
        mio_addr = pipe.(fet).pc;
        mio_wdata = zero C.xlen; 
        mio_req = gnd; 
        mio_rw = pipe.(com).junk;
        mio_wmask = zero (C.xlen/8);
      })
  end

  module Output_debug = struct
    let f pipe = 
      O_debug.({
        o = Output.f pipe;
        fet = pipe.(0);
        dec = pipe.(1);
        alu = pipe.(2);
        mem = pipe.(3);
        com = pipe.(4);
      })
  end

end

module Test = struct

  module Cfg = struct
    let xlen = 32
    let start_addr = 0x10
  end

  module Rv = Make(Cfg)
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

  let write_circ name circ = 
    let f = open_out ("test/rv32i_rtl/" ^ name ^ ".v") in
    HardCaml.Rtl.Verilog.write (output_string f) circ;
    close_out f

  let write_pipe_stage name stage p = 
    let module P = (val p : Rv.Stage) in
    let inp = Rv.Ifs.I.(map (fun (n,b) -> input n b) t) in
    let module Seq = Utils.Regs(struct let clk=inp.Rv.Ifs.I.clk let clr=inp.Rv.Ifs.I.clr end) in
    let pipe = Array.init 5 (fun j -> 
      Rv.Ifs.Stage.(map (fun (n,b) -> Seq.reg ~e:vdd (input (n^"_p_"^string_of_int j) b)) t)) 
    in
    let comb = Array.init 5 (fun j -> 
      Rv.Ifs.Stage.(map (fun (n,b) -> Seq.reg ~e:vdd (input (n^"_c_"^string_of_int j) b)) t)) 
    in
    let o = P.f ~n:stage ~inp ~comb ~pipe in
    let o = Rv.Ifs.Stage.(map2 (fun o (n,b) -> n,o) o t) in
    let o = 
      Rv.Ifs.Stage.to_list o 
      (*|> List.filter (fun (n,o) -> not (is_const x)) o*) 
      |> List.map (fun (n,o) -> output n (Seq.reg ~e:vdd o))
    in
    let circ = HardCaml.Circuit.make name o in
    write_circ name circ

  let write_core () = 
    let module G = HardCaml.Interface.Circ(Rv.Ifs.I)(Rv_o) in
    let circ = G.make "rv32i" pipeline in
    write_circ "rv32i" circ

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

end

