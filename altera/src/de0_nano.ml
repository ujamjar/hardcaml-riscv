(* DE0-Nano top level *)

module Epcs = struct
  module I = interface EPCS_DATA0[1] end
  module O = interface EPCS_ASDO[1] EPCS_DCLK[1] EPCS_NCSO[1] end
end

module Acc_ee = struct
  module I = interface G_SENSOR_INT[1] end
  module O = interface G_SENSOR_CS_N[1] I2C_SCLK[1] end
  module T = interface I2C_SDAT[1] end
end

module Adc = struct
  module I = interface ADC_SDAT[1] end
  module O = interface ADC_CS_N[1] ADC_SADDR[1] ADC_SCLK[1] end
end

module Gpio2x13 = struct
  module I = interface GPIO_2_IN[3] end
  module T = interface GPIO_2[13] end
end

module Gpio0 = struct
  module I = interface GPIO_0_IN[2] end
  module T = interface GPIO_0[34] end
end

module Gpio1 = struct
  module I = interface GPIO_1_IN[2] end
  module T = interface GPIO_1[34] end
end

module Top = struct

  module I = interface
    CLOCK_50[1]
    KEY[2]
    SW[4]
    (epcs : Epcs.I)
    (acc_ee : Acc_ee.I)
    (adc : Adc.I)
    (gpio2x13 : Gpio2x13.I)
    (gpio0 : Gpio0.I)
    (gpio1 : Gpio1.I)
  end

  module P = struct let f s = "DRAM_" ^ String.uppercase s end
  module Sdram_o = Util.Name_map(P)(Sdram.O)
  module Sdram_t = Util.Name_map(P)(Sdram.T)

  module O = interface
    LED[8]
    DRAM_CLK[1]
    (sdram : Sdram_o)
    (epcs : Epcs.O)
    (acc_ee : Acc_ee.O)
    (adc : Adc.O)
  end

  module T = interface
    (sdram : Sdram_t)
    (acc_ee : Acc_ee.T)
    (gpio2x13 : Gpio2x13.T)
    (gpio0 : Gpio0.T)
    (gpio1 : Gpio1.T)
  end

end

module Inst(G : HardCaml.Interface.S)
           (I : HardCaml.Interface.S)
           (O : HardCaml.Interface.S)
           (T : HardCaml.Interface.S) = struct

  open HardCaml.Structural

  let inst ?g ?i ?o ?t name = 
    let g = match g with None -> [] | Some(x) -> I.(to_list @@ map2 (fun (n,b) x -> n,x) t x) in
    let i = match i with None -> [] | Some(x) -> I.(to_list @@ map2 (fun (n,b) x -> n,x) t x) in
    let o = match o with None -> [] | Some(x) -> O.(to_list @@ map2 (fun (n,b) x -> n,x) t x) in
    let t = match t with None -> [] | Some(x) -> T.(to_list @@ map2 (fun (n,b) x -> n,x) t x) in
    HardCaml.Structural.(inst ~g ~i ~o ~t name)

end

module E = HardCaml.Interface.Empty
module type Comb_S = HardCaml.Comb.S with type t = HardCaml.Structural.signal

let make_top () = 
  let open HardCaml.Structural in
  let i = Top.I.(map (fun (n,b) -> mk_input n b) t) in
  let o = Top.O.(map (fun (n,b) -> mk_output n b) t) in
  let t = Top.T.(map (fun (n,b) -> mk_tristate n b) t) in
  i, o, t

let make_pll comb clock_50 = 
  let module Comb = (val comb : Comb_S) in
  let open Comb in
  let module X = Inst(E)(Pll.I)(Pll.O)(E) in
  let plli = Pll.I.{ inclk0=clock_50 } in
  let pllo = Pll.O.(map (fun (n,b) -> wire b) t) in
  let () = X.inst "pll50" ~i:plli ~o:pllo in
  plli, pllo

