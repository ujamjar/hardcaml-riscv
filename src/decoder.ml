
module Make_insn_decoder(Ifs : Interfaces.S)(B : HardCaml.Comb.S) = struct

  open Ifs
  open B

  type t = 
    {
      insn : B.t;
      iclass : B.t Class.t;
      csr : B.t Csr_ctrl.t;
    }

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
      c.csr, uresize instr.[19:15] Ifs.xlen;
    ] (zero Ifs.xlen)


  let decode_csrs csrs func = 
    let open Csr.Specs in
    let csrs = List.map (fun csr -> List.assoc csr Csr.Specs.all_csrs) csrs in
    let csrs = List.map (fun csr -> (consti 12 csr.addr) ==: func) csrs in
    let dec = List.fold_left (|:) gnd csrs in
    (concat @@ List.rev csrs), dec

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

    let ecall, ebreak, eret, wfi = 
      let f12_0 = (funct12.[11:9] ==:. 0) &: (funct12.[7:2] ==:. 0) in
      let f12_c = funct12.[8:8] @: funct12.[1:0] in
      let c = f12_0 &: rs1_0 &: f3.(0) &: rd_0 &: sys in
      let dec b x = if b then (f12_c ==:. x) &: c else gnd in
      dec true 0b000, 
      dec true 0b001, 
      dec Ifs.support_eret 0b100, 
      dec Ifs.support_wfi  0b110 
    in

    let csr, csr_ctrl, csrs = 
      (* implements csrrs in read-only mode *)
      let simple () = 
        let csr_dec, dec = decode_csrs Ifs.csrs funct12 in
        let csr = rs1_0 &: rd_0 &: f3.(2) &: sys &: dec in
        csr, {
          Csr_ctrl.csr_use_imm = gnd;
          csr_imm = zero 5;
          csr_we_n = gnd;
          csr_re_n = gnd;
          csr_invalid_we = gnd;
          csr_dec;
          csr_clr = gnd;
          csr_set = gnd;
          csr_write = gnd;
        },
        [| gnd; csr; gnd; gnd; gnd; gnd |]
      in
      (* csrrw[i], csrrs[i], csrrc[i] with error checking TODO check machine mode *)
      let full () = 
        (* a supported csr address *)
        let csr_dec, dec = decode_csrs Ifs.csrs funct12 in
        (* valid (csr &: f) => valid instruction *)
        let f = ~: (f3.(0) |: f3.(4)) in (* 1,2,3,5,6,7 *)
        let csr = sys &: dec in
        let csr = csr &: f in
        (* immediate value *)
        let imm = rs1 in
        let use_imm = funct3.[2:2] in
        (* CSR is read only *)
        let ro = funct12.[11:10] ==:. 0b11 in
        (* csr level *)
        (*let level = funct12.[9:8] in*)
        (* write to csr is disabled *)
        let we_n = 
          (* csrrs[i] and csrrc[i] shall not perform write if rs1=imm=x0. *)
          (f3.(2) |: f3.(3) |: f3.(6) |: f3.(7)) &: rs1_0
        in
        (* read (side effect) from csr disableed *)
        let re_n = 
          (* csrrw[i] does not perform read if rd=x0. *)
          (f3.(1) |: f3.(5)) &: rd_0
        in
        (* write is enabled, but csr is read only *)
        let invalid_we = ((~: we_n) |: f3.(1)) &: ro in
        let csr_valid = csr &: (~: invalid_we) in
        let csr_invalid = csr &: invalid_we in
        csr_valid, {
          Csr_ctrl.csr_use_imm = use_imm;
          csr_imm = imm;
          csr_we_n = we_n;
          csr_re_n = re_n;
          csr_invalid_we = csr_invalid;
          csr_dec;
          csr_clr = (f3.(3) |: f3.(7)) &: csr_valid &: (~: we_n);
          csr_set = (f3.(2) |: f3.(6)) &: csr_valid &: (~: we_n);
          csr_write = (f3.(1) |: f3.(5)) &: csr_valid &: (~: we_n);
        }, Array.map (fun i -> csr &: f3.(i) &: (~: invalid_we)) [| 1;2;3;5;6;7 |] 
      in
      if Ifs.support_csrs then full() else simple() 
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
         fence; fencei; ecall; ebreak; eret; wfi; csr])
    in
    let trap = trap |: csr_ctrl.Csr_ctrl.csr_invalid_we in

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
      `eret, eret;
      `wfi, wfi;
      `csrrw, csrs.(0);
      `csrrs, csrs.(1); 
      `csrrc, csrs.(2); 
      `csrrwi, csrs.(3);
      `csrrsi, csrs.(4);
      `csrrci, csrs.(5);
    ] in
    let insn = 
      List.map (fun (i,v) -> Enum.from_enum<Config.T.t> i, v) insn
      |> List.sort (fun (a,_) (b,_) -> - (compare a b)) 
      |> List.map snd
      |> concat
    in
    let insn = trap @: insn in
    let ld, st = ld &: (~: trap), st &: (~: trap) in

    { insn; 
      iclass = { 
        Class.trap; 
        lui; auipc; jal; jalr; bra; ld; st; opi; opr; fen; sys; 
        csr; ecall; eret;
        f7 = instr.[30:30]; f3=funct3; 
      };
      csr = csr_ctrl;
    }

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
    let d = decoder instr in
    let c = d.iclass in

    (* extract immediate field *)
    let imm_uj = imm_uj instr in
    let imm = imm ~c ~instr ~imm_uj in

    (* register addresses *)
    let rad, ra1, ra2 = instr.[11:7], instr.[19:15], instr.[24:20] in
    let rad_zero, ra1_zero, ra2_zero = rad ==:. 0, ra1 ==:. 0, ra2 ==:. 0 in

    let rwe = ~: (c.trap |: c.bra |: c.st |: c.fen |: c.sys) in

    (* is rd2 used in pipeline *)
    let is_pipe_imm = c.opi |: c.lui |: c.auipc |: c.jal |: c.jalr in
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
    }

  let name = "dec"

  let f ~inp ~comb ~pipe = 
    let open Ifs.Stage in
    let open Ifs.Stages in
    let csrs = Ifs.Csr_regs_ex.zero in
    decoder ~inp ~csrs ~fet:pipe.fet

end

