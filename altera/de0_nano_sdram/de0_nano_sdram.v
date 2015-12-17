module loopback (
    vjtag_byteenable,
    vjtag_writedata,
    vjtag_address,
    sdram_readdatavalid,
    sdram_waitrequest,
    sdram_readdata,
    vjtag_write,
    vjtag_read,
    rst,
    clk,
    leds,
    vjtag_readdata,
    vjtag_waitrequest,
    vjtag_readdatavalid,
    sdram_address,
    sdram_read,
    sdram_write,
    sdram_writedata,
    sdram_byteenable
);

    input [3:0] vjtag_byteenable;
    input [31:0] vjtag_writedata;
    input [31:0] vjtag_address;
    input sdram_readdatavalid;
    input sdram_waitrequest;
    input [31:0] sdram_readdata;
    input vjtag_write;
    input vjtag_read;
    input rst;
    input clk;
    output [7:0] leds;
    output [31:0] vjtag_readdata;
    output vjtag_waitrequest;
    output vjtag_readdatavalid;
    output [31:0] sdram_address;
    output sdram_read;
    output sdram_write;
    output [31:0] sdram_writedata;
    output [3:0] sdram_byteenable;

    /* signal declarations */
    wire _48;
    wire [7:0] _50 = 8'b00000000;
    wire vdd = 1'b1;
    wire [7:0] _51 = 8'b00000000;
    wire _47;
    wire [7:0] _53 = 8'b00000001;
    wire [7:0] _54;
    wire [7:0] _49;
    reg [7:0] _52;

    /* logic */
    assign _48 = vjtag_read | vjtag_write;
    assign _47 = ~ rst;
    assign _54 = _52 + _53;
    assign _49 = _54;
    always @(posedge clk or posedge _47) begin
        if (_47)
            _52 <= _51;
        else
            if (_48)
                _52 <= _49;
    end

    /* aliases */

    /* output assignments */
    assign leds = _52;
    assign vjtag_readdata = sdram_readdata;
    assign vjtag_waitrequest = sdram_waitrequest;
    assign vjtag_readdatavalid = sdram_readdatavalid;
    assign sdram_address = vjtag_address;
    assign sdram_read = vjtag_read;
    assign sdram_write = vjtag_write;
    assign sdram_writedata = vjtag_writedata;
    assign sdram_byteenable = vjtag_byteenable;

