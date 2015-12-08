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

  let def_clear = 
    let zero (n,b) = zero b in
    Stage.({ (* set up for xori instruction - psuedo bubble *)
      (map zero t) with
        pc = consti C.xlen C.start_addr;
        ra1_zero = vdd; ra2_zero = vdd; rad_zero = vdd;
        insn = sll (one 48) (Enum.from_enum<Insn.T.t> `xori);
        iclass = Class.({ 
          (map zero t) with 
            opi = vdd;
            f3 = consti 3 6;
        });
        mi = Mo_instr.({
          (map zero t) with
            addr = consti C.xlen C.start_addr;
        });
    })

  module Fetch = Fetch.Make(Ifs)
  module Decoder = Decoder.Make(Ifs)
  module Alu = Alu.Make(Ifs)
  module Mem = Mem.Make(Ifs)
  module Commit = Commit.Make(Ifs)

  module Build = struct

    (* 5 stage pipeline controller *)
    module Ctrl = interface
      en[5] stall[1]
    end

    let p5_ctrl ~inp ~pipe ~comb = 
      let open Stage in
      let open Stages in
      (* compute pipeline bubble for register file read hazard *)
      let stall = 
        ((~: (comb.dec.ra1_zero)) &: 
            ((comb.dec.ra1 ==: pipe.dec.rad) |: 
             (comb.dec.ra1 ==: pipe.alu.rad) |: 
             (comb.dec.ra1 ==: pipe.mem.rad))) |:
        ((~: (comb.dec.ra2_zero)) &: 
            ((comb.dec.ra2 ==: pipe.dec.rad) |: 
             (comb.dec.ra2 ==: pipe.alu.rad) |: 
             (comb.dec.ra2 ==: pipe.mem.rad)))
      in
      let en = mux2 stall (constb "11110") (constb "11111") in
      let stall,en = stall -- "pipe_stall", en -- "pipe_en" in
      Ctrl.{ en; stall }

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

    let p5 ~inp ~f_output = 
      let open Stage in
      let open Stages in
      let module Seq = Utils.Regs(struct let clk=inp.I.clk let clr=inp.I.clr end) in
      
      let pclr = let c = def_clear in Stages.{fet=c; dec=c; alu=c; mem=c; com=c} in
      let comb, pipe = Stages_ex.(wire(), wiren()) in

      (* controller *)
      let ctrl = p5_ctrl ~inp ~pipe ~comb in

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

      (* waveform debug *)
      let func = debug_junk ~func ~pipe in

      (* pipeline enable *)
      let pen = 
        let pen n = let en = bit ctrl.Ctrl.en n in Stage.(map (fun _ -> en) t) in
        { fet = pen 0; dec = pen 1; alu = pen 2; mem = pen 3; com = pen 4 } 
      in

      (* wire it all together *)
      let _ = Stages.map2 (<==) comb func in
      let _ = 
        let preg cv e pipe comb = pipe <== Seq.reg ~cv ~e comb in
        Stages_ex.(map4 preg pclr pen pipe comb)
      in

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


