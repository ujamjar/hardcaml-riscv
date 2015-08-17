module alu (
    junk_p_1,
    rd2_p_2,
    rd1_p_2,
    insn_p_2,
    is_p_2,
    fclass_p_1,
    is_p_1,
    insn_p_1,
    instr_p_1,
    next_pc_p_1,
    pc_p_1,
    imm_p_1,
    rdd_p_1,
    rd2_p_1,
    rd1_p_1,
    rad_zero_p_1,
    ra2_zero_p_1,
    ra1_zero_p_1,
    rad_p_1,
    ra2_p_1,
    ra1_p_1,
    clr,
    clk,
    pen_p_1,
    pen,
    ra1,
    ra2,
    rad,
    ra1_zero,
    ra2_zero,
    rad_zero,
    rd1,
    rd2,
    rdd,
    imm,
    pc,
    next_pc,
    instr,
    insn,
    is,
    fclass,
    alu,
    alu_cmp,
    junk
);

    input junk_p_1;
    input [31:0] rd2_p_2;
    input [31:0] rd1_p_2;
    input [47:0] insn_p_2;
    input [14:0] is_p_2;
    input [5:0] fclass_p_1;
    input [14:0] is_p_1;
    input [47:0] insn_p_1;
    input [31:0] instr_p_1;
    input [31:0] next_pc_p_1;
    input [31:0] pc_p_1;
    input [31:0] imm_p_1;
    input [31:0] rdd_p_1;
    input [31:0] rd2_p_1;
    input [31:0] rd1_p_1;
    input rad_zero_p_1;
    input ra2_zero_p_1;
    input ra1_zero_p_1;
    input [4:0] rad_p_1;
    input [4:0] ra2_p_1;
    input [4:0] ra1_p_1;
    input clr;
    input clk;
    input pen_p_1;
    output pen;
    output [4:0] ra1;
    output [4:0] ra2;
    output [4:0] rad;
    output ra1_zero;
    output ra2_zero;
    output rad_zero;
    output [31:0] rd1;
    output [31:0] rd2;
    output [31:0] rdd;
    output [31:0] imm;
    output [31:0] pc;
    output [31:0] next_pc;
    output [31:0] instr;
    output [47:0] insn;
    output [14:0] is;
    output [5:0] fclass;
    output [31:0] alu;
    output alu_cmp;
    output junk;

    /* signal declarations */
    wire _5196 = 1'b0;
    wire _5197 = 1'b0;
    wire _4323 = 1'b0;
    wire _4324 = 1'b0;
    reg _4325;
    reg _5198;
    wire _5192 = 1'b0;
    wire _5193 = 1'b0;
    reg _5194;
    wire [31:0] _5188 = 32'b00000000000000000000000000000000;
    wire [31:0] _5189 = 32'b00000000000000000000000000000000;
    wire [31:0] _5108;
    wire [31:0] _5106;
    wire [31:0] _5114;
    wire _5071;
    wire _5068;
    wire _5069;
    wire _5077;
    wire [30:0] _5057;
    wire _5058;
    wire _5059;
    wire [31:0] _5060;
    wire [30:0] _5061;
    wire _5062;
    wire _5063;
    wire [31:0] _5064;
    wire _5065;
    wire _5066;
    wire _5054;
    wire _5055;
    wire _5075;
    wire _5079;
    wire [30:0] _5044;
    wire _5045;
    wire _5046;
    wire [31:0] _5047;
    wire [30:0] _5048;
    wire _5049;
    wire _5050;
    wire [31:0] _5051;
    wire _5052;
    wire _5042;
    wire _5053;
    wire _5073;
    wire _5056;
    wire _5067;
    wire _5076;
    wire _5070;
    wire _5072;
    wire _5078;
    wire _5080;
    wire _5081;
    wire [30:0] _5102 = 31'b0000000000000000000000000000000;
    wire [31:0] _5104;
    wire [31:0] _5091;
    wire [31:0] _5112;
    wire [31:0] _5116;
    wire [31:0] _5087;
    wire [31:0] _4447 = 32'b00000000000000000000000000000000;
    wire [31:0] _4448 = 32'b00000000000000000000000000000000;
    reg [31:0] _4449;
    wire [31:0] _4451 = 32'b00000000000000000000000000000000;
    wire [31:0] _4452 = 32'b00000000000000000000000000000000;
    reg [31:0] _4453;
    wire [31:0] _5083;
    wire _5088;
    wire _5089;
    wire _5090;
    wire [31:0] _5110;
    wire _5092;
    wire _5093;
    wire _5094;
    wire _5105;
    wire _5113;
    wire [47:0] _4423 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _4424 = 48'b000000000000000000000000000000000000000000000000;
    reg [47:0] _4425;
    wire _5107;
    wire [14:0] _4419 = 15'b000000000000000;
    wire [14:0] _4420 = 15'b000000000000000;
    reg [14:0] _4421;
    wire _5109;
    wire _5115;
    wire _5117;
    wire [31:0] _5118;
    reg [31:0] _5190;
    wire [5:0] _5184 = 6'b000000;
    wire [5:0] _5185 = 6'b000000;
    wire [5:0] _4335 = 6'b000000;
    wire [5:0] _4336 = 6'b000000;
    reg [5:0] _4337;
    reg [5:0] _5186;
    wire [14:0] _5180 = 15'b000000000000000;
    wire [14:0] _5181 = 15'b000000000000000;
    wire [14:0] _4339 = 15'b000000000000000;
    wire [14:0] _4340 = 15'b000000000000000;
    reg [14:0] _4341;
    reg [14:0] _5182;
    wire [47:0] _5176 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _5177 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _4343 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _4344 = 48'b000000000000000000000000000000000000000000000000;
    reg [47:0] _4345;
    reg [47:0] _5178;
    wire [31:0] _5172 = 32'b00000000000000000000000000000000;
    wire [31:0] _5173 = 32'b00000000000000000000000000000000;
    wire [31:0] _4347 = 32'b00000000000000000000000000000000;
    wire [31:0] _4348 = 32'b00000000000000000000000000000000;
    reg [31:0] _4349;
    reg [31:0] _5174;
    wire [31:0] _5168 = 32'b00000000000000000000000000000000;
    wire [31:0] _5169 = 32'b00000000000000000000000000000000;
    wire [31:0] _4351 = 32'b00000000000000000000000000000000;
    wire [31:0] _4352 = 32'b00000000000000000000000000000000;
    reg [31:0] _4353;
    reg [31:0] _5170;
    wire [31:0] _5164 = 32'b00000000000000000000000000000000;
    wire [31:0] _5165 = 32'b00000000000000000000000000000000;
    wire [31:0] _4355 = 32'b00000000000000000000000000000000;
    wire [31:0] _4356 = 32'b00000000000000000000000000000000;
    reg [31:0] _4357;
    reg [31:0] _5166;
    wire [31:0] _5160 = 32'b00000000000000000000000000000000;
    wire [31:0] _5161 = 32'b00000000000000000000000000000000;
    wire [31:0] _4359 = 32'b00000000000000000000000000000000;
    wire [31:0] _4360 = 32'b00000000000000000000000000000000;
    reg [31:0] _4361;
    reg [31:0] _5162;
    wire [31:0] _5156 = 32'b00000000000000000000000000000000;
    wire [31:0] _5157 = 32'b00000000000000000000000000000000;
    wire [31:0] _4363 = 32'b00000000000000000000000000000000;
    wire [31:0] _4364 = 32'b00000000000000000000000000000000;
    reg [31:0] _4365;
    reg [31:0] _5158;
    wire [31:0] _5152 = 32'b00000000000000000000000000000000;
    wire [31:0] _5153 = 32'b00000000000000000000000000000000;
    wire [31:0] _4367 = 32'b00000000000000000000000000000000;
    wire [31:0] _4368 = 32'b00000000000000000000000000000000;
    reg [31:0] _4369;
    reg [31:0] _5154;
    wire [31:0] _5148 = 32'b00000000000000000000000000000000;
    wire [31:0] _5149 = 32'b00000000000000000000000000000000;
    wire [31:0] _4371 = 32'b00000000000000000000000000000000;
    wire [31:0] _4372 = 32'b00000000000000000000000000000000;
    reg [31:0] _4373;
    reg [31:0] _5150;
    wire _5144 = 1'b0;
    wire _5145 = 1'b0;
    wire _4375 = 1'b0;
    wire _4376 = 1'b0;
    reg _4377;
    reg _5146;
    wire _5140 = 1'b0;
    wire _5141 = 1'b0;
    wire _4379 = 1'b0;
    wire _4380 = 1'b0;
    reg _4381;
    reg _5142;
    wire _5136 = 1'b0;
    wire _5137 = 1'b0;
    wire _4383 = 1'b0;
    wire _4384 = 1'b0;
    reg _4385;
    reg _5138;
    wire [4:0] _5132 = 5'b00000;
    wire [4:0] _5133 = 5'b00000;
    wire [4:0] _4387 = 5'b00000;
    wire [4:0] _4388 = 5'b00000;
    reg [4:0] _4389;
    reg [4:0] _5134;
    wire [4:0] _5128 = 5'b00000;
    wire [4:0] _5129 = 5'b00000;
    wire [4:0] _4391 = 5'b00000;
    wire [4:0] _4392 = 5'b00000;
    reg [4:0] _4393;
    reg [4:0] _5130;
    wire [4:0] _5124 = 5'b00000;
    wire [4:0] _5125 = 5'b00000;
    wire [4:0] _4395 = 5'b00000;
    wire [4:0] _4396 = 5'b00000;
    reg [4:0] _4397;
    reg [4:0] _5126;
    wire _5120 = 1'b0;
    wire _5121 = 1'b0;
    wire _4399 = 1'b0;
    wire vdd = 1'b1;
    wire _4400 = 1'b0;
    reg _4401;
    reg _5122;

    /* logic */
    always @(posedge clk) begin
        if (clr)
            _4325 <= _4323;
        else
            _4325 <= junk_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5198 <= _5196;
        else
            _5198 <= _4325;
    end
    always @(posedge clk) begin
        if (clr)
            _5194 <= _5192;
        else
            _5194 <= _5081;
    end
    assign _5108 = _4453 + _4449;
    assign _5106 = _4453 - _4449;
    assign _5114 = _5109 ? _5108 : _5106;
    assign _5071 = _4453 == _4449;
    assign _5068 = _4453 == _4449;
    assign _5069 = ~ _5068;
    assign _5077 = _5072 ? _5071 : _5069;
    assign _5057 = _4449[30:0];
    assign _5058 = _4449[31:31];
    assign _5059 = ~ _5058;
    assign _5060 = { _5059, _5057 };
    assign _5061 = _4453[30:0];
    assign _5062 = _4453[31:31];
    assign _5063 = ~ _5062;
    assign _5064 = { _5063, _5061 };
    assign _5065 = _5064 < _5060;
    assign _5066 = ~ _5065;
    assign _5054 = _4453 < _4449;
    assign _5055 = ~ _5054;
    assign _5075 = _5067 ? _5066 : _5055;
    assign _5079 = _5078 ? _5077 : _5075;
    assign _5044 = _4449[30:0];
    assign _5045 = _4449[31:31];
    assign _5046 = ~ _5045;
    assign _5047 = { _5046, _5044 };
    assign _5048 = _4453[30:0];
    assign _5049 = _4453[31:31];
    assign _5050 = ~ _5049;
    assign _5051 = { _5050, _5048 };
    assign _5052 = _5051 < _5047;
    assign _5042 = _4453 < _4449;
    assign _5053 = _4421[7:7];
    assign _5073 = _5053 ? _5052 : _5042;
    assign _5056 = _4425[9:9];
    assign _5067 = _4425[7:7];
    assign _5076 = _5067 | _5056;
    assign _5070 = _4425[5:5];
    assign _5072 = _4425[4:4];
    assign _5078 = _5072 | _5070;
    assign _5080 = _5078 | _5076;
    assign _5081 = _5080 ? _5079 : _5073;
    assign _5104 = { _5102, _5081 };
    assign _5091 = _4453 ^ _4449;
    assign _5112 = _5105 ? _5104 : _5091;
    assign _5116 = _5115 ? _5114 : _5112;
    assign _5087 = _4453 | _4449;
    always @(posedge clk) begin
        if (clr)
            _4449 <= _4447;
        else
            _4449 <= rd2_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _4453 <= _4451;
        else
            _4453 <= rd1_p_2;
    end
    assign _5083 = _4453 & _4449;
    assign _5088 = _4425[35:35];
    assign _5089 = _4425[22:22];
    assign _5090 = _5089 | _5088;
    assign _5110 = _5090 ? _5087 : _5083;
    assign _5092 = _4425[32:32];
    assign _5093 = _4425[21:21];
    assign _5094 = _5093 | _5092;
    assign _5105 = _4421[13:13];
    assign _5113 = _5105 | _5094;
    always @(posedge clk) begin
        if (clr)
            _4425 <= _4423;
        else
            _4425 <= insn_p_2;
    end
    assign _5107 = _4425[28:28];
    always @(posedge clk) begin
        if (clr)
            _4421 <= _4419;
        else
            _4421 <= is_p_2;
    end
    assign _5109 = _4421[6:6];
    assign _5115 = _5109 | _5107;
    assign _5117 = _5115 | _5113;
    assign _5118 = _5117 ? _5116 : _5110;
    always @(posedge clk) begin
        if (clr)
            _5190 <= _5188;
        else
            _5190 <= _5118;
    end
    always @(posedge clk) begin
        if (clr)
            _4337 <= _4335;
        else
            _4337 <= fclass_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5186 <= _5184;
        else
            _5186 <= _4337;
    end
    always @(posedge clk) begin
        if (clr)
            _4341 <= _4339;
        else
            _4341 <= is_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5182 <= _5180;
        else
            _5182 <= _4341;
    end
    always @(posedge clk) begin
        if (clr)
            _4345 <= _4343;
        else
            _4345 <= insn_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5178 <= _5176;
        else
            _5178 <= _4345;
    end
    always @(posedge clk) begin
        if (clr)
            _4349 <= _4347;
        else
            _4349 <= instr_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5174 <= _5172;
        else
            _5174 <= _4349;
    end
    always @(posedge clk) begin
        if (clr)
            _4353 <= _4351;
        else
            _4353 <= next_pc_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5170 <= _5168;
        else
            _5170 <= _4353;
    end
    always @(posedge clk) begin
        if (clr)
            _4357 <= _4355;
        else
            _4357 <= pc_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5166 <= _5164;
        else
            _5166 <= _4357;
    end
    always @(posedge clk) begin
        if (clr)
            _4361 <= _4359;
        else
            _4361 <= imm_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5162 <= _5160;
        else
            _5162 <= _4361;
    end
    always @(posedge clk) begin
        if (clr)
            _4365 <= _4363;
        else
            _4365 <= rdd_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5158 <= _5156;
        else
            _5158 <= _4365;
    end
    always @(posedge clk) begin
        if (clr)
            _4369 <= _4367;
        else
            _4369 <= rd2_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5154 <= _5152;
        else
            _5154 <= _4369;
    end
    always @(posedge clk) begin
        if (clr)
            _4373 <= _4371;
        else
            _4373 <= rd1_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5150 <= _5148;
        else
            _5150 <= _4373;
    end
    always @(posedge clk) begin
        if (clr)
            _4377 <= _4375;
        else
            _4377 <= rad_zero_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5146 <= _5144;
        else
            _5146 <= _4377;
    end
    always @(posedge clk) begin
        if (clr)
            _4381 <= _4379;
        else
            _4381 <= ra2_zero_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5142 <= _5140;
        else
            _5142 <= _4381;
    end
    always @(posedge clk) begin
        if (clr)
            _4385 <= _4383;
        else
            _4385 <= ra1_zero_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5138 <= _5136;
        else
            _5138 <= _4385;
    end
    always @(posedge clk) begin
        if (clr)
            _4389 <= _4387;
        else
            _4389 <= rad_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5134 <= _5132;
        else
            _5134 <= _4389;
    end
    always @(posedge clk) begin
        if (clr)
            _4393 <= _4391;
        else
            _4393 <= ra2_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5130 <= _5128;
        else
            _5130 <= _4393;
    end
    always @(posedge clk) begin
        if (clr)
            _4397 <= _4395;
        else
            _4397 <= ra1_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5126 <= _5124;
        else
            _5126 <= _4397;
    end
    always @(posedge clk) begin
        if (clr)
            _4401 <= _4399;
        else
            _4401 <= pen_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5122 <= _5120;
        else
            _5122 <= _4401;
    end

    /* aliases */

    /* output assignments */
    assign pen = _5122;
    assign ra1 = _5126;
    assign ra2 = _5130;
    assign rad = _5134;
    assign ra1_zero = _5138;
    assign ra2_zero = _5142;
    assign rad_zero = _5146;
    assign rd1 = _5150;
    assign rd2 = _5154;
    assign rdd = _5158;
    assign imm = _5162;
    assign pc = _5166;
    assign next_pc = _5170;
    assign instr = _5174;
    assign insn = _5178;
    assign is = _5182;
    assign fclass = _5186;
    assign alu = _5190;
    assign alu_cmp = _5194;
    assign junk = _5198;

endmodule
