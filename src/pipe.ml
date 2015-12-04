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

  module Fetch = struct
    let name = "fet"
    let f =
      let module F = Fetch.Make(Ifs) in
      F.f 
  end

  module Icache = struct
    let name = "icache"
    module C = Cache.Direct_mapped(struct
      let data = 32
      let addr = 32
      let line = 2
      let size = 8
    end)
    let f ~inp ~comb ~pipe = 
      let open Stage in
      let open Stages in
      (*let { C.O.hit; data } = 
        C.direct_mapped 
          C.I.{ clk=inp.clk;
                clr=inp.clr;
                en=vdd;
                rw=vdd;
                addr=pipe.fet.pc; }
      in*)
      pipe.fet

  end

  module Decoder = struct
    let name = "dec"
    let f ~inp ~comb ~pipe = 
      let module D = Decoder.Make(Ifs) in
      let open Stage in
      let open Stages in
      D.decoder ~inp 
        ~pipe:{ pipe.fet with rwe = pipe.com.rwe;
                              rad = pipe.com.rad;
                              rdd = pipe.com.rdd }
  end

  module Alu = struct
    let name = "alu"
    let f ~inp ~comb ~pipe = 
      let module Alu = Alu.Make(Ifs) in
      Alu.alu pipe.Stages.dec
  end

  module Mem = struct
    let name = "mem"
    let f = 
      let module M = Mem.Make(Ifs) in
      M.f
  end

  module Commit = struct
    let name = "com"
    let f =
      let module C = Commit.Make(Ifs) in
      C.f
  end

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


