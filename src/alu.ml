module Make(Ifs : Interfaces.S) = struct

  let alu ~dec = 
    let open Ifs.Stage in
    let open Ifs.Class in
    let open HardCaml.Signal.Comb in
    
    let rd1,rd2 = dec.rd1, mux2 dec.is_imm dec.imm dec.rd2 in

    let addsub ctl a b = mux2 ctl (a -: b) (a +: b) in

    let eq = rd1 ==: rd2 in
    let neq = ~: eq in
    let slt = rd1 <+ rd2 in (* may be able to simplify this with a subtractor *)
    let sltu = rd1 <: rd2 in
    let sge = rd1 >=+ rd2 in
    let sgeu = rd1 >=: rd2 in
    let shamt = rd2.[4:0] in

    let c = dec.iclass in

    let addctl = c.jal |: c.jalr |: c.ld |: c.st in
    let addsub = addsub (mux2 addctl gnd c.f7) rd1 rd2 in

    let alu_op = mux (mux2 addctl (zero 3) c.f3) [
      addsub;
      log_shift sll rd1 shamt;
      uresize slt Ifs.xlen;
      uresize sltu Ifs.xlen;
      rd1 ^: rd2;
      mux2 c.f7 (log_shift sra rd1 shamt) (log_shift srl rd2 shamt);
      rd1 |: rd2;
      rd1 &: rd2;
    ] in

    (* outcome of conditional branch *)
    let branch = mux c.f3 [ eq; neq; gnd; gnd; slt; sge; sltu; sgeu ] in

    let rdd = 
      pmux [
        c.lui, rd2;
        c.bra |: c.jal |: c.auipc, dec.pc +: dec.imm;
      ] alu_op
    in

    { dec with rdd; branch }

  let name = "alu"

  let f ~inp ~comb ~pipe = alu ~dec:pipe.Ifs.Stages.dec

end

