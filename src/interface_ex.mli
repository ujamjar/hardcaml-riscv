module Make(X : HardCaml.Interface.S) : sig

  type 'a t 

  val t : (string * int) t
  val to_list : 'a t -> 'a list

  val mapn : (string -> 'a) -> 'a t
  val mapb : (int -> 'a) -> 'a t

  val zip2 : 'a t -> 'b t -> ('a * 'b) t
  val zip3 : 'a t -> 'b t -> 'c t -> ('a * 'b * 'c) t
  val zip4 : 'a t -> 'b t -> 'c t -> 'd t -> ('a * 'b * 'c * 'd) t
  val zip5 : 'a t -> 'b t -> 'c t -> 'd t -> 'e t -> ('a * 'b * 'c * 'd * 'e) t
  val zip6 : 'a t -> 'b t -> 'c t -> 'd t -> 'e t -> 'f t -> ('a * 'b * 'c * 'd * 'e * 'f) t

  val map : 
    ('a -> 'b) -> 
    'a t -> 'b t 
  val map2 : 
    ('a -> 'b -> 'c) ->
    'a t -> 'b t -> 'c t
  val map3 : 
    ('a -> 'b -> 'c -> 'd) ->
    'a t -> 'b t -> 'c t -> 'd t
  val map4 : 
    ('a -> 'b -> 'c -> 'd -> 'e) ->
    'a t -> 'b t -> 'c t -> 'd t -> 'e t
  val map5 : 
    ('a -> 'b -> 'c -> 'd -> 'e -> 'f) ->
    'a t -> 'b t -> 'c t -> 'd t -> 'e t -> 'f t
  val map6 : 
    ('a -> 'b -> 'c -> 'd -> 'e -> 'f -> 'g) ->
    'a t -> 'b t -> 'c t -> 'd t -> 'e t -> 'f t -> 'g t

  val offsets : ?rev:bool -> unit -> int t

  open HardCaml.Signal

  module type S = sig

    type b
    type ifs 

    val wire : unit -> ifs
    val wiren : unit -> ifs
    val consti : int -> ifs
    val zero : ifs
    val one : ifs
    val ones : ifs

    val (&:) : ifs -> ifs -> ifs
    val (|:) : ifs -> ifs -> ifs
    val (^:) : ifs -> ifs -> ifs
    val (~:) : ifs -> ifs

    val ( +: ) : ifs -> ifs -> ifs
    val ( -: ) : ifs -> ifs -> ifs
    val ( *: ) : ifs -> ifs -> ifs
    val ( *+ ) : ifs -> ifs -> ifs

    val pack : ?rev:bool -> ifs -> b
    val unpack : ?rev:bool -> b -> ifs

    module L : sig
      type 'a l = 'a list t
      val empty : unit -> 'a l
      val rev : 'a l -> 'a l
      val map : ('a t -> 'b t) -> 'a l -> 'b l
      val cons : 'a t -> 'a l -> 'a l
      val hd : 'a l -> 'a t
      val tl : 'a l -> 'a l
      val of_list : 'a t list -> 'a l
      val to_list : 'a l -> 'a t list
    end

    val mux : b -> ifs list -> ifs
    val mux2 : b -> ifs -> ifs -> ifs
    val concat : ifs list -> ifs
    val select : int -> int -> ifs -> ifs
    val msb : ifs -> ifs
    val msbs : ifs -> ifs
    val lsb : ifs -> ifs
    val lsbs : ifs -> ifs

  end

  module Make(B : HardCaml.Comb.S) : S
    with type b = B.t
    and  type ifs = B.t t
  
  include S 
    with type b = HardCaml.Signal.Comb.t
    and  type ifs = HardCaml.Signal.Comb.t t

end with type 'a t = 'a X.t

