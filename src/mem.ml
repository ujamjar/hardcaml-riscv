module Make(Ifs : Interfaces.S) = struct

  open HardCaml.Signal.Comb
  open Ifs

  let name = "mem"

  let mem ~inp ~alu = 
    let open Stage in
    let open Stages in
    let open Class in
    (* note; XXX don't (currently) allow unaligned accesses and
      *           they should cause a trap *)
    let p = alu in
    let i = p.iclass in
    let ofs = p.rdd.[1:0] in
    let rdm = p.rd2 in
    let addr = p.rdd in
    (* byte, half or word transfer *)
    let size = p.iclass.f3.[1:0] in
    (* sign extend *)
    let sext = p.iclass.f3.[2:2] in
    (* write data mask *)
    let wmask = 
      mux size [
        mux ofs.[1:0] (List.map constb ["0001";"0010";"0100";"1000"]);
        mux ofs.[1:1] (List.map constb ["0011";"1100"]);
        constb "1111";
      ]
    in
    (* write data *)
    let wdata = 
      let sft n s = sll (uresize rdm.[n-1:0] 32) s in
      mux size [
        mux ofs.[1:0] (List.map (sft 8) [0;8;16;24]);
        mux ofs.[1:1] (List.map (sft 16) [0;16]);
        rdm;
      ]
    in
    (* read data *)
    let rdm = 
      let res x = mux2 sext (sresize x 32) (uresize x 32) in
      let rdm = inp.I.md.Mi_data.rdata in
      let rdm8 = res @@ mux ofs.[1:0] [ rdm.[7:0]; rdm.[15:8]; rdm.[23:16]; rdm.[31:24] ] in
      let rdm16 = res @@ mux ofs.[1:1] [ rdm.[15:0]; rdm.[31:16] ] in
      mux size [ rdm8; rdm16; rdm ]
    in
    let req = i.st |: i.ld in (* is a memory request *)
    let rw = i.ld in
    let rdd = mux2 rw rdm p.rdd in
    { p with
      rdd;
      md = Mo_data.({
        addr; wdata;
        req; rw; wmask; 
      })
    }

  let f ~inp ~comb ~pipe = 
    let open Stages in
    mem ~inp ~alu:pipe.alu

  let m ~ctrl ~inp ~comb ~pipe = 
    let open Stage in
    let open Stages in
    pipe.mem.md (* XXX for now ... *)

end

