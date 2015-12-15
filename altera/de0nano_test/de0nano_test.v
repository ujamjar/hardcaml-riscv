module de0nano_test (
    CLOCK_50,
    LED
);

    input CLOCK_50;
    output [7:0] LED;

    /* signal declarations */
    wire _138;
    wire _139;
    wire [7:0] _140 = 8'b00000000;
    wire [7:0] _141 = 8'b00000000;
    wire [7:0] _137;
    reg [7:0] _142;
    wire _144;
    wire _145;
    wire [7:0] _146 = 8'b00000000;
    wire [7:0] _147 = 8'b00000000;
    wire [7:0] _143;
    reg [7:0] _148;
    wire _150;
    wire _151;
    wire [7:0] _152 = 8'b00000000;
    wire [7:0] _153 = 8'b00000000;
    wire [7:0] _149;
    reg [7:0] _154;
    wire _156;
    wire [31:0] _135 = 32'b00000000000000000000000000001100;
    wire _136;
    wire _157;
    wire [7:0] _158 = 8'b00000000;
    wire [7:0] _159 = 8'b00000000;
    wire _42;
    wire gnd = 1'b0;
    wire _43;
    wire [31:0] _162 = 32'b11011110101011011011111011101111;
    wire _111;
    wire _112;
    wire [7:0] _113 = 8'b00000000;
    wire [7:0] _114 = 8'b00000000;
    wire [7:0] _110;
    reg [7:0] _115;
    wire _117;
    wire _118;
    wire [7:0] _119 = 8'b00000000;
    wire [7:0] _120 = 8'b00000000;
    wire [7:0] _116;
    reg [7:0] _121;
    wire _123;
    wire _124;
    wire [7:0] _125 = 8'b00000000;
    wire [7:0] _126 = 8'b00000000;
    wire [7:0] _122;
    reg [7:0] _127;
    wire _129;
    wire [31:0] _108 = 32'b00000000000000000000000000001000;
    wire _109;
    wire _130;
    wire [7:0] _131 = 8'b00000000;
    wire [7:0] _132 = 8'b00000000;
    wire [7:0] _128;
    reg [7:0] _133;
    wire [31:0] _134;
    wire _84;
    wire _85;
    wire [7:0] _86 = 8'b00000000;
    wire [7:0] _87 = 8'b00000000;
    wire [7:0] _83;
    reg [7:0] _88;
    wire _90;
    wire _91;
    wire [7:0] _92 = 8'b00000000;
    wire [7:0] _93 = 8'b00000000;
    wire [7:0] _89;
    reg [7:0] _94;
    wire _96;
    wire _97;
    wire [7:0] _98 = 8'b00000000;
    wire [7:0] _99 = 8'b00000000;
    wire [7:0] _95;
    reg [7:0] _100;
    wire _102;
    wire [31:0] _81 = 32'b00000000000000000000000000000100;
    wire _82;
    wire _103;
    wire [7:0] _104 = 8'b00000000;
    wire [7:0] _105 = 8'b00000000;
    wire [7:0] _101;
    reg [7:0] _106;
    wire [31:0] _107;
    wire _57;
    wire _58;
    wire [7:0] _59 = 8'b00000000;
    wire [7:0] _60 = 8'b00000000;
    wire [7:0] _56;
    reg [7:0] _61;
    wire _63;
    wire _64;
    wire [7:0] _65 = 8'b00000000;
    wire [7:0] _66 = 8'b00000000;
    wire [7:0] _62;
    reg [7:0] _67;
    wire _69;
    wire _70;
    wire [7:0] _71 = 8'b00000000;
    wire [7:0] _72 = 8'b00000000;
    wire [7:0] _68;
    reg [7:0] _73;
    wire [3:0] _49;
    wire _75;
    wire [31:0] _54 = 32'b00000000000000000000000000000000;
    wire _55;
    wire _76;
    wire [7:0] _77 = 8'b00000000;
    wire vdd = 1'b1;
    wire [7:0] _78 = 8'b00000000;
    wire [7:0] _74;
    reg [7:0] _79;
    wire [31:0] _80;
    wire [31:0] _53;
    wire [29:0] _163;
    reg [31:0] _164;
    wire [31:0] _44;
    wire _40;
    wire _45;
    wire [1:0] _39;
    wire _41;
    wire _46;
    wire [69:0] _48;
    wire [31:0] _50;
    wire [7:0] _155;
    reg [7:0] _160;
    wire [31:0] _161;
    wire [7:0] _165;

    /* logic */
    assign _138 = _49[0:0];
    assign _139 = _136 & _138;
    assign _137 = _50[7:0];
    always @(posedge _41) begin
        if (_139)
            _142 <= _137;
    end
    assign _144 = _49[1:1];
    assign _145 = _136 & _144;
    assign _143 = _50[15:8];
    always @(posedge _41) begin
        if (_145)
            _148 <= _143;
    end
    assign _150 = _49[2:2];
    assign _151 = _136 & _150;
    assign _149 = _50[23:16];
    always @(posedge _41) begin
        if (_151)
            _154 <= _149;
    end
    assign _156 = _49[3:3];
    assign _136 = _53 == _135;
    assign _157 = _136 & _156;
    assign _42 = vdd;
    assign _43 = gnd;
    assign _111 = _49[0:0];
    assign _112 = _109 & _111;
    assign _110 = _50[7:0];
    always @(posedge _41) begin
        if (_112)
            _115 <= _110;
    end
    assign _117 = _49[1:1];
    assign _118 = _109 & _117;
    assign _116 = _50[15:8];
    always @(posedge _41) begin
        if (_118)
            _121 <= _116;
    end
    assign _123 = _49[2:2];
    assign _124 = _109 & _123;
    assign _122 = _50[23:16];
    always @(posedge _41) begin
        if (_124)
            _127 <= _122;
    end
    assign _129 = _49[3:3];
    assign _109 = _53 == _108;
    assign _130 = _109 & _129;
    assign _128 = _50[31:24];
    always @(posedge _41) begin
        if (_130)
            _133 <= _128;
    end
    assign _134 = { _133, _127, _121, _115 };
    assign _84 = _49[0:0];
    assign _85 = _82 & _84;
    assign _83 = _50[7:0];
    always @(posedge _41) begin
        if (_85)
            _88 <= _83;
    end
    assign _90 = _49[1:1];
    assign _91 = _82 & _90;
    assign _89 = _50[15:8];
    always @(posedge _41) begin
        if (_91)
            _94 <= _89;
    end
    assign _96 = _49[2:2];
    assign _97 = _82 & _96;
    assign _95 = _50[23:16];
    always @(posedge _41) begin
        if (_97)
            _100 <= _95;
    end
    assign _102 = _49[3:3];
    assign _82 = _53 == _81;
    assign _103 = _82 & _102;
    assign _101 = _50[31:24];
    always @(posedge _41) begin
        if (_103)
            _106 <= _101;
    end
    assign _107 = { _106, _100, _94, _88 };
    assign _57 = _49[0:0];
    assign _58 = _55 & _57;
    assign _56 = _50[7:0];
    always @(posedge _41) begin
        if (_58)
            _61 <= _56;
    end
    assign _63 = _49[1:1];
    assign _64 = _55 & _63;
    assign _62 = _50[15:8];
    always @(posedge _41) begin
        if (_64)
            _67 <= _62;
    end
    assign _69 = _49[2:2];
    assign _70 = _55 & _69;
    assign _68 = _50[23:16];
    always @(posedge _41) begin
        if (_70)
            _73 <= _68;
    end
    assign _49 = _48[69:66];
    assign _75 = _49[3:3];
    assign _55 = _53 == _54;
    assign _76 = _55 & _75;
    assign _74 = _50[31:24];
    always @(posedge _41) begin
        if (_76)
            _79 <= _74;
    end
    assign _80 = { _79, _73, _67, _61 };
    assign _53 = _48[31:0];
    assign _163 = _53[31:2];
    always @* begin
        case (_163)
        0: _164 <= _80;
        1: _164 <= _107;
        2: _164 <= _134;
        3: _164 <= _161;
        default: _164 <= _162;
        endcase
    end
    assign _44 = _164;
    assign _40 = _39[1:1];
    assign _45 = _40;
    pll50
        the_pll50
        ( .inclk0(CLOCK_50), .locked(_39[1:1]), .c0(_39[0:0]) );
    assign _41 = _39[0:0];
    assign _46 = _41;
    vjtag_mm
        the_vjtag_mm
        ( .clk_clk(_46), .reset_reset_n(_45), .vjtag_mm_readdata(_44), .vjtag_mm_waitrequest(_43), .vjtag_mm_readdatavalid(_42), .vjtag_mm_byteenable(_48[69:66]), .vjtag_mm_writedata(_48[65:34]), .vjtag_mm_write(_48[33:33]), .vjtag_mm_read(_48[32:32]), .vjtag_mm_address(_48[31:0]) );
    assign _50 = _48[65:34];
    assign _155 = _50[31:24];
    always @(posedge _41) begin
        if (_157)
            _160 <= _155;
    end
    assign _161 = { _160, _154, _148, _142 };
    assign _165 = _161[7:0];

    /* aliases */

    /* output assignments */
    assign LED = _165;

endmodule
