
open HardCaml
open Signal.Comb
open Signal.Seq

module Options = struct

  let enable_counters = true
  let enable_regs_16_31 = true
  let enable_regs_dualport = true
  let latched_mem_rdata = false
  let enable_pcpi = false
  let enable_mul = true
  let enable_irq = true
  let enable_irq_qregs = true
  let enable_irq_timer = true
  let masked_irq = consti 32 0
  let latched_irq = consti 32 (-1)
  let progaddr_reset = consti 32 0
  let progaddr_irq = consti 32 16
  
  let mul_steps_at_once = 1

end

module Instr = struct

  type t = 
    | Lui | Auipc | Jal | Jalr | Beq | Bne | Blt | Bge | Bltu | Bgeu | Lb
    | Lh | Lw | Lbu | Lhu | Sb | Sh | Sw | Addi | Slti | Sltiu | Xori | Ori
    | Andi | Slli | Srli | Srai | Add | Sub | Sll | Slt | Sltu | Xor | Srl
    | Sra | Or | And | Rdcycle | Rdcycleh | Rdinstr | Rdinstrh | Getq | Setq
    | Retirq | Maskirq | Waitirq | Timer | Trap
    deriving(Enum,Bounded,Show)

  let name = "instr"

  let n = 1 + Enum.from_enum<t> Bounded.max_bound<t>

  let sel x b = let b = Enum.from_enum<t> b in x.[b:b]

  let cname x = "instr_" ^ (String.lowercase (Show_t.show x))

  let list = Enum_t.enum_from_to Bounded_t.min_bound Bounded_t.max_bound

end

module Is = struct

  type t = 
    | Lui_auipc_jal | Lb_lh_lw_lbu_lhu | Slli_srli_srai | Jalr_addi_slti_sltiu_xori_ori_andi
    | Sb_sh_sw | Sll_srl_sra | Lui_auipc_jal_jalr_addi_add | Slti_blt_slt
    | Sltiu_bltu_sltu | Beq_bne_blt_bge_bltu_bgeu | Lbu_lhu_lw | Alu_reg_imm
    | Alu_reg_reg | Compare | Rdcycle_rdcycleh_rdinstr_rdinstrh
    deriving(Enum,Bounded,Show)

  let name = "is"

  let n = 1 + Enum.from_enum<t> Bounded.max_bound<t>

  let sel x b = let b = Enum.from_enum<t> b in x.[b:b]

  let cname x = "is_" ^ (String.lowercase (Show_t.show x))

  let list = Enum_t.enum_from_to Bounded_t.min_bound Bounded_t.max_bound

end

let irq_timer = 0
let irq_sbreak = 1
let irq_buserror = 2

(* one hot control inputs. log depth muxes *)
let pmux1ht x = 
  snd @@ tree 2 
    (function [(c,d)] -> (c,d) 
            | [(a,b);(c,d)] -> (a|:c, mux2 a b d) 
            | _ -> failwith "") x

let cbool x = if x then vdd else gnd

module type Regs = sig
  val r_spec : t -> Signal.Types.register
  val reg : c:t -> e:t -> d:t -> t
end

module Regs (X : sig
  val clk : t
  val resetn : t
end) = struct

  let r_spec c = 
    Signal.Types.({ r_async with
      reg_clock = X.clk;
      reg_reset = X.resetn;
      reg_reset_level = gnd;
      reg_reset_value = c }) 

  let reg ~c ~e ~d = reg (r_spec c) e d
  let reg_fb ~c ~e ~w f = reg_fb (r_spec c) e w f
  let g_reg ~c ~e ~n = Signal.Guarded.g_reg (r_spec c) e n

end

open Options

let irqregs_offset = if enable_regs_16_31 then 32 else 16

let regfile_size = (
  if enable_regs_16_31 then 32 else 16) +
  (if enable_irq && enable_irq_qregs then 4 else 0)

let regindex_bits = 
  (if enable_regs_16_31 then 5 else 4) + 
  (if enable_irq && enable_irq_qregs then 1 else 0)

let with_pcpi = enable_pcpi || enable_mul

(* instruction decoder *)

