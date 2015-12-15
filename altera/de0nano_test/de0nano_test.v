module de0nano_test (
    CLOCK_50,
    LED
);

    input CLOCK_50;
    output [7:0] LED;

    /* signal declarations */
    wire _269;
    wire _270;
    wire _271;
    wire [7:0] _272 = 8'b00000000;
    wire [7:0] _273 = 8'b00000000;
    wire [7:0] _268;
    reg [7:0] _274;
    wire _276;
    wire _277;
    wire _278;
    wire [7:0] _279 = 8'b00000000;
    wire [7:0] _280 = 8'b00000000;
    wire [7:0] _275;
    reg [7:0] _281;
    wire _283;
    wire _284;
    wire _285;
    wire [7:0] _286 = 8'b00000000;
    wire [7:0] _287 = 8'b00000000;
    wire [7:0] _282;
    reg [7:0] _288;
    wire _290;
    wire [31:0] _179 = 32'b00000000000000000000000000001100;
    wire _180;
    wire _291;
    wire _292;
    wire [7:0] _293 = 8'b00000000;
    wire [7:0] _294 = 8'b00000000;
    wire _161;
    wire gnd = 1'b0;
    wire _162;
    wire [31:0] _297 = 32'b11011110101011011011111011101111;
    wire _240;
    wire _241;
    wire _242;
    wire [7:0] _243 = 8'b00000000;
    wire [7:0] _244 = 8'b00000000;
    wire [7:0] _239;
    reg [7:0] _245;
    wire _247;
    wire _248;
    wire _249;
    wire [7:0] _250 = 8'b00000000;
    wire [7:0] _251 = 8'b00000000;
    wire [7:0] _246;
    reg [7:0] _252;
    wire _254;
    wire _255;
    wire _256;
    wire [7:0] _257 = 8'b00000000;
    wire [7:0] _258 = 8'b00000000;
    wire [7:0] _253;
    reg [7:0] _259;
    wire _261;
    wire [31:0] _177 = 32'b00000000000000000000000000001000;
    wire _178;
    wire _262;
    wire _263;
    wire [7:0] _264 = 8'b00000000;
    wire [7:0] _265 = 8'b00000000;
    wire [7:0] _260;
    reg [7:0] _266;
    wire [31:0] _267;
    wire _211;
    wire _212;
    wire _213;
    wire [7:0] _214 = 8'b00000000;
    wire [7:0] _215 = 8'b00000000;
    wire [7:0] _210;
    reg [7:0] _216;
    wire _218;
    wire _219;
    wire _220;
    wire [7:0] _221 = 8'b00000000;
    wire [7:0] _222 = 8'b00000000;
    wire [7:0] _217;
    reg [7:0] _223;
    wire _225;
    wire _226;
    wire _227;
    wire [7:0] _228 = 8'b00000000;
    wire [7:0] _229 = 8'b00000000;
    wire [7:0] _224;
    reg [7:0] _230;
    wire _232;
    wire [31:0] _175 = 32'b00000000000000000000000000000100;
    wire _176;
    wire _233;
    wire _234;
    wire [7:0] _235 = 8'b00000000;
    wire [7:0] _236 = 8'b00000000;
    wire [7:0] _231;
    reg [7:0] _237;
    wire [31:0] _238;
    wire _182;
    wire _183;
    wire _184;
    wire [7:0] _185 = 8'b00000000;
    wire [7:0] _186 = 8'b00000000;
    wire [7:0] _181;
    reg [7:0] _187;
    wire _189;
    wire _190;
    wire _191;
    wire [7:0] _192 = 8'b00000000;
    wire [7:0] _193 = 8'b00000000;
    wire [7:0] _188;
    reg [7:0] _194;
    wire _196;
    wire _197;
    wire _198;
    wire [7:0] _199 = 8'b00000000;
    wire [7:0] _200 = 8'b00000000;
    wire [7:0] _195;
    reg [7:0] _201;
    wire [3:0] _168;
    wire _203;
    wire [31:0] _173 = 32'b00000000000000000000000000000000;
    wire _174;
    wire _170;
    wire _204;
    wire _205;
    wire [7:0] _206 = 8'b00000000;
    wire vdd = 1'b1;
    wire [7:0] _207 = 8'b00000000;
    wire [7:0] _202;
    reg [7:0] _208;
    wire [31:0] _209;
    wire [31:0] _172;
    wire [29:0] _298;
    reg [31:0] _299;
    wire [31:0] _163;
    wire _159;
    wire _164;
    wire [1:0] _158;
    wire _160;
    wire _165;
    wire [69:0] _167;
    wire [31:0] _169;
    wire [7:0] _289;
    reg [7:0] _295;
    wire [31:0] _296;
    wire [7:0] _300;

    /* logic */
    assign _269 = _168[0:0];
    assign _270 = _170 & _180;
    assign _271 = _270 & _269;
    assign _268 = _169[7:0];
    always @(posedge _160) begin
        if (_271)
            _274 <= _268;
    end
    assign _276 = _168[1:1];
    assign _277 = _170 & _180;
    assign _278 = _277 & _276;
    assign _275 = _169[15:8];
    always @(posedge _160) begin
        if (_278)
            _281 <= _275;
    end
    assign _283 = _168[2:2];
    assign _284 = _170 & _180;
    assign _285 = _284 & _283;
    assign _282 = _169[23:16];
    always @(posedge _160) begin
        if (_285)
            _288 <= _282;
    end
    assign _290 = _168[3:3];
    assign _180 = _172 == _179;
    assign _291 = _170 & _180;
    assign _292 = _291 & _290;
    assign _161 = vdd;
    assign _162 = gnd;
    assign _240 = _168[0:0];
    assign _241 = _170 & _178;
    assign _242 = _241 & _240;
    assign _239 = _169[7:0];
    always @(posedge _160) begin
        if (_242)
            _245 <= _239;
    end
    assign _247 = _168[1:1];
    assign _248 = _170 & _178;
    assign _249 = _248 & _247;
    assign _246 = _169[15:8];
    always @(posedge _160) begin
        if (_249)
            _252 <= _246;
    end
    assign _254 = _168[2:2];
    assign _255 = _170 & _178;
    assign _256 = _255 & _254;
    assign _253 = _169[23:16];
    always @(posedge _160) begin
        if (_256)
            _259 <= _253;
    end
    assign _261 = _168[3:3];
    assign _178 = _172 == _177;
    assign _262 = _170 & _178;
    assign _263 = _262 & _261;
    assign _260 = _169[31:24];
    always @(posedge _160) begin
        if (_263)
            _266 <= _260;
    end
    assign _267 = { _266, _259, _252, _245 };
    assign _211 = _168[0:0];
    assign _212 = _170 & _176;
    assign _213 = _212 & _211;
    assign _210 = _169[7:0];
    always @(posedge _160) begin
        if (_213)
            _216 <= _210;
    end
    assign _218 = _168[1:1];
    assign _219 = _170 & _176;
    assign _220 = _219 & _218;
    assign _217 = _169[15:8];
    always @(posedge _160) begin
        if (_220)
            _223 <= _217;
    end
    assign _225 = _168[2:2];
    assign _226 = _170 & _176;
    assign _227 = _226 & _225;
    assign _224 = _169[23:16];
    always @(posedge _160) begin
        if (_227)
            _230 <= _224;
    end
    assign _232 = _168[3:3];
    assign _176 = _172 == _175;
    assign _233 = _170 & _176;
    assign _234 = _233 & _232;
    assign _231 = _169[31:24];
    always @(posedge _160) begin
        if (_234)
            _237 <= _231;
    end
    assign _238 = { _237, _230, _223, _216 };
    assign _182 = _168[0:0];
    assign _183 = _170 & _174;
    assign _184 = _183 & _182;
    assign _181 = _169[7:0];
    always @(posedge _160) begin
        if (_184)
            _187 <= _181;
    end
    assign _189 = _168[1:1];
    assign _190 = _170 & _174;
    assign _191 = _190 & _189;
    assign _188 = _169[15:8];
    always @(posedge _160) begin
        if (_191)
            _194 <= _188;
    end
    assign _196 = _168[2:2];
    assign _197 = _170 & _174;
    assign _198 = _197 & _196;
    assign _195 = _169[23:16];
    always @(posedge _160) begin
        if (_198)
            _201 <= _195;
    end
    assign _168 = _167[69:66];
    assign _203 = _168[3:3];
    assign _174 = _172 == _173;
    assign _170 = _167[33:33];
    assign _204 = _170 & _174;
    assign _205 = _204 & _203;
    assign _202 = _169[31:24];
    always @(posedge _160) begin
        if (_205)
            _208 <= _202;
    end
    assign _209 = { _208, _201, _194, _187 };
    assign _172 = _167[31:0];
    assign _298 = _172[31:2];
    always @* begin
        case (_298)
        0: _299 <= _209;
        1: _299 <= _238;
        2: _299 <= _267;
        3: _299 <= _296;
        default: _299 <= _297;
        endcase
    end
    assign _163 = _299;
    assign _159 = _158[1:1];
    assign _164 = _159;
    pll50
        the_pll50
        ( .inclk0(CLOCK_50), .locked(_158[1:1]), .c0(_158[0:0]) );
    assign _160 = _158[0:0];
    assign _165 = _160;
    vjtag_mm
        the_vjtag_mm
        ( .clk_clk(_165), .reset_reset_n(_164), .vjtag_mm_readdata(_163), .vjtag_mm_waitrequest(_162), .vjtag_mm_readdatavalid(_161), .vjtag_mm_byteenable(_167[69:66]), .vjtag_mm_writedata(_167[65:34]), .vjtag_mm_write(_167[33:33]), .vjtag_mm_read(_167[32:32]), .vjtag_mm_address(_167[31:0]) );
    assign _169 = _167[65:34];
    assign _289 = _169[31:24];
    always @(posedge _160) begin
        if (_292)
            _295 <= _289;
    end
    assign _296 = { _295, _288, _281, _274 };
    assign _300 = _296[7:0];

    /* aliases */

    /* output assignments */
    assign LED = _300;

endmodule
