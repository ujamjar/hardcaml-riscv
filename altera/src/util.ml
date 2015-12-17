module Name_map(P : sig val f : string -> string end)(X : HardCaml.Interface.S) = struct
  include X
  let t = map (fun (n,b) -> P.f n, b) t
end
