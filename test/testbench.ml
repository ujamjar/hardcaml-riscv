open Printf
open HardCaml.Api
open HardCamlWaveLTerm.Api
open Riscv
open Picorv32

module B = HardCaml.Bits_ext.Comb.IntbitsList

module Api = HardCaml.Api.Make(B)
module G = Api.Interface.Gen(Core.I)(Core.O)
module G' = HardCamlLlvmsim.Sim.Gen(B)(Core.I)(Core.O)

let load_hex memory file = 
  let rec f i = 
    match input_line file with
    | s -> begin
      memory.(i) <- B.to_int32 @@ B.consthu 32 s;
      f (i+1)
    end
    | exception _ -> ()
  in
  f 0


let cfg = 
  let open Waveterm_waves in
  let open Core in
  (List.map  (fun n -> n, B) ["clock"; "clear"]) @
  ["count_cycle",U] @
  (I.(to_list (map (fun (n,b) -> n, if b=1 then B else H) t))) @
  (O.(to_list (map (fun (n,b) -> n, if b=1 then B else H) t))) 

let waves = true
let llvm = false 
let n_cycles = 0

let init_testbench () = 
  let memory = Array.init (64*1024/4) (fun _ -> 0l) in
  let circ,sim,i,o = 
    if llvm then
      G'.make "opicorv32" Core.f 
    else
      let circ,sim,i,o,_ = G.make "opicorv32" Core.f in
      circ,sim,i,o
  in

  let sim,waves = 
    if waves then 
      let s,w = Waveterm_sim.wrap ~cfg sim in 
      s,Some(w) 
    else sim, None 
  in

  let () = 
    let f = open_in "firmware/firmware.hex" in
    load_hex memory f;
    close_in f
  in

  sim, i, o, memory, waves

let run_testbench (sim, i, o, memory, waves) = 
  let open Core.I in
  let open Core.O in
  (* basic memory interface *)
  let memif () = 
    let verbose = false in
    if B.to_int !(o.mem_valid) = 1 && B.to_int !(i.mem_ready) = 0 then begin
      let addr = B.to_int !(o.mem_addr) in
      let wstrb = B.to_int !(o.mem_wstrb) in
      let fail() = failwith ("memory access out of bounds @ " ^ string_of_int (addr)) in
      i.mem_ready := B.vdd;
      if wstrb = 0 then begin (* memory read *)
        (if verbose then printf "RD: ADDR=%.8x DATA=%.8lx\n%!" addr memory.(addr/4));
        try i.mem_rdata := B.consti32 32 memory.(addr/4)
        with Invalid_argument _ -> fail ()
      end else begin (* memory write *)
        let wdata = B.to_int32 !(o.mem_wdata) in
        if addr = 0x1000_0000 then begin
          (if verbose then 
            printf "OUT: %c\n" (try Char.chr (Int32.to_int wdata) with _ -> '#')
          else 
            printf "%c%!" (try Char.chr (Int32.to_int wdata) with _ -> '#'))
        end else begin
          (if verbose then printf "WR: ADDR=%.8x DATA=%.8lx\n%!" addr wdata);
          try 
            let write_mask mask = 
              memory.(addr/4) <- Int32.(logor 
                  (logand memory.(addr/4) (lognot mask))
                  (logand wdata mask))
            in
            match wstrb with
            | 0b0001 -> write_mask 0x0000_00FFl
            | 0b0010 -> write_mask 0x0000_FF00l
            | 0b0100 -> write_mask 0x00FF_0000l
            | 0b1000 -> write_mask 0xFF00_0000l
            | 0b0011 -> write_mask 0x0000_FFFFl
            | 0b1100 -> write_mask 0xFFFF_0000l
            | 0b1111 -> memory.(addr/4) <- wdata
            | _ -> failwith "Invalid write strobe"
          with Invalid_argument _ -> fail ()
        end
      end
    end else begin
      i.mem_ready := B.gnd;
    end
  in

  let cycleno = ref 0 in

  let irq () = 
    cycleno := !cycleno + 1;
    i.irq := B.zero 32;
    if (!cycleno mod (1 lsl 13)) = 0 (*|| !cycleno = 200*) then begin
      i.irq := B.(!(i.irq) |: (B.consti 32 0x10))
    end;
    if (!cycleno mod (1 lsl 16)) = 0 then begin
      i.irq := B.(!(i.irq) |: (B.consti 32 0x20))
    end
  in

  let cycle() = 
    memif();
    irq();
    Cs.cycle sim
  in

  Cs.reset sim;

  i.resetn := B.gnd;
  for i=0 to 100 do
    Cs.cycle sim;
  done;
  i.resetn := B.vdd;

  if n_cycles <> 0 then begin
    for i=0 to n_cycles-1 do
      cycle ()
    done
  end else begin
    while B.to_int !(o.trap) = 0 do
      cycle ()
    done
  end;

  for i=0 to 10 do
    cycle ()
  done;
  printf "TRAP after %1d clock cycles\n" !cycleno

let show_waves waves = 
  (* display waveform *)
  match waves with
  | None -> ()
  | Some(waves) -> Lwt_main.run (Waveterm_ui.run Waveterm_waves.({ cfg=default; waves }))

let () = 
  let sim, i, o, memory, waves = init_testbench () in
  let () = Sys.catch_break true in
  let () = try run_testbench (sim, i, o, memory, waves) with Sys.Break -> () in
  let () = show_waves waves in
  ()


