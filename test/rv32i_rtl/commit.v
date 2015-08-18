module commit (
    junk_p_3,
    cond_branch_p_3,
    f7_p_3,
    f3_p_3,
    sys_p_3,
    fen_p_3,
    opr_p_3,
    opi_p_3,
    st_p_3,
    ld_p_3,
    bra_p_3,
    jalr_p_3,
    jal_p_3,
    auipc_p_3,
    lui_p_3,
    trap_p_3,
    insn_p_3,
    instr_p_3,
    next_pc_p_3,
    pc_p_3,
    imm_p_3,
    rdm_p_3,
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
    rdm,
    imm,
    pc,
    next_pc,
    instr,
    insn,
    trap,
    lui,
    auipc,
    jal,
    jalr,
    bra,
    ld,
    st,
    opi,
    opr,
    fen,
    sys,
    f3,
    f7,
    cond_branch,
    junk
);

    input junk_p_3;
    input cond_branch_p_3;
    input f7_p_3;
    input [2:0] f3_p_3;
    input sys_p_3;
    input fen_p_3;
    input opr_p_3;
    input opi_p_3;
    input st_p_3;
    input ld_p_3;
    input bra_p_3;
    input jalr_p_3;
    input jal_p_3;
    input auipc_p_3;
    input lui_p_3;
    input trap_p_3;
    input [47:0] insn_p_3;
    input [31:0] instr_p_3;
    input [31:0] next_pc_p_3;
    input [31:0] pc_p_3;
    input [31:0] imm_p_3;
    input [31:0] rdm_p_3;
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
    output [31:0] rdm;
    output [31:0] imm;
    output [31:0] pc;
    output [31:0] next_pc;
    output [31:0] instr;
    output [47:0] insn;
    output trap;
    output lui;
    output auipc;
    output jal;
    output jalr;
    output bra;
    output ld;
    output st;
    output opi;
    output opr;
    output fen;
    output sys;
    output [2:0] f3;
    output f7;
    output cond_branch;
    output junk;

    /* signal declarations */
    wire _7968 = 1'b0;
    wire _7969 = 1'b0;
    wire _6949 = 1'b0;
    wire _6950 = 1'b0;
    reg _6951;
    reg _7970;
    wire _7964 = 1'b0;
    wire _7965 = 1'b0;
    wire _6953 = 1'b0;
    wire _6954 = 1'b0;
    reg _6955;
    reg _7966;
    wire _7960 = 1'b0;
    wire _7961 = 1'b0;
    wire _6957 = 1'b0;
    wire _6958 = 1'b0;
    reg _6959;
    reg _7962;
    wire [2:0] _7956 = 3'b000;
    wire [2:0] _7957 = 3'b000;
    wire [2:0] _6961 = 3'b000;
    wire [2:0] _6962 = 3'b000;
    reg [2:0] _6963;
    reg [2:0] _7958;
    wire _7952 = 1'b0;
    wire _7953 = 1'b0;
    wire _6965 = 1'b0;
    wire _6966 = 1'b0;
    reg _6967;
    reg _7954;
    wire _7948 = 1'b0;
    wire _7949 = 1'b0;
    wire _6969 = 1'b0;
    wire _6970 = 1'b0;
    reg _6971;
    reg _7950;
    wire _7944 = 1'b0;
    wire _7945 = 1'b0;
    wire _6973 = 1'b0;
    wire _6974 = 1'b0;
    reg _6975;
    reg _7946;
    wire _7940 = 1'b0;
    wire _7941 = 1'b0;
    wire _6977 = 1'b0;
    wire _6978 = 1'b0;
    reg _6979;
    reg _7942;
    wire _7936 = 1'b0;
    wire _7937 = 1'b0;
    wire _6981 = 1'b0;
    wire _6982 = 1'b0;
    reg _6983;
    reg _7938;
    wire _7932 = 1'b0;
    wire _7933 = 1'b0;
    wire _6985 = 1'b0;
    wire _6986 = 1'b0;
    reg _6987;
    reg _7934;
    wire _7928 = 1'b0;
    wire _7929 = 1'b0;
    wire _6989 = 1'b0;
    wire _6990 = 1'b0;
    reg _6991;
    reg _7930;
    wire _7924 = 1'b0;
    wire _7925 = 1'b0;
    wire _6993 = 1'b0;
    wire _6994 = 1'b0;
    reg _6995;
    reg _7926;
    wire _7920 = 1'b0;
    wire _7921 = 1'b0;
    wire _6997 = 1'b0;
    wire _6998 = 1'b0;
    reg _6999;
    reg _7922;
    wire _7916 = 1'b0;
    wire _7917 = 1'b0;
    wire _7001 = 1'b0;
    wire _7002 = 1'b0;
    reg _7003;
    reg _7918;
    wire _7912 = 1'b0;
    wire _7913 = 1'b0;
    wire _7005 = 1'b0;
    wire _7006 = 1'b0;
    reg _7007;
    reg _7914;
    wire _7908 = 1'b0;
    wire _7909 = 1'b0;
    wire _7009 = 1'b0;
    wire _7010 = 1'b0;
    reg _7011;
    reg _7910;
    wire [47:0] _7904 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _7905 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _7013 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _7014 = 48'b000000000000000000000000000000000000000000000000;
    reg [47:0] _7015;
    reg [47:0] _7906;
    wire [31:0] _7900 = 32'b00000000000000000000000000000000;
    wire [31:0] _7901 = 32'b00000000000000000000000000000000;
    wire [31:0] _7017 = 32'b00000000000000000000000000000000;
    wire [31:0] _7018 = 32'b00000000000000000000000000000000;
    reg [31:0] _7019;
    reg [31:0] _7902;
    wire [31:0] _7896 = 32'b00000000000000000000000000000000;
    wire [31:0] _7897 = 32'b00000000000000000000000000000000;
    wire [31:0] _7021 = 32'b00000000000000000000000000000000;
    wire [31:0] _7022 = 32'b00000000000000000000000000000000;
    reg [31:0] _7023;
    reg [31:0] _7898;
    wire [31:0] _7892 = 32'b00000000000000000000000000000000;
    wire [31:0] _7893 = 32'b00000000000000000000000000000000;
    wire [31:0] _7025 = 32'b00000000000000000000000000000000;
    wire [31:0] _7026 = 32'b00000000000000000000000000000000;
    reg [31:0] _7027;
    reg [31:0] _7894;
    wire [31:0] _7888 = 32'b00000000000000000000000000000000;
    wire [31:0] _7889 = 32'b00000000000000000000000000000000;
    wire [31:0] _7029 = 32'b00000000000000000000000000000000;
    wire [31:0] _7030 = 32'b00000000000000000000000000000000;
    reg [31:0] _7031;
    reg [31:0] _7890;
    wire [31:0] _7884 = 32'b00000000000000000000000000000000;
    wire [31:0] _7885 = 32'b00000000000000000000000000000000;
    wire [31:0] _7033 = 32'b00000000000000000000000000000000;
    wire [31:0] _7034 = 32'b00000000000000000000000000000000;
    reg [31:0] _7035;
    reg [31:0] _7886;
    wire [31:0] _7880 = 32'b00000000000000000000000000000000;
    wire [31:0] _7881 = 32'b00000000000000000000000000000000;
    wire [31:0] _7037 = 32'b00000000000000000000000000000000;
    wire [31:0] _7038 = 32'b00000000000000000000000000000000;
    reg [31:0] _7039;
    reg [31:0] _7882;
    wire [31:0] _7876 = 32'b00000000000000000000000000000000;
    wire [31:0] _7877 = 32'b00000000000000000000000000000000;
    wire [31:0] _7041 = 32'b00000000000000000000000000000000;
    wire [31:0] _7042 = 32'b00000000000000000000000000000000;
    reg [31:0] _7043;
    reg [31:0] _7878;
    wire [31:0] _7872 = 32'b00000000000000000000000000000000;
    wire [31:0] _7873 = 32'b00000000000000000000000000000000;
    wire [31:0] _7045 = 32'b00000000000000000000000000000000;
    wire [31:0] _7046 = 32'b00000000000000000000000000000000;
    reg [31:0] _7047;
    reg [31:0] _7874;
    wire _7868 = 1'b0;
    wire _7869 = 1'b0;
    wire _7049 = 1'b0;
    wire _7050 = 1'b0;
    reg _7051;
    reg _7870;
    wire _7864 = 1'b0;
    wire _7865 = 1'b0;
    wire _7053 = 1'b0;
    wire _7054 = 1'b0;
    reg _7055;
    reg _7866;
    wire _7860 = 1'b0;
    wire _7861 = 1'b0;
    wire _7057 = 1'b0;
    wire _7058 = 1'b0;
    reg _7059;
    reg _7862;
    wire [4:0] _7856 = 5'b00000;
    wire [4:0] _7857 = 5'b00000;
    wire [4:0] _7061 = 5'b00000;
    wire [4:0] _7062 = 5'b00000;
    reg [4:0] _7063;
    reg [4:0] _7858;
    wire [4:0] _7852 = 5'b00000;
    wire [4:0] _7853 = 5'b00000;
    wire [4:0] _7065 = 5'b00000;
    wire [4:0] _7066 = 5'b00000;
    reg [4:0] _7067;
    reg [4:0] _7854;
    wire [4:0] _7848 = 5'b00000;
    wire [4:0] _7849 = 5'b00000;
    wire [4:0] _7069 = 5'b00000;
    wire [4:0] _7070 = 5'b00000;
    reg [4:0] _7071;
    reg [4:0] _7850;
    wire _7844 = 1'b0;
    wire _7845 = 1'b0;
    wire _7073 = 1'b0;
    wire vdd = 1'b1;
    wire _7074 = 1'b0;
    reg _7075;
    reg _7846;

    /* logic */
    always @(posedge clk) begin
        if (clr)
            _6951 <= _6949;
        else
            _6951 <= junk_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7970 <= _7968;
        else
            _7970 <= _6951;
    end
    always @(posedge clk) begin
        if (clr)
            _6955 <= _6953;
        else
            _6955 <= cond_branch_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7966 <= _7964;
        else
            _7966 <= _6955;
    end
    always @(posedge clk) begin
        if (clr)
            _6959 <= _6957;
        else
            _6959 <= f7_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7962 <= _7960;
        else
            _7962 <= _6959;
    end
    always @(posedge clk) begin
        if (clr)
            _6963 <= _6961;
        else
            _6963 <= f3_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7958 <= _7956;
        else
            _7958 <= _6963;
    end
    always @(posedge clk) begin
        if (clr)
            _6967 <= _6965;
        else
            _6967 <= sys_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7954 <= _7952;
        else
            _7954 <= _6967;
    end
    always @(posedge clk) begin
        if (clr)
            _6971 <= _6969;
        else
            _6971 <= fen_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7950 <= _7948;
        else
            _7950 <= _6971;
    end
    always @(posedge clk) begin
        if (clr)
            _6975 <= _6973;
        else
            _6975 <= opr_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7946 <= _7944;
        else
            _7946 <= _6975;
    end
    always @(posedge clk) begin
        if (clr)
            _6979 <= _6977;
        else
            _6979 <= opi_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7942 <= _7940;
        else
            _7942 <= _6979;
    end
    always @(posedge clk) begin
        if (clr)
            _6983 <= _6981;
        else
            _6983 <= st_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7938 <= _7936;
        else
            _7938 <= _6983;
    end
    always @(posedge clk) begin
        if (clr)
            _6987 <= _6985;
        else
            _6987 <= ld_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7934 <= _7932;
        else
            _7934 <= _6987;
    end
    always @(posedge clk) begin
        if (clr)
            _6991 <= _6989;
        else
            _6991 <= bra_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7930 <= _7928;
        else
            _7930 <= _6991;
    end
    always @(posedge clk) begin
        if (clr)
            _6995 <= _6993;
        else
            _6995 <= jalr_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7926 <= _7924;
        else
            _7926 <= _6995;
    end
    always @(posedge clk) begin
        if (clr)
            _6999 <= _6997;
        else
            _6999 <= jal_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7922 <= _7920;
        else
            _7922 <= _6999;
    end
    always @(posedge clk) begin
        if (clr)
            _7003 <= _7001;
        else
            _7003 <= auipc_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7918 <= _7916;
        else
            _7918 <= _7003;
    end
    always @(posedge clk) begin
        if (clr)
            _7007 <= _7005;
        else
            _7007 <= lui_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7914 <= _7912;
        else
            _7914 <= _7007;
    end
    always @(posedge clk) begin
        if (clr)
            _7011 <= _7009;
        else
            _7011 <= trap_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7910 <= _7908;
        else
            _7910 <= _7011;
    end
    always @(posedge clk) begin
        if (clr)
            _7015 <= _7013;
        else
            _7015 <= insn_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7906 <= _7904;
        else
            _7906 <= _7015;
    end
    always @(posedge clk) begin
        if (clr)
            _7019 <= _7017;
        else
            _7019 <= instr_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7902 <= _7900;
        else
            _7902 <= _7019;
    end
    always @(posedge clk) begin
        if (clr)
            _7023 <= _7021;
        else
            _7023 <= next_pc_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7898 <= _7896;
        else
            _7898 <= _7023;
    end
    always @(posedge clk) begin
        if (clr)
            _7027 <= _7025;
        else
            _7027 <= pc_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7894 <= _7892;
        else
            _7894 <= _7027;
    end
    always @(posedge clk) begin
        if (clr)
            _7031 <= _7029;
        else
            _7031 <= imm_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7890 <= _7888;
        else
            _7890 <= _7031;
    end
    always @(posedge clk) begin
        if (clr)
            _7035 <= _7033;
        else
            _7035 <= rdm_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7886 <= _7884;
        else
            _7886 <= _7035;
    end
    always @(posedge clk) begin
        if (clr)
            _7039 <= _7037;
        else
            _7039 <= rdd_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7882 <= _7880;
        else
            _7882 <= _7039;
    end
    always @(posedge clk) begin
        if (clr)
            _7043 <= _7041;
        else
            _7043 <= rd2_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7878 <= _7876;
        else
            _7878 <= _7043;
    end
    always @(posedge clk) begin
        if (clr)
            _7047 <= _7045;
        else
            _7047 <= rd1_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7874 <= _7872;
        else
            _7874 <= _7047;
    end
    always @(posedge clk) begin
        if (clr)
            _7051 <= _7049;
        else
            _7051 <= rad_zero_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7870 <= _7868;
        else
            _7870 <= _7051;
    end
    always @(posedge clk) begin
        if (clr)
            _7055 <= _7053;
        else
            _7055 <= ra2_zero_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7866 <= _7864;
        else
            _7866 <= _7055;
    end
    always @(posedge clk) begin
        if (clr)
            _7059 <= _7057;
        else
            _7059 <= ra1_zero_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7862 <= _7860;
        else
            _7862 <= _7059;
    end
    always @(posedge clk) begin
        if (clr)
            _7063 <= _7061;
        else
            _7063 <= rad_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7858 <= _7856;
        else
            _7858 <= _7063;
    end
    always @(posedge clk) begin
        if (clr)
            _7067 <= _7065;
        else
            _7067 <= ra2_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7854 <= _7852;
        else
            _7854 <= _7067;
    end
    always @(posedge clk) begin
        if (clr)
            _7071 <= _7069;
        else
            _7071 <= ra1_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7850 <= _7848;
        else
            _7850 <= _7071;
    end
    always @(posedge clk) begin
        if (clr)
            _7075 <= _7073;
        else
            _7075 <= pen_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _7846 <= _7844;
        else
            _7846 <= _7075;
    end

    /* aliases */

    /* output assignments */
    assign pen = _7846;
    assign ra1 = _7850;
    assign ra2 = _7854;
    assign rad = _7858;
    assign ra1_zero = _7862;
    assign ra2_zero = _7866;
    assign rad_zero = _7870;
    assign rd1 = _7874;
    assign rd2 = _7878;
    assign rdd = _7882;
    assign rdm = _7886;
    assign imm = _7890;
    assign pc = _7894;
    assign next_pc = _7898;
    assign instr = _7902;
    assign insn = _7906;
    assign trap = _7910;
    assign lui = _7914;
    assign auipc = _7918;
    assign jal = _7922;
    assign jalr = _7926;
    assign bra = _7930;
    assign ld = _7934;
    assign st = _7938;
    assign opi = _7942;
    assign opr = _7946;
    assign fen = _7950;
    assign sys = _7954;
    assign f3 = _7958;
    assign f7 = _7962;
    assign cond_branch = _7966;
    assign junk = _7970;

endmodule
