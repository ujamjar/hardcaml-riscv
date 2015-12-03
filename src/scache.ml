(* Simpler cache implementation.
 *
 * It will use register banks instead of memory
 * to simplify the pipeline structure.  Its not what
 * we really want as it will be rather large.  
 *
 * note; with 2x clocks (or falling edge or whatever) we
 * could emulate the reg banks with rams, but thats also
 * a bit fiddly.
 *
 * The intention is to work out all the pipeline issues
 * with this simpler version first, before going back to
 * the more efficient implementation. *)

module Direct_mapped(Cfg : Cache.Config) = struct

  open HardCaml.Api.Comb
  include Cache.Cfg(Cfg)

  module I = interface
    clk[1] clr[1] msel[1]
    paddr[Cfg.addr] pdata[Cfg.data] pwe[1] pre[1]
    maddr[Cfg.addr] mdata[Cfg.data] mwe[1] mre[1]
  end
  module O = interface
    miss[1] hit[1] dirty[1] data_o[Cfg.data] evict_addr[Cfg.addr]
  end

  open HardCaml.Signal.Comb
  include Cache.Cfg(Cfg)

  
  let rmemory ~clk ~clr ~we ~wa ~d ~ra = 
    let module Seq = Utils.Regs(struct let clk=clk let clr=clr end) in
    let size = 1 lsl (width wa) in
    let wen = binary_to_onehot wa in
    mux ra @@ Array.to_list @@ Array.init size 
      (fun j -> Seq.reg ~e:(bit wen j &: we) d)

  let f i = 
    let open I in
    let module Seq = Utils.Regs(struct let clk=i.clk let clr=i.clr end) in

    assert (width i.paddr = Cfg.addr);
    assert (width i.maddr = Cfg.addr);

    let pline, pslot, ptag = extract_addr i.paddr in
    let mline, mslot, mtag = extract_addr i.maddr in

    let addr = mux2 i.msel (concat_e [mslot; mline]) (concat_e [pslot; pline]) -- "i_addr" in
    let data = mux2 i.msel i.mdata i.pdata -- "i_data" in
    let re = mux2 i.msel i.mre i.pre -- "i_re" in
    let we = mux2 i.msel i.mwe i.pwe -- "i_we" in
    let tag = mux2 i.msel mtag ptag -- "i_tag" in
    let slot = mux2 i.msel mslot pslot -- "i_slot" in
    let line = mux2 i.msel mline pline -- "i_line" in
    let dirty_i = mux2 i.msel gnd vdd in

    let rmemory = rmemory ~clk:i.clk ~clr:i.clr in
    let qtag = (rmemory ~we:i.mwe ~wa:slot ~d:tag ~ra:slot) -- "f_qtag" in
    let valid = (rmemory ~we:i.mwe ~wa:slot ~d:vdd ~ra:slot) -- "f_valid" in
    let dirty = (rmemory ~we:we ~wa:slot ~d:dirty_i ~ra:slot) -- "f_dirty" in
    let data_o = rmemory ~we ~wa:addr ~d:data ~ra:addr in

    let pen = (i.pre |: i.pre) in
    let match_tag = tag ==: qtag in 
    let hit = pen &: valid &: match_tag in
    let miss = pen &: (~: (valid &: match_tag)) in

    let evict_addr = concat [ qtag; slot; line; zero ldbits ] -- "evict_addr" in

    O.{ miss; hit; dirty; data_o; evict_addr }

end

module Controller(B : Cache.Config) = struct

  open HardCaml.Signal.Comb
  include Cache.Cfg(B) 

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
    addr[B.addr] evict_addr[B.addr]
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
    let mrw = Seq.g_reg ~e 1 in

    let aligned_addr a = a.[width a - 1:B.line+ldbits] @: zero (B.line+ldbits) in

    (* processor read or write miss:
          
        if dirty then flush cacheline;
        load cacheline

       This means we are allocating and filling a cache line on
       a write miss.  *)

    let () = compile [
      sm [
        `wait, [
          cnt $==. (-1);
          msel $==. 0;
          mrw $==. 1;
          g_when i.miss [
            msel $==. 1;
            maddr $== aligned_addr i.addr;
            caddr $== aligned_addr i.addr;
            g_if i.dirty [
              (* current cache line needs to be flushed *)
              mrw $==. 0;
              maddr $== aligned_addr i.evict_addr;
              next `store_re;
            ] [
              (* load new cache line *)
              mreq $==. 1;
              next `load;
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

        (* flush the cache line *)
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
              mrw $==. 1;
              next `load;
            ];
          ]
        ];

      ];
    ] in

    O.({
      stall = i.miss |: ~: (is `wait);
      msel = (*i.miss |:*) msel#q;
      state = concat @@ List.rev @@ List.map is Sm_v.list;
      mreq = mreq#q;
      maddr = maddr#q;
      mdata_o = i.cdata_i;
      mrw = mrw#q;
      cwe = mreq#q &: i.mvld &: (is `load);
      cre = mreq#q &: (~: (i.rw)) &: ((is `store_re) |: (is `store_nxt));
      cdata_o = i.mdata_i;
      caddr = caddr#q;
    });

end

