module opicorv32_pcpi_if_wrap (
    pcpi_ready,
    pcpi_wait,
    pcpi_rd,
    pcpi_wr,
    pcpi_rs2,
    pcpi_rs1,
    pcpi_insn,
    pcpi_valid,
    resetn,
    clk,
    pcpi_int_wr,
    pcpi_int_rd,
    pcpi_int_wait,
    pcpi_int_ready
);

    input pcpi_ready;
    input pcpi_wait;
    input [31:0] pcpi_rd;
    input pcpi_wr;
    input [31:0] pcpi_rs2;
    input [31:0] pcpi_rs1;
    input [31:0] pcpi_insn;
    input pcpi_valid;
    input resetn;
    input clk;
    output pcpi_int_wr;
    output [31:0] pcpi_int_rd;
    output pcpi_int_wait;
    output pcpi_int_ready;

    /* signal declarations */
    wire _2562;
    wire _2558;
    wire compare_pcpi_int_ready;
    wire _2564;
    wire _2565;
    wire _2559;
    wire compare_pcpi_int_wait;
    wire _2567;
    wire [31:0] _2568;
    wire [31:0] _2560;
    wire [31:0] compare_pcpi_int_rd;
    wire [31:0] _2570;
    wire [34:0] _2555;
    wire _2571;
    wire [34:0] _2557;
    wire _2561;
    wire compare_pcpi_int_wr;
    wire _2573;

    /* logic */
    assign _2562 = _2555[34:34];
    assign _2558 = _2557[34:34];
    assign compare_pcpi_int_ready = _2558 ^ _2562;
    assign _2564 = compare_pcpi_int_ready ^ _2562;
    assign _2565 = _2555[33:33];
    assign _2559 = _2557[33:33];
    assign compare_pcpi_int_wait = _2559 ^ _2565;
    assign _2567 = compare_pcpi_int_wait ^ _2565;
    assign _2568 = _2555[32:1];
    assign _2560 = _2557[32:1];
    assign compare_pcpi_int_rd = _2560 ^ _2568;
    assign _2570 = compare_pcpi_int_rd ^ _2568;
    picorv32_pcpi_if
        #( .ENABLE_PCPI(0), .ENABLE_MUL(1) )
        the_picorv32_pcpi_if
        ( .clk(clk), .resetn(resetn), .pcpi_valid(pcpi_valid), .pcpi_insn(pcpi_insn), .pcpi_rs1(pcpi_rs1), .pcpi_rs2(pcpi_rs2), .pcpi_wr(pcpi_wr), .pcpi_rd(pcpi_rd), .pcpi_wait(pcpi_wait), .pcpi_ready(pcpi_ready), .pcpi_int_ready(_2555[34:34]), .pcpi_int_wait(_2555[33:33]), .pcpi_int_rd(_2555[32:1]), .pcpi_int_wr(_2555[0:0]) );
    assign _2571 = _2555[0:0];
    opicorv32_pcpi_if
        the_opicorv32_pcpi_if
        ( .clk(clk), .resetn(resetn), .pcpi_valid(pcpi_valid), .pcpi_insn(pcpi_insn), .pcpi_rs1(pcpi_rs1), .pcpi_rs2(pcpi_rs2), .pcpi_wr(pcpi_wr), .pcpi_rd(pcpi_rd), .pcpi_wait(pcpi_wait), .pcpi_ready(pcpi_ready), .pcpi_int_ready(_2557[34:34]), .pcpi_int_wait(_2557[33:33]), .pcpi_int_rd(_2557[32:1]), .pcpi_int_wr(_2557[0:0]) );
    assign _2561 = _2557[0:0];
    assign compare_pcpi_int_wr = _2561 ^ _2571;
    assign _2573 = compare_pcpi_int_wr ^ _2571;

    /* aliases */

    /* output assignments */
    assign pcpi_int_wr = _2573;
    assign pcpi_int_rd = _2570;
    assign pcpi_int_wait = _2567;
    assign pcpi_int_ready = _2564;

endmodule
