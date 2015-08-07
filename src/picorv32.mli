open HardCaml

module Options : sig
  val enable_counters : bool
  val enable_regs_16_31 : bool
  val enable_regs_dualport : bool
  val latched_mem_rdata : bool
  val enable_pcpi : bool
  val enable_mul : bool
  val enable_irq : bool
  val enable_irq_qregs : bool
  val enable_irq_timer : bool
  val masked_irq : Signal.Comb.t
  val latched_irq : Signal.Comb.t
  val progaddr_reset : Signal.Comb.t
  val progaddr_irq : Signal.Comb.t
  val mul_steps_at_once : int
end

module Instr : sig
  type t = 
    | Lui | Auipc | Jal | Jalr | Beq | Bne | Blt | Bge | Bltu | Bgeu | Lb
    | Lh | Lw | Lbu | Lhu | Sb | Sh | Sw | Addi | Slti | Sltiu | Xori | Ori
    | Andi | Slli | Srli | Srai | Add | Sub | Sll | Slt | Sltu | Xor | Srl
    | Sra | Or | And | Rdcycle | Rdcycleh | Rdinstr | Rdinstrh | Getq | Setq
    | Retirq | Maskirq | Waitirq | Timer | Trap
    deriving(Enum,Bounded,Show)
  val name : string
  val n : int
  val sel : Signal.Comb.t -> t -> Signal.Comb.t
  val cname : t -> string
  val list : t list
end

module Is : sig
  type t = 
    | Lui_auipc_jal | Lb_lh_lw_lbu_lhu | Slli_srli_srai | Jalr_addi_slti_sltiu_xori_ori_andi
    | Sb_sh_sw | Sll_srl_sra | Lui_auipc_jal_jalr_addi_add | Slti_blt_slt
    | Sltiu_bltu_sltu | Beq_bne_blt_bge_bltu_bgeu | Lbu_lhu_lw | Alu_reg_imm
    | Alu_reg_reg | Compare | Rdcycle_rdcycleh_rdinstr_rdinstrh
    deriving(Enum,Bounded,Show)
  val name : string
  val n : int
  val sel : Signal.Comb.t -> t -> Signal.Comb.t
  val cname : t -> string
  val list : t list
end

val irqregs_offset : int
val regfile_size : int
val regindex_bits : int

module Decoder : sig
  module I : interface
    clk resetn
    mem_do_rinst mem_done 
    mem_rdata_latched mem_rdata_q
    decoder_trigger (*decoder_trigger_q*) decoder_pseudo_trigger
  end

  module O : interface
    instr is
    pcpi_insn
    decoded_rd decoded_rs1 decoded_rs2
    decoded_imm decoded_imm_uj
  end

  val f : Signal.Comb.t I.t -> Signal.Comb.t O.t
end

module Alu : sig
  module I : interface
    reg_op1 reg_op2
    instr is
  end

  module O : interface
    alu_out
    alu_out_0
  end

  val f : Signal.Comb.t I.t -> Signal.Comb.t O.t
end

module Memif : sig
  module I : interface
    clk resetn
    reg_op1 reg_op2 next_pc
    mem_ready mem_do_rinst mem_rdata
    mem_wordsize mem_do_prefetch mem_do_rdata mem_do_wdata
  end

  module O : interface
    mem_done mem_valid mem_instr mem_addr mem_wdata
    mem_wstrb mem_rdata_latched mem_rdata_q mem_rdata_word
    mem_la_read mem_la_write mem_la_addr mem_la_wdata mem_la_wstrb
  end

  val f : Signal.Comb.t I.t -> Signal.Comb.t O.t
end

module Pcpi : sig
  module I_ : interface
    valid insn rs1 rs2
  end
  module I : module type of I_
  module O_ : interface
    wr rd wait_ ready
  end
  module O : module type of O_
end

module Mul : sig
  module I : interface
    clk resetn
    (i : Pcpi.I)
  end

  module O : module type of Pcpi.O

  val f : Signal.Comb.t I.t -> Signal.Comb.t O.t
end

module Pcpi_if : sig
  module I : interface
    clk resetn
    (i : Pcpi.I)
    (o : Pcpi.O)
  end

  module O : module type of Pcpi.O

  val f : Signal.Comb.t I.t -> Signal.Comb.t O.t
end

module Rf : sig
  module I : interface
    clk resetn
    wr wa d
    ra1 ra2
  end

  module O : interface
    q1 q2
  end

  val f : Signal.Comb.t I.t -> Signal.Comb.t O.t
end

module Control : sig
  module I : interface
    clk resetn
    instr is
    mem_rdata_word mem_done
    pcpi_int_ready pcpi_int_wait
    pcpi_int_wr pcpi_int_rd
    decoded_rd decoded_rs1 decoded_rs2
    decoded_imm decoded_imm_uj
    irq
  end

  module O : interface
    next_pc reg_op1 reg_op2
    trap
    mem_do_rinst mem_do_wdata mem_do_rdata
    mem_wordsize mem_do_prefetch
    pcpi_valid
    decoder_trigger decoder_trigger_q decoder_pseudo_trigger
    eoi
    ascii_state
  end

  val f : Signal.Comb.t I.t -> Signal.Comb.t O.t
end

module Core : sig

  module I : interface
    clk resetn
    mem_ready mem_rdata
    pcpi_wr pcpi_rd pcpi_wait pcpi_ready
    irq
  end

  module O : interface
    trap
    mem_valid mem_instr mem_addr mem_wdata mem_wstrb
    mem_la_read mem_la_write mem_la_addr mem_la_wdata mem_la_wstrb
    pcpi_valid pcpi_insn pcpi_rs1 pcpi_rs2
    eoi
  end

  val f : Signal.Comb.t I.t -> Signal.Comb.t O.t
end

