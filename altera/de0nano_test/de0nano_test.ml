open HardCaml
open Signal.Comb
open Signal.Seq

open HardCamlAltera

let f i = 
  let open De0_nano.Simple.I in
  let reg = reg { r_none with 
    Signal.Types.reg_clock = i.clk;
    reg_clear = ~: (i.rst);
  } in

  (* register bank *)
  let s = i.master in
  let open Avalon.Master in
  let addr = Array.init 4 (fun i -> s.address ==:. (i*4)) in
  let en i j = s.write &: addr.(i) &: s.byteenable.[j:j] in
  let regb i j = reg (en i j) s.writedata.[j*8+7:j*8] in
  let cat r = concat @@ List.rev @@ Array.to_list r in
  let regs = Array.init 4 (fun i -> cat @@ Array.init 4 (fun j -> regb i j)) in

  let xxx = consthu 32 "deadbeef" in

  De0_nano.Simple.O.{
    leds = regs.(3).[7:0];
    slave = {
      Avalon.Slave.waitrequest = gnd;
      readdatavalid = vdd;
      readdata = mux2 s.read (mux s.address.[31:2] (Array.to_list regs @ [xxx])) xxx;
    };
  }

let () = 
  let file = open_out "de0nano_test.v" in
  De0_nano.generate_simple_vjtag_mm (output_string file) "de0nano_test" "reg_bank" f;
  close_out file


