
module Make_insn_decoder(Ifs : Interfaces.S)(B : HardCaml.Comb.S) = struct

  open Ifs
  open B

  type t = 
    {
      insn : B.t;
      iclass : B.t Class.t;
    }

  let decoder instr = 
    (* ALM = 509, REG = 405 *)
    let opcode = instr.[6:0] in
    let funct3 = instr.[14:12] in
    let funct7 = instr.[31:25] in
    let funct12 = instr.[31:20] in

    let f3' = binary_to_onehot funct3 in
    let f3  = bits f3' |> List.rev |> Array.of_list in
    let f7_0,f7_s = funct7 ==:. 0b0000000, funct7 ==:. 0b0100000 in
    let f7_x = f7_0 |: f7_s in

    let rs1, rs2, rd = instr.[19:15], instr.[24:20], instr.[11:7] in
    let rs1_0, rs2_0, rd_0 = rs1 ==:. 0, rs2 ==:. 0, rd ==:. 0 in

    let isf3 l = reduce (|:) (List.map (Array.get f3) l) in
    let notf3 l = ~: (isf3 l) in

    let lui   = opcode ==:. 0b0110111 in
    let auipc = opcode ==:. 0b0010111 in
    let jal   = opcode ==:. 0b1101111 in
    let jalr  = opcode ==:. 0b1100111 &: f3.(0) in
    let bra   = opcode ==:. 0b1100011 in
    let ld    = opcode ==:. 0b0000011 in
    let st    = opcode ==:. 0b0100011 in
    let opi   = opcode ==:. 0b0010011 in
    let opr   = opcode ==:. 0b0110011 in
    let fen   = opcode ==:. 0b0001111 in
    let sys   = opcode ==:. 0b1110011 in

    let fence, fencei = fen &: f3.(0), fen &: f3.(1) in

    let scall, sbreak = 
      let f12_0, f12_1 = funct12 ==:. 0b000000000000, funct12 ==:. 0b000000000001 in
      let c = rs1_0 &: f3.(0) &: rd_0 &: sys in
      f12_0 &: c, f12_1 &: c
    in

    let rdcycle, rdtime, rdinstret, rdhigh =
      let f = (funct12.[11:8] ==:. 0b1100) &: (funct12.[6:2] ==:. 0b00000) in
      let c = rs1_0 &: f3.(2) &: sys &: f in
      let x = funct12.[1:0] in
      x ==:. 0b00 &: c, x ==:. 0b01 &: c, x ==:. 0b10 &: c, funct12.[7:7]
    in

    let trap = 
      let bra = bra &: notf3 [2;3] in
      let ld  = ld  &: notf3 [3;6;7] in
      let st  = st  &: isf3 [0;1;2] in
      let opr = 
        let c = isf3 [0;5] in
        opr &: ((c &: f7_x) |: ((~: c) &: f7_0))
      in
      let opi, sfti = 
        opi &: notf3[1;5], 
        opi &: ((f3.(1) &: f7_0) |: (f3.(5) &: f7_x))
      in
      ~: (reduce (|:) 
        [lui; auipc; jal; jalr; bra; ld; st; opi; sfti; opr; 
          fence; fencei; scall; sbreak; rdcycle; rdtime; rdinstret])
    in

    let open Insn.T in
    let insn = [
      Lui, lui; 
      Auipc, auipc; 
      Jal, jal; 
      Jalr, jalr; 
      Beq, bra &: f3.(0); 
      Bne, bra &: f3.(1); 
      Blt, bra &: f3.(4); 
      Bge, bra &: f3.(5); 
      Bltu, bra &: f3.(6); 
      Bgeu, bra &: f3.(7); 
      Lb, ld &: f3.(0); 
      Lh, ld &: f3.(1); 
      Lw, ld &: f3.(2); 
      Lbu, ld &: f3.(4); 
      Lhu, ld &: f3.(5); 
      Sb, st &: f3.(0); 
      Sh, st &: f3.(1); 
      Sw, st &: f3.(2); 
      Addi, opi &: f3.(0); 
      Slti, opi &: f3.(2); 
      Sltiu, opi &: f3.(3); 
      Xori, opi &: f3.(4); 
      Ori, opi &: f3.(6); 
      Andi, opi &: f3.(7); 
      Slli, opi &: f3.(1) &: f7_0; 
      Srli, opi &: f3.(5) &: f7_0; 
      Srai, opi &: f3.(5) &: f7_s; 
      Add, opr &: f3.(0) &: f7_0; 
      Sub, opr &: f3.(0) &: f7_s; 
      Sll, opr &: f3.(1) &: f7_0; 
      Slt, opr &: f3.(2) &: f7_0; 
      Sltu, opr &: f3.(3) &: f7_0; 
      Xor, opr &: f3.(4) &: f7_0; 
      Srl, opr &: f3.(5) &: f7_0; 
      Sra, opr &: f3.(5) &: f7_s; 
      Or, opr &: f3.(6) &: f7_0; 
      And, opr &: f3.(7) &: f7_0; 
      Fence, fence; 
      Fenchi, fencei; 
      Scall, scall; 
      Sbreak, sbreak;
      Rdcycle, rdcycle &: ~: rdhigh; 
      Rdcycleh, rdcycle &: rdhigh; 
      Rdtime, rdtime &: ~: rdhigh; 
      Rdtimeh, rdtime &: rdhigh; 
      Rdinstret, rdinstret &: ~: rdhigh; 
      Rdinstreth, rdinstret &: rdhigh; 
      Trap, trap;
    ] in
    let insn = 
      List.map (fun (i,v) -> Enum.from_enum<Insn.T.t> i, v) insn
      |> List.sort (fun (a,_) (b,_) -> - (compare a b)) 
      |> List.map snd
      |> concat
    in

    { insn; 
      iclass = { 
        Class.trap; 
        lui; auipc; jal; jalr; bra; ld; st; opi; opr; fen; sys; 
        f7 = instr.[30:30]; f3=funct3; 
      } 
    }

