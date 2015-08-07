module opicorv32_instruction_decoder_wrap (
    decoder_trigger_q,
    decoder_pseudo_trigger,
    decoder_trigger,
    mem_rdata_q,
    mem_rdata_latched,
    mem_done,
    mem_do_rinst,
    resetn,
    clk,
    instr_lui,
    instr_auipc,
    instr_jal,
    instr_jalr,
    instr_beq,
    instr_bne,
    instr_blt,
    instr_bge,
    instr_bltu,
    instr_bgeu,
    instr_lb,
    instr_lh,
    instr_lw,
    instr_lbu,
    instr_lhu,
    instr_sb,
    instr_sh,
    instr_sw,
    instr_addi,
    instr_slti,
    instr_sltiu,
    instr_xori,
    instr_ori,
    instr_andi,
    instr_slli,
    instr_srli,
    instr_srai,
    instr_add,
    instr_sub,
    instr_sll,
    instr_slt,
    instr_sltu,
    instr_xor,
    instr_srl,
    instr_sra,
    instr_or,
    instr_and,
    instr_rdcycle,
    instr_rdcycleh,
    instr_rdinstr,
    instr_rdinstrh,
    instr_getq,
    instr_setq,
    instr_retirq,
    instr_maskirq,
    instr_waitirq,
    instr_timer,
    instr_trap,
    is_lui_auipc_jal,
    is_lb_lh_lw_lbu_lhu,
    is_slli_srli_srai,
    is_jalr_addi_slti_sltiu_xori_ori_andi,
    is_sb_sh_sw,
    is_sll_srl_sra,
    is_lui_auipc_jal_jalr_addi_add,
    is_slti_blt_slt,
    is_sltiu_bltu_sltu,
    is_beq_bne_blt_bge_bltu_bgeu,
    is_lbu_lhu_lw,
    is_alu_reg_imm,
    is_alu_reg_reg,
    is_compare,
    is_rdcycle_rdcycleh_rdinstr_rdinstrh,
    pcpi_insn,
    decoded_rd,
    decoded_rs1,
    decoded_rs2,
    decoded_imm,
    decoded_imm_uj
);

    input decoder_trigger_q;
    input decoder_pseudo_trigger;
    input decoder_trigger;
    input [31:0] mem_rdata_q;
    input [31:0] mem_rdata_latched;
    input mem_done;
    input mem_do_rinst;
    input resetn;
    input clk;
    output instr_lui;
    output instr_auipc;
    output instr_jal;
    output instr_jalr;
    output instr_beq;
    output instr_bne;
    output instr_blt;
    output instr_bge;
    output instr_bltu;
    output instr_bgeu;
    output instr_lb;
    output instr_lh;
    output instr_lw;
    output instr_lbu;
    output instr_lhu;
    output instr_sb;
    output instr_sh;
    output instr_sw;
    output instr_addi;
    output instr_slti;
    output instr_sltiu;
    output instr_xori;
    output instr_ori;
    output instr_andi;
    output instr_slli;
    output instr_srli;
    output instr_srai;
    output instr_add;
    output instr_sub;
    output instr_sll;
    output instr_slt;
    output instr_sltu;
    output instr_xor;
    output instr_srl;
    output instr_sra;
    output instr_or;
    output instr_and;
    output instr_rdcycle;
    output instr_rdcycleh;
    output instr_rdinstr;
    output instr_rdinstrh;
    output instr_getq;
    output instr_setq;
    output instr_retirq;
    output instr_maskirq;
    output instr_waitirq;
    output instr_timer;
    output instr_trap;
    output is_lui_auipc_jal;
    output is_lb_lh_lw_lbu_lhu;
    output is_slli_srli_srai;
    output is_jalr_addi_slti_sltiu_xori_ori_andi;
    output is_sb_sh_sw;
    output is_sll_srl_sra;
    output is_lui_auipc_jal_jalr_addi_add;
    output is_slti_blt_slt;
    output is_sltiu_bltu_sltu;
    output is_beq_bne_blt_bge_bltu_bgeu;
    output is_lbu_lhu_lw;
    output is_alu_reg_imm;
    output is_alu_reg_reg;
    output is_compare;
    output is_rdcycle_rdcycleh_rdinstr_rdinstrh;
    output [31:0] pcpi_insn;
    output [5:0] decoded_rd;
    output [5:0] decoded_rs1;
    output [5:0] decoded_rs2;
    output [31:0] decoded_imm;
    output [31:0] decoded_imm_uj;

    /* signal declarations */
    wire [31:0] _863;
    wire [31:0] _792;
    wire [31:0] compare_decoded_imm_uj;
    wire [31:0] _865;
    wire [31:0] _866;
    wire [31:0] _793;
    wire [31:0] compare_decoded_imm;
    wire [31:0] _868;
    wire [5:0] _869;
    wire [5:0] _794;
    wire [5:0] compare_decoded_rs2;
    wire [5:0] _871;
    wire [5:0] _872;
    wire [5:0] _795;
    wire [5:0] compare_decoded_rs1;
    wire [5:0] _874;
    wire [5:0] _875;
    wire [5:0] _796;
    wire [5:0] compare_decoded_rd;
    wire [5:0] _877;
    wire [31:0] _878;
    wire [31:0] _797;
    wire [31:0] compare_pcpi_insn;
    wire [31:0] _880;
    wire _881;
    wire _862;
    wire compare_is_rdcycle_rdcycleh_rdinstr_rdinstrh;
    wire _883;
    wire _884;
    wire _861;
    wire compare_is_compare;
    wire _886;
    wire _887;
    wire _860;
    wire compare_is_alu_reg_reg;
    wire _889;
    wire _890;
    wire _859;
    wire compare_is_alu_reg_imm;
    wire _892;
    wire _893;
    wire _858;
    wire compare_is_lbu_lhu_lw;
    wire _895;
    wire _896;
    wire _857;
    wire compare_is_beq_bne_blt_bge_bltu_bgeu;
    wire _898;
    wire _899;
    wire _856;
    wire compare_is_sltiu_bltu_sltu;
    wire _901;
    wire _902;
    wire _855;
    wire compare_is_slti_blt_slt;
    wire _904;
    wire _905;
    wire _854;
    wire compare_is_lui_auipc_jal_jalr_addi_add;
    wire _907;
    wire _908;
    wire _853;
    wire compare_is_sll_srl_sra;
    wire _910;
    wire _911;
    wire _852;
    wire compare_is_sb_sh_sw;
    wire _913;
    wire _914;
    wire _851;
    wire compare_is_jalr_addi_slti_sltiu_xori_ori_andi;
    wire _916;
    wire _917;
    wire _850;
    wire compare_is_slli_srli_srai;
    wire _919;
    wire _920;
    wire _849;
    wire compare_is_lb_lh_lw_lbu_lhu;
    wire _922;
    wire _923;
    wire [14:0] _798;
    wire _848;
    wire compare_is_lui_auipc_jal;
    wire _925;
    wire _926;
    wire _847;
    wire compare_instr_trap;
    wire _928;
    wire _929;
    wire _846;
    wire compare_instr_timer;
    wire _931;
    wire _932;
    wire _845;
    wire compare_instr_waitirq;
    wire _934;
    wire _935;
    wire _844;
    wire compare_instr_maskirq;
    wire _937;
    wire _938;
    wire _843;
    wire compare_instr_retirq;
    wire _940;
    wire _941;
    wire _842;
    wire compare_instr_setq;
    wire _943;
    wire _944;
    wire _841;
    wire compare_instr_getq;
    wire _946;
    wire _947;
    wire _840;
    wire compare_instr_rdinstrh;
    wire _949;
    wire _950;
    wire _839;
    wire compare_instr_rdinstr;
    wire _952;
    wire _953;
    wire _838;
    wire compare_instr_rdcycleh;
    wire _955;
    wire _956;
    wire _837;
    wire compare_instr_rdcycle;
    wire _958;
    wire _959;
    wire _836;
    wire compare_instr_and;
    wire _961;
    wire _962;
    wire _835;
    wire compare_instr_or;
    wire _964;
    wire _965;
    wire _834;
    wire compare_instr_sra;
    wire _967;
    wire _968;
    wire _833;
    wire compare_instr_srl;
    wire _970;
    wire _971;
    wire _832;
    wire compare_instr_xor;
    wire _973;
    wire _974;
    wire _831;
    wire compare_instr_sltu;
    wire _976;
    wire _977;
    wire _830;
    wire compare_instr_slt;
    wire _979;
    wire _980;
    wire _829;
    wire compare_instr_sll;
    wire _982;
    wire _983;
    wire _828;
    wire compare_instr_sub;
    wire _985;
    wire _986;
    wire _827;
    wire compare_instr_add;
    wire _988;
    wire _989;
    wire _826;
    wire compare_instr_srai;
    wire _991;
    wire _992;
    wire _825;
    wire compare_instr_srli;
    wire _994;
    wire _995;
    wire _824;
    wire compare_instr_slli;
    wire _997;
    wire _998;
    wire _823;
    wire compare_instr_andi;
    wire _1000;
    wire _1001;
    wire _822;
    wire compare_instr_ori;
    wire _1003;
    wire _1004;
    wire _821;
    wire compare_instr_xori;
    wire _1006;
    wire _1007;
    wire _820;
    wire compare_instr_sltiu;
    wire _1009;
    wire _1010;
    wire _819;
    wire compare_instr_slti;
    wire _1012;
    wire _1013;
    wire _818;
    wire compare_instr_addi;
    wire _1015;
    wire _1016;
    wire _817;
    wire compare_instr_sw;
    wire _1018;
    wire _1019;
    wire _816;
    wire compare_instr_sh;
    wire _1021;
    wire _1022;
    wire _815;
    wire compare_instr_sb;
    wire _1024;
    wire _1025;
    wire _814;
    wire compare_instr_lhu;
    wire _1027;
    wire _1028;
    wire _813;
    wire compare_instr_lbu;
    wire _1030;
    wire _1031;
    wire _812;
    wire compare_instr_lw;
    wire _1033;
    wire _1034;
    wire _811;
    wire compare_instr_lh;
    wire _1036;
    wire _1037;
    wire _810;
    wire compare_instr_lb;
    wire _1039;
    wire _1040;
    wire _809;
    wire compare_instr_bgeu;
    wire _1042;
    wire _1043;
    wire _808;
    wire compare_instr_bltu;
    wire _1045;
    wire _1046;
    wire _807;
    wire compare_instr_bge;
    wire _1048;
    wire _1049;
    wire _806;
    wire compare_instr_blt;
    wire _1051;
    wire _1052;
    wire _805;
    wire compare_instr_bne;
    wire _1054;
    wire _1055;
    wire _804;
    wire compare_instr_beq;
    wire _1057;
    wire _1058;
    wire _803;
    wire compare_instr_jalr;
    wire _1060;
    wire _1061;
    wire _802;
    wire compare_instr_jal;
    wire _1063;
    wire _1064;
    wire _801;
    wire compare_instr_auipc;
    wire _1066;
    wire [176:0] _789;
    wire _1067;
    wire [176:0] _791;
    wire [47:0] _799;
    wire _800;
    wire compare_instr_lui;
    wire _1069;

    /* logic */
    assign _863 = _789[176:145];
    assign _792 = _791[176:145];
    assign compare_decoded_imm_uj = _792 ^ _863;
    assign _865 = compare_decoded_imm_uj ^ _863;
    assign _866 = _789[144:113];
    assign _793 = _791[144:113];
    assign compare_decoded_imm = _793 ^ _866;
    assign _868 = compare_decoded_imm ^ _866;
    assign _869 = _789[112:107];
    assign _794 = _791[112:107];
    assign compare_decoded_rs2 = _794 ^ _869;
    assign _871 = compare_decoded_rs2 ^ _869;
    assign _872 = _789[106:101];
    assign _795 = _791[106:101];
    assign compare_decoded_rs1 = _795 ^ _872;
    assign _874 = compare_decoded_rs1 ^ _872;
    assign _875 = _789[100:95];
    assign _796 = _791[100:95];
    assign compare_decoded_rd = _796 ^ _875;
    assign _877 = compare_decoded_rd ^ _875;
    assign _878 = _789[94:63];
    assign _797 = _791[94:63];
    assign compare_pcpi_insn = _797 ^ _878;
    assign _880 = compare_pcpi_insn ^ _878;
    assign _881 = _789[62:62];
    assign _862 = _798[14:14];
    assign compare_is_rdcycle_rdcycleh_rdinstr_rdinstrh = _862 ^ _881;
    assign _883 = compare_is_rdcycle_rdcycleh_rdinstr_rdinstrh ^ _881;
    assign _884 = _789[61:61];
    assign _861 = _798[13:13];
    assign compare_is_compare = _861 ^ _884;
    assign _886 = compare_is_compare ^ _884;
    assign _887 = _789[60:60];
    assign _860 = _798[12:12];
    assign compare_is_alu_reg_reg = _860 ^ _887;
    assign _889 = compare_is_alu_reg_reg ^ _887;
    assign _890 = _789[59:59];
    assign _859 = _798[11:11];
    assign compare_is_alu_reg_imm = _859 ^ _890;
    assign _892 = compare_is_alu_reg_imm ^ _890;
    assign _893 = _789[58:58];
    assign _858 = _798[10:10];
    assign compare_is_lbu_lhu_lw = _858 ^ _893;
    assign _895 = compare_is_lbu_lhu_lw ^ _893;
    assign _896 = _789[57:57];
    assign _857 = _798[9:9];
    assign compare_is_beq_bne_blt_bge_bltu_bgeu = _857 ^ _896;
    assign _898 = compare_is_beq_bne_blt_bge_bltu_bgeu ^ _896;
    assign _899 = _789[56:56];
    assign _856 = _798[8:8];
    assign compare_is_sltiu_bltu_sltu = _856 ^ _899;
    assign _901 = compare_is_sltiu_bltu_sltu ^ _899;
    assign _902 = _789[55:55];
    assign _855 = _798[7:7];
    assign compare_is_slti_blt_slt = _855 ^ _902;
    assign _904 = compare_is_slti_blt_slt ^ _902;
    assign _905 = _789[54:54];
    assign _854 = _798[6:6];
    assign compare_is_lui_auipc_jal_jalr_addi_add = _854 ^ _905;
    assign _907 = compare_is_lui_auipc_jal_jalr_addi_add ^ _905;
    assign _908 = _789[53:53];
    assign _853 = _798[5:5];
    assign compare_is_sll_srl_sra = _853 ^ _908;
    assign _910 = compare_is_sll_srl_sra ^ _908;
    assign _911 = _789[52:52];
    assign _852 = _798[4:4];
    assign compare_is_sb_sh_sw = _852 ^ _911;
    assign _913 = compare_is_sb_sh_sw ^ _911;
    assign _914 = _789[51:51];
    assign _851 = _798[3:3];
    assign compare_is_jalr_addi_slti_sltiu_xori_ori_andi = _851 ^ _914;
    assign _916 = compare_is_jalr_addi_slti_sltiu_xori_ori_andi ^ _914;
    assign _917 = _789[50:50];
    assign _850 = _798[2:2];
    assign compare_is_slli_srli_srai = _850 ^ _917;
    assign _919 = compare_is_slli_srli_srai ^ _917;
    assign _920 = _789[49:49];
    assign _849 = _798[1:1];
    assign compare_is_lb_lh_lw_lbu_lhu = _849 ^ _920;
    assign _922 = compare_is_lb_lh_lw_lbu_lhu ^ _920;
    assign _923 = _789[48:48];
    assign _798 = _791[62:48];
    assign _848 = _798[0:0];
    assign compare_is_lui_auipc_jal = _848 ^ _923;
    assign _925 = compare_is_lui_auipc_jal ^ _923;
    assign _926 = _789[47:47];
    assign _847 = _799[47:47];
    assign compare_instr_trap = _847 ^ _926;
    assign _928 = compare_instr_trap ^ _926;
    assign _929 = _789[46:46];
    assign _846 = _799[46:46];
    assign compare_instr_timer = _846 ^ _929;
    assign _931 = compare_instr_timer ^ _929;
    assign _932 = _789[45:45];
    assign _845 = _799[45:45];
    assign compare_instr_waitirq = _845 ^ _932;
    assign _934 = compare_instr_waitirq ^ _932;
    assign _935 = _789[44:44];
    assign _844 = _799[44:44];
    assign compare_instr_maskirq = _844 ^ _935;
    assign _937 = compare_instr_maskirq ^ _935;
    assign _938 = _789[43:43];
    assign _843 = _799[43:43];
    assign compare_instr_retirq = _843 ^ _938;
    assign _940 = compare_instr_retirq ^ _938;
    assign _941 = _789[42:42];
    assign _842 = _799[42:42];
    assign compare_instr_setq = _842 ^ _941;
    assign _943 = compare_instr_setq ^ _941;
    assign _944 = _789[41:41];
    assign _841 = _799[41:41];
    assign compare_instr_getq = _841 ^ _944;
    assign _946 = compare_instr_getq ^ _944;
    assign _947 = _789[40:40];
    assign _840 = _799[40:40];
    assign compare_instr_rdinstrh = _840 ^ _947;
    assign _949 = compare_instr_rdinstrh ^ _947;
    assign _950 = _789[39:39];
    assign _839 = _799[39:39];
    assign compare_instr_rdinstr = _839 ^ _950;
    assign _952 = compare_instr_rdinstr ^ _950;
    assign _953 = _789[38:38];
    assign _838 = _799[38:38];
    assign compare_instr_rdcycleh = _838 ^ _953;
    assign _955 = compare_instr_rdcycleh ^ _953;
    assign _956 = _789[37:37];
    assign _837 = _799[37:37];
    assign compare_instr_rdcycle = _837 ^ _956;
    assign _958 = compare_instr_rdcycle ^ _956;
    assign _959 = _789[36:36];
    assign _836 = _799[36:36];
    assign compare_instr_and = _836 ^ _959;
    assign _961 = compare_instr_and ^ _959;
    assign _962 = _789[35:35];
    assign _835 = _799[35:35];
    assign compare_instr_or = _835 ^ _962;
    assign _964 = compare_instr_or ^ _962;
    assign _965 = _789[34:34];
    assign _834 = _799[34:34];
    assign compare_instr_sra = _834 ^ _965;
    assign _967 = compare_instr_sra ^ _965;
    assign _968 = _789[33:33];
    assign _833 = _799[33:33];
    assign compare_instr_srl = _833 ^ _968;
    assign _970 = compare_instr_srl ^ _968;
    assign _971 = _789[32:32];
    assign _832 = _799[32:32];
    assign compare_instr_xor = _832 ^ _971;
    assign _973 = compare_instr_xor ^ _971;
    assign _974 = _789[31:31];
    assign _831 = _799[31:31];
    assign compare_instr_sltu = _831 ^ _974;
    assign _976 = compare_instr_sltu ^ _974;
    assign _977 = _789[30:30];
    assign _830 = _799[30:30];
    assign compare_instr_slt = _830 ^ _977;
    assign _979 = compare_instr_slt ^ _977;
    assign _980 = _789[29:29];
    assign _829 = _799[29:29];
    assign compare_instr_sll = _829 ^ _980;
    assign _982 = compare_instr_sll ^ _980;
    assign _983 = _789[28:28];
    assign _828 = _799[28:28];
    assign compare_instr_sub = _828 ^ _983;
    assign _985 = compare_instr_sub ^ _983;
    assign _986 = _789[27:27];
    assign _827 = _799[27:27];
    assign compare_instr_add = _827 ^ _986;
    assign _988 = compare_instr_add ^ _986;
    assign _989 = _789[26:26];
    assign _826 = _799[26:26];
    assign compare_instr_srai = _826 ^ _989;
    assign _991 = compare_instr_srai ^ _989;
    assign _992 = _789[25:25];
    assign _825 = _799[25:25];
    assign compare_instr_srli = _825 ^ _992;
    assign _994 = compare_instr_srli ^ _992;
    assign _995 = _789[24:24];
    assign _824 = _799[24:24];
    assign compare_instr_slli = _824 ^ _995;
    assign _997 = compare_instr_slli ^ _995;
    assign _998 = _789[23:23];
    assign _823 = _799[23:23];
    assign compare_instr_andi = _823 ^ _998;
    assign _1000 = compare_instr_andi ^ _998;
    assign _1001 = _789[22:22];
    assign _822 = _799[22:22];
    assign compare_instr_ori = _822 ^ _1001;
    assign _1003 = compare_instr_ori ^ _1001;
    assign _1004 = _789[21:21];
    assign _821 = _799[21:21];
    assign compare_instr_xori = _821 ^ _1004;
    assign _1006 = compare_instr_xori ^ _1004;
    assign _1007 = _789[20:20];
    assign _820 = _799[20:20];
    assign compare_instr_sltiu = _820 ^ _1007;
    assign _1009 = compare_instr_sltiu ^ _1007;
    assign _1010 = _789[19:19];
    assign _819 = _799[19:19];
    assign compare_instr_slti = _819 ^ _1010;
    assign _1012 = compare_instr_slti ^ _1010;
    assign _1013 = _789[18:18];
    assign _818 = _799[18:18];
    assign compare_instr_addi = _818 ^ _1013;
    assign _1015 = compare_instr_addi ^ _1013;
    assign _1016 = _789[17:17];
    assign _817 = _799[17:17];
    assign compare_instr_sw = _817 ^ _1016;
    assign _1018 = compare_instr_sw ^ _1016;
    assign _1019 = _789[16:16];
    assign _816 = _799[16:16];
    assign compare_instr_sh = _816 ^ _1019;
    assign _1021 = compare_instr_sh ^ _1019;
    assign _1022 = _789[15:15];
    assign _815 = _799[15:15];
    assign compare_instr_sb = _815 ^ _1022;
    assign _1024 = compare_instr_sb ^ _1022;
    assign _1025 = _789[14:14];
    assign _814 = _799[14:14];
    assign compare_instr_lhu = _814 ^ _1025;
    assign _1027 = compare_instr_lhu ^ _1025;
    assign _1028 = _789[13:13];
    assign _813 = _799[13:13];
    assign compare_instr_lbu = _813 ^ _1028;
    assign _1030 = compare_instr_lbu ^ _1028;
    assign _1031 = _789[12:12];
    assign _812 = _799[12:12];
    assign compare_instr_lw = _812 ^ _1031;
    assign _1033 = compare_instr_lw ^ _1031;
    assign _1034 = _789[11:11];
    assign _811 = _799[11:11];
    assign compare_instr_lh = _811 ^ _1034;
    assign _1036 = compare_instr_lh ^ _1034;
    assign _1037 = _789[10:10];
    assign _810 = _799[10:10];
    assign compare_instr_lb = _810 ^ _1037;
    assign _1039 = compare_instr_lb ^ _1037;
    assign _1040 = _789[9:9];
    assign _809 = _799[9:9];
    assign compare_instr_bgeu = _809 ^ _1040;
    assign _1042 = compare_instr_bgeu ^ _1040;
    assign _1043 = _789[8:8];
    assign _808 = _799[8:8];
    assign compare_instr_bltu = _808 ^ _1043;
    assign _1045 = compare_instr_bltu ^ _1043;
    assign _1046 = _789[7:7];
    assign _807 = _799[7:7];
    assign compare_instr_bge = _807 ^ _1046;
    assign _1048 = compare_instr_bge ^ _1046;
    assign _1049 = _789[6:6];
    assign _806 = _799[6:6];
    assign compare_instr_blt = _806 ^ _1049;
    assign _1051 = compare_instr_blt ^ _1049;
    assign _1052 = _789[5:5];
    assign _805 = _799[5:5];
    assign compare_instr_bne = _805 ^ _1052;
    assign _1054 = compare_instr_bne ^ _1052;
    assign _1055 = _789[4:4];
    assign _804 = _799[4:4];
    assign compare_instr_beq = _804 ^ _1055;
    assign _1057 = compare_instr_beq ^ _1055;
    assign _1058 = _789[3:3];
    assign _803 = _799[3:3];
    assign compare_instr_jalr = _803 ^ _1058;
    assign _1060 = compare_instr_jalr ^ _1058;
    assign _1061 = _789[2:2];
    assign _802 = _799[2:2];
    assign compare_instr_jal = _802 ^ _1061;
    assign _1063 = compare_instr_jal ^ _1061;
    assign _1064 = _789[1:1];
    assign _801 = _799[1:1];
    assign compare_instr_auipc = _801 ^ _1064;
    assign _1066 = compare_instr_auipc ^ _1064;
    picorv32_instruction_decoder
        #( .ENABLE_COUNTERS(1), .ENABLE_REGS_16_31(1), .ENABLE_PCPI(0), .ENABLE_MUL(1), .ENABLE_IRQ(1), .ENABLE_IRQ_QREGS(1), .ENABLE_IRQ_TIMER(1), .irqregs_offset(32), .regindex_bits(6) )
        the_picorv32_instruction_decoder
        ( .clk(clk), .resetn(resetn), .mem_do_rinst(mem_do_rinst), .mem_done(mem_done), .mem_rdata_latched(mem_rdata_latched), .mem_rdata_q(mem_rdata_q), .decoder_trigger(decoder_trigger), .decoder_pseudo_trigger(decoder_pseudo_trigger), .decoder_trigger_q(decoder_trigger_q), .decoded_imm_uj(_789[176:145]), .decoded_imm(_789[144:113]), .decoded_rs2(_789[112:107]), .decoded_rs1(_789[106:101]), .decoded_rd(_789[100:95]), .pcpi_insn(_789[94:63]), .is_rdcycle_rdcycleh_rdinstr_rdinstrh(_789[62:62]), .is_compare(_789[61:61]), .is_alu_reg_reg(_789[60:60]), .is_alu_reg_imm(_789[59:59]), .is_lbu_lhu_lw(_789[58:58]), .is_beq_bne_blt_bge_bltu_bgeu(_789[57:57]), .is_sltiu_bltu_sltu(_789[56:56]), .is_slti_blt_slt(_789[55:55]), .is_lui_auipc_jal_jalr_addi_add(_789[54:54]), .is_sll_srl_sra(_789[53:53]), .is_sb_sh_sw(_789[52:52]), .is_jalr_addi_slti_sltiu_xori_ori_andi(_789[51:51]), .is_slli_srli_srai(_789[50:50]), .is_lb_lh_lw_lbu_lhu(_789[49:49]), .is_lui_auipc_jal(_789[48:48]), .instr_trap(_789[47:47]), .instr_timer(_789[46:46]), .instr_waitirq(_789[45:45]), .instr_maskirq(_789[44:44]), .instr_retirq(_789[43:43]), .instr_setq(_789[42:42]), .instr_getq(_789[41:41]), .instr_rdinstrh(_789[40:40]), .instr_rdinstr(_789[39:39]), .instr_rdcycleh(_789[38:38]), .instr_rdcycle(_789[37:37]), .instr_and(_789[36:36]), .instr_or(_789[35:35]), .instr_sra(_789[34:34]), .instr_srl(_789[33:33]), .instr_xor(_789[32:32]), .instr_sltu(_789[31:31]), .instr_slt(_789[30:30]), .instr_sll(_789[29:29]), .instr_sub(_789[28:28]), .instr_add(_789[27:27]), .instr_srai(_789[26:26]), .instr_srli(_789[25:25]), .instr_slli(_789[24:24]), .instr_andi(_789[23:23]), .instr_ori(_789[22:22]), .instr_xori(_789[21:21]), .instr_sltiu(_789[20:20]), .instr_slti(_789[19:19]), .instr_addi(_789[18:18]), .instr_sw(_789[17:17]), .instr_sh(_789[16:16]), .instr_sb(_789[15:15]), .instr_lhu(_789[14:14]), .instr_lbu(_789[13:13]), .instr_lw(_789[12:12]), .instr_lh(_789[11:11]), .instr_lb(_789[10:10]), .instr_bgeu(_789[9:9]), .instr_bltu(_789[8:8]), .instr_bge(_789[7:7]), .instr_blt(_789[6:6]), .instr_bne(_789[5:5]), .instr_beq(_789[4:4]), .instr_jalr(_789[3:3]), .instr_jal(_789[2:2]), .instr_auipc(_789[1:1]), .instr_lui(_789[0:0]) );
    assign _1067 = _789[0:0];
    opicorv32_instruction_decoder
        the_opicorv32_instruction_decoder
        ( .clk(clk), .resetn(resetn), .mem_do_rinst(mem_do_rinst), .mem_done(mem_done), .mem_rdata_latched(mem_rdata_latched), .mem_rdata_q(mem_rdata_q), .decoder_trigger(decoder_trigger), .decoder_pseudo_trigger(decoder_pseudo_trigger), .decoded_imm_uj(_791[176:145]), .decoded_imm(_791[144:113]), .decoded_rs2(_791[112:107]), .decoded_rs1(_791[106:101]), .decoded_rd(_791[100:95]), .pcpi_insn(_791[94:63]), .is(_791[62:48]), .instr(_791[47:0]) );
    assign _799 = _791[47:0];
    assign _800 = _799[0:0];
    assign compare_instr_lui = _800 ^ _1067;
    assign _1069 = compare_instr_lui ^ _1067;

    /* aliases */

    /* output assignments */
    assign instr_lui = _1069;
    assign instr_auipc = _1066;
    assign instr_jal = _1063;
    assign instr_jalr = _1060;
    assign instr_beq = _1057;
    assign instr_bne = _1054;
    assign instr_blt = _1051;
    assign instr_bge = _1048;
    assign instr_bltu = _1045;
    assign instr_bgeu = _1042;
    assign instr_lb = _1039;
    assign instr_lh = _1036;
    assign instr_lw = _1033;
    assign instr_lbu = _1030;
    assign instr_lhu = _1027;
    assign instr_sb = _1024;
    assign instr_sh = _1021;
    assign instr_sw = _1018;
    assign instr_addi = _1015;
    assign instr_slti = _1012;
    assign instr_sltiu = _1009;
    assign instr_xori = _1006;
    assign instr_ori = _1003;
    assign instr_andi = _1000;
    assign instr_slli = _997;
    assign instr_srli = _994;
    assign instr_srai = _991;
    assign instr_add = _988;
    assign instr_sub = _985;
    assign instr_sll = _982;
    assign instr_slt = _979;
    assign instr_sltu = _976;
    assign instr_xor = _973;
    assign instr_srl = _970;
    assign instr_sra = _967;
    assign instr_or = _964;
    assign instr_and = _961;
    assign instr_rdcycle = _958;
    assign instr_rdcycleh = _955;
    assign instr_rdinstr = _952;
    assign instr_rdinstrh = _949;
    assign instr_getq = _946;
    assign instr_setq = _943;
    assign instr_retirq = _940;
    assign instr_maskirq = _937;
    assign instr_waitirq = _934;
    assign instr_timer = _931;
    assign instr_trap = _928;
    assign is_lui_auipc_jal = _925;
    assign is_lb_lh_lw_lbu_lhu = _922;
    assign is_slli_srli_srai = _919;
    assign is_jalr_addi_slti_sltiu_xori_ori_andi = _916;
    assign is_sb_sh_sw = _913;
    assign is_sll_srl_sra = _910;
    assign is_lui_auipc_jal_jalr_addi_add = _907;
    assign is_slti_blt_slt = _904;
    assign is_sltiu_bltu_sltu = _901;
    assign is_beq_bne_blt_bge_bltu_bgeu = _898;
    assign is_lbu_lhu_lw = _895;
    assign is_alu_reg_imm = _892;
    assign is_alu_reg_reg = _889;
    assign is_compare = _886;
    assign is_rdcycle_rdcycleh_rdinstr_rdinstrh = _883;
    assign pcpi_insn = _880;
    assign decoded_rd = _877;
    assign decoded_rs1 = _874;
    assign decoded_rs2 = _871;
    assign decoded_imm = _868;
    assign decoded_imm_uj = _865;

endmodule