endmodule
module de0_nano_sdram
(
  input [1:0] GPIO_1_IN,
  input [1:0] GPIO_0_IN,
  input [2:0] GPIO_2_IN,
  input ADC_SDAT,
  input G_SENSOR_INT,
  input EPCS_DATA0,
  input [3:0] SW,
  input [1:0] KEY,
  input CLOCK_50,
  output ADC_SCLK,
  output ADC_SADDR,
  output ADC_CS_N,
  output I2C_SCLK,
  output G_SENSOR_CS_N,
  output EPCS_NCSO,
  output EPCS_DCLK,
  output EPCS_ASDO,
  output DRAM_WE_N,
  output DRAM_RAS_N,
  output [1:0] DRAM_DQM,
  output DRAM_CS_N,
  output DRAM_CKE,
  output DRAM_CAS_N,
  output [1:0] DRAM_BA,
  output [12:0] DRAM_ADDR,
  output DRAM_CLK,
  output [7:0] LED,
  inout [33:0] GPIO_1,
  inout [33:0] GPIO_0,
  inout [12:0] GPIO_2,
  inout I2C_SDAT,
  inout [15:0] DRAM_DQ
);

  wire _1;
  wire _2;
  wire _3;
  wire _4;
  wire _5;
  wire _6;
  wire _39;
  wire _40;
  wire _41;
  wire _43;
  wire _44;
  wire [31:0] _45;
  wire _46;
  wire _47;
  wire [3:0] _48;
  wire [31:0] _49;
  wire _50;
  wire _51;
  wire [31:0] _52;
  wire [3:0] _54;
  wire [31:0] _55;
  wire _56;
  wire _57;
  wire [31:0] _58;
  wire _59;
  wire _60;
  wire _61;
  wire _62;
  wire _63;
  wire _64;
  wire [1:0] _65;
  wire _66;
  wire _67;
  wire _68;
  wire [1:0] _69;
  wire [12:0] _70;
  wire _71;
  wire _72;
  wire [31:0] _73;
  wire [3:0] _75;
  wire [31:0] _76;
  wire _77;
  wire _78;
  wire [31:0] _79;
  wire _80;
  wire _81;
  wire [31:0] _82;
  wire [7:0] _83;
  wire [3:0] _85;
  wire _87;
  wire _89;
  wire [33:0] _91;
  wire [12:0] _92;
  wire _93;
  assign _1 = 1'b1;
  assign _2 = 1'b0;
  assign _43 = _80;
  assign _44 = _81;
  assign _45 = _82;
  assign _46 = _39;
  assign _47 = _41;
  assign _54 = _85;
  assign _55 = _76;
  assign _56 = _87;
  assign _57 = _89;
  assign _58 = _79;
  assign _60 = _39;
  assign _61 = _39;
  assign _62 = _41;
  assign _91 = 34'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
  assign _92 = 13'bzzzzzzzzzzzzz;
  assign _93 = 1'bz;
  assign ADC_SCLK = _2;
  assign ADC_SADDR = _2;
  assign ADC_CS_N = _1;
  assign I2C_SCLK = _2;
  assign G_SENSOR_CS_N = _1;
  assign EPCS_NCSO = _2;
  assign EPCS_DCLK = _2;
  assign EPCS_ASDO = _2;
  assign DRAM_WE_N = _63;
  assign DRAM_RAS_N = _64;
  assign DRAM_DQM = _65;
  assign DRAM_CS_N = _66;
  assign DRAM_CKE = _67;
  assign DRAM_CAS_N = _68;
  assign DRAM_BA = _69;
  assign DRAM_ADDR = _70;
  assign DRAM_CLK = _40;
  assign LED = _83;
  assign GPIO_1 = _91;
  assign GPIO_0 = _91;
  assign GPIO_2 = _92;
  assign I2C_SDAT = _93;
  pll50 _42
  (
    .inclk0(CLOCK_50),
    .c0(_41),
    .c1(_40),
    .locked(_39)
  );
  vjtag_mm _53
  (
    .clk_clk(_47),
    .reset_reset_n(_46),
    .vjtag_mm_readdata(_45),
    .vjtag_mm_waitrequest(_44),
    .vjtag_mm_readdatavalid(_43),
    .vjtag_mm_address(_52),
    .vjtag_mm_read(_51),
    .vjtag_mm_write(_50),
    .vjtag_mm_writedata(_49),
    .vjtag_mm_byteenable(_48)
  );
  sdram _74
  (
    .clk_clk(_62),
    .clk_reset_reset_n(_61),
    .sdram_reset_reset_n(_60),
    .mm_chipselect(_59),
    .mm_address(_58),
    .mm_read_n(_57),
    .mm_write_n(_56),
    .mm_writedata(_55),
    .mm_byteenable_n(_54),
    .mm_readdata(_73),
    .mm_waitrequest(_72),
    .mm_readdatavalid(_71),
    .io_addr(_70),
    .io_ba(_69),
    .io_cas_n(_68),
    .io_cke(_67),
    .io_cs_n(_66),
    .io_dqm(_65),
    .io_ras_n(_64),
    .io_we_n(_63),
    .io_dq(DRAM_DQ)
  );
  loopback _84
  (
    .clk(_41),
    .rst(_39),
    .vjtag_address(_52),
    .vjtag_read(_51),
    .vjtag_write(_50),
    .vjtag_writedata(_49),
    .vjtag_byteenable(_48),
    .sdram_readdata(_73),
    .sdram_waitrequest(_72),
    .sdram_readdatavalid(_71),
    .leds(_83),
    .vjtag_readdata(_82),
    .vjtag_waitrequest(_81),
    .vjtag_readdatavalid(_80),
    .sdram_address(_79),
    .sdram_read(_78),
    .sdram_write(_77),
    .sdram_writedata(_76),
    .sdram_byteenable(_75)
  );
  hardcaml_lib_not
  #(
    .b(4)
  ) _86
  (
    .i(_75),
    .o(_85)
  );
  hardcaml_lib_not
  #(
    .b(1)
  ) _88
  (
    .i(_77),
    .o(_87)
  );
  hardcaml_lib_not
  #(
    .b(1)
  ) _90
  (
    .i(_78),
    .o(_89)
  );
endmodule
