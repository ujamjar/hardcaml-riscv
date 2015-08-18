module alu (
    junk_p_1,
    sys_p_1,
    fen_p_1,
    opr_p_1,
    opi_p_1,
    trap_p_1,
    insn_p_1,
    instr_p_1,
    next_pc_p_1,
    rdm_p_1,
    imm_p_1,
    pc_p_1,
    f7_p_1,
    st_p_1,
    ld_p_1,
    f3_p_1,
    bra_p_1,
    jalr_p_1,
    jal_p_1,
    auipc_p_1,
    lui_p_1,
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

    input junk_p_1;
    input sys_p_1;
    input fen_p_1;
    input opr_p_1;
    input opi_p_1;
    input trap_p_1;
    input [47:0] insn_p_1;
    input [31:0] instr_p_1;
    input [31:0] next_pc_p_1;
    input [31:0] rdm_p_1;
    input [31:0] imm_p_1;
    input [31:0] pc_p_1;
    input f7_p_1;
    input st_p_1;
    input ld_p_1;
    input [2:0] f3_p_1;
    input bra_p_1;
    input jalr_p_1;
    input jal_p_1;
    input auipc_p_1;
    input lui_p_1;
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
    wire _5144 = 1'b0;
    wire _5145 = 1'b0;
    wire _3714 = 1'b0;
    wire _3715 = 1'b0;
    reg _3716;
    reg _5146;
    wire _5140 = 1'b0;
    wire _5141 = 1'b0;
    wire _4887;
    wire _4888;
    wire [30:0] _4877;
    wire _4878;
    wire _4879;
    wire [31:0] _4880;
    wire [30:0] _4881;
    wire _4882;
    wire _4883;
    wire [31:0] _4884;
    wire _4885;
    wire _4886;
    wire _4866;
    wire _4865;
    reg _5011;
    reg _5142;
    wire _5136 = 1'b0;
    wire _5137 = 1'b0;
    reg _5138;
    wire [2:0] _5132 = 3'b000;
    wire [2:0] _5133 = 3'b000;
    reg [2:0] _5134;
    wire _5128 = 1'b0;
    wire _5129 = 1'b0;
    wire _3730 = 1'b0;
    wire _3731 = 1'b0;
    reg _3732;
    reg _5130;
    wire _5124 = 1'b0;
    wire _5125 = 1'b0;
    wire _3734 = 1'b0;
    wire _3735 = 1'b0;
    reg _3736;
    reg _5126;
    wire _5120 = 1'b0;
    wire _5121 = 1'b0;
    wire _3738 = 1'b0;
    wire _3739 = 1'b0;
    reg _3740;
    reg _5122;
    wire _5116 = 1'b0;
    wire _5117 = 1'b0;
    wire _3742 = 1'b0;
    wire _3743 = 1'b0;
    reg _3744;
    reg _5118;
    wire _5112 = 1'b0;
    wire _5113 = 1'b0;
    reg _5114;
    wire _5108 = 1'b0;
    wire _5109 = 1'b0;
    reg _5110;
    wire _5104 = 1'b0;
    wire _5105 = 1'b0;
    reg _5106;
    wire _5100 = 1'b0;
    wire _5101 = 1'b0;
    reg _5102;
    wire _5096 = 1'b0;
    wire _5097 = 1'b0;
    reg _5098;
    wire _5092 = 1'b0;
    wire _5093 = 1'b0;
    reg _5094;
    wire _5088 = 1'b0;
    wire _5089 = 1'b0;
    reg _5090;
    wire _5084 = 1'b0;
    wire _5085 = 1'b0;
    wire _3774 = 1'b0;
    wire _3775 = 1'b0;
    reg _3776;
    reg _5086;
    wire [47:0] _5080 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _5081 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _3778 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _3779 = 48'b000000000000000000000000000000000000000000000000;
    reg [47:0] _3780;
    reg [47:0] _5082;
    wire [31:0] _5076 = 32'b00000000000000000000000000000000;
    wire [31:0] _5077 = 32'b00000000000000000000000000000000;
    wire [31:0] _3782 = 32'b00000000000000000000000000000000;
    wire [31:0] _3783 = 32'b00000000000000000000000000000000;
    reg [31:0] _3784;
    reg [31:0] _5078;
    wire [31:0] _5072 = 32'b00000000000000000000000000000000;
    wire [31:0] _5073 = 32'b00000000000000000000000000000000;
    wire [31:0] _3786 = 32'b00000000000000000000000000000000;
    wire [31:0] _3787 = 32'b00000000000000000000000000000000;
    reg [31:0] _3788;
    reg [31:0] _5074;
    wire [31:0] _5068 = 32'b00000000000000000000000000000000;
    wire [31:0] _5069 = 32'b00000000000000000000000000000000;
    reg [31:0] _5070;
    wire [31:0] _5064 = 32'b00000000000000000000000000000000;
    wire [31:0] _5065 = 32'b00000000000000000000000000000000;
    reg [31:0] _5066;
    wire [31:0] _5060 = 32'b00000000000000000000000000000000;
    wire [31:0] _5061 = 32'b00000000000000000000000000000000;
    wire [31:0] _3798 = 32'b00000000000000000000000000000000;
    wire [31:0] _3799 = 32'b00000000000000000000000000000000;
    reg [31:0] _3800;
    reg [31:0] _5062;
    wire [31:0] _5056 = 32'b00000000000000000000000000000000;
    wire [31:0] _5057 = 32'b00000000000000000000000000000000;
    wire [31:0] _5013 = 32'b00000000000000000000000000000100;
    wire [31:0] _5014;
    wire [31:0] _3794 = 32'b00000000000000000000000000000000;
    wire [31:0] _3795 = 32'b00000000000000000000000000000000;
    reg [31:0] _3796;
    wire [31:0] _3790 = 32'b00000000000000000000000000000000;
    wire [31:0] _3791 = 32'b00000000000000000000000000000000;
    reg [31:0] _3792;
    wire [31:0] _5012;
    wire [31:0] _4897;
    wire [31:0] _4898;
    wire [15:0] _4953;
    wire _4954;
    wire [1:0] _4955;
    wire [3:0] _4956;
    wire [7:0] _4957;
    wire [15:0] _4958;
    wire [31:0] _4960;
    wire [23:0] _4944;
    wire _4945;
    wire [1:0] _4946;
    wire [3:0] _4947;
    wire [7:0] _4948;
    wire [31:0] _4950;
    wire [27:0] _4936;
    wire _4937;
    wire [1:0] _4938;
    wire [3:0] _4939;
    wire [31:0] _4941;
    wire [29:0] _4929;
    wire _4930;
    wire [1:0] _4931;
    wire [31:0] _4933;
    wire [30:0] _4924;
    wire _4925;
    wire [31:0] _4926;
    wire _4927;
    wire [31:0] _4928;
    wire _4934;
    wire [31:0] _4935;
    wire _4942;
    wire [31:0] _4943;
    wire _4951;
    wire [31:0] _4952;
    wire _4961;
    wire [31:0] _4962;
    wire [15:0] _4919;
    wire [15:0] _4920 = 16'b0000000000000000;
    wire [31:0] _4921;
    wire [23:0] _4914;
    wire [7:0] _4915 = 8'b00000000;
    wire [31:0] _4916;
    wire [27:0] _4909;
    wire [3:0] _4910 = 4'b0000;
    wire [31:0] _4911;
    wire [29:0] _4904;
    wire [1:0] _4905 = 2'b00;
    wire [31:0] _4906;
    wire [30:0] _4899;
    wire _4900 = 1'b0;
    wire [31:0] _4901;
    wire _4902;
    wire [31:0] _4903;
    wire _4907;
    wire [31:0] _4908;
    wire _4912;
    wire [31:0] _4913;
    wire _4917;
    wire [31:0] _4918;
    wire _4922;
    wire [31:0] _4923;
    wire [31:0] _4963;
    wire [31:0] _4964;
    wire _4876;
    wire [30:0] _4972 = 31'b0000000000000000000000000000000;
    wire [31:0] _4974;
    wire [30:0] _4867;
    wire _4868;
    wire _4869;
    wire [31:0] _4870;
    wire [30:0] _4871;
    wire _4872;
    wire _4873;
    wire [31:0] _4874;
    wire _4875;
    wire [30:0] _4982 = 31'b0000000000000000000000000000000;
    wire [31:0] _4984;
    wire [15:0] _5005 = 16'b0000000000000000;
    wire [15:0] _5006;
    wire [31:0] _5007;
    wire [7:0] _5000 = 8'b00000000;
    wire [23:0] _5001;
    wire [31:0] _5002;
    wire [3:0] _4995 = 4'b0000;
    wire [27:0] _4996;
    wire [31:0] _4997;
    wire [1:0] _4990 = 2'b00;
    wire [29:0] _4991;
    wire [31:0] _4992;
    wire _4985 = 1'b0;
    wire [30:0] _4986;
    wire [31:0] _4987;
    wire _4988;
    wire [31:0] _4989;
    wire _4993;
    wire [31:0] _4994;
    wire _4998;
    wire [31:0] _4999;
    wire _5003;
    wire [31:0] _5004;
    wire [4:0] _4889;
    wire _5008;
    wire [31:0] _5009;
    wire [31:0] _4895;
    wire [31:0] _4894;
    wire gnd = 1'b0;
    wire _3722 = 1'b0;
    wire _3723 = 1'b0;
    reg _3724;
    wire _3746 = 1'b0;
    wire _3747 = 1'b0;
    reg _3748;
    wire _3750 = 1'b0;
    wire _3751 = 1'b0;
    reg _3752;
    wire _4890;
    wire _4891;
    wire _4892;
    wire _4893;
    wire [31:0] _4896;
    wire [2:0] _3726 = 3'b000;
    wire [2:0] _3727 = 3'b000;
    reg [2:0] _3728;
    reg [31:0] _5010;
    wire _3754 = 1'b0;
    wire _3755 = 1'b0;
    reg _3756;
    wire [31:0] _5016;
    wire _3758 = 1'b0;
    wire _3759 = 1'b0;
    reg _3760;
    wire _3762 = 1'b0;
    wire _3763 = 1'b0;
    reg _3764;
    wire _5015;
    wire [31:0] _5017;
    wire _3766 = 1'b0;
    wire _3767 = 1'b0;
    reg _3768;
    wire [31:0] _5018;
    wire _3770 = 1'b0;
    wire _3771 = 1'b0;
    reg _3772;
    wire [31:0] _5019;
    reg [31:0] _5058;
    wire [31:0] _5052 = 32'b00000000000000000000000000000000;
    wire [31:0] _5053 = 32'b00000000000000000000000000000000;
    wire [31:0] _3806 = 32'b00000000000000000000000000000000;
    wire [31:0] _3807 = 32'b00000000000000000000000000000000;
    reg [31:0] _3808;
    reg [31:0] _5054;
    wire [31:0] _5048 = 32'b00000000000000000000000000000000;
    wire [31:0] _5049 = 32'b00000000000000000000000000000000;
    wire [31:0] _3810 = 32'b00000000000000000000000000000000;
    wire [31:0] _3811 = 32'b00000000000000000000000000000000;
    reg [31:0] _3812;
    reg [31:0] _5050;
    wire _5044 = 1'b0;
    wire _5045 = 1'b0;
    wire _3814 = 1'b0;
    wire _3815 = 1'b0;
    reg _3816;
    reg _5046;
    wire _5040 = 1'b0;
    wire _5041 = 1'b0;
    wire _3818 = 1'b0;
    wire _3819 = 1'b0;
    reg _3820;
    reg _5042;
    wire _5036 = 1'b0;
    wire _5037 = 1'b0;
    wire _3822 = 1'b0;
    wire _3823 = 1'b0;
    reg _3824;
    reg _5038;
    wire [4:0] _5032 = 5'b00000;
    wire [4:0] _5033 = 5'b00000;
    wire [4:0] _3826 = 5'b00000;
    wire [4:0] _3827 = 5'b00000;
    reg [4:0] _3828;
    reg [4:0] _5034;
    wire [4:0] _5028 = 5'b00000;
    wire [4:0] _5029 = 5'b00000;
    wire [4:0] _3830 = 5'b00000;
    wire [4:0] _3831 = 5'b00000;
    reg [4:0] _3832;
    reg [4:0] _5030;
    wire [4:0] _5024 = 5'b00000;
    wire [4:0] _5025 = 5'b00000;
    wire [4:0] _3834 = 5'b00000;
    wire [4:0] _3835 = 5'b00000;
    reg [4:0] _3836;
    reg [4:0] _5026;
    wire _5020 = 1'b0;
    wire _5021 = 1'b0;
    wire _3838 = 1'b0;
    wire vdd = 1'b1;
    wire _3839 = 1'b0;
    reg _3840;
    reg _5022;

    /* logic */
    always @(posedge clk) begin
        if (clr)
            _3716 <= _3714;
        else
            _3716 <= junk_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5146 <= _5144;
        else
            _5146 <= _3716;
    end
    assign _4887 = _3812 < _3808;
    assign _4888 = ~ _4887;
    assign _4877 = _3808[30:0];
    assign _4878 = _3808[31:31];
    assign _4879 = ~ _4878;
    assign _4880 = { _4879, _4877 };
    assign _4881 = _3812[30:0];
    assign _4882 = _3812[31:31];
    assign _4883 = ~ _4882;
    assign _4884 = { _4883, _4881 };
    assign _4885 = _4884 < _4880;
    assign _4886 = ~ _4885;
    assign _4866 = ~ _4865;
    assign _4865 = _3812 == _3808;
    always @* begin
        case (_3728)
        0: _5011 <= _4865;
        1: _5011 <= _4866;
        2: _5011 <= gnd;
        3: _5011 <= gnd;
        4: _5011 <= _4875;
        5: _5011 <= _4886;
        6: _5011 <= _4876;
        default: _5011 <= _4888;
        endcase
    end
    always @(posedge clk) begin
        if (clr)
            _5142 <= _5140;
        else
            _5142 <= _5011;
    end
    always @(posedge clk) begin
        if (clr)
            _5138 <= _5136;
        else
            _5138 <= _3724;
    end
    always @(posedge clk) begin
        if (clr)
            _5134 <= _5132;
        else
            _5134 <= _3728;
    end
    always @(posedge clk) begin
        if (clr)
            _3732 <= _3730;
        else
            _3732 <= sys_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5130 <= _5128;
        else
            _5130 <= _3732;
    end
    always @(posedge clk) begin
        if (clr)
            _3736 <= _3734;
        else
            _3736 <= fen_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5126 <= _5124;
        else
            _5126 <= _3736;
    end
    always @(posedge clk) begin
        if (clr)
            _3740 <= _3738;
        else
            _3740 <= opr_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5122 <= _5120;
        else
            _5122 <= _3740;
    end
    always @(posedge clk) begin
        if (clr)
            _3744 <= _3742;
        else
            _3744 <= opi_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5118 <= _5116;
        else
            _5118 <= _3744;
    end
    always @(posedge clk) begin
        if (clr)
            _5114 <= _5112;
        else
            _5114 <= _3748;
    end
    always @(posedge clk) begin
        if (clr)
            _5110 <= _5108;
        else
            _5110 <= _3752;
    end
    always @(posedge clk) begin
        if (clr)
            _5106 <= _5104;
        else
            _5106 <= _3756;
    end
    always @(posedge clk) begin
        if (clr)
            _5102 <= _5100;
        else
            _5102 <= _3760;
    end
    always @(posedge clk) begin
        if (clr)
            _5098 <= _5096;
        else
            _5098 <= _3764;
    end
    always @(posedge clk) begin
        if (clr)
            _5094 <= _5092;
        else
            _5094 <= _3768;
    end
    always @(posedge clk) begin
        if (clr)
            _5090 <= _5088;
        else
            _5090 <= _3772;
    end
    always @(posedge clk) begin
        if (clr)
            _3776 <= _3774;
        else
            _3776 <= trap_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5086 <= _5084;
        else
            _5086 <= _3776;
    end
    always @(posedge clk) begin
        if (clr)
            _3780 <= _3778;
        else
            _3780 <= insn_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5082 <= _5080;
        else
            _5082 <= _3780;
    end
    always @(posedge clk) begin
        if (clr)
            _3784 <= _3782;
        else
            _3784 <= instr_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5078 <= _5076;
        else
            _5078 <= _3784;
    end
    always @(posedge clk) begin
        if (clr)
            _3788 <= _3786;
        else
            _3788 <= next_pc_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5074 <= _5072;
        else
            _5074 <= _3788;
    end
    always @(posedge clk) begin
        if (clr)
            _5070 <= _5068;
        else
            _5070 <= _3792;
    end
    always @(posedge clk) begin
        if (clr)
            _5066 <= _5064;
        else
            _5066 <= _3796;
    end
    always @(posedge clk) begin
        if (clr)
            _3800 <= _3798;
        else
            _3800 <= rdm_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5062 <= _5060;
        else
            _5062 <= _3800;
    end
    assign _5014 = _3792 + _5013;
    always @(posedge clk) begin
        if (clr)
            _3796 <= _3794;
        else
            _3796 <= imm_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _3792 <= _3790;
        else
            _3792 <= pc_p_1;
    end
    assign _5012 = _3792 + _3796;
    assign _4897 = _3812 & _3808;
    assign _4898 = _3812 | _3808;
    assign _4953 = _4952[31:16];
    assign _4954 = _4952[31:31];
    assign _4955 = { _4954, _4954 };
    assign _4956 = { _4955, _4955 };
    assign _4957 = { _4956, _4956 };
    assign _4958 = { _4957, _4957 };
    assign _4960 = { _4958, _4953 };
    assign _4944 = _4943[31:8];
    assign _4945 = _4943[31:31];
    assign _4946 = { _4945, _4945 };
    assign _4947 = { _4946, _4946 };
    assign _4948 = { _4947, _4947 };
    assign _4950 = { _4948, _4944 };
    assign _4936 = _4935[31:4];
    assign _4937 = _4935[31:31];
    assign _4938 = { _4937, _4937 };
    assign _4939 = { _4938, _4938 };
    assign _4941 = { _4939, _4936 };
    assign _4929 = _4928[31:2];
    assign _4930 = _4928[31:31];
    assign _4931 = { _4930, _4930 };
    assign _4933 = { _4931, _4929 };
    assign _4924 = _3812[31:1];
    assign _4925 = _3812[31:31];
    assign _4926 = { _4925, _4924 };
    assign _4927 = _4889[0:0];
    assign _4928 = _4927 ? _4926 : _3812;
    assign _4934 = _4889[1:1];
    assign _4935 = _4934 ? _4933 : _4928;
    assign _4942 = _4889[2:2];
    assign _4943 = _4942 ? _4941 : _4935;
    assign _4951 = _4889[3:3];
    assign _4952 = _4951 ? _4950 : _4943;
    assign _4961 = _4889[4:4];
    assign _4962 = _4961 ? _4960 : _4952;
    assign _4919 = _4918[31:16];
    assign _4921 = { _4920, _4919 };
    assign _4914 = _4913[31:8];
    assign _4916 = { _4915, _4914 };
    assign _4909 = _4908[31:4];
    assign _4911 = { _4910, _4909 };
    assign _4904 = _4903[31:2];
    assign _4906 = { _4905, _4904 };
    assign _4899 = _3808[31:1];
    assign _4901 = { _4900, _4899 };
    assign _4902 = _4889[0:0];
    assign _4903 = _4902 ? _4901 : _3808;
    assign _4907 = _4889[1:1];
    assign _4908 = _4907 ? _4906 : _4903;
    assign _4912 = _4889[2:2];
    assign _4913 = _4912 ? _4911 : _4908;
    assign _4917 = _4889[3:3];
    assign _4918 = _4917 ? _4916 : _4913;
    assign _4922 = _4889[4:4];
    assign _4923 = _4922 ? _4921 : _4918;
    assign _4963 = _3724 ? _4962 : _4923;
    assign _4964 = _3812 ^ _3808;
    assign _4876 = _3812 < _3808;
    assign _4974 = { _4972, _4876 };
    assign _4867 = _3808[30:0];
    assign _4868 = _3808[31:31];
    assign _4869 = ~ _4868;
    assign _4870 = { _4869, _4867 };
    assign _4871 = _3812[30:0];
    assign _4872 = _3812[31:31];
    assign _4873 = ~ _4872;
    assign _4874 = { _4873, _4871 };
    assign _4875 = _4874 < _4870;
    assign _4984 = { _4982, _4875 };
    assign _5006 = _5004[15:0];
    assign _5007 = { _5006, _5005 };
    assign _5001 = _4999[23:0];
    assign _5002 = { _5001, _5000 };
    assign _4996 = _4994[27:0];
    assign _4997 = { _4996, _4995 };
    assign _4991 = _4989[29:0];
    assign _4992 = { _4991, _4990 };
    assign _4986 = _3812[30:0];
    assign _4987 = { _4986, _4985 };
    assign _4988 = _4889[0:0];
    assign _4989 = _4988 ? _4987 : _3812;
    assign _4993 = _4889[1:1];
    assign _4994 = _4993 ? _4992 : _4989;
    assign _4998 = _4889[2:2];
    assign _4999 = _4998 ? _4997 : _4994;
    assign _5003 = _4889[3:3];
    assign _5004 = _5003 ? _5002 : _4999;
    assign _4889 = _3808[4:0];
    assign _5008 = _4889[4:4];
    assign _5009 = _5008 ? _5007 : _5004;
    assign _4895 = _3812 - _3808;
    assign _4894 = _3812 + _3808;
    always @(posedge clk) begin
        if (clr)
            _3724 <= _3722;
        else
            _3724 <= f7_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _3748 <= _3746;
        else
            _3748 <= st_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _3752 <= _3750;
        else
            _3752 <= ld_p_1;
    end
    assign _4890 = _3768 | _3764;
    assign _4891 = _4890 | _3752;
    assign _4892 = _4891 | _3748;
    assign _4893 = _4892 ? gnd : _3724;
    assign _4896 = _4893 ? _4895 : _4894;
    always @(posedge clk) begin
        if (clr)
            _3728 <= _3726;
        else
            _3728 <= f3_p_1;
    end
    always @* begin
        case (_3728)
        0: _5010 <= _4896;
        1: _5010 <= _5009;
        2: _5010 <= _4984;
        3: _5010 <= _4974;
        4: _5010 <= _4964;
        5: _5010 <= _4963;
        6: _5010 <= _4898;
        default: _5010 <= _4897;
        endcase
    end
    always @(posedge clk) begin
        if (clr)
            _3756 <= _3754;
        else
            _3756 <= bra_p_1;
    end
    assign _5016 = _3756 ? _5012 : _5010;
    always @(posedge clk) begin
        if (clr)
            _3760 <= _3758;
        else
            _3760 <= jalr_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _3764 <= _3762;
        else
            _3764 <= jal_p_1;
    end
    assign _5015 = _3764 | _3760;
    assign _5017 = _5015 ? _5014 : _5016;
    always @(posedge clk) begin
        if (clr)
            _3768 <= _3766;
        else
            _3768 <= auipc_p_1;
    end
    assign _5018 = _3768 ? _4896 : _5017;
    always @(posedge clk) begin
        if (clr)
            _3772 <= _3770;
        else
            _3772 <= lui_p_1;
    end
    assign _5019 = _3772 ? _3808 : _5018;
    always @(posedge clk) begin
        if (clr)
            _5058 <= _5056;
        else
            _5058 <= _5019;
    end
    always @(posedge clk) begin
        if (clr)
            _3808 <= _3806;
        else
            _3808 <= rd2_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5054 <= _5052;
        else
            _5054 <= _3808;
    end
    always @(posedge clk) begin
        if (clr)
            _3812 <= _3810;
        else
            _3812 <= rd1_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5050 <= _5048;
        else
            _5050 <= _3812;
    end
    always @(posedge clk) begin
        if (clr)
            _3816 <= _3814;
        else
            _3816 <= rad_zero_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5046 <= _5044;
        else
            _5046 <= _3816;
    end
    always @(posedge clk) begin
        if (clr)
            _3820 <= _3818;
        else
            _3820 <= ra2_zero_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5042 <= _5040;
        else
            _5042 <= _3820;
    end
    always @(posedge clk) begin
        if (clr)
            _3824 <= _3822;
        else
            _3824 <= ra1_zero_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5038 <= _5036;
        else
            _5038 <= _3824;
    end
    always @(posedge clk) begin
        if (clr)
            _3828 <= _3826;
        else
            _3828 <= rad_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5034 <= _5032;
        else
            _5034 <= _3828;
    end
    always @(posedge clk) begin
        if (clr)
            _3832 <= _3830;
        else
            _3832 <= ra2_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5030 <= _5028;
        else
            _5030 <= _3832;
    end
    always @(posedge clk) begin
        if (clr)
            _3836 <= _3834;
        else
            _3836 <= ra1_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5026 <= _5024;
        else
            _5026 <= _3836;
    end
    always @(posedge clk) begin
        if (clr)
            _3840 <= _3838;
        else
            _3840 <= pen_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5022 <= _5020;
        else
            _5022 <= _3840;
    end

    /* aliases */

    /* output assignments */
    assign pen = _5022;
    assign ra1 = _5026;
    assign ra2 = _5030;
    assign rad = _5034;
    assign ra1_zero = _5038;
    assign ra2_zero = _5042;
    assign rad_zero = _5046;
    assign rd1 = _5050;
    assign rd2 = _5054;
    assign rdd = _5058;
    assign rdm = _5062;
    assign imm = _5066;
    assign pc = _5070;
    assign next_pc = _5074;
    assign instr = _5078;
    assign insn = _5082;
    assign trap = _5086;
    assign lui = _5090;
    assign auipc = _5094;
    assign jal = _5098;
    assign jalr = _5102;
    assign bra = _5106;
    assign ld = _5110;
    assign st = _5114;
    assign opi = _5118;
    assign opr = _5122;
    assign fen = _5126;
    assign sys = _5130;
    assign f3 = _5134;
    assign f7 = _5138;
    assign cond_branch = _5142;
    assign junk = _5146;

endmodule
