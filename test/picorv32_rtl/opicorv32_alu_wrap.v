module opicorv32_alu_wrap (
    is_lui_auipc_jal_jalr_addi_add,
    is_slti_blt_slt,
    is_sltiu_bltu_sltu,
    is_compare,
    instr_beq,
    instr_bne,
    instr_bge,
    instr_bgeu,
    instr_xori,
    instr_ori,
    instr_andi,
    instr_sub,
    instr_xor,
    instr_or,
    instr_and,
    reg_op2,
    reg_op1,
    alu_out,
    alu_out_0
);

    input is_lui_auipc_jal_jalr_addi_add;
    input is_slti_blt_slt;
    input is_sltiu_bltu_sltu;
    input is_compare;
    input instr_beq;
    input instr_bne;
    input instr_bge;
    input instr_bgeu;
    input instr_xori;
    input instr_ori;
    input instr_andi;
    input instr_sub;
    input instr_xor;
    input instr_or;
    input instr_and;
    input [31:0] reg_op2;
    input [31:0] reg_op1;
    output [31:0] alu_out;
    output alu_out_0;

    /* signal declarations */
    wire _1285;
    wire _1283;
    wire compare_alu_out_0;
    wire _1287;
    wire [32:0] _1241;
    wire [31:0] _1288;
    wire [5:0] _1279 = 6'b000000;
    wire [3:0] _1274 = 4'b0000;
    wire [14:0] _1280;
    wire [3:0] _1270 = 4'b0000;
    wire gnd = 1'b0;
    wire [10:0] _1267 = 11'b00000000000;
    wire [3:0] _1257 = 4'b0000;
    wire [2:0] _1254 = 3'b000;
    wire [1:0] _1252 = 2'b00;
    wire [10:0] _1251 = 11'b00000000000;
    wire [47:0] _1271;
    wire [32:0] _1282;
    wire [31:0] _1284;
    wire [31:0] compare_alu_out;
    wire [31:0] _1290;

    /* logic */
    assign _1285 = _1241[32:32];
    assign _1283 = _1282[32:32];
    assign compare_alu_out_0 = _1283 ^ _1285;
    assign _1287 = compare_alu_out_0 ^ _1285;
    picorv32_alu
        the_picorv32_alu
        ( .reg_op1(reg_op1), .reg_op2(reg_op2), .instr_beq(instr_beq), .instr_bne(instr_bne), .instr_bge(instr_bge), .instr_bgeu(instr_bgeu), .instr_sub(instr_sub), .instr_xori(instr_xori), .instr_xor(instr_xor), .instr_ori(instr_ori), .instr_or(instr_or), .instr_andi(instr_andi), .instr_and(instr_and), .is_compare(is_compare), .is_slti_blt_slt(is_slti_blt_slt), .is_sltiu_bltu_sltu(is_sltiu_bltu_sltu), .is_lui_auipc_jal_jalr_addi_add(is_lui_auipc_jal_jalr_addi_add), .alu_out_0(_1241[32:32]), .alu_out(_1241[31:0]) );
    assign _1288 = _1241[31:0];
    assign _1280 = { gnd, is_compare, _1274, is_sltiu_bltu_sltu, is_slti_blt_slt, is_lui_auipc_jal_jalr_addi_add, _1279 };
    assign _1271 = { _1251, instr_and, instr_or, _1252, instr_xor, _1254, instr_sub, _1257, instr_andi, instr_ori, instr_xori, _1267, instr_bgeu, gnd, instr_bge, gnd, instr_bne, instr_beq, _1270 };
    opicorv32_alu
        the_opicorv32_alu
        ( .reg_op1(reg_op1), .reg_op2(reg_op2), .instr(_1271), .is(_1280), .alu_out_0(_1282[32:32]), .alu_out(_1282[31:0]) );
    assign _1284 = _1282[31:0];
    assign compare_alu_out = _1284 ^ _1288;
    assign _1290 = compare_alu_out ^ _1288;

    /* aliases */

    /* output assignments */
    assign alu_out = _1290;
    assign alu_out_0 = _1287;

endmodule
