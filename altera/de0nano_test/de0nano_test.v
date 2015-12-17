module reg_bank (
    read,
    byteenable,
    address,
    write,
    rst,
    clk,
    writedata,
    leds,
    readdata,
    waitrequest,
    readdatavalid
);

    input read;
    input [3:0] byteenable;
    input [31:0] address;
    input write;
    input rst;
    input clk;
    input [31:0] writedata;
    output [7:0] leds;
    output [31:0] readdata;
    output waitrequest;
    output readdatavalid;

    /* signal declarations */
    wire gnd = 1'b0;
    wire _112;
    wire _113;
    wire _114;
    wire [7:0] _115 = 8'b00000000;
    wire [7:0] _116 = 8'b00000000;
    wire [7:0] _111;
    reg [7:0] _117;
    wire _119;
    wire _120;
    wire _121;
    wire [7:0] _122 = 8'b00000000;
    wire [7:0] _123 = 8'b00000000;
    wire [7:0] _118;
    reg [7:0] _124;
    wire _126;
    wire _127;
    wire _128;
    wire [7:0] _129 = 8'b00000000;
    wire [7:0] _130 = 8'b00000000;
    wire [7:0] _125;
    reg [7:0] _131;
    wire _133;
    wire [31:0] _49 = 32'b00000000000000000000000000001000;
    wire _50;
    wire _134;
    wire _135;
    wire [7:0] _136 = 8'b00000000;
    wire [7:0] _137 = 8'b00000000;
    wire [7:0] _132;
    reg [7:0] _138;
    wire [31:0] _139;
    wire _83;
    wire _84;
    wire _85;
    wire [7:0] _86 = 8'b00000000;
    wire [7:0] _87 = 8'b00000000;
    wire [7:0] _82;
    reg [7:0] _88;
    wire _90;
    wire _91;
    wire _92;
    wire [7:0] _93 = 8'b00000000;
    wire [7:0] _94 = 8'b00000000;
    wire [7:0] _89;
    reg [7:0] _95;
    wire _97;
    wire _98;
    wire _99;
    wire [7:0] _100 = 8'b00000000;
    wire [7:0] _101 = 8'b00000000;
    wire [7:0] _96;
    reg [7:0] _102;
    wire _104;
    wire [31:0] _47 = 32'b00000000000000000000000000000100;
    wire _48;
    wire _105;
    wire _106;
    wire [7:0] _107 = 8'b00000000;
    wire [7:0] _108 = 8'b00000000;
    wire [7:0] _103;
    reg [7:0] _109;
    wire [31:0] _110;
    wire _54;
    wire _55;
    wire _56;
    wire [7:0] _57 = 8'b00000000;
    wire [7:0] _58 = 8'b00000000;
    wire [7:0] _53;
    reg [7:0] _59;
    wire _61;
    wire _62;
    wire _63;
    wire [7:0] _64 = 8'b00000000;
    wire [7:0] _65 = 8'b00000000;
    wire [7:0] _60;
    reg [7:0] _66;
    wire _68;
    wire _69;
    wire _70;
    wire [7:0] _71 = 8'b00000000;
    wire [7:0] _72 = 8'b00000000;
    wire [7:0] _67;
    reg [7:0] _73;
    wire _75;
    wire [31:0] _45 = 32'b00000000000000000000000000000000;
    wire _46;
    wire _76;
    wire _77;
    wire [7:0] _78 = 8'b00000000;
    wire [7:0] _79 = 8'b00000000;
    wire [7:0] _74;
    reg [7:0] _80;
    wire [31:0] _81;
    wire [29:0] _170;
    reg [31:0] _171;
    wire [31:0] _169 = 32'b11011110101011011011111011101111;
    wire [31:0] _172;
    wire _141;
    wire _142;
    wire _143;
    wire [7:0] _144 = 8'b00000000;
    wire [7:0] _145 = 8'b00000000;
    wire [7:0] _140;
    reg [7:0] _146;
    wire _148;
    wire _149;
    wire _150;
    wire [7:0] _151 = 8'b00000000;
    wire [7:0] _152 = 8'b00000000;
    wire [7:0] _147;
    reg [7:0] _153;
    wire _155;
    wire _156;
    wire _157;
    wire [7:0] _158 = 8'b00000000;
    wire [7:0] _159 = 8'b00000000;
    wire [7:0] _154;
    reg [7:0] _160;
    wire _162;
    wire [31:0] _51 = 32'b00000000000000000000000000001100;
    wire _52;
    wire _163;
    wire _164;
    wire [7:0] _165 = 8'b00000000;
    wire _44;
    wire vdd = 1'b1;
    wire [7:0] _166 = 8'b00000000;
    wire [7:0] _161;
    reg [7:0] _167;
    wire [31:0] _168;
    wire [7:0] _173;

    /* logic */
    assign _112 = byteenable[0:0];
    assign _113 = write & _50;
    assign _114 = _113 & _112;
    assign _111 = writedata[7:0];
    always @(posedge clk) begin
        if (_44)
            _117 <= _115;
        else
            if (_114)
                _117 <= _111;
    end
    assign _119 = byteenable[1:1];
    assign _120 = write & _50;
    assign _121 = _120 & _119;
    assign _118 = writedata[15:8];
    always @(posedge clk) begin
        if (_44)
            _124 <= _122;
        else
            if (_121)
                _124 <= _118;
    end
    assign _126 = byteenable[2:2];
    assign _127 = write & _50;
    assign _128 = _127 & _126;
    assign _125 = writedata[23:16];
    always @(posedge clk) begin
        if (_44)
            _131 <= _129;
        else
            if (_128)
                _131 <= _125;
    end
    assign _133 = byteenable[3:3];
    assign _50 = address == _49;
    assign _134 = write & _50;
    assign _135 = _134 & _133;
    assign _132 = writedata[31:24];
    always @(posedge clk) begin
        if (_44)
            _138 <= _136;
        else
            if (_135)
                _138 <= _132;
    end
    assign _139 = { _138, _131, _124, _117 };
    assign _83 = byteenable[0:0];
    assign _84 = write & _48;
    assign _85 = _84 & _83;
    assign _82 = writedata[7:0];
    always @(posedge clk) begin
        if (_44)
            _88 <= _86;
        else
            if (_85)
                _88 <= _82;
    end
    assign _90 = byteenable[1:1];
    assign _91 = write & _48;
    assign _92 = _91 & _90;
    assign _89 = writedata[15:8];
    always @(posedge clk) begin
        if (_44)
            _95 <= _93;
        else
            if (_92)
                _95 <= _89;
    end
    assign _97 = byteenable[2:2];
    assign _98 = write & _48;
    assign _99 = _98 & _97;
    assign _96 = writedata[23:16];
    always @(posedge clk) begin
        if (_44)
            _102 <= _100;
        else
            if (_99)
                _102 <= _96;
    end
    assign _104 = byteenable[3:3];
    assign _48 = address == _47;
    assign _105 = write & _48;
    assign _106 = _105 & _104;
    assign _103 = writedata[31:24];
    always @(posedge clk) begin
        if (_44)
            _109 <= _107;
        else
            if (_106)
                _109 <= _103;
    end
    assign _110 = { _109, _102, _95, _88 };
    assign _54 = byteenable[0:0];
    assign _55 = write & _46;
    assign _56 = _55 & _54;
    assign _53 = writedata[7:0];
    always @(posedge clk) begin
        if (_44)
            _59 <= _57;
        else
            if (_56)
                _59 <= _53;
    end
    assign _61 = byteenable[1:1];
    assign _62 = write & _46;
    assign _63 = _62 & _61;
    assign _60 = writedata[15:8];
    always @(posedge clk) begin
        if (_44)
            _66 <= _64;
        else
            if (_63)
                _66 <= _60;
    end
    assign _68 = byteenable[2:2];
    assign _69 = write & _46;
    assign _70 = _69 & _68;
    assign _67 = writedata[23:16];
    always @(posedge clk) begin
        if (_44)
            _73 <= _71;
        else
            if (_70)
                _73 <= _67;
    end
    assign _75 = byteenable[3:3];
    assign _46 = address == _45;
    assign _76 = write & _46;
    assign _77 = _76 & _75;
    assign _74 = writedata[31:24];
    always @(posedge clk) begin
        if (_44)
            _80 <= _78;
        else
            if (_77)
                _80 <= _74;
    end
    assign _81 = { _80, _73, _66, _59 };
    assign _170 = address[31:2];
    always @* begin
        case (_170)
        0: _171 <= _81;
        1: _171 <= _110;
        2: _171 <= _139;
        3: _171 <= _168;
        default: _171 <= _169;
        endcase
    end
    assign _172 = read ? _171 : _169;
    assign _141 = byteenable[0:0];
    assign _142 = write & _52;
    assign _143 = _142 & _141;
    assign _140 = writedata[7:0];
    always @(posedge clk) begin
        if (_44)
            _146 <= _144;
        else
            if (_143)
                _146 <= _140;
    end
    assign _148 = byteenable[1:1];
    assign _149 = write & _52;
    assign _150 = _149 & _148;
    assign _147 = writedata[15:8];
    always @(posedge clk) begin
        if (_44)
            _153 <= _151;
        else
            if (_150)
                _153 <= _147;
    end
    assign _155 = byteenable[2:2];
    assign _156 = write & _52;
    assign _157 = _156 & _155;
    assign _154 = writedata[23:16];
    always @(posedge clk) begin
        if (_44)
            _160 <= _158;
        else
            if (_157)
                _160 <= _154;
    end
    assign _162 = byteenable[3:3];
    assign _52 = address == _51;
    assign _163 = write & _52;
    assign _164 = _163 & _162;
    assign _44 = ~ rst;
    assign _161 = writedata[31:24];
    always @(posedge clk) begin
        if (_44)
            _167 <= _165;
        else
            if (_164)
                _167 <= _161;
    end
    assign _168 = { _167, _160, _153, _146 };
    assign _173 = _168[7:0];

    /* aliases */

    /* output assignments */
    assign leds = _173;
    assign readdata = _172;
    assign waitrequest = gnd;
    assign readdatavalid = vdd;

