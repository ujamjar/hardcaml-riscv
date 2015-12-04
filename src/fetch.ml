module Make(Ifs : Interfaces.S) = struct

  open HardCaml.Signal.Comb
  open Ifs

  let f ~inp ~comb ~pipe = 
    let open Stage in
    let open Stages in
    let pc = mux2 pipe.com.branch pipe.com.pc (pipe.fet.pc +:. 4) in
    let junk = I.to_list inp |> concat |> bits |> reduce (|:) in (* XXX TO BE REMOVED *)
    let z = zero_stage () in
    { z with 
      pc; junk; pen=vdd;
      mi = {
        Mo_instr.addr = pc;
        wdata = zero xlen;
        (*req = vdd;*)
        req = vdd;
        rw = vdd;
        wmask = zero (xlen / 8); 
      } 
    } 

end

