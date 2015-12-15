module I : interface
  clk_clk reset_reset_n
  vjtag_mm_readdata vjtag_mm_waitrequest 
  vjtag_mm_readdatavalid
end

module O : interface
  vjtag_mm_address vjtag_mm_read vjtag_mm_write
  vjtag_mm_writedata vjtag_mm_byteenable
end

val vjtag_mm_inst : HardCaml.Signal.Comb.t I.t -> HardCaml.Signal.Comb.t O.t

