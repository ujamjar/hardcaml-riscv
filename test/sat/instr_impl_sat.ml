(* requires hardcaml-bloop *)

(*open HardCamlRiscV*)
open Printf 

let solver = ref `mini
let () = 
  let solver_args = [
    "mini", (fun () -> solver := `mini);
    (*"pico", (fun () -> solver := `pico);*)
    "crypto", (fun () -> solver := `crypto);
    "dimacs-mini", (fun () -> solver := `dimacs `mini);
    "dimacs-pico", (fun () -> solver := `dimacs `pico);
    "dimacs-crypto", (fun () -> solver := `dimacs `crypto);
  ] in
  Arg.parse
  [
    "-solver", Arg.Symbol(List.map fst solver_args, 
                         (fun s -> (List.assoc s solver_args)())),
              "select solver"
  ]
  (fun _ -> ())
  "HardCamlRiscV instruction implementation SAT tests"

module Bloop = HardCamlBloop.Gates.Make_comb(HardCamlBloop.Gates.Basic_gates)
module Bits = HardCaml.Bits.Comb.IntbitsList

module Make(B : HardCaml.Comb.S) = struct

  module Cfg = Config.RV32I_machine

  module Ifs = Interfaces.Make(Cfg)
  module Cmb = Cmb.Make(B)(Ifs)
  module Rf = Rf.Make(Ifs)
  module F = Fetch.Make(Ifs)(B)
  module D = Decoder.Make(Ifs)(B)
  module X = Alu.Make(Ifs)(B)
  module M = Mem.Make(Ifs)(B)
  module C = Commit.Make(Ifs)(B)

  let z (_,b) = B.zero b
  let inp (n,b) = B.input n b

  let st_zero = Ifs.Stage.(map z t)
  let sts_zero = Ifs.Stages.(map z t)
  let inp_zero = Ifs.I.(map z t)
  let mi_zero = Ifs.Mi_instr.(map z t)
  let md_zero = Ifs.Mi_data.(map z t)

  let build_cpu ~pc ~instr ~rdata ~csr_rdata = 
    let open Ifs in
    let open Stage in
    let inp = 
      { inp_zero with Ifs.I.mi = { mi_zero with Ifs.Mi_instr.rdata = instr };
                      Ifs.I.md = { md_zero with Ifs.Mi_data.rdata = rdata } }
    in
    let csrs_q = Csr_regs.(map (fun (n,b) -> B.zero b) t) in
    let state = { Stage.(map B.(fun (_,b) -> zero b) t) with pc } in

    let async_rf ~dec = 
      let rd1, rd2 = B.input "reg_rd1" 32, B.input "reg_rd2" 32 in
      Rf.O.{
        q1 = B.(mux2 (dec.ra1 ==:. 0) (zero 32) rd1);
        q2 = B.(mux2 (dec.ra2 ==:. 0) (zero 32) rd2);
      }
    in

    let mi, md, com, rfo, ctrl, csrs_wr = 
      Cmb.c ~inp ~state ~async_rf ~csrs_q ~csr_rdata 
    in
    
    com, rfo.Rf.O.q1, rfo.Rf.O.q2, md


  (*******************************************************************************)

  module I = Insn_fmt.I(B)
  module I_shift = Insn_fmt.I_shift(B)
  module U = Insn_fmt.U(B)
  module R = Insn_fmt.R(B)
  module UJ = Insn_fmt.UJ(B)
  module SB = Insn_fmt.SB(B)
  module S = Insn_fmt.S(B)
  module All = Insn_fmt.All(B)
  module Csr = Insn_fmt.Csr(B)

  open B
  open Ifs.Stage

  type 'a t = 
    {
      instr : B.t;
      rdata : B.t;
      csr_rdata : B.t;
      pc : B.t;
      data : 'a;
      st : B.t Ifs.Stage.t;
      rd1 : B.t;
      rd2 : B.t;
      md : B.t Ifs.Mo_data.t;
    }

  let make : 
    Config.T.t -> (Int32.t -> B.t * 'a) -> 'a t
    = fun instr make ->
    let _,match' = List.assoc instr Config.T.mask_match in
    let rdata = input "rdata" 32 in
    let csr_rdata = input "csr_rdata" 32 in
    let pc = input "pc" 31 @: gnd in
    let instr, data = make match' in
    let st,rd1,rd2, md = build_cpu ~pc ~instr ~rdata ~csr_rdata in
    { instr; rdata; csr_rdata; pc; data; st; rd1; rd2; md }

end

(*******************************************************************************)

(*******************************************************************************)

module Tests(B : HardCaml.Comb.S) = struct

  module Core = Make(B)

  open Core
  open Ifs.Stage
  open Ifs.Mo_data
  open B

  type show = Config.T.Show_t.a -> string 
  type 'a mk = int32 -> B.t * 'a
  type instr = Config.T.Enum_t.a 
  type 'a core = 'a Core.t 
  type props = ((B.t * string) list) * (B.t list)

  let testb : 'a.  
        show -> 'a mk -> instr -> ('a core -> props) -> unit ->
        (show * 'a mk * instr * ('a core -> props)) 
    = fun show mk instr f () -> show, mk, instr, f

  let test ?(no_default_checks=false) mk instr f = 
    let idx = Config.T.Enum_t.from_enum instr in
    testb Config.T.Show_t.show mk instr (fun x -> 
      let props = f x in
      let props_insn =
        if no_default_checks then []
        else
          [
            (~: (msb x.st.insn)), "no trap"; (* trap is not set *) 
            (x.st.insn ==: (sll (one (width x.st.insn)) idx)), "insn decode"; 
          ]
      in
      props @ props_insn, [])

  let check_class x z = 
    Ifs.Class_ex.(to_list @@ map3 (fun (n,b) x z -> x ==: z, n) t x.st.iclass z)
    |> List.filter (fun (_,n) -> n <> "f3" && n <> "f7")
    
  let zero_class = 
    let module X = Ifs.Class_ex.Make(B) in
    X.zero

  (* Register-immediate *)

  let imm_props f x = 
    [
      x.st.rdd ==: (f x.rd1 (sresize x.data.I.imm 32)), "rdd = imm op";
      x.st.rad ==: x.data.I.rd, "rad";
      x.st.rwe, "reg write";
      x.st.pc ==: x.pc +:. 4, "incr pc";
      ~: (x.md.req), "no mem req";
    ] 
    @ check_class x { zero_class with Ifs.Class.opi=vdd }

  let slt a b = uresize (a <+ b) 32
  let sltu a b = uresize (a <: b) 32

  let test_rimm = List.map (fun (i,f) -> test I.make i (imm_props f))
    [
      `addi,  (+:);
      `andi,  (&:);
      `ori,   (|:);
      `xori,  (^:);
      `slti,  slt;
      `sltiu, sltu;
    ]

  let imm_shift_props f x = 
    [
      x.st.rdd ==: (f x.rd1 x.data.I_shift.imm), "rdd = shift by imm";
      x.st.rad ==: x.data.I_shift.rd, "rad";
      x.st.rwe, "reg write";
      x.st.pc ==: x.pc +:. 4, "incr pc";
      ~: (x.md.req), "no mem req";
    ]
    @ check_class x { zero_class with Ifs.Class.opi=vdd }

  let sll_ a b = log_shift sll a b.[4:0]
  let srl_ a b = log_shift srl a b.[4:0]
  let sra_ a b = log_shift sra a b.[4:0]

  let test_rimm_sh = List.map (fun (i,f) -> test I_shift.make i (imm_shift_props f))
    [
      `slli, sll_;
      `srli, srl_;
      `srai, sra_;
    ]

  (* Special: lui, auipc *)

  let test_auipc = test U.make `auipc @@ fun x ->
    [
      x.st.rdd ==: (x.pc +: (x.data.U.imm @: zero 12)), "rdd = pc+imm";
      x.st.rad ==: x.data.U.rd, "rad";
      x.st.rwe, "reg write";
      x.st.pc ==: x.pc +:. 4, "incr pc";
      ~: (x.md.req), "no mem req";
    ]
    @ check_class x { zero_class with Ifs.Class.auipc=vdd }

  let test_lui = test U.make `lui @@ fun x ->
    [
      x.st.rdd ==: (x.data.U.imm @: zero 12), "rdd = upper imm";
      x.st.rad ==: x.data.U.rd, "rad";
      x.st.rwe, "reg write";
      x.st.pc ==: x.pc +:. 4, "incr pc";
      ~: (x.md.req), "no mem req";
    ]
    @ check_class x { zero_class with Ifs.Class.lui=vdd }

  (* Register-Register *)

  let reg_props f x = 
    [
      x.st.rdd ==: (f x.rd1 x.rd2), "rdd = op";
      x.st.rad ==: x.data.R.rd, "rad";
      x.st.rwe, "reg write";
      x.st.pc ==: x.pc +:. 4, "incr pc";
      ~: (x.md.req), "no mem req";
    ]
    @ check_class x { zero_class with Ifs.Class.opr=vdd }

  let test_rr = List.map (fun (i,f) -> test R.make i (reg_props f))
    [
      `add,  (+:);
      `sub,  (-:);
      `and_, (&:);
      `or_,  (|:);
      `xor_, (^:);
      `slt,  slt;
      `sltu, sltu;
      `sll,  sll_;
      `srl,  srl_;
      `sra,  sra_;
    ]

  (* Unconditional jump *)

  let test_jal = test UJ.make `jal @@ fun x ->
    [
      x.st.pc ==: ((x.pc +: (sresize (x.data.UJ.imm @: gnd) 32)) &:. (-2)), "pc jump"; 
      x.st.rdd ==: (x.pc +:. 4), "rdd = pc+4";
      x.st.rad ==: x.data.UJ.rd, "rad";
      x.st.rwe, "reg write";
      ~: (x.md.req), "no mem req";
    ]
    @ check_class x { zero_class with Ifs.Class.jal=vdd }

  let test_jalr = test I.make `jalr @@ fun x ->
    [
      x.st.pc ==: (((x.rd1 +: sresize x.data.I.imm 32) &:. (-2))), "pc jump";
      x.st.rdd ==: (x.pc +:. 4), "rdd = pc+4";
      x.st.rad ==: x.data.I.rd, "rad";
      x.st.rwe, "reg write";
      ~: (x.md.req), "no mem req";
    ]
    @ check_class x { zero_class with Ifs.Class.jalr=vdd }

  (* Conditional branch *)

  let branch_props f x = 
    let taken = f x.Core.rd1 x.rd2 in
    [
      x.st.pc ==: mux2 taken 
        ((x.pc +: sresize (x.data.SB.imm @: gnd) 32) &:. (-2))
        (x.pc +:. 4), "pc = cond set";
      ~: (x.md.req), "no mem req";
      ~: (x.st.rwe), "no reg write";
    ]
    @ check_class x { zero_class with Ifs.Class.bra=vdd }

  let test_bra = List.map (fun (i,f) -> test SB.make i (branch_props f))
    [
      `beq,  (==:);
      `bne,  (<>:);
      `blt,  (<+);
      `bltu, (<:);
      `bge,  (>=+);
      `bgeu, (>=:);
    ]

  (* Load and Store *)

  let load_props i x =
    let lh = mux2 x.md.addr.[1:1] x.rdata.[31:16] x.rdata.[15:0] in
    let lb = 
      mux x.md.addr.[1:0] 
        [
          x.rdata.[7:0];
          x.rdata.[15:8];
          x.rdata.[23:16];
          x.rdata.[31:24];
        ]
    in
    [
      x.md.addr ==: (x.Core.rd1 +: sresize x.data.I.imm 32), "mem addr";
      x.st.rdd ==: 
          (match i with
          | `lw -> x.rdata
          | `lh -> sresize lh 32
          | `lhu -> uresize lh 32
          | `lb -> sresize lb 32
          | `lbu -> uresize lb 32
          | _ -> failwith ""), "rdd = loaded data";
      x.st.rad ==: x.data.I.rd, "rad";
      x.st.rwe, "reg write";
      x.st.pc ==: x.pc +:. 4, "incr pc";
      x.md.req, "mem req";
      x.md.rw, "mem load";
    ]
    @ check_class x { zero_class with Ifs.Class.ld=vdd }

  let test_load = List.map (fun i -> test I.make i (load_props i))
    [
      `lw;
      `lh;
      `lhu;
      `lb;
      `lbu;
    ]

  let store_props i x = 
    [
      x.md.addr ==: (x.Core.rd1 +: sresize x.data.S.imm 32), "mem addr";
      x.md.wmask ==: 
        (match i with
        | `sw -> const "1111"
        | `sh -> mux2 x.md.addr.[1:1] (const "1100") (const "0011")
        | `sb -> mux x.md.addr.[1:0] (List.map const [ "0001"; "0010"; "0100"; "1000" ])
        | _ -> failwith ""), "mem store mask";
      x.md.wdata ==: 
        (match i with
        | `sw -> x.Core.rd2
        | `sh -> mux2 x.md.addr.[1:1] (x.rd2.[15:0] @: zero 16) (zero 16 @: x.rd2.[15:0])
        | `sb -> mux x.md.addr.[1:0]
                  [
                    zero 24 @: x.rd2.[7:0];
                    zero 16 @: x.rd2.[7:0] @: zero  8;
                    zero  8 @: x.rd2.[7:0] @: zero 16;
                               x.rd2.[7:0] @: zero 24;
                  ]
        | _ -> failwith ""), "mem store data";
      x.st.pc ==: x.pc +:. 4, "incr pc";
      ~: (x.st.rwe), "no reg write";
      x.md.req, "mem req";
      ~: (x.md.rw), "mem write";
    ]
    @ check_class x { zero_class with Ifs.Class.st=vdd }

  let test_store = List.map (fun i -> test S.make i (store_props i))
    [
      `sw;
      `sh;
      `sb;
    ]

  (* Trap *)

  let test_trap = testb (fun _ -> "#trap") All.make `addi (* doesnt matter *) @@ fun x ->
    (* disallow valid instructions, so we force a trap *)
    let insns, csrs = Gencsr.get_full_csrs Config.V.list Ifs.csrs in
    let banned = 
      List.map (fun (mask,mtch) -> ~: ((x.instr &: consti32 32 mask) ^: consti32 32 mtch))
        (insns @ List.concat csrs)
    in
    let props = 
      [
        x.st.iclass.Ifs.Class.trap, "traps";
        ~: (x.st.rwe), "no reg write";
        ~: (x.md.req), "no mem req";
        x.st.insn ==: (sll (one (width x.st.insn)) (width x.st.insn - 1)), "insn=trap";
        (* xxx pc+epc *)
      ]
    in
    props, banned

  (* CSRs *)

  let all_csrs_mux () = 
    let ro_csrs = Gencsr.ro_csrs Ifs.csrs |> List.map (consti 12) in
    let rw_csrs = Gencsr.rw_csrs Ifs.csrs |> List.map (consti 12) in
    let w l = HardCaml.Utils.clog2 (List.length l) in
    let mux l = mux (input "csr_sel" (w l)) l in
    mux (ro_csrs@rw_csrs)

  let csrs_insns = 
    [
      `csrrw;
      `csrrc;
      `csrrs;
      `csrrwi;
      `csrrci;
      `csrrsi;
    ]

  let ro_csrs_insns = 
    [
      `csrrc;
      `csrrs;
      `csrrci;
      `csrrsi;
    ]

  let (==>:) p q = (~: p) |: q
  let (<==>:) q p = (p ==>: q) &: (q ==>: p)

  let test_csrs = List.map
      (fun i -> test ~no_default_checks:true (fun m -> Csr.make ~csr:(all_csrs_mux()) m) i @@ fun x -> 
        let traps = x.st.iclass.Ifs.Class.trap in
        let sel g p = (if g then gnd else vdd) |: p in
        let open Ifs.Csr_ctrl in
        [
          traps ==>: (select x.data.Csr.csr 11 10 ==:. 3), "trap on read only";
          (x.st.csr.csr_we_n) ==>: (x.data.Csr.rs1 ==:. 0), "disable csr write";
          (~: traps) ==>:
            ((~: (x.st.csr.csr_write |: 
                 x.st.csr.csr_set |: 
                 x.st.csr.csr_clr)) ==>:
              (x.data.Csr.rs1 ==:. 0)), "no write ==> rs1=0";
          sel (i <> `csrrw && i <> `csrrwi) 
            ((~: traps) ==>:
              ((x.data.Csr.rs1 ==:. 0) ==>: 
               (~: (x.st.csr.csr_write |: 
                    x.st.csr.csr_set |: 
                    x.st.csr.csr_clr)))), "rs1=0 => no write if ~csrrw[i]";
          sel (i = `csrrw || i = `csrrwi) 
            ((~: traps) ==>: x.st.csr.csr_write), "csrrw[i] always writes";
          sel (i = `csrrs || i = `csrrsi) 
            (((~: traps) &: (x.data.Csr.rs1 <>:. 0)) ==>:
                 x.st.csr.csr_set), "csrrs[i] & rs1<>0 ==> set";
          sel (i = `csrrc || i = `csrrci) 
            (((~: traps) &: (x.data.Csr.rs1 <>:. 0)) ==>:
                 x.st.csr.csr_clr), "csrrc[i] & rs1<>0 ==> clr";
          (~: traps) ==>: (x.st.rwe), "reg write";
          traps ==>: (~: (x.st.rwe)), "trap ==> no reg write";
          ~: (x.md.req), "no memory access";
          ((ue x.st.csr.csr_write +: 
            ue x.st.csr.csr_set +: 
            ue x.st.csr.csr_clr) <=:. 1), "one of write, set or clear";
          traps ==>: 
            (~: (x.st.csr.csr_write |: x.st.csr.csr_set |: x.st.csr.csr_clr)), 
              "no write on trap";
          x.st.csr.csr_re_n ==>: (x.data.Csr.rd ==:. 0), "no read ==> rd=0";
          x.csr_rdata ==: x.st.rdd, "csr_rdata = rdd";
        ])
      csrs_insns

end

module Sat_tests = Tests(Bloop)

module Bits_i = struct
  let inputs = ref []
  include Bits
  let input n b = 
    let c = try List.assoc n !inputs with _ -> failwith n in
    assert (width c = b);
    c
end
module Bit_tests = Tests(Bits_i)

let get_soln = function
  | `unsat -> failwith "unexpected"
  | `sat (s,_) ->
    List.map (fun (n,a) -> n, Bits_i.const (HardCamlBloop.Sat.string_of_vec_result (n,a))) s

let eval bits soln = 
  let show, mk, instr, f = bits () in
  Bits_i.inputs := get_soln soln;
  let x = Bit_tests.Core.make instr mk in
  let props, _ = f x in
  x, props

let show_vec (n,b) = printf "%-16s : %s\n" n (Bits_i.to_string b)

let check ~verbose ~bits ~banned x = 
  let open HardCamlBloop.Sat in
  let report_inputs soln = 
    match soln with
    | `unsat -> printf "UNSAT\n"
    | `sat(s,_) -> begin
        printf "SAT\n";
        List.iter show_vec (get_soln soln)
    end
  in
  let report_outputs soln = 
    let open Bit_tests.Core in
    if soln <> `unsat then begin
      let x, _ = eval bits soln in
      show_vec ("instr", x.instr);
      ignore @@ Ifs.Stage.(map2 (fun (n,b) x -> show_vec (n,x)) t x.st)
    end
  in
  let soln = of_signal ~solver:!solver ~banned (*~verbose:true*) (Bloop.(~:) x) in
  let () = 
    if verbose then begin
      report_inputs soln;
      report_outputs soln
    end 
    else printf "%s\n" (match soln with `sat _ -> "SAT" | `unsat -> "UNSAT")
  in
  soln

