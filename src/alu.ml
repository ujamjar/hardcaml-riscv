module Make(Ifs : Interfaces.S) = struct

  let alu p = 
    let open Ifs.Stage in
    let open Ifs.Class in
    let open HardCaml.Signal.Comb in
    
    let addsub ctl a b = mux2 ctl (a -: b) (a +: b) in

    let eq = p.rd1 ==: p.rd2 in
    let neq = ~: eq in
    let slt = p.rd1 <+ p.rd2 in (* may be able to simplify this with a subtractor *)
    let sltu = p.rd1 <: p.rd2 in
    let sge = p.rd1 >=+ p.rd2 in
    let sgeu = p.rd1 >=: p.rd2 in
    let shamt = p.rd2.[4:0] in

    let c = p.iclass in

    let addsub = 
      let addctl = mux2 (c.auipc |: c.jal |: c.ld |: c.st) gnd c.f7 in
      addsub addctl p.rd1 p.rd2 
    in

    let alu_op = mux c.f3 [
      addsub;
      log_shift sll p.rd1 shamt;
      uresize slt Ifs.xlen;
      uresize sltu Ifs.xlen;
      p.rd1 ^: p.rd2;
      mux2 c.f7 (log_shift sra p.rd1 shamt) (log_shift srl p.rd2 shamt);
      p.rd1 |: p.rd2;
      p.rd1 &: p.rd2;
    ] in

    let cond_branch = mux c.f3 [ eq; neq; gnd; gnd; slt; sge; sltu; sgeu ] in

    let rdd = 
      pmux [
        c.lui, p.rd2;
        c.auipc, addsub;
        c.jal |: c.jalr, p.pc +:. 4; (* XXX we could put pc in rs1 and 'imm' in rs2 instead *)
        c.bra, p.pc +: p.imm;
      ] alu_op
    in

    { p with rdd; cond_branch }

end