module Decoder = struct

  module I = interface
    clk[1] resetn[1]
    mem_do_rinst[1] mem_done[1] 
    mem_rdata_latched[32] mem_rdata_q[32]
    decoder_trigger[1] (*decoder_trigger_q[1]*) decoder_pseudo_trigger[1]
  end

  module O = interface
    instr[Instr.n] is[Is.n]
    pcpi_insn[32] 
    decoded_rd[regindex_bits] decoded_rs1[regindex_bits] decoded_rs2[regindex_bits]
    decoded_imm[32] decoded_imm_uj[32]
  end

  let decoder
    regs
    mem_rdata_q mem_rdata_latched 
    mem_do_rinst mem_done
    decoder_trigger decoder_pseudo_trigger
    = 
    let open Instr in
    let open Is in
    let module Regs = (val regs : Regs) in
    let open Regs in

    let enable_irq = cbool Options.enable_irq in
    let enable_irq_qregs = cbool Options.enable_irq_qregs in
    let enable_irq_timer = cbool Options.enable_irq_timer in
    let enable_counters = cbool Options.enable_counters in

    let reg e d = reg ~c:gnd ~e ~d in
    let r0 = reg vdd in
    let r1 = reg (mem_do_rinst &: mem_done) in
    let r2 = reg (decoder_trigger &: ~: (decoder_pseudo_trigger)) in

    let instr_lui   = r1 (mem_rdata_latched.[6:0] ==:. 0b0110111) in
    let instr_auipc = r1 (mem_rdata_latched.[6:0] ==:. 0b0010111) in
    let instr_jal   = r1 (mem_rdata_latched.[6:0] ==:. 0b1101111) in
    let instr_jalr  = r1 (mem_rdata_latched.[6:0] ==:. 0b1100111) in

    let is_beq_bne_blt_bge_bltu_bgeu = r1 (mem_rdata_latched.[6:0] ==:. 0b1100011) in
    let is_lb_lh_lw_lbu_lhu          = r1 (mem_rdata_latched.[6:0] ==:. 0b0000011) in
    let is_sb_sh_sw                  = r1 (mem_rdata_latched.[6:0] ==:. 0b0100011) in
    let is_alu_reg_imm               = r1 (mem_rdata_latched.[6:0] ==:. 0b0010011) in
    let is_alu_reg_reg               = r1 (mem_rdata_latched.[6:0] ==:. 0b0110011) in

    let instr = [
      Lui,     instr_lui;
      Auipc,   instr_auipc;
      Jal,     instr_jal;
      Jalr,    instr_jalr;
      Retirq,  r1 ((mem_rdata_latched.[6:0] ==:. 0b0001011) &: 
                  (mem_rdata_latched.[31:25] ==:. 0b0000010) &: enable_irq);
      Waitirq, r1 ((mem_rdata_latched.[6:0] ==:. 0b0001011) &: 
                  (mem_rdata_latched.[31:25] ==:. 0b0000100) &: enable_irq);

      Beq,   r2 (is_beq_bne_blt_bge_bltu_bgeu &: (mem_rdata_q.[14:12] ==:. 0b000));
      Bne,   r2 (is_beq_bne_blt_bge_bltu_bgeu &: (mem_rdata_q.[14:12] ==:. 0b001));
      Blt,   r2 (is_beq_bne_blt_bge_bltu_bgeu &: (mem_rdata_q.[14:12] ==:. 0b100));
      Bge,   r2 (is_beq_bne_blt_bge_bltu_bgeu &: (mem_rdata_q.[14:12] ==:. 0b101));
      Bltu,  r2 (is_beq_bne_blt_bge_bltu_bgeu &: (mem_rdata_q.[14:12] ==:. 0b110));
      Bgeu,  r2 (is_beq_bne_blt_bge_bltu_bgeu &: (mem_rdata_q.[14:12] ==:. 0b111));

      Lb,    r2 (is_lb_lh_lw_lbu_lhu &: (mem_rdata_q.[14:12] ==:. 0b000));
      Lh,    r2 (is_lb_lh_lw_lbu_lhu &: (mem_rdata_q.[14:12] ==:. 0b001));
      Lw,    r2 (is_lb_lh_lw_lbu_lhu &: (mem_rdata_q.[14:12] ==:. 0b010));
      Lbu,   r2 (is_lb_lh_lw_lbu_lhu &: (mem_rdata_q.[14:12] ==:. 0b100));
      Lhu,   r2 (is_lb_lh_lw_lbu_lhu &: (mem_rdata_q.[14:12] ==:. 0b101));

      Sb,    r2 (is_sb_sh_sw &: (mem_rdata_q.[14:12] ==:. 0b000));
      Sh,    r2 (is_sb_sh_sw &: (mem_rdata_q.[14:12] ==:. 0b001));
      Sw,    r2 (is_sb_sh_sw &: (mem_rdata_q.[14:12] ==:. 0b010));

      Addi,  r2 (is_alu_reg_imm &: (mem_rdata_q.[14:12] ==:. 0b000));
      Slti,  r2 (is_alu_reg_imm &: (mem_rdata_q.[14:12] ==:. 0b010));
      Sltiu, r2 (is_alu_reg_imm &: (mem_rdata_q.[14:12] ==:. 0b011));
      Xori,  r2 (is_alu_reg_imm &: (mem_rdata_q.[14:12] ==:. 0b100));
      Ori,   r2 (is_alu_reg_imm &: (mem_rdata_q.[14:12] ==:. 0b110));
      Andi,  r2 (is_alu_reg_imm &: (mem_rdata_q.[14:12] ==:. 0b111));

      Slli,  r2 (is_alu_reg_imm &: (mem_rdata_q.[14:12] ==:. 0b001) &: 
                                  (mem_rdata_q.[31:25] ==:. 0b0000000));
      Srli,  r2 (is_alu_reg_imm &: (mem_rdata_q.[14:12] ==:. 0b101) &: 
                                  (mem_rdata_q.[31:25] ==:. 0b0000000));
      Srai,  r2 (is_alu_reg_imm &: (mem_rdata_q.[14:12] ==:. 0b101) &: 
                                  (mem_rdata_q.[31:25] ==:. 0b0100000));

      Add,   r2 (is_alu_reg_reg &: (mem_rdata_q.[14:12] ==:. 0b000) &: 
                                  (mem_rdata_q.[31:25] ==:. 0b0000000));
      Sub,   r2 (is_alu_reg_reg &: (mem_rdata_q.[14:12] ==:. 0b000) &: 
                                  (mem_rdata_q.[31:25] ==:. 0b0100000));
      Sll,   r2 (is_alu_reg_reg &: (mem_rdata_q.[14:12] ==:. 0b001) &: 
                                  (mem_rdata_q.[31:25] ==:. 0b0000000));
      Slt,   r2 (is_alu_reg_reg &: (mem_rdata_q.[14:12] ==:. 0b010) &: 
                                  (mem_rdata_q.[31:25] ==:. 0b0000000));
      Sltu,  r2 (is_alu_reg_reg &: (mem_rdata_q.[14:12] ==:. 0b011) &: 
                                  (mem_rdata_q.[31:25] ==:. 0b0000000));
      Xor,   r2 (is_alu_reg_reg &: (mem_rdata_q.[14:12] ==:. 0b100) &: 
                                  (mem_rdata_q.[31:25] ==:. 0b0000000));
      Srl,   r2 (is_alu_reg_reg &: (mem_rdata_q.[14:12] ==:. 0b101) &: 
                                  (mem_rdata_q.[31:25] ==:. 0b0000000));
      Sra,   r2 (is_alu_reg_reg &: (mem_rdata_q.[14:12] ==:. 0b101) &: 
                                  (mem_rdata_q.[31:25] ==:. 0b0100000));
      Or,    r2 (is_alu_reg_reg &: (mem_rdata_q.[14:12] ==:. 0b110) &: 
                                  (mem_rdata_q.[31:25] ==:. 0b0000000));
      And,   r2 (is_alu_reg_reg &: (mem_rdata_q.[14:12] ==:. 0b111) &: 
                                  (mem_rdata_q.[31:25] ==:. 0b0000000));

      Rdcycle,  r2 ((((mem_rdata_q.[6:0] ==:. 0b1110011) &: 
                      (mem_rdata_q.[31:12] ==:. 0b11000000000000000010)) |:
                    ((mem_rdata_q.[6:0] ==:. 0b1110011) &: 
                      (mem_rdata_q.[31:12] ==:. 0b11000000000100000010))) &:
                    enable_counters);
      Rdcycleh, r2 ((((mem_rdata_q.[6:0] ==:. 0b1110011) &: 
                      (mem_rdata_q.[31:12] ==:. 0b11001000000000000010)) |:
                    ((mem_rdata_q.[6:0] ==:. 0b1110011) &: 
                      (mem_rdata_q.[31:12] ==:. 0b11001000000100000010))) &: 
                    enable_counters);
      Rdinstr,  r2 (((mem_rdata_q.[6:0] ==:. 0b1110011) &: 
                    (mem_rdata_q.[31:12] ==:. 0b11000000001000000010)) &: 
                    enable_counters);
      Rdinstrh, r2 (((mem_rdata_q.[6:0] ==:. 0b1110011) &: 
                    (mem_rdata_q.[31:12] ==:. 0b11001000001000000010)) &: 
                    enable_counters);

      Getq,    r2 ((mem_rdata_q.[6:0] ==:. 0b0001011) &: 
                  (mem_rdata_q.[31:25] ==:. 0b0000000) &: 
                  enable_irq &: enable_irq_qregs);
      Setq,    r2 ((mem_rdata_q.[6:0] ==:. 0b0001011) &: 
                  (mem_rdata_q.[31:25] ==:. 0b0000001) &: 
                  enable_irq &: enable_irq_qregs);
      Maskirq, r2 ((mem_rdata_q.[6:0] ==:. 0b0001011) &: 
                  (mem_rdata_q.[31:25] ==:. 0b0000011) &: 
                  enable_irq);
      Timer,   r2 ((mem_rdata_q.[6:0] ==:. 0b0001011) &: 
                  (mem_rdata_q.[31:25] ==:. 0b0000101) &: 
                  enable_irq &: enable_irq_timer);
    ] 
    in
    let instr = (Trap, ~: (reduce (|:) (List.map snd instr))) :: instr in
    let instr = 
      let name i = "instr_" ^ String.lowercase (Show.show<Instr.t> i) in
      List.map (fun (i,v) -> Enum.from_enum<Instr.t> i, v -- (name i)) instr
      |> List.sort (fun (a,_) (b,_) -> - (compare a b)) 
      |> List.map snd
      |> concat
    in

    let f l = reduce (|:) (List.map (Instr.sel instr) l) in
    let is = [
      Lui_auipc_jal,   r0 (f [Lui; Auipc; Jal]);
      Lui_auipc_jal_jalr_addi_add, 
                      r0 (f [Lui; Auipc; Jal; Jalr; Addi; Add]);
      Slti_blt_slt,    r0 (f [Slti; Blt; Slt]);
      Sltiu_bltu_sltu, r0 (f [Sltiu; Bltu; Sltu]);
      Lbu_lhu_lw,      r0 (f [Lbu; Lhu; Lw]);
      Compare,         r0 (f [Slti; Slt; Sltiu; Sltu] |: is_beq_bne_blt_bge_bltu_bgeu);
      Beq_bne_blt_bge_bltu_bgeu, is_beq_bne_blt_bge_bltu_bgeu;
      Lb_lh_lw_lbu_lhu,          is_lb_lh_lw_lbu_lhu;
      Sb_sh_sw,                  is_sb_sh_sw;
      Alu_reg_imm,               is_alu_reg_imm;
      Alu_reg_reg,               is_alu_reg_reg;
      Slli_srli_srai, r2 (is_alu_reg_imm &: (reduce (|:) [
        (mem_rdata_q.[14:12] ==:. 0b001) &: (mem_rdata_q.[31:25] ==:. 0b0000000);
        (mem_rdata_q.[14:12] ==:. 0b101) &: (mem_rdata_q.[31:25] ==:. 0b0000000);
        (mem_rdata_q.[14:12] ==:. 0b101) &: (mem_rdata_q.[31:25] ==:. 0b0100000)
      ]));
      Jalr_addi_slti_sltiu_xori_ori_andi, r2 (instr_jalr |: (is_alu_reg_imm &: (reduce (|:) [
        mem_rdata_q.[14:12] ==:. 0b000;
        mem_rdata_q.[14:12] ==:. 0b010;
        mem_rdata_q.[14:12] ==:. 0b011;
        mem_rdata_q.[14:12] ==:. 0b100;
        mem_rdata_q.[14:12] ==:. 0b110;
        mem_rdata_q.[14:12] ==:. 0b111
      ])));
      Sll_srl_sra, r2 (is_alu_reg_reg &: (reduce (|:) [
        (mem_rdata_q.[14:12] ==:. 0b001) &: (mem_rdata_q.[31:25] ==:. 0b0000000);
        (mem_rdata_q.[14:12] ==:. 0b101) &: (mem_rdata_q.[31:25] ==:. 0b0000000);
        (mem_rdata_q.[14:12] ==:. 0b101) &: (mem_rdata_q.[31:25] ==:. 0b0100000)
      ]));
      Rdcycle_rdcycleh_rdinstr_rdinstrh, f [Rdcycle; Rdcycleh; Rdinstr; Rdinstrh];
    ] in
    let is = 
      let name i = "is_" ^ String.lowercase (Show.show<Is.t> i) in
      List.map (fun (i,v) -> Enum.from_enum<Is.t> i, v -- name i) is
      |> List.sort (fun (a,_) (b,_) -> - (compare a b)) 
      |> List.map snd
      |> concat
    in

    instr, is

  let f i = 

    let open I in
    let module Regs = Regs(struct let clk=i.clk let resetn=i.resetn end) in
    let open Regs in
      
    let enable_irq = cbool Options.enable_irq in
    let enable_irq_qregs = cbool Options.enable_irq_qregs in

    let reg e d = reg ~c:(zero (width d)) ~e ~d in
    let r1 = reg (i.mem_do_rinst &: i.mem_done) in
    let r2 = reg (i.decoder_trigger &: ~: (i.decoder_pseudo_trigger)) in

    let instr, is = decoder 
      (module Regs)
      i.mem_rdata_q i.mem_rdata_latched 
      i.mem_do_rinst i.mem_done
      i.decoder_trigger i.decoder_pseudo_trigger
    in

    let rs1 = 
      let c0 = ( 
        (i.mem_rdata_latched.[6:0] ==:. 0b0001011) &: 
        (i.mem_rdata_latched.[31:25] ==:. 0b0000000) &: 
        enable_irq &: enable_irq_qregs
      ) -- "c0" in
      let c1 = (
        (i.mem_rdata_latched.[6:0] ==:. 0b0001011) &:
        (i.mem_rdata_latched.[31:25] ==:. 0b0000010) &: 
        enable_irq
      ) -- "c1" in
      let rs1 = uresize i.mem_rdata_latched.[19:15] regindex_bits -- "cx" in
      mux2 c1 
        (consti regindex_bits (if Options.enable_irq_qregs then irqregs_offset else 3))
        (mux2 c0 (vdd @: lsbs rs1) rs1)
    in

    let decoded_imm_uj = 
      let d = sresize (i.mem_rdata_latched.[31:12] @: gnd) 32 in
      let rec f off = function
        | [] -> []
        | (h,l) :: tl -> 
          let w = h-l+1 in
          (l, select d (off+w-1) off) :: f (off + w) tl
      in
      r1 @@ concat @@ List.map snd @@  List.sort (fun a b -> compare (fst b) (fst a)) @@ 
        f 0 [0,0; 19,12; 11,11; 10,1; 31,20]
    in

    let decoded_imm = 
      let instr l = reduce (|:) (List.map (Instr.sel instr) l) in
      let is l = reduce (|:) (List.map (Is.sel is) l) in
      let open Instr in
      let open Is in
      let smap x l = List.map (fun (h,l) -> x.[h:l]) l in
      r2 (pmux [
        instr [Jal], 
          decoded_imm_uj;
        instr [Lui; Auipc], 
          i.mem_rdata_q.[31:12] @: zero 12;
        instr [Jalr] |: is [Lb_lh_lw_lbu_lhu; Alu_reg_imm], 
          sresize i.mem_rdata_q.[31:20] 32;
        is [Beq_bne_blt_bge_bltu_bgeu], 
          sresize (concat ((smap i.mem_rdata_q [(31,31); (7,7); (30,25); (11,8)]) @ [gnd])) 32;
        is [Sb_sh_sw], 
          sresize (concat (smap i.mem_rdata_q [(31,25); (11,7)])) 32;
      ] (zero 32))
    in

    O.({
      instr; is;
      decoded_rd = uresize (r1 i.mem_rdata_latched.[11:7]) regindex_bits;
      decoded_rs1 = r1 rs1;
      decoded_rs2 = uresize (r1 i.mem_rdata_latched.[24:20]) regindex_bits;
      pcpi_insn = if with_pcpi then r2 i.mem_rdata_q else zero 32;
      decoded_imm; decoded_imm_uj;
    })

