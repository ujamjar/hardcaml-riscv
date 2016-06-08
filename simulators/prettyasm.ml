(* quick hack ... properly pretty print the asm instructions *)

let mask n = 
  if n=0 then 0l
  else Int32.(shift_right_logical (of_int (-1)) (32-n))

let field l h x = 
  let w = h-l+1 in
  Int32.(logand
          (shift_right_logical x l)
          (mask w))

let sfield l h x = 
  let w = h-l+1 in
  let x = field l h x in
  if w < 32 && field h h x = 1l then 
    Int32.(logor
            (shift_left (mask (32-w)) w)
            x)
  else x

let pack x = fst @@ List.fold_left 
  (fun (acc,l) (x,w) ->
    Int32.(logor acc (shift_left x l)), (l+w))
  (0l,0) x

type u = 
  {
    opcode : Int32.t;
    rd : Int32.t;
    imm : Int32.t;
  }

let u_imm x = sfield 20 31 x

let u x = 
  let imm = u_imm x in
  {
    opcode = field 0 6 x;
    rd = field 7 11 x;
    imm;
  }

let uj_imm x = 
  let i_10_1 = field 21 30 x in
  let i_11 = field 20 20 x in
  let i_12_19 = field 12 19 x in
  let i_20 = sfield 31 31 x in
  pack [
    0l, 1;
    i_10_1, 10;
    i_11, 1;
    i_12_19, 8;
    i_20, 1;
  ]

let uj x = 
  let imm = uj_imm x in
  {
    opcode = field 0 6 x;
    rd = field 7 11 x;
    imm;
  }

type i = 
  {
    opcode : Int32.t;
    rd : Int32.t;
    f3 : Int32.t;
    rs1 : Int32.t;
    imm : Int32.t;
  }

let i_imm x = sfield 20 31 x

let i x = 
  let imm = i_imm x in
  {
    opcode = field 0 6 x;
    rd = field 7 11 x;
    f3 = field 12 14 x;
    rs1 = field 15 19 x;
    imm;
  }

type s = 
  {
    opcode : Int32.t;
    f3 : Int32.t;
    rs1 : Int32.t;
    rs2 : Int32.t;
    imm : Int32.t;
  }

let sb_imm x = 
  let i_11 = field 7 7 x in
  let i_1_4 = field 8 11 x in
  let i_5_10 = field 25 30 x in
  let i_12 = sfield 31 31 x in
  pack [
    0l, 1;
    i_1_4, 4;
    i_5_10, 6;
    i_11, 1;
    i_12, 1;
  ]
  

let sb x = 
  let imm = sb_imm x in
  {
    opcode = field 0 6 x;
    f3 = field 12 14 x;
    rs1 = field 15 19 x;
    rs2 = field 15 19 x;
    imm;
  }

let s_imm x = 
  let i_0_4 = field 7 11 x in
  let i_5_11 = sfield 25 31 x in
  pack [
    i_0_4, 5;
    i_5_11, 7;
  ]

let s x = 
  let imm = s_imm x in
  {
    opcode = field 0 6 x;
    f3 = field 12 14 x;
    rs1 = field 15 19 x;
    rs2 = field 20 24 x;
    imm;
  }

type r = 
  {
    opcode : Int32.t;
    f3 : Int32.t;
    f7 : Int32.t;
    rd : Int32.t;
    rs1 : Int32.t;
    rs2 : Int32.t;
  }

let r x = 
  {
    opcode = field 0 6 x;
    f3 = field 12 14 x;
    f7 = field 25 31 x;
    rd = field 7 11 x;
    rs1 = field 15 19 x;
    rs2 = field 20 24 x;
  }

(* XXXXXXXXXXXX FIX X_imm functions *)
open Printf 

let pretty_i s x = 
  let y = i x in
  sprintf "%s x%li, x%li, %li" s y.rd y.rs1 y.imm

let pretty_r s x = 
  let y = r x in
  sprintf "%s x%li, x%li, x%li" s y.rd y.rs1 y.rs2

let pretty_sb s x = 
  let y = sb x in
  sprintf "%s x%li, x%li, %li" s y.rs1 y.rs2 y.imm

let pretty_uj s x = 
  let y = uj x in
  sprintf "%s x%li, %li" s y.rd y.imm

let pretty_u s x = 
  let y = u x in
  sprintf "%s x%li, %li" s y.rd y.imm

let pretty_i_mem s x = 
  let y = i x in
  sprintf "%s x%li, %li(x%li)" s y.rd y.imm y.rs1

let pretty_s s' x = 
  let y = s x in
  sprintf "%s x%li, %li(x%li)" s' y.rs2 y.imm y.rs1

let pretty_i_shift s x =
  let y = i x in
  sprintf "%s x%li, x%li, %li" s y.rd y.rs1 
    Int32.(logand 31l y.imm)

let pretty x =
  match Riscv.RV32I.T.to_t x with
  | `beq -> pretty_sb "beq" x
  | `bne -> pretty_sb "bne" x
  | `blt -> pretty_sb "blt" x
  | `bge -> pretty_sb "bge" x
  | `bltu -> pretty_sb "bltu" x
  | `bgeu -> pretty_sb "bgeu" x
  | `jalr -> pretty_i "jalr" x
  | `jal -> pretty_uj "jal" x
  | `lui -> pretty_u "lui" x
  | `auipc -> pretty_u "auipc" x
  | `addi -> pretty_i "addi" x
  | `slti -> pretty_i "slti" x
  | `sltiu -> pretty_i "sltiu" x
  | `xori -> pretty_i "xori" x
  | `ori -> pretty_i "ori" x
  | `andi -> pretty_i "andi" x
  | `add -> pretty_r "add" x
  | `sub -> pretty_r "sub" x
  | `sll -> pretty_r "sll" x
  | `slt -> pretty_r "slt" x
  | `sltu -> pretty_r "sltu" x
  | `xor_ -> pretty_r "xor" x
  | `srl -> pretty_r "srl" x
  | `sra -> pretty_r "sra" x
  | `or_ -> pretty_r "or" x
  | `and_ -> pretty_r "and" x
  | `slli -> pretty_i_shift "slli" x
  | `srli -> pretty_i_shift "srli" x
  | `srai -> pretty_i_shift "srai" x
  | `lb -> pretty_i_mem "lb" x
  | `lh -> pretty_i_mem "lh" x
  | `lw -> pretty_i_mem "lw" x
  | `lbu -> pretty_i_mem "lbu" x
  | `lhu -> pretty_i_mem "lhu" x
  | `sb -> pretty_s "sb" x
  | `sh -> pretty_s "sh" x
  | `sw -> pretty_s "sw" x
  | `fence -> "fence" (* XXX pred+succ *)
  | `fence_i -> "fencei"
  | `ecall -> "ecall"
  | `ebreak -> "ebreak"
  (*| `csrrs -> "csrrs"*)