end

module Rf(Ifs : Interfaces.S) = struct

  open Ifs
  open HardCaml.Signal.Comb

  module I = interface
    clk[1] clr[1]
    wr[1] wa[log_regs] d[xlen]
    ra1[log_regs] ra2[log_regs]
  end

  module O = interface
    q1[xlen] q2[xlen]
  end

  let f i = 
    let open I in
    let module Seq = Utils.Regs(struct let clk=i.clk let clr=i.clr end) in

    let wen = binary_to_onehot i.wa in
    let regs = 
      Array.to_list @@
      Array.init num_regs 
        (fun j -> 
          if j=0 then zero xlen 
          else Seq.reg ~e:(i.wr &: wen.[j:j]) i.d -- (Printf.sprintf "reg_%.2i" j)) 
    in
    O.({
      q1 = mux i.ra1 regs;
      q2 = mux i.ra2 regs;
    })

end

module Make(Ifs : Interfaces.S) = struct

  open HardCaml.Signal.Comb 
  module Insn = Make_insn_decoder(Ifs)(HardCaml.Signal.Comb) 

  let imm_uj ~instr = 
    let d = sresize (instr.[31:12] @: gnd) Ifs.xlen in
    let rec f off = function
      | [] -> []
      | (h,l) :: tl -> 
        let w = h-l+1 in
        (l, select d (off+w-1) off) :: f (off + w) tl
    in
    concat @@ List.map snd @@ List.sort (fun a b -> compare (fst b) (fst a)) @@ 
      f 0 [0,0; 19,12; 11,11; 10,1; 31,20]

  let imm ~c ~instr ~imm_uj = 
    let open Ifs.Class in
    let smap x l = List.map (fun (h,l) -> x.[h:l]) l in
    pmux [
      c.jal, imm_uj;
      c.lui |: c.auipc, instr.[31:12] @: zero 12;
      c.jalr |: c.ld |: c.opi, sresize instr.[31:20] Ifs.xlen;
      c.bra, sresize (concat ((smap instr [(31,31); (7,7); (30,25); (11,8)]) @ [gnd])) Ifs.xlen;
      c.st, sresize (concat (smap instr [(31,25); (11,7)])) Ifs.xlen;
    ] (zero Ifs.xlen)

  let decoder ~inp ~pipe = 

    let open Ifs.Stage in
    let module Seq = Utils.Regs(struct let clk=inp.Ifs.I.clk let clr=inp.Ifs.I.clr end) in
    let open Insn in
    let open Ifs.Class in

    let instr = inp.Ifs.I.mio_rdata in
    let d = decoder instr in
    let c = d.iclass in

    (* extract immediate field *)
    let imm_uj = imm_uj instr in
    let imm = imm ~c ~instr ~imm_uj in

    (* register addresses *)
    let rad, ra1, ra2 = instr.[11:7], instr.[19:15], instr.[24:20] in
    let rad_zero, ra1_zero, ra2_zero = rad ==:. 0, ra1 ==:. 0, ra2 ==:. 0 in

    (* (async) regiser file *)
    let module Rf = Rf(Ifs) in
    let rfo = 
      Rf.f 
        Rf.I.({ 
          clk=inp.Ifs.I.clk; clr=inp.Ifs.I.clr;
          (* write from commit stage *)
          wr=gnd; wa=zero Ifs.log_regs; d=pipe.rdd (* XXX *); 
          (* read *)
          ra1; ra2; 
        })
    in
    let rd1, rdm = rfo.Rf.O.q1, rfo.Rf.O.q2 in 
    let rd2 = mux2 (c.opi |: c.lui |: c.auipc |: c.ld |: c.st) imm rdm in 

    let pen = Seq.reg ~e:vdd pipe.pen in

    { pipe with 
      pen; 
      ra1; ra2; rad;
      ra1_zero; ra2_zero; rad_zero;
      rd1; rd2; rdm;
      instr; insn=d.insn; iclass=d.iclass; }

end

