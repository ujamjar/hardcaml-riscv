module O : interface
    addr ba cas_n 
    cke cs_n
    dqm ras_n we_n
end

module T : interface dq end

module Core : sig
  module I : interface 
    clk_clk reset_reset_n 
    mm_burstcount mm_debugaccess
    (mm : Avalon.Master) 
  end
  module O : interface (mm : Avalon.Slave) (sdram : O) end
  module T : HardCaml.Interface.S with type 'a t = 'a T.t
end

