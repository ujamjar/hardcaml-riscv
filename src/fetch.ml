module Make(Ifs : Interfaces.S)(B : HardCaml.Comb.S) = struct

  open B
  open Ifs

  let name = "fet"

  let z = Stage_ex.(map (fun (_,b) -> B.zero b) t)

  let fetch ~inp ~com ~fet = 
    let open Stage in
    (*let pc = mux2 com.branch com.pc (fet.pc +:. 4) in*)
    let pc = com.pc in 
    let junk = I.to_list inp |> concat |> bits |> reduce (|:) in (* XXX TO BE REMOVED *)
    { z with pc; junk; }, 
    {
      Mo_instr.addr = pc;
      wdata = zero xlen;
      (*req = vdd;*)
      req = vdd;
      rw = vdd;
      wmask = zero (xlen / 8); 
    } 

  let f ~inp ~comb ~pipe = 
    let open Stages in
    fetch ~inp ~com:pipe.com ~fet:pipe.fet
    
  (*let m ~ctrl ~inp ~comb ~pipe = 
    let open Stage in
    let open Stages in
    { pipe.fet.mi with
      Mo_instr.req = ctrl.Ctrl.en.[0:0];
    }*)
  
  let m ~ctrl ~inp ~comb ~pipe = failwith "Fetch.m"

end

