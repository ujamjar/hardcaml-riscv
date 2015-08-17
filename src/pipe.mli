open HardCaml.Signal

module type Config = sig
  (* 32 or 64 bit *)
  val xlen : int 
  (* processor start address *)
  val start_addr : int
end

module Insn : sig
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
  val name : string
end
module Insn_v : Utils.BVec_S with type t = Insn.t

module Is : sig
  type t = 
    | Lui_auipc_jal | Lb_lh_lw_lbu_lhu | Slli_srli_srai | Jalr_addi_slti_sltiu_xori_ori_andi
    | Sb_sh_sw | Sll_srl_sra | Lui_auipc_jal_jalr_addi_add | Slti_blt_slt
    | Sltiu_bltu_sltu | Beq_bne_blt_bge_bltu_bgeu | Lbu_lhu_lw | Alu_reg_imm
    | Alu_reg_reg | Compare | Rdcycle_rdcycleh_rdinstr_rdinstrh
    deriving(Enum,Bounded,Show)
  val name : string
end
module Is_v : Utils.BVec_S with type t = Is.t

module Make(C : Config) : sig

  val num_regs : int
  val log_regs : int

  module I : interface
    clk clr
    mio_rdata mio_vld
  end

  module O : interface
    mio_addr mio_wdata mio_req mio_rw mio_wmask  
  end

  module Pipe : interface
    pen 
    ra1 ra2 rad
    ra1_zero ra2_zero rad_zero
    rd1 rd2 rdd
    imm
    pc next_pc
    instr insn is fclass
    alu alu_cmp
    junk
  end

  val wired_stage : 'a -> Comb.t Pipe.t

  type stage = Comb.t Pipe.t
  type stages = stage array
  type f_stage = n:int -> inp:Comb.t I.t -> comb:stages -> pipe:stages -> stage
  type 'a f_output = stages -> 'a

  module type M_stage = sig
    val name : string
    val f : f_stage
  end

  val build_pipeline : f_stages:(module M_stage) array -> f_output:'a f_output -> 
    Comb.t I.t -> 'a

  module type Stage = sig
    val name : string
    val f : f_stage
  end

  module Fetch : Stage
  module Decoder : Stage
  module Decoder2 : sig
    module Make(B : HardCaml.Comb.S) : sig
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
      val decoder : B.t -> t 
    end
    include Stage
  end
  module Alu : Stage
  module Mem : Stage
  module Commit : Stage

end

module Test : sig
  module Cfg : Config 
  module Rv : module type of Make(Cfg)
  val write_pipe_stage : string -> int -> (module Rv.Stage) -> unit
  val write_core : unit -> unit
  val testbench : unit -> unit
end

