open HardCaml
open Signal.Comb
open Signal.Seq

open HardCamlAltera

let clock_50 = input "CLOCK_50" 1

(* instantiate the pll *)
let pllo = Pll.(pll50_inst I.{ inclk0=clock_50 })
let reg = reg { r_none with Signal.Types.reg_clock=pllo.Pll.O.c0 }

(* instantiate the vjtag_mm bridge *)
let vji = Vjtag_mm.I.(map (fun (n,b) -> wire b) t)
let vjo = Vjtag_mm.vjtag_mm_inst vji

(* create register bank *)
let regs = 
  let open Vjtag_mm.O in
  let addr = Array.init 4 (fun i -> vjo.vjtag_mm_address ==:. (i*4)) in
  let en i j = vjo.vjtag_mm_write &: addr.(i) &: vjo.vjtag_mm_byteenable.[j:j] in
  let regb i j = reg (en i j) vjo.vjtag_mm_writedata.[j*8+7:j*8] in
  let cat r = concat @@ List.rev @@ Array.to_list r in
  Array.init 4 (fun i -> cat @@ Array.init 4 (fun j -> regb i j)) 

(* wiring *)
let () = begin
  let open Vjtag_mm.I in
  let open Vjtag_mm.O in
  let open Pll.O in
  vji.clk_clk <== pllo.c0;
  vji.reset_reset_n <== pllo.locked;
  vji.vjtag_mm_waitrequest <== gnd;
  vji.vjtag_mm_readdatavalid <== vdd;
  vji.vjtag_mm_readdata <== mux vjo.vjtag_mm_address.[31:2] 
    (Array.to_list regs @ [consthu 32 "deadbeef"]);
end

(* LED *)
let led = output "LED" regs.(3).[7:0]

(* write circuit *)
let circ = Circuit.make "de0nano_test" [ led ]
let () = 
  let f = open_out "de0nano_test.v" in
  Rtl.Verilog.write (output_string f) circ;
  close_out f


