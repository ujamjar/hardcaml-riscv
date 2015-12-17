(* 32 bit avalon master interface *)
module Master = interface address[32] read[1] write[1] writedata[32] byteenable[4] end

(* 32 bit avalon slave interface *)
module Slave = interface readdata[32] waitrequest[1] readdatavalid[1] end

module Master_clk = interface clk[1] rst[1] (master : Master) end
module Slave_clk = interface clk[1] rst[1] (slave : Slave) end

