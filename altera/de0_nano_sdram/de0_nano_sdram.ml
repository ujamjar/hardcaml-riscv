open HardCaml
open Signal.Comb
open Signal.Seq

open HardCamlAltera

let f i = 
  let open De0_nano.Sdram_mm.I in

  let r_reg = { r_none with Signal.Types.reg_clock = i.clk; reg_reset = ~: (i.rst) } in
  let cnt = reg_fb r_reg (i.vjtag_master.Avalon.Master.read |: i.vjtag_master.Avalon.Master.write) 8 (fun d -> d +:. 1) in
  
  {
    De0_nano.Sdram_mm.O.leds = cnt;
    vjtag_slave = i.sdram_slave;
    sdram_master = i.vjtag_master;
  }

let () = 
  let file = open_out "de0_nano_sdram.v" in
  De0_nano.generate_sdram_vjtag_mm (output_string file) "de0_nano_sdram" "loopback" f;
  close_out file


