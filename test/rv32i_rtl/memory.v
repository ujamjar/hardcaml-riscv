module memory (
    junk_p_2,
    alu_cmp_p_2,
    alu_p_2,
    fclass_p_2,
    is_p_2,
    insn_p_2,
    instr_p_2,
    next_pc_p_2,
    pc_p_2,
    imm_p_2,
    rdd_p_2,
    rd2_p_2,
    rd1_p_2,
    rad_zero_p_2,
    ra2_zero_p_2,
    ra1_zero_p_2,
    rad_p_2,
    ra2_p_2,
    ra1_p_2,
    clr,
    clk,
    pen_p_2,
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

    input junk_p_2;
    input alu_cmp_p_2;
    input [31:0] alu_p_2;
    input [5:0] fclass_p_2;
    input [14:0] is_p_2;
    input [47:0] insn_p_2;
    input [31:0] instr_p_2;
    input [31:0] next_pc_p_2;
    input [31:0] pc_p_2;
    input [31:0] imm_p_2;
    input [31:0] rdd_p_2;
    input [31:0] rd2_p_2;
    input [31:0] rd1_p_2;
    input rad_zero_p_2;
    input ra2_zero_p_2;
    input ra1_zero_p_2;
    input [4:0] rad_p_2;
    input [4:0] ra2_p_2;
    input [4:0] ra1_p_2;
    input clr;
    input clk;
    input pen_p_2;
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
    wire _6080 = 1'b0;
    wire _6081 = 1'b0;
    wire _5365 = 1'b0;
    wire _5366 = 1'b0;
    reg _5367;
    reg _6082;
    wire _6076 = 1'b0;
    wire _6077 = 1'b0;
    wire _5369 = 1'b0;
    wire _5370 = 1'b0;
    reg _5371;
    reg _6078;
    wire [31:0] _6072 = 32'b00000000000000000000000000000000;
    wire [31:0] _6073 = 32'b00000000000000000000000000000000;
    wire [31:0] _5373 = 32'b00000000000000000000000000000000;
    wire [31:0] _5374 = 32'b00000000000000000000000000000000;
    reg [31:0] _5375;
    reg [31:0] _6074;
    wire [5:0] _6068 = 6'b000000;
    wire [5:0] _6069 = 6'b000000;
    wire [5:0] _5377 = 6'b000000;
    wire [5:0] _5378 = 6'b000000;
    reg [5:0] _5379;
    reg [5:0] _6070;
    wire [14:0] _6064 = 15'b000000000000000;
    wire [14:0] _6065 = 15'b000000000000000;
    wire [14:0] _5381 = 15'b000000000000000;
    wire [14:0] _5382 = 15'b000000000000000;
    reg [14:0] _5383;
    reg [14:0] _6066;
    wire [47:0] _6060 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _6061 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _5385 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _5386 = 48'b000000000000000000000000000000000000000000000000;
    reg [47:0] _5387;
    reg [47:0] _6062;
    wire [31:0] _6056 = 32'b00000000000000000000000000000000;
    wire [31:0] _6057 = 32'b00000000000000000000000000000000;
    wire [31:0] _5389 = 32'b00000000000000000000000000000000;
    wire [31:0] _5390 = 32'b00000000000000000000000000000000;
    reg [31:0] _5391;
    reg [31:0] _6058;
    wire [31:0] _6052 = 32'b00000000000000000000000000000000;
    wire [31:0] _6053 = 32'b00000000000000000000000000000000;
    wire [31:0] _5393 = 32'b00000000000000000000000000000000;
    wire [31:0] _5394 = 32'b00000000000000000000000000000000;
    reg [31:0] _5395;
    reg [31:0] _6054;
    wire [31:0] _6048 = 32'b00000000000000000000000000000000;
    wire [31:0] _6049 = 32'b00000000000000000000000000000000;
    wire [31:0] _5397 = 32'b00000000000000000000000000000000;
    wire [31:0] _5398 = 32'b00000000000000000000000000000000;
    reg [31:0] _5399;
    reg [31:0] _6050;
    wire [31:0] _6044 = 32'b00000000000000000000000000000000;
    wire [31:0] _6045 = 32'b00000000000000000000000000000000;
    wire [31:0] _5401 = 32'b00000000000000000000000000000000;
    wire [31:0] _5402 = 32'b00000000000000000000000000000000;
    reg [31:0] _5403;
    reg [31:0] _6046;
    wire [31:0] _6040 = 32'b00000000000000000000000000000000;
    wire [31:0] _6041 = 32'b00000000000000000000000000000000;
    wire [31:0] _5405 = 32'b00000000000000000000000000000000;
    wire [31:0] _5406 = 32'b00000000000000000000000000000000;
    reg [31:0] _5407;
    reg [31:0] _6042;
    wire [31:0] _6036 = 32'b00000000000000000000000000000000;
    wire [31:0] _6037 = 32'b00000000000000000000000000000000;
    wire [31:0] _5409 = 32'b00000000000000000000000000000000;
    wire [31:0] _5410 = 32'b00000000000000000000000000000000;
    reg [31:0] _5411;
    reg [31:0] _6038;
    wire [31:0] _6032 = 32'b00000000000000000000000000000000;
    wire [31:0] _6033 = 32'b00000000000000000000000000000000;
    wire [31:0] _5413 = 32'b00000000000000000000000000000000;
    wire [31:0] _5414 = 32'b00000000000000000000000000000000;
    reg [31:0] _5415;
    reg [31:0] _6034;
    wire _6028 = 1'b0;
    wire _6029 = 1'b0;
    wire _5417 = 1'b0;
    wire _5418 = 1'b0;
    reg _5419;
    reg _6030;
    wire _6024 = 1'b0;
    wire _6025 = 1'b0;
    wire _5421 = 1'b0;
    wire _5422 = 1'b0;
    reg _5423;
    reg _6026;
    wire _6020 = 1'b0;
    wire _6021 = 1'b0;
    wire _5425 = 1'b0;
    wire _5426 = 1'b0;
    reg _5427;
    reg _6022;
    wire [4:0] _6016 = 5'b00000;
    wire [4:0] _6017 = 5'b00000;
    wire [4:0] _5429 = 5'b00000;
    wire [4:0] _5430 = 5'b00000;
    reg [4:0] _5431;
    reg [4:0] _6018;
    wire [4:0] _6012 = 5'b00000;
    wire [4:0] _6013 = 5'b00000;
    wire [4:0] _5433 = 5'b00000;
    wire [4:0] _5434 = 5'b00000;
    reg [4:0] _5435;
    reg [4:0] _6014;
    wire [4:0] _6008 = 5'b00000;
    wire [4:0] _6009 = 5'b00000;
    wire [4:0] _5437 = 5'b00000;
    wire [4:0] _5438 = 5'b00000;
    reg [4:0] _5439;
    reg [4:0] _6010;
    wire _6004 = 1'b0;
    wire _6005 = 1'b0;
    wire _5441 = 1'b0;
    wire vdd = 1'b1;
    wire _5442 = 1'b0;
    reg _5443;
    reg _6006;

    /* logic */
    always @(posedge clk) begin
        if (clr)
            _5367 <= _5365;
        else
            _5367 <= junk_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6082 <= _6080;
        else
            _6082 <= _5367;
    end
    always @(posedge clk) begin
        if (clr)
            _5371 <= _5369;
        else
            _5371 <= alu_cmp_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6078 <= _6076;
        else
            _6078 <= _5371;
    end
    always @(posedge clk) begin
        if (clr)
            _5375 <= _5373;
        else
            _5375 <= alu_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6074 <= _6072;
        else
            _6074 <= _5375;
    end
    always @(posedge clk) begin
        if (clr)
            _5379 <= _5377;
        else
            _5379 <= fclass_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6070 <= _6068;
        else
            _6070 <= _5379;
    end
    always @(posedge clk) begin
        if (clr)
            _5383 <= _5381;
        else
            _5383 <= is_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6066 <= _6064;
        else
            _6066 <= _5383;
    end
    always @(posedge clk) begin
        if (clr)
            _5387 <= _5385;
        else
            _5387 <= insn_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6062 <= _6060;
        else
            _6062 <= _5387;
    end
    always @(posedge clk) begin
        if (clr)
            _5391 <= _5389;
        else
            _5391 <= instr_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6058 <= _6056;
        else
            _6058 <= _5391;
    end
    always @(posedge clk) begin
        if (clr)
            _5395 <= _5393;
        else
            _5395 <= next_pc_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6054 <= _6052;
        else
            _6054 <= _5395;
    end
    always @(posedge clk) begin
        if (clr)
            _5399 <= _5397;
        else
            _5399 <= pc_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6050 <= _6048;
        else
            _6050 <= _5399;
    end
    always @(posedge clk) begin
        if (clr)
            _5403 <= _5401;
        else
            _5403 <= imm_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6046 <= _6044;
        else
            _6046 <= _5403;
    end
    always @(posedge clk) begin
        if (clr)
            _5407 <= _5405;
        else
            _5407 <= rdd_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6042 <= _6040;
        else
            _6042 <= _5407;
    end
    always @(posedge clk) begin
        if (clr)
            _5411 <= _5409;
        else
            _5411 <= rd2_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6038 <= _6036;
        else
            _6038 <= _5411;
    end
    always @(posedge clk) begin
        if (clr)
            _5415 <= _5413;
        else
            _5415 <= rd1_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6034 <= _6032;
        else
            _6034 <= _5415;
    end
    always @(posedge clk) begin
        if (clr)
            _5419 <= _5417;
        else
            _5419 <= rad_zero_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6030 <= _6028;
        else
            _6030 <= _5419;
    end
    always @(posedge clk) begin
        if (clr)
            _5423 <= _5421;
        else
            _5423 <= ra2_zero_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6026 <= _6024;
        else
            _6026 <= _5423;
    end
    always @(posedge clk) begin
        if (clr)
            _5427 <= _5425;
        else
            _5427 <= ra1_zero_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6022 <= _6020;
        else
            _6022 <= _5427;
    end
    always @(posedge clk) begin
        if (clr)
            _5431 <= _5429;
        else
            _5431 <= rad_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6018 <= _6016;
        else
            _6018 <= _5431;
    end
    always @(posedge clk) begin
        if (clr)
            _5435 <= _5433;
        else
            _5435 <= ra2_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6014 <= _6012;
        else
            _6014 <= _5435;
    end
    always @(posedge clk) begin
        if (clr)
            _5439 <= _5437;
        else
            _5439 <= ra1_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6010 <= _6008;
        else
            _6010 <= _5439;
    end
    always @(posedge clk) begin
        if (clr)
            _5443 <= _5441;
        else
            _5443 <= pen_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6006 <= _6004;
        else
            _6006 <= _5443;
    end

    /* aliases */

    /* output assignments */
    assign pen = _6006;
    assign ra1 = _6010;
    assign ra2 = _6014;
    assign rad = _6018;
    assign ra1_zero = _6022;
    assign ra2_zero = _6026;
    assign rad_zero = _6030;
    assign rd1 = _6034;
    assign rd2 = _6038;
    assign rdd = _6042;
    assign imm = _6046;
    assign pc = _6050;
    assign next_pc = _6054;
    assign instr = _6058;
    assign insn = _6062;
    assign is = _6066;
    assign fclass = _6070;
    assign alu = _6074;
    assign alu_cmp = _6078;
    assign junk = _6082;

endmodule
