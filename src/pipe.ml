open HardCaml.Signal
open Comb

module U = HardCaml.Utils

module Make(C : Config.S) = struct

  module Ifs = Interfaces.Make(C)
  open Ifs

  let zero_stage _ = Stage.(map (fun (n,b) -> zero b) t)

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
    })

  module Fetch = Fetch.Make(Ifs)
  module Decoder = Decoder.Make(Ifs)
  module Alu = Alu.Make(Ifs)
  module Mem = Mem.Make(Ifs)
  module Commit = Commit.Make(Ifs)

  module Build = struct


    let p5 ~inp ~f_output = 
      let module Seq = Utils.Regs(struct let clk=inp.I.clk let clr=inp.I.clr end) in
      
      let pzip a b = Stages.map2 (fun a b -> a,b) a b in
      let pclr = let c = def_clear in Stages.{fet=c; dec=c; alu=c; mem=c; com=c} in
      let pwire (n,b) = wire b in
      let pwiren (n,b) = wire b -- n in
      let pen = wire 1 in

      let comb, pipe = Stages.(map pwiren t), Stages.(map pwire t) in

      let func = Stages.{
        fet = Fetch.f ~inp ~comb ~pipe;
        dec = Decoder.f ~inp ~comb ~pipe;
        alu = Alu.f ~inp ~comb ~pipe;
        mem = Mem.f ~inp ~comb ~pipe;
        com = Commit.f ~inp ~comb ~pipe;
      } in
    
      let _ = Stages.(map2 (<==) comb func) in
      let _ = 
        let preg ((n,b),(cv,(pipe,func))) = pipe <== (Seq.reg ~cv ~e:pen func) in
        let pdat = Stages.(pzip t (pzip pclr (pzip pipe comb))) in
        Stages.(map preg pdat)
      in

      pen <== vdd;
 
      f_output pipe

  end

  module Output = struct
    let f pipe = 
      O.({
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


