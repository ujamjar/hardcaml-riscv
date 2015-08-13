(** Caches
 
  The main logic in a cache is the hit/miss and eviction logic.
  This uses the incoming address and some state to figure out if 
  something is in the cache or not.  If it's not something has to 
  be evicted to make way.

  On a cache hit the logic will provide an address into a memory
  buffer which gives the required data.  On a cache miss a
  statemachine which interacts with the memory subsystem 
  needs to update the cache with valid data.

*)

(** Configuration *)
module type Config = sig
  (** data bits *)
  val data : int

  (** total (byte) address bits *)
  val addr : int

  (** cache line block address bits (ie 0 = 1, 4 = 2^4 (16) words) *)
  val line : int

  (** cache size bits *)
  val size : int
end

module Lru(B : HardCaml.Comb.S)(C : sig val numways : int end) : sig

  val vwidth : int

  module I : interface
    current
    access
  end

  module O : interface
    update
    lru_pre
    lru_post
  end

  val lru : B.t I.t -> B.t O.t

end

module Make(B : Config) : sig

  module I : interface
    clk clr
    en rw
    addr
  end
  
  module O : interface
    hit
    addr_o
  end

  open HardCaml.Signal

  val direct_mapped : Comb.t I.t -> Comb.t O.t

  val set_associative : int -> Comb.t I.t -> Comb.t O.t

end



