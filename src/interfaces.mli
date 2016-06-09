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
    junk
  end

  module Class : interface
    trap
    lui auipc
    jal jalr
    bra
    ld st
    opi opr
    fen sys csr 
    f3 f7
  end
  module Class_ex : module type of Interface_ex.Make(Class) 

  module Csr_ctrl : interface
    csr_use_imm csr_imm 
    csr_we_n csr_re_n csr_invalid_we
    csr_dec
    csr_clr csr_set csr_write
  end

  module Stage : interface
    insn pc instr 
    ra1 ra2 rad
    rd1 rd2 rdd 
    imm is_imm 
    branch rwe
    ra1_zero ra2_zero rad_zero
    (iclass : Class)
    (csr : Csr_ctrl)
    junk
  end
  module Stage_ex : module type of Interface_ex.Make(Stage) 

  module Stages : interface
    (fet : Stage)
    (dec : Stage)
    (alu : Stage)
    (mem : Stage)
    (com : Stage)
  end
  module Stages_ex : module type of Interface_ex.Make(Stages) 
  
  module Ctrl : interface
    en bubble
  end

  module O_debug : interface
    (o : O)
    (dbg : Stages)
  end

end

module Make(C : Config.S) : S

