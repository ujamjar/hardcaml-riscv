module Direct_mapped(Cfg : Cache.Config) : sig

  open HardCaml.Api

  module I : interface
    clk clr 
    (* control from pipeline or memory controller *)
    msel
    (* from pipeline *)
    paddr pdata pwe pre
    (* from memory controller *)
    maddr mdata mwe mre
  end
  
  module O : interface
    (* flags to memory controller *)
    miss hit dirty 
    (* data from cache *)
    data_o 
    (* memory address of cache line to evict *)
    evict_addr
  end

  val rmemory : clk:Comb.t -> clr:Comb.t ->
    we:Comb.t -> wa:Comb.t -> d:Comb.t -> ra:Comb.t -> Comb.t
  
  val f : Comb.t I.t -> Comb.t O.t

end

module Controller(B : Cache.Config) : sig

  module I : interface
    clk clr
    (* status bits *)
    miss rw dirty
    (* memory address of cache access *)
    addr 
    (* memory address of cache line to evict *)
    evict_addr
    (* memory interface response *)
    mvld 
    (* data from memory interface *)
    mdata_i
    (* data from cache *)
    cdata_i
  end
  module O : interface
    (* stall pipeline *)
    stall 
    (* memory controller selects cache access *)
    msel 
    (* statemachine *)
    state
    (* memory access *)
    mreq maddr mdata_o mrw
    (* cache access *)
    cwe cre caddr cdata_o
  end

  module Sm : sig
    type t = [
      | `wait
      | `load
      | `store_re
      | `store_nxt
    ] deriving(Enum,Bounded,Show)
    val name : string
  end
  module Sm_v : Utils.BVec_S

  open HardCaml.Signal
  val f : Comb.t I.t -> Comb.t O.t

end


