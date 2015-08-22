module memory (
    junk_p_2,
    mio_instr_wmask_p_2,
    mio_instr_rw_p_2,
    mio_instr_req_p_2,
    mio_instr_wdata_p_2,
    mio_instr_addr_p_2,
    rwe_p_2,
    branch_p_2,
    f7_p_2,
    rdco_p_2,
    rdc_p_2,
    sys_p_2,
    fen_p_2,
    opr_p_2,
    opi_p_2,
    st_p_2,
    bra_p_2,
    jalr_p_2,
    jal_p_2,
    auipc_p_2,
    lui_p_2,
    trap_p_2,
    insn_p_2,
    instr_p_2,
    pc_p_2,
    imm_p_2,
    rdm_p_2,
    mio_data_rdata,
    f3_p_2,
    rdd_p_2,
    ld_p_2,
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

    input junk_p_2;
    input [3:0] mio_instr_wmask_p_2;
    input mio_instr_rw_p_2;
    input mio_instr_req_p_2;
    input [31:0] mio_instr_wdata_p_2;
    input [31:0] mio_instr_addr_p_2;
    input rwe_p_2;
    input branch_p_2;
    input f7_p_2;
    input [2:0] rdco_p_2;
    input rdc_p_2;
    input sys_p_2;
    input fen_p_2;
    input opr_p_2;
    input opi_p_2;
    input st_p_2;
    input bra_p_2;
    input jalr_p_2;
    input jal_p_2;
    input auipc_p_2;
    input lui_p_2;
    input trap_p_2;
    input [47:0] insn_p_2;
    input [31:0] instr_p_2;
    input [31:0] pc_p_2;
    input [31:0] imm_p_2;
    input [31:0] rdm_p_2;
    input [31:0] mio_data_rdata;
    input [2:0] f3_p_2;
    input [31:0] rdd_p_2;
    input ld_p_2;
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
    wire _8881 = 1'b0;
    wire _8882 = 1'b0;
    wire _7184 = 1'b0;
    wire _7185 = 1'b0;
    reg _7186;
    reg _8883;
    wire [3:0] _8877 = 4'b0000;
    wire [3:0] _8878 = 4'b0000;
    wire [3:0] _8594 = 4'b1111;
    wire [3:0] _8596 = 4'b1100;
    wire [3:0] _8595 = 4'b0011;
    wire _8597;
    wire [3:0] _8598;
    wire [3:0] _8602 = 4'b1000;
    wire [3:0] _8601 = 4'b0100;
    wire [3:0] _8600 = 4'b0010;
    wire [3:0] _8599 = 4'b0001;
    reg [3:0] _8603;
    reg [3:0] _8604;
    reg [3:0] _8879;
    wire _8873 = 1'b0;
    wire _8874 = 1'b0;
    reg _8875;
    wire _8869 = 1'b0;
    wire _8870 = 1'b0;
    wire _8707;
    reg _8871;
    wire [31:0] _8865 = 32'b00000000000000000000000000000000;
    wire [31:0] _8866 = 32'b00000000000000000000000000000000;
    wire [15:0] _8619 = 16'b0000000000000000;
    wire [15:0] _8612;
    wire [15:0] _8616 = 16'b0000000000000000;
    wire [31:0] _8618;
    wire [15:0] _8620;
    wire [31:0] _8621;
    wire [15:0] _8605;
    wire [15:0] _8609 = 16'b0000000000000000;
    wire [31:0] _8611;
    wire _8622;
    wire [31:0] _8623;
    wire [23:0] _8662 = 24'b000000000000000000000000;
    wire [7:0] _8654;
    wire [23:0] _8659 = 24'b000000000000000000000000;
    wire [31:0] _8661;
    wire [7:0] _8663;
    wire [31:0] _8664;
    wire [15:0] _8651 = 16'b0000000000000000;
    wire [7:0] _8643;
    wire [23:0] _8648 = 24'b000000000000000000000000;
    wire [31:0] _8650;
    wire [15:0] _8652;
    wire [31:0] _8653;
    wire [7:0] _8640 = 8'b00000000;
    wire [7:0] _8632;
    wire [23:0] _8637 = 24'b000000000000000000000000;
    wire [31:0] _8639;
    wire [23:0] _8641;
    wire [31:0] _8642;
    wire [7:0] _8624;
    wire [23:0] _8629 = 24'b000000000000000000000000;
    wire [31:0] _8631;
    reg [31:0] _8665;
    reg [31:0] _8666;
    reg [31:0] _8867;
    wire [31:0] _8861 = 32'b00000000000000000000000000000000;
    wire [31:0] _8862 = 32'b00000000000000000000000000000000;
    reg [31:0] _8863;
    wire [3:0] _8857 = 4'b0000;
    wire [3:0] _8858 = 4'b0000;
    wire [3:0] _7208 = 4'b0000;
    wire [3:0] _7209 = 4'b0000;
    reg [3:0] _7210;
    reg [3:0] _8859;
    wire _8853 = 1'b0;
    wire _8854 = 1'b0;
    wire _7212 = 1'b0;
    wire _7213 = 1'b0;
    reg _7214;
    reg _8855;
    wire _8849 = 1'b0;
    wire _8850 = 1'b0;
    wire _7216 = 1'b0;
    wire _7217 = 1'b0;
    reg _7218;
    reg _8851;
    wire [31:0] _8845 = 32'b00000000000000000000000000000000;
    wire [31:0] _8846 = 32'b00000000000000000000000000000000;
    wire [31:0] _7220 = 32'b00000000000000000000000000000000;
    wire [31:0] _7221 = 32'b00000000000000000000000000000000;
    reg [31:0] _7222;
    reg [31:0] _8847;
    wire [31:0] _8841 = 32'b00000000000000000000000000000000;
    wire [31:0] _8842 = 32'b00000000000000000000000000000000;
    wire [31:0] _7224 = 32'b00000000000000000000000000000000;
    wire [31:0] _7225 = 32'b00000000000000000000000000000000;
    reg [31:0] _7226;
    reg [31:0] _8843;
    wire _8837 = 1'b0;
    wire _8838 = 1'b0;
    wire _7228 = 1'b0;
    wire _7229 = 1'b0;
    reg _7230;
    reg _8839;
    wire _8833 = 1'b0;
    wire _8834 = 1'b0;
    wire _7232 = 1'b0;
    wire _7233 = 1'b0;
    reg _7234;
    reg _8835;
    wire _8829 = 1'b0;
    wire _8830 = 1'b0;
    wire _7236 = 1'b0;
    wire _7237 = 1'b0;
    reg _7238;
    reg _8831;
    wire [2:0] _8825 = 3'b000;
    wire [2:0] _8826 = 3'b000;
    reg [2:0] _8827;
    wire [2:0] _8821 = 3'b000;
    wire [2:0] _8822 = 3'b000;
    wire [2:0] _7244 = 3'b000;
    wire [2:0] _7245 = 3'b000;
    reg [2:0] _7246;
    reg [2:0] _8823;
    wire _8817 = 1'b0;
    wire _8818 = 1'b0;
    wire _7248 = 1'b0;
    wire _7249 = 1'b0;
    reg _7250;
    reg _8819;
    wire _8813 = 1'b0;
    wire _8814 = 1'b0;
    wire _7252 = 1'b0;
    wire _7253 = 1'b0;
    reg _7254;
    reg _8815;
    wire _8809 = 1'b0;
    wire _8810 = 1'b0;
    wire _7256 = 1'b0;
    wire _7257 = 1'b0;
    reg _7258;
    reg _8811;
    wire _8805 = 1'b0;
    wire _8806 = 1'b0;
    wire _7260 = 1'b0;
    wire _7261 = 1'b0;
    reg _7262;
    reg _8807;
    wire _8801 = 1'b0;
    wire _8802 = 1'b0;
    wire _7264 = 1'b0;
    wire _7265 = 1'b0;
    reg _7266;
    reg _8803;
    wire _8797 = 1'b0;
    wire _8798 = 1'b0;
    wire _7268 = 1'b0;
    wire _7269 = 1'b0;
    reg _7270;
    reg _8799;
    wire _8793 = 1'b0;
    wire _8794 = 1'b0;
    reg _8795;
    wire _8789 = 1'b0;
    wire _8790 = 1'b0;
    wire _7276 = 1'b0;
    wire _7277 = 1'b0;
    reg _7278;
    reg _8791;
    wire _8785 = 1'b0;
    wire _8786 = 1'b0;
    wire _7280 = 1'b0;
    wire _7281 = 1'b0;
    reg _7282;
    reg _8787;
    wire _8781 = 1'b0;
    wire _8782 = 1'b0;
    wire _7284 = 1'b0;
    wire _7285 = 1'b0;
    reg _7286;
    reg _8783;
    wire _8777 = 1'b0;
    wire _8778 = 1'b0;
    wire _7288 = 1'b0;
    wire _7289 = 1'b0;
    reg _7290;
    reg _8779;
    wire _8773 = 1'b0;
    wire _8774 = 1'b0;
    wire _7292 = 1'b0;
    wire _7293 = 1'b0;
    reg _7294;
    reg _8775;
    wire _8769 = 1'b0;
    wire _8770 = 1'b0;
    wire _7296 = 1'b0;
    wire _7297 = 1'b0;
    reg _7298;
    reg _8771;
    wire [47:0] _8765 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _8766 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _7300 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _7301 = 48'b000000000000000000000000000000000000000000000000;
    reg [47:0] _7302;
    reg [47:0] _8767;
    wire [31:0] _8761 = 32'b00000000000000000000000000000000;
    wire [31:0] _8762 = 32'b00000000000000000000000000000000;
    wire [31:0] _7304 = 32'b00000000000000000000000000000000;
    wire [31:0] _7305 = 32'b00000000000000000000000000000000;
    reg [31:0] _7306;
    reg [31:0] _8763;
    wire [31:0] _8757 = 32'b00000000000000000000000000000000;
    wire [31:0] _8758 = 32'b00000000000000000000000000000000;
    wire [31:0] _7308 = 32'b00000000000000000000000000000000;
    wire [31:0] _7309 = 32'b00000000000000000000000000000000;
    reg [31:0] _7310;
    reg [31:0] _8759;
    wire [31:0] _8753 = 32'b00000000000000000000000000000000;
    wire [31:0] _8754 = 32'b00000000000000000000000000000000;
    wire [31:0] _7312 = 32'b00000000000000000000000000000000;
    wire [31:0] _7313 = 32'b00000000000000000000000000000000;
    reg [31:0] _7314;
    reg [31:0] _8755;
    wire [31:0] _8749 = 32'b00000000000000000000000000000000;
    wire [31:0] _8750 = 32'b00000000000000000000000000000000;
    wire [31:0] _7316 = 32'b00000000000000000000000000000000;
    wire [31:0] _7317 = 32'b00000000000000000000000000000000;
    reg [31:0] _7318;
    reg [31:0] _8751;
    wire [31:0] _8745 = 32'b00000000000000000000000000000000;
    wire [31:0] _8746 = 32'b00000000000000000000000000000000;
    wire _8698;
    wire [1:0] _8699;
    wire [3:0] _8700;
    wire [7:0] _8701;
    wire [15:0] _8702;
    wire [31:0] _8704;
    wire [15:0] _8688;
    wire [15:0] _8689;
    wire _8690;
    wire [15:0] _8691;
    wire [15:0] _8695 = 16'b0000000000000000;
    wire [31:0] _8697;
    wire [31:0] _8705;
    wire _8679;
    wire [1:0] _8680;
    wire [3:0] _8681;
    wire [7:0] _8682;
    wire [15:0] _8683;
    wire [23:0] _8684;
    wire [31:0] _8686;
    wire [7:0] _8667;
    wire [7:0] _8668;
    wire [7:0] _8669;
    wire [7:0] _8670;
    wire [1:0] _8591;
    reg [7:0] _8671;
    wire [23:0] _8676 = 24'b000000000000000000000000;
    wire [31:0] _8678;
    wire _8593;
    wire [31:0] _8687;
    wire [2:0] _7240 = 3'b000;
    wire [2:0] _7241 = 3'b000;
    reg [2:0] _7242;
    wire [1:0] _8592;
    reg [31:0] _8706;
    wire [31:0] _7320 = 32'b00000000000000000000000000000000;
    wire [31:0] _7321 = 32'b00000000000000000000000000000000;
    reg [31:0] _7322;
    wire _7272 = 1'b0;
    wire _7273 = 1'b0;
    reg _7274;
    wire [31:0] _8708;
    reg [31:0] _8747;
    wire [31:0] _8741 = 32'b00000000000000000000000000000000;
    wire [31:0] _8742 = 32'b00000000000000000000000000000000;
    wire [31:0] _7324 = 32'b00000000000000000000000000000000;
    wire [31:0] _7325 = 32'b00000000000000000000000000000000;
    reg [31:0] _7326;
    reg [31:0] _8743;
    wire [31:0] _8737 = 32'b00000000000000000000000000000000;
    wire [31:0] _8738 = 32'b00000000000000000000000000000000;
    wire [31:0] _7328 = 32'b00000000000000000000000000000000;
    wire [31:0] _7329 = 32'b00000000000000000000000000000000;
    reg [31:0] _7330;
    reg [31:0] _8739;
    wire _8733 = 1'b0;
    wire _8734 = 1'b0;
    wire _7332 = 1'b0;
    wire _7333 = 1'b0;
    reg _7334;
    reg _8735;
    wire _8729 = 1'b0;
    wire _8730 = 1'b0;
    wire _7336 = 1'b0;
    wire _7337 = 1'b0;
    reg _7338;
    reg _8731;
    wire _8725 = 1'b0;
    wire _8726 = 1'b0;
    wire _7340 = 1'b0;
    wire _7341 = 1'b0;
    reg _7342;
    reg _8727;
    wire [4:0] _8721 = 5'b00000;
    wire [4:0] _8722 = 5'b00000;
    wire [4:0] _7344 = 5'b00000;
    wire [4:0] _7345 = 5'b00000;
    reg [4:0] _7346;
    reg [4:0] _8723;
    wire [4:0] _8717 = 5'b00000;
    wire [4:0] _8718 = 5'b00000;
    wire [4:0] _7348 = 5'b00000;
    wire [4:0] _7349 = 5'b00000;
    reg [4:0] _7350;
    reg [4:0] _8719;
    wire [4:0] _8713 = 5'b00000;
    wire [4:0] _8714 = 5'b00000;
    wire [4:0] _7352 = 5'b00000;
    wire [4:0] _7353 = 5'b00000;
    reg [4:0] _7354;
    reg [4:0] _8715;
    wire _8709 = 1'b0;
    wire _8710 = 1'b0;
    wire _7356 = 1'b0;
    wire vdd = 1'b1;
    wire _7357 = 1'b0;
    reg _7358;
    reg _8711;

    /* logic */
    always @(posedge clk) begin
        if (clr)
            _7186 <= _7184;
        else
            _7186 <= junk_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8883 <= _8881;
        else
            _8883 <= _7186;
    end
    assign _8597 = _8591[1:1];
    assign _8598 = _8597 ? _8596 : _8595;
    always @* begin
        case (_8591)
        0: _8603 <= _8599;
        1: _8603 <= _8600;
        2: _8603 <= _8601;
        default: _8603 <= _8602;
        endcase
    end
    always @* begin
        case (_8592)
        0: _8604 <= _8603;
        1: _8604 <= _8598;
        default: _8604 <= _8594;
        endcase
    end
    always @(posedge clk) begin
        if (clr)
            _8879 <= _8877;
        else
            _8879 <= _8604;
    end
    always @(posedge clk) begin
        if (clr)
            _8875 <= _8873;
        else
            _8875 <= _7274;
    end
    assign _8707 = _7270 | _7274;
    always @(posedge clk) begin
        if (clr)
            _8871 <= _8869;
        else
            _8871 <= _8707;
    end
    assign _8612 = _7318[15:0];
    assign _8618 = { _8616, _8612 };
    assign _8620 = _8618[15:0];
    assign _8621 = { _8620, _8619 };
    assign _8605 = _7318[15:0];
    assign _8611 = { _8609, _8605 };
    assign _8622 = _8591[1:1];
    assign _8623 = _8622 ? _8621 : _8611;
    assign _8654 = _7318[7:0];
    assign _8661 = { _8659, _8654 };
    assign _8663 = _8661[7:0];
    assign _8664 = { _8663, _8662 };
    assign _8643 = _7318[7:0];
    assign _8650 = { _8648, _8643 };
    assign _8652 = _8650[15:0];
    assign _8653 = { _8652, _8651 };
    assign _8632 = _7318[7:0];
    assign _8639 = { _8637, _8632 };
    assign _8641 = _8639[23:0];
    assign _8642 = { _8641, _8640 };
    assign _8624 = _7318[7:0];
    assign _8631 = { _8629, _8624 };
    always @* begin
        case (_8591)
        0: _8665 <= _8631;
        1: _8665 <= _8642;
        2: _8665 <= _8653;
        default: _8665 <= _8664;
        endcase
    end
    always @* begin
        case (_8592)
        0: _8666 <= _8665;
        1: _8666 <= _8623;
        default: _8666 <= _7318;
        endcase
    end
    always @(posedge clk) begin
        if (clr)
            _8867 <= _8865;
        else
            _8867 <= _8666;
    end
    always @(posedge clk) begin
        if (clr)
            _8863 <= _8861;
        else
            _8863 <= _7322;
    end
    always @(posedge clk) begin
        if (clr)
            _7210 <= _7208;
        else
            _7210 <= mio_instr_wmask_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8859 <= _8857;
        else
            _8859 <= _7210;
    end
    always @(posedge clk) begin
        if (clr)
            _7214 <= _7212;
        else
            _7214 <= mio_instr_rw_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8855 <= _8853;
        else
            _8855 <= _7214;
    end
    always @(posedge clk) begin
        if (clr)
            _7218 <= _7216;
        else
            _7218 <= mio_instr_req_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8851 <= _8849;
        else
            _8851 <= _7218;
    end
    always @(posedge clk) begin
        if (clr)
            _7222 <= _7220;
        else
            _7222 <= mio_instr_wdata_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8847 <= _8845;
        else
            _8847 <= _7222;
    end
    always @(posedge clk) begin
        if (clr)
            _7226 <= _7224;
        else
            _7226 <= mio_instr_addr_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8843 <= _8841;
        else
            _8843 <= _7226;
    end
    always @(posedge clk) begin
        if (clr)
            _7230 <= _7228;
        else
            _7230 <= rwe_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8839 <= _8837;
        else
            _8839 <= _7230;
    end
    always @(posedge clk) begin
        if (clr)
            _7234 <= _7232;
        else
            _7234 <= branch_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8835 <= _8833;
        else
            _8835 <= _7234;
    end
    always @(posedge clk) begin
        if (clr)
            _7238 <= _7236;
        else
            _7238 <= f7_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8831 <= _8829;
        else
            _8831 <= _7238;
    end
    always @(posedge clk) begin
        if (clr)
            _8827 <= _8825;
        else
            _8827 <= _7242;
    end
    always @(posedge clk) begin
        if (clr)
            _7246 <= _7244;
        else
            _7246 <= rdco_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8823 <= _8821;
        else
            _8823 <= _7246;
    end
    always @(posedge clk) begin
        if (clr)
            _7250 <= _7248;
        else
            _7250 <= rdc_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8819 <= _8817;
        else
            _8819 <= _7250;
    end
    always @(posedge clk) begin
        if (clr)
            _7254 <= _7252;
        else
            _7254 <= sys_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8815 <= _8813;
        else
            _8815 <= _7254;
    end
    always @(posedge clk) begin
        if (clr)
            _7258 <= _7256;
        else
            _7258 <= fen_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8811 <= _8809;
        else
            _8811 <= _7258;
    end
    always @(posedge clk) begin
        if (clr)
            _7262 <= _7260;
        else
            _7262 <= opr_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8807 <= _8805;
        else
            _8807 <= _7262;
    end
    always @(posedge clk) begin
        if (clr)
            _7266 <= _7264;
        else
            _7266 <= opi_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8803 <= _8801;
        else
            _8803 <= _7266;
    end
    always @(posedge clk) begin
        if (clr)
            _7270 <= _7268;
        else
            _7270 <= st_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8799 <= _8797;
        else
            _8799 <= _7270;
    end
    always @(posedge clk) begin
        if (clr)
            _8795 <= _8793;
        else
            _8795 <= _7274;
    end
    always @(posedge clk) begin
        if (clr)
            _7278 <= _7276;
        else
            _7278 <= bra_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8791 <= _8789;
        else
            _8791 <= _7278;
    end
    always @(posedge clk) begin
        if (clr)
            _7282 <= _7280;
        else
            _7282 <= jalr_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8787 <= _8785;
        else
            _8787 <= _7282;
    end
    always @(posedge clk) begin
        if (clr)
            _7286 <= _7284;
        else
            _7286 <= jal_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8783 <= _8781;
        else
            _8783 <= _7286;
    end
    always @(posedge clk) begin
        if (clr)
            _7290 <= _7288;
        else
            _7290 <= auipc_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8779 <= _8777;
        else
            _8779 <= _7290;
    end
    always @(posedge clk) begin
        if (clr)
            _7294 <= _7292;
        else
            _7294 <= lui_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8775 <= _8773;
        else
            _8775 <= _7294;
    end
    always @(posedge clk) begin
        if (clr)
            _7298 <= _7296;
        else
            _7298 <= trap_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8771 <= _8769;
        else
            _8771 <= _7298;
    end
    always @(posedge clk) begin
        if (clr)
            _7302 <= _7300;
        else
            _7302 <= insn_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8767 <= _8765;
        else
            _8767 <= _7302;
    end
    always @(posedge clk) begin
        if (clr)
            _7306 <= _7304;
        else
            _7306 <= instr_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8763 <= _8761;
        else
            _8763 <= _7306;
    end
    always @(posedge clk) begin
        if (clr)
            _7310 <= _7308;
        else
            _7310 <= pc_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8759 <= _8757;
        else
            _8759 <= _7310;
    end
    always @(posedge clk) begin
        if (clr)
            _7314 <= _7312;
        else
            _7314 <= imm_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8755 <= _8753;
        else
            _8755 <= _7314;
    end
    always @(posedge clk) begin
        if (clr)
            _7318 <= _7316;
        else
            _7318 <= rdm_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8751 <= _8749;
        else
            _8751 <= _7318;
    end
    assign _8698 = _8691[15:15];
    assign _8699 = { _8698, _8698 };
    assign _8700 = { _8699, _8699 };
    assign _8701 = { _8700, _8700 };
    assign _8702 = { _8701, _8701 };
    assign _8704 = { _8702, _8691 };
    assign _8688 = mio_data_rdata[31:16];
    assign _8689 = mio_data_rdata[15:0];
    assign _8690 = _8591[1:1];
    assign _8691 = _8690 ? _8688 : _8689;
    assign _8697 = { _8695, _8691 };
    assign _8705 = _8593 ? _8704 : _8697;
    assign _8679 = _8671[7:7];
    assign _8680 = { _8679, _8679 };
    assign _8681 = { _8680, _8680 };
    assign _8682 = { _8681, _8681 };
    assign _8683 = { _8682, _8682 };
    assign _8684 = { _8683, _8682 };
    assign _8686 = { _8684, _8671 };
    assign _8667 = mio_data_rdata[31:24];
    assign _8668 = mio_data_rdata[23:16];
    assign _8669 = mio_data_rdata[15:8];
    assign _8670 = mio_data_rdata[7:0];
    assign _8591 = _7322[1:0];
    always @* begin
        case (_8591)
        0: _8671 <= _8670;
        1: _8671 <= _8669;
        2: _8671 <= _8668;
        default: _8671 <= _8667;
        endcase
    end
    assign _8678 = { _8676, _8671 };
    assign _8593 = _7242[2:2];
    assign _8687 = _8593 ? _8686 : _8678;
    always @(posedge clk) begin
        if (clr)
            _7242 <= _7240;
        else
            _7242 <= f3_p_2;
    end
    assign _8592 = _7242[1:0];
    always @* begin
        case (_8592)
        0: _8706 <= _8687;
        1: _8706 <= _8705;
        default: _8706 <= mio_data_rdata;
        endcase
    end
    always @(posedge clk) begin
        if (clr)
            _7322 <= _7320;
        else
            _7322 <= rdd_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _7274 <= _7272;
        else
            _7274 <= ld_p_2;
    end
    assign _8708 = _7274 ? _8706 : _7322;
    always @(posedge clk) begin
        if (clr)
            _8747 <= _8745;
        else
            _8747 <= _8708;
    end
    always @(posedge clk) begin
        if (clr)
            _7326 <= _7324;
        else
            _7326 <= rd2_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8743 <= _8741;
        else
            _8743 <= _7326;
    end
    always @(posedge clk) begin
        if (clr)
            _7330 <= _7328;
        else
            _7330 <= rd1_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8739 <= _8737;
        else
            _8739 <= _7330;
    end
    always @(posedge clk) begin
        if (clr)
            _7334 <= _7332;
        else
            _7334 <= rad_zero_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8735 <= _8733;
        else
            _8735 <= _7334;
    end
    always @(posedge clk) begin
        if (clr)
            _7338 <= _7336;
        else
            _7338 <= ra2_zero_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8731 <= _8729;
        else
            _8731 <= _7338;
    end
    always @(posedge clk) begin
        if (clr)
            _7342 <= _7340;
        else
            _7342 <= ra1_zero_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8727 <= _8725;
        else
            _8727 <= _7342;
    end
    always @(posedge clk) begin
        if (clr)
            _7346 <= _7344;
        else
            _7346 <= rad_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8723 <= _8721;
        else
            _8723 <= _7346;
    end
    always @(posedge clk) begin
        if (clr)
            _7350 <= _7348;
        else
            _7350 <= ra2_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8719 <= _8717;
        else
            _8719 <= _7350;
    end
    always @(posedge clk) begin
        if (clr)
            _7354 <= _7352;
        else
            _7354 <= ra1_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8715 <= _8713;
        else
            _8715 <= _7354;
    end
    always @(posedge clk) begin
        if (clr)
            _7358 <= _7356;
        else
            _7358 <= pen_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _8711 <= _8709;
        else
            _8711 <= _7358;
    end

    /* aliases */

    /* output assignments */
    assign pen = _8711;
    assign ra1 = _8715;
    assign ra2 = _8719;
    assign rad = _8723;
    assign ra1_zero = _8727;
    assign ra2_zero = _8731;
    assign rad_zero = _8735;
    assign rd1 = _8739;
    assign rd2 = _8743;
    assign rdd = _8747;
    assign rdm = _8751;
    assign imm = _8755;
    assign pc = _8759;
    assign instr = _8763;
    assign insn = _8767;
    assign trap = _8771;
    assign lui = _8775;
    assign auipc = _8779;
    assign jal = _8783;
    assign jalr = _8787;
    assign bra = _8791;
    assign ld = _8795;
    assign st = _8799;
    assign opi = _8803;
    assign opr = _8807;
    assign fen = _8811;
    assign sys = _8815;
    assign rdc = _8819;
    assign rdco = _8823;
    assign f3 = _8827;
    assign f7 = _8831;
    assign branch = _8835;
    assign rwe = _8839;
    assign mio_instr_addr = _8843;
    assign mio_instr_wdata = _8847;
    assign mio_instr_req = _8851;
    assign mio_instr_rw = _8855;
    assign mio_instr_wmask = _8859;
    assign mio_data_addr = _8863;
    assign mio_data_wdata = _8867;
    assign mio_data_req = _8871;
    assign mio_data_rw = _8875;
    assign mio_data_wmask = _8879;
    assign junk = _8883;

endmodule
