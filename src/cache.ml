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

module Cfg(B : Config) = struct

  open HardCaml.Signal.Comb

  let ldbits = HardCaml.Utils.clog2 B.data - 3
  let tagbits = B.addr - B.size - B.line - ldbits

  let () = assert (tagbits > 0)

  let extract_addr ?((--)=(fun a b -> a)) addr = 
    let line = try addr.[B.line+ldbits-1:ldbits] -- "line" with _ -> empty in
    let slot = addr.[B.size+B.line+ldbits-1:B.line+ldbits] -- "slot" in
    let tag = addr.[B.addr-1:B.addr-tagbits] -- "tag" in
    line, slot, tag
end

module Direct_mapped(B : Config) = struct

  (* address setup
     [ ..... tag ..... | slot | block | ldbits ] *)

  open HardCaml.Signal.Comb
  include Cfg(B)

  module I = interface
    clk[1] clr[1]
    (* pipeline interface *)
    paddr[B.addr] pdata[B.data] pre[1] pwe[1]
    (* memory interface *)
    msel[1] 
    maddr[B.addr] mdata[B.data] mre[1] mwe[1]
  end
  
  (* 4 cases, all instigated by the pipeline

    1) read, hit - read directly from cache
    2) read, miss - evict cache line (if dirty), request data from memory interface, 
    3) write, hit - write directly into cache
    4) write, miss - evict cache line, write data

    Note; For an instruction cache we only read, so things are a bit simpler.

    General control will include flushing of the cache, as required.

  *)
  
  module O = interface
    hit[1] miss[1] dirty[1]
    data[B.data]
    waddr[B.addr]
  end

  let status_bits ~clk ~clr ~we ~slot ~re = 
    let module Seq = Utils.Regs(struct let clk=clk let clr=clr end) in
    Seq.reg ~e:re @@ Seq.memory (1 lsl B.size)
      ~c:clr ~cv:gnd (* global clear / cache flush *)
      ~we ~wa:slot ~d:vdd ~ra:slot 

  let status_bits ~clk ~clr ~we ~slot ~re = 
    let module Seq = Utils.Regs(struct let clk=clk let clr=clr end) in
    let w = 1 lsl (width slot) in
    let q = Seq.reg_fb ~c:clr ~cv:(zero w) ~w ~e:we (fun d -> d |: binary_to_onehot slot) in
    let q = q -- "status_bits" in
    Seq.reg ~e:re (mux slot (List.rev @@ bits q))

  (* XXX TODO: allow line = 0 for caches which dont require spatial correlation *)

  let f i =
    let open I in
    let module Seq = Utils.Regs(struct let clk=i.clk let clr=i.clr end) in

    assert (width i.paddr = B.addr);
    assert (width i.maddr = B.addr);

    let pline, pslot, ptag = extract_addr i.paddr in
    let mline, mslot, mtag = extract_addr i.maddr in

    (* select between memory interface and pipeline *)
    let addr = mux2 i.msel (concat_e [mslot; mline]) (concat_e [pslot; pline]) -- "i_addr" in
    let data = mux2 i.msel i.mdata i.pdata -- "i_data" in
    let re = mux2 i.msel i.mre i.pre -- "i_re" in
    let we = mux2 i.msel i.mwe i.pwe -- "i_we" in
    let tag = mux2 i.msel mtag ptag -- "i_tag" in
    let slot = mux2 i.msel mslot pslot -- "i_slot" in
    let line = mux2 i.msel mline pline -- "i_line" in

    (*let en = (i.msel |: i.pen) -- "i_en" in
    let mwe = i.men &: (~: (i.mrw)) in
    let pwe = i.pen &: (~: (i.prw)) in
    let we = (en &: (~: rw)) -- "i_we" in
    let re = (en &: rw) -- "i_re" in
    *)

    let pstall = wire 1 in
    let pen = ((~: (i.msel)) &: (i.pre |: i.pwe)) in

    let () = 
      let open Printf in
      printf "direct_mapped:\n";
      printf " data = %i(%i) addr = %i\n" B.data ldbits B.addr;
      printf " bytes/word = %i\n" (1 lsl ldbits);
      printf " words/cache line = %i\n" (1 lsl B.line);
      printf " cache lines = %i\n" (1 lsl B.size);
      printf " tag bits = %i (%i)\n" tagbits (width ptag);
      printf " slot bits = %i\n" (width pslot);
      printf " cache bytes = %i\n" (1 lsl (B.data/8 + B.size + B.line));
      printf "%!"
    in

    (* tags *)
    let tag' = Seq.ram_wbr (1 lsl B.size) ~we:i.mwe ~wa:slot ~d:tag ~ra:slot ~re:i.pre in

    (* valid bits *)
    let valid = status_bits ~clk:i.clk ~clr:i.clr ~we:i.mwe ~slot ~re:i.pre in

    (* dirty bits *)
    let dirty = status_bits ~clk:i.clk ~clr:i.clr ~we:i.pwe ~slot ~re:i.pre in

    (* cache data *)
    let data = Seq.ram_rbw (1 lsl (B.size + B.line))
      ~we:we ~wa:addr ~d:data ~ra:addr ~re:(we|:re)
    in

    let tag = Seq.reg ~e:vdd tag in (* XXX what should be use for enable here? *)
    let pen = Seq.reg ~e:vdd pen in
    let match_tag = tag ==: tag' in 
    let hit = pen &: valid &: match_tag in
    let miss = pen &: (~: (valid &: match_tag)) in

    let waddr = concat [ tag'; slot; line; zero ldbits ] in

    O.({ hit; miss; dirty; data; waddr })

end

module Controller(B : Config) = struct

  open HardCaml.Signal.Comb
  include Cfg(B) 

  module Sm = struct
    type t = [
      | `wait 
      | `load
      | `store_re
      | `store_nxt
    ] deriving(Enum,Bounded,Show)
    let name = "sm"
  end
  module Sm_v = Utils.BVec(Sm)

  module I = interface
    clk[1] clr[1]
    miss[1] rw[1] dirty[1] 
    addr[B.addr] paddr[B.addr]
    mvld[1] mdata_i[B.data]
    cdata_i[B.data]
  end

  module O = interface
    stall[1] msel[1] 
    state[Sm_v.n]
    mreq[1] maddr[B.addr] mdata_o[B.data] mrw[1]
    cwe[1] cre[1] caddr[B.addr] cdata_o[B.data]
  end

  let f i = 
    let open I in
    let open HardCaml.Signal.Guarded in
    let module Seq = Utils.Regs(struct let clk=i.clk let clr=i.clr end) in
    let e = vdd in
    let is, sm, next = Seq.statemachine ~e Sm_v.list in
    let msel = Seq.g_reg ~e 1 in
    let maddr, caddr = Seq.g_reg ~e B.addr, Seq.g_reg ~e B.addr in
    let maddr_n, caddr_n = maddr#q +:. 4, caddr#q +:. 4 in
    let cnt = Seq.g_reg ~e B.line in
    let cnt_n = (cnt#q -- "cnt") -:. 1 in
    let mreq = Seq.g_reg ~e 1 in

    let aligned_addr a = a.[width a - 1:B.line+ldbits] @: zero (B.line+ldbits) in

    let () = compile [
      sm [
        `wait, [
          cnt $==. (-1);
          msel $==. 0;
          g_when i.miss [
            msel $==. 1;
            maddr $== aligned_addr i.addr;
            caddr $== aligned_addr i.addr;
            g_if i.rw [
              (* read - load new cache line *)
              mreq $==. 1;
              next `load;
            ] [
              (* write *)
              g_if i.dirty [
                (* current cache line needs to be flushed *)
                caddr $== aligned_addr i.paddr;
                next `store_re;
              ] [
                (* load new cache line *)
                next `load;
              ]
            ]
          ]
        ];

        `load, [
          g_when i.mvld [
            maddr $== maddr_n;
            caddr $== caddr_n;
            cnt $== cnt_n;
            g_when (cnt#q ==:. 0) [
              mreq $==. 0;
              msel $==. 0;
              next `wait;
            ];
          ];
        ];

        `store_re, [
          caddr $== caddr_n;
          mreq $==. 1;
          next `store_nxt;
        ];

        `store_nxt, [
          g_when i.mvld [
            caddr $== caddr_n;
            maddr $== maddr_n;
            cnt $== cnt_n;
            g_when (cnt#q ==:. 0) [
              (* load the cache line *)
              cnt $==. (-1);
              maddr $== aligned_addr i.addr;
              caddr $== aligned_addr i.addr;
              next `load;
            ];
          ]
        ];

      ];
    ] in

    O.({
      stall = i.miss |: ~: (is `wait);
      msel = i.miss |: msel#q;
      state = concat @@ List.rev @@ List.map is Sm_v.list;
      mreq = mreq#q;
      maddr = maddr#q;
      mdata_o = i.cdata_i;
      mrw = vdd; (* XXX *)
      cwe = mreq#q &: i.mvld &: (is `load);
      cre = mreq#q &: (~: (i.rw)) &: ((is `store_re) |: (is `store_nxt));
      cdata_o = i.mdata_i;
      caddr = caddr#q;
    });

end

