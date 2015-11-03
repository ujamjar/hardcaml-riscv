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

  (** log2 number of data words / cache line *)
  val line : int

  (** log2 number of cache lines *)
  val size : int
end

module Cfg(C : Config) : sig
  val ldbits : int
  val tagbits : int
  open HardCaml.Signal.Comb
  val extract_addr : ?(--):(t -> string -> t) -> t -> t * t * t
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

module Direct_mapped(B : Config) : sig

  module I : interface
    clk clr
    paddr pdata pre pwe
    msel
    maddr mdata mre mwe
  end
  
  module O : interface
    hit miss dirty
    data waddr
  end

  open HardCaml.Signal
  val f : Comb.t I.t -> Comb.t O.t

end

module Controller(B : Config) : sig

  module I : interface
    clk clr
    miss rw dirty
    addr paddr
    mvld mdata_i
    cdata_i
  end
  module O : interface
    stall msel 
    state
    mreq maddr mdata_o mrw
    cwe cre caddr cdata_o
  end

  open HardCaml.Signal
  val f : Comb.t I.t -> Comb.t O.t

end