end

module Alu = struct

  module I = interface
    reg_op1[32] reg_op2[32]
    instr[Instr.n] is[Is.n]
  end

  module O = interface
    alu_out[32]
    alu_out_0[1]
  end

  let f i = 
    let open I in
    let instr x = Instr.sel i.instr x in
    let is x = Is.sel i.is x in

    let alu_out_0 = pmux1ht [
      instr Instr.Beq, i.reg_op1 ==: i.reg_op2;
      instr Instr.Bne, i.reg_op1 <>: i.reg_op2;
      instr Instr.Bge, i.reg_op1 >=+ i.reg_op2;
      instr Instr.Bgeu, i.reg_op1 >=: i.reg_op2;
      is Is.Slti_blt_slt, i.reg_op1 <+ i.reg_op2;
      is Is.Sltiu_bltu_sltu, i.reg_op1 <: i.reg_op2;
    ] in
    
    let alu_out = pmux1ht [
      is Is.Lui_auipc_jal_jalr_addi_add, i.reg_op1 +: i.reg_op2;
      instr Instr.Sub, i.reg_op1 -: i.reg_op2;
      is Is.Compare, uresize alu_out_0 32;
      instr Instr.Xori |: instr Instr.Xor, i.reg_op1 ^: i.reg_op2;
      instr Instr.Ori |: instr Instr.Or, i.reg_op1 |: i.reg_op2;
      instr Instr.Andi |: instr Instr.And, i.reg_op1 &: i.reg_op2;
    ] in

    O.({
      alu_out;
      alu_out_0;
    })

end

