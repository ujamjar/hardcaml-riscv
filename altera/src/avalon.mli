(* 32 bit avalon master interface *)
module Master : interface address read write writedata byteenable end

(* 32 bit avalon slave interface *)
module Slave : interface readdata waitrequest readdatavalid end

module Master_clk : interface clk rst (master : Master) end
module Slave_clk : interface clk rst (slave : Slave) end

