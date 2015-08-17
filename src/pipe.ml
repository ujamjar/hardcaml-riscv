open HardCaml.Signal
open Comb

module U = HardCaml.Utils

module type Config = sig
  val xlen : int 
  val start_addr : int
end

module Insn = struct
  type t = 
    | Lui | Auipc 
    | Jal | Jalr 
    | Beq | Bne | Blt | Bge | Bltu | Bgeu 
    | Lb | Lh | Lw | Lbu | Lhu | Sb | Sh | Sw 
    | Addi | Slti | Sltiu | Xori | Ori | Andi | Slli | Srli | Srai 
    | Add | Sub | Sll | Slt | Sltu | Xor | Srl | Sra | Or | And 
    | Fence | Fenchi | Scall | Sbreak
    | Rdcycle | Rdcycleh | Rdtime | Rdtimeh | Rdinstret | Rdinstreth 
    | Invalid
    deriving(Enum,Bounded,Show)
  let name = "instr"
end
module Insn_v = Utils.BVec(Insn)

module Is = struct
  type t = 
    | Lui_auipc_jal | Lb_lh_lw_lbu_lhu | Slli_srli_srai | Jalr_addi_slti_sltiu_xori_ori_andi
    | Sb_sh_sw | Sll_srl_sra | Lui_auipc_jal_jalr_addi_add | Slti_blt_slt
    | Sltiu_bltu_sltu | Beq_bne_blt_bge_bltu_bgeu | Lbu_lhu_lw | Alu_reg_imm
    | Alu_reg_reg | Compare | Rdcycle_rdcycleh_rdinstr_rdinstrh
    deriving(Enum,Bounded,Show)
  let name = "is"
end
module Is_v = Utils.BVec(Is)

module FClass = struct
  type t = R | I | S | SB | U | UJ
    deriving(Enum,Bounded,Show)
  let name = "fclass"
end
module FClass_v = Utils.BVec(FClass)

