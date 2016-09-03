
module Make_insn_decoder(Ifs : Interfaces.S)(B : HardCaml.Comb.S) = struct

  open Ifs
  open B

  type t = 
    {
      insn : B.t;
      iclass : B.t Class.t;
      csr : B.t Csr_ctrl.t;
    }

  let sel insn b = let b = Config.T.Enum_t.from_enum b in insn.[b:b] 

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

  let imm ~c ~instr ~insn ~imm_uj = 
    let open Ifs.Class in
    let smap x l = List.map (fun (h,l) -> x.[h:l]) l in
    let jal, jalr, lui, auipc = 
      let sel = sel insn in
      sel `jal, sel `jalr, sel `lui, sel `auipc
    in
    pmux [
      jal, imm_uj;
      lui |: auipc, instr.[31:12] @: zero 12;
      jalr |: c.ld |: c.opi, sresize instr.[31:20] Ifs.xlen;
      c.bra, sresize (concat ((smap instr [(31,31); (7,7); (30,25); (11,8)]) @ [gnd])) Ifs.xlen;
      c.st, sresize (concat (smap instr [(31,25); (11,7)])) Ifs.xlen;
      c.csr, uresize instr.[19:15] Ifs.xlen;
    ] (zero Ifs.xlen)


  let decode_csrs csrs func = 
    let open Csr.Specs in
    let csrs = List.map (fun csr -> List.assoc csr Csr.Specs.all_csrs) csrs in
    let csrs = List.map (fun csr -> (consti 12 csr.addr) ==: func) csrs in
    let dec = List.fold_left (|:) gnd csrs in
    (concat @@ List.rev csrs), dec

  let decode_csrs_ctrl ~funct3 ~funct12 ~rs1 ~f3 ~sys = 
    let csr_dec, csr_address_valid = decode_csrs Ifs.csrs funct12 in
    let csr = sys &: (~: (f3.(0) |: f3.(4))) in
    let csr_use_imm = funct3.[2:2] in
    let csr_imm = rs1 in
    let csr_clr = f3.(3) |: f3.(7) in
    let csr_set = f3.(2) |: f3.(6) in
    let csr_write = f3.(1) |: f3.(5) in
    let csr_read_only = funct12.[11:10] ==:. 0b11 in
    {
      Csr_ctrl.csr_dec;
      csr_use_imm; csr_imm;
      csr_clr; csr_set; csr_write;
      csr_read_only;
      csr_address_valid;
      csr_reg_write = gnd;
      csr_file_write = gnd;
    }, 
    csr, 
    sys &: f3.(1), sys &: f3.(2), sys &: f3.(3),
    sys &: f3.(5), sys &: f3.(6), sys &: f3.(7)

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

    let ecall, ebreak, uret, sret, hret, mret, wfi = 
      let f12_0 = (funct12.[11:10] ==:. 0) &: (funct12.[7:3] ==:. 0) in
      let f12_c = funct12.[9:8] @: funct12.[2:0] in
      let c = f12_0 &: rs1_0 &: f3.(0) &: rd_0 &: sys in
      let dec b x = if b then (f12_c ==:. x) &: c else gnd in
      dec true 0b00000, 
      dec true 0b00001, 
      dec Ifs.support_uret 0b00010, 
      dec Ifs.support_sret 0b01010, 
      dec Ifs.support_hret 0b10010, 
      dec Ifs.support_mret 0b11010, 
      dec Ifs.support_wfi  0b01101
    in
    let eret = (uret |: sret |: hret |: mret) in

    let csr_ctrl, csr,
        csrrw, csrrs, csrrc,
        csrrwi, csrrsi, csrrci = 
      decode_csrs_ctrl ~funct3 ~funct12 ~f3 ~rs1 ~sys
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
         fence; fencei; ecall; ebreak; 
         eret; wfi; csr])
    in

    let open Config.T in
    let insn = [
      `lui, lui; 
      `auipc, auipc; 
      `jal, jal; 
      `jalr, jalr; 
      `beq, bra &: f3.(0); 
      `bne, bra &: f3.(1); 
      `blt, bra &: f3.(4); 
      `bge, bra &: f3.(5); 
      `bltu, bra &: f3.(6); 
      `bgeu, bra &: f3.(7); 
      `lb, ld &: f3.(0); 
      `lh, ld &: f3.(1); 
      `lw, ld &: f3.(2); 
      `lbu, ld &: f3.(4); 
      `lhu, ld &: f3.(5); 
      `sb, st &: f3.(0); 
      `sh, st &: f3.(1); 
      `sw, st &: f3.(2); 
      `addi, opi &: f3.(0); 
      `slti, opi &: f3.(2); 
      `sltiu, opi &: f3.(3); 
      `xori, opi &: f3.(4); 
      `ori, opi &: f3.(6); 
      `andi, opi &: f3.(7); 
      `slli, opi &: f3.(1) &: f7_0; 
      `srli, opi &: f3.(5) &: f7_0; 
      `srai, opi &: f3.(5) &: f7_s; 
      `add, opr &: f3.(0) &: f7_0; 
      `sub, opr &: f3.(0) &: f7_s; 
      `sll, opr &: f3.(1) &: f7_0; 
      `slt, opr &: f3.(2) &: f7_0; 
      `sltu, opr &: f3.(3) &: f7_0; 
      `xor_, opr &: f3.(4) &: f7_0; 
      `srl, opr &: f3.(5) &: f7_0; 
      `sra, opr &: f3.(5) &: f7_s; 
      `or_, opr &: f3.(6) &: f7_0; 
      `and_, opr &: f3.(7) &: f7_0; 
      `fence, fence; 
      `fence_i, fencei; 
      `ecall, ecall; 
      `ebreak, ebreak;
      `uret, uret;
      `sret, sret;
      `hret, hret;
      `mret, mret;
      `wfi, wfi;
      `csrrw, csrrw;
      `csrrs, csrrs; 
      `csrrc, csrrc; 
      `csrrwi, csrrwi;
      `csrrsi, csrrsi;
      `csrrci, csrrci;
    ] in
    let insn = 
      List.map (fun (i,v) -> Enum.from_enum<Config.T.t> i, v) insn
      |> List.sort (fun (a,_) (b,_) -> - (compare a b)) 
      |> List.map snd
      |> concat
    in
    let ld, st = ld &: (~: trap), st &: (~: trap) in

    let level = 
      pmux [
        csr, funct12.[9:8];
        (sel insn `mret |: sel insn `wfi), const "11";
        (sel insn `hret), const "10";
        (sel insn `sret), const "01"; (* XXX sfence.vm *)
      ] (const "00")
    in

    { insn; 
      iclass = { 
        Class.bra; ld; st; opi; opr; fen; sys; 
        csr; ecall; eret;
        f7 = instr.[30:30]; f3=funct3; 
        level;
      };
      csr = csr_ctrl;
    }, trap

