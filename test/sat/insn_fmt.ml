module type S = sig
  type bits
  type 'a t
  val make : int32 -> bits * bits t
end

module MakeB(B : HardCaml.Comb.S) = struct
  include B
  let funct3 m = B.select m 14 12
  let funct7 m = B.select m 31 25
  let opcode m = B.select m 6 0
end

module I(B' : HardCaml.Comb.S) = struct
  module B = MakeB(B')

  type bits = B.t
  type 'a t = 
    {
      rd : 'a;
      rs1 : 'a;
      imm : 'a;
    }

  let make m = 
    let rd = B.input "rd" 5 in
    let rs1 = B.input "rs1" 5 in
    let imm = B.input "imm" 12 in
    let m = B.consti32 32 m in
    let instr = 
      B.concat [
        imm;
        rs1;
        B.funct3 m;
        rd;
        B.opcode m;
      ]
    in
    instr, { rd; rs1; imm }

end

module I_shift(B' : HardCaml.Comb.S) = struct
  module B = MakeB(B')

  type bits = B.t

  type 'a t = 
    {
      rd : 'a;
      rs1 : 'a;
      imm : 'a;
    }

  let make m = 
    let rd = B.input "rd" 5 in
    let rs1 = B.input "rs1" 5 in
    let imm = B.input "imm" 5 in
    let m = B.consti32 32 m in
    let instr = 
      B.concat [
        B.select m 31 25;
        imm;
        rs1;
        B.funct3 m;
        rd;
        B.opcode m;
      ]
    in
    instr, { rd; rs1; imm }

end

module U(B' : HardCaml.Comb.S) = struct
  module B = MakeB(B')

  type bits = B.t

  type 'a t = 
    {
      rd : 'a;
      imm : 'a;
    }

  let make m = 
    let rd = B.input "rd" 5 in
    let imm = B.input "imm" 20 in
    let m = B.consti32 32 m in
    let instr = 
      B.concat [
        imm;
        rd;
        B.opcode m;
      ]
    in
    instr, { rd; imm }

end

module R(B' : HardCaml.Comb.S) = struct
  module B = MakeB(B')

  type bits = B.t

  type 'a t = 
    {
      rd : 'a;
      rs1 : 'a;
      rs2 : 'a;
    }

  let make m = 
    let rd = B.input "rd" 5 in
    let rs1 = B.input "rs1" 5 in
    let rs2 = B.input "rs2" 5 in
    let m = B.consti32 32 m in
    let instr = 
      B.concat [
        B.funct7 m;
        rs2;
        rs1;
        B.funct3 m;
        rd;
        B.opcode m;
      ]
    in
    instr, { rd; rs1; rs2 }

end

module UJ(B' : HardCaml.Comb.S) = struct
  module B = MakeB(B')

  type bits = B.t

  type 'a t = 
    {
      rd : 'a;
      imm : 'a;
    }

  let make m = 
    let open B in
    let rd = input "rd" 5 in
    let imm = input "imm" 20 in
    let imm' = imm @: gnd in
    let m = consti32 32 m in
    let instr = 
      concat [
        imm'.[20:20];
        imm'.[10:1];
        imm'.[11:11];
        imm'.[19:12];
        rd;
        opcode m;
      ]
    in
    instr, { rd; imm }

end

module SB(B' : HardCaml.Comb.S) = struct
  module B = MakeB(B')

  type bits = B.t
  
  type 'a t = 
    {
      rs1 : 'a;
      rs2 : 'a;
      imm : 'a;
    }

  let make m = 
    let rs1 = B.input "rs1" 5 in
    let rs2 = B.input "rs2" 5 in
    let imm = B.input "imm" 12 in
    let imm' = B.(imm @: gnd) in
    let m = B.consti32 32 m in
    let instr = 
      B.(concat [
        imm'.[12:12];
        imm'.[10:5];
        rs2;
        rs1;
        funct3 m;
        imm'.[4:1];
        imm'.[11:11];
        opcode m;
      ])
    in
    instr, { rs1; rs2; imm }

end

module S(B' : HardCaml.Comb.S) = struct
  module B = MakeB(B')

  type bits = B.t

  type 'a t = 
    {
      rs1 : 'a;
      rs2 : 'a;
      imm : 'a; 
    }

  let make m = 
    let rs1 = B.input "rs1" 5 in
    let rs2 = B.input "rs2" 5 in
    let imm = B.input "imm" 12 in
    let m = B.consti32 32 m in
    let instr = 
      B.(concat [
        imm.[11:5];
        rs2;
        rs1;
        funct3 m;
        imm.[4:0];
        opcode m;
      ])
    in
    instr, { rs1; rs2; imm }

end

module All(B : HardCaml.Comb.S) = struct
  type bits = B.t
  type 'a t = B.t
  let make _ = let b = B.input "instr" 32 in b, b 
end

module Csr(B' : HardCaml.Comb.S) = struct
  module B = MakeB(B')

  type bits = B.t

  type 'a t = 
    {
      rd : 'a;
      rs1 : 'a;
      csr: 'a;
    }

  let make ?csr ?rs1 m = 
    let rd = B.input "rd" 5 in
    let rs1 = 
      match rs1 with
      | None -> B.input "rs1" 5
      | Some(rs1) -> rs1
    in
    let csr = 
      match csr with
      | None -> B.input "csr" 12 
      | Some(csr) -> csr
    in
    let m = B.consti32 32 m in
    let instr = 
      B.concat [
        csr;
        rs1;
        B.funct3 m;
        rd;
        B.opcode m;
      ]
    in
    instr, { rd; rs1; csr }

end

module Const(B' : HardCaml.Comb.S) = struct
  module B = MakeB(B')

  type bits = B.t

  type 'a t = unit 

  let make m = 
    let instr = B.consti32 32 m in
    instr, ()

end

