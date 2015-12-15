module I = interface
  clk_clk[1] reset_reset_n[1]
  vjtag_mm_readdata[32] vjtag_mm_waitrequest[1] 
  vjtag_mm_readdatavalid[1]
end

module O = interface
  vjtag_mm_address[32] vjtag_mm_read[1] vjtag_mm_write[1]
  vjtag_mm_writedata[32] vjtag_mm_byteenable[4]
end

let vjtag_mm_inst i = 
  let module Vjtag = HardCaml.Interface.Inst(I)(O) in
  Vjtag.make "vjtag_mm" i

