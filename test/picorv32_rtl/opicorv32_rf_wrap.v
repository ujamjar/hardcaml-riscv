module opicorv32_rf_wrap (
    ra2,
    ra1,
    d,
    wa,
    wr,
    resetn,
    clk,
    q1,
    q2
);

    input [5:0] ra2;
    input [5:0] ra1;
    input [31:0] d;
    input [5:0] wa;
    input wr;
    input resetn;
    input clk;
    output [31:0] q1;
    output [31:0] q2;

    /* signal declarations */
    wire [31:0] _2356;
    wire [31:0] _2354;
    wire [31:0] compare_q2;
    wire [31:0] _2358;
    wire [63:0] _2351;
    wire [31:0] _2359;
    wire [63:0] _2353;
    wire [31:0] _2355;
    wire [31:0] compare_q1;
    wire [31:0] _2361;

    /* logic */
    assign _2356 = _2351[63:32];
    assign _2354 = _2353[63:32];
    assign compare_q2 = _2354 ^ _2356;
    assign _2358 = compare_q2 ^ _2356;
    picorv32_rf
        the_picorv32_rf
        ( .clk(clk), .resetn(resetn), .wr(wr), .wa(wa), .d(d), .ra1(ra1), .ra2(ra2), .q2(_2351[63:32]), .q1(_2351[31:0]) );
    assign _2359 = _2351[31:0];
    opicorv32_rf
        the_opicorv32_rf
        ( .clk(clk), .resetn(resetn), .wr(wr), .wa(wa), .d(d), .ra1(ra1), .ra2(ra2), .q2(_2353[63:32]), .q1(_2353[31:0]) );
    assign _2355 = _2353[31:0];
    assign compare_q1 = _2355 ^ _2359;
    assign _2361 = compare_q1 ^ _2359;

    /* aliases */

    /* output assignments */
    assign q1 = _2361;
    assign q2 = _2358;

endmodule
