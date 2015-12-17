module S = struct
  include Avalon.Slave
  let t = map (fun (n,b) -> "vjtag_mm_" ^ n, b) t
end

module I = interface
  clk_clk[1] reset_reset_n[1]
  (slave : S)
end

module O = struct
  include Avalon.Master
  let t = map (fun (n,b) -> "vjtag_mm_" ^ n, b) t
end

