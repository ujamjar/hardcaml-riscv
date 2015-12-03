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
    let f ~inp ~comb ~pipe = 
      let open Stage in
      let open Stages in
      let pc = mux2 pipe.com.branch pipe.com.pc (pipe.fet.pc +:. 4) in
      let junk = I.to_list inp |> concat |> bits |> reduce (|:) in (* XXX TO BE REMOVED *)
      { zero_stage () with 
        pc; junk; pen=vdd;
        mi = {
          Mo_instr.addr = pc;
          wdata = zero xlen;
          (*req = vdd;*)
          req = vdd;
          rw = vdd;
          wmask = zero (xlen / 8); 
        } 
      } 

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
    let f ~inp ~comb ~pipe = 
      let open Stage in
      let open Stages in
      let open Class in
      (* note; XXX don't (currently) allow unaligned accesses and
       *           they should cause a trap *)
      let p = pipe.alu in
      let i = p.iclass in
      let ofs = p.rdd.[1:0] in 
      let addr = p.rdd in
      (* byte, half or word transfer *)
      let size = p.iclass.f3.[1:0] in
      (* sign extend *)
      let sext = p.iclass.f3.[2:2] in
      (* write data mask *)
      let wmask = 
        mux size [
          mux ofs.[1:0] (List.map constb ["0001";"0010";"0100";"1000"]);
          mux ofs.[1:1] (List.map constb ["0011";"1100"]);
          constb "1111";
        ]
      in
      (* write data *)
      let wdata = 
        let sft n s = sll (uresize p.rdm.[n-1:0] 32) s in
        mux size [
          mux ofs.[1:0] (List.map (sft 8) [0;8;16;24]);
          mux ofs.[1:1] (List.map (sft 16) [0;16]);
          p.rdm;
        ]
      in
      (* read data *)
      let rdm = 
        let res x = mux2 sext (sresize x 32) (uresize x 32) in
        let rdm = inp.I.md.Mi_data.rdata in
        let rdm8 = res @@ mux ofs.[1:0] [ rdm.[7:0]; rdm.[15:8]; rdm.[23:16]; rdm.[31:24] ] in
        let rdm16 = res @@ mux ofs.[1:1] [ rdm.[15:0]; rdm.[31:16] ] in
        mux size [ rdm8; rdm16; rdm ]
      in
      let req = i.st |: i.ld in (* is a memory request *)
      let rw = i.ld in
      let rdd = mux2 rw rdm p.rdd in
      { p with
        rdd;
        md = Mo_data.({
          addr; wdata;
          req; rw; wmask; 
        })
      }

  end

  module Commit = struct
    let name = "com"
    let f ~inp ~comb ~pipe = 
      let open Stage in
      let open Stages in
      let open Class in
      let p = pipe.mem in
      let i = p.iclass in
      let branch = i.jal |: i.jalr |: (i.bra &: p.branch) in
      let rdd = mux2 (i.jal |: i.jalr) (p.pc +:. 4) p.rdd in
      let rwe = ~: (i.trap |: i.bra |: i.st |: i.fen |: i.rdc) in
      let pc = p.rdd in (* jal + jalr *)
      { pipe.mem with rwe; branch; rdd; pc; }
  end

  module Build = struct


    let p5 ~inp ~f_output = 
      let module Seq = Utils.Regs(struct let clk=inp.I.clk let clr=inp.I.clr end) in
      
      let pzip a b = Stages.map2 (fun a b -> a,b) a b in
      let pclr = let c = def_clear in Stages.{fet=c; dec=c; alu=c; mem=c; com=c} in
      let pwire (n,b) = wire b in
      let pen = wire 1 in

      let comb, pipe = Stages.(map pwire t), Stages.(map pwire t) in

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
        let pdat = Stages.(pzip t (pzip pclr (pzip pipe func))) in
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


