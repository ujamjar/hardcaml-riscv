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

  let build_comb ~f_stages ~f_output inp = 
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
        map "_p_" (fun o -> o) p_stages.(i)
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
      let open Ifs.Stage in
      D.decoder ~inp 
        ~pipe:{pipe.(n-1) with rf_we = pipe.(com).rf_we;
                               rad = pipe.(com).rad;
                               rdd = pipe.(com).rdd }
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
    let f ~n ~inp ~comb ~pipe = 
      let open Ifs.Stage in
      let open Ifs.Class in
      let i = pipe.(n-1).iclass in
      { pipe.(n-1) with
        rf_we = ~: (i.trap |: i.bra |: i.st |: i.fen |: i.sys); (* XXX some sys will write *)
      }
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

