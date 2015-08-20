open HardCaml
open Signal.Comb

module Regs (X : sig
  val clk : t
  val clr : t
end) = struct

  include Signal.Make_seq(struct
    open Signal.Types
    open Signal.Seq
    let reg_spec = { r_sync with reg_clock = X.clk; reg_clear = X.clr; }
    let ram_spec = { r_none with reg_clock = X.clk; }
  end)

end

module type BVec_S = sig
  open HardCaml.Signal
  type t 
  val n : int
  val sel : Comb.t -> t -> Comb.t
  val cname : t -> string
  val list : t list
end

module BVec(X : sig
  type t
  module Show_t : Deriving_Show.Show with type a = t
  module Enum_t : Deriving_Enum.Enum with type a = t
  module Bounded_t : Deriving_Bounded.Bounded with type a = t
  val name : string
end) = struct

  type t = X.t

  let n = 1 + X.Enum_t.from_enum X.Bounded_t.max_bound

  let sel x b = let b = X.Enum_t.from_enum b in x.[b:b]

  let cname x = X.name ^ "_" ^ (String.lowercase (X.Show_t.show x))

  let list = X.Enum_t.enum_from_to X.Bounded_t.min_bound X.Bounded_t.max_bound

end

module type Data = sig
  type t
  type bt
  val bits : int
  val to_int : t -> int
  val of_int : int -> t
  val to_signal : t -> bt
  val of_signal : bt -> t
  val (|:) : t -> t -> t
  val (&:) : t -> t -> t
  val (~:) : t -> t
  val sll : t -> int -> t
end

module D64(B : Comb.S) = struct
  type t = int64
  type bt = B.t
  let bits = 64
  let to_int = Int64.to_int
  let of_int = Int64.of_int
  let to_signal = B.consti64 64
  let of_signal = B.to_int64
  let (|:) = Int64.logor
  let (&:) = Int64.logand
  let (~:) = Int64.lognot
  let sll = Int64.shift_left
end

module D32(B : Comb.S) = struct
  type t = int32
  type bt = B.t
  let bits = 32
  let to_int = Int32.to_int
  let of_int = Int32.of_int
  let to_signal = B.consti32 32
  let of_signal = B.to_int32
  let (|:) = Int32.logor
  let (&:) = Int32.logand
  let (~:) = Int32.lognot
  let sll = Int32.shift_left
end

module Mem(D : Data) = struct
  let masks = 
    let ff = D.of_int 0xff in
    let n = 1 lsl (D.bits / 8) in
    let rec mask j i = 
      if i=0 then D.of_int 0 
      else if (i land 1) = 0 then mask (j+1) (i lsr 1)
      else D.(sll ff (j*8) |: mask (j+1) (i lsr 1))
    in
    Array.init n (mask 0)

  let init ~words = Array.make words (D.of_int 0)

  let read' ~memory ~addr = memory.(addr / 4)
  
  let write' ~memory ~addr ~data ~strb = 
    let addr = addr / 4 in
    let mask = masks.(strb) in
    memory.(addr) <- D.( (memory.(addr) &: (~: mask)) |: (data &: mask) )  

  let read ~memory ~addr = 
    let addr = D.to_int @@ D.of_signal addr in
    read' ~memory ~addr

  let write ~memory ~addr ~data ~strb = 
    let ci x = D.to_int @@ D.of_signal x in (* convert to int *)
    let addr, data, strb = ci addr, D.of_signal data, ci strb in
    write' ~memory ~addr ~data ~strb

end

let pmux1ht x = 
  snd @@ tree 2 
    (function [(c,d)] -> (c,d) 
            | [(a,b);(c,d)] -> (a|:c, mux2 a b d) 
            | _ -> failwith "") x

(* immediate formatting 
 * XXX Shouldn't need to be here.... *)

let msk x n = x land ((1 lsl n)-1)

let i_imm f ~imm = 
  let imm12 = msk imm 12 in
  f ~imm12

let sh_imm f ~imm = 
  let shamt = msk imm 12 in
  f ~shamt

let s_imm f ~imm =
  let imm12lo = msk imm 5 in
  let imm12hi = msk (imm lsr 5) 7 in
  f ~imm12hi ~imm12lo

let b_imm f ~imm = 
  let bimm12lo = ((msk (imm lsr 1) 4) lsl 1) lor (msk (imm lsr 11) 1) in
  let bimm12hi = (msk (imm lsr 5) 6) lor ((msk (imm lsr 12) 1) lsl 6) in
  f ~bimm12hi ~bimm12lo

let u_imm f ~imm = 
  let imm20 = msk (imm lsr 12) 20 in (* XXX wouldn't get full range in 32 bit mode... *)
  f ~imm20

let j_imm f ~imm = 
  let jimm20 = 
    ((msk (imm lsr 12) 3) lsl  0) lor
    ((msk (imm lsr 15) 5) lsl  3) lor
    ((msk (imm lsr 11) 1) lsl  8) lor
    ((msk (imm lsr  1) 4) lsl  9) lor
    ((msk (imm lsr  5) 6) lsl 13) lor
    ((msk (imm lsr 20) 1) lsl 19)
  in
  f ~jimm20


