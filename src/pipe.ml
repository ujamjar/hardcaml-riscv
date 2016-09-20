open HardCaml.Signal
open Comb

module U = HardCaml.Utils

module Make(C : Config.S) = struct

  module Ifs = Interfaces.Make(C)
  open Ifs

  module Csr = Csr.Build(Ifs)
  module Cmb = Cmb.Make(Comb)(Ifs)
  
  type stage = Comb.t Stage.t
  type stages = Comb.t Stages.t
  type 'a f = 'a Cmb.f
  type f_stage = stage f
  type 'a f_output = 'a Cmb.f_output

  module type Stage = sig
    val name : string
    val f : f_stage
  end

  let zero' (n,b) = zero b
  let def_instr = consti32 32 @@ Riscv.RV32I.Asm.xori ~rd:0 ~rs1:0 ~imm:0
  let def_insn = sll (one Config.V.n) (Enum.from_enum<Config.T.t> `xori)
  let def_iclass = Class.{ (map zero' t) with opi = vdd; f3 = consti 3 6; }

  let def_clear = 
    Stage.({ (* set up for xori instruction - psuedo bubble *)
      (map zero' t) with
        pc = consti C.xlen C.start_addr;
        ra1_zero = vdd; ra2_zero = vdd; rad_zero = vdd;
        insn = def_insn; instr = def_instr;
        iclass = def_iclass;
        prv = const "11";
    })

  let def_clear_mi = 
    Mo_instr.({ (map zero' t) with 
        addr = consti C.xlen C.start_addr; 
        req = vdd; rw = vdd 
    })

  let bubble sel stage = 
    let high x = sel |: x in
    let low x = (~: sel) &: x in 
    Stage.{ stage with
      ra1_zero = high stage.ra1_zero;
      ra2_zero = high stage.ra2_zero;
      insn = mux2 sel def_insn stage.insn;
      instr = mux2 sel def_instr stage.instr;
      iclass = Class_ex.mux2 sel def_iclass stage.iclass;
      branch = low stage.branch;
      rwe = low stage.rwe;
      (* XXX anything we need to tidy up in mi/md? *)
    }

  (*module Fetch = Fetch.Make(Ifs)(HardCaml.Signal.Comb)
  module Decoder = Decoder.Make(Ifs)(HardCaml.Signal.Comb)
  module Alu = Alu.Make(Ifs)(HardCaml.Signal.Comb)
  module Mem = Mem.Make(Ifs)(HardCaml.Signal.Comb)
  module Commit = Commit.Make(Ifs)(HardCaml.Signal.Comb)*)

  module Build = struct

    (* 5 stage pipeline controller *)
    let p5_ctrl ~inp ~pipe ~comb_dec = 
      let open Stage in
      let open Stages in
      let module Seq = Utils.Regs(struct let clk=inp.I.clk let clr=inp.I.clr end) in
      (* compute pipeline bubble for register file read hazard *)
      let ra1_nz = (~: (comb_dec.ra1_zero)) -- "ra1_nz" in
      let ra1_alu_rad = (comb_dec.ra1 ==: pipe.dec.rad) -- "ra1_alu_rad" in
      let ra1_mem_rad = (comb_dec.ra1 ==: pipe.alu.rad) -- "ra1_mem_rad" in
      let ra1_com_rad = (comb_dec.ra1 ==: pipe.mem.rad) -- "ra1_com_rad" in
      let ra2_nz = (~: (comb_dec.ra2_zero)) -- "ra2_nz" in
      let ra2_alu_rad = (comb_dec.ra2 ==: pipe.dec.rad) -- "ra1_alu_rad" in
      let ra2_mem_rad = (comb_dec.ra2 ==: pipe.alu.rad) -- "ra1_mem_rad" in
      let ra2_com_rad = (comb_dec.ra2 ==: pipe.mem.rad) -- "ra1_com_rad" in

      let bubble = 
        (ra1_nz &: (ra1_alu_rad |: ra1_mem_rad |: ra1_com_rad)) |:
        (ra2_nz &: (ra2_alu_rad |: ra2_mem_rad |: ra2_com_rad)) 
      in

      let startup_hack = Seq.reg ~e:vdd ~cv:vdd gnd in (* high 1 cycle after clear *)
      let en = 
        mux2 startup_hack (constb "00001")
          (mux2 bubble (constb "11110") (constb "11111")) 
      in
      let bubble = mux2 bubble (constb "00010") (constb "00000") in
      let en, bubble = en -- "pipe_en", bubble --"pipe_bubble" in
      Ctrl.{ en; bubble }

    module Rf = Rf.Make(Ifs)

    let async_rf ~inp ~dec ~com = 
      let open Stage in
      Rf.f Rf.I.{
        clk = inp.I.clk; clr=inp.I.clr;
        wr = com.rwe; wa = com.rad; d = com.rdd;
        ra1 = dec.Stage.ra1; ra2 = dec.Stage.ra2;
      } 

    let async_rf_pipe ~inp ~func ~comb = 
      let open Stages in
      let rfo = async_rf ~inp ~dec:comb.dec ~com:comb.com in
      Rf.O.{ func with dec = { func.dec with Stage.rd1 = rfo.q1; rd2 = rfo.q2; } } 

    (* add in some internal debug signals 
       XXX remove along with the various junk signals *)
    let debug_junk ~func ~pipe = 
      let open Stage in
      let open Stages in
      { func with com = { func.com with junk=
        pipe.com.instr.[0:0] |:
        pipe.com.insn.[0:0] |:
        pipe.com.ra1_zero |: pipe.com.ra2_zero
      } } 

    (*let pipeline_bubble ~ctrl ~func = 
      let open Stages in
      let open Ctrl in
      { 
        fet = bubble (bit ctrl.bubble 0) func.fet;
        dec = bubble (bit ctrl.bubble 1) func.dec;
        alu = bubble (bit ctrl.bubble 2) func.alu;
        mem = bubble (bit ctrl.bubble 3) func.mem;
        com = bubble (bit ctrl.bubble 4) func.com;
      }*)

    let pipeline_bubble ~ctrl ~func = 
      Stages.{ func with dec = bubble (bit ctrl.Ctrl.bubble 1) func.dec }

    let pipeline_enable ~ctrl = 
      let pen n = let en = bit ctrl.Ctrl.en n in Stage.(map (fun _ -> en) t) in
      Stages.{ fet = pen 0; dec = pen 1; alu = pen 2; mem = pen 3; com = pen 4 } 

    let p5_wiring ~inp ~pen ~comb ~pipe ~func = 
      let module Seq = Utils.Regs(struct let clk=inp.I.clk let clr=inp.I.clr end) in
      let pclr = let c = def_clear in Stages.{fet=c; dec=c; alu=c; mem=c; com=c} in
      let _ = Stages.map2 (<==) comb func in
      let preg cv e pipe comb = pipe <== Seq.reg ~cv ~e comb in
      let _ = Stages_ex.(map4 preg pclr pen pipe comb) in
      ()

    let p5 ~inp ~f_output = 
      let open Stage in
      let open Stages in
      
      (* pipeline stages wires *)
      let comb, pipe = Stages_ex.(wiren(), wire()) in

      (* pipeline stages *)
      let func, mi, md = 
        let fet, mi = Cmb.Fetch.f ~inp ~comb ~pipe in
        let mem, md = Cmb.Mem.f ~inp ~comb ~pipe in
        { 
          fet;
          dec = Cmb.Decoder.f ~inp ~comb ~pipe;
          alu = Cmb.Alu.f ~inp ~comb ~pipe;
          mem;
          com = Cmb.Commit.f ~inp ~comb ~pipe;
        }, mi, md 
      in

      (* insert the (async) register file *)
      let func = async_rf_pipe ~inp ~func ~comb in

      (* pipeline control + bubbles + enable *)
      let ctrl = p5_ctrl ~inp ~pipe ~comb_dec:func.dec in
      let pen = pipeline_enable ~ctrl in
      let func = pipeline_bubble ~ctrl ~func in

      (* waveform debug *)
      let func = debug_junk ~func ~pipe in

      (* wire it all together *)
      let () = p5_wiring ~inp ~pen ~comb ~pipe ~func in

      f_output ~ctrl ~mi ~md ~inp ~comb ~pipe

    (*let p5_new ~inp ~(f_output : 'a f_output) = 
      let open Stage in
      let module Seq = Utils.Regs(struct let clk=inp.I.clk let clr=inp.I.clr end) in
      
      let name prefix f = Stage.(map2 (fun (n,b) y -> y -- (prefix ^ n)) t f) in
      let preg prefix (n,b) cv d =
        try (Seq.reg ~cv ~e:ctrl.Ctrl.en d) -- (prefix ^ n)
        with _ ->
          failwith 
            (n ^ ": " ^ 
            "r[" ^ string_of_int (width r) ^ "] " ^
            "c[" ^ string_of_int (width cv) ^ "] " ^
            "d[" ^ string_of_int (width d) ^ "] ")
      in
      let stage prefix d = Stage_ex.(map3 (preg prefix) t def_clear d) in
      
      let fet,mi = Fetch.fetch ~inp ~com:state in
      let fet = stage "fet_" fet in (* hmmm - might rework this *)
      let dec = stage "dec_" @@ Decoder.decoder ~inp ~csrs:csrs_q ~fet:fet in
      let rfo = async_rf ~dec:dec in
      let dec = { dec with rd1 = rfo.Rf.O.q1; rd2 = rfo.Rf.O.q2 } in
      let alu = stage "alu_" @@ Alu.alu ~dec:dec in
      let mem,md = Mem.mem ~inp ~alu:alu in
      let mem = stage "mem_" mem in
      let com, csrs_wr = Commit.commit ~mem:mem ~csrs:csrs_q ~csr_rdata ~prv:state.prv in
      let com = stage "com_" com in
      let com = hack_junk com state in
      ()
    *)

    let p1 ~inp ~(f_output : 'a f_output) = 
      let open Stage in
      let open Stages in
      let module Seq = Utils.Regs(struct let clk=inp.I.clk let clr=inp.I.clr end) in

      let inp = Ifs.I.(map (fun x -> let y = wire (width x) in y <== x; y) inp) in
        
      let csr_rdata = wire C.xlen in
      let csrs_q = Ifs.Csr_regs_ex.wire () in
      let state = Stage.(map (fun (n,b) -> wire b -- ("state_" ^ n)) t) in
      let com' = Stage.(map (fun (n,b) -> wire b) t) in

      (* generate core *)
      let async_rf = async_rf ~inp ~com:com' in
      let mi, md, com, _, ctrl, csrs_wr = Cmb.c ~inp ~state ~async_rf ~csrs_q ~csr_rdata in
        
      (* csrs *)
      let csrs_r, csr_rdata' = 
        Csr.make 
          ~clk:inp.I.clk
          ~clr:inp.I.clr
          ~csr_ctrl:com.csr
          ~ext:csrs_wr
          ~wdata:com.rd1 
      in
      let () = csr_rdata <== csr_rdata' in
      let _ = Ifs.Csr_regs.map2 (<==) csrs_q csrs_r in

      let preg (n,b) cv r d =
        try
          r <== Seq.reg ~cv ~e:ctrl.Ctrl.en d 
        with _ ->
          failwith 
            (n ^ ": " ^ 
            "r[" ^ string_of_int (width r) ^ "] " ^
            "c[" ^ string_of_int (width cv) ^ "] " ^
            "d[" ^ string_of_int (width d) ^ "] ")
      in
      let _ = Stage_ex.map4 preg Stage_ex.t def_clear state com in
      let _ = Stage_ex.map2 (<==) com' com in

      let sts_zero = Stages.(map (fun (n,b) -> zero b) t) in
      f_output ~ctrl ~mi ~md ~inp ~comb:sts_zero ~pipe:sts_zero 

  end

  module Output = struct
    let o ~ctrl ~mi ~md ~inp ~comb ~pipe =
      O.({
        junk=pipe.Stages.com.Stage.junk;
        mi; md;
      })
  end

  module Output_debug = struct
    let o ~ctrl ~mi ~md ~inp ~comb ~pipe =
      O_debug.({
        o = Output.o ~ctrl ~mi ~md ~inp ~comb ~pipe;
        dbg = pipe;
      })
  end

end


