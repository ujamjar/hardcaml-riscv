module Name_map(P : sig val f : string -> string end)(X : HardCaml.Interface.S) : 
  HardCaml.Interface.S with type 'a t = 'a X.t

