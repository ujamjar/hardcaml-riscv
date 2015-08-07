open HardCaml
open Signal.Comb

let irqregs_offset = Picorv32.irqregs_offset
let regfile_size = Picorv32.regfile_size
let regindex_bits = Picorv32.regindex_bits

module Decoder = struct
  include Picorv32.Decoder
  module I' = interface
    (i : I) decoder_trigger_q[1]
  end
  module O' = interface
    instr_lui[1] instr_auipc[1] instr_jal[1] instr_jalr[1]
    instr_beq[1] instr_bne[1] instr_blt[1] instr_bge[1] instr_bltu[1] instr_bgeu[1]
    instr_lb[1] instr_lh[1] instr_lw[1] instr_lbu[1] instr_lhu[1] 
    instr_sb[1] instr_sh[1] instr_sw[1]
    instr_addi[1] instr_slti[1] instr_sltiu[1] instr_xori[1] 
    instr_ori[1] instr_andi[1] instr_slli[1] 
    instr_srli[1] instr_srai[1] instr_add[1] 
    instr_sub[1] instr_sll[1] instr_slt[1] instr_sltu[1] 
    instr_xor[1] instr_srl[1] instr_sra[1] instr_or[1] 
    instr_and[1] instr_rdcycle[1] instr_rdcycleh[1] 
    instr_rdinstr[1] instr_rdinstrh[1] instr_getq[1] 
    instr_setq[1] instr_retirq[1] instr_maskirq[1] 
    instr_waitirq[1] instr_timer[1] instr_trap[1]

    is_lui_auipc_jal[1] is_lb_lh_lw_lbu_lhu[1] is_slli_srli_srai[1]
    is_jalr_addi_slti_sltiu_xori_ori_andi[1] is_sb_sh_sw[1] is_sll_srl_sra[1]
    is_lui_auipc_jal_jalr_addi_add[1] is_slti_blt_slt[1] is_sltiu_bltu_sltu[1]
    is_beq_bne_blt_bge_bltu_bgeu[1] is_lbu_lhu_lw[1] is_alu_reg_imm[1]
    is_alu_reg_reg[1] is_compare[1]
    is_rdcycle_rdcycleh_rdinstr_rdinstrh[1]

    pcpi_insn[32] 
    decoded_rd[regindex_bits] decoded_rs1[regindex_bits] decoded_rs2[regindex_bits]
    decoded_imm[32] decoded_imm_uj[32]
  end

  let convo o = 
    let open Picorv32 in
    let instr_a = List.map (fun x -> Instr.cname x, Instr.sel o.O.instr x) Instr.list in
    let is_a = List.map (fun x -> Is.cname x, Is.sel o.O.is x) Is.list in
    let other_a = O.(to_list @@ map2 (fun (n,_) s -> n,s) t o) in
    O'.(map (fun (n,b) ->
      try List.assoc n instr_a with _ ->
      try List.assoc n is_a with _ ->
      List.assoc n other_a) t)

  let convi i' = i'.I'.i

  let generics = 
    [
      "ENABLE_COUNTERS", Signal.Types.ParamInt(1);
      "ENABLE_REGS_16_31", Signal.Types.ParamInt(1);
      "ENABLE_PCPI", Signal.Types.ParamInt(0);
      "ENABLE_MUL", Signal.Types.ParamInt(1);
      "ENABLE_IRQ", Signal.Types.ParamInt(1);
      "ENABLE_IRQ_QREGS", Signal.Types.ParamInt(1);
      "ENABLE_IRQ_TIMER", Signal.Types.ParamInt(1);
      "irqregs_offset", Signal.Types.ParamInt(irqregs_offset);
      "regindex_bits", Signal.Types.ParamInt(regindex_bits);
    ]
end

