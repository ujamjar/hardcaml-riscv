module I : interface
  clk_clk reset_reset_n
  (slave : Avalon.Slave)
end

module O : module type of Avalon.Master 
           with type 'a t = 'a Avalon.Master.t