let make_vjtag_mm comb = 
  let module Comb = (val comb : Comb_S) in
  let open Comb in
  let module X = Inst(E)(Vjtag_mm.I)(Vjtag_mm.O)(E) in
  let vji = Vjtag_mm.I.(map (fun (n,b) -> wire b) t) in
  let vjo = Vjtag_mm.O.(map (fun (n,b) -> wire b) t) in
  let () = X.inst "vjtag_mm" ~i:vji ~o:vjo in
  vji, vjo

let connect_floating_outputs_tristates comb o t = 
  let open HardCaml.Structural in
  let module Comb = (val comb : Comb_S) in
  let open Comb in
  let def_o o = if not (is_connected o) then o <== consti (width o) 0 in
  let def_t t = if not (is_connected t) then t <== constz (width t) in
  let _ = Top.O.map def_o o in
  let _ = Top.T.map def_t t in
  ()

(********************************************************************)

module Simple = struct
  module I = Avalon.Master_clk
  module O = interface leds[8] (slave : Avalon.Slave) end
end

let make_simple_core comb clk rst master name = 
  let module Comb = (val comb : Comb_S) in
  let open Comb in
  let module X = Inst(E)(Simple.I)(Simple.O)(E) in
  let i = Simple.I.{clk; rst; master } in
  let o = Simple.O.(map (fun (n,b) -> wire b) t) in
  let () = X.inst name ~i ~o in
  i, o

(* creates a top level which instantiates a core inplementing a simple
 * avalon slave and connects it to the vjtag_mm comms component *)
let make_simple_vjtag_mm top_name core_name = 
  let open HardCaml.Structural in
  let _ = circuit top_name in
  let module Comb = HardCaml.Comb.Make(Base0) in
  let open Comb in
  
  (* top level ports *)
  let i, o, t = make_top () in

  (* pll *)
  let plli, pllo = make_pll (module Comb) i.Top.I.clock_50 in

  (* vjtag_mm *)
  let vji, vjo = make_vjtag_mm (module Comb) in

  (* instantiate user design *)
  let clk = pllo.Pll.O.c0 in
  let rst_n = pllo.Pll.O.locked in

  let _, fo = make_simple_core (module Comb) clk rst_n vjo core_name in

  (* connect to vjtag_mm *)
  let _ = 
    vji.Vjtag_mm.I.clk_clk <== clk;
    vji.Vjtag_mm.I.reset_reset_n <== rst_n;
    Avalon.Slave.(map2 (<==) vji.Vjtag_mm.I.slave fo.Simple.O.slave);
  in
  
  (* drive outputs and tri-states *)
  let () = 
    o.Top.O.led <== fo.Simple.O.leds;
    o.Top.O.acc_ee.Acc_ee.O.g_sensor_cs_n <== vdd;
    o.Top.O.adc.Adc.O.adc_cs_n <== vdd;
    connect_floating_outputs_tristates (module Comb) o t 
  in

  end_circuit ();
  find_circuit top_name

let generate_simple_vjtag_mm os top_name core_name core =
  (* write core *)
  let module X = HardCaml.Interface.Circ(Simple.I)(Simple.O) in
  let () = HardCaml.Rtl.Verilog.write os (X.make core_name core) in
  (* write top level *)
  let circ = make_simple_vjtag_mm top_name core_name in
  HardCaml.Structural.write_verilog os circ

(********************************************************************)

module Sdram_mm = struct
  
  module V_master = Util.Name_map(struct let f s = "vjtag_"^s end)(Avalon.Master)
  module V_slave = Util.Name_map(struct let f s = "vjtag_"^s end)(Avalon.Slave)
  module S_master = Util.Name_map(struct let f s = "sdram_"^s end)(Avalon.Master)
  module S_slave = Util.Name_map(struct let f s = "sdram_"^s end)(Avalon.Slave)
  
  module I = interface
    clk[1] rst[1]
    (vjtag_master : V_master)
    (sdram_slave : S_slave)
  end

  module O = interface
    leds[8]
    (vjtag_slave : V_slave)
    (sdram_master : S_master)
  end