module Make(C : Config) = struct

  (* various (derived) constants *)
  let num_regs = 32
  let log_regs = U.clog2 num_regs

  (* interface to core *)
  module I = interface
    clk[1] clr[1]
    mio_rdata[C.xlen] mio_vld[1]
  end

  module O = interface
    mio_addr[C.xlen] mio_wdata[C.xlen] mio_req[1] mio_rw[1] mio_wmask[C.xlen/8]   
  end

  (* this stores the information needed at any stage of the
   * pipeline.  In some stages the information may or may not
   * have been calculated or needed.  Some values could just 
   * skip a stage or stop being required.  
   *
   * This will allow us to pass pipeline info from all stages
   * to all other stages which will make operations like bypassing 
   * easier without having to carefully track every bit of data
   * that is or isnt needed at a particular stage. 
   *
   * This will probably get pretty big, but not to worry as 
   * elaborating the design will remove stuff that's not needed.
   * On the other hand it will make it more difficult to 
   * produce a hierarchy of modules. *)
  module Pipe = interface
    (* pipeline stage enable and clear *)
    pen[1] 
    (* register addresses *)
    ra1[log_regs] ra2[log_regs] rad[log_regs]
    (* register address zero detection *)
    ra1_zero[1] ra2_zero[1] rad_zero[1]
    (* data to/from register file *)
    rd1[C.xlen] rd2[C.xlen] rdd[C.xlen]
    (* immediate *)
    imm[C.xlen]
    (* program counter *)
    pc[C.xlen] next_pc[C.xlen]
    (* instruction from memory *)
    instr[32]
    (* decoded instruction *)
    insn[Insn_v.n]
    (* instruction class *)
    is[Is_v.n]
    (* instruction format *)
    fclass[FClass_v.n]
    (* alu results *)
    alu[C.xlen] alu_cmp[1]
    (* junk *)
    junk[1]
  end

  let wired_stage _ = Pipe.(map (fun (n,b) -> wire b) t)
  let zero_stage _ = Pipe.(map (fun (n,b) -> zero b) t)

  type stage = Comb.t Pipe.t
  type stages = stage array
  type f_stage = n:int -> inp:Comb.t I.t -> comb:stages -> pipe:stages -> stage
  type 'a f_output = stages -> 'a
  
  module type M_stage = sig
    val name : string
    val f : f_stage
  end

  let build_pipeline ~f_stages ~f_output inp = 
    let module Seq = Utils.Regs(struct let clk=inp.I.clk let clr=inp.I.clr end) in
    (* number of stages *)
    let n_stages = Array.length f_stages in
    (* pipeline stage after registering *)
    let p_stages = Array.init n_stages wired_stage in
    (* pipeline stage before registering *)
    let w_stages = Array.init n_stages wired_stage in

    (* generate the stages *)
    let o_stages = 
      Array.mapi 
        (fun n f -> 
          let module F = (val f : M_stage) in
          F.f ~n ~inp ~comb:w_stages ~pipe:p_stages) 
        f_stages 
    in

    (* wiring *)
    let () = 
      let open Pipe in
      let internal_names = false in
      for i=0 to n_stages-1 do
        let module F = (val f_stages.(i) : M_stage) in
        (* get pipeline enable and clear *)
        let e = o_stages.(i).pen in
        let map f st = 
          let st = Pipe.map2 (fun a b -> a,b) st o_stages.(i) in
          let st = Pipe.map2 (fun (a,b) (n,_) -> a,b,n) st t in
          ignore @@ Pipe.map f st
        in
        let map name f st = map (* optional internal naming *)
          (fun (w,o,n) -> 
            w <== if internal_names then (f o) -- (F.name ^ name ^ n)
                  else f o) st 
        in
        (* wire up combinatorial output of stages *)
        map "_c_" (fun o -> o) w_stages.(i);
        (* wire up pipelined output of stages *)
        map "_p_" (Seq.reg ~e) p_stages.(i)
      done
    in
    
    f_output p_stages

  module type Stage = sig
    val name : string
    val f : f_stage
  end

  (* ideally we would parameterise each of the pipeline stages somehow
   * so they can refer to other pipeline stages without needing to actually
   * know the pipeline number.  The goal would then to be able to generate
   * different pipeline lengths and have the core adapt itself (ie for bypassing,
   * interlocking etc).  As yet I'm not sure how this will work, so we'll stick
   * to static numbers for the first iteration of the core *)
  let fet = 0 (* fetch *)
  let dec = 1 (* decode *)
  let exe = 2 (* execute *)
  let mem = 3 (* memory *)
  let com = 4 (* commit *)

  module Fetch = struct
    let name = "fet"
    let f ~n ~inp ~comb ~pipe = 
      let open Pipe in
      let module Seq = Utils.Regs(struct let clk=inp.I.clk let clr=inp.I.clr end) in
      let pc = Seq.reg_fb ~cv:(consti C.xlen C.start_addr) ~e:vdd ~w:C.xlen (fun d -> d +:. 4) in
      let pc = pc -- "fetch_pc" in
      let junk = I.to_list inp |> concat |> bits |> reduce (|:) in
      { zero_stage () with 
        pc; junk; pen=vdd }
  end

  module Rf = struct

    module I = interface
      clk[1] clr[1]
      wr[1] wa[log_regs] d[C.xlen]
      ra1[log_regs] ra2[log_regs]
    end

    module O = interface
      q1[32] q2[32]
    end

    let f i = 
      let open I in
      let module Seq = Utils.Regs(struct let clk=i.clk let clr=i.clr end) in

      let wen = binary_to_onehot i.wa in
      let regs = 
        Array.to_list @@
        Array.init num_regs 
          (fun j -> 
            if j=0 then zero C.xlen 
            else Seq.reg ~e:(i.wr &: wen.[j:j]) i.d -- (Printf.sprintf "reg_%.2i" j)) 
      in
      O.({
        q1 = mux i.ra1 regs;
        q2 = mux i.ra2 regs;
      })

  end

  module Decoder = struct

    (* ALM = 511, REG = 414 *)

    let name = "dec"

    let imm_uj instr = 
      let d = sresize (instr.[31:12] @: gnd) 32 in
      let rec f off = function
        | [] -> []
        | (h,l) :: tl -> 
          let w = h-l+1 in
          (l, select d (off+w-1) off) :: f (off + w) tl
      in
      concat @@ List.map snd @@  List.sort (fun a b -> compare (fst b) (fst a)) @@ 
        f 0 [0,0; 19,12; 11,11; 10,1; 31,20]

    let imm instr insn is imm_uj = 
      let insn l = reduce (|:) (List.map (Insn_v.sel insn) l) in
      let is l = reduce (|:) (List.map (Is_v.sel is) l) in
      let open Insn in
      let open Is in
      let smap x l = List.map (fun (h,l) -> x.[h:l]) l in
      pmux [
        insn [Jal], imm_uj;
        insn [Lui; Auipc], instr.[31:12] @: zero 12;
        insn [Jalr] |: is [Lb_lh_lw_lbu_lhu; Alu_reg_imm], sresize instr.[31:20] 32;
        is [Beq_bne_blt_bge_bltu_bgeu], 
          sresize (concat ((smap instr [(31,31); (7,7); (30,25); (11,8)]) @ [gnd])) 32;
        is [Sb_sh_sw], sresize (concat (smap instr [(31,25); (11,7)])) 32;
      ] (zero 32)

    let decode_insn instr = 
      let instr_lui   = instr.[6:0] ==:. 0b0110111 in
      let instr_auipc = instr.[6:0] ==:. 0b0010111 in
      let instr_jal   = instr.[6:0] ==:. 0b1101111 in
      let instr_jalr  = instr.[6:0] ==:. 0b1100111 in

      let is_beq_bne_blt_bge_bltu_bgeu = instr.[6:0] ==:. 0b1100011 in
      let is_lb_lh_lw_lbu_lhu          = instr.[6:0] ==:. 0b0000011 in
      let is_sb_sh_sw                  = instr.[6:0] ==:. 0b0100011 in
      let is_alu_reg_imm               = instr.[6:0] ==:. 0b0010011 in
      let is_alu_reg_reg               = instr.[6:0] ==:. 0b0110011 in
      let is_fence                     = instr.[6:0] ==:. 0b0001111 in

      (* instructions *)

      let open Insn in
      let insn = [
        Lui,     instr_lui;
        Auipc,   instr_auipc;
        Jal,     instr_jal;
        Jalr,    instr_jalr;

        Beq,   is_beq_bne_blt_bge_bltu_bgeu &: (instr.[14:12] ==:. 0b000);
        Bne,   is_beq_bne_blt_bge_bltu_bgeu &: (instr.[14:12] ==:. 0b001);
        Blt,   is_beq_bne_blt_bge_bltu_bgeu &: (instr.[14:12] ==:. 0b100);
        Bge,   is_beq_bne_blt_bge_bltu_bgeu &: (instr.[14:12] ==:. 0b101);
        Bltu,  is_beq_bne_blt_bge_bltu_bgeu &: (instr.[14:12] ==:. 0b110);
        Bgeu,  is_beq_bne_blt_bge_bltu_bgeu &: (instr.[14:12] ==:. 0b111);

        Lb,    is_lb_lh_lw_lbu_lhu &: (instr.[14:12] ==:. 0b000);
        Lh,    is_lb_lh_lw_lbu_lhu &: (instr.[14:12] ==:. 0b001);
        Lw,    is_lb_lh_lw_lbu_lhu &: (instr.[14:12] ==:. 0b010);
        Lbu,   is_lb_lh_lw_lbu_lhu &: (instr.[14:12] ==:. 0b100);
        Lhu,   is_lb_lh_lw_lbu_lhu &: (instr.[14:12] ==:. 0b101);

        Sb,    is_sb_sh_sw &: (instr.[14:12] ==:. 0b000);
        Sh,    is_sb_sh_sw &: (instr.[14:12] ==:. 0b001);
        Sw,    is_sb_sh_sw &: (instr.[14:12] ==:. 0b010);

        Addi,  is_alu_reg_imm &: (instr.[14:12] ==:. 0b000);
        Slti,  is_alu_reg_imm &: (instr.[14:12] ==:. 0b010);
        Sltiu, is_alu_reg_imm &: (instr.[14:12] ==:. 0b011);
        Xori,  is_alu_reg_imm &: (instr.[14:12] ==:. 0b100);
        Ori,   is_alu_reg_imm &: (instr.[14:12] ==:. 0b110);
        Andi,  is_alu_reg_imm &: (instr.[14:12] ==:. 0b111);

        Slli,  is_alu_reg_imm &: (instr.[14:12] ==:. 0b001) &: 
                                 (instr.[31:25] ==:. 0b0000000);
        Srli,  is_alu_reg_imm &: (instr.[14:12] ==:. 0b101) &:
                                 (instr.[31:25] ==:. 0b0000000);
        Srai,  is_alu_reg_imm &: (instr.[14:12] ==:. 0b101) &:
                                 (instr.[31:25] ==:. 0b0100000);

        Add,   is_alu_reg_reg &: (instr.[14:12] ==:. 0b000) &: 
                                 (instr.[31:25] ==:. 0b0000000);
        Sub,   is_alu_reg_reg &: (instr.[14:12] ==:. 0b000) &:
                                 (instr.[31:25] ==:. 0b0100000);
        Sll,   is_alu_reg_reg &: (instr.[14:12] ==:. 0b001) &:
                                 (instr.[31:25] ==:. 0b0000000);
        Slt,   is_alu_reg_reg &: (instr.[14:12] ==:. 0b010) &:
                                 (instr.[31:25] ==:. 0b0000000);
        Sltu,  is_alu_reg_reg &: (instr.[14:12] ==:. 0b011) &:
                                 (instr.[31:25] ==:. 0b0000000);
        Xor,   is_alu_reg_reg &: (instr.[14:12] ==:. 0b100) &:
                                 (instr.[31:25] ==:. 0b0000000);
        Srl,   is_alu_reg_reg &: (instr.[14:12] ==:. 0b101) &:
                                 (instr.[31:25] ==:. 0b0000000);
        Sra,   is_alu_reg_reg &: (instr.[14:12] ==:. 0b101) &:
                                 (instr.[31:25] ==:. 0b0100000);
        Or,    is_alu_reg_reg &: (instr.[14:12] ==:. 0b110) &:
                                 (instr.[31:25] ==:. 0b0000000);
        And,   is_alu_reg_reg &: (instr.[14:12] ==:. 0b111) &:
                                 (instr.[31:25] ==:. 0b0000000);

        Rdcycle,  (((instr.[6:0] ==:. 0b1110011) &: 
                    (instr.[31:12] ==:. 0b11000000000000000010)) |:
                   ((instr.[6:0] ==:. 0b1110011) &: 
                    (instr.[31:12] ==:. 0b11000000000100000010)));
        Rdcycleh, (((instr.[6:0] ==:. 0b1110011) &: 
                    (instr.[31:12] ==:. 0b11001000000000000010)) |:
                  ((instr.[6:0] ==:. 0b1110011) &: 
                   (instr.[31:12] ==:. 0b11001000000100000010)));
        Rdinstret,  ((instr.[6:0] ==:. 0b1110011) &: 
                     (instr.[31:12] ==:. 0b11000000001000000010));
        Rdinstreth, ((instr.[6:0] ==:. 0b1110011) &: 
                     (instr.[31:12] ==:. 0b11001000001000000010));
        (* TODO *)
        Rdtime, gnd; Rdtimeh, gnd;
        Fence, gnd; Fenchi, gnd; Scall, gnd; Sbreak, gnd;
      ] 
      in

      let insn = (Invalid, ~: (reduce (|:) (List.map snd insn))) :: insn in
      let insn = 
        List.map (fun (i,v) -> Enum.from_enum<Insn.t> i, v) insn
        |> List.sort (fun (a,_) (b,_) -> - (compare a b)) 
        |> List.map snd
        |> concat
      in
      assert (width insn = Insn_v.n);
      insn, 
      (instr_lui, instr_auipc, instr_jal, instr_jalr,
       is_beq_bne_blt_bge_bltu_bgeu, is_lb_lh_lw_lbu_lhu, 
       is_sb_sh_sw, is_alu_reg_imm, is_alu_reg_reg)

    let decode_is instr insn 
      (instr_lui, instr_auipc, instr_jal, instr_jalr,
       is_beq_bne_blt_bge_bltu_bgeu, is_lb_lh_lw_lbu_lhu, 
       is_sb_sh_sw, is_alu_reg_imm, is_alu_reg_reg) =

      let open Insn in
      let open Is in
      let f l = reduce (|:) (List.map (Insn_v.sel insn) l) in
      let is = [
        Lui_auipc_jal,   (f [Lui; Auipc; Jal]);
        Lui_auipc_jal_jalr_addi_add, 
                        (f [Lui; Auipc; Jal; Jalr; Addi; Add]);
        Slti_blt_slt,    (f [Slti; Blt; Slt]);
        Sltiu_bltu_sltu, (f [Sltiu; Bltu; Sltu]);
        Lbu_lhu_lw,      (f [Lbu; Lhu; Lw]);
        Compare,         (f [Slti; Slt; Sltiu; Sltu] |: is_beq_bne_blt_bge_bltu_bgeu);
        Beq_bne_blt_bge_bltu_bgeu, is_beq_bne_blt_bge_bltu_bgeu;
        Lb_lh_lw_lbu_lhu,          is_lb_lh_lw_lbu_lhu;
        Sb_sh_sw,                  is_sb_sh_sw;
        Alu_reg_imm,               is_alu_reg_imm;
        Alu_reg_reg,               is_alu_reg_reg;
        Slli_srli_srai, (is_alu_reg_imm &: (reduce (|:) [
          (instr.[14:12] ==:. 0b001) &: (instr.[31:25] ==:. 0b0000000);
          (instr.[14:12] ==:. 0b101) &: (instr.[31:25] ==:. 0b0000000);
          (instr.[14:12] ==:. 0b101) &: (instr.[31:25] ==:. 0b0100000)
        ]));
        Jalr_addi_slti_sltiu_xori_ori_andi, (instr_jalr |: (is_alu_reg_imm &: (reduce (|:) [
          instr.[14:12] ==:. 0b000;
          instr.[14:12] ==:. 0b010;
          instr.[14:12] ==:. 0b011;
          instr.[14:12] ==:. 0b100;
          instr.[14:12] ==:. 0b110;
          instr.[14:12] ==:. 0b111
        ])));
        Sll_srl_sra, (is_alu_reg_reg &: (reduce (|:) [
          (instr.[14:12] ==:. 0b001) &: (instr.[31:25] ==:. 0b0000000);
          (instr.[14:12] ==:. 0b101) &: (instr.[31:25] ==:. 0b0000000);
          (instr.[14:12] ==:. 0b101) &: (instr.[31:25] ==:. 0b0100000)
        ]));
        Rdcycle_rdcycleh_rdinstr_rdinstrh, f [Rdcycle; Rdcycleh; Rdinstret; Rdinstreth];
      ] in
      let is = 
        List.map (fun (i,v) -> Enum.from_enum<Is.t> i, v) is
        |> List.sort (fun (a,_) (b,_) -> - (compare a b)) 
        |> List.map snd
        |> concat
      in
      assert (width is = Is_v.n);
      is

    let decode_fclass instr insn is = 
      let open FClass in
      let open Insn in
      let open Is in
      let u = reduce (|:) @@ List.map (Insn_v.sel insn) [Auipc; Lui] in
      let uj = Insn_v.sel insn Jal in
      let s = Is_v.sel is Sb_sh_sw in
      let sb = Is_v.sel is Beq_bne_blt_bge_bltu_bgeu in
      let i = reduce (|:) @@ List.map (Is_v.sel is) 
        [Jalr_addi_slti_sltiu_xori_ori_andi; Lb_lh_lw_lbu_lhu] 
      in
      let r = Is_v.sel is Alu_reg_reg in
      let rsft = Is_v.sel is Slli_srli_srai in
      (*let sys = Is_v sel is System in
      let cnt = Is_v sel is Count in*)
      ()

          
    let f ~n ~inp ~comb ~pipe = 
      let open Pipe in
      let module Seq = Utils.Regs(struct let clk=inp.I.clk let clr=inp.I.clr end) in

      (* delay enable until data is ready on memory port and decoded *)
      let pen = Seq.reg ~e:vdd pipe.(n-1).pen in

      let instr = inp.I.mio_rdata in
       
      (* decoding *)
      let insn, base_instr = decode_insn instr in
      let is = decode_is instr insn base_instr in
      let fclass = decode_fclass instr insn is in
      let imm_uj = imm_uj instr in
      let imm = imm instr insn is imm_uj in

      (* register addresses *)
      let rad, ra1, ra2 = instr.[11:7], instr.[19:15], instr.[24:20] in
      let rad_zero, ra1_zero, ra2_zero = rad ==:. 0, ra1 ==:. 0, ra2 ==:. 0 in

      (* (async) regiser file *)
      let rfo = 
        Rf.f 
          Rf.I.({ 
            clk=inp.I.clk; clr=inp.I.clr;
            (* write from commit stage *)
            wr=gnd; wa=zero log_regs; d=pipe.(4).rdd; 
            (* read *)
            ra1; ra2; 
          })
      in
      let rd1, rd2 = rfo.Rf.O.q1, rfo.Rf.O.q2 in
        
      { pipe.(n-1) with 
        pen; 
        ra1; ra2; rad;
        ra1_zero; ra2_zero; rad_zero;
        rd1; rd2;
        imm; 
        instr; insn; 
        is }

  end

  module Decoder2 = struct
    (* ALM = 509, REG = 405 *)
    
    (* note; parameterised over Comb.S so it can be used with the sat solver *)
    module Make(B : HardCaml.Comb.S) = struct

      open B

      type t = 
        {
          (* fully decoded instructions *)
          insn : B.t;
          (* various classes of instruction *)
          trap : B.t;
          lui : B.t;
          auipc : B.t;
          jal : B.t;
          jalr : B.t;
          bra : B.t;
          ld : B.t;
          st : B.t;
          opi : B.t;
          opr : B.t;
          fen : B.t;
          sys : B.t;
        }

      let decoder instr = 
        let opcode = instr.[6:0] in
        let funct3 = instr.[14:12] in
        let funct7 = instr.[31:25] in
        let funct12 = instr.[31:20] in

        let f3' = binary_to_onehot funct3 in
        let f3  = bits f3' |> List.rev |> Array.of_list in
        let f7_0,f7_s = funct7 ==:. 0b0000000, funct7 ==:. 0b0100000 in
        let f7_x = f7_0 |: f7_s in

        let rs1, rs2, rd = instr.[19:15], instr.[24:20], instr.[11:7] in
        let rs1_0, rs2_0, rd_0 = rs1 ==:. 0, rs2 ==:. 0, rd ==:. 0 in

        let isf3 l = reduce (|:) (List.map (Array.get f3) l) in
        let notf3 l = ~: (isf3 l) in

        let lui   = opcode ==:. 0b0110111 in
        let auipc = opcode ==:. 0b0010111 in
        let jal   = opcode ==:. 0b1101111 in
        let jalr  = opcode ==:. 0b1100111 &: f3.(0) in
        let bra   = opcode ==:. 0b1100011 in
        let ld    = opcode ==:. 0b0000011 in
        let st    = opcode ==:. 0b0100011 in
        let opi   = opcode ==:. 0b0010011 in
        let opr   = opcode ==:. 0b0110011 in
        let fen   = opcode ==:. 0b0001111 in
        let sys   = opcode ==:. 0b1110011 in

        let fence, fencei = fen &: f3.(0), fen &: f3.(1) in

        let scall, sbreak = 
          let f12_0, f12_1 = funct12 ==:. 0b000000000000, funct12 ==:. 0b000000000001 in
          let c = rs1_0 &: f3.(0) &: rd_0 &: sys in
          f12_0 &: c, f12_1 &: c
        in

        let rdcycle, rdtime, rdinstret, rdhigh =
          let f = (funct12.[11:8] ==:. 0b1100) &: (funct12.[6:2] ==:. 0b00000) in
          let c = rs1_0 &: f3.(2) &: sys &: f in
          let x = funct12.[1:0] in
          x ==:. 0b00 &: c, x ==:. 0b01 &: c, x ==:. 0b10 &: c, funct12.[7:7]
        in

        let trap = 
          let bra = bra &: notf3 [2;3] in
          let ld  = ld  &: notf3 [3;6;7] in
          let st  = st  &: isf3 [0;1;2] in
          let opr = 
            let c = isf3 [0;5] in
            opr &: ((c &: f7_x) |: ((~: c) &: f7_0))
          in
          let opi, sfti = 
            opi &: notf3[1;5], 
            opi &: ((f3.(1) &: f7_0) |: (f3.(5) &: f7_x))
          in
          ~: (reduce (|:) 
            [lui; auipc; jal; jalr; bra; ld; st; opi; sfti; opr; 
             fence; fencei; scall; sbreak; rdcycle; rdtime; rdinstret])
        in

        let open Insn in
        let insn = [
          Lui, lui; 
          Auipc, auipc; 
          Jal, jal; 
          Jalr, jalr; 
          Beq, bra &: f3.(0); 
          Bne, bra &: f3.(1); 
          Blt, bra &: f3.(4); 
          Bge, bra &: f3.(5); 
          Bltu, bra &: f3.(6); 
          Bgeu, bra &: f3.(7); 
          Lb, ld &: f3.(0); 
          Lh, ld &: f3.(1); 
          Lw, ld &: f3.(2); 
          Lbu, ld &: f3.(4); 
          Lhu, ld &: f3.(5); 
          Sb, st &: f3.(0); 
          Sh, st &: f3.(1); 
          Sw, st &: f3.(2); 
          Addi, opi &: f3.(0); 
          Slti, opi &: f3.(2); 
          Sltiu, opi &: f3.(3); 
          Xori, opi &: f3.(4); 
          Ori, opi &: f3.(6); 
          Andi, opi &: f3.(7); 
          Slli, opi &: f3.(1) &: f7_0; 
          Srli, opi &: f3.(5) &: f7_0; 
          Srai, opi &: f3.(5) &: f7_s; 
          Add, opr &: f3.(0) &: f7_0; 
          Sub, opr &: f3.(0) &: f7_s; 
          Sll, opr &: f3.(1) &: f7_0; 
          Slt, opr &: f3.(2) &: f7_0; 
          Sltu, opr &: f3.(3) &: f7_0; 
          Xor, opr &: f3.(4) &: f7_0; 
          Srl, opr &: f3.(5) &: f7_0; 
          Sra, opr &: f3.(5) &: f7_s; 
          Or, opr &: f3.(6) &: f7_0; 
          And, opr &: f3.(7) &: f7_0; 
          Fence, fence; 
          Fenchi, fencei; 
          Scall, scall; 
          Sbreak, sbreak;
          Rdcycle, rdcycle &: ~: rdhigh; 
          Rdcycleh, rdcycle &: rdhigh; 
          Rdtime, rdtime &: ~: rdhigh; 
          Rdtimeh, rdtime &: rdhigh; 
          Rdinstret, rdinstret &: ~: rdhigh; 
          Rdinstreth, rdinstret &: rdhigh; 
          Invalid, trap;
        ] in
        let insn = 
          List.map (fun (i,v) -> Enum.from_enum<Insn.t> i, v) insn
          |> List.sort (fun (a,_) (b,_) -> - (compare a b)) 
          |> List.map snd
          |> concat
        in

        { insn; trap; lui; auipc; jal; jalr; bra; ld; st; opi; opr; fen; sys }

    end

    let name = "dec2"

    let imm_uj instr = 
      let d = sresize (instr.[31:12] @: gnd) 32 in
      let rec f off = function
        | [] -> []
        | (h,l) :: tl -> 
          let w = h-l+1 in
          (l, select d (off+w-1) off) :: f (off + w) tl
      in
      concat @@ List.map snd @@ List.sort (fun a b -> compare (fst b) (fst a)) @@ 
        f 0 [0,0; 19,12; 11,11; 10,1; 31,20]

    let f ~n ~inp ~comb ~pipe = 

      let open Pipe in
      let module Seq = Utils.Regs(struct let clk=inp.I.clk let clr=inp.I.clr end) in
      let module D = Make(HardCaml.Signal.Comb) in

      let instr = inp.I.mio_rdata in
      let d = D.decoder instr in

      (* extract immediate field *)
      let imm_uj = imm_uj instr in
      let imm = 
        let smap x l = List.map (fun (h,l) -> x.[h:l]) l in
        pmux [
          d.D.jal, imm_uj;
          d.D.lui |: d.D.auipc, instr.[31:12] @: zero 12;
          d.D.jalr |: d.D.ld |: d.D.opi, sresize instr.[31:20] 32;
          d.D.bra, sresize (concat ((smap instr [(31,31); (7,7); (30,25); (11,8)]) @ [gnd])) 32;
          d.D.st, sresize (concat (smap instr [(31,25); (11,7)])) 32;
        ] (zero 32)
      in

      (* register addresses *)
      let rad, ra1, ra2 = instr.[11:7], instr.[19:15], instr.[24:20] in
      let rad_zero, ra1_zero, ra2_zero = rad ==:. 0, ra1 ==:. 0, ra2 ==:. 0 in

      (* (async) regiser file *)
      let rfo = 
        Rf.f 
          Rf.I.({ 
            clk=inp.I.clk; clr=inp.I.clr;
            (* write from commit stage *)
            wr=gnd; wa=zero log_regs; d=pipe.(4).rdd; 
            (* read *)
            ra1; ra2; 
          })
      in
      let rd1, rd2 = rfo.Rf.O.q1, rfo.Rf.O.q2 in
        
      let pen = Seq.reg ~e:vdd pipe.(n-1).pen in

      { pipe.(n-1) with 
        pen; 
        ra1; ra2; rad;
        ra1_zero; ra2_zero; rad_zero;
        rd1; rd2;
        imm; 
        instr; insn=d.D.insn }

  end

  module Alu = struct
    let name = "alu"
    let f ~n ~inp ~comb ~pipe = 
      let open Pipe in

      let cur = pipe.(n) in
      let instr x = Insn_v.sel cur.insn x in
      let is x = Is_v.sel cur.is x in
      let rd1 = cur.rd1 in
      let rd2 = cur.rd2 in

      let alu_cmp = Utils.pmux1ht [
        instr Insn.Beq, rd1 ==: rd2;
        instr Insn.Bne, rd1 <>: rd2;
        instr Insn.Bge, rd1 >=+ rd2;
        instr Insn.Bgeu, rd1 >=: rd2;
        is Is.Slti_blt_slt, rd1 <+ rd2;
        is Is.Sltiu_bltu_sltu, rd1 <: rd2;
      ] in
      
      let alu = Utils.pmux1ht [
        is Is.Lui_auipc_jal_jalr_addi_add, rd1 +: rd2;
        instr Insn.Sub, rd1 -: rd2;
        is Is.Compare, uresize alu_cmp 32;
        instr Insn.Xori |: instr Insn.Xor, rd1 ^: rd2;
        instr Insn.Ori |: instr Insn.Or, rd1 |: rd2;
        instr Insn.Andi |: instr Insn.And, rd1 &: rd2;
      ] in

      { pipe.(n-1) with alu; alu_cmp }

  end

  module Alu2 = struct

    let name = "alu2"

    let f ~n ~inp ~comb ~pipe = pipe.(n-1)

  end

  module Mem = struct
    let name = "mem"
    let f ~n ~inp ~comb ~pipe = pipe.(n-1)
  end

  module Commit = struct
    let name = "com"
    let f ~n ~inp ~comb ~pipe = pipe.(n-1)
  end

  module type Pipe_S = module type of Pipe
  let map_pipe_name name = 
    let module X = struct
      include Pipe
      let t = map (fun (n,b) -> name^"_"^n,b) t
    end in
    (module X : Pipe_S)

  let pipename name (n,b) = name^"_"^n, b 
  module Pipe_fet = struct include Pipe let t = map (pipename "fet") t end
  module Pipe_dec = struct include Pipe let t = map (pipename "dec") t end
  module Pipe_alu = struct include Pipe let t = map (pipename "alu") t end
  module Pipe_mem = struct include Pipe let t = map (pipename "mem") t end
  module Pipe_com = struct include Pipe let t = map (pipename "com") t end
  module O_debug = interface
    (o : O)
    (fet : Pipe_fet)
    (dec : Pipe_dec)
    (alu : Pipe_alu)
    (mem : Pipe_mem)
    (com : Pipe_com)
  end

  module Output = struct
    let f pipe = 
      let open Pipe in
      O.({
        mio_addr = pipe.(com).pc;
        mio_wdata = zero C.xlen; 
        mio_req = gnd; 
        mio_rw = pipe.(com).junk;
        mio_wmask = zero (C.xlen/8);
      })
  end

  module Output_debug = struct
    let f pipe = 
      O_debug.({
        o = Output.f pipe;
        fet = pipe.(0);
        dec = pipe.(1);
        alu = pipe.(2);
        mem = pipe.(3);
        com = pipe.(4);
      })
  end

