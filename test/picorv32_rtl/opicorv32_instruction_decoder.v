module opicorv32_instruction_decoder (
    decoder_pseudo_trigger,
    decoder_trigger,
    mem_rdata_q,
    mem_done,
    mem_do_rinst,
    resetn,
    clk,
    mem_rdata_latched,
    instr,
    is,
    pcpi_insn,
    decoded_rd,
    decoded_rs1,
    decoded_rs2,
    decoded_imm,
    decoded_imm_uj
);

    input decoder_pseudo_trigger;
    input decoder_trigger;
    input [31:0] mem_rdata_q;
    input mem_done;
    input mem_do_rinst;
    input resetn;
    input clk;
    input [31:0] mem_rdata_latched;
    output [47:0] instr;
    output [14:0] is;
    output [31:0] pcpi_insn;
    output [5:0] decoded_rd;
    output [5:0] decoded_rs1;
    output [5:0] decoded_rs2;
    output [31:0] decoded_imm;
    output [31:0] decoded_imm_uj;

    /* signal declarations */
    wire [31:0] _753 = 32'b00000000000000000000000000000000;
    wire [31:0] _752 = 32'b00000000000000000000000000000000;
    wire [31:0] _696 = 32'b00000000000000000000000000000000;
    wire [31:0] _695 = 32'b00000000000000000000000000000000;
    wire _693;
    wire [9:0] _690;
    wire _691;
    wire [7:0] _692;
    wire [2:0] _683;
    wire [19:0] _679;
    wire [20:0] _680;
    wire _681;
    wire [1:0] _682;
    wire [3:0] _684;
    wire [7:0] _685;
    wire [10:0] _686;
    wire [31:0] _688;
    wire [11:0] _689;
    wire [31:0] _694;
    reg [31:0] _697;
    wire [11:0] _740 = 12'b000000000000;
    wire [19:0] _741;
    wire [31:0] _742;
    wire [11:0] _726;
    wire _727;
    wire [1:0] _728;
    wire [3:0] _729;
    wire [7:0] _730;
    wire [15:0] _731;
    wire [19:0] _732;
    wire [31:0] _734;
    wire [2:0] _718;
    wire [3:0] _714;
    wire [5:0] _713;
    wire _712;
    wire _711;
    wire [12:0] _715;
    wire _716;
    wire [1:0] _717;
    wire [3:0] _719;
    wire [7:0] _720;
    wire [15:0] _721;
    wire [18:0] _722;
    wire [31:0] _724;
    wire [4:0] _700;
    wire [6:0] _699;
    wire [11:0] _701;
    wire _702;
    wire [1:0] _703;
    wire [3:0] _704;
    wire [7:0] _705;
    wire [15:0] _706;
    wire [19:0] _707;
    wire [31:0] _709;
    wire [31:0] _698 = 32'b00000000000000000000000000000000;
    wire _710;
    wire [31:0] _747;
    wire _725;
    wire [31:0] _748;
    wire _736;
    wire _735;
    wire _737;
    wire _738;
    wire _739;
    wire [31:0] _749;
    wire _744;
    wire _743;
    wire _745;
    wire [31:0] _750;
    wire _746;
    wire [31:0] _751;
    reg [31:0] _754;
    wire [4:0] _757 = 5'b00000;
    wire [4:0] _756 = 5'b00000;
    wire [4:0] _755;
    reg [4:0] _758;
    wire [5:0] _759;
    wire [5:0] _761 = 6'b000000;
    wire [5:0] _760 = 6'b000000;
    wire [5:0] _677 = 6'b100000;
    wire [4:0] _674;
    wire [5:0] _675;
    wire [4:0] _672;
    wire [5:0] cx;
    wire [6:0] _656 = 7'b0000000;
    wire [6:0] _655;
    wire _657;
    wire [6:0] _659 = 7'b0001011;
    wire [6:0] _658;
    wire _660;
    wire _661;
    wire _662;
    wire c0;
    wire [5:0] _676;
    wire [6:0] _665 = 7'b0000010;
    wire [6:0] _664;
    wire _666;
    wire [6:0] _668 = 7'b0001011;
    wire [6:0] _667;
    wire _669;
    wire _670;
    wire c1;
    wire [5:0] _678;
    reg [5:0] _762;
    wire _49;
    wire [4:0] _765 = 5'b00000;
    wire [4:0] _764 = 5'b00000;
    wire [4:0] _763;
    reg [4:0] _766;
    wire [5:0] _767;
    wire _50;
    wire _51;
    wire [31:0] _769 = 32'b00000000000000000000000000000000;
    wire [31:0] _768 = 32'b00000000000000000000000000000000;
    reg [31:0] _770;
    wire _652 = 1'b0;
    wire _649;
    wire _648;
    wire _647;
    wire _650;
    wire _651;
    reg is_lui_auipc_jal;
    wire _601 = 1'b0;
    wire [6:0] _578 = 7'b0100000;
    wire [6:0] _577;
    wire _579;
    wire [2:0] _581 = 3'b101;
    wire [2:0] _580;
    wire _582;
    wire _583;
    wire [6:0] _585 = 7'b0000000;
    wire [6:0] _584;
    wire _586;
    wire [2:0] _588 = 3'b101;
    wire [2:0] _587;
    wire _589;
    wire _590;
    wire [6:0] _592 = 7'b0000000;
    wire [6:0] _591;
    wire _593;
    wire [2:0] _595 = 3'b001;
    wire [2:0] _594;
    wire _596;
    wire _597;
    wire _598;
    wire _599;
    wire _600;
    reg is_slli_srli_srai;
    wire _575 = 1'b0;
    wire [2:0] _551 = 3'b111;
    wire [2:0] _550;
    wire _552;
    wire [2:0] _554 = 3'b110;
    wire [2:0] _553;
    wire _555;
    wire [2:0] _557 = 3'b100;
    wire [2:0] _556;
    wire _558;
    wire [2:0] _560 = 3'b011;
    wire [2:0] _559;
    wire _561;
    wire [2:0] _563 = 3'b010;
    wire [2:0] _562;
    wire _564;
    wire [2:0] _566 = 3'b000;
    wire [2:0] _565;
    wire _567;
    wire _568;
    wire _569;
    wire _570;
    wire _571;
    wire _572;
    wire _573;
    wire _574;
    reg is_jalr_addi_slti_sltiu_xori_ori_andi;
    wire _548 = 1'b0;
    wire [6:0] _525 = 7'b0100000;
    wire [6:0] _524;
    wire _526;
    wire [2:0] _528 = 3'b101;
    wire [2:0] _527;
    wire _529;
    wire _530;
    wire [6:0] _532 = 7'b0000000;
    wire [6:0] _531;
    wire _533;
    wire [2:0] _535 = 3'b101;
    wire [2:0] _534;
    wire _536;
    wire _537;
    wire [6:0] _539 = 7'b0000000;
    wire [6:0] _538;
    wire _540;
    wire [2:0] _542 = 3'b001;
    wire [2:0] _541;
    wire _543;
    wire _544;
    wire _545;
    wire _546;
    wire _547;
    reg is_sll_srl_sra;
    wire _645 = 1'b0;
    wire _639;
    wire _638;
    wire _637;
    wire _636;
    wire _635;
    wire _634;
    wire _640;
    wire _641;
    wire _642;
    wire _643;
    wire _644;
    reg is_lui_auipc_jal_jalr_addi_add;
    wire _632 = 1'b0;
    wire _629;
    wire _628;
    wire _627;
    wire _630;
    wire _631;
    reg is_slti_blt_slt;
    wire _625 = 1'b0;
    wire _622;
    wire _621;
    wire _620;
    wire _623;
    wire _624;
    reg is_sltiu_bltu_sltu;
    wire _618 = 1'b0;
    wire _615;
    wire _614;
    wire _613;
    wire _616;
    wire _617;
    reg is_lbu_lhu_lw;
    wire _611 = 1'b0;
    wire _606;
    wire _605;
    wire _604;
    wire _603;
    wire _607;
    wire _608;
    wire _609;
    wire _610;
    reg is_compare;
    wire _520;
    wire _519;
    wire _518;
    wire _517;
    wire _521;
    wire _522;
    wire is_rdcycle_rdcycleh_rdinstr_rdinstrh;
    wire [14:0] _654;
    wire _109 = 1'b0;
    wire [6:0] _101 = 7'b0000101;
    wire [6:0] _100;
    wire _102;
    wire [6:0] _104 = 7'b0001011;
    wire [6:0] _103;
    wire _105;
    wire _106;
    wire _107;
    wire _108;
    reg instr_timer;
    wire _119 = 1'b0;
    wire [6:0] _112 = 7'b0000011;
    wire [6:0] _111;
    wire _113;
    wire [6:0] _115 = 7'b0001011;
    wire [6:0] _114;
    wire _116;
    wire _117;
    wire _118;
    reg instr_maskirq;
    wire _130 = 1'b0;
    wire [6:0] _122 = 7'b0000001;
    wire [6:0] _121;
    wire _123;
    wire [6:0] _125 = 7'b0001011;
    wire [6:0] _124;
    wire _126;
    wire _127;
    wire _128;
    wire _129;
    reg instr_setq;
    wire _141 = 1'b0;
    wire [6:0] _133 = 7'b0000000;
    wire [6:0] _132;
    wire _134;
    wire [6:0] _136 = 7'b0001011;
    wire [6:0] _135;
    wire _137;
    wire _138;
    wire _139;
    wire _140;
    reg instr_getq;
    wire _151 = 1'b0;
    wire [19:0] _144 = 20'b11001000001000000010;
    wire [19:0] _143;
    wire _145;
    wire [6:0] _147 = 7'b1110011;
    wire [6:0] _146;
    wire _148;
    wire _149;
    wire _150;
    reg instr_rdinstrh;
    wire _161 = 1'b0;
    wire [19:0] _154 = 20'b11000000001000000010;
    wire [19:0] _153;
    wire _155;
    wire [6:0] _157 = 7'b1110011;
    wire [6:0] _156;
    wire _158;
    wire _159;
    wire _160;
    reg instr_rdinstr;
    wire _179 = 1'b0;
    wire [19:0] _164 = 20'b11001000000100000010;
    wire [19:0] _163;
    wire _165;
    wire [6:0] _167 = 7'b1110011;
    wire [6:0] _166;
    wire _168;
    wire _169;
    wire [19:0] _171 = 20'b11001000000000000010;
    wire [19:0] _170;
    wire _172;
    wire [6:0] _174 = 7'b1110011;
    wire [6:0] _173;
    wire _175;
    wire _176;
    wire _177;
    wire _178;
    reg instr_rdcycleh;
    wire _197 = 1'b0;
    wire [19:0] _182 = 20'b11000000000100000010;
    wire [19:0] _181;
    wire _183;
    wire [6:0] _185 = 7'b1110011;
    wire [6:0] _184;
    wire _186;
    wire _187;
    wire [19:0] _189 = 20'b11000000000000000010;
    wire [19:0] _188;
    wire _190;
    wire [6:0] _192 = 7'b1110011;
    wire [6:0] _191;
    wire _193;
    wire _194;
    wire _195;
    wire _196;
    reg instr_rdcycle;
    wire _207 = 1'b0;
    wire [6:0] _200 = 7'b0000000;
    wire [6:0] _199;
    wire _201;
    wire [2:0] _203 = 3'b111;
    wire [2:0] _202;
    wire _204;
    wire _205;
    wire _206;
    reg instr_and;
    wire _217 = 1'b0;
    wire [6:0] _210 = 7'b0000000;
    wire [6:0] _209;
    wire _211;
    wire [2:0] _213 = 3'b110;
    wire [2:0] _212;
    wire _214;
    wire _215;
    wire _216;
    reg instr_or;
    wire _227 = 1'b0;
    wire [6:0] _220 = 7'b0100000;
    wire [6:0] _219;
    wire _221;
    wire [2:0] _223 = 3'b101;
    wire [2:0] _222;
    wire _224;
    wire _225;
    wire _226;
    reg instr_sra;
    wire _237 = 1'b0;
    wire [6:0] _230 = 7'b0000000;
    wire [6:0] _229;
    wire _231;
    wire [2:0] _233 = 3'b101;
    wire [2:0] _232;
    wire _234;
    wire _235;
    wire _236;
    reg instr_srl;
    wire _247 = 1'b0;
    wire [6:0] _240 = 7'b0000000;
    wire [6:0] _239;
    wire _241;
    wire [2:0] _243 = 3'b100;
    wire [2:0] _242;
    wire _244;
    wire _245;
    wire _246;
    reg instr_xor;
    wire _257 = 1'b0;
    wire [6:0] _250 = 7'b0000000;
    wire [6:0] _249;
    wire _251;
    wire [2:0] _253 = 3'b011;
    wire [2:0] _252;
    wire _254;
    wire _255;
    wire _256;
    reg instr_sltu;
    wire _267 = 1'b0;
    wire [6:0] _260 = 7'b0000000;
    wire [6:0] _259;
    wire _261;
    wire [2:0] _263 = 3'b010;
    wire [2:0] _262;
    wire _264;
    wire _265;
    wire _266;
    reg instr_slt;
    wire _277 = 1'b0;
    wire [6:0] _270 = 7'b0000000;
    wire [6:0] _269;
    wire _271;
    wire [2:0] _273 = 3'b001;
    wire [2:0] _272;
    wire _274;
    wire _275;
    wire _276;
    reg instr_sll;
    wire _287 = 1'b0;
    wire [6:0] _280 = 7'b0100000;
    wire [6:0] _279;
    wire _281;
    wire [2:0] _283 = 3'b000;
    wire [2:0] _282;
    wire _284;
    wire _285;
    wire _286;
    reg instr_sub;
    wire _297 = 1'b0;
    wire [6:0] _290 = 7'b0000000;
    wire [6:0] _289;
    wire _291;
    wire [2:0] _293 = 3'b000;
    wire [2:0] _292;
    wire _294;
    wire _98 = 1'b0;
    wire [6:0] _96 = 7'b0110011;
    wire [6:0] _95;
    wire _97;
    reg is_alu_reg_reg;
    wire _295;
    wire _296;
    reg instr_add;
    wire _307 = 1'b0;
    wire [6:0] _300 = 7'b0100000;
    wire [6:0] _299;
    wire _301;
    wire [2:0] _303 = 3'b101;
    wire [2:0] _302;
    wire _304;
    wire _305;
    wire _306;
    reg instr_srai;
    wire _317 = 1'b0;
    wire [6:0] _310 = 7'b0000000;
    wire [6:0] _309;
    wire _311;
    wire [2:0] _313 = 3'b101;
    wire [2:0] _312;
    wire _314;
    wire _315;
    wire _316;
    reg instr_srli;
    wire _327 = 1'b0;
    wire [6:0] _320 = 7'b0000000;
    wire [6:0] _319;
    wire _321;
    wire [2:0] _323 = 3'b001;
    wire [2:0] _322;
    wire _324;
    wire _325;
    wire _326;
    reg instr_slli;
    wire _333 = 1'b0;
    wire [2:0] _330 = 3'b111;
    wire [2:0] _329;
    wire _331;
    wire _332;
    reg instr_andi;
    wire _339 = 1'b0;
    wire [2:0] _336 = 3'b110;
    wire [2:0] _335;
    wire _337;
    wire _338;
    reg instr_ori;
    wire _345 = 1'b0;
    wire [2:0] _342 = 3'b100;
    wire [2:0] _341;
    wire _343;
    wire _344;
    reg instr_xori;
    wire _351 = 1'b0;
    wire [2:0] _348 = 3'b011;
    wire [2:0] _347;
    wire _349;
    wire _350;
    reg instr_sltiu;
    wire _357 = 1'b0;
    wire [2:0] _354 = 3'b010;
    wire [2:0] _353;
    wire _355;
    wire _356;
    reg instr_slti;
    wire _363 = 1'b0;
    wire [2:0] _360 = 3'b000;
    wire [2:0] _359;
    wire _361;
    wire _93 = 1'b0;
    wire [6:0] _91 = 7'b0010011;
    wire [6:0] _90;
    wire _92;
    reg is_alu_reg_imm;
    wire _362;
    reg instr_addi;
    wire _369 = 1'b0;
    wire [2:0] _366 = 3'b010;
    wire [2:0] _365;
    wire _367;
    wire _368;
    reg instr_sw;
    wire _375 = 1'b0;
    wire [2:0] _372 = 3'b001;
    wire [2:0] _371;
    wire _373;
    wire _374;
    reg instr_sh;
    wire _381 = 1'b0;
    wire [2:0] _378 = 3'b000;
    wire [2:0] _377;
    wire _379;
    wire _88 = 1'b0;
    wire [6:0] _86 = 7'b0100011;
    wire [6:0] _85;
    wire _87;
    reg is_sb_sh_sw;
    wire _380;
    reg instr_sb;
    wire _387 = 1'b0;
    wire [2:0] _384 = 3'b101;
    wire [2:0] _383;
    wire _385;
    wire _386;
    reg instr_lhu;
    wire _393 = 1'b0;
    wire [2:0] _390 = 3'b100;
    wire [2:0] _389;
    wire _391;
    wire _392;
    reg instr_lbu;
    wire _399 = 1'b0;
    wire [2:0] _396 = 3'b010;
    wire [2:0] _395;
    wire _397;
    wire _398;
    reg instr_lw;
    wire _405 = 1'b0;
    wire [2:0] _402 = 3'b001;
    wire [2:0] _401;
    wire _403;
    wire _404;
    reg instr_lh;
    wire _411 = 1'b0;
    wire [2:0] _408 = 3'b000;
    wire [2:0] _407;
    wire _409;
    wire _83 = 1'b0;
    wire [6:0] _81 = 7'b0000011;
    wire [6:0] _80;
    wire _82;
    reg is_lb_lh_lw_lbu_lhu;
    wire _410;
    reg instr_lb;
    wire _417 = 1'b0;
    wire [2:0] _414 = 3'b111;
    wire [2:0] _413;
    wire _415;
    wire _416;
    reg instr_bgeu;
    wire _423 = 1'b0;
    wire [2:0] _420 = 3'b110;
    wire [2:0] _419;
    wire _421;
    wire _422;
    reg instr_bltu;
    wire _429 = 1'b0;
    wire [2:0] _426 = 3'b101;
    wire [2:0] _425;
    wire _427;
    wire _428;
    reg instr_bge;
    wire _435 = 1'b0;
    wire [2:0] _432 = 3'b100;
    wire [2:0] _431;
    wire _433;
    wire _434;
    reg instr_blt;
    wire _441 = 1'b0;
    wire [2:0] _438 = 3'b001;
    wire [2:0] _437;
    wire _439;
    wire _440;
    reg instr_bne;
    wire _53;
    wire _54;
    wire _447 = 1'b0;
    wire [2:0] _444 = 3'b000;
    wire [2:0] _443;
    wire _445;
    wire _78 = 1'b0;
    wire [6:0] _76 = 7'b1100011;
    wire [6:0] _75;
    wire _77;
    reg is_beq_bne_blt_bge_bltu_bgeu;
    wire _446;
    reg instr_beq;
    wire _457 = 1'b0;
    wire [6:0] _450 = 7'b0000100;
    wire [6:0] _449;
    wire _451;
    wire [6:0] _453 = 7'b0001011;
    wire [6:0] _452;
    wire _454;
    wire _455;
    wire _456;
    reg instr_waitirq;
    wire _467 = 1'b0;
    wire vdd = 1'b1;
    wire [6:0] _460 = 7'b0000010;
    wire [6:0] _459;
    wire _461;
    wire [6:0] _463 = 7'b0001011;
    wire [6:0] _462;
    wire _464;
    wire _465;
    wire _466;
    reg instr_retirq;
    wire _73 = 1'b0;
    wire [6:0] _71 = 7'b1100111;
    wire [6:0] _70;
    wire _72;
    reg instr_jalr;
    wire _68 = 1'b0;
    wire [6:0] _66 = 7'b1101111;
    wire [6:0] _65;
    wire _67;
    reg instr_jal;
    wire _63 = 1'b0;
    wire [6:0] _61 = 7'b0010111;
    wire [6:0] _60;
    wire _62;
    reg instr_auipc;
    wire _52;
    wire _58 = 1'b0;
    wire gnd = 1'b0;
    wire [6:0] _56 = 7'b0110111;
    wire [6:0] _55;
    wire _57;
    reg instr_lui;
    wire _469;
    wire _470;
    wire _471;
    wire _472;
    wire _473;
    wire _474;
    wire _475;
    wire _476;
    wire _477;
    wire _478;
    wire _479;
    wire _480;
    wire _481;
    wire _482;
    wire _483;
    wire _484;
    wire _485;
    wire _486;
    wire _487;
    wire _488;
    wire _489;
    wire _490;
    wire _491;
    wire _492;
    wire _493;
    wire _494;
    wire _495;
    wire _496;
    wire _497;
    wire _498;
    wire _499;
    wire _500;
    wire _501;
    wire _502;
    wire _503;
    wire _504;
    wire _505;
    wire _506;
    wire _507;
    wire _508;
    wire _509;
    wire _510;
    wire _511;
    wire _512;
    wire _513;
    wire _514;
    wire instr_trap;
    wire [47:0] _516;

    /* logic */
    assign _693 = _688[0:0];
    assign _690 = _688[19:10];
    assign _691 = _688[9:9];
    assign _692 = _688[8:1];
    assign _683 = { _682, _681 };
    assign _679 = mem_rdata_latched[31:12];
    assign _680 = { _679, gnd };
    assign _681 = _680[20:20];
    assign _682 = { _681, _681 };
    assign _684 = { _682, _682 };
    assign _685 = { _684, _684 };
    assign _686 = { _685, _683 };
    assign _688 = { _686, _680 };
    assign _689 = _688[31:20];
    assign _694 = { _689, _692, _691, _690, _693 };
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _697 <= _695;
        else
            if (_49)
                _697 <= _694;
    end
    assign _741 = mem_rdata_q[31:12];
    assign _742 = { _741, _740 };
    assign _726 = mem_rdata_q[31:20];
    assign _727 = _726[11:11];
    assign _728 = { _727, _727 };
    assign _729 = { _728, _728 };
    assign _730 = { _729, _729 };
    assign _731 = { _730, _730 };
    assign _732 = { _731, _729 };
    assign _734 = { _732, _726 };
    assign _718 = { _717, _716 };
    assign _714 = mem_rdata_q[11:8];
    assign _713 = mem_rdata_q[30:25];
    assign _712 = mem_rdata_q[7:7];
    assign _711 = mem_rdata_q[31:31];
    assign _715 = { _711, _712, _713, _714, gnd };
    assign _716 = _715[12:12];
    assign _717 = { _716, _716 };
    assign _719 = { _717, _717 };
    assign _720 = { _719, _719 };
    assign _721 = { _720, _720 };
    assign _722 = { _721, _718 };
    assign _724 = { _722, _715 };
    assign _700 = mem_rdata_q[11:7];
    assign _699 = mem_rdata_q[31:25];
    assign _701 = { _699, _700 };
    assign _702 = _701[11:11];
    assign _703 = { _702, _702 };
    assign _704 = { _703, _703 };
    assign _705 = { _704, _704 };
    assign _706 = { _705, _705 };
    assign _707 = { _706, _704 };
    assign _709 = { _707, _701 };
    assign _710 = _654[4:4];
    assign _747 = _710 ? _709 : _698;
    assign _725 = _654[9:9];
    assign _748 = _725 ? _724 : _747;
    assign _736 = _654[11:11];
    assign _735 = _654[1:1];
    assign _737 = _735 | _736;
    assign _738 = _516[3:3];
    assign _739 = _738 | _737;
    assign _749 = _739 ? _734 : _748;
    assign _744 = _516[1:1];
    assign _743 = _516[0:0];
    assign _745 = _743 | _744;
    assign _750 = _745 ? _742 : _749;
    assign _746 = _516[2:2];
    assign _751 = _746 ? _697 : _750;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _754 <= _752;
        else
            if (_51)
                _754 <= _751;
    end
    assign _755 = mem_rdata_latched[24:20];
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _758 <= _756;
        else
            if (_49)
                _758 <= _755;
    end
    assign _759 = { gnd, _758 };
    assign _674 = cx[4:0];
    assign _675 = { vdd, _674 };
    assign _672 = mem_rdata_latched[19:15];
    assign cx = { gnd, _672 };
    assign _655 = mem_rdata_latched[31:25];
    assign _657 = _655 == _656;
    assign _658 = mem_rdata_latched[6:0];
    assign _660 = _658 == _659;
    assign _661 = _660 & _657;
    assign _662 = _661 & vdd;
    assign c0 = _662 & vdd;
    assign _676 = c0 ? _675 : cx;
    assign _664 = mem_rdata_latched[31:25];
    assign _666 = _664 == _665;
    assign _667 = mem_rdata_latched[6:0];
    assign _669 = _667 == _668;
    assign _670 = _669 & _666;
    assign c1 = _670 & vdd;
    assign _678 = c1 ? _677 : _676;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _762 <= _760;
        else
            if (_49)
                _762 <= _678;
    end
    assign _49 = mem_do_rinst & mem_done;
    assign _763 = mem_rdata_latched[11:7];
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _766 <= _764;
        else
            if (_49)
                _766 <= _763;
    end
    assign _767 = { gnd, _766 };
    assign _50 = ~ decoder_pseudo_trigger;
    assign _51 = decoder_trigger & _50;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _770 <= _768;
        else
            if (_51)
                _770 <= mem_rdata_q;
    end
    assign _649 = _516[2:2];
    assign _648 = _516[1:1];
    assign _647 = _516[0:0];
    assign _650 = _647 | _648;
    assign _651 = _650 | _649;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            is_lui_auipc_jal <= gnd;
        else
            is_lui_auipc_jal <= _651;
    end
    assign _577 = mem_rdata_q[31:25];
    assign _579 = _577 == _578;
    assign _580 = mem_rdata_q[14:12];
    assign _582 = _580 == _581;
    assign _583 = _582 & _579;
    assign _584 = mem_rdata_q[31:25];
    assign _586 = _584 == _585;
    assign _587 = mem_rdata_q[14:12];
    assign _589 = _587 == _588;
    assign _590 = _589 & _586;
    assign _591 = mem_rdata_q[31:25];
    assign _593 = _591 == _592;
    assign _594 = mem_rdata_q[14:12];
    assign _596 = _594 == _595;
    assign _597 = _596 & _593;
    assign _598 = _597 | _590;
    assign _599 = _598 | _583;
    assign _600 = is_alu_reg_imm & _599;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            is_slli_srli_srai <= gnd;
        else
            if (_54)
                is_slli_srli_srai <= _600;
    end
    assign _550 = mem_rdata_q[14:12];
    assign _552 = _550 == _551;
    assign _553 = mem_rdata_q[14:12];
    assign _555 = _553 == _554;
    assign _556 = mem_rdata_q[14:12];
    assign _558 = _556 == _557;
    assign _559 = mem_rdata_q[14:12];
    assign _561 = _559 == _560;
    assign _562 = mem_rdata_q[14:12];
    assign _564 = _562 == _563;
    assign _565 = mem_rdata_q[14:12];
    assign _567 = _565 == _566;
    assign _568 = _567 | _564;
    assign _569 = _568 | _561;
    assign _570 = _569 | _558;
    assign _571 = _570 | _555;
    assign _572 = _571 | _552;
    assign _573 = is_alu_reg_imm & _572;
    assign _574 = instr_jalr | _573;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            is_jalr_addi_slti_sltiu_xori_ori_andi <= gnd;
        else
            if (_54)
                is_jalr_addi_slti_sltiu_xori_ori_andi <= _574;
    end
    assign _524 = mem_rdata_q[31:25];
    assign _526 = _524 == _525;
    assign _527 = mem_rdata_q[14:12];
    assign _529 = _527 == _528;
    assign _530 = _529 & _526;
    assign _531 = mem_rdata_q[31:25];
    assign _533 = _531 == _532;
    assign _534 = mem_rdata_q[14:12];
    assign _536 = _534 == _535;
    assign _537 = _536 & _533;
    assign _538 = mem_rdata_q[31:25];
    assign _540 = _538 == _539;
    assign _541 = mem_rdata_q[14:12];
    assign _543 = _541 == _542;
    assign _544 = _543 & _540;
    assign _545 = _544 | _537;
    assign _546 = _545 | _530;
    assign _547 = is_alu_reg_reg & _546;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            is_sll_srl_sra <= gnd;
        else
            if (_54)
                is_sll_srl_sra <= _547;
    end
    assign _639 = _516[27:27];
    assign _638 = _516[18:18];
    assign _637 = _516[3:3];
    assign _636 = _516[2:2];
    assign _635 = _516[1:1];
    assign _634 = _516[0:0];
    assign _640 = _634 | _635;
    assign _641 = _640 | _636;
    assign _642 = _641 | _637;
    assign _643 = _642 | _638;
    assign _644 = _643 | _639;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            is_lui_auipc_jal_jalr_addi_add <= gnd;
        else
            is_lui_auipc_jal_jalr_addi_add <= _644;
    end
    assign _629 = _516[30:30];
    assign _628 = _516[6:6];
    assign _627 = _516[19:19];
    assign _630 = _627 | _628;
    assign _631 = _630 | _629;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            is_slti_blt_slt <= gnd;
        else
            is_slti_blt_slt <= _631;
    end
    assign _622 = _516[31:31];
    assign _621 = _516[8:8];
    assign _620 = _516[20:20];
    assign _623 = _620 | _621;
    assign _624 = _623 | _622;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            is_sltiu_bltu_sltu <= gnd;
        else
            is_sltiu_bltu_sltu <= _624;
    end
    assign _615 = _516[12:12];
    assign _614 = _516[14:14];
    assign _613 = _516[13:13];
    assign _616 = _613 | _614;
    assign _617 = _616 | _615;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            is_lbu_lhu_lw <= gnd;
        else
            is_lbu_lhu_lw <= _617;
    end
    assign _606 = _516[31:31];
    assign _605 = _516[20:20];
    assign _604 = _516[30:30];
    assign _603 = _516[19:19];
    assign _607 = _603 | _604;
    assign _608 = _607 | _605;
    assign _609 = _608 | _606;
    assign _610 = _609 | is_beq_bne_blt_bge_bltu_bgeu;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            is_compare <= gnd;
        else
            is_compare <= _610;
    end
    assign _520 = _516[40:40];
    assign _519 = _516[39:39];
    assign _518 = _516[38:38];
    assign _517 = _516[37:37];
    assign _521 = _517 | _518;
    assign _522 = _521 | _519;
    assign is_rdcycle_rdcycleh_rdinstr_rdinstrh = _522 | _520;
    assign _654 = { is_rdcycle_rdcycleh_rdinstr_rdinstrh, is_compare, is_alu_reg_reg, is_alu_reg_imm, is_lbu_lhu_lw, is_beq_bne_blt_bge_bltu_bgeu, is_sltiu_bltu_sltu, is_slti_blt_slt, is_lui_auipc_jal_jalr_addi_add, is_sll_srl_sra, is_sb_sh_sw, is_jalr_addi_slti_sltiu_xori_ori_andi, is_slli_srli_srai, is_lb_lh_lw_lbu_lhu, is_lui_auipc_jal };
    assign _100 = mem_rdata_q[31:25];
    assign _102 = _100 == _101;
    assign _103 = mem_rdata_q[6:0];
    assign _105 = _103 == _104;
    assign _106 = _105 & _102;
    assign _107 = _106 & vdd;
    assign _108 = _107 & vdd;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_timer <= gnd;
        else
            if (_54)
                instr_timer <= _108;
    end
    assign _111 = mem_rdata_q[31:25];
    assign _113 = _111 == _112;
    assign _114 = mem_rdata_q[6:0];
    assign _116 = _114 == _115;
    assign _117 = _116 & _113;
    assign _118 = _117 & vdd;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_maskirq <= gnd;
        else
            if (_54)
                instr_maskirq <= _118;
    end
    assign _121 = mem_rdata_q[31:25];
    assign _123 = _121 == _122;
    assign _124 = mem_rdata_q[6:0];
    assign _126 = _124 == _125;
    assign _127 = _126 & _123;
    assign _128 = _127 & vdd;
    assign _129 = _128 & vdd;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_setq <= gnd;
        else
            if (_54)
                instr_setq <= _129;
    end
    assign _132 = mem_rdata_q[31:25];
    assign _134 = _132 == _133;
    assign _135 = mem_rdata_q[6:0];
    assign _137 = _135 == _136;
    assign _138 = _137 & _134;
    assign _139 = _138 & vdd;
    assign _140 = _139 & vdd;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_getq <= gnd;
        else
            if (_54)
                instr_getq <= _140;
    end
    assign _143 = mem_rdata_q[31:12];
    assign _145 = _143 == _144;
    assign _146 = mem_rdata_q[6:0];
    assign _148 = _146 == _147;
    assign _149 = _148 & _145;
    assign _150 = _149 & vdd;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_rdinstrh <= gnd;
        else
            if (_54)
                instr_rdinstrh <= _150;
    end
    assign _153 = mem_rdata_q[31:12];
    assign _155 = _153 == _154;
    assign _156 = mem_rdata_q[6:0];
    assign _158 = _156 == _157;
    assign _159 = _158 & _155;
    assign _160 = _159 & vdd;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_rdinstr <= gnd;
        else
            if (_54)
                instr_rdinstr <= _160;
    end
    assign _163 = mem_rdata_q[31:12];
    assign _165 = _163 == _164;
    assign _166 = mem_rdata_q[6:0];
    assign _168 = _166 == _167;
    assign _169 = _168 & _165;
    assign _170 = mem_rdata_q[31:12];
    assign _172 = _170 == _171;
    assign _173 = mem_rdata_q[6:0];
    assign _175 = _173 == _174;
    assign _176 = _175 & _172;
    assign _177 = _176 | _169;
    assign _178 = _177 & vdd;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_rdcycleh <= gnd;
        else
            if (_54)
                instr_rdcycleh <= _178;
    end
    assign _181 = mem_rdata_q[31:12];
    assign _183 = _181 == _182;
    assign _184 = mem_rdata_q[6:0];
    assign _186 = _184 == _185;
    assign _187 = _186 & _183;
    assign _188 = mem_rdata_q[31:12];
    assign _190 = _188 == _189;
    assign _191 = mem_rdata_q[6:0];
    assign _193 = _191 == _192;
    assign _194 = _193 & _190;
    assign _195 = _194 | _187;
    assign _196 = _195 & vdd;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_rdcycle <= gnd;
        else
            if (_54)
                instr_rdcycle <= _196;
    end
    assign _199 = mem_rdata_q[31:25];
    assign _201 = _199 == _200;
    assign _202 = mem_rdata_q[14:12];
    assign _204 = _202 == _203;
    assign _205 = is_alu_reg_reg & _204;
    assign _206 = _205 & _201;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_and <= gnd;
        else
            if (_54)
                instr_and <= _206;
    end
    assign _209 = mem_rdata_q[31:25];
    assign _211 = _209 == _210;
    assign _212 = mem_rdata_q[14:12];
    assign _214 = _212 == _213;
    assign _215 = is_alu_reg_reg & _214;
    assign _216 = _215 & _211;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_or <= gnd;
        else
            if (_54)
                instr_or <= _216;
    end
    assign _219 = mem_rdata_q[31:25];
    assign _221 = _219 == _220;
    assign _222 = mem_rdata_q[14:12];
    assign _224 = _222 == _223;
    assign _225 = is_alu_reg_reg & _224;
    assign _226 = _225 & _221;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_sra <= gnd;
        else
            if (_54)
                instr_sra <= _226;
    end
    assign _229 = mem_rdata_q[31:25];
    assign _231 = _229 == _230;
    assign _232 = mem_rdata_q[14:12];
    assign _234 = _232 == _233;
    assign _235 = is_alu_reg_reg & _234;
    assign _236 = _235 & _231;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_srl <= gnd;
        else
            if (_54)
                instr_srl <= _236;
    end
    assign _239 = mem_rdata_q[31:25];
    assign _241 = _239 == _240;
    assign _242 = mem_rdata_q[14:12];
    assign _244 = _242 == _243;
    assign _245 = is_alu_reg_reg & _244;
    assign _246 = _245 & _241;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_xor <= gnd;
        else
            if (_54)
                instr_xor <= _246;
    end
    assign _249 = mem_rdata_q[31:25];
    assign _251 = _249 == _250;
    assign _252 = mem_rdata_q[14:12];
    assign _254 = _252 == _253;
    assign _255 = is_alu_reg_reg & _254;
    assign _256 = _255 & _251;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_sltu <= gnd;
        else
            if (_54)
                instr_sltu <= _256;
    end
    assign _259 = mem_rdata_q[31:25];
    assign _261 = _259 == _260;
    assign _262 = mem_rdata_q[14:12];
    assign _264 = _262 == _263;
    assign _265 = is_alu_reg_reg & _264;
    assign _266 = _265 & _261;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_slt <= gnd;
        else
            if (_54)
                instr_slt <= _266;
    end
    assign _269 = mem_rdata_q[31:25];
    assign _271 = _269 == _270;
    assign _272 = mem_rdata_q[14:12];
    assign _274 = _272 == _273;
    assign _275 = is_alu_reg_reg & _274;
    assign _276 = _275 & _271;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_sll <= gnd;
        else
            if (_54)
                instr_sll <= _276;
    end
    assign _279 = mem_rdata_q[31:25];
    assign _281 = _279 == _280;
    assign _282 = mem_rdata_q[14:12];
    assign _284 = _282 == _283;
    assign _285 = is_alu_reg_reg & _284;
    assign _286 = _285 & _281;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_sub <= gnd;
        else
            if (_54)
                instr_sub <= _286;
    end
    assign _289 = mem_rdata_q[31:25];
    assign _291 = _289 == _290;
    assign _292 = mem_rdata_q[14:12];
    assign _294 = _292 == _293;
    assign _95 = mem_rdata_latched[6:0];
    assign _97 = _95 == _96;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            is_alu_reg_reg <= gnd;
        else
            if (_52)
                is_alu_reg_reg <= _97;
    end
    assign _295 = is_alu_reg_reg & _294;
    assign _296 = _295 & _291;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_add <= gnd;
        else
            if (_54)
                instr_add <= _296;
    end
    assign _299 = mem_rdata_q[31:25];
    assign _301 = _299 == _300;
    assign _302 = mem_rdata_q[14:12];
    assign _304 = _302 == _303;
    assign _305 = is_alu_reg_imm & _304;
    assign _306 = _305 & _301;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_srai <= gnd;
        else
            if (_54)
                instr_srai <= _306;
    end
    assign _309 = mem_rdata_q[31:25];
    assign _311 = _309 == _310;
    assign _312 = mem_rdata_q[14:12];
    assign _314 = _312 == _313;
    assign _315 = is_alu_reg_imm & _314;
    assign _316 = _315 & _311;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_srli <= gnd;
        else
            if (_54)
                instr_srli <= _316;
    end
    assign _319 = mem_rdata_q[31:25];
    assign _321 = _319 == _320;
    assign _322 = mem_rdata_q[14:12];
    assign _324 = _322 == _323;
    assign _325 = is_alu_reg_imm & _324;
    assign _326 = _325 & _321;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_slli <= gnd;
        else
            if (_54)
                instr_slli <= _326;
    end
    assign _329 = mem_rdata_q[14:12];
    assign _331 = _329 == _330;
    assign _332 = is_alu_reg_imm & _331;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_andi <= gnd;
        else
            if (_54)
                instr_andi <= _332;
    end
    assign _335 = mem_rdata_q[14:12];
    assign _337 = _335 == _336;
    assign _338 = is_alu_reg_imm & _337;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_ori <= gnd;
        else
            if (_54)
                instr_ori <= _338;
    end
    assign _341 = mem_rdata_q[14:12];
    assign _343 = _341 == _342;
    assign _344 = is_alu_reg_imm & _343;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_xori <= gnd;
        else
            if (_54)
                instr_xori <= _344;
    end
    assign _347 = mem_rdata_q[14:12];
    assign _349 = _347 == _348;
    assign _350 = is_alu_reg_imm & _349;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_sltiu <= gnd;
        else
            if (_54)
                instr_sltiu <= _350;
    end
    assign _353 = mem_rdata_q[14:12];
    assign _355 = _353 == _354;
    assign _356 = is_alu_reg_imm & _355;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_slti <= gnd;
        else
            if (_54)
                instr_slti <= _356;
    end
    assign _359 = mem_rdata_q[14:12];
    assign _361 = _359 == _360;
    assign _90 = mem_rdata_latched[6:0];
    assign _92 = _90 == _91;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            is_alu_reg_imm <= gnd;
        else
            if (_52)
                is_alu_reg_imm <= _92;
    end
    assign _362 = is_alu_reg_imm & _361;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_addi <= gnd;
        else
            if (_54)
                instr_addi <= _362;
    end
    assign _365 = mem_rdata_q[14:12];
    assign _367 = _365 == _366;
    assign _368 = is_sb_sh_sw & _367;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_sw <= gnd;
        else
            if (_54)
                instr_sw <= _368;
    end
    assign _371 = mem_rdata_q[14:12];
    assign _373 = _371 == _372;
    assign _374 = is_sb_sh_sw & _373;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_sh <= gnd;
        else
            if (_54)
                instr_sh <= _374;
    end
    assign _377 = mem_rdata_q[14:12];
    assign _379 = _377 == _378;
    assign _85 = mem_rdata_latched[6:0];
    assign _87 = _85 == _86;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            is_sb_sh_sw <= gnd;
        else
            if (_52)
                is_sb_sh_sw <= _87;
    end
    assign _380 = is_sb_sh_sw & _379;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_sb <= gnd;
        else
            if (_54)
                instr_sb <= _380;
    end
    assign _383 = mem_rdata_q[14:12];
    assign _385 = _383 == _384;
    assign _386 = is_lb_lh_lw_lbu_lhu & _385;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_lhu <= gnd;
        else
            if (_54)
                instr_lhu <= _386;
    end
    assign _389 = mem_rdata_q[14:12];
    assign _391 = _389 == _390;
    assign _392 = is_lb_lh_lw_lbu_lhu & _391;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_lbu <= gnd;
        else
            if (_54)
                instr_lbu <= _392;
    end
    assign _395 = mem_rdata_q[14:12];
    assign _397 = _395 == _396;
    assign _398 = is_lb_lh_lw_lbu_lhu & _397;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_lw <= gnd;
        else
            if (_54)
                instr_lw <= _398;
    end
    assign _401 = mem_rdata_q[14:12];
    assign _403 = _401 == _402;
    assign _404 = is_lb_lh_lw_lbu_lhu & _403;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_lh <= gnd;
        else
            if (_54)
                instr_lh <= _404;
    end
    assign _407 = mem_rdata_q[14:12];
    assign _409 = _407 == _408;
    assign _80 = mem_rdata_latched[6:0];
    assign _82 = _80 == _81;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            is_lb_lh_lw_lbu_lhu <= gnd;
        else
            if (_52)
                is_lb_lh_lw_lbu_lhu <= _82;
    end
    assign _410 = is_lb_lh_lw_lbu_lhu & _409;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_lb <= gnd;
        else
            if (_54)
                instr_lb <= _410;
    end
    assign _413 = mem_rdata_q[14:12];
    assign _415 = _413 == _414;
    assign _416 = is_beq_bne_blt_bge_bltu_bgeu & _415;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_bgeu <= gnd;
        else
            if (_54)
                instr_bgeu <= _416;
    end
    assign _419 = mem_rdata_q[14:12];
    assign _421 = _419 == _420;
    assign _422 = is_beq_bne_blt_bge_bltu_bgeu & _421;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_bltu <= gnd;
        else
            if (_54)
                instr_bltu <= _422;
    end
    assign _425 = mem_rdata_q[14:12];
    assign _427 = _425 == _426;
    assign _428 = is_beq_bne_blt_bge_bltu_bgeu & _427;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_bge <= gnd;
        else
            if (_54)
                instr_bge <= _428;
    end
    assign _431 = mem_rdata_q[14:12];
    assign _433 = _431 == _432;
    assign _434 = is_beq_bne_blt_bge_bltu_bgeu & _433;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_blt <= gnd;
        else
            if (_54)
                instr_blt <= _434;
    end
    assign _437 = mem_rdata_q[14:12];
    assign _439 = _437 == _438;
    assign _440 = is_beq_bne_blt_bge_bltu_bgeu & _439;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_bne <= gnd;
        else
            if (_54)
                instr_bne <= _440;
    end
    assign _53 = ~ decoder_pseudo_trigger;
    assign _54 = decoder_trigger & _53;
    assign _443 = mem_rdata_q[14:12];
    assign _445 = _443 == _444;
    assign _75 = mem_rdata_latched[6:0];
    assign _77 = _75 == _76;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            is_beq_bne_blt_bge_bltu_bgeu <= gnd;
        else
            if (_52)
                is_beq_bne_blt_bge_bltu_bgeu <= _77;
    end
    assign _446 = is_beq_bne_blt_bge_bltu_bgeu & _445;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_beq <= gnd;
        else
            if (_54)
                instr_beq <= _446;
    end
    assign _449 = mem_rdata_latched[31:25];
    assign _451 = _449 == _450;
    assign _452 = mem_rdata_latched[6:0];
    assign _454 = _452 == _453;
    assign _455 = _454 & _451;
    assign _456 = _455 & vdd;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_waitirq <= gnd;
        else
            if (_52)
                instr_waitirq <= _456;
    end
    assign _459 = mem_rdata_latched[31:25];
    assign _461 = _459 == _460;
    assign _462 = mem_rdata_latched[6:0];
    assign _464 = _462 == _463;
    assign _465 = _464 & _461;
    assign _466 = _465 & vdd;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_retirq <= gnd;
        else
            if (_52)
                instr_retirq <= _466;
    end
    assign _70 = mem_rdata_latched[6:0];
    assign _72 = _70 == _71;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_jalr <= gnd;
        else
            if (_52)
                instr_jalr <= _72;
    end
    assign _65 = mem_rdata_latched[6:0];
    assign _67 = _65 == _66;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_jal <= gnd;
        else
            if (_52)
                instr_jal <= _67;
    end
    assign _60 = mem_rdata_latched[6:0];
    assign _62 = _60 == _61;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_auipc <= gnd;
        else
            if (_52)
                instr_auipc <= _62;
    end
    assign _52 = mem_do_rinst & mem_done;
    assign _55 = mem_rdata_latched[6:0];
    assign _57 = _55 == _56;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            instr_lui <= gnd;
        else
            if (_52)
                instr_lui <= _57;
    end
    assign _469 = instr_lui | instr_auipc;
    assign _470 = _469 | instr_jal;
    assign _471 = _470 | instr_jalr;
    assign _472 = _471 | instr_retirq;
    assign _473 = _472 | instr_waitirq;
    assign _474 = _473 | instr_beq;
    assign _475 = _474 | instr_bne;
    assign _476 = _475 | instr_blt;
    assign _477 = _476 | instr_bge;
    assign _478 = _477 | instr_bltu;
    assign _479 = _478 | instr_bgeu;
    assign _480 = _479 | instr_lb;
    assign _481 = _480 | instr_lh;
    assign _482 = _481 | instr_lw;
    assign _483 = _482 | instr_lbu;
    assign _484 = _483 | instr_lhu;
    assign _485 = _484 | instr_sb;
    assign _486 = _485 | instr_sh;
    assign _487 = _486 | instr_sw;
    assign _488 = _487 | instr_addi;
    assign _489 = _488 | instr_slti;
    assign _490 = _489 | instr_sltiu;
    assign _491 = _490 | instr_xori;
    assign _492 = _491 | instr_ori;
    assign _493 = _492 | instr_andi;
    assign _494 = _493 | instr_slli;
    assign _495 = _494 | instr_srli;
    assign _496 = _495 | instr_srai;
    assign _497 = _496 | instr_add;
    assign _498 = _497 | instr_sub;
    assign _499 = _498 | instr_sll;
    assign _500 = _499 | instr_slt;
    assign _501 = _500 | instr_sltu;
    assign _502 = _501 | instr_xor;
    assign _503 = _502 | instr_srl;
    assign _504 = _503 | instr_sra;
    assign _505 = _504 | instr_or;
    assign _506 = _505 | instr_and;
    assign _507 = _506 | instr_rdcycle;
    assign _508 = _507 | instr_rdcycleh;
    assign _509 = _508 | instr_rdinstr;
    assign _510 = _509 | instr_rdinstrh;
    assign _511 = _510 | instr_getq;
    assign _512 = _511 | instr_setq;
    assign _513 = _512 | instr_maskirq;
    assign _514 = _513 | instr_timer;
    assign instr_trap = ~ _514;
    assign _516 = { instr_trap, instr_timer, instr_waitirq, instr_maskirq, instr_retirq, instr_setq, instr_getq, instr_rdinstrh, instr_rdinstr, instr_rdcycleh, instr_rdcycle, instr_and, instr_or, instr_sra, instr_srl, instr_xor, instr_sltu, instr_slt, instr_sll, instr_sub, instr_add, instr_srai, instr_srli, instr_slli, instr_andi, instr_ori, instr_xori, instr_sltiu, instr_slti, instr_addi, instr_sw, instr_sh, instr_sb, instr_lhu, instr_lbu, instr_lw, instr_lh, instr_lb, instr_bgeu, instr_bltu, instr_bge, instr_blt, instr_bne, instr_beq, instr_jalr, instr_jal, instr_auipc, instr_lui };

    /* aliases */

    /* output assignments */
    assign instr = _516;
    assign is = _654;
    assign pcpi_insn = _770;
    assign decoded_rd = _767;
    assign decoded_rs1 = _762;
    assign decoded_rs2 = _759;
    assign decoded_imm = _754;
    assign decoded_imm_uj = _697;

endmodule
