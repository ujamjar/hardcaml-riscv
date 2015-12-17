module hardcaml_lib_add #(parameter b=1) 
(
    input [b-1:0] i0,
    input [b-1:0] i1,
    output [b-1:0] o
);
    assign o = i0 + i1;
endmodule

module hardcaml_lib_sub #(parameter b=1) 
(
    input [b-1:0] i0,
    input [b-1:0] i1,
    output [b-1:0] o
);
    assign o = i0 - i1;
endmodule

module hardcaml_lib_mulu
#(
    parameter w0=1, 
    parameter w1=1
) 
(
    input [w0-1:0] i0,
    input [w1-1:0] i1,
    output [w0+w1-1:0] o
);
    assign o = i0 * i1;
endmodule

module hardcaml_lib_muls
#(
    parameter w0=1, 
    parameter w1=1
) 
(
    input [w0-1:0] i0,
    input [w1-1:0] i1,
    output [w0+w1-1:0] o
);
    assign o = $signed(i0) * $signed(i1);
endmodule

module hardcaml_lib_and #(parameter b=1) 
(
    input [b-1:0] i0,
    input [b-1:0] i1,
    output [b-1:0] o
);
    assign o = i0 & i1;
endmodule

module hardcaml_lib_or #(parameter b=1) 
(
    input [b-1:0] i0,
    input [b-1:0] i1,
    output [b-1:0] o
);
    assign o = i0 | i1;
endmodule

module hardcaml_lib_xor #(parameter b=1) 
(
    input [b-1:0] i0,
    input [b-1:0] i1,
    output [b-1:0] o
);
    assign o = i0 ^ i1;
endmodule

module hardcaml_lib_not #(parameter b=1) 
(
    input [b-1:0] i,
    output [b-1:0] o
);
    assign o = ~ i;
endmodule

module hardcaml_lib_eq #(parameter b=1) 
(
    input [b-1:0] i0,
    input [b-1:0] i1,
    output o
);
    assign o = i0 == i1;
endmodule

module hardcaml_lib_lt #(parameter b=1) 
(
    input [b-1:0] i0,
    input [b-1:0] i1,
    output o
);
    assign o = i0 < i1;
endmodule

module hardcaml_lib_gnd
(
    output o
);
    assign o = 1'b0;
endmodule

module hardcaml_lib_vdd
(
    output o
);
    assign o = 1'b1;
endmodule

module hardcaml_lib_z
(
    output o
);
    assign o = 1'bz;
endmodule

module hardcaml_lib_concat2 
#(
    parameter w0=1, 
    parameter w1=1
) 
(
    input [w0-1:0] i0,
    input [w1-1:0] i1,
    output [w0+w1-1:0] o
);
    assign o = {i0,i1};
endmodule

module hardcaml_lib_mux2 #(parameter b=1) 
(
    input sel,
    input [b-1:0] d0,
    input [b-1:0] d1,
    output [b-1:0] o
);
    assign o = sel ? d1 : d0;
endmodule

module hardcaml_lib_select 
#(
    parameter b=1,
    parameter h=0,
    parameter l=0
) 
(
    input [b-1:0] i,
    output [h-l:0] o
);
    assign o=i[h:l];
endmodule

module hardcaml_tristate_buffer
#(
    parameter b=1
) 
(
    input en,
    input [b-1:0] i,
    output [b-1:0] o,
    inout [b-1:0] io
);
    assign io = en ? i : {b{1'bz}};
    assign o = io;
endmodule

