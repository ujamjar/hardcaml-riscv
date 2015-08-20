open HardCaml

module Regs (X : sig
  val clk : Signal.Comb.t
  val clr : Signal.Comb.t
end) : Signal.Seq

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
end) : BVec_S with type t = X.t

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

module D64(B : Comb.S) : Data with type t = int64 and type bt = B.t
module D32(B : Comb.S) : Data with type t = int32 and type bt = B.t

module Mem(D : Data) : sig
  val masks : D.t array

  val init : words:int -> D.t array

  val read' : memory:D.t array -> addr:int -> D.t
  val write' : memory:D.t array -> addr:int -> data:D.t -> strb:int -> unit

  val read : memory:D.t array -> addr:D.bt -> D.t
  val write : memory:D.t array -> addr:D.bt -> data:D.bt -> strb:D.bt -> unit
end

(** one hot control inputs. log depth muxes *)
val pmux1ht : (Signal.Comb.t * Signal.Comb.t) list -> Signal.Comb.t

(** immediate formatting *)
val i_imm : (imm12:int -> int32) -> imm:int -> int32

val sh_imm : (shamt:int -> int32) -> imm:int -> int32

val s_imm : (imm12hi:int -> imm12lo:int -> int32) -> imm:int -> int32

val b_imm : (bimm12hi:int -> bimm12lo:int -> int32) -> imm:int -> int32

val u_imm : (imm20:int -> int32) -> imm:int -> int32

val j_imm : (jimm20:int -> int32) -> imm:int -> int32

