module Make(Ifs : Interfaces.S) = struct

  open Ifs
  open HardCaml.Signal.Comb

  module I = interface
    clk[1] clr[1]
    wr[1] wa[log_regs] d[xlen]
    ra1[log_regs] ra2[log_regs]
  end

  module O = interface
    q1[xlen] q2[xlen]
  end

  let f i = 
    let open I in
    let module Seq = Utils.Regs(struct let clk=i.clk let clr=i.clr end) in

    let wen = binary_to_onehot i.wa in
    let regs = 
      Array.to_list @@
      Array.init num_regs 
        (fun j -> 
          if j=0 then zero xlen 
          else Seq.reg ~e:(i.wr &: wen.[j:j]) i.d -- (Printf.sprintf "reg_%.2i" j)) 
    in
    O.({
      q1 = mux i.ra1 regs;
      q2 = mux i.ra2 regs;
    })

end


