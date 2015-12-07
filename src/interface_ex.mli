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

  open HardCaml.Signal

  type ifs = Comb.t t

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

  val pack : ifs -> Comb.t
  val unpack : Comb.t -> ifs

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

  val mux : Comb.t -> ifs list -> ifs
  val concat : ifs list -> ifs
  val select : int -> int -> ifs -> ifs
  val msb : ifs -> ifs
  val msbs : ifs -> ifs
  val lsb : ifs -> ifs
  val lsbs : ifs -> ifs

end with type 'a t = 'a X.t