let test sat bits = 
  let show, mk, instr, f = sat () in
  let cost c = HardCamlBloop.(Expr.cost (snd @@ Bloop.counts Expr.Uset.empty c)) in
  let x = Sat_tests.Core.make instr mk in
  let props, banned = f x in
  let all_props = Bloop.(reduce (&:) (List.map fst props)) in
  printf "--------------------------------------------------------\n";
  printf "%-.8s[%7i]...%!" (show instr) (cost all_props);
  match check ~verbose:false ~bits ~banned all_props with
  | `unsat -> ()
  | `sat _ -> begin
    printf "checking each property\n";
    List.iteri 
      (fun i (p,n) ->
        printf "%-30s: " n;
        ignore @@ check ~verbose:true ~bits ~banned p) 
      props
  end

let () = List.iter2 test Sat_tests.test_rimm Bit_tests.test_rimm
let () = List.iter2 test Sat_tests.test_rimm_sh Bit_tests.test_rimm_sh
let () = test Sat_tests.test_auipc Bit_tests.test_auipc
let () = test Sat_tests.test_lui Bit_tests.test_lui
let () = List.iter2 test Sat_tests.test_rr Bit_tests.test_rr
let () = test Sat_tests.test_jal Bit_tests.test_jal
let () = test Sat_tests.test_jalr Bit_tests.test_jalr
let () = List.iter2 test Sat_tests.test_bra Bit_tests.test_bra
let () = List.iter2 test Sat_tests.test_load Bit_tests.test_load
let () = List.iter2 test Sat_tests.test_store Bit_tests.test_store
let () = test Sat_tests.test_trap Bit_tests.test_trap
let () = List.iter2 test Sat_tests.test_csrs Bit_tests.test_csrs