end

module Make(Ifs : Interfaces.S)(B : HardCaml.Comb.S) = struct

  open B
  module Insn = Make_insn_decoder(Ifs)(B) 

  let decoder ~inp ~csrs ~fet = 

    let open Ifs in
    let open Stage in
    let open Insn in
    let open Class in

    let instr = inp.I.mi.Mi_instr.rdata in
    let d, trap = decoder instr in
    let c = d.iclass in
    let sel = sel d.insn in

    (* extract immediate field *)
    let imm_uj = imm_uj instr in
    let imm = imm ~c ~instr ~insn:d.insn ~imm_uj in

    (* register addresses *)
    let rad, ra1, ra2 = instr.[11:7], instr.[19:15], instr.[24:20] in
    let rad_zero, ra1_zero, ra2_zero = rad ==:. 0, ra1 ==:. 0, ra2 ==:. 0 in

    (* is register file written *)
    let rwe = (~: (trap |: c.bra |: c.st |: c.fen |: c.sys)) in

    (* is rd2 used in pipeline *)
    let is_pipe_imm = c.opi |: sel `lui |: sel `auipc |: sel `jal |: sel `jalr in
    (* rd2 uses immediate encoding in alu (but may be used in mem stage) *)
    let is_imm = is_pipe_imm |: c.ld |: c.st in
    (* ra2 is unused so mark as zero *)
    let ra2_zero = ra2_zero |: is_pipe_imm in

    { fet with 
      ra1; ra2; rad;
      ra1_zero; ra2_zero; rad_zero;
      rwe;
      is_imm; imm; 
      instr; insn=d.insn; iclass=d.iclass; csr=d.csr;
      exn = { 
        Exn.invalid_instr_trap = trap; 
        invalid_instr_level = gnd;
      };
    }

  let name = "dec"

  let f ~inp ~comb ~pipe = 
    let open Ifs.Stage in
    let open Ifs.Stages in
    let csrs = Ifs.Csr_regs_ex.zero in
    decoder ~inp ~csrs ~fet:pipe.fet

end