end


module Test = struct

  module Cfg = struct
    let xlen = 32
    let start_addr = 0x10
  end

  module Rv = Make(Cfg)

  module B = HardCaml.Api.B

  module Rv_o = Rv.O_debug
  module Rv_output = Rv.Output_debug

  let pipeline = 
    Rv.build_pipeline
      ~f_stages:[| 
        (module Rv.Fetch : Rv.M_stage); 
        (module Rv.Decoder : Rv.M_stage); 
        (module Rv.Alu : Rv.M_stage); 
        (module Rv.Mem : Rv.M_stage); 
        (module Rv.Commit : Rv.M_stage);
      |]
      ~f_output:Rv_output.f

  let write_circ name circ = 
    let f = open_out (name ^ ".v") in
    HardCaml.Rtl.Verilog.write (output_string f) circ;
    close_out f

  let write_pipe_stage name stage p = 
    let module P = (val p : Rv.Stage) in
    let inp = Rv.I.(map (fun (n,b) -> input n b) t) in
    let module Seq = Utils.Regs(struct let clk=inp.Rv.I.clk let clr=inp.Rv.I.clr end) in
    let pipe = Array.init 5 (fun j -> 
      Rv.Pipe.(map (fun (n,b) -> Seq.reg ~e:vdd (input (n^"_p_"^string_of_int j) b)) t)) 
    in
    let comb = Array.init 5 (fun j -> 
      Rv.Pipe.(map (fun (n,b) -> Seq.reg ~e:vdd (input (n^"_c_"^string_of_int j) b)) t)) 
    in
    let o = P.f ~n:stage ~inp ~comb ~pipe in
    let o = Rv.Pipe.(map2 (fun o (n,b) -> n,o) o t) in
    let o = 
      Rv.Pipe.to_list o 
      (*|> List.filter (fun (n,o) -> not (is_const x)) o*) 
      |> List.map (fun (n,o) -> output n (Seq.reg ~e:vdd o))
    in
    let circ = HardCaml.Circuit.make name o in
    write_circ name circ

  let write_core () = 
    let module G = HardCaml.Interface.Circ(Rv.I)(Rv_o) in
    let circ = G.make "rv32i" pipeline in
    write_circ "rv32i" circ

  module Waveterm_waves = HardCamlWaveTerm.Wave.Make(HardCamlWaveTerm.Wave.Bits(B))
  module Waveterm_sim = HardCamlWaveTerm.Sim.Make(B)(Waveterm_waves)
  module Waveterm_ui = HardCamlWaveLTerm.Ui.Make(B)(Waveterm_waves)

  let waves = true

  let testbench () = 

    let open HardCaml.Api in
    let module G = HardCaml.Interface.Gen(B)(Rv.I)(Rv_o) in
    let circ,sim,i,o,o' = G.make "rv32i" pipeline in

    (* waveform viewer *)
    let wave_cfg = 
      let f = function (n,b) -> if b=1 then n, Waveterm_waves.B
                                else n, Waveterm_waves.H
      in
      Some( 
        [f ( "clk",1); f ("clr",1); ] @
        Rv.I.(to_list @@ map f t) @ 
        Rv_o.(to_list @@ map f t) )
    in
    let sim, waves = 
      if waves then 
        let sim, waves = Waveterm_sim.wrap ?cfg:wave_cfg sim in
        sim, Some(waves)
      else sim, None
    in

    let open Rv.I in
    let open Rv.O in
    let open Rv_o in

    let module D = Utils.D32(B) in
    let module Mem = Utils.Mem(D) in
    let memory = Mem.init (8*1024) in (* 32 Kib *)

    let mio () = 
      let o = o.o in
      i.mio_vld := B.gnd;
      if B.to_int !(o.mio_req) = 1 then begin
        i.mio_vld := B.vdd;
        if B.to_int !(o.mio_rw) = 1 then begin
          i.mio_rdata := D.to_signal @@ Mem.read ~memory ~addr:!(o.mio_addr)
        end else begin
          Mem.write ~memory ~addr:!(o.mio_addr) ~data:!(o.mio_wdata) ~strb:!(o.mio_wmask)
        end
      end;
    in

    let cycle () = 
      mio();
      Cs.cycle sim 
    in

    Cs.reset sim;
    i.clr := B.vdd;
    cycle();
    i.clr := B.gnd;
    for i=0 to 20 do
      cycle();
    done;

    begin
      match waves with
      | None -> ()
      | Some(waves) ->
        Lwt_main.run (Waveterm_ui.run Waveterm_waves.({ cfg=default; waves }))
    end

end

