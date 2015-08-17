module decoder (
    junk_p_0,
    cond_branch_p_0,
    f7_p_0,
    f3_p_0,
    sys_p_0,
    fen_p_0,
    opr_p_0,
    opi_p_0,
    st_p_0,
    ld_p_0,
    bra_p_0,
    jalr_p_0,
    jal_p_0,
    auipc_p_0,
    lui_p_0,
    trap_p_0,
    next_pc_p_0,
    pc_p_0,
    imm_p_0,
    rdd_p_0,
    rdd_p_4,
    mio_rdata,
    clr,
    clk,
    pen_p_0,
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
    next_pc,
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
    f3,
    f7,
    cond_branch,
    junk
);

    input junk_p_0;
    input cond_branch_p_0;
    input f7_p_0;
    input f3_p_0;
    input sys_p_0;
    input fen_p_0;
    input opr_p_0;
    input opi_p_0;
    input st_p_0;
    input ld_p_0;
    input bra_p_0;
    input jalr_p_0;
    input jal_p_0;
    input auipc_p_0;
    input lui_p_0;
    input trap_p_0;
    input [31:0] next_pc_p_0;
    input [31:0] pc_p_0;
    input [31:0] imm_p_0;
    input [31:0] rdd_p_0;
    input [31:0] rdd_p_4;
    input [31:0] mio_rdata;
    input clr;
    input clk;
    input pen_p_0;
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
    output [31:0] next_pc;
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
    output f3;
    output f7;
    output cond_branch;
    output junk;

    /* signal declarations */
    wire _3577 = 1'b0;
    wire _3578 = 1'b0;
    wire _1566 = 1'b0;
    wire _1567 = 1'b0;
    reg _1568;
    reg _3579;
    wire _3573 = 1'b0;
    wire _3574 = 1'b0;
    wire _1570 = 1'b0;
    wire _1571 = 1'b0;
    reg _1572;
    reg _3575;
    wire _3569 = 1'b0;
    wire _3570 = 1'b0;
    wire _1574 = 1'b0;
    wire _1575 = 1'b0;
    reg _1576;
    reg _3571;
    wire _3565 = 1'b0;
    wire _3566 = 1'b0;
    wire _1578 = 1'b0;
    wire _1579 = 1'b0;
    reg _1580;
    reg _3567;
    wire _3561 = 1'b0;
    wire _3562 = 1'b0;
    wire _1582 = 1'b0;
    wire _1583 = 1'b0;
    reg _1584;
    reg _3563;
    wire _3557 = 1'b0;
    wire _3558 = 1'b0;
    wire _1586 = 1'b0;
    wire _1587 = 1'b0;
    reg _1588;
    reg _3559;
    wire _3553 = 1'b0;
    wire _3554 = 1'b0;
    wire _1590 = 1'b0;
    wire _1591 = 1'b0;
    reg _1592;
    reg _3555;
    wire _3549 = 1'b0;
    wire _3550 = 1'b0;
    wire _1594 = 1'b0;
    wire _1595 = 1'b0;
    reg _1596;
    reg _3551;
    wire _3545 = 1'b0;
    wire _3546 = 1'b0;
    wire _1598 = 1'b0;
    wire _1599 = 1'b0;
    reg _1600;
    reg _3547;
    wire _3541 = 1'b0;
    wire _3542 = 1'b0;
    wire _1602 = 1'b0;
    wire _1603 = 1'b0;
    reg _1604;
    reg _3543;
    wire _3537 = 1'b0;
    wire _3538 = 1'b0;
    wire _1606 = 1'b0;
    wire _1607 = 1'b0;
    reg _1608;
    reg _3539;
    wire _3533 = 1'b0;
    wire _3534 = 1'b0;
    wire _1610 = 1'b0;
    wire _1611 = 1'b0;
    reg _1612;
    reg _3535;
    wire _3529 = 1'b0;
    wire _3530 = 1'b0;
    wire _1614 = 1'b0;
    wire _1615 = 1'b0;
    reg _1616;
    reg _3531;
    wire _3525 = 1'b0;
    wire _3526 = 1'b0;
    wire _1618 = 1'b0;
    wire _1619 = 1'b0;
    reg _1620;
    reg _3527;
    wire _3521 = 1'b0;
    wire _3522 = 1'b0;
    wire _1622 = 1'b0;
    wire _1623 = 1'b0;
    reg _1624;
    reg _3523;
    wire _3517 = 1'b0;
    wire _3518 = 1'b0;
    wire _1626 = 1'b0;
    wire _1627 = 1'b0;
    reg _1628;
    reg _3519;
    wire [47:0] _3513 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _3514 = 48'b000000000000000000000000000000000000000000000000;
    wire _3047;
    wire _3046;
    wire _3045;
    wire _3044;
    wire _3043;
    wire _3042;
    wire _3041;
    wire _3040;
    wire _3039;
    wire _3038;
    wire _3037;
    wire _3036;
    wire _3035;
    wire _3034;
    wire _3033;
    wire _3032;
    wire _3031;
    wire _3030;
    wire _3029;
    wire _3028;
    wire _3026;
    wire _3027;
    wire _3024;
    wire _3025;
    wire _3022;
    wire _3023;
    wire _3020;
    wire _3021;
    wire _3018;
    wire _3019;
    wire _3016;
    wire _3017;
    wire _3014;
    wire _3015;
    wire _3012;
    wire _3013;
    wire _2880;
    wire _3010;
    wire _3011;
    wire _3008;
    wire _3009;
    wire _3006;
    wire _3007;
    wire _3004;
    wire _3005;
    wire _3002;
    wire _3003;
    wire _3000;
    wire _3001;
    wire _2999;
    wire _2997;
    wire _2998;
    wire _2996;
    wire _2994;
    wire _2995;
    wire _2943;
    wire _2993;
    wire [1:0] _2944 = 2'b10;
    wire _2945;
    wire _2946;
    wire [1:0] _2947 = 2'b01;
    wire _2948;
    wire _2949;
    wire [4:0] _2933 = 5'b00000;
    wire [4:0] _2932;
    wire _2934;
    wire [3:0] _2936 = 4'b1100;
    wire [3:0] _2935;
    wire _2937;
    wire _2938;
    wire _2939;
    wire _2940;
    wire _2941;
    wire [1:0] _2950 = 2'b00;
    wire [1:0] _2942;
    wire _2951;
    wire _2952;
    wire [11:0] _2923 = 12'b000000000001;
    wire _2924;
    wire _2930;
    wire [6:0] _2919 = 7'b1110011;
    wire _2920;
    wire [4:0] _2892 = 5'b00000;
    wire [4:0] _2889;
    wire _2893;
    wire [4:0] _2896 = 5'b00000;
    wire [4:0] _2891;
    wire _2897;
    wire _2927;
    wire _2928;
    wire _2929;
    wire [11:0] _2925 = 12'b000000000000;
    wire [11:0] _2848;
    wire _2926;
    wire _2931;
    wire _2921;
    wire [6:0] _2917 = 7'b0001111;
    wire _2918;
    wire _2922;
    wire _2964;
    wire _2965;
    wire _2963;
    wire _2966;
    wire _2967;
    wire [6:0] _2915 = 7'b0110011;
    wire _2916;
    wire _2968;
    wire [6:0] _2884 = 7'b0100000;
    wire _2885;
    wire _2888;
    wire _2969;
    wire [6:0] _2886 = 7'b0000000;
    wire [6:0] _2847;
    wire _2887;
    wire _2970;
    wire _2971;
    wire _2972;
    wire _2881;
    wire _2973;
    wire _2974;
    wire _2975;
    wire _2877;
    wire _2960;
    wire _2961;
    wire _2962;
    wire _2883;
    wire _2882;
    wire _2956;
    wire _2957;
    wire _2958;
    wire _2959;
    wire _2879;
    wire _2878;
    wire _2953;
    wire _2954;
    wire _2955;
    wire _2976;
    wire _2977;
    wire _2978;
    wire _2979;
    wire _2980;
    wire _2981;
    wire _2982;
    wire _2983;
    wire _2984;
    wire _2985;
    wire _2986;
    wire _2987;
    wire _2988;
    wire _2989;
    wire _2990;
    wire _2991;
    wire _2992;
    wire [47:0] _3048;
    reg [47:0] _3515;
    wire [31:0] _3509 = 32'b00000000000000000000000000000000;
    wire [31:0] _3510 = 32'b00000000000000000000000000000000;
    reg [31:0] _3511;
    wire [31:0] _3505 = 32'b00000000000000000000000000000000;
    wire [31:0] _3506 = 32'b00000000000000000000000000000000;
    wire [31:0] _1638 = 32'b00000000000000000000000000000000;
    wire [31:0] _1639 = 32'b00000000000000000000000000000000;
    reg [31:0] _1640;
    reg [31:0] _3507;
    wire [31:0] _3501 = 32'b00000000000000000000000000000000;
    wire [31:0] _3502 = 32'b00000000000000000000000000000000;
    wire [31:0] _1642 = 32'b00000000000000000000000000000000;
    wire [31:0] _1643 = 32'b00000000000000000000000000000000;
    reg [31:0] _1644;
    reg [31:0] _3503;
    wire [31:0] _3497 = 32'b00000000000000000000000000000000;
    wire [31:0] _3498 = 32'b00000000000000000000000000000000;
    wire [31:0] _1646 = 32'b00000000000000000000000000000000;
    wire [31:0] _1647 = 32'b00000000000000000000000000000000;
    reg [31:0] _1648;
    reg [31:0] _3499;
    wire [31:0] _3493 = 32'b00000000000000000000000000000000;
    wire [31:0] _3494 = 32'b00000000000000000000000000000000;
    reg [31:0] _3495;
    wire [31:0] _3489 = 32'b00000000000000000000000000000000;
    wire [31:0] _3490 = 32'b00000000000000000000000000000000;
    wire [31:0] _1654 = 32'b00000000000000000000000000000000;
    wire [31:0] _1655 = 32'b00000000000000000000000000000000;
    reg [31:0] _1656;
    reg [31:0] _3491;
    wire [31:0] _3485 = 32'b00000000000000000000000000000000;
    wire [31:0] _3486 = 32'b00000000000000000000000000000000;
    wire _3064;
    wire [9:0] _3061;
    wire _3062;
    wire [7:0] _3063;
    wire [2:0] _3054;
    wire [19:0] _3050;
    wire [20:0] _3051;
    wire _3052;
    wire [1:0] _3053;
    wire [3:0] _3055;
    wire [7:0] _3056;
    wire [10:0] _3057;
    wire [31:0] _3059;
    wire [11:0] _3060;
    wire [31:0] _3065;
    wire [11:0] _3103 = 12'b000000000000;
    wire [19:0] _3104;
    wire [31:0] _3105;
    wire [11:0] _3092;
    wire _3093;
    wire [1:0] _3094;
    wire [3:0] _3095;
    wire [7:0] _3096;
    wire [15:0] _3097;
    wire [19:0] _3098;
    wire [31:0] _3100;
    wire [2:0] _3085;
    wire [3:0] _3081;
    wire [5:0] _3080;
    wire _3079;
    wire _3078;
    wire [12:0] _3082;
    wire _3083;
    wire [1:0] _3084;
    wire [3:0] _3086;
    wire [7:0] _3087;
    wire [15:0] _3088;
    wire [18:0] _3089;
    wire [31:0] _3091;
    wire [4:0] _3068;
    wire [6:0] _3067;
    wire [11:0] _3069;
    wire _3070;
    wire [1:0] _3071;
    wire [3:0] _3072;
    wire [7:0] _3073;
    wire [15:0] _3074;
    wire [19:0] _3075;
    wire [31:0] _3077;
    wire [31:0] _3066 = 32'b00000000000000000000000000000000;
    wire [31:0] _3107;
    wire [6:0] _2907 = 7'b1100011;
    wire _2908;
    wire [31:0] _3108;
    wire _2852;
    wire _2855;
    wire _2863;
    wire _2853;
    wire _2854;
    wire _2862;
    wire _2856;
    wire _2858;
    wire _2861;
    wire _2857;
    wire _2859;
    wire _2860;
    wire _2864;
    wire _2867;
    wire _2874;
    wire _2865;
    wire _2866;
    wire _2873;
    wire _2868;
    wire _2870;
    wire _2872;
    wire _2849;
    wire _2850;
    wire _2869;
    wire [2:0] _2846;
    wire _2851;
    wire _2871;
    wire [7:0] _2875;
    wire _2876;
    wire [6:0] _2904 = 7'b1100111;
    wire _2905;
    wire _2906;
    wire _3101;
    wire _3102;
    wire [31:0] _3109;
    wire _3106;
    wire [31:0] _3110;
    wire [6:0] _2902 = 7'b1101111;
    wire _2903;
    wire [31:0] _3111;
    reg [31:0] _3443;
    wire [6:0] _2911 = 7'b0100011;
    wire _2912;
    wire [6:0] _2909 = 7'b0000011;
    wire _2910;
    wire [6:0] _2900 = 7'b0010111;
    wire _2901;
    wire [6:0] _2898 = 7'b0110111;
    wire _2899;
    wire [6:0] _2913 = 7'b0010011;
    wire [6:0] _2845;
    wire _2914;
    wire _3445;
    wire _3446;
    wire _3447;
    wire _3448;
    wire [31:0] _3449;
    reg [31:0] _3487;
    wire [31:0] _3481 = 32'b00000000000000000000000000000000;
    wire [31:0] _3482 = 32'b00000000000000000000000000000000;
    wire _3438;
    wire _3439;
    wire [31:0] _3440 = 32'b00000000000000000000000000000000;
    wire [31:0] _3441 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_31;
    wire _3433;
    wire _3434;
    wire [31:0] _3435 = 32'b00000000000000000000000000000000;
    wire [31:0] _3436 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_30;
    wire _3428;
    wire _3429;
    wire [31:0] _3430 = 32'b00000000000000000000000000000000;
    wire [31:0] _3431 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_29;
    wire _3423;
    wire _3424;
    wire [31:0] _3425 = 32'b00000000000000000000000000000000;
    wire [31:0] _3426 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_28;
    wire _3418;
    wire _3419;
    wire [31:0] _3420 = 32'b00000000000000000000000000000000;
    wire [31:0] _3421 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_27;
    wire _3413;
    wire _3414;
    wire [31:0] _3415 = 32'b00000000000000000000000000000000;
    wire [31:0] _3416 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_26;
    wire _3408;
    wire _3409;
    wire [31:0] _3410 = 32'b00000000000000000000000000000000;
    wire [31:0] _3411 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_25;
    wire _3403;
    wire _3404;
    wire [31:0] _3405 = 32'b00000000000000000000000000000000;
    wire [31:0] _3406 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_24;
    wire _3398;
    wire _3399;
    wire [31:0] _3400 = 32'b00000000000000000000000000000000;
    wire [31:0] _3401 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_23;
    wire _3393;
    wire _3394;
    wire [31:0] _3395 = 32'b00000000000000000000000000000000;
    wire [31:0] _3396 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_22;
    wire _3388;
    wire _3389;
    wire [31:0] _3390 = 32'b00000000000000000000000000000000;
    wire [31:0] _3391 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_21;
    wire _3383;
    wire _3384;
    wire [31:0] _3385 = 32'b00000000000000000000000000000000;
    wire [31:0] _3386 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_20;
    wire _3378;
    wire _3379;
    wire [31:0] _3380 = 32'b00000000000000000000000000000000;
    wire [31:0] _3381 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_19;
    wire _3373;
    wire _3374;
    wire [31:0] _3375 = 32'b00000000000000000000000000000000;
    wire [31:0] _3376 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_18;
    wire _3368;
    wire _3369;
    wire [31:0] _3370 = 32'b00000000000000000000000000000000;
    wire [31:0] _3371 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_17;
    wire _3363;
    wire _3364;
    wire [31:0] _3365 = 32'b00000000000000000000000000000000;
    wire [31:0] _3366 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_16;
    wire _3358;
    wire _3359;
    wire [31:0] _3360 = 32'b00000000000000000000000000000000;
    wire [31:0] _3361 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_15;
    wire _3353;
    wire _3354;
    wire [31:0] _3355 = 32'b00000000000000000000000000000000;
    wire [31:0] _3356 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_14;
    wire _3348;
    wire _3349;
    wire [31:0] _3350 = 32'b00000000000000000000000000000000;
    wire [31:0] _3351 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_13;
    wire _3343;
    wire _3344;
    wire [31:0] _3345 = 32'b00000000000000000000000000000000;
    wire [31:0] _3346 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_12;
    wire _3338;
    wire _3339;
    wire [31:0] _3340 = 32'b00000000000000000000000000000000;
    wire [31:0] _3341 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_11;
    wire _3333;
    wire _3334;
    wire [31:0] _3335 = 32'b00000000000000000000000000000000;
    wire [31:0] _3336 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_10;
    wire _3328;
    wire _3329;
    wire [31:0] _3330 = 32'b00000000000000000000000000000000;
    wire [31:0] _3331 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_09;
    wire _3323;
    wire _3324;
    wire [31:0] _3325 = 32'b00000000000000000000000000000000;
    wire [31:0] _3326 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_08;
    wire _3318;
    wire _3319;
    wire [31:0] _3320 = 32'b00000000000000000000000000000000;
    wire [31:0] _3321 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_07;
    wire _3313;
    wire _3314;
    wire [31:0] _3315 = 32'b00000000000000000000000000000000;
    wire [31:0] _3316 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_06;
    wire _3308;
    wire _3309;
    wire [31:0] _3310 = 32'b00000000000000000000000000000000;
    wire [31:0] _3311 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_05;
    wire _3303;
    wire _3304;
    wire [31:0] _3305 = 32'b00000000000000000000000000000000;
    wire [31:0] _3306 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_04;
    wire _3298;
    wire _3299;
    wire [31:0] _3300 = 32'b00000000000000000000000000000000;
    wire [31:0] _3301 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_03;
    wire _3293;
    wire _3294;
    wire [31:0] _3295 = 32'b00000000000000000000000000000000;
    wire [31:0] _3296 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_02;
    wire _3127;
    wire _3130;
    wire _3138;
    wire _3158;
    wire _3206;
    wire _3128;
    wire _3129;
    wire _3137;
    wire _3157;
    wire _3205;
    wire _3131;
    wire _3133;
    wire _3136;
    wire _3156;
    wire _3204;
    wire _3132;
    wire _3134;
    wire _3135;
    wire _3155;
    wire _3203;
    wire _3139;
    wire _3142;
    wire _3149;
    wire _3154;
    wire _3202;
    wire _3140;
    wire _3141;
    wire _3148;
    wire _3153;
    wire _3201;
    wire _3143;
    wire _3145;
    wire _3147;
    wire _3152;
    wire _3200;
    wire _3144;
    wire _3146;
    wire _3150;
    wire _3151;
    wire _3199;
    wire _3159;
    wire _3162;
    wire _3170;
    wire _3189;
    wire _3198;
    wire _3160;
    wire _3161;
    wire _3169;
    wire _3188;
    wire _3197;
    wire _3163;
    wire _3165;
    wire _3168;
    wire _3187;
    wire _3196;
    wire _3164;
    wire _3166;
    wire _3167;
    wire _3186;
    wire _3195;
    wire _3171;
    wire _3174;
    wire _3181;
    wire _3185;
    wire _3194;
    wire _3172;
    wire _3173;
    wire _3180;
    wire _3184;
    wire _3193;
    wire _3175;
    wire _3177;
    wire _3179;
    wire _3183;
    wire _3192;
    wire _3176;
    wire _3178;
    wire _3182;
    wire _3190;
    wire _3191;
    wire _3207;
    wire _3210;
    wire _3218;
    wire _3238;
    wire _3285;
    wire _3208;
    wire _3209;
    wire _3217;
    wire _3237;
    wire _3284;
    wire _3211;
    wire _3213;
    wire _3216;
    wire _3236;
    wire _3283;
    wire _3212;
    wire _3214;
    wire _3215;
    wire _3235;
    wire _3282;
    wire _3219;
    wire _3222;
    wire _3229;
    wire _3234;
    wire _3281;
    wire _3220;
    wire _3221;
    wire _3228;
    wire _3233;
    wire _3280;
    wire _3223;
    wire _3225;
    wire _3227;
    wire _3232;
    wire _3279;
    wire _3224;
    wire _3226;
    wire _3230;
    wire _3231;
    wire _3278;
    wire _3239;
    wire _3242;
    wire _3250;
    wire _3269;
    wire _3277;
    wire _3240;
    wire _3241;
    wire _3249;
    wire _3268;
    wire _3276;
    wire _3243;
    wire _3245;
    wire _3248;
    wire _3267;
    wire _3275;
    wire _3244;
    wire _3246;
    wire _3247;
    wire _3266;
    wire _3274;
    wire _3251;
    wire _3254;
    wire _3261;
    wire _3265;
    wire _3273;
    wire _3252;
    wire _3253;
    wire _3260;
    wire _3264;
    wire _3272;
    wire _3255;
    wire _3257;
    wire _3259;
    wire _3263;
    wire _3271;
    wire _3122;
    wire _3123;
    wire _3256;
    wire _3124;
    wire _3258;
    wire _3125;
    wire _3262;
    wire [4:0] _3121 = 5'b00000;
    wire _3126;
    wire _3270;
    wire [31:0] _3286;
    wire _3288;
    wire gnd = 1'b0;
    wire _3289;
    wire [31:0] _3290 = 32'b00000000000000000000000000000000;
    wire [31:0] _3291 = 32'b00000000000000000000000000000000;
    wire [31:0] _2166 = 32'b00000000000000000000000000000000;
    wire [31:0] _2167 = 32'b00000000000000000000000000000000;
    reg [31:0] _2168;
    reg [31:0] reg_01;
    wire [31:0] _3287 = 32'b00000000000000000000000000000000;
    reg [31:0] _3444;
    reg [31:0] _3483;
    wire _3477 = 1'b0;
    wire _3478 = 1'b0;
    wire [4:0] _3119 = 5'b00000;
    wire _3120;
    reg _3479;
    wire _3473 = 1'b0;
    wire _3474 = 1'b0;
    wire [4:0] _3115 = 5'b00000;
    wire _3116;
    reg _3475;
    wire _3469 = 1'b0;
    wire _3470 = 1'b0;
    wire [4:0] _3117 = 5'b00000;
    wire _3118;
    reg _3471;
    wire [4:0] _3465 = 5'b00000;
    wire [4:0] _3466 = 5'b00000;
    wire [4:0] _3114;
    reg [4:0] _3467;
    wire [4:0] _3461 = 5'b00000;
    wire [4:0] _3462 = 5'b00000;
    wire [4:0] _3112;
    reg [4:0] _3463;
    wire [4:0] _3457 = 5'b00000;
    wire [4:0] _3458 = 5'b00000;
    wire [4:0] _3113;
    reg [4:0] _3459;
    wire _3453 = 1'b0;
    wire _3454 = 1'b0;
    wire _3450 = 1'b0;
    wire _3451 = 1'b0;
    wire _1690 = 1'b0;
    wire vdd = 1'b1;
    wire _1691 = 1'b0;
    reg _1692;
    reg _3452;
    reg _3455;

    /* logic */
    always @(posedge clk) begin
        if (clr)
            _1568 <= _1566;
        else
            _1568 <= junk_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _3579 <= _3577;
        else
            _3579 <= _1568;
    end
    always @(posedge clk) begin
        if (clr)
            _1572 <= _1570;
        else
            _1572 <= cond_branch_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _3575 <= _3573;
        else
            _3575 <= _1572;
    end
    always @(posedge clk) begin
        if (clr)
            _1576 <= _1574;
        else
            _1576 <= f7_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _3571 <= _3569;
        else
            _3571 <= _1576;
    end
    always @(posedge clk) begin
        if (clr)
            _1580 <= _1578;
        else
            _1580 <= f3_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _3567 <= _3565;
        else
            _3567 <= _1580;
    end
    always @(posedge clk) begin
        if (clr)
            _1584 <= _1582;
        else
            _1584 <= sys_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _3563 <= _3561;
        else
            _3563 <= _1584;
    end
    always @(posedge clk) begin
        if (clr)
            _1588 <= _1586;
        else
            _1588 <= fen_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _3559 <= _3557;
        else
            _3559 <= _1588;
    end
    always @(posedge clk) begin
        if (clr)
            _1592 <= _1590;
        else
            _1592 <= opr_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _3555 <= _3553;
        else
            _3555 <= _1592;
    end
    always @(posedge clk) begin
        if (clr)
            _1596 <= _1594;
        else
            _1596 <= opi_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _3551 <= _3549;
        else
            _3551 <= _1596;
    end
    always @(posedge clk) begin
        if (clr)
            _1600 <= _1598;
        else
            _1600 <= st_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _3547 <= _3545;
        else
            _3547 <= _1600;
    end
    always @(posedge clk) begin
        if (clr)
            _1604 <= _1602;
        else
            _1604 <= ld_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _3543 <= _3541;
        else
            _3543 <= _1604;
    end
    always @(posedge clk) begin
        if (clr)
            _1608 <= _1606;
        else
            _1608 <= bra_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _3539 <= _3537;
        else
            _3539 <= _1608;
    end
    always @(posedge clk) begin
        if (clr)
            _1612 <= _1610;
        else
            _1612 <= jalr_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _3535 <= _3533;
        else
            _3535 <= _1612;
    end
    always @(posedge clk) begin
        if (clr)
            _1616 <= _1614;
        else
            _1616 <= jal_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _3531 <= _3529;
        else
            _3531 <= _1616;
    end
    always @(posedge clk) begin
        if (clr)
            _1620 <= _1618;
        else
            _1620 <= auipc_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _3527 <= _3525;
        else
            _3527 <= _1620;
    end
    always @(posedge clk) begin
        if (clr)
            _1624 <= _1622;
        else
            _1624 <= lui_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _3523 <= _3521;
        else
            _3523 <= _1624;
    end
    always @(posedge clk) begin
        if (clr)
            _1628 <= _1626;
        else
            _1628 <= trap_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _3519 <= _3517;
        else
            _3519 <= _1628;
    end
    assign _3047 = _2908 & _2876;
    assign _3046 = _2908 & _2877;
    assign _3045 = _2908 & _2880;
    assign _3044 = _2908 & _2881;
    assign _3043 = _2908 & _2882;
    assign _3042 = _2908 & _2883;
    assign _3041 = _2910 & _2876;
    assign _3040 = _2910 & _2877;
    assign _3039 = _2910 & _2878;
    assign _3038 = _2910 & _2880;
    assign _3037 = _2910 & _2881;
    assign _3036 = _2912 & _2876;
    assign _3035 = _2912 & _2877;
    assign _3034 = _2912 & _2878;
    assign _3033 = _2914 & _2876;
    assign _3032 = _2914 & _2878;
    assign _3031 = _2914 & _2879;
    assign _3030 = _2914 & _2880;
    assign _3029 = _2914 & _2882;
    assign _3028 = _2914 & _2883;
    assign _3026 = _2914 & _2877;
    assign _3027 = _3026 & _2887;
    assign _3024 = _2914 & _2881;
    assign _3025 = _3024 & _2887;
    assign _3022 = _2914 & _2881;
    assign _3023 = _3022 & _2885;
    assign _3020 = _2916 & _2876;
    assign _3021 = _3020 & _2887;
    assign _3018 = _2916 & _2876;
    assign _3019 = _3018 & _2885;
    assign _3016 = _2916 & _2877;
    assign _3017 = _3016 & _2887;
    assign _3014 = _2916 & _2878;
    assign _3015 = _3014 & _2887;
    assign _3012 = _2916 & _2879;
    assign _3013 = _3012 & _2887;
    assign _2880 = _2875[4:4];
    assign _3010 = _2916 & _2880;
    assign _3011 = _3010 & _2887;
    assign _3008 = _2916 & _2881;
    assign _3009 = _3008 & _2887;
    assign _3006 = _2916 & _2881;
    assign _3007 = _3006 & _2885;
    assign _3004 = _2916 & _2882;
    assign _3005 = _3004 & _2887;
    assign _3002 = _2916 & _2883;
    assign _3003 = _3002 & _2887;
    assign _3000 = ~ _2943;
    assign _3001 = _2952 & _3000;
    assign _2999 = _2952 & _2943;
    assign _2997 = ~ _2943;
    assign _2998 = _2949 & _2997;
    assign _2996 = _2949 & _2943;
    assign _2994 = ~ _2943;
    assign _2995 = _2946 & _2994;
    assign _2943 = _2848[7:7];
    assign _2993 = _2946 & _2943;
    assign _2945 = _2942 == _2944;
    assign _2946 = _2945 & _2941;
    assign _2948 = _2942 == _2947;
    assign _2949 = _2948 & _2941;
    assign _2932 = _2848[6:2];
    assign _2934 = _2932 == _2933;
    assign _2935 = _2848[11:8];
    assign _2937 = _2935 == _2936;
    assign _2938 = _2937 & _2934;
    assign _2939 = _2897 & _2878;
    assign _2940 = _2939 & _2920;
    assign _2941 = _2940 & _2938;
    assign _2942 = _2848[1:0];
    assign _2951 = _2942 == _2950;
    assign _2952 = _2951 & _2941;
    assign _2924 = _2848 == _2923;
    assign _2930 = _2924 & _2929;
    assign _2920 = _2845 == _2919;
    assign _2889 = mio_rdata[11:7];
    assign _2893 = _2889 == _2892;
    assign _2891 = mio_rdata[19:15];
    assign _2897 = _2891 == _2896;
    assign _2927 = _2897 & _2876;
    assign _2928 = _2927 & _2893;
    assign _2929 = _2928 & _2920;
    assign _2848 = mio_rdata[31:20];
    assign _2926 = _2848 == _2925;
    assign _2931 = _2926 & _2929;
    assign _2921 = _2918 & _2877;
    assign _2918 = _2845 == _2917;
    assign _2922 = _2918 & _2876;
    assign _2964 = ~ _2963;
    assign _2965 = _2964 & _2887;
    assign _2963 = _2876 | _2881;
    assign _2966 = _2963 & _2888;
    assign _2967 = _2966 | _2965;
    assign _2916 = _2845 == _2915;
    assign _2968 = _2916 & _2967;
    assign _2885 = _2847 == _2884;
    assign _2888 = _2887 | _2885;
    assign _2969 = _2881 & _2888;
    assign _2847 = mio_rdata[31:25];
    assign _2887 = _2847 == _2886;
    assign _2970 = _2877 & _2887;
    assign _2971 = _2970 | _2969;
    assign _2972 = _2914 & _2971;
    assign _2881 = _2875[5:5];
    assign _2973 = _2877 | _2881;
    assign _2974 = ~ _2973;
    assign _2975 = _2914 & _2974;
    assign _2877 = _2875[1:1];
    assign _2960 = _2876 | _2877;
    assign _2961 = _2960 | _2878;
    assign _2962 = _2912 & _2961;
    assign _2883 = _2875[7:7];
    assign _2882 = _2875[6:6];
    assign _2956 = _2879 | _2882;
    assign _2957 = _2956 | _2883;
    assign _2958 = ~ _2957;
    assign _2959 = _2910 & _2958;
    assign _2879 = _2875[3:3];
    assign _2878 = _2875[2:2];
    assign _2953 = _2878 | _2879;
    assign _2954 = ~ _2953;
    assign _2955 = _2908 & _2954;
    assign _2976 = _2899 | _2901;
    assign _2977 = _2976 | _2903;
    assign _2978 = _2977 | _2906;
    assign _2979 = _2978 | _2955;
    assign _2980 = _2979 | _2959;
    assign _2981 = _2980 | _2962;
    assign _2982 = _2981 | _2975;
    assign _2983 = _2982 | _2972;
    assign _2984 = _2983 | _2968;
    assign _2985 = _2984 | _2922;
    assign _2986 = _2985 | _2921;
    assign _2987 = _2986 | _2931;
    assign _2988 = _2987 | _2930;
    assign _2989 = _2988 | _2952;
    assign _2990 = _2989 | _2949;
    assign _2991 = _2990 | _2946;
    assign _2992 = ~ _2991;
    assign _3048 = { _2992, _2993, _2995, _2996, _2998, _2999, _3001, _2930, _2931, _2921, _2922, _3003, _3005, _3007, _3009, _3011, _3013, _3015, _3017, _3019, _3021, _3023, _3025, _3027, _3028, _3029, _3030, _3031, _3032, _3033, _3034, _3035, _3036, _3037, _3038, _3039, _3040, _3041, _3042, _3043, _3044, _3045, _3046, _3047, _2906, _2903, _2901, _2899 };
    always @(posedge clk) begin
        if (clr)
            _3515 <= _3513;
        else
            _3515 <= _3048;
    end
    always @(posedge clk) begin
        if (clr)
            _3511 <= _3509;
        else
            _3511 <= mio_rdata;
    end
    always @(posedge clk) begin
        if (clr)
            _1640 <= _1638;
        else
            _1640 <= next_pc_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _3507 <= _3505;
        else
            _3507 <= _1640;
    end
    always @(posedge clk) begin
        if (clr)
            _1644 <= _1642;
        else
            _1644 <= pc_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _3503 <= _3501;
        else
            _3503 <= _1644;
    end
    always @(posedge clk) begin
        if (clr)
            _1648 <= _1646;
        else
            _1648 <= imm_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _3499 <= _3497;
        else
            _3499 <= _1648;
    end
    always @(posedge clk) begin
        if (clr)
            _3495 <= _3493;
        else
            _3495 <= _3443;
    end
    always @(posedge clk) begin
        if (clr)
            _1656 <= _1654;
        else
            _1656 <= rdd_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _3491 <= _3489;
        else
            _3491 <= _1656;
    end
    assign _3064 = _3059[0:0];
    assign _3061 = _3059[19:10];
    assign _3062 = _3059[9:9];
    assign _3063 = _3059[8:1];
    assign _3054 = { _3053, _3052 };
    assign _3050 = mio_rdata[31:12];
    assign _3051 = { _3050, gnd };
    assign _3052 = _3051[20:20];
    assign _3053 = { _3052, _3052 };
    assign _3055 = { _3053, _3053 };
    assign _3056 = { _3055, _3055 };
    assign _3057 = { _3056, _3054 };
    assign _3059 = { _3057, _3051 };
    assign _3060 = _3059[31:20];
    assign _3065 = { _3060, _3063, _3062, _3061, _3064 };
    assign _3104 = mio_rdata[31:12];
    assign _3105 = { _3104, _3103 };
    assign _3092 = mio_rdata[31:20];
    assign _3093 = _3092[11:11];
    assign _3094 = { _3093, _3093 };
    assign _3095 = { _3094, _3094 };
    assign _3096 = { _3095, _3095 };
    assign _3097 = { _3096, _3096 };
    assign _3098 = { _3097, _3095 };
    assign _3100 = { _3098, _3092 };
    assign _3085 = { _3084, _3083 };
    assign _3081 = mio_rdata[11:8];
    assign _3080 = mio_rdata[30:25];
    assign _3079 = mio_rdata[7:7];
    assign _3078 = mio_rdata[31:31];
    assign _3082 = { _3078, _3079, _3080, _3081, gnd };
    assign _3083 = _3082[12:12];
    assign _3084 = { _3083, _3083 };
    assign _3086 = { _3084, _3084 };
    assign _3087 = { _3086, _3086 };
    assign _3088 = { _3087, _3087 };
    assign _3089 = { _3088, _3085 };
    assign _3091 = { _3089, _3082 };
    assign _3068 = mio_rdata[11:7];
    assign _3067 = mio_rdata[31:25];
    assign _3069 = { _3067, _3068 };
    assign _3070 = _3069[11:11];
    assign _3071 = { _3070, _3070 };
    assign _3072 = { _3071, _3071 };
    assign _3073 = { _3072, _3072 };
    assign _3074 = { _3073, _3073 };
    assign _3075 = { _3074, _3072 };
    assign _3077 = { _3075, _3069 };
    assign _3107 = _2912 ? _3077 : _3066;
    assign _2908 = _2845 == _2907;
    assign _3108 = _2908 ? _3091 : _3107;
    assign _2852 = ~ _2849;
    assign _2855 = _2853 & _2852;
    assign _2863 = _2859 & _2855;
    assign _2853 = ~ _2850;
    assign _2854 = _2853 & _2849;
    assign _2862 = _2859 & _2854;
    assign _2856 = ~ _2849;
    assign _2858 = _2850 & _2856;
    assign _2861 = _2859 & _2858;
    assign _2857 = _2850 & _2849;
    assign _2859 = ~ _2851;
    assign _2860 = _2859 & _2857;
    assign _2864 = ~ _2849;
    assign _2867 = _2865 & _2864;
    assign _2874 = _2851 & _2867;
    assign _2865 = ~ _2850;
    assign _2866 = _2865 & _2849;
    assign _2873 = _2851 & _2866;
    assign _2868 = ~ _2849;
    assign _2870 = _2850 & _2868;
    assign _2872 = _2851 & _2870;
    assign _2849 = _2846[0:0];
    assign _2850 = _2846[1:1];
    assign _2869 = _2850 & _2849;
    assign _2846 = mio_rdata[14:12];
    assign _2851 = _2846[2:2];
    assign _2871 = _2851 & _2869;
    assign _2875 = { _2871, _2872, _2873, _2874, _2860, _2861, _2862, _2863 };
    assign _2876 = _2875[0:0];
    assign _2905 = _2845 == _2904;
    assign _2906 = _2905 & _2876;
    assign _3101 = _2906 | _2910;
    assign _3102 = _3101 | _2914;
    assign _3109 = _3102 ? _3100 : _3108;
    assign _3106 = _2899 | _2901;
    assign _3110 = _3106 ? _3105 : _3109;
    assign _2903 = _2845 == _2902;
    assign _3111 = _2903 ? _3065 : _3110;
    always @* begin
        case (_3112)
        0: _3443 <= _3287;
        1: _3443 <= reg_01;
        2: _3443 <= reg_02;
        3: _3443 <= reg_03;
        4: _3443 <= reg_04;
        5: _3443 <= reg_05;
        6: _3443 <= reg_06;
        7: _3443 <= reg_07;
        8: _3443 <= reg_08;
        9: _3443 <= reg_09;
        10: _3443 <= reg_10;
        11: _3443 <= reg_11;
        12: _3443 <= reg_12;
        13: _3443 <= reg_13;
        14: _3443 <= reg_14;
        15: _3443 <= reg_15;
        16: _3443 <= reg_16;
        17: _3443 <= reg_17;
        18: _3443 <= reg_18;
        19: _3443 <= reg_19;
        20: _3443 <= reg_20;
        21: _3443 <= reg_21;
        22: _3443 <= reg_22;
        23: _3443 <= reg_23;
        24: _3443 <= reg_24;
        25: _3443 <= reg_25;
        26: _3443 <= reg_26;
        27: _3443 <= reg_27;
        28: _3443 <= reg_28;
        29: _3443 <= reg_29;
        30: _3443 <= reg_30;
        default: _3443 <= reg_31;
        endcase
    end
    assign _2912 = _2845 == _2911;
    assign _2910 = _2845 == _2909;
    assign _2901 = _2845 == _2900;
    assign _2899 = _2845 == _2898;
    assign _2845 = mio_rdata[6:0];
    assign _2914 = _2845 == _2913;
    assign _3445 = _2914 | _2899;
    assign _3446 = _3445 | _2901;
    assign _3447 = _3446 | _2910;
    assign _3448 = _3447 | _2912;
    assign _3449 = _3448 ? _3111 : _3443;
    always @(posedge clk) begin
        if (clr)
            _3487 <= _3485;
        else
            _3487 <= _3449;
    end
    assign _3438 = _3286[31:31];
    assign _3439 = gnd & _3438;
    always @(posedge clk) begin
        if (clr)
            reg_31 <= _3440;
        else
            if (_3439)
                reg_31 <= _2168;
    end
    assign _3433 = _3286[30:30];
    assign _3434 = gnd & _3433;
    always @(posedge clk) begin
        if (clr)
            reg_30 <= _3435;
        else
            if (_3434)
                reg_30 <= _2168;
    end
    assign _3428 = _3286[29:29];
    assign _3429 = gnd & _3428;
    always @(posedge clk) begin
        if (clr)
            reg_29 <= _3430;
        else
            if (_3429)
                reg_29 <= _2168;
    end
    assign _3423 = _3286[28:28];
    assign _3424 = gnd & _3423;
    always @(posedge clk) begin
        if (clr)
            reg_28 <= _3425;
        else
            if (_3424)
                reg_28 <= _2168;
    end
    assign _3418 = _3286[27:27];
    assign _3419 = gnd & _3418;
    always @(posedge clk) begin
        if (clr)
            reg_27 <= _3420;
        else
            if (_3419)
                reg_27 <= _2168;
    end
    assign _3413 = _3286[26:26];
    assign _3414 = gnd & _3413;
    always @(posedge clk) begin
        if (clr)
            reg_26 <= _3415;
        else
            if (_3414)
                reg_26 <= _2168;
    end
    assign _3408 = _3286[25:25];
    assign _3409 = gnd & _3408;
    always @(posedge clk) begin
        if (clr)
            reg_25 <= _3410;
        else
            if (_3409)
                reg_25 <= _2168;
    end
    assign _3403 = _3286[24:24];
    assign _3404 = gnd & _3403;
    always @(posedge clk) begin
        if (clr)
            reg_24 <= _3405;
        else
            if (_3404)
                reg_24 <= _2168;
    end
    assign _3398 = _3286[23:23];
    assign _3399 = gnd & _3398;
    always @(posedge clk) begin
        if (clr)
            reg_23 <= _3400;
        else
            if (_3399)
                reg_23 <= _2168;
    end
    assign _3393 = _3286[22:22];
    assign _3394 = gnd & _3393;
    always @(posedge clk) begin
        if (clr)
            reg_22 <= _3395;
        else
            if (_3394)
                reg_22 <= _2168;
    end
    assign _3388 = _3286[21:21];
    assign _3389 = gnd & _3388;
    always @(posedge clk) begin
        if (clr)
            reg_21 <= _3390;
        else
            if (_3389)
                reg_21 <= _2168;
    end
    assign _3383 = _3286[20:20];
    assign _3384 = gnd & _3383;
    always @(posedge clk) begin
        if (clr)
            reg_20 <= _3385;
        else
            if (_3384)
                reg_20 <= _2168;
    end
    assign _3378 = _3286[19:19];
    assign _3379 = gnd & _3378;
    always @(posedge clk) begin
        if (clr)
            reg_19 <= _3380;
        else
            if (_3379)
                reg_19 <= _2168;
    end
    assign _3373 = _3286[18:18];
    assign _3374 = gnd & _3373;
    always @(posedge clk) begin
        if (clr)
            reg_18 <= _3375;
        else
            if (_3374)
                reg_18 <= _2168;
    end
    assign _3368 = _3286[17:17];
    assign _3369 = gnd & _3368;
    always @(posedge clk) begin
        if (clr)
            reg_17 <= _3370;
        else
            if (_3369)
                reg_17 <= _2168;
    end
    assign _3363 = _3286[16:16];
    assign _3364 = gnd & _3363;
    always @(posedge clk) begin
        if (clr)
            reg_16 <= _3365;
        else
            if (_3364)
                reg_16 <= _2168;
    end
    assign _3358 = _3286[15:15];
    assign _3359 = gnd & _3358;
    always @(posedge clk) begin
        if (clr)
            reg_15 <= _3360;
        else
            if (_3359)
                reg_15 <= _2168;
    end
    assign _3353 = _3286[14:14];
    assign _3354 = gnd & _3353;
    always @(posedge clk) begin
        if (clr)
            reg_14 <= _3355;
        else
            if (_3354)
                reg_14 <= _2168;
    end
    assign _3348 = _3286[13:13];
    assign _3349 = gnd & _3348;
    always @(posedge clk) begin
        if (clr)
            reg_13 <= _3350;
        else
            if (_3349)
                reg_13 <= _2168;
    end
    assign _3343 = _3286[12:12];
    assign _3344 = gnd & _3343;
    always @(posedge clk) begin
        if (clr)
            reg_12 <= _3345;
        else
            if (_3344)
                reg_12 <= _2168;
    end
    assign _3338 = _3286[11:11];
    assign _3339 = gnd & _3338;
    always @(posedge clk) begin
        if (clr)
            reg_11 <= _3340;
        else
            if (_3339)
                reg_11 <= _2168;
    end
    assign _3333 = _3286[10:10];
    assign _3334 = gnd & _3333;
    always @(posedge clk) begin
        if (clr)
            reg_10 <= _3335;
        else
            if (_3334)
                reg_10 <= _2168;
    end
    assign _3328 = _3286[9:9];
    assign _3329 = gnd & _3328;
    always @(posedge clk) begin
        if (clr)
            reg_09 <= _3330;
        else
            if (_3329)
                reg_09 <= _2168;
    end
    assign _3323 = _3286[8:8];
    assign _3324 = gnd & _3323;
    always @(posedge clk) begin
        if (clr)
            reg_08 <= _3325;
        else
            if (_3324)
                reg_08 <= _2168;
    end
    assign _3318 = _3286[7:7];
    assign _3319 = gnd & _3318;
    always @(posedge clk) begin
        if (clr)
            reg_07 <= _3320;
        else
            if (_3319)
                reg_07 <= _2168;
    end
    assign _3313 = _3286[6:6];
    assign _3314 = gnd & _3313;
    always @(posedge clk) begin
        if (clr)
            reg_06 <= _3315;
        else
            if (_3314)
                reg_06 <= _2168;
    end
    assign _3308 = _3286[5:5];
    assign _3309 = gnd & _3308;
    always @(posedge clk) begin
        if (clr)
            reg_05 <= _3310;
        else
            if (_3309)
                reg_05 <= _2168;
    end
    assign _3303 = _3286[4:4];
    assign _3304 = gnd & _3303;
    always @(posedge clk) begin
        if (clr)
            reg_04 <= _3305;
        else
            if (_3304)
                reg_04 <= _2168;
    end
    assign _3298 = _3286[3:3];
    assign _3299 = gnd & _3298;
    always @(posedge clk) begin
        if (clr)
            reg_03 <= _3300;
        else
            if (_3299)
                reg_03 <= _2168;
    end
    assign _3293 = _3286[2:2];
    assign _3294 = gnd & _3293;
    always @(posedge clk) begin
        if (clr)
            reg_02 <= _3295;
        else
            if (_3294)
                reg_02 <= _2168;
    end
    assign _3127 = ~ _3122;
    assign _3130 = _3128 & _3127;
    assign _3138 = _3134 & _3130;
    assign _3158 = _3150 & _3138;
    assign _3206 = _3190 & _3158;
    assign _3128 = ~ _3123;
    assign _3129 = _3128 & _3122;
    assign _3137 = _3134 & _3129;
    assign _3157 = _3150 & _3137;
    assign _3205 = _3190 & _3157;
    assign _3131 = ~ _3122;
    assign _3133 = _3123 & _3131;
    assign _3136 = _3134 & _3133;
    assign _3156 = _3150 & _3136;
    assign _3204 = _3190 & _3156;
    assign _3132 = _3123 & _3122;
    assign _3134 = ~ _3124;
    assign _3135 = _3134 & _3132;
    assign _3155 = _3150 & _3135;
    assign _3203 = _3190 & _3155;
    assign _3139 = ~ _3122;
    assign _3142 = _3140 & _3139;
    assign _3149 = _3124 & _3142;
    assign _3154 = _3150 & _3149;
    assign _3202 = _3190 & _3154;
    assign _3140 = ~ _3123;
    assign _3141 = _3140 & _3122;
    assign _3148 = _3124 & _3141;
    assign _3153 = _3150 & _3148;
    assign _3201 = _3190 & _3153;
    assign _3143 = ~ _3122;
    assign _3145 = _3123 & _3143;
    assign _3147 = _3124 & _3145;
    assign _3152 = _3150 & _3147;
    assign _3200 = _3190 & _3152;
    assign _3144 = _3123 & _3122;
    assign _3146 = _3124 & _3144;
    assign _3150 = ~ _3125;
    assign _3151 = _3150 & _3146;
    assign _3199 = _3190 & _3151;
    assign _3159 = ~ _3122;
    assign _3162 = _3160 & _3159;
    assign _3170 = _3166 & _3162;
    assign _3189 = _3125 & _3170;
    assign _3198 = _3190 & _3189;
    assign _3160 = ~ _3123;
    assign _3161 = _3160 & _3122;
    assign _3169 = _3166 & _3161;
    assign _3188 = _3125 & _3169;
    assign _3197 = _3190 & _3188;
    assign _3163 = ~ _3122;
    assign _3165 = _3123 & _3163;
    assign _3168 = _3166 & _3165;
    assign _3187 = _3125 & _3168;
    assign _3196 = _3190 & _3187;
    assign _3164 = _3123 & _3122;
    assign _3166 = ~ _3124;
    assign _3167 = _3166 & _3164;
    assign _3186 = _3125 & _3167;
    assign _3195 = _3190 & _3186;
    assign _3171 = ~ _3122;
    assign _3174 = _3172 & _3171;
    assign _3181 = _3124 & _3174;
    assign _3185 = _3125 & _3181;
    assign _3194 = _3190 & _3185;
    assign _3172 = ~ _3123;
    assign _3173 = _3172 & _3122;
    assign _3180 = _3124 & _3173;
    assign _3184 = _3125 & _3180;
    assign _3193 = _3190 & _3184;
    assign _3175 = ~ _3122;
    assign _3177 = _3123 & _3175;
    assign _3179 = _3124 & _3177;
    assign _3183 = _3125 & _3179;
    assign _3192 = _3190 & _3183;
    assign _3176 = _3123 & _3122;
    assign _3178 = _3124 & _3176;
    assign _3182 = _3125 & _3178;
    assign _3190 = ~ _3126;
    assign _3191 = _3190 & _3182;
    assign _3207 = ~ _3122;
    assign _3210 = _3208 & _3207;
    assign _3218 = _3214 & _3210;
    assign _3238 = _3230 & _3218;
    assign _3285 = _3126 & _3238;
    assign _3208 = ~ _3123;
    assign _3209 = _3208 & _3122;
    assign _3217 = _3214 & _3209;
    assign _3237 = _3230 & _3217;
    assign _3284 = _3126 & _3237;
    assign _3211 = ~ _3122;
    assign _3213 = _3123 & _3211;
    assign _3216 = _3214 & _3213;
    assign _3236 = _3230 & _3216;
    assign _3283 = _3126 & _3236;
    assign _3212 = _3123 & _3122;
    assign _3214 = ~ _3124;
    assign _3215 = _3214 & _3212;
    assign _3235 = _3230 & _3215;
    assign _3282 = _3126 & _3235;
    assign _3219 = ~ _3122;
    assign _3222 = _3220 & _3219;
    assign _3229 = _3124 & _3222;
    assign _3234 = _3230 & _3229;
    assign _3281 = _3126 & _3234;
    assign _3220 = ~ _3123;
    assign _3221 = _3220 & _3122;
    assign _3228 = _3124 & _3221;
    assign _3233 = _3230 & _3228;
    assign _3280 = _3126 & _3233;
    assign _3223 = ~ _3122;
    assign _3225 = _3123 & _3223;
    assign _3227 = _3124 & _3225;
    assign _3232 = _3230 & _3227;
    assign _3279 = _3126 & _3232;
    assign _3224 = _3123 & _3122;
    assign _3226 = _3124 & _3224;
    assign _3230 = ~ _3125;
    assign _3231 = _3230 & _3226;
    assign _3278 = _3126 & _3231;
    assign _3239 = ~ _3122;
    assign _3242 = _3240 & _3239;
    assign _3250 = _3246 & _3242;
    assign _3269 = _3125 & _3250;
    assign _3277 = _3126 & _3269;
    assign _3240 = ~ _3123;
    assign _3241 = _3240 & _3122;
    assign _3249 = _3246 & _3241;
    assign _3268 = _3125 & _3249;
    assign _3276 = _3126 & _3268;
    assign _3243 = ~ _3122;
    assign _3245 = _3123 & _3243;
    assign _3248 = _3246 & _3245;
    assign _3267 = _3125 & _3248;
    assign _3275 = _3126 & _3267;
    assign _3244 = _3123 & _3122;
    assign _3246 = ~ _3124;
    assign _3247 = _3246 & _3244;
    assign _3266 = _3125 & _3247;
    assign _3274 = _3126 & _3266;
    assign _3251 = ~ _3122;
    assign _3254 = _3252 & _3251;
    assign _3261 = _3124 & _3254;
    assign _3265 = _3125 & _3261;
    assign _3273 = _3126 & _3265;
    assign _3252 = ~ _3123;
    assign _3253 = _3252 & _3122;
    assign _3260 = _3124 & _3253;
    assign _3264 = _3125 & _3260;
    assign _3272 = _3126 & _3264;
    assign _3255 = ~ _3122;
    assign _3257 = _3123 & _3255;
    assign _3259 = _3124 & _3257;
    assign _3263 = _3125 & _3259;
    assign _3271 = _3126 & _3263;
    assign _3122 = _3121[0:0];
    assign _3123 = _3121[1:1];
    assign _3256 = _3123 & _3122;
    assign _3124 = _3121[2:2];
    assign _3258 = _3124 & _3256;
    assign _3125 = _3121[3:3];
    assign _3262 = _3125 & _3258;
    assign _3126 = _3121[4:4];
    assign _3270 = _3126 & _3262;
    assign _3286 = { _3270, _3271, _3272, _3273, _3274, _3275, _3276, _3277, _3278, _3279, _3280, _3281, _3282, _3283, _3284, _3285, _3191, _3192, _3193, _3194, _3195, _3196, _3197, _3198, _3199, _3200, _3201, _3202, _3203, _3204, _3205, _3206 };
    assign _3288 = _3286[1:1];
    assign _3289 = gnd & _3288;
    always @(posedge clk) begin
        if (clr)
            _2168 <= _2166;
        else
            _2168 <= rdd_p_4;
    end
    always @(posedge clk) begin
        if (clr)
            reg_01 <= _3290;
        else
            if (_3289)
                reg_01 <= _2168;
    end
    always @* begin
        case (_3113)
        0: _3444 <= _3287;
        1: _3444 <= reg_01;
        2: _3444 <= reg_02;
        3: _3444 <= reg_03;
        4: _3444 <= reg_04;
        5: _3444 <= reg_05;
        6: _3444 <= reg_06;
        7: _3444 <= reg_07;
        8: _3444 <= reg_08;
        9: _3444 <= reg_09;
        10: _3444 <= reg_10;
        11: _3444 <= reg_11;
        12: _3444 <= reg_12;
        13: _3444 <= reg_13;
        14: _3444 <= reg_14;
        15: _3444 <= reg_15;
        16: _3444 <= reg_16;
        17: _3444 <= reg_17;
        18: _3444 <= reg_18;
        19: _3444 <= reg_19;
        20: _3444 <= reg_20;
        21: _3444 <= reg_21;
        22: _3444 <= reg_22;
        23: _3444 <= reg_23;
        24: _3444 <= reg_24;
        25: _3444 <= reg_25;
        26: _3444 <= reg_26;
        27: _3444 <= reg_27;
        28: _3444 <= reg_28;
        29: _3444 <= reg_29;
        30: _3444 <= reg_30;
        default: _3444 <= reg_31;
        endcase
    end
    always @(posedge clk) begin
        if (clr)
            _3483 <= _3481;
        else
            _3483 <= _3444;
    end
    assign _3120 = _3114 == _3119;
    always @(posedge clk) begin
        if (clr)
            _3479 <= _3477;
        else
            _3479 <= _3120;
    end
    assign _3116 = _3112 == _3115;
    always @(posedge clk) begin
        if (clr)
            _3475 <= _3473;
        else
            _3475 <= _3116;
    end
    assign _3118 = _3113 == _3117;
    always @(posedge clk) begin
        if (clr)
            _3471 <= _3469;
        else
            _3471 <= _3118;
    end
    assign _3114 = mio_rdata[11:7];
    always @(posedge clk) begin
        if (clr)
            _3467 <= _3465;
        else
            _3467 <= _3114;
    end
    assign _3112 = mio_rdata[24:20];
    always @(posedge clk) begin
        if (clr)
            _3463 <= _3461;
        else
            _3463 <= _3112;
    end
    assign _3113 = mio_rdata[19:15];
    always @(posedge clk) begin
        if (clr)
            _3459 <= _3457;
        else
            _3459 <= _3113;
    end
    always @(posedge clk) begin
        if (clr)
            _1692 <= _1690;
        else
            _1692 <= pen_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _3452 <= _3450;
        else
            _3452 <= _1692;
    end
    always @(posedge clk) begin
        if (clr)
            _3455 <= _3453;
        else
            _3455 <= _3452;
    end

    /* aliases */

    /* output assignments */
    assign pen = _3455;
    assign ra1 = _3459;
    assign ra2 = _3463;
    assign rad = _3467;
    assign ra1_zero = _3471;
    assign ra2_zero = _3475;
    assign rad_zero = _3479;
    assign rd1 = _3483;
    assign rd2 = _3487;
    assign rdd = _3491;
    assign rdm = _3495;
    assign imm = _3499;
    assign pc = _3503;
    assign next_pc = _3507;
    assign instr = _3511;
    assign insn = _3515;
    assign trap = _3519;
    assign lui = _3523;
    assign auipc = _3527;
    assign jal = _3531;
    assign jalr = _3535;
    assign bra = _3539;
    assign ld = _3543;
    assign st = _3547;
    assign opi = _3551;
    assign opr = _3555;
    assign fen = _3559;
    assign sys = _3563;
    assign f3 = _3567;
    assign f7 = _3571;
    assign cond_branch = _3575;
    assign junk = _3579;

endmodule
