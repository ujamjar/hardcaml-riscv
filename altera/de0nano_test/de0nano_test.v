module de0nano_test (
  input CLOCK_50,
  output [7:0] LED
);

  wire clk, reset_n;

  pll50 the_pll50 ( 
    .inclk0(CLOCK_50),
    .c0(clk),
    .locked(reset_n)
  );

  wire [31:0] vjtag_mm_address;
  wire [31:0] vjtag_mm_readdata;
  wire [31:0] vjtag_mm_writedata;
  wire        vjtag_mm_read;
  wire        vjtag_mm_write;
  wire        vjtag_mm_waitrequest = 1'b0;
  wire        vjtag_mm_readdatavalid = 1'b1;
  wire [3:0]  vjtag_mm_byteenable;
  
  vjtag_mm the_vjtag_mm (
		.clk_clk(clk),
		.reset_reset_n(reset_n),
		.vjtag_mm_address(vjtag_mm_address),
		.vjtag_mm_readdata(vjtag_mm_readdata),
		.vjtag_mm_read(vjtag_mm_read),
		.vjtag_mm_write(vjtag_mm_write),
		.vjtag_mm_writedata(vjtag_mm_writedata),
		.vjtag_mm_waitrequest(vjtag_mm_waitrequest),
		.vjtag_mm_readdatavalid(vjtag_mm_readdatavalid),
		.vjtag_mm_byteenable(vjtag_mm_byteenable)
	);

  reg [31:0] regs[0:3];
  integer i;

  always @(posedge clk) begin
    if (vjtag_mm_write) begin
      for (i=0; i<4; i=i+1) begin
        if (vjtag_mm_address == (i*4)) begin
          if (vjtag_mm_byteenable[0]) regs[i][ 7: 0] <= vjtag_mm_writedata[ 7: 0];
          if (vjtag_mm_byteenable[1]) regs[i][15: 8] <= vjtag_mm_writedata[15: 8];
          if (vjtag_mm_byteenable[2]) regs[i][23:16] <= vjtag_mm_writedata[23:16];
          if (vjtag_mm_byteenable[3]) regs[i][31:24] <= vjtag_mm_writedata[31:24];
        end
      end
    end
  end

  assign vjtag_mm_readdata = 
    vjtag_mm_address == (0*4) ? regs[0] :
    vjtag_mm_address == (1*4) ? regs[1] :
    vjtag_mm_address == (2*4) ? regs[2] :
    vjtag_mm_address == (3*4) ? regs[3] :
                                32'hDEADBEEF;

  assign LED = regs[3][7:0];

endmodule