endmodule
module de0nano_test
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
  output DRAM_CLK,
  output DRAM_CKE,
  output DRAM_CAS_N,
  output [1:0] DRAM_BA,
  output [12:0] DRAM_ADDR,
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
  wire _54;
  wire _55;
  wire [31:0] _56;
  wire [7:0] _57;
  wire [1:0] _59;
  wire [12:0] _60;
  wire [33:0] _61;
  wire [12:0] _62;
  wire _63;
  wire [15:0] _64;
  assign _1 = 1'b1;
  assign _2 = 1'b0;
  assign _43 = _54;
  assign _44 = _55;
  assign _45 = _56;
  assign _46 = _39;
  assign _47 = _41;
  assign _59 = 2'b00;
  assign _60 = 13'b0000000000000;
  assign _61 = 34'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
  assign _62 = 13'bzzzzzzzzzzzzz;
  assign _63 = 1'bz;
  assign _64 = 16'bzzzzzzzzzzzzzzzz;
  assign ADC_SCLK = _2;
  assign ADC_SADDR = _2;
  assign ADC_CS_N = _1;
  assign I2C_SCLK = _2;
  assign G_SENSOR_CS_N = _1;
  assign EPCS_NCSO = _2;
  assign EPCS_DCLK = _2;
  assign EPCS_ASDO = _2;
  assign DRAM_WE_N = _2;
  assign DRAM_RAS_N = _2;
  assign DRAM_DQM = _59;
  assign DRAM_CS_N = _2;
  assign DRAM_CLK = _2;
  assign DRAM_CKE = _2;
  assign DRAM_CAS_N = _2;
  assign DRAM_BA = _59;
  assign DRAM_ADDR = _60;
  assign LED = _57;
  assign GPIO_1 = _61;
  assign GPIO_0 = _61;
  assign GPIO_2 = _62;
  assign I2C_SDAT = _63;
  assign DRAM_DQ = _64;
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
  reg_bank _58
  (
    .clk(_41),
    .rst(_39),
    .address(_52),
    .read(_51),
    .write(_50),
    .writedata(_49),
    .byteenable(_48),
    .leds(_57),
    .readdata(_56),
    .waitrequest(_55),
    .readdatavalid(_54)
  );
endmodule
