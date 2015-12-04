module type S = sig

  include Config.S

  val num_regs : int
  val log_regs : int

  module Mi : interface
    rdata vld
  end
  module Mi_instr : module type of Mi
  module Mi_data : module type of Mi

  module I : interface
    clk clr
    (mi : Mi_instr)
    (md : Mi_data)
  end

  module Mo : interface
    addr wdata req rw wmask  
  end
  module Mo_instr : module type of Mo
  module Mo_data : module type of Mo

  module O : interface
    (mi : Mo_instr)
    (md : Mo_data)
  end

  module Class : interface
    trap
    lui auipc
    jal jalr
    bra
    ld st
    opi opr
    fen sys rdc rdco
    f3 f7
  end

  module Stage : interface
    pen 
    ra1 ra2 rad
    ra1_zero ra2_zero rad_zero
    rd1 rd2 rdd rdm imm
    pc 
    instr insn (iclass : Class)
    branch
    rwe
    (mi : Mo_instr)
    (md : Mo_data)
    junk
  end

  module Stages : interface
    (fet : Stage)
    (dec : Stage)
    (alu : Stage)
    (mem : Stage)
    (com : Stage)
  end
  
  module O_debug : interface
    (o : O)
    (dbg : Stages)
  end

  val zero_stage : unit -> HardCaml.Signal.Comb.t Stage.t

end

module Make(C : Config.S) : S

