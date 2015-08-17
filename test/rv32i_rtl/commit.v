module commit (
    junk_p_3,
    alu_cmp_p_3,
    alu_p_3,
    fclass_p_3,
    is_p_3,
    insn_p_3,
    instr_p_3,
    next_pc_p_3,
    pc_p_3,
    imm_p_3,
    rdd_p_3,
    rd2_p_3,
    rd1_p_3,
    rad_zero_p_3,
    ra2_zero_p_3,
    ra1_zero_p_3,
    rad_p_3,
    ra2_p_3,
    ra1_p_3,
    clr,
    clk,
    pen_p_3,
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

    input junk_p_3;
    input alu_cmp_p_3;
    input [31:0] alu_p_3;
    input [5:0] fclass_p_3;
    input [14:0] is_p_3;
    input [47:0] insn_p_3;
    input [31:0] instr_p_3;
    input [31:0] next_pc_p_3;
    input [31:0] pc_p_3;
    input [31:0] imm_p_3;
    input [31:0] rdd_p_3;
    input [31:0] rd2_p_3;
    input [31:0] rd1_p_3;
    input rad_zero_p_3;
    input ra2_zero_p_3;
    input ra1_zero_p_3;
    input [4:0] rad_p_3;
    input [4:0] ra2_p_3;
    input [4:0] ra1_p_3;
    input clr;
    input clk;
    input pen_p_3;
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
    wire _6964 = 1'b0;
    wire _6965 = 1'b0;
    wire _6329 = 1'b0;
    wire _6330 = 1'b0;
    reg _6331;
    reg _6966;
    wire _6960 = 1'b0;
    wire _6961 = 1'b0;
    wire _6333 = 1'b0;
    wire _6334 = 1'b0;
    reg _6335;
    reg _6962;
    wire [31:0] _6956 = 32'b00000000000000000000000000000000;
    wire [31:0] _6957 = 32'b00000000000000000000000000000000;
    wire [31:0] _6337 = 32'b00000000000000000000000000000000;
    wire [31:0] _6338 = 32'b00000000000000000000000000000000;
    reg [31:0] _6339;
    reg [31:0] _6958;
    wire [5:0] _6952 = 6'b000000;
    wire [5:0] _6953 = 6'b000000;
    wire [5:0] _6341 = 6'b000000;
    wire [5:0] _6342 = 6'b000000;
    reg [5:0] _6343;
    reg [5:0] _6954;
    wire [14:0] _6948 = 15'b000000000000000;
    wire [14:0] _6949 = 15'b000000000000000;
    wire [14:0] _6345 = 15'b000000000000000;
    wire [14:0] _6346 = 15'b000000000000000;
    reg [14:0] _6347;
    reg [14:0] _6950;
    wire [47:0] _6944 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _6945 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _6349 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _6350 = 48'b000000000000000000000000000000000000000000000000;
    reg [47:0] _6351;
    reg [47:0] _6946;
    wire [31:0] _6940 = 32'b00000000000000000000000000000000;
    wire [31:0] _6941 = 32'b00000000000000000000000000000000;
    wire [31:0] _6353 = 32'b00000000000000000000000000000000;
    wire [31:0] _6354 = 32'b00000000000000000000000000000000;
    reg [31:0] _6355;
    reg [31:0] _6942;
    wire [31:0] _6936 = 32'b00000000000000000000000000000000;
    wire [31:0] _6937 = 32'b00000000000000000000000000000000;
    wire [31:0] _6357 = 32'b00000000000000000000000000000000;
    wire [31:0] _6358 = 32'b00000000000000000000000000000000;
    reg [31:0] _6359;
    reg [31:0] _6938;
    wire [31:0] _6932 = 32'b00000000000000000000000000000000;
    wire [31:0] _6933 = 32'b00000000000000000000000000000000;
    wire [31:0] _6361 = 32'b00000000000000000000000000000000;
    wire [31:0] _6362 = 32'b00000000000000000000000000000000;
    reg [31:0] _6363;
    reg [31:0] _6934;
    wire [31:0] _6928 = 32'b00000000000000000000000000000000;
    wire [31:0] _6929 = 32'b00000000000000000000000000000000;
    wire [31:0] _6365 = 32'b00000000000000000000000000000000;
    wire [31:0] _6366 = 32'b00000000000000000000000000000000;
    reg [31:0] _6367;
    reg [31:0] _6930;
    wire [31:0] _6924 = 32'b00000000000000000000000000000000;
    wire [31:0] _6925 = 32'b00000000000000000000000000000000;
    wire [31:0] _6369 = 32'b00000000000000000000000000000000;
    wire [31:0] _6370 = 32'b00000000000000000000000000000000;
    reg [31:0] _6371;
    reg [31:0] _6926;
    wire [31:0] _6920 = 32'b00000000000000000000000000000000;
    wire [31:0] _6921 = 32'b00000000000000000000000000000000;
    wire [31:0] _6373 = 32'b00000000000000000000000000000000;
    wire [31:0] _6374 = 32'b00000000000000000000000000000000;
    reg [31:0] _6375;
    reg [31:0] _6922;
    wire [31:0] _6916 = 32'b00000000000000000000000000000000;
    wire [31:0] _6917 = 32'b00000000000000000000000000000000;
    wire [31:0] _6377 = 32'b00000000000000000000000000000000;
    wire [31:0] _6378 = 32'b00000000000000000000000000000000;
    reg [31:0] _6379;
    reg [31:0] _6918;
    wire _6912 = 1'b0;
    wire _6913 = 1'b0;
    wire _6381 = 1'b0;
    wire _6382 = 1'b0;
    reg _6383;
    reg _6914;
    wire _6908 = 1'b0;
    wire _6909 = 1'b0;
    wire _6385 = 1'b0;
    wire _6386 = 1'b0;
    reg _6387;
    reg _6910;
    wire _6904 = 1'b0;
    wire _6905 = 1'b0;
    wire _6389 = 1'b0;
    wire _6390 = 1'b0;
    reg _6391;
    reg _6906;
    wire [4:0] _6900 = 5'b00000;
    wire [4:0] _6901 = 5'b00000;
    wire [4:0] _6393 = 5'b00000;
    wire [4:0] _6394 = 5'b00000;
    reg [4:0] _6395;
    reg [4:0] _6902;
    wire [4:0] _6896 = 5'b00000;
    wire [4:0] _6897 = 5'b00000;
    wire [4:0] _6397 = 5'b00000;
    wire [4:0] _6398 = 5'b00000;
    reg [4:0] _6399;
    reg [4:0] _6898;
    wire [4:0] _6892 = 5'b00000;
    wire [4:0] _6893 = 5'b00000;
    wire [4:0] _6401 = 5'b00000;
    wire [4:0] _6402 = 5'b00000;
    reg [4:0] _6403;
    reg [4:0] _6894;
    wire _6888 = 1'b0;
    wire _6889 = 1'b0;
    wire _6405 = 1'b0;
    wire vdd = 1'b1;
    wire _6406 = 1'b0;
    reg _6407;
    reg _6890;

    /* logic */
    always @(posedge clk) begin
        if (clr)
            _6331 <= _6329;
        else
            _6331 <= junk_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _6966 <= _6964;
        else
            _6966 <= _6331;
    end
    always @(posedge clk) begin
        if (clr)
            _6335 <= _6333;
        else
            _6335 <= alu_cmp_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _6962 <= _6960;
        else
            _6962 <= _6335;
    end
    always @(posedge clk) begin
        if (clr)
            _6339 <= _6337;
        else
            _6339 <= alu_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _6958 <= _6956;
        else
            _6958 <= _6339;
    end
    always @(posedge clk) begin
        if (clr)
            _6343 <= _6341;
        else
            _6343 <= fclass_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _6954 <= _6952;
        else
            _6954 <= _6343;
    end
    always @(posedge clk) begin
        if (clr)
            _6347 <= _6345;
        else
            _6347 <= is_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _6950 <= _6948;
        else
            _6950 <= _6347;
    end
    always @(posedge clk) begin
        if (clr)
            _6351 <= _6349;
        else
            _6351 <= insn_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _6946 <= _6944;
        else
            _6946 <= _6351;
    end
    always @(posedge clk) begin
        if (clr)
            _6355 <= _6353;
        else
            _6355 <= instr_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _6942 <= _6940;
        else
            _6942 <= _6355;
    end
    always @(posedge clk) begin
        if (clr)
            _6359 <= _6357;
        else
            _6359 <= next_pc_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _6938 <= _6936;
        else
            _6938 <= _6359;
    end
    always @(posedge clk) begin
        if (clr)
            _6363 <= _6361;
        else
            _6363 <= pc_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _6934 <= _6932;
        else
            _6934 <= _6363;
    end
    always @(posedge clk) begin
        if (clr)
            _6367 <= _6365;
        else
            _6367 <= imm_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _6930 <= _6928;
        else
            _6930 <= _6367;
    end
    always @(posedge clk) begin
        if (clr)
            _6371 <= _6369;
        else
            _6371 <= rdd_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _6926 <= _6924;
        else
            _6926 <= _6371;
    end
    always @(posedge clk) begin
        if (clr)
            _6375 <= _6373;
        else
            _6375 <= rd2_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _6922 <= _6920;
        else
            _6922 <= _6375;
    end
    always @(posedge clk) begin
        if (clr)
            _6379 <= _6377;
        else
            _6379 <= rd1_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _6918 <= _6916;
        else
            _6918 <= _6379;
    end
    always @(posedge clk) begin
        if (clr)
            _6383 <= _6381;
        else
            _6383 <= rad_zero_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _6914 <= _6912;
        else
            _6914 <= _6383;
    end
    always @(posedge clk) begin
        if (clr)
            _6387 <= _6385;
        else
            _6387 <= ra2_zero_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _6910 <= _6908;
        else
            _6910 <= _6387;
    end
    always @(posedge clk) begin
        if (clr)
            _6391 <= _6389;
        else
            _6391 <= ra1_zero_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _6906 <= _6904;
        else
            _6906 <= _6391;
    end
    always @(posedge clk) begin
        if (clr)
            _6395 <= _6393;
        else
            _6395 <= rad_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _6902 <= _6900;
        else
            _6902 <= _6395;
    end
    always @(posedge clk) begin
        if (clr)
            _6399 <= _6397;
        else
            _6399 <= ra2_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _6898 <= _6896;
        else
            _6898 <= _6399;
    end
    always @(posedge clk) begin
        if (clr)
            _6403 <= _6401;
        else
            _6403 <= ra1_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _6894 <= _6892;
        else
            _6894 <= _6403;
    end
    always @(posedge clk) begin
        if (clr)
            _6407 <= _6405;
        else
            _6407 <= pen_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _6890 <= _6888;
        else
            _6890 <= _6407;
    end

    /* aliases */

    /* output assignments */
    assign pen = _6890;
    assign ra1 = _6894;
    assign ra2 = _6898;
    assign rad = _6902;
    assign ra1_zero = _6906;
    assign ra2_zero = _6910;
    assign rad_zero = _6914;
    assign rd1 = _6918;
    assign rd2 = _6922;
    assign rdd = _6926;
    assign imm = _6930;
    assign pc = _6934;
    assign next_pc = _6938;
    assign instr = _6942;
    assign insn = _6946;
    assign is = _6950;
    assign fclass = _6954;
    assign alu = _6958;
    assign alu_cmp = _6962;
    assign junk = _6966;

endmodule
