open HardCaml.Signal
open Comb

module U = HardCaml.Utils

module Make(C : Config.S) = struct

  module Ifs = Interfaces.Make(C)
  open Ifs

  type stage = Comb.t Stage.t
  type stages = Comb.t Stages.t
  type f_stage = inp:Comb.t I.t -> comb:stages -> pipe:stages -> stage
  type 'a f_output = stages -> 'a
  
  module type Stage = sig
    val name : string
    val f : f_stage
  end

  let zero' (n,b) = zero b
  let def_instr = consti32 32 @@ Riscv.RV32I.Asm.xori ~rd:0 ~rs1:0 ~imm:0
  let def_insn = sll (one 48) (Enum.from_enum<Insn.T.t> `xori)
  let def_iclass = Class.{ (map zero' t) with opi = vdd; f3 = consti 3 6; }

  let def_clear = 
    Stage.({ (* set up for xori instruction - psuedo bubble *)
      (map zero' t) with
        pc = consti C.xlen C.start_addr;
        ra1_zero = vdd; ra2_zero = vdd; rad_zero = vdd;
        insn = def_insn; instr = def_instr;
        iclass = def_iclass;
        mi = Mo_instr.({ (map zero' t) with addr = consti C.xlen C.start_addr; });
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

  module Fetch = Fetch.Make(Ifs)
  module Decoder = Decoder.Make(Ifs)
  module Alu = Alu.Make(Ifs)
  module Mem = Mem.Make(Ifs)
  module Commit = Commit.Make(Ifs)

  module Build = struct

    (* 5 stage pipeline controller *)
    module Ctrl = interface
      en[5] bubble[5]
    end

    let p5_ctrl ~inp ~pipe ~comb_dec = 
      let open Stage in
      let open Stages in
      let module Seq = Utils.Regs(struct let clk=inp.I.clk let clr=inp.I.clr end) in
      (* compute pipeline bubble for register file read hazard *)
      let bubble = 
        ((~: (comb_dec.ra1_zero)) &: 
            ((comb_dec.ra1 ==: pipe.dec.rad) |: 
             (comb_dec.ra1 ==: pipe.alu.rad) |: 
             (comb_dec.ra1 ==: pipe.mem.rad))) |:
        ((~: (comb_dec.ra2_zero)) &: 
            ((comb_dec.ra2 ==: pipe.dec.rad) |: 
             (comb_dec.ra2 ==: pipe.alu.rad) |: 
             (comb_dec.ra2 ==: pipe.mem.rad)))
      in
      let startup_hack = Seq.reg ~e:vdd ~cv:vdd gnd in (* high 1 cycle after clear *)
      let en = 
        mux2 startup_hack (constb "00001")
          (mux2 bubble (constb "11110") (constb "11111")) 
      in
      let bubble = mux2 bubble (constb "00010") (constb "00000") in
      let en, bubble = en -- "pipe_en", bubble --"pipe_bubble" in
      Ctrl.{ en; bubble }

    let async_rf ~inp ~func ~comb = 
      let open Stage in
      let open Stages in
      let module Seq = Utils.Regs(struct let clk=inp.I.clk let clr=inp.I.clr end) in
      let module Rf = Rf.Make(Ifs) in
      let rfo = Rf.f Rf.I.{
        clk = inp.I.clk; clr=inp.I.clr;
        wr = comb.com.rwe; wa = comb.com.rad; d = comb.com.rdd;
        ra1 = comb.dec.ra1; ra2 = comb.dec.ra2;
      } in
      Rf.O.{ func with dec = { func.dec with rd1 = rfo.q1; rd2 = rfo.q2; } } 

    (* add in some internal debug signals 
       XXX remove along with the various junk signals *)
    let debug_junk ~func ~pipe = 
      let open Stage in
      let open Stages in
      { func with com = { func.com with junk=
        pipe.com.instr.[0:0] |:
        pipe.com.insn.[0:0]
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

    let pipeline_wiring ~inp ~pen ~comb ~pipe ~func = 
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
      let func = {
        fet = Fetch.f ~inp ~comb ~pipe;
        dec = Decoder.f ~inp ~comb ~pipe;
        alu = Alu.f ~inp ~comb ~pipe;
        mem = Mem.f ~inp ~comb ~pipe;
        com = Commit.f ~inp ~comb ~pipe;
      } in

      (* insert the (async) register file *)
      let func = async_rf ~inp ~func ~comb in

      (* pipeline control + bubbles + enable *)
      let ctrl = p5_ctrl ~inp ~pipe ~comb_dec:func.dec in
      let pen = pipeline_enable ~ctrl in
      let func = pipeline_bubble ~ctrl ~func in

      (* waveform debug *)
      let func = debug_junk ~func ~pipe in

      (* wire it all together *)
      let () = pipeline_wiring ~inp ~pen ~comb ~pipe ~func in

      f_output pipe

  end

  module Output = struct
    let f pipe = 
      O.({
        junk=pipe.Stages.com.Stage.junk;
        mi = pipe.Stages.fet.Stage.mi;
        md = pipe.Stages.mem.Stage.md;
      })
  end

  module Output_debug = struct
    let f pipe = 
      O_debug.({
        o = Output.f pipe;
        dbg = pipe;
      })
  end

end


