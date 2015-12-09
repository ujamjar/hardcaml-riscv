open HardCaml.Signal.Comb

module Make(X : HardCaml.Interface.S) = struct

  (*include X*)

  type 'a t = 'a X.t

  let to_list = X.to_list
  let t = X.t

  let map = X.map
  let map2 = X.map2

  let mapn f = map (fun (n,_) -> f n) t
  let mapb f = map (fun (_,b) -> f b) t

  let zip2 a b = map2 (fun a b -> a,b) a b
  let zip3 a b c = map2 (fun (a,b) c -> a,b,c) (zip2 a b) c
  let zip4 a b c d = map2 (fun (a,b) (c,d) -> a,b,c,d) (zip2 a b) (zip2 c d)
  let zip5 a b c d e = map2 (fun (a,b,c) (d,e) -> a,b,c,d,e) (zip3 a b c) (zip2 d e)
  let zip6 a b c d e f = map2 (fun (a,b,c) (d,e,f) -> a,b,c,d,e,f) (zip3 a b c) (zip3 d e f)

  let map3 fn a b c = map (fun (a,b,c) -> fn a b c) (zip3 a b c)
  let map4 fn a b c d = map (fun (a,b,c,d) -> fn a b c d) (zip4 a b c d)
  let map5 fn a b c d e = map (fun (a,b,c,d,e) -> fn a b c d e) (zip5 a b c d e)
  let map6 fn a b c d e f = map (fun (a,b,c,d,e,f) -> fn a b c d e f) (zip6 a b c d e f)

  type ifs = HardCaml.Signal.Comb.t t

  let wiren () = map (fun (n,b) -> wire b -- n) t
  let wire () = mapb wire 

  let consti i = mapb (fun b -> consti b i) 
  let zero = consti 0
  let one = consti 1
  let ones = consti (-1)

  let (&:) = map2 (&:)
  let (|:) = map2 (|:)
  let (^:) = map2 (^:)
  let (~:) = map (~:)

  let ( +: ) = map2 ( +: )
  let ( -: ) = map2 ( -: )
  let ( *: ) = map2 ( *: )
  let ( *+ ) = map2 ( *+ )

  let pack d = HardCaml.Signal.Comb.concat (List.rev @@ to_list d)
  let unpack d = 
    let rec f l t = 
      match t with
      | [] -> []
      | (n,b)::t -> (n, (select d (b+l-1) l)) :: f (b+l) t
    in
    let s = f 0 (to_list t) in
    mapn (fun n -> List.assoc n s)

  module L = struct

    type 'a l = 'a list t

    let empty () = X.map (fun _ -> []) X.t
    let rev l = X.map List.rev l
    let cons h t = X.map2 (fun h t -> h::t) h t
    let hd l = X.map List.hd l
    let tl l = X.map List.tl l

    let rec of_list = function
      | [] -> empty ()
      | h::t -> cons h (of_list t)

    let rec to_list l = 
      try 
        let h = hd l in
        let t = tl l in
        h :: to_list t
      with _ -> []

    let map f l =
      let rec g l = 
        try 
          let h = hd l in
          let t = tl l in
          f h :: g t
        with _ -> []
      in
      of_list (g l)

  end

  let mux s l = X.map (mux s) (L.of_list l)
  let mux2 s h l = mux s [l;h]
  let concat l = X.map concat (L.of_list l)
  let select h l d = X.map (fun d -> select d h l) d
  let msb = X.map msb 
  let msbs = X.map msbs
  let lsb = X.map lsb 
  let lsbs = X.map lsbs

end


