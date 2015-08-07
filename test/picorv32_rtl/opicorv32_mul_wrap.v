module opicorv32_mul_wrap (
    pcpi_rs2,
    pcpi_rs1,
    pcpi_insn,
    pcpi_valid,
    resetn,
    clk,
    pcpi_wr,
    pcpi_rd,
    pcpi_wait,
    pcpi_ready
);

    input [31:0] pcpi_rs2;
    input [31:0] pcpi_rs1;
    input [31:0] pcpi_insn;
    input pcpi_valid;
    input resetn;
    input clk;
    output pcpi_wr;
    output [31:0] pcpi_rd;
    output pcpi_wait;
    output pcpi_ready;

    /* signal declarations */
    wire _1746;
    wire _1742;
    wire compare_pcpi_ready;
    wire _1748;
    wire _1749;
    wire _1743;
    wire compare_pcpi_wait;
    wire _1751;
    wire [31:0] _1752;
    wire [31:0] _1744;
    wire [31:0] compare_pcpi_rd;
    wire [31:0] _1754;
    wire [34:0] _1739;
    wire _1755;
    wire [34:0] _1741;
    wire _1745;
    wire compare_pcpi_wr;
    wire _1757;

    /* logic */
    assign _1746 = _1739[34:34];
    assign _1742 = _1741[34:34];
    assign compare_pcpi_ready = _1742 ^ _1746;
    assign _1748 = compare_pcpi_ready ^ _1746;
    assign _1749 = _1739[33:33];
    assign _1743 = _1741[33:33];
    assign compare_pcpi_wait = _1743 ^ _1749;
    assign _1751 = compare_pcpi_wait ^ _1749;
    assign _1752 = _1739[32:1];
    assign _1744 = _1741[32:1];
    assign compare_pcpi_rd = _1744 ^ _1752;
    assign _1754 = compare_pcpi_rd ^ _1752;
    picorv32_mul
        the_picorv32_mul
        ( .clk(clk), .resetn(resetn), .pcpi_valid(pcpi_valid), .pcpi_insn(pcpi_insn), .pcpi_rs1(pcpi_rs1), .pcpi_rs2(pcpi_rs2), .pcpi_ready(_1739[34:34]), .pcpi_wait(_1739[33:33]), .pcpi_rd(_1739[32:1]), .pcpi_wr(_1739[0:0]) );
    assign _1755 = _1739[0:0];
    opicorv32_mul
        the_opicorv32_mul
        ( .clk(clk), .resetn(resetn), .pcpi_valid(pcpi_valid), .pcpi_insn(pcpi_insn), .pcpi_rs1(pcpi_rs1), .pcpi_rs2(pcpi_rs2), .pcpi_ready(_1741[34:34]), .pcpi_wait(_1741[33:33]), .pcpi_rd(_1741[32:1]), .pcpi_wr(_1741[0:0]) );
    assign _1745 = _1741[0:0];
    assign compare_pcpi_wr = _1745 ^ _1755;
    assign _1757 = compare_pcpi_wr ^ _1755;

    /* aliases */

    /* output assignments */
    assign pcpi_wr = _1757;
    assign pcpi_rd = _1754;
    assign pcpi_wait = _1751;
    assign pcpi_ready = _1748;

endmodule