module Memif = struct

  module I = interface
    clk[1] resetn[1]
    reg_op1[32] reg_op2[32] next_pc[32]
    mem_ready[1] mem_do_rinst[1] mem_rdata[32]
    mem_wordsize[2] mem_do_prefetch[1] mem_do_rdata[1] mem_do_wdata[1]
  end

  module O = interface
    mem_done[1] mem_valid[1] mem_instr[1] mem_addr[32] mem_wdata[32]
    mem_wstrb[4] mem_rdata_latched[32] mem_rdata_q[32] mem_rdata_word[32]
    mem_la_read[1] mem_la_write[1] mem_la_addr[32] mem_la_wdata[32] mem_la_wstrb[4]
  end

  let f i = 
    let open I in
    let module Regs = Regs(struct let clk=i.clk let resetn=i.resetn end) in
    let open Regs in

    let latched_mem_rdata = cbool Options.latched_mem_rdata in
    let is, sm, next = 
      Signal.Statemachine.statemachine (r_spec (zero 2)) vdd [0;1;2;3] 
    in
    let mem_state_n0, mem_state_3, mem_state_0 = ~: (is 0), is 3, is 0 in
    let mem_valid = g_reg ~c:gnd ~e:vdd ~n:1 in

    (*let mem_busy = 
      reduce (|:) [i.mem_do_prefetch; i.mem_do_rinst; i.mem_do_rdata; i.mem_do_wdata] 
    in*)
    let mem_done = 
      (i.mem_ready &: mem_state_n0 &: (i.mem_do_rinst |: i.mem_do_rdata |: i.mem_do_wdata)) |: 
      (mem_state_3 &: i.mem_do_rinst)
    in

    let mem_la_write = i.resetn &: mem_state_0 &: i.mem_do_wdata in
    let mem_la_read = 
      i.resetn &: mem_state_0 &: 
      (i.mem_do_rinst |: i.mem_do_prefetch |: i.mem_do_rdata)
    in
    let mem_la_addr = 
      mux2 (i.mem_do_prefetch |: i.mem_do_rinst) i.next_pc (i.reg_op1.[31:2] @: zero 2)
    in

    let mem_rdata_latched = wire 32 in
    let mem_rdata_q = reg ~c:(zero 32) ~e:(mem_valid#q &: i.mem_ready) ~d:mem_rdata_latched in
    let () = mem_rdata_latched <== 
      mux2 ((mem_valid#q &: i.mem_ready) |: latched_mem_rdata) i.mem_rdata mem_rdata_q 
    in

    let mem_la_wdata = mux i.mem_wordsize 
      (List.map (fun n -> repeat i.reg_op2.[(32/n)-1:0] n) [1;2;4])
    in
    let mem_la_wstrb = mux i.mem_wordsize
      [
        constb "1111";
        mux2 i.reg_op1.[1:1] (constb "1100") (constb "0011");
        mux i.reg_op1.[1:0] (List.map (consti 4) [1;2;4;8]);
      ]
    in
    let mem_rdata_word = 
      let u32 x = uresize x 32 in
      mux i.mem_wordsize
      [
        i.mem_rdata;
        mux i.reg_op1.[1:1] [u32 i.mem_rdata.[15:0]; u32 i.mem_rdata.[31:16]];
        mux i.reg_op1.[1:0] (Array.to_list @@ Array.init 4 
                                (fun j -> u32 i.mem_rdata.[(j*8)+7:(j*8)]))
      ]
    in

    let mem_addr = g_reg ~c:(zero 32) ~e:vdd ~n:32 in
    let mem_wdata = g_reg ~c:(zero 32) ~e:vdd ~n:32 in
    let mem_wstrb = g_reg ~c:(zero 4) ~e:vdd ~n:4 in
    let mem_instr = g_reg ~c:gnd ~e:vdd ~n:1 in
    let () = 
      let open Signal.Guarded in
      compile [
        sm [
          0, [
            mem_addr $== mem_la_addr;
            mem_wdata $== mem_la_wdata;
            mem_wstrb $== mem_la_wstrb;
            g_when (i.mem_do_prefetch |: i.mem_do_rinst |: i.mem_do_rdata) [
              mem_valid $== vdd;
              mem_instr $== (i.mem_do_prefetch |: i.mem_do_rinst);
              mem_wstrb $== (zero 4);
              next 1;
            ];
            g_when (i.mem_do_wdata) [
              mem_valid $== vdd;
              mem_instr $== gnd;
              next 2;
            ];
          ];
          1, [
            g_when i.mem_ready [
              mem_valid $== gnd;
              g_if (i.mem_do_rinst |: i.mem_do_rdata) [ next 0 ] [ next 3 ]
            ];
          ];
          2, [
            g_when i.mem_ready [ mem_valid $== gnd; next 0; ];
          ];
          3, [
            g_when i.mem_do_rinst [ next 0; ];
          ];
        ]
      ] 
    in

    let mem_valid, mem_instr, mem_addr, mem_wdata, mem_wstrb = 
      mem_valid#q, mem_instr#q, mem_addr#q, mem_wdata#q, mem_wstrb#q
    in
    O.({
      mem_done; mem_valid; mem_instr; mem_addr; mem_wdata;
      mem_wstrb; mem_rdata_latched; mem_rdata_q; mem_rdata_word;
      mem_la_read; mem_la_write; mem_la_addr; mem_la_wdata; mem_la_wstrb;
    })

end

module Pcpi = struct

  module I_ = interface
    valid[1] insn[32] rs1[32] rs2[32]
  end
  module I = struct
    include I_
    let t = map (fun (n,b) -> "pcpi_" ^ n,b) t
  end

  module O_ = interface
    wr[1] rd[32] wait_[1] ready[1]
  end
  module O = struct
    include O_
    let t = map (function "wait_",b -> "pcpi_wait", b | n,b -> "pcpi_" ^ n,b) t
  end

end

module Mul = struct
  
  module I = interface
    clk[1] resetn[1]
    (i : Pcpi.I)
  end
  module O = Pcpi.O
  
  let f i = 
    let open I in
    let open Pcpi.I in
    let module Regs = Regs(struct let clk=i.clk let resetn=i.resetn end) in
    let open Regs in

    let i', i = i, i.i in
    let sel = 
      i'.resetn &: i.valid &: (i.insn.[6:0] ==:. 0b0110011) &: (i.insn.[31:25] ==:. 0b0000001)
    in
    let mul    = reg ~c:gnd ~e:vdd ~d:(sel &: (i.insn.[14:12] ==:. 0)) in
    let mulh   = reg ~c:gnd ~e:vdd ~d:(sel &: (i.insn.[14:12] ==:. 1)) in
    let mulhsu = reg ~c:gnd ~e:vdd ~d:(sel &: (i.insn.[14:12] ==:. 2)) in
    let mulhu  = reg ~c:gnd ~e:vdd ~d:(sel &: (i.insn.[14:12] ==:. 3)) in

    let any_mul = reduce (|:) [ mul; mulh; mulhsu; mulhu ] in
    let any_mulh = reduce (|:) [ mulh; mulhsu; mulhu ] in
    let rs1_signed = reduce (|:) [ mulh; mulhsu ] in
    let rs2_signed = mulh in

    let wait_ = reg ~c:gnd ~e:vdd ~d:any_mul in
    let wait_q = reg ~c:gnd ~e:vdd ~d:wait_ in

    let start = wait_ &: (~: wait_q) in

    let rec csa i ((rd, rdx, rs1, rs2) as x) = 
      if i >= Options.mul_steps_at_once then x
      else
        let rdt' = rd ^: rdx in
        let rdt = mux2 rs1.[0:0] (rdt' ^: rs2) rdt' in
        let rdx' = rd &: rdx in
        let rdx = sll (mux2 rs1.[0:0] (rdx' |: (rd &: rs2) |: (rdx &: rs2)) rdx') 1 in
        let rd = rdt in
        let rs1 = srl rs1 1 in
        let rs2 = sll rs2 1 in
        csa (i+1) (rd, rdx, rs1, rs2) 
    in

    let rd, rdx, rs1, rs2 = 
      let r () = g_reg ~c:(zero 64) ~e:vdd ~n:64 in
      r (), r (), r (), r () 
    in
    let next_rd, next_rdx, next_rs1, next_rs2 = csa 0 (rd#q, rdx#q, rs1#q, rs2#q) in

    let counter = g_reg ~c:(zero 7) ~e:vdd ~n:7 in
    let waiting = g_reg ~c:vdd ~e:vdd ~n:1 in
    let finish = g_reg ~c:gnd ~e:vdd ~n:1 in

    let () = 
      let open Signal.Guarded in
      compile [
        finish $== gnd;
        g_if waiting#q [
          rs1 $== (mux2 rs1_signed (sresize i.rs1 64) (uresize i.rs1 64));
          rs2 $== (mux2 rs2_signed (sresize i.rs2 64) (uresize i.rs2 64));
          rd $==. 0;
          rdx $==. 0;
          counter $== (mux2 any_mulh 
            (consti 7 (63 - Options.mul_steps_at_once)) 
            (consti 7 (31 - Options.mul_steps_at_once)));
          waiting $== (~: start);
        ] [
          rd $== next_rd;
          rdx $== next_rdx;
          rs1 $== next_rs1;
          rs2 $== next_rs2;
          counter $== counter#q -:. Options.mul_steps_at_once;
          g_when counter#q.[6:6] [
            finish $== vdd;
            waiting $== vdd;
          ];
        ];
      ]
    in

    let wr = reg ~c:gnd ~e:vdd ~d:finish#q in
    let ready = reg ~c:gnd ~e:vdd ~d:finish#q in
    let rd = reg ~c:(zero 32) ~e:finish#q ~d:(mux2 any_mulh rd#q.[63:32] rd#q.[31:0]) in

    O.({
      wr;
      rd;
      wait_;
      ready;
    })

end

module Pcpi_if = struct

  module I = interface
    clk[1] resetn[1]
    (i : Pcpi.I)
    (o : Pcpi.O)
  end

  (*module O = Pcpi.O*)
  module O = struct
    include Pcpi.O
    let t = map (fun (n,b) -> ("pcpi_int_" ^ String.sub n 5 (String.length n - 5)), b) t
  end

  let f i = 
    let open I in
    let open Pcpi.O in
    let module Regs = Regs(struct let clk=i.clk let resetn=i.resetn end) in
    let open Regs in

    let z = Pcpi.O.(map (fun (_,b) -> zero b) t) in 
    let mul = if Options.enable_mul then Mul.f Mul.I.({clk=i.clk; resetn=i.resetn; i=i.i}) else z in

    let en_pcpi = cbool Options.enable_pcpi in
    let en_mul = cbool Options.enable_mul in

    let wait_ = (en_pcpi &: i.o.wait_) |: (en_mul &: mul.wait_) in
    let pcpi_ready, mul_ready = en_pcpi &: i.o.ready, en_mul &: mul.ready in
    let ready = pcpi_ready |: mul_ready in
    let wr = pmux [ pcpi_ready, i.o.wr; mul_ready, mul.wr ] gnd in
    let rd = pmux [ pcpi_ready, i.o.rd; mul_ready, mul.rd ] (zero 32) in

    O.({ wr; rd; wait_; ready })

end

module Rf = struct

  module I = interface
    clk[1] resetn[1]
    wr[1] wa[regindex_bits] d[32]
    ra1[regindex_bits] ra2[regindex_bits]
  end

  module O = interface
    q1[32] q2[32]
  end

  let f i = 
    let open I in
    let module Regs = Regs(struct let clk=i.clk let resetn=i.resetn end) in
    let open Regs in

    let wen = binary_to_onehot i.wa in
    let regs = 
      Array.to_list @@
      Array.init regfile_size (fun j -> reg ~c:(zero 32) ~e:(i.wr &: wen.[j:j]) ~d:i.d) 
    in
    O.({
      q1 = mux i.ra1 regs;
      q2 = mux i.ra2 regs;
    })

end

module Control = struct

  module I = interface
    clk[1] resetn[1]
    instr[Instr.n] is[Is.n]
    mem_rdata_word[32] mem_done[1]
    pcpi_int_ready[1] pcpi_int_wait[1]
    pcpi_int_wr[1] pcpi_int_rd[32]
    decoded_rd[regindex_bits] decoded_rs1[regindex_bits] decoded_rs2[regindex_bits]
    decoded_imm[32] decoded_imm_uj[32]
    irq[32]
  end

  module O = interface
    next_pc[32] reg_op1[32] reg_op2[32]
    trap[1]
    mem_do_rinst[1] mem_do_wdata[1] mem_do_rdata[1]
    mem_wordsize[2] mem_do_prefetch[1]
    pcpi_valid[1]
    decoder_trigger[1] decoder_trigger_q[1] decoder_pseudo_trigger[1]
    eoi[32]
    ascii_state[16*8]
  end

  type cpu_state = [ `fetch | `trap | `ld_rs1 | `ld_rs2 | `exec | `shift | `stmem | `ldmem ]
    deriving(Show)

  let bits_of_string s = 
    uresize
      (concat @@ Array.to_list @@
        Array.init (String.length s) (fun i -> consti 8 (Char.code s.[i])))
      (16*8)

  let f i = 
    let open I in
    let open O in
    let module Regs = Regs(struct let clk=i.clk let resetn=i.resetn end) in
    let open Regs in

    (*let enable_pcpi = cbool Options.enable_pcpi in
    let enable_mul = cbool Options.enable_mul in*)
    let enable_irq = cbool Options.enable_irq in
    let enable_irq_timer = cbool Options.enable_irq_timer in
    let enable_irq_qregs = cbool Options.enable_irq_qregs in
    let enable_counters = cbool Options.enable_counters in
    let enable_regs_dualport = cbool Options.enable_regs_dualport in
    
    let is_cpu, sm_cpu, next_cpu = 
      Signal.Statemachine.statemachine (r_spec (zero 3)) vdd 
        [ `fetch; `trap; `ld_rs1; `ld_rs2; `exec; `shift; `stmem; `ldmem ]
    in

    let regn n = g_reg ~c:(zero n) ~e:vdd ~n in
    let reg1 () = regn 1 in
    let reg5 () = regn 5 in
    let reg32 () = regn 32 in
    let reg64 () = regn 64 in

    let ro = O.(map (fun (_,b) -> regn b) t) in

    (* register file *)
    let latched_rd = g_reg ~c:(zero regindex_bits) ~e:vdd ~n:regindex_bits in
    let rf_wr, rf_d = Signal.Guarded.(g_wire gnd, g_wire (zero 32)) in
    let rfi = Rf.I.({
      clk = i.clk;
      resetn = i.resetn;
      wa = latched_rd#q;
      wr = rf_wr#q;
      d = rf_d#q;
      ra1 = i.decoded_rs1;
      ra2 = i.decoded_rs2;
    }) in
    let write_rf d = 
      Signal.Guarded.(g_proc [
        rf_wr $== vdd;
        rf_d $== d;
      ])
    in
    let rfo = Rf.f rfi in

    (* alu *)
    let alu = Alu.f Alu.I.({ reg_op1=ro.reg_op1#q; reg_op2=ro.reg_op2#q; 
                             instr=i.instr; is=i.is }) in

    (* statemachine *)
    let pcpi_timeout = reg1() in
    let pcpi_timeout_counter = regn 4 in
    let do_waitirq = reg1() in
    let count_cycle, count_instr = reg64(), reg64() in
    let latched_store, latched_stalu, latched_branch = reg1(), reg1(), reg1() in
    let latched_is_lu, latched_is_lh, latched_is_lb = reg1(), reg1(), reg1() in
    let reg_pc, reg_next_pc = 
      let mk() = g_reg ~c:Options.progaddr_reset ~e:vdd ~n:32 in
      mk(), mk()
    in
    let current_pc = Signal.Guarded.g_wire (zero 32) in
    let reg_out, reg_alu_out = reg32(), reg32() in
    let reg_sh = reg5() in

    let concat_array a = concat @@ List.rev @@ List.map (fun x -> x#q) @@ Array.to_list a in

    let irq_state = g_reg ~c:(zero 2) ~e:vdd ~n:2 in
    let irq_active = reg1 () in
    let irq_pending = reg32 () in
    let next_irq_pending = Array.init 32 (fun j -> Signal.Guarded.g_wire gnd) in
    let next_irq_pending_vec = concat_array next_irq_pending in
    let irq_mask = Array.init 32 (fun _ -> g_reg ~c:vdd ~e:vdd ~n:1) in
    let irq_mask_vec = concat_array irq_mask in

    let set_mem_do_rinst, set_mem_do_rdata, set_mem_do_wdata = 
      Signal.Guarded.(g_wire gnd, g_wire gnd, g_wire gnd)
    in

    let timer = reg32 () in

    let instr x = Instr.sel i.instr x in
    let is x = Is.sel i.is x in

    (* states *)
    let trap = `trap, Signal.Guarded.([ ro.trap $== vdd ]) in

    let fetch = `fetch, Signal.Guarded.([
      ro.mem_do_rinst $== ((~: (ro.decoder_trigger#q)) &: (~: (do_waitirq#q)));
      ro.mem_wordsize $==. 0;

      current_pc $== reg_next_pc#q;

      g_if latched_branch#q [
        current_pc $== mux2 latched_store#q 
          (mux2 latched_stalu#q reg_alu_out#q reg_out#q) 
          reg_next_pc#q;
        write_rf (reg_pc#q +:. 4);
      ] @@ g_elif latched_store#q [
        write_rf (mux2 latched_stalu#q reg_alu_out#q reg_out#q);
      ] @@ g_elif (enable_irq &: irq_state#q.[0:0]) [
        write_rf reg_next_pc#q; (* == current_pc at this point *)
        current_pc $== Options.progaddr_irq;
        irq_active $==. 1;
        ro.mem_do_rinst $==. 1;
      ] @@ g_elif (enable_irq &: irq_state#q.[1:1]) [
        ro.eoi $== (irq_pending#q &: (~: irq_mask_vec));
        write_rf (irq_pending#q &: (~: irq_mask_vec));
        irq_pending $== (next_irq_pending_vec &: irq_mask_vec); (* XXX CHANGED *)
      ] [];

      reg_pc $== current_pc#q;
      reg_next_pc $== current_pc#q;

      latched_store $==. 0;
      latched_stalu $==. 0;
      latched_branch $==. 0;
      latched_is_lu $==. 0;
      latched_is_lh $==. 0;
      latched_is_lb $==. 0;
      latched_rd $== i.decoded_rd;

      g_if (enable_irq &: 
            ((ro.decoder_trigger#q &: (~: (irq_active#q)) &: 
             reduce (|:) (bits (irq_pending#q &: (~: irq_mask_vec)))) |: 
             (reduce (|:) @@ bits irq_state#q))) [
          irq_state $==
            mux2 (irq_state#q ==:. 0b00) (consti 2 0b01) @@
            mux2 (irq_state#q ==:. 0b01) (consti 2 0b10) (consti 2 0b00);
          g_if (enable_irq_qregs) [
            latched_rd $== 
              ((consti regindex_bits irqregs_offset) |: 
               (uresize irq_state#q.[0:0] regindex_bits));
          ] [ 
            g_if irq_state#q.[0:0] [ latched_rd $==. 4 ] [ latched_rd $==. 3 ]
          ]
      ] @@ g_elif (enable_irq &: (ro.decoder_trigger#q |: do_waitirq#q) &: instr Instr.Waitirq) [
        g_if irq_pending#q [
          latched_store $==. 1;
          reg_out $== irq_pending#q;
          reg_next_pc $== current_pc#q +:. 4;
          ro.mem_do_rinst $==. 1;
        ] [
          do_waitirq $==. 1;
        ]
      ] @@ g_elif ro.decoder_trigger#q [
          reg_next_pc $== current_pc#q +:. 4;
          g_when (enable_counters) [ count_instr $== count_instr#q +:. 1; ];
          g_if (instr Instr.Jal) [
            ro.mem_do_rinst $==. 1;
            reg_next_pc $== current_pc#q +: i.decoded_imm_uj;
            latched_branch $==. 1;
          ] [
            ro.mem_do_rinst $==. 0;
            ro.mem_do_prefetch $== ((~: (instr Instr.Jalr)) &: (~: (instr Instr.Retirq)));
            next_cpu `ld_rs1;
          ]
      ] []
    ]) in

    let z_rs1 = mux2 (i.decoded_rs1 <>:. 0) rfo.Rf.O.q1 (zero 32) in
    let z_rs2 = mux2 (i.decoded_rs2 <>:. 0) rfo.Rf.O.q2 (zero 32) in

    let ld_rs1 = `ld_rs1, Signal.Guarded.([

      ro.reg_op1 $== zero 32;
      ro.reg_op2 $== zero 32;

      g_if (instr Instr.Trap) [
        g_if (cbool with_pcpi) [
          ro.reg_op1 $== z_rs1;
          g_if (enable_regs_dualport) [
            ro.pcpi_valid $==. 1;
            reg_sh $== uresize z_rs2 5;
            ro.reg_op2 $== z_rs2;
            g_if (i.pcpi_int_ready) [
              ro.mem_do_rinst $==. 1;
              ro.pcpi_valid $==. 0;
              reg_out $== i.pcpi_int_rd;
              latched_store $== i.pcpi_int_wr;
              next_cpu `fetch;
            ] @@ g_elif (pcpi_timeout#q) [
              g_if (enable_irq &: (~: (irq_mask.(irq_sbreak)#q)) &: (~: (irq_active#q))) [
                next_irq_pending.(irq_sbreak) $==. 1;
                next_cpu `fetch;
              ] [
                next_cpu `trap;
              ]
            ] []
          ] [
            next_cpu `ld_rs2;
          ]
        ] [
          g_if (enable_irq &: (~: (irq_mask.(irq_sbreak)#q)) &: (~: (irq_active#q))) [
            next_irq_pending.(irq_sbreak) $==. 1;
            next_cpu `fetch;
          ] [
            next_cpu `trap;
          ]
        ]
      ] @@ g_elif (is Is.Rdcycle_rdcycleh_rdinstr_rdinstrh) [
        reg_out $== (pmux1ht [
          instr Instr.Rdcycle, count_cycle#q.[31:0];
          instr Instr.Rdcycleh, count_cycle#q.[63:32];
          instr Instr.Rdinstr, count_instr#q.[31:0];
          instr Instr.Rdinstrh, count_instr#q.[63:32];
        ]);
        latched_store $==. 1;
        next_cpu `fetch;
      ] @@ g_elif (is Is.Lui_auipc_jal) [
        ro.reg_op1 $== mux2 (instr Instr.Lui) (zero 32) reg_pc#q;
        ro.reg_op2 $== i.decoded_imm;
        ro.mem_do_rinst $== ro.mem_do_prefetch#q;
        next_cpu `exec;
      ] @@ g_elif (enable_irq &: enable_irq_qregs &: instr Instr.Getq) [
        reg_out $== rfo.Rf.O.q1;
        latched_store $==. 1;
        next_cpu `fetch;
      ] @@ g_elif (enable_irq &: enable_irq_qregs &: instr Instr.Setq) [
        reg_out $== rfo.Rf.O.q1;
        latched_rd $== (latched_rd#q |: consti regindex_bits irqregs_offset);
        latched_store $==. 1;
        next_cpu `fetch;
      ] @@ g_elif (enable_irq &: instr Instr.Retirq) [
        ro.eoi $==. 0;
        irq_active $==. 0;
        latched_branch $==. 1;
        latched_store $==. 1;
        reg_out $== rfo.Rf.O.q1;
        next_cpu `fetch;
      ] @@ g_elif (enable_irq &: instr Instr.Maskirq) [
        latched_store $==. 1;
        reg_out $== irq_mask_vec;
        (*irq_mask $== (mux2 decoded_rs1 rfo.Rf.O.q1 (zero 32)) |: Options.masked_irq;*)
        (let irq_mask' = z_rs1 |: Options.masked_irq in
        g_proc @@ Array.to_list @@ Array.init 32 (fun i -> irq_mask.(i) $== irq_mask'.[i:i]));
        next_cpu `fetch;
      ] @@ g_elif (enable_irq &: enable_irq_timer &: instr Instr.Timer) [
        latched_store $==. 1;
        reg_out $== timer#q;
        timer $== z_rs1;
        next_cpu `fetch; 
      ] [
        ro.reg_op1 $== z_rs1;
        g_if (is Is.Lb_lh_lw_lbu_lhu) [
          next_cpu `ldmem;
          ro.mem_do_rinst $==. 1;
        ] @@ g_elif (is Is.Slli_srli_srai) [
          reg_sh $== uresize i.decoded_rs2 5;
          next_cpu `shift;
        ] @@ g_elif (is Is.Jalr_addi_slti_sltiu_xori_ori_andi) [
          ro.reg_op2 $== i.decoded_imm;
          ro.mem_do_rinst $== ro.mem_do_prefetch#q;
          next_cpu `exec;
        ] @@ g_elif (enable_regs_dualport) [
          reg_sh $== uresize z_rs2 5;
          ro.reg_op2 $== z_rs2;
          g_if (is Is.Sb_sh_sw) [
            next_cpu `stmem;
            ro.mem_do_rinst $==. 1;
          ] @@ g_elif (is Is.Sll_srl_sra) [
            next_cpu `shift;
          ] [
            ro.mem_do_rinst $== ro.mem_do_prefetch#q;
            next_cpu `exec;
          ]
        ] [
          next_cpu `ld_rs2;
        ]
      ]
      
    ]) in

    let ld_rs2 = `ld_rs2, Signal.Guarded.([
    
      reg_sh $== uresize z_rs2 5;
      ro.reg_op2 $== z_rs2;

      g_if (cbool with_pcpi &: instr Instr.Trap) [
        ro.pcpi_valid $==. 1;
        g_if (i.pcpi_int_ready) [
          ro.mem_do_rinst $==. 1;
          ro.pcpi_valid $==. 0;
          reg_out $== i.pcpi_int_rd;
          latched_store $== i.pcpi_int_wr;
          next_cpu `fetch;
        ] @@ g_elif (pcpi_timeout#q) [
          g_if (enable_irq &: (~: (irq_mask.(irq_sbreak)#q)) &: (~: (irq_active#q))) [
            next_irq_pending.(irq_sbreak) $==. 1;
            next_cpu `fetch;
          ] [
            next_cpu `trap;
          ]
        ] []
      ] @@ g_elif (is Is.Sb_sh_sw) [
        next_cpu `stmem;
        ro.mem_do_rinst $==. 1;
      ] @@ g_elif (is Is.Sll_srl_sra) [
        next_cpu `shift;
      ] [
        ro.mem_do_rinst $== ro.mem_do_prefetch#q;
        next_cpu `exec;
      ]

    ]) in

    let exec = `exec, Signal.Guarded.([
      latched_store $== alu.Alu.O.alu_out_0;
      latched_branch $== alu.Alu.O.alu_out_0;
      reg_out $== reg_pc#q +: i.decoded_imm;
      g_if (is Is.Beq_bne_blt_bge_bltu_bgeu) [
        latched_rd $==. 0;
        g_when (i.mem_done) [
          next_cpu `fetch;
        ];
        g_when (alu.Alu.O.alu_out_0) [
          ro.decoder_trigger $==. 0;
          set_mem_do_rinst $==. 1;
        ]
      ] [
        latched_branch $== instr Instr.Jalr;
        latched_store $==. 1;
        latched_stalu $==. 1;
        next_cpu `fetch;
      ]
    ]) in

    let shift = `shift, Signal.Guarded.([
      latched_store $==. 1;
      g_if (reg_sh#q ==:. 0) [
        reg_out $== ro.reg_op1#q;
        ro.mem_do_rinst $== ro.mem_do_prefetch#q;
        next_cpu `fetch;
      ] @@ g_elif (reg_sh#q >=:. 4) [
        ro.reg_op1 $== pmux1ht [
          instr Instr.Slli |: instr Instr.Sll, sll ro.reg_op1#q 4;
          instr Instr.Srli |: instr Instr.Srl, srl ro.reg_op1#q 4;
          instr Instr.Srai |: instr Instr.Sra, sra ro.reg_op1#q 4;
        ];
        reg_sh $== reg_sh#q -:. 4;
      ] [
        ro.reg_op1 $== pmux1ht [
          instr Instr.Slli |: instr Instr.Sll, sll ro.reg_op1#q 1;
          instr Instr.Srli |: instr Instr.Srl, srl ro.reg_op1#q 1;
          instr Instr.Srai |: instr Instr.Sra, sra ro.reg_op1#q 1;
        ];
        reg_sh $== reg_sh#q -:. 1;
      ]
    ]) in

    let stmem = `stmem, Signal.Guarded.([
      g_when ((~: (ro.mem_do_prefetch#q)) |: i.mem_done) [
        g_when (~: (ro.mem_do_wdata#q)) [
          ro.mem_wordsize $== pmux1ht [
            instr Instr.Sb, consti 2 2;
            instr Instr.Sh, consti 2 1;
            instr Instr.Sw, consti 2 0;
          ];
          ro.reg_op1 $== ro.reg_op1#q +: i.decoded_imm;
          set_mem_do_wdata $==. 1;
        ];
        g_when ((~: (ro.mem_do_prefetch#q)) &: i.mem_done) [
          next_cpu `fetch;
          ro.decoder_trigger $==. 1;
          ro.decoder_pseudo_trigger $==. 1;
        ]
      ]
    ]) in

    let ldmem = `ldmem, Signal.Guarded.([
      latched_store $==. 1;
      g_when ((~: (ro.mem_do_prefetch#q)) |: i.mem_done) [
        g_when (~: (ro.mem_do_rdata#q)) [
          ro.mem_wordsize $== pmux1ht [
            instr Instr.Lb |: instr Instr.Lbu, consti 2 2;
            instr Instr.Lh |: instr Instr.Lhu, consti 2 1;
            instr Instr.Lw,                    consti 2 0;
          ];
          latched_is_lu $== is Is.Lbu_lhu_lw;
          latched_is_lh $== instr Instr.Lh;
          latched_is_lb $== instr Instr.Lb;
          ro.reg_op1 $== ro.reg_op1#q +: i.decoded_imm;
          set_mem_do_rdata $==. 1;
        ];
        g_when ((~: (ro.mem_do_prefetch#q)) &: i.mem_done) [
          reg_out $== pmux1ht [
            latched_is_lu#q, i.mem_rdata_word;
            latched_is_lh#q, sresize (i.mem_rdata_word.[15:0]) 32;
            latched_is_lb#q, sresize (i.mem_rdata_word.[7:0]) 32;
          ];
          ro.decoder_trigger $==. 1;
          ro.decoder_pseudo_trigger $==. 1;
          next_cpu `fetch;
        ]
      ]
    ]) in

    let () = Signal.Guarded.(compile [
     
      ro.trap $==. 0;
      reg_sh $==. 0;
      reg_out $==. 0;
      reg_alu_out $== alu.Alu.O.alu_out;

      (* XXX this is quite different to the original implementation *)
      g_proc (Array.to_list @@ Array.init 32 (fun j -> 
        next_irq_pending.(j) $== 
          ((irq_pending#q.[j:j] &: Options.latched_irq.[j:j]) |: i.irq.[j:j])));
      irq_pending $== next_irq_pending_vec;

      g_proc (if with_pcpi then [
        g_if (ro.pcpi_valid#q &: (~: (i.pcpi_int_wait))) [
          g_when (pcpi_timeout_counter#q) [
            pcpi_timeout_counter $== pcpi_timeout_counter#q -:. 1;
          ]
        ] [
          pcpi_timeout_counter $==. (-1);
        ];
        pcpi_timeout $== (pcpi_timeout_counter#q ==:. 0);
      ] else [
        pcpi_timeout $==. 0;
        pcpi_timeout_counter $==. 0;
      ]);

      g_proc (if Options.enable_counters then [ count_cycle $== (count_cycle#q -- "count_cycle") +:. 1 ] 
                                         else [ count_cycle $==. 0 ]);

      g_when (enable_irq &: enable_irq_timer &: (timer#q <>:. 0)) [ 
        g_when ((timer#q -:. 1) ==:. 0) [
          next_irq_pending.(irq_timer) $==. 1;
        ];
        timer $== timer#q -:. 1;
      ];

      ro.decoder_trigger_q $== ro.decoder_trigger#q;
      ro.decoder_trigger $== (ro.mem_do_rinst#q &: i.mem_done);
      ro.decoder_pseudo_trigger $==. 0;
      do_waitirq $==. 0;

      sm_cpu [
        trap;
        fetch;
        ld_rs1;
        ld_rs2;
        exec;
        shift;
        stmem;
        ldmem;
      ];

      g_when i.mem_done [
        ro.mem_do_prefetch $==. 0;
        ro.mem_do_rinst $==. 0;
        ro.mem_do_rdata $==. 0;
        ro.mem_do_wdata $==. 0;
      ];

      g_when (set_mem_do_rinst#q) [ ro.mem_do_rinst $==. 1 ];
      g_when (set_mem_do_rdata#q) [ ro.mem_do_rdata $==. 1 ];
      g_when (set_mem_do_wdata#q) [ ro.mem_do_wdata $==. 1 ];
        
    ]) in

    O.({ map (fun s -> s#q) ro with 
          next_pc = mux2 (latched_store#q &: latched_branch#q) reg_out#q reg_next_pc#q;
          ascii_state = (pmux [
            is_cpu `trap  , bits_of_string "trap  ";
            is_cpu `fetch , bits_of_string "fetch ";
            is_cpu `ld_rs1, bits_of_string "ld_rs1";
            is_cpu `ld_rs2, bits_of_string "ld_rs2";
            is_cpu `exec  , bits_of_string "exec  ";
            is_cpu `shift , bits_of_string "shift ";
            is_cpu `stmem , bits_of_string "stmem ";
            is_cpu `ldmem , bits_of_string "ldmem ";
          ] (bits_of_string "none?")) -- "ascii_state";
      })

end

module Core = struct

  module I = interface
    clk[1] resetn[1]
    mem_ready[1] mem_rdata[32]
    pcpi_wr[1] pcpi_rd[32] pcpi_wait[1] pcpi_ready[1]
    irq[32]
  end

  module O = interface
    trap[1]
    mem_valid[1] mem_instr[1] mem_addr[32] mem_wdata[32] mem_wstrb[4]
    mem_la_read[1] mem_la_write[1] mem_la_addr[32] mem_la_wdata[32] mem_la_wstrb[4]
    pcpi_valid[1] pcpi_insn[32] pcpi_rs1[32] pcpi_rs2[32]
    eoi[32]
  end

  let f i = 

    let pif = Pcpi_if.O.(map (fun (n,b) -> wire b) t) in
    let dec = Decoder.O.(map (fun (n,b) -> wire b) t) in
    let mem = Memif.O.(map (fun (n,b) -> wire b) t) in
    let ctl = Control.O.(map (fun (n,b) -> wire b) t) in

    let pif' = Pcpi_if.f
      Pcpi_if.I.({
        clk=i.I.clk; resetn=i.I.resetn;
        i=Pcpi.I.({
          valid = ctl.Control.O.pcpi_valid;
          insn = dec.Decoder.O.pcpi_insn;
          rs1 = ctl.Control.O.reg_op1;
          rs2 = ctl.Control.O.reg_op2;
        });
        o=Pcpi.O.({
          wr = i.I.pcpi_wr;
          rd = i.I.pcpi_rd;
          wait_ = i.I.pcpi_wait;
          ready = i.I.pcpi_ready;
        });
      });
    in

    let dec' = Decoder.f
      Decoder.I.({
        clk=i.I.clk; resetn=i.I.resetn;
        mem_do_rinst = ctl.Control.O.mem_do_rinst;
        mem_done = mem.Memif.O.mem_done;
        mem_rdata_latched = mem.Memif.O.mem_rdata_latched; 
        mem_rdata_q = mem.Memif.O.mem_rdata_q;
        decoder_trigger = ctl.Control.O.decoder_trigger;
        decoder_pseudo_trigger = ctl.Control.O.decoder_pseudo_trigger;
      })
    in

    let mem' = Memif.f
      Memif.I.({
        clk=i.I.clk; resetn=i.I.resetn;
        reg_op1 = ctl.Control.O.reg_op1;
        reg_op2 = ctl.Control.O.reg_op2;
        next_pc = ctl.Control.O.next_pc;
        mem_ready = i.I.mem_ready;
        mem_do_rinst = ctl.Control.O.mem_do_rinst;
        mem_rdata = i.I.mem_rdata;
        mem_wordsize = ctl.Control.O.mem_wordsize;
        mem_do_prefetch = ctl.Control.O.mem_do_prefetch;
        mem_do_rdata = ctl.Control.O.mem_do_rdata;
        mem_do_wdata = ctl.Control.O.mem_do_wdata;
      })
    in

    let ctl' = Control.f
      Control.I.({
        clk=i.I.clk; resetn=i.I.resetn;
        instr = dec.Decoder.O.instr;
        is = dec.Decoder.O.is;
        mem_rdata_word = mem.Memif.O.mem_rdata_word;
        mem_done = mem.Memif.O.mem_done;
        pcpi_int_ready = pif.Pcpi_if.O.ready;
        pcpi_int_wait = pif.Pcpi_if.O.wait_;
        pcpi_int_wr = pif.Pcpi_if.O.wr;
        pcpi_int_rd = pif.Pcpi_if.O.rd;
        decoded_rd = dec.Decoder.O.decoded_rd;
        decoded_rs1 = dec.Decoder.O.decoded_rs1;
        decoded_rs2 = dec.Decoder.O.decoded_rs2;
        decoded_imm = dec.Decoder.O.decoded_imm;
        decoded_imm_uj = dec.Decoder.O.decoded_imm_uj;
        irq = i.I.irq;
      })
    in

    let _ = Pcpi_if.O.(map2 (fun a b -> a <== b) pif pif') in
    let _ = Decoder.O.(map2 (fun a b -> a <== b) dec dec') in
    let _ = Memif.O.(map2 (fun a b -> a <== b) mem mem') in
    let _ = Control.O.(map2 (fun a b -> a <== b) ctl ctl') in

    O.({
      trap = ctl.Control.O.trap;
      mem_valid = mem.Memif.O.mem_valid;
      mem_instr = mem.Memif.O.mem_instr;
      mem_addr = mem.Memif.O.mem_addr;
      mem_wdata = mem.Memif.O.mem_wdata;
      mem_wstrb = mem.Memif.O.mem_wstrb;
      mem_la_read = mem.Memif.O.mem_la_read;
      mem_la_write = mem.Memif.O.mem_la_write;
      mem_la_addr = mem.Memif.O.mem_la_addr;
      mem_la_wdata = mem.Memif.O.mem_la_wdata;
      mem_la_wstrb = mem.Memif.O.mem_la_wstrb;
      pcpi_valid = ctl.Control.O.pcpi_valid;
      pcpi_insn = dec.Decoder.O.pcpi_insn;
      pcpi_rs1 = ctl.Control.O.reg_op1;
      pcpi_rs2 = ctl.Control.O.reg_op2;
      eoi = ctl.Control.O.eoi;
    })

end