end

let make_sdram_controller comb t = 
  let module Comb = (val comb : Comb_S) in
  let open Comb in
  let module X = Inst(E)(Sdram.Core.I)(Sdram.Core.O)(Sdram.Core.T) in
  let i = Sdram.Core.I.(map (fun (n,b) -> wire b) t) in
  let o = Sdram.Core.O.(map (fun (n,b) -> wire b) t) in
  let () = X.inst "sdram" ~i ~o ~t in
  i, o

let make_sdram_mm_core comb clk rst vjtag_master sdram_slave name = 
  let module Comb = (val comb : Comb_S) in
  let open Comb in
  let module X = Inst(E)(Sdram_mm.I)(Sdram_mm.O)(E) in
  let i = Sdram_mm.I.{ clk; rst; vjtag_master; sdram_slave } in
  let o = Sdram_mm.O.(map (fun (n,b) -> wire b) t) in
  let () = X.inst name ~i ~o in 
  i, o

let make_sdram_vjtag_mm top_name core_name = 
  let open HardCaml.Structural in
  let _ = circuit top_name in
  let module Comb = HardCaml.Comb.Make(Base0) in
  let open Comb in
  
  (* top level ports *)
  let i, o, t = make_top () in

  (* pll *)
  let plli, pllo = make_pll (module Comb) i.Top.I.clock_50 in

  (* vjtag_mm *)
  let vji, vjo = make_vjtag_mm (module Comb) in

  (* instantiate sdram controller *)
  let sdi, sdo = make_sdram_controller (module Comb) t.Top.T.sdram in

  (* instantiate user design *)
  let clk = pllo.Pll.O.c0 in
  let sdram_clk = pllo.Pll.O.c1 in
  let rst_n = pllo.Pll.O.locked in

  let _, fo = make_sdram_mm_core (module Comb) clk rst_n vjo sdo.Sdram.Core.O.mm core_name in

  (* connect to vjtag_mm *)
  let () = 
    vji.Vjtag_mm.I.clk_clk <== clk;
    vji.Vjtag_mm.I.reset_reset_n <== rst_n;
    ignore @@ Avalon.Slave.(map2 (<==) vji.Vjtag_mm.I.slave fo.Sdram_mm.O.vjtag_slave);
  in
  
  (* connect to sdram controller *)
  let () = 
    sdi.Sdram.Core.I.clk_clk <== clk;
    sdi.Sdram.Core.I.clk_reset_reset_n <== rst_n;
    sdi.Sdram.Core.I.sdram_reset_reset_n <== rst_n;
    o.Top.O.dram_clk <== sdram_clk;
    ignore @@ Avalon.Master.(map2 (<==) sdi.Sdram.Core.I.mm 
      { fo.Sdram_mm.O.sdram_master with
        byteenable = ~: (fo.Sdram_mm.O.sdram_master.byteenable);
        read = ~: (fo.Sdram_mm.O.sdram_master.read);
        write = ~: (fo.Sdram_mm.O.sdram_master.write);
      });
    ignore @@ Sdram.O.(map2 (<==) o.Top.O.sdram sdo.Sdram.Core.O.sdram);
  in

  (* drive outputs and tri-states *)
  let () = 
    o.Top.O.led <== fo.Sdram_mm.O.leds;
    o.Top.O.acc_ee.Acc_ee.O.g_sensor_cs_n <== vdd;
    o.Top.O.adc.Adc.O.adc_cs_n <== vdd;
    connect_floating_outputs_tristates (module Comb) o t 
  in

  end_circuit ();
  find_circuit top_name

let generate_sdram_vjtag_mm os top_name core_name core =
  (* write core *)
  let module X = HardCaml.Interface.Circ(Sdram_mm.I)(Sdram_mm.O) in
  let () = HardCaml.Rtl.Verilog.write os (X.make core_name core) in
  (* write top level *)
  let circ = make_sdram_vjtag_mm top_name core_name in
  HardCaml.Structural.write_verilog os circ