module Alu = struct
  include Picorv32.Alu
  module I' = interface
    reg_op1[32] reg_op2[32]
    instr_beq[1] instr_bne[1] instr_bge[1] instr_bgeu[1]
    instr_sub[1] instr_xori[1] instr_xor[1] instr_ori[1]
    instr_or[1] instr_andi[1] instr_and[1] is_compare[1]
    is_slti_blt_slt[1] is_sltiu_bltu_sltu[1]
    is_lui_auipc_jal_jalr_addi_add[1]
  end
  module O' = O

  let generics = []

  let convi i' = 
    let open Picorv32 in
    let i'a = I'.(to_list @@ map2 (fun (n,b) s -> n,s) t i') in
    let instr = concat @@ List.rev @@ Array.to_list @@ Array.init Instr.n 
      (fun i -> try List.assoc Instr.(cname (Enum_t.to_enum i)) i'a with _ -> gnd) 
    in
    let is = concat @@ List.rev @@ Array.to_list @@ Array.init Is.n 
      (fun i -> try List.assoc Is.(cname (Enum_t.to_enum i)) i'a with _ -> gnd) 
    in
    I.({ instr; is; reg_op1 = i'.I'.reg_op1; reg_op2 = i'.I'.reg_op2 })

  let convo o = o
end

module Memif = struct
  include Picorv32.Memif
  module I' = I
  module O' = O
  let generics = []
  let convi i = i
  let convo o = o
end

module Mul = struct
  include Picorv32.Mul
  module I' = I
  module O' = O
  let generics = []
  let convi i = i
  let convo o = o
end

module Pcpi_if = struct
  include Picorv32.Pcpi_if
  module I' = I
  module O' = O

  let generics = [
    "ENABLE_PCPI", Signal.Types.ParamInt(0); 
    "ENABLE_MUL", Signal.Types.ParamInt(1);
  ]
  let convi i = i
  let convo o = o
end

module Rf = struct
  include Picorv32.Rf
  module I' = I
  module O' = O

  let generics = []
  let convi i = i
  let convo o = o
end

module Control = struct
  include Picorv32.Control
  module I' = interface
    instr_lui[1] instr_auipc[1] instr_jal[1] instr_jalr[1]
    instr_beq[1] instr_bne[1] instr_blt[1] instr_bge[1] instr_bltu[1] instr_bgeu[1]
    instr_lb[1] instr_lh[1] instr_lw[1] instr_lbu[1] instr_lhu[1] 
    instr_sb[1] instr_sh[1] instr_sw[1]
    instr_addi[1] instr_slti[1] instr_sltiu[1] instr_xori[1] 
    instr_ori[1] instr_andi[1] instr_slli[1] 
    instr_srli[1] instr_srai[1] instr_add[1] 
    instr_sub[1] instr_sll[1] instr_slt[1] instr_sltu[1] 
    instr_xor[1] instr_srl[1] instr_sra[1] instr_or[1] 
    instr_and[1] instr_rdcycle[1] instr_rdcycleh[1] 
    instr_rdinstr[1] instr_rdinstrh[1] instr_getq[1] 
    instr_setq[1] instr_retirq[1] instr_maskirq[1] 
    instr_waitirq[1] instr_timer[1] instr_trap[1]
    is_lui_auipc_jal[1] is_lb_lh_lw_lbu_lhu[1] is_slli_srli_srai[1]
    is_jalr_addi_slti_sltiu_xori_ori_andi[1] is_sb_sh_sw[1] is_sll_srl_sra[1]
    is_lui_auipc_jal_jalr_addi_add[1] is_slti_blt_slt[1] is_sltiu_bltu_sltu[1]
    is_beq_bne_blt_bge_bltu_bgeu[1] is_lbu_lhu_lw[1] is_alu_reg_imm[1]
    is_alu_reg_reg[1] is_compare[1]
    is_rdcycle_rdcycleh_rdinstr_rdinstrh[1]
    clk[1] resetn[1]
    mem_rdata_word[32] mem_done[1]
    pcpi_int_ready[1] pcpi_int_wait[1]
    pcpi_int_wr[1] pcpi_int_rd[32]
    decoded_rd[regindex_bits] decoded_rs1[regindex_bits] decoded_rs2[regindex_bits]
    decoded_imm[32] decoded_imm_uj[32]
    irq[32]
  end
  module O' = O
  let generics = [
    "ENABLE_COUNTERS", Signal.Types.ParamInt(1);
    "ENABLE_REGS_16_31", Signal.Types.ParamInt(1);
    "ENABLE_REGS_DUALPORT", Signal.Types.ParamInt(1);
    "LATCHED_MEM_RDATA", Signal.Types.ParamInt(0);
    "ENABLE_PCPI", Signal.Types.ParamInt(0);
    "ENABLE_MUL", Signal.Types.ParamInt(1);
    "ENABLE_IRQ", Signal.Types.ParamInt(1);
    "ENABLE_IRQ_QREGS", Signal.Types.ParamInt(1);
    "ENABLE_IRQ_TIMER", Signal.Types.ParamInt(1);
    "MASKED_IRQ", Signal.Types.ParamInt(0);
    "LATCHED_IRQ", Signal.Types.ParamInt(-1);
    "PROGADDR_RESET", Signal.Types.ParamInt(0);
    "PROGADDR_IRQ", Signal.Types.ParamInt(16);
    "irqregs_offset", Signal.Types.ParamInt(irqregs_offset);
    "regfile_size", Signal.Types.ParamInt(regfile_size);
    "regindex_bits", Signal.Types.ParamInt(regindex_bits);
  ]
  let convi i' = 
    let open Picorv32 in
    let i'a = I'.(to_list @@ map2 (fun (n,b) s -> n,s) t i') in
    let instr = concat @@ List.rev @@ Array.to_list @@ Array.init Instr.n 
      (fun i -> try List.assoc Instr.(cname (Enum_t.to_enum i)) i'a with _ -> gnd) 
    in
    let is = concat @@ List.rev @@ Array.to_list @@ Array.init Is.n 
      (fun i -> try List.assoc Is.(cname (Enum_t.to_enum i)) i'a with _ -> gnd) 
    in
    I.({ 
      instr; is; 
      clk = i'.I'.clk;
      resetn = i'.I'.resetn;
      mem_rdata_word = i'.I'.mem_rdata_word;
      mem_done = i'.I'.mem_done;
      pcpi_int_ready = i'.I'.pcpi_int_ready;
      pcpi_int_wait = i'.I'.pcpi_int_wait;
      pcpi_int_wr = i'.I'.pcpi_int_wr;
      pcpi_int_rd = i'.I'.pcpi_int_rd;
      decoded_rd = i'.I'.decoded_rd;
      decoded_rs1 = i'.I'.decoded_rs1;
      decoded_rs2 = i'.I'.decoded_rs2;
      decoded_imm = i'.I'.decoded_imm;
      decoded_imm_uj = i'.I'.decoded_imm_uj;
      irq = i'.I'.irq;
    })

  let convo o = o
end

module Core = struct
  include Picorv32.Core
  module I' = I
  module O' = O
  let generics = []
  let convi i = i
  let convo o = o
end

module Test = struct

  module Gen(X : sig
    module I : Interface.S
    module O : Interface.S
    module I' : Interface.S
    module O' : Interface.S
    val f : Signal.Comb.t I.t -> Signal.Comb.t O.t
    val generics : (string * Signal.Types.parameter) list
    val convi : t I'.t -> t I.t
    val convo : t O.t -> t O'.t
  end) = struct

    module Y = Interface.Circ(X.I)(X.O)
    module Y' = Interface.Circ(X.I')(X.O')

    let wrap name i = 
      let o = Signal.Instantiation.inst ("picorv32_" ^ name)  
        X.generics
        X.I'.(to_list @@ map2 (fun (n,b) s -> n,s) t i)
        X.O'.(to_list t)
      in
      let module Z = Interface.Inst(X.I)(X.O) in
      let x = X.convo @@ Z.make ("opicorv32_" ^ name) (X.convi i) in
      let compare x y = 
        let y' = o#o y in
        let c = (x ^: y') -- ("compare_" ^ y) in
        let which = false in (* true: verilog, false: hardcaml *)
        if which then c ^: x else c ^: y'
      in
      X.O'.(map2 (fun (n,b) c -> compare c n) t x)

    let write name' = 
      let name = "opicorv32_" ^ name' in
      let f = open_out (name ^ ".v") in
      let circ = Y.make name X.f in
      Rtl.Verilog.write (output_string f) circ;
      close_out f;

      let name = "opicorv32_" ^ name' ^ "_wrap" in
      let f = open_out (name ^ ".v") in
      let circ = Y'.make name (wrap name') in
      Rtl.Verilog.write (output_string f) circ;
      close_out f;

      ()

  end

  module Decoder = Gen(Decoder)
  module Alu = Gen(Alu)
  module Memif = Gen(Memif)
  module Mul = Gen(Mul)
  module Pcpi_if = Gen(Pcpi_if)
  module Rf = Gen(Rf)
  module Control = Gen(Control)
  module Core = Gen(Core)

  let write_vlog() = 
    Decoder.write "instruction_decoder";
    Alu.write "alu";
    Memif.write "memif";
    Mul.write "mul";
    Rf.write "rf";
    Pcpi_if.write "pcpi_if";
    Control.write "control";
    Core.write "rv32"

  (* defines *)

  let instr_defines () = 
    List.iter (fun x ->
      Printf.printf "`define %s %i\n" 
        (Show.show<Picorv32.Instr.t> x)
        (Enum.from_enum<Picorv32.Instr.t> x)) Picorv32.Instr.list

  let is_defines () = 
    List.iter (fun x ->
      Printf.printf "`define %s %i\n" 
        (Show.show<Picorv32.Is.t> x)
        (Enum.from_enum<Picorv32.Is.t> x)) Picorv32.Is.list

  (* Instr and Is Modules to/from bit vectors *)

  module Vec(X : sig
    type t 
    val name : string
    val n : int
    module Enum_t : sig val to_enum : int -> t end
    module Show_t : sig val show : t -> string end
  end) = struct

    let vec_of_t () = 
      let l = Array.init X.n 
        (fun idx -> 
          let e = X.Enum_t.to_enum idx in
          let n = X.name ^ "_" ^ String.lowercase (X.Show_t.show e) in
          input n 1)
      in
      let o = output "q" (concat @@ List.rev @@ Array.to_list l) in
      let circ = Circuit.make ("vec_of_" ^ X.name) [o] in
      circ

    let t_of_vec () = 
      let i = input "d" X.n in
      let o = Array.init X.n 
        (fun j -> 
          let e = X.Enum_t.to_enum j in
          output 
            (X.name ^ "_" ^ String.lowercase (X.Show_t.show e)) 
            (bit i j)) 
      in
      let circ = Circuit.make (X.name ^ "_of_vec") (Array.to_list o) in
      circ

  end

  module Instr_vec = Vec(Picorv32.Instr)
  module Is_vec = Vec(Picorv32.Is)

end

let () = Test.write_vlog();;

