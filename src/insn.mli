module T : module type of Riscv.RV32I.T
module V : Utils.BVec_S with type t = T.t

