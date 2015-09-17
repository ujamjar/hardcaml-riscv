module type Config = sig
  val data : int
  val addr : int
  val line : int
  val size : int
end

module Lru(B : HardCaml.Comb.S)(C : sig val numways : int end) = struct

  open B

  let vwidth = C.numways * (C.numways-1) / 2

  (* note totally sure about the interface to this.
   * it seems you need to first get the lru way (with access=0)
   * then reapply it with (on access) to update the logic.
   * can this be split so they both happen? that would seem
   * to be a better interface for what I have in mind *)

  module I = interface
    current[vwidth]
    access[C.numways]
  end

  module O = interface
    update[vwidth]
    lru_pre[C.numways]
    lru_post[C.numways]
  end

  let idx i j = 
    let rec f n off =
      if n=i then off+j-i-1
      else f (n+1) (off+C.numways-n-1)
    in
    f 0 0

  let upper_diag = 
    let rec g i j = 
      if i = C.numways then []
      else if j = C.numways then g (i+1) (i+2)
      else (i,j) :: g i (j+1)
    in
    g 0 1

  let expand current = 
    Array.init C.numways (fun i ->
      Array.init C.numways (fun j ->
        if i = j then vdd
        else if j > i then bit current (idx i j)
        else ~: (bit current (idx j i))))

  let compress expand = 
    concat @@ List.rev @@ List.map (fun (i,j) -> expand.(i).(j)) upper_diag

  let mask expand access = 
    let access = Array.init (width access) (fun i -> access.[i:i]) in
    Array.mapi 
      (fun i a -> 
        let c = access.(i) in
        Array.mapi 
          (fun j x -> 
            let d = access.(j) in
            if i = j then x
            else mux2 c gnd (mux2 d vdd x)) a) expand (* (!c & (d | x)) = c ? 0 : (d ? 1 : x) *)

  let onehot expand = 
    concat @@ List.rev @@ Array.to_list @@
      Array.map (fun a -> reduce (&:) (Array.to_list a)) expand

  let lru i = 
    let open I in

    let expand = expand i.current in
    let lru_pre = onehot expand in
    let expand = mask expand i.access in
    let update = compress expand in
    let lru_post = onehot expand in

    O.{
      update;
      lru_pre;
      lru_post;
    }
end

module Make(B : Config) = struct

  (* address setup
     [ ..... tag ..... | slot | block | ldbits ] *)

  open HardCaml.Signal.Comb

  let ldbits = HardCaml.Utils.clog2 B.data - 3
  let tagbits = B.addr - B.size - B.line - ldbits

  let () = assert (tagbits > 0)

  module I = interface
    clk[1] clr[1]
    en[1] addr[B.addr] data[B.data] rw[1]
    men[1] maddr[B.addr] mdata[B.data] mrw[1]
  end
  
  (* 4 cases, all instigated by the pipeline

    1) read, hit - read directly from cache
    2) read, miss - request data from memory interface, evict cache line (if dirty)
    3) write, hit - write directly into cache
    4) write, miss - evict cache line, write data

    For an instruction cache we only read, so things are a bit simpler.

  *)
  
  module O = interface
    hit[1]
    data[B.data]
  end

  (* XXX TODO: allow line = 0 for caches which dont require spatial correlation *)

  let direct_mapped i =
    let open I in
    let module Seq = Utils.Regs(struct let clk=i.clk let clr=i.clr end) in

    assert (width i.addr = B.addr);
    assert (width i.maddr = B.addr);

    (* address in cache line *)
    let extract_addr addr = 
      let line = try addr.[B.line+ldbits-1:ldbits] -- "cache_line" with _ -> empty in
      let slot = addr.[B.size+B.line+ldbits-1:B.line+ldbits] -- "cache_slot" in
      let tag = addr.[B.addr-1:B.addr-tagbits] -- "cache_tag" in
      line, slot, tag
    in

    let line, slot, tag = extract_addr i.addr in
    let mline, mslot, mtag = extract_addr i.maddr in

    let () = 
      let open Printf in
      printf "direct_mapped:\n";
      printf " data = %i(%i) addr = %i\n" B.data ldbits B.addr;
      printf " bytes/word = %i\n" (1 lsl ldbits);
      printf " words/cache line = %i\n" (1 lsl B.line);
      printf " cache lines = %i\n" (1 lsl B.size);
      printf " tag bits = %i (%i)\n" tagbits (width tag);
      printf " slot bits = %i\n" (width slot);
      printf " cache bytes = %i\n" (1 lsl (B.data/8 + B.size + B.line));
      printf "%!"
    in

    (* tags *)
    let tag' = Seq.ram_wbr (1 lsl B.size) 
      ~we:i.men ~wa:slot ~d:tag ~ra:slot ~re:i.en
    in

    (* valid bits *)
    let valid = Seq.reg ~e:i.en @@ Seq.memory (1 lsl B.size)
      ~c:i.clr ~cv:gnd (* global clear / cache flush *)
      ~we:i.men ~wa:slot ~d:vdd ~ra:slot 
    in

    (* cache data *)
    let addr_c = concat_e [ slot; line ] in
    let addr_m = concat_e [ mslot; mline ] in
    let data = Seq.ram_wbr (1 lsl (B.size + B.line))
      ~we:gnd ~wa:addr_c ~d:(zero B.data) ~ra:addr_c ~re:i.en
    in

    let hit = valid &: (tag ==: tag') in

    O.({ hit; data })

end

