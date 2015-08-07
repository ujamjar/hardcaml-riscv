module opicorv32_alu (
    reg_op2,
    reg_op1,
    instr,
    is,
    alu_out,
    alu_out_0
);

    input [31:0] reg_op2;
    input [31:0] reg_op1;
    input [47:0] instr;
    input [14:0] is;
    output [31:0] alu_out;
    output alu_out_0;

    /* signal declarations */
    wire [31:0] _1209;
    wire [31:0] _1207;
    wire [31:0] _1215;
    wire _1172;
    wire _1169;
    wire _1170;
    wire _1178;
    wire [30:0] _1158;
    wire _1159;
    wire _1160;
    wire [31:0] _1161;
    wire [30:0] _1162;
    wire _1163;
    wire _1164;
    wire [31:0] _1165;
    wire _1166;
    wire _1167;
    wire _1155;
    wire _1156;
    wire _1176;
    wire _1180;
    wire [30:0] _1145;
    wire _1146;
    wire _1147;
    wire [31:0] _1148;
    wire [30:0] _1149;
    wire _1150;
    wire _1151;
    wire [31:0] _1152;
    wire _1153;
    wire _1143;
    wire _1154;
    wire _1174;
    wire _1157;
    wire _1168;
    wire _1177;
    wire _1171;
    wire _1173;
    wire _1179;
    wire _1181;
    wire _1182;
    wire [30:0] _1203 = 31'b0000000000000000000000000000000;
    wire [31:0] _1205;
    wire [31:0] _1192;
    wire [31:0] _1213;
    wire [31:0] _1217;
    wire [31:0] _1188;
    wire [31:0] _1184;
    wire _1189;
    wire _1190;
    wire _1191;
    wire [31:0] _1211;
    wire _1193;
    wire _1194;
    wire _1195;
    wire _1206;
    wire _1214;
    wire _1208;
    wire _1210;
    wire _1216;
    wire _1218;
    wire [31:0] _1219;

    /* logic */
    assign _1209 = reg_op1 + reg_op2;
    assign _1207 = reg_op1 - reg_op2;
    assign _1215 = _1210 ? _1209 : _1207;
    assign _1172 = reg_op1 == reg_op2;
    assign _1169 = reg_op1 == reg_op2;
    assign _1170 = ~ _1169;
    assign _1178 = _1173 ? _1172 : _1170;
    assign _1158 = reg_op2[30:0];
    assign _1159 = reg_op2[31:31];
    assign _1160 = ~ _1159;
    assign _1161 = { _1160, _1158 };
    assign _1162 = reg_op1[30:0];
    assign _1163 = reg_op1[31:31];
    assign _1164 = ~ _1163;
    assign _1165 = { _1164, _1162 };
    assign _1166 = _1165 < _1161;
    assign _1167 = ~ _1166;
    assign _1155 = reg_op1 < reg_op2;
    assign _1156 = ~ _1155;
    assign _1176 = _1168 ? _1167 : _1156;
    assign _1180 = _1179 ? _1178 : _1176;
    assign _1145 = reg_op2[30:0];
    assign _1146 = reg_op2[31:31];
    assign _1147 = ~ _1146;
    assign _1148 = { _1147, _1145 };
    assign _1149 = reg_op1[30:0];
    assign _1150 = reg_op1[31:31];
    assign _1151 = ~ _1150;
    assign _1152 = { _1151, _1149 };
    assign _1153 = _1152 < _1148;
    assign _1143 = reg_op1 < reg_op2;
    assign _1154 = is[7:7];
    assign _1174 = _1154 ? _1153 : _1143;
    assign _1157 = instr[9:9];
    assign _1168 = instr[7:7];
    assign _1177 = _1168 | _1157;
    assign _1171 = instr[5:5];
    assign _1173 = instr[4:4];
    assign _1179 = _1173 | _1171;
    assign _1181 = _1179 | _1177;
    assign _1182 = _1181 ? _1180 : _1174;
    assign _1205 = { _1203, _1182 };
    assign _1192 = reg_op1 ^ reg_op2;
    assign _1213 = _1206 ? _1205 : _1192;
    assign _1217 = _1216 ? _1215 : _1213;
    assign _1188 = reg_op1 | reg_op2;
    assign _1184 = reg_op1 & reg_op2;
    assign _1189 = instr[35:35];
    assign _1190 = instr[22:22];
    assign _1191 = _1190 | _1189;
    assign _1211 = _1191 ? _1188 : _1184;
    assign _1193 = instr[32:32];
    assign _1194 = instr[21:21];
    assign _1195 = _1194 | _1193;
    assign _1206 = is[13:13];
    assign _1214 = _1206 | _1195;
    assign _1208 = instr[28:28];
    assign _1210 = is[6:6];
    assign _1216 = _1210 | _1208;
    assign _1218 = _1216 | _1214;
    assign _1219 = _1218 ? _1217 : _1211;

    /* aliases */

    /* output assignments */
    assign alu_out = _1219;
    assign alu_out_0 = _1182;

endmodule
