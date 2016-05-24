open HardCamlRiscV
open Cfg32

module D = Utils.D32(B) 
module Mem = Utils.Mem(D) 

open Rv.Ifs 
open I 
open O 
open Rv_o 

let mio_data i o memory = 
  let open Mi_data in
  let open Mo_data in
  (*let o = o.o in*)
  let o = o.md in
  i.I.md.Mi_data.vld := B.gnd;
  if B.to_int !(o.req) = 1 then begin
    i.md.vld := B.vdd;
    if B.to_int !(o.rw) = 1 then begin
      i.md.rdata := D.to_signal @@ Mem.read ~memory ~addr:!(o.addr)
    end else begin
      Mem.write ~memory ~addr:!(o.addr) ~data:!(o.wdata) ~strb:!(o.wmask)
    end
  end

let mio_instr i o memory = 
  let open Mi_instr in
  let open Mo_instr in
  (*let o = o.o in*)
  let o = o.mi in
  (* XXX memif must hold data *)
  if B.to_int !(o.req) = 1 then begin
    i.I.mi.Mi_instr.rdata := D.to_signal @@ Mem.read ~memory ~addr:!(o.addr)
  end
