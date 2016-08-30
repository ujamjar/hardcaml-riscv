module Make(B : HardCaml.Comb.S)(Ifs : Interfaces.S) = struct

  open Ifs

  module Fetch = Fetch.Make(Ifs)(B)
  module Decoder = Decoder.Make(Ifs)(B)
  module Alu = Alu.Make(Ifs)(B)
  module Mem = Mem.Make(Ifs)(B)
  module Commit = Commit.Make(Ifs)(B)
  module Rf = Rf.Make(Ifs)

  type stage = B.t Ifs.Stage.t

  type stages = B.t Ifs.Stages.t

  type 'a f = inp:B.t Ifs.I.t -> comb:stages -> pipe:stages -> 'a

  type 'a f_output = 
    ctrl:B.t Ifs.Ctrl.t -> 
    mi:B.t Ifs.Mo_instr.t ->
    md:B.t Ifs.Mo_data.t ->
    'a f

  open B

  let hack_junk com state = 
    let open Stage in
    let open Ifs.Csr_ctrl in
    { com with
      junk = (* waveform debug junk *)
        state.instr.[0:0] |:
        state.insn.[0:0] |:
        state.ra1_zero |: state.ra2_zero |:
        state.csr.csr_set |: state.csr.csr_clr |: 
        state.csr.csr_write |: 
        reduce (|:) (bits state.csr.csr_dec)
    }

  let ctrl ~inp = 
    let en = vdd in
    let bubble = gnd in
    Ctrl.{ en; bubble }

  let c ~inp ~state ~async_rf ~csrs_q ~csr_rdata = 
    let open Stage in
    let name x f = Stage.(map2 (fun (n,b) y -> y -- (x ^ n)) t f) in

    let ctrl = ctrl ~inp in

    let fet,mi = Fetch.fetch ~inp ~com:state in
    let fet = name "fet_" fet in
    let dec = name "dec_" @@ Decoder.decoder ~inp ~csrs:csrs_q ~fet:fet in
    let rfo = async_rf ~dec:dec in
    let dec = { dec with rd1 = rfo.Rf.O.q1; rd2 = rfo.Rf.O.q2 } in
    let alu = name "alu_" @@ Alu.alu ~dec:dec in
    let mem,md = Mem.mem ~inp ~alu:alu in
    let mem = name "mem_" mem in
    let com, csrs_wr = Commit.commit ~mem:mem ~csrs:csrs_q ~csr_rdata ~prv:state.prv in
    let com = name "com_" com in
    let com = hack_junk com state in

    mi, md, com, rfo, ctrl, csrs_wr

end

