module type S = sig

  include Config.S

  val num_regs : int
  val log_regs : int

  module I : interface
    clk clr
    mio_rdata mio_vld
  end

  module O : interface
    mio_addr mio_wdata mio_req mio_rw mio_wmask  
  end

  module Class : interface
    trap
    lui auipc
    jal jalr
    bra
    ld st
    opi opr
    fen sys
    f3 f7
  end

  module Stage : interface
    pen 
    ra1 ra2 rad
    ra1_zero ra2_zero rad_zero
    rd1 rd2 rdd rdm imm
    pc next_pc
    instr insn (iclass : Class)
    cond_branch
    junk
  end

  module O_debug : interface
    (o : O)
    (fet : Stage)
    (dec : Stage)
    (alu : Stage)
    (mem : Stage)
    (com : Stage)
  end

end

module Make(C : Config.S) : S

