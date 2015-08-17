module type S = sig
  (* 32 or 64 bit *)
  val xlen : int 
  (* processor start address *)
  val start_addr : int
end


