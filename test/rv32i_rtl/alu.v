module alu (
    junk_p_1,
    mio_data_wmask_p_1,
    mio_data_rw_p_1,
    mio_data_req_p_1,
    mio_data_wdata_p_1,
    mio_data_addr_p_1,
    mio_instr_wmask_p_1,
    mio_instr_rw_p_1,
    mio_instr_req_p_1,
    mio_instr_wdata_p_1,
    mio_instr_addr_p_1,
    rwe_p_1,
    rdco_p_1,
    rdc_p_1,
    sys_p_1,
    fen_p_1,
    opr_p_1,
    opi_p_1,
    trap_p_1,
    insn_p_1,
    instr_p_1,
    rdm_p_1,
    imm_p_1,
    pc_p_1,
    f7_p_1,
    f3_p_1,
    st_p_1,
    ld_p_1,
    jalr_p_1,
    auipc_p_1,
    jal_p_1,
    bra_p_1,
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
    rdc,
    rdco,
    f3,
    f7,
    branch,
    rwe,
    mio_instr_addr,
    mio_instr_wdata,
    mio_instr_req,
    mio_instr_rw,
    mio_instr_wmask,
    mio_data_addr,
    mio_data_wdata,
    mio_data_req,
    mio_data_rw,
    mio_data_wmask,
    junk
);

    input junk_p_1;
    input [3:0] mio_data_wmask_p_1;
    input mio_data_rw_p_1;
    input mio_data_req_p_1;
    input [31:0] mio_data_wdata_p_1;
    input [31:0] mio_data_addr_p_1;
    input [3:0] mio_instr_wmask_p_1;
    input mio_instr_rw_p_1;
    input mio_instr_req_p_1;
    input [31:0] mio_instr_wdata_p_1;
    input [31:0] mio_instr_addr_p_1;
    input rwe_p_1;
    input [2:0] rdco_p_1;
    input rdc_p_1;
    input sys_p_1;
    input fen_p_1;
    input opr_p_1;
    input opi_p_1;
    input trap_p_1;
    input [47:0] insn_p_1;
    input [31:0] instr_p_1;
    input [31:0] rdm_p_1;
    input [31:0] imm_p_1;
    input [31:0] pc_p_1;
    input f7_p_1;
    input [2:0] f3_p_1;
    input st_p_1;
    input ld_p_1;
    input jalr_p_1;
    input auipc_p_1;
    input jal_p_1;
    input bra_p_1;
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
    output rdc;
    output [2:0] rdco;
    output [2:0] f3;
    output f7;
    output branch;
    output rwe;
    output [31:0] mio_instr_addr;
    output [31:0] mio_instr_wdata;
    output mio_instr_req;
    output mio_instr_rw;
    output [3:0] mio_instr_wmask;
    output [31:0] mio_data_addr;
    output [31:0] mio_data_wdata;
    output mio_data_req;
    output mio_data_rw;
    output [3:0] mio_data_wmask;
    output junk;

    /* signal declarations */
    wire _6821 = 1'b0;
    wire _6822 = 1'b0;
    wire _4912 = 1'b0;
    wire _4913 = 1'b0;
    reg _4914;
    reg _6823;
    wire [3:0] _6817 = 4'b0000;
    wire [3:0] _6818 = 4'b0000;
    wire [3:0] _4916 = 4'b0000;
    wire [3:0] _4917 = 4'b0000;
    reg [3:0] _4918;
    reg [3:0] _6819;
    wire _6813 = 1'b0;
    wire _6814 = 1'b0;
    wire _4920 = 1'b0;
    wire _4921 = 1'b0;
    reg _4922;
    reg _6815;
    wire _6809 = 1'b0;
    wire _6810 = 1'b0;
    wire _4924 = 1'b0;
    wire _4925 = 1'b0;
    reg _4926;
    reg _6811;
    wire [31:0] _6805 = 32'b00000000000000000000000000000000;
    wire [31:0] _6806 = 32'b00000000000000000000000000000000;
    wire [31:0] _4928 = 32'b00000000000000000000000000000000;
    wire [31:0] _4929 = 32'b00000000000000000000000000000000;
    reg [31:0] _4930;
    reg [31:0] _6807;
    wire [31:0] _6801 = 32'b00000000000000000000000000000000;
    wire [31:0] _6802 = 32'b00000000000000000000000000000000;
    wire [31:0] _4932 = 32'b00000000000000000000000000000000;
    wire [31:0] _4933 = 32'b00000000000000000000000000000000;
    reg [31:0] _4934;
    reg [31:0] _6803;
    wire [3:0] _6797 = 4'b0000;
    wire [3:0] _6798 = 4'b0000;
    wire [3:0] _4936 = 4'b0000;
    wire [3:0] _4937 = 4'b0000;
    reg [3:0] _4938;
    reg [3:0] _6799;
    wire _6793 = 1'b0;
    wire _6794 = 1'b0;
    wire _4940 = 1'b0;
    wire _4941 = 1'b0;
    reg _4942;
    reg _6795;
    wire _6789 = 1'b0;
    wire _6790 = 1'b0;
    wire _4944 = 1'b0;
    wire _4945 = 1'b0;
    reg _4946;
    reg _6791;
    wire [31:0] _6785 = 32'b00000000000000000000000000000000;
    wire [31:0] _6786 = 32'b00000000000000000000000000000000;
    wire [31:0] _4948 = 32'b00000000000000000000000000000000;
    wire [31:0] _4949 = 32'b00000000000000000000000000000000;
    reg [31:0] _4950;
    reg [31:0] _6787;
    wire [31:0] _6781 = 32'b00000000000000000000000000000000;
    wire [31:0] _6782 = 32'b00000000000000000000000000000000;
    wire [31:0] _4952 = 32'b00000000000000000000000000000000;
    wire [31:0] _4953 = 32'b00000000000000000000000000000000;
    reg [31:0] _4954;
    reg [31:0] _6783;
    wire _6777 = 1'b0;
    wire _6778 = 1'b0;
    wire _4956 = 1'b0;
    wire _4957 = 1'b0;
    reg _4958;
    reg _6779;
    wire _6773 = 1'b0;
    wire _6774 = 1'b0;
    wire _6517;
    wire _6518;
    wire [30:0] _6507;
    wire _6508;
    wire _6509;
    wire [31:0] _6510;
    wire [30:0] _6511;
    wire _6512;
    wire _6513;
    wire [31:0] _6514;
    wire _6515;
    wire _6516;
    wire _6496;
    wire _6495;
    reg _6643;
    reg _6775;
    wire _6769 = 1'b0;
    wire _6770 = 1'b0;
    reg _6771;
    wire [2:0] _6765 = 3'b000;
    wire [2:0] _6766 = 3'b000;
    reg [2:0] _6767;
    wire [2:0] _6761 = 3'b000;
    wire [2:0] _6762 = 3'b000;
    wire [2:0] _4972 = 3'b000;
    wire [2:0] _4973 = 3'b000;
    reg [2:0] _4974;
    reg [2:0] _6763;
    wire _6757 = 1'b0;
    wire _6758 = 1'b0;
    wire _4976 = 1'b0;
    wire _4977 = 1'b0;
    reg _4978;
    reg _6759;
    wire _6753 = 1'b0;
    wire _6754 = 1'b0;
    wire _4980 = 1'b0;
    wire _4981 = 1'b0;
    reg _4982;
    reg _6755;
    wire _6749 = 1'b0;
    wire _6750 = 1'b0;
    wire _4984 = 1'b0;
    wire _4985 = 1'b0;
    reg _4986;
    reg _6751;
    wire _6745 = 1'b0;
    wire _6746 = 1'b0;
    wire _4988 = 1'b0;
    wire _4989 = 1'b0;
    reg _4990;
    reg _6747;
    wire _6741 = 1'b0;
    wire _6742 = 1'b0;
    wire _4992 = 1'b0;
    wire _4993 = 1'b0;
    reg _4994;
    reg _6743;
    wire _6737 = 1'b0;
    wire _6738 = 1'b0;
    reg _6739;
    wire _6733 = 1'b0;
    wire _6734 = 1'b0;
    reg _6735;
    wire _6729 = 1'b0;
    wire _6730 = 1'b0;
    reg _6731;
    wire _6725 = 1'b0;
    wire _6726 = 1'b0;
    reg _6727;
    wire _6721 = 1'b0;
    wire _6722 = 1'b0;
    reg _6723;
    wire _6717 = 1'b0;
    wire _6718 = 1'b0;
    reg _6719;
    wire _6713 = 1'b0;
    wire _6714 = 1'b0;
    reg _6715;
    wire _6709 = 1'b0;
    wire _6710 = 1'b0;
    wire _5024 = 1'b0;
    wire _5025 = 1'b0;
    reg _5026;
    reg _6711;
    wire [47:0] _6705 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _6706 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _5028 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _5029 = 48'b000000000000000000000000000000000000000000000000;
    reg [47:0] _5030;
    reg [47:0] _6707;
    wire [31:0] _6701 = 32'b00000000000000000000000000000000;
    wire [31:0] _6702 = 32'b00000000000000000000000000000000;
    wire [31:0] _5032 = 32'b00000000000000000000000000000000;
    wire [31:0] _5033 = 32'b00000000000000000000000000000000;
    reg [31:0] _5034;
    reg [31:0] _6703;
    wire [31:0] _6697 = 32'b00000000000000000000000000000000;
    wire [31:0] _6698 = 32'b00000000000000000000000000000000;
    reg [31:0] _6699;
    wire [31:0] _6693 = 32'b00000000000000000000000000000000;
    wire [31:0] _6694 = 32'b00000000000000000000000000000000;
    reg [31:0] _6695;
    wire [31:0] _6689 = 32'b00000000000000000000000000000000;
    wire [31:0] _6690 = 32'b00000000000000000000000000000000;
    wire [31:0] _5044 = 32'b00000000000000000000000000000000;
    wire [31:0] _5045 = 32'b00000000000000000000000000000000;
    reg [31:0] _5046;
    reg [31:0] _6691;
    wire [31:0] _6685 = 32'b00000000000000000000000000000000;
    wire [31:0] _6686 = 32'b00000000000000000000000000000000;
    wire [31:0] _5040 = 32'b00000000000000000000000000000000;
    wire [31:0] _5041 = 32'b00000000000000000000000000000000;
    reg [31:0] _5042;
    wire [31:0] _5036 = 32'b00000000000000000000000000000000;
    wire [31:0] _5037 = 32'b00000000000000000000000000000000;
    reg [31:0] _5038;
    wire [31:0] _6644;
    wire [31:0] _6527;
    wire [31:0] _6528;
    wire [15:0] _6583;
    wire _6584;
    wire [1:0] _6585;
    wire [3:0] _6586;
    wire [7:0] _6587;
    wire [15:0] _6588;
    wire [31:0] _6590;
    wire [23:0] _6574;
    wire _6575;
    wire [1:0] _6576;
    wire [3:0] _6577;
    wire [7:0] _6578;
    wire [31:0] _6580;
    wire [27:0] _6566;
    wire _6567;
    wire [1:0] _6568;
    wire [3:0] _6569;
    wire [31:0] _6571;
    wire [29:0] _6559;
    wire _6560;
    wire [1:0] _6561;
    wire [31:0] _6563;
    wire [30:0] _6554;
    wire _6555;
    wire [31:0] _6556;
    wire _6557;
    wire [31:0] _6558;
    wire _6564;
    wire [31:0] _6565;
    wire _6572;
    wire [31:0] _6573;
    wire _6581;
    wire [31:0] _6582;
    wire _6591;
    wire [31:0] _6592;
    wire [15:0] _6549;
    wire [15:0] _6550 = 16'b0000000000000000;
    wire [31:0] _6551;
    wire [23:0] _6544;
    wire [7:0] _6545 = 8'b00000000;
    wire [31:0] _6546;
    wire [27:0] _6539;
    wire [3:0] _6540 = 4'b0000;
    wire [31:0] _6541;
    wire [29:0] _6534;
    wire [1:0] _6535 = 2'b00;
    wire [31:0] _6536;
    wire [30:0] _6529;
    wire _6530 = 1'b0;
    wire [31:0] _6531;
    wire _6532;
    wire [31:0] _6533;
    wire _6537;
    wire [31:0] _6538;
    wire _6542;
    wire [31:0] _6543;
    wire _6547;
    wire [31:0] _6548;
    wire _6552;
    wire [31:0] _6553;
    wire [31:0] _6593;
    wire [31:0] _6594;
    wire _6506;
    wire [30:0] _6602 = 31'b0000000000000000000000000000000;
    wire [31:0] _6604;
    wire [30:0] _6497;
    wire _6498;
    wire _6499;
    wire [31:0] _6500;
    wire [30:0] _6501;
    wire _6502;
    wire _6503;
    wire [31:0] _6504;
    wire _6505;
    wire [30:0] _6612 = 31'b0000000000000000000000000000000;
    wire [31:0] _6614;
    wire [15:0] _6635 = 16'b0000000000000000;
    wire [15:0] _6636;
    wire [31:0] _6637;
    wire [7:0] _6630 = 8'b00000000;
    wire [23:0] _6631;
    wire [31:0] _6632;
    wire [3:0] _6625 = 4'b0000;
    wire [27:0] _6626;
    wire [31:0] _6627;
    wire [1:0] _6620 = 2'b00;
    wire [29:0] _6621;
    wire [31:0] _6622;
    wire _6615 = 1'b0;
    wire [30:0] _6616;
    wire [31:0] _6617;
    wire _6618;
    wire [31:0] _6619;
    wire _6623;
    wire [31:0] _6624;
    wire _6628;
    wire [31:0] _6629;
    wire _6633;
    wire [31:0] _6634;
    wire [4:0] _6519;
    wire _6638;
    wire [31:0] _6639;
    wire [31:0] _6525;
    wire [31:0] _6524;
    wire gnd = 1'b0;
    wire _4964 = 1'b0;
    wire _4965 = 1'b0;
    reg _4966;
    wire _6523;
    wire [31:0] _6526;
    wire [2:0] _6640 = 3'b000;
    wire [2:0] _4968 = 3'b000;
    wire [2:0] _4969 = 3'b000;
    reg [2:0] _4970;
    wire _4996 = 1'b0;
    wire _4997 = 1'b0;
    reg _4998;
    wire _5000 = 1'b0;
    wire _5001 = 1'b0;
    reg _5002;
    wire _5008 = 1'b0;
    wire _5009 = 1'b0;
    reg _5010;
    wire _6520;
    wire _6521;
    wire _6522;
    wire [2:0] _6641;
    reg [31:0] _6642;
    wire _5016 = 1'b0;
    wire _5017 = 1'b0;
    reg _5018;
    wire _5012 = 1'b0;
    wire _5013 = 1'b0;
    reg _5014;
    wire _5004 = 1'b0;
    wire _5005 = 1'b0;
    reg _5006;
    wire _6645;
    wire _6646;
    wire [31:0] _6647;
    wire _5020 = 1'b0;
    wire _5021 = 1'b0;
    reg _5022;
    wire [31:0] _6648;
    reg [31:0] _6687;
    wire [31:0] _6681 = 32'b00000000000000000000000000000000;
    wire [31:0] _6682 = 32'b00000000000000000000000000000000;
    wire [31:0] _5052 = 32'b00000000000000000000000000000000;
    wire [31:0] _5053 = 32'b00000000000000000000000000000000;
    reg [31:0] _5054;
    reg [31:0] _6683;
    wire [31:0] _6677 = 32'b00000000000000000000000000000000;
    wire [31:0] _6678 = 32'b00000000000000000000000000000000;
    wire [31:0] _5056 = 32'b00000000000000000000000000000000;
    wire [31:0] _5057 = 32'b00000000000000000000000000000000;
    reg [31:0] _5058;
    reg [31:0] _6679;
    wire _6673 = 1'b0;
    wire _6674 = 1'b0;
    wire _5060 = 1'b0;
    wire _5061 = 1'b0;
    reg _5062;
    reg _6675;
    wire _6669 = 1'b0;
    wire _6670 = 1'b0;
    wire _5064 = 1'b0;
    wire _5065 = 1'b0;
    reg _5066;
    reg _6671;
    wire _6665 = 1'b0;
    wire _6666 = 1'b0;
    wire _5068 = 1'b0;
    wire _5069 = 1'b0;
    reg _5070;
    reg _6667;
    wire [4:0] _6661 = 5'b00000;
    wire [4:0] _6662 = 5'b00000;
    wire [4:0] _5072 = 5'b00000;
    wire [4:0] _5073 = 5'b00000;
    reg [4:0] _5074;
    reg [4:0] _6663;
    wire [4:0] _6657 = 5'b00000;
    wire [4:0] _6658 = 5'b00000;
    wire [4:0] _5076 = 5'b00000;
    wire [4:0] _5077 = 5'b00000;
    reg [4:0] _5078;
    reg [4:0] _6659;
    wire [4:0] _6653 = 5'b00000;
    wire [4:0] _6654 = 5'b00000;
    wire [4:0] _5080 = 5'b00000;
    wire [4:0] _5081 = 5'b00000;
    reg [4:0] _5082;
    reg [4:0] _6655;
    wire _6649 = 1'b0;
    wire _6650 = 1'b0;
    wire _5084 = 1'b0;
    wire vdd = 1'b1;
    wire _5085 = 1'b0;
    reg _5086;
    reg _6651;

    /* logic */
    always @(posedge clk) begin
        if (clr)
            _4914 <= _4912;
        else
            _4914 <= junk_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6823 <= _6821;
        else
            _6823 <= _4914;
    end
    always @(posedge clk) begin
        if (clr)
            _4918 <= _4916;
        else
            _4918 <= mio_data_wmask_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6819 <= _6817;
        else
            _6819 <= _4918;
    end
    always @(posedge clk) begin
        if (clr)
            _4922 <= _4920;
        else
            _4922 <= mio_data_rw_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6815 <= _6813;
        else
            _6815 <= _4922;
    end
    always @(posedge clk) begin
        if (clr)
            _4926 <= _4924;
        else
            _4926 <= mio_data_req_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6811 <= _6809;
        else
            _6811 <= _4926;
    end
    always @(posedge clk) begin
        if (clr)
            _4930 <= _4928;
        else
            _4930 <= mio_data_wdata_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6807 <= _6805;
        else
            _6807 <= _4930;
    end
    always @(posedge clk) begin
        if (clr)
            _4934 <= _4932;
        else
            _4934 <= mio_data_addr_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6803 <= _6801;
        else
            _6803 <= _4934;
    end
    always @(posedge clk) begin
        if (clr)
            _4938 <= _4936;
        else
            _4938 <= mio_instr_wmask_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6799 <= _6797;
        else
            _6799 <= _4938;
    end
    always @(posedge clk) begin
        if (clr)
            _4942 <= _4940;
        else
            _4942 <= mio_instr_rw_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6795 <= _6793;
        else
            _6795 <= _4942;
    end
    always @(posedge clk) begin
        if (clr)
            _4946 <= _4944;
        else
            _4946 <= mio_instr_req_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6791 <= _6789;
        else
            _6791 <= _4946;
    end
    always @(posedge clk) begin
        if (clr)
            _4950 <= _4948;
        else
            _4950 <= mio_instr_wdata_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6787 <= _6785;
        else
            _6787 <= _4950;
    end
    always @(posedge clk) begin
        if (clr)
            _4954 <= _4952;
        else
            _4954 <= mio_instr_addr_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6783 <= _6781;
        else
            _6783 <= _4954;
    end
    always @(posedge clk) begin
        if (clr)
            _4958 <= _4956;
        else
            _4958 <= rwe_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6779 <= _6777;
        else
            _6779 <= _4958;
    end
    assign _6517 = _5058 < _5054;
    assign _6518 = ~ _6517;
    assign _6507 = _5054[30:0];
    assign _6508 = _5054[31:31];
    assign _6509 = ~ _6508;
    assign _6510 = { _6509, _6507 };
    assign _6511 = _5058[30:0];
    assign _6512 = _5058[31:31];
    assign _6513 = ~ _6512;
    assign _6514 = { _6513, _6511 };
    assign _6515 = _6514 < _6510;
    assign _6516 = ~ _6515;
    assign _6496 = ~ _6495;
    assign _6495 = _5058 == _5054;
    always @* begin
        case (_4970)
        0: _6643 <= _6495;
        1: _6643 <= _6496;
        2: _6643 <= gnd;
        3: _6643 <= gnd;
        4: _6643 <= _6505;
        5: _6643 <= _6516;
        6: _6643 <= _6506;
        default: _6643 <= _6518;
        endcase
    end
    always @(posedge clk) begin
        if (clr)
            _6775 <= _6773;
        else
            _6775 <= _6643;
    end
    always @(posedge clk) begin
        if (clr)
            _6771 <= _6769;
        else
            _6771 <= _4966;
    end
    always @(posedge clk) begin
        if (clr)
            _6767 <= _6765;
        else
            _6767 <= _4970;
    end
    always @(posedge clk) begin
        if (clr)
            _4974 <= _4972;
        else
            _4974 <= rdco_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6763 <= _6761;
        else
            _6763 <= _4974;
    end
    always @(posedge clk) begin
        if (clr)
            _4978 <= _4976;
        else
            _4978 <= rdc_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6759 <= _6757;
        else
            _6759 <= _4978;
    end
    always @(posedge clk) begin
        if (clr)
            _4982 <= _4980;
        else
            _4982 <= sys_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6755 <= _6753;
        else
            _6755 <= _4982;
    end
    always @(posedge clk) begin
        if (clr)
            _4986 <= _4984;
        else
            _4986 <= fen_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6751 <= _6749;
        else
            _6751 <= _4986;
    end
    always @(posedge clk) begin
        if (clr)
            _4990 <= _4988;
        else
            _4990 <= opr_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6747 <= _6745;
        else
            _6747 <= _4990;
    end
    always @(posedge clk) begin
        if (clr)
            _4994 <= _4992;
        else
            _4994 <= opi_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6743 <= _6741;
        else
            _6743 <= _4994;
    end
    always @(posedge clk) begin
        if (clr)
            _6739 <= _6737;
        else
            _6739 <= _4998;
    end
    always @(posedge clk) begin
        if (clr)
            _6735 <= _6733;
        else
            _6735 <= _5002;
    end
    always @(posedge clk) begin
        if (clr)
            _6731 <= _6729;
        else
            _6731 <= _5006;
    end
    always @(posedge clk) begin
        if (clr)
            _6727 <= _6725;
        else
            _6727 <= _5010;
    end
    always @(posedge clk) begin
        if (clr)
            _6723 <= _6721;
        else
            _6723 <= _5014;
    end
    always @(posedge clk) begin
        if (clr)
            _6719 <= _6717;
        else
            _6719 <= _5018;
    end
    always @(posedge clk) begin
        if (clr)
            _6715 <= _6713;
        else
            _6715 <= _5022;
    end
    always @(posedge clk) begin
        if (clr)
            _5026 <= _5024;
        else
            _5026 <= trap_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6711 <= _6709;
        else
            _6711 <= _5026;
    end
    always @(posedge clk) begin
        if (clr)
            _5030 <= _5028;
        else
            _5030 <= insn_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6707 <= _6705;
        else
            _6707 <= _5030;
    end
    always @(posedge clk) begin
        if (clr)
            _5034 <= _5032;
        else
            _5034 <= instr_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6703 <= _6701;
        else
            _6703 <= _5034;
    end
    always @(posedge clk) begin
        if (clr)
            _6699 <= _6697;
        else
            _6699 <= _5038;
    end
    always @(posedge clk) begin
        if (clr)
            _6695 <= _6693;
        else
            _6695 <= _5042;
    end
    always @(posedge clk) begin
        if (clr)
            _5046 <= _5044;
        else
            _5046 <= rdm_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6691 <= _6689;
        else
            _6691 <= _5046;
    end
    always @(posedge clk) begin
        if (clr)
            _5042 <= _5040;
        else
            _5042 <= imm_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5038 <= _5036;
        else
            _5038 <= pc_p_1;
    end
    assign _6644 = _5038 + _5042;
    assign _6527 = _5058 & _5054;
    assign _6528 = _5058 | _5054;
    assign _6583 = _6582[31:16];
    assign _6584 = _6582[31:31];
    assign _6585 = { _6584, _6584 };
    assign _6586 = { _6585, _6585 };
    assign _6587 = { _6586, _6586 };
    assign _6588 = { _6587, _6587 };
    assign _6590 = { _6588, _6583 };
    assign _6574 = _6573[31:8];
    assign _6575 = _6573[31:31];
    assign _6576 = { _6575, _6575 };
    assign _6577 = { _6576, _6576 };
    assign _6578 = { _6577, _6577 };
    assign _6580 = { _6578, _6574 };
    assign _6566 = _6565[31:4];
    assign _6567 = _6565[31:31];
    assign _6568 = { _6567, _6567 };
    assign _6569 = { _6568, _6568 };
    assign _6571 = { _6569, _6566 };
    assign _6559 = _6558[31:2];
    assign _6560 = _6558[31:31];
    assign _6561 = { _6560, _6560 };
    assign _6563 = { _6561, _6559 };
    assign _6554 = _5058[31:1];
    assign _6555 = _5058[31:31];
    assign _6556 = { _6555, _6554 };
    assign _6557 = _6519[0:0];
    assign _6558 = _6557 ? _6556 : _5058;
    assign _6564 = _6519[1:1];
    assign _6565 = _6564 ? _6563 : _6558;
    assign _6572 = _6519[2:2];
    assign _6573 = _6572 ? _6571 : _6565;
    assign _6581 = _6519[3:3];
    assign _6582 = _6581 ? _6580 : _6573;
    assign _6591 = _6519[4:4];
    assign _6592 = _6591 ? _6590 : _6582;
    assign _6549 = _6548[31:16];
    assign _6551 = { _6550, _6549 };
    assign _6544 = _6543[31:8];
    assign _6546 = { _6545, _6544 };
    assign _6539 = _6538[31:4];
    assign _6541 = { _6540, _6539 };
    assign _6534 = _6533[31:2];
    assign _6536 = { _6535, _6534 };
    assign _6529 = _5054[31:1];
    assign _6531 = { _6530, _6529 };
    assign _6532 = _6519[0:0];
    assign _6533 = _6532 ? _6531 : _5054;
    assign _6537 = _6519[1:1];
    assign _6538 = _6537 ? _6536 : _6533;
    assign _6542 = _6519[2:2];
    assign _6543 = _6542 ? _6541 : _6538;
    assign _6547 = _6519[3:3];
    assign _6548 = _6547 ? _6546 : _6543;
    assign _6552 = _6519[4:4];
    assign _6553 = _6552 ? _6551 : _6548;
    assign _6593 = _4966 ? _6592 : _6553;
    assign _6594 = _5058 ^ _5054;
    assign _6506 = _5058 < _5054;
    assign _6604 = { _6602, _6506 };
    assign _6497 = _5054[30:0];
    assign _6498 = _5054[31:31];
    assign _6499 = ~ _6498;
    assign _6500 = { _6499, _6497 };
    assign _6501 = _5058[30:0];
    assign _6502 = _5058[31:31];
    assign _6503 = ~ _6502;
    assign _6504 = { _6503, _6501 };
    assign _6505 = _6504 < _6500;
    assign _6614 = { _6612, _6505 };
    assign _6636 = _6634[15:0];
    assign _6637 = { _6636, _6635 };
    assign _6631 = _6629[23:0];
    assign _6632 = { _6631, _6630 };
    assign _6626 = _6624[27:0];
    assign _6627 = { _6626, _6625 };
    assign _6621 = _6619[29:0];
    assign _6622 = { _6621, _6620 };
    assign _6616 = _5058[30:0];
    assign _6617 = { _6616, _6615 };
    assign _6618 = _6519[0:0];
    assign _6619 = _6618 ? _6617 : _5058;
    assign _6623 = _6519[1:1];
    assign _6624 = _6623 ? _6622 : _6619;
    assign _6628 = _6519[2:2];
    assign _6629 = _6628 ? _6627 : _6624;
    assign _6633 = _6519[3:3];
    assign _6634 = _6633 ? _6632 : _6629;
    assign _6519 = _5054[4:0];
    assign _6638 = _6519[4:4];
    assign _6639 = _6638 ? _6637 : _6634;
    assign _6525 = _5058 - _5054;
    assign _6524 = _5058 + _5054;
    always @(posedge clk) begin
        if (clr)
            _4966 <= _4964;
        else
            _4966 <= f7_p_1;
    end
    assign _6523 = _6522 ? gnd : _4966;
    assign _6526 = _6523 ? _6525 : _6524;
    always @(posedge clk) begin
        if (clr)
            _4970 <= _4968;
        else
            _4970 <= f3_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _4998 <= _4996;
        else
            _4998 <= st_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5002 <= _5000;
        else
            _5002 <= ld_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5010 <= _5008;
        else
            _5010 <= jalr_p_1;
    end
    assign _6520 = _5014 | _5010;
    assign _6521 = _6520 | _5002;
    assign _6522 = _6521 | _4998;
    assign _6641 = _6522 ? _6640 : _4970;
    always @* begin
        case (_6641)
        0: _6642 <= _6526;
        1: _6642 <= _6639;
        2: _6642 <= _6614;
        3: _6642 <= _6604;
        4: _6642 <= _6594;
        5: _6642 <= _6593;
        6: _6642 <= _6528;
        default: _6642 <= _6527;
        endcase
    end
    always @(posedge clk) begin
        if (clr)
            _5018 <= _5016;
        else
            _5018 <= auipc_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5014 <= _5012;
        else
            _5014 <= jal_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _5006 <= _5004;
        else
            _5006 <= bra_p_1;
    end
    assign _6645 = _5006 | _5014;
    assign _6646 = _6645 | _5018;
    assign _6647 = _6646 ? _6644 : _6642;
    always @(posedge clk) begin
        if (clr)
            _5022 <= _5020;
        else
            _5022 <= lui_p_1;
    end
    assign _6648 = _5022 ? _5054 : _6647;
    always @(posedge clk) begin
        if (clr)
            _6687 <= _6685;
        else
            _6687 <= _6648;
    end
    always @(posedge clk) begin
        if (clr)
            _5054 <= _5052;
        else
            _5054 <= rd2_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6683 <= _6681;
        else
            _6683 <= _5054;
    end
    always @(posedge clk) begin
        if (clr)
            _5058 <= _5056;
        else
            _5058 <= rd1_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6679 <= _6677;
        else
            _6679 <= _5058;
    end
    always @(posedge clk) begin
        if (clr)
            _5062 <= _5060;
        else
            _5062 <= rad_zero_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6675 <= _6673;
        else
            _6675 <= _5062;
    end
    always @(posedge clk) begin
        if (clr)
            _5066 <= _5064;
        else
            _5066 <= ra2_zero_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6671 <= _6669;
        else
            _6671 <= _5066;
    end
    always @(posedge clk) begin
        if (clr)
            _5070 <= _5068;
        else
            _5070 <= ra1_zero_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6667 <= _6665;
        else
            _6667 <= _5070;
    end
    always @(posedge clk) begin
        if (clr)
            _5074 <= _5072;
        else
            _5074 <= rad_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6663 <= _6661;
        else
            _6663 <= _5074;
    end
    always @(posedge clk) begin
        if (clr)
            _5078 <= _5076;
        else
            _5078 <= ra2_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6659 <= _6657;
        else
            _6659 <= _5078;
    end
    always @(posedge clk) begin
        if (clr)
            _5082 <= _5080;
        else
            _5082 <= ra1_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6655 <= _6653;
        else
            _6655 <= _5082;
    end
    always @(posedge clk) begin
        if (clr)
            _5086 <= _5084;
        else
            _5086 <= pen_p_1;
    end
    always @(posedge clk) begin
        if (clr)
            _6651 <= _6649;
        else
            _6651 <= _5086;
    end

    /* aliases */

    /* output assignments */
    assign pen = _6651;
    assign ra1 = _6655;
    assign ra2 = _6659;
    assign rad = _6663;
    assign ra1_zero = _6667;
    assign ra2_zero = _6671;
    assign rad_zero = _6675;
    assign rd1 = _6679;
    assign rd2 = _6683;
    assign rdd = _6687;
    assign rdm = _6691;
    assign imm = _6695;
    assign pc = _6699;
    assign instr = _6703;
    assign insn = _6707;
    assign trap = _6711;
    assign lui = _6715;
    assign auipc = _6719;
    assign jal = _6723;
    assign jalr = _6727;
    assign bra = _6731;
    assign ld = _6735;
    assign st = _6739;
    assign opi = _6743;
    assign opr = _6747;
    assign fen = _6751;
    assign sys = _6755;
    assign rdc = _6759;
    assign rdco = _6763;
    assign f3 = _6767;
    assign f7 = _6771;
    assign branch = _6775;
    assign rwe = _6779;
    assign mio_instr_addr = _6783;
    assign mio_instr_wdata = _6787;
    assign mio_instr_req = _6791;
    assign mio_instr_rw = _6795;
    assign mio_instr_wmask = _6799;
    assign mio_data_addr = _6803;
    assign mio_data_wdata = _6807;
    assign mio_data_req = _6811;
    assign mio_data_rw = _6815;
    assign mio_data_wmask = _6819;
    assign junk = _6823;

endmodule
