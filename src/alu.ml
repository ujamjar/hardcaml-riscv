module Make(Ifs : Interfaces.S)(B : HardCaml.Comb.S) = struct


  let alu ~dec = 
    let open Ifs.Stage in
    let open Ifs.Class in
    let open B in
    
    let rd1, rd2 = dec.rd1, mux2 dec.is_imm dec.imm dec.rd2 in
    let rd1, rd2 = rd1 -- "alu_rd1_i",  rd2 -- "alu_rd2_i" in

    let addsub ctl a b = mux2 ctl (a -: b) (a +: b) in

    let eq = rd1 ==: rd2 in
    let neq = ~: eq in
    let slt = rd1 <+ rd2 in (* may be able to simplify this with a subtractor *)
    let sltu = rd1 <: rd2 in
    let sge = rd1 >=+ rd2 in
    let sgeu = rd1 >=: rd2 in
    let shamt = rd2.[4:0] in

    let c = dec.iclass in
    let sel b = let b = Config.T.Enum_t.from_enum b in dec.insn.[b:b] in

    let addctl = sel `jal |: sel `jalr |: c.ld |: c.st in
    let addsub = addsub (mux2 dec.is_imm gnd c.f7) rd1 rd2 in

    let alu_op = mux (mux2 addctl (zero 3) c.f3) [
      addsub;
      log_shift sll rd1 shamt;
      uresize slt Ifs.xlen;
      uresize sltu Ifs.xlen;
      rd1 ^: rd2;
      mux2 c.f7 (log_shift sra rd1 shamt) (log_shift srl rd1 shamt);
      rd1 |: rd2;
      rd1 &: rd2;
    ] in

    (* outcome of conditional branch *)
    let branch = mux c.f3 [ eq; neq; gnd; gnd; slt; sge; sltu; sgeu ] in

    let rdd = 
      pmux [
        sel `lui, rd2;
        c.bra |: sel `jal |: sel `auipc, dec.pc +: dec.imm;
      ] alu_op
    in

    { dec with rdd; branch }

  let name = "alu"

  let f ~inp ~comb ~pipe = alu ~dec:pipe.Ifs.Stages.dec

end

