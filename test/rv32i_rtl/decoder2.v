module decoder2 (
    junk_p_0,
    alu_cmp_p_0,
    alu_p_0,
    fclass_p_0,
    is_p_0,
    next_pc_p_0,
    pc_p_0,
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
    imm,
    pc,
    next_pc,
    instr,
    insn,
    is,
    fclass,
    alu,
    alu_cmp,
    junk
);

    input junk_p_0;
    input alu_cmp_p_0;
    input [31:0] alu_p_0;
    input [5:0] fclass_p_0;
    input [14:0] is_p_0;
    input [31:0] next_pc_p_0;
    input [31:0] pc_p_0;
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
    output [31:0] imm;
    output [31:0] pc;
    output [31:0] next_pc;
    output [31:0] instr;
    output [47:0] insn;
    output [14:0] is;
    output [5:0] fclass;
    output [31:0] alu;
    output alu_cmp;
    output junk;

    /* signal declarations */
    wire _4234 = 1'b0;
    wire _4235 = 1'b0;
    wire _2757 = 1'b0;
    wire _2758 = 1'b0;
    reg _2759;
    reg _4236;
    wire _4230 = 1'b0;
    wire _4231 = 1'b0;
    wire _2761 = 1'b0;
    wire _2762 = 1'b0;
    reg _2763;
    reg _4232;
    wire [31:0] _4226 = 32'b00000000000000000000000000000000;
    wire [31:0] _4227 = 32'b00000000000000000000000000000000;
    wire [31:0] _2765 = 32'b00000000000000000000000000000000;
    wire [31:0] _2766 = 32'b00000000000000000000000000000000;
    reg [31:0] _2767;
    reg [31:0] _4228;
    wire [5:0] _4222 = 6'b000000;
    wire [5:0] _4223 = 6'b000000;
    wire [5:0] _2769 = 6'b000000;
    wire [5:0] _2770 = 6'b000000;
    reg [5:0] _2771;
    reg [5:0] _4224;
    wire [14:0] _4218 = 15'b000000000000000;
    wire [14:0] _4219 = 15'b000000000000000;
    wire [14:0] _2773 = 15'b000000000000000;
    wire [14:0] _2774 = 15'b000000000000000;
    reg [14:0] _2775;
    reg [14:0] _4220;
    wire [47:0] _4214 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _4215 = 48'b000000000000000000000000000000000000000000000000;
    wire _3758;
    wire _3757;
    wire _3756;
    wire _3755;
    wire _3754;
    wire _3753;
    wire _3752;
    wire _3751;
    wire _3750;
    wire _3749;
    wire _3748;
    wire _3747;
    wire _3746;
    wire _3745;
    wire _3744;
    wire _3743;
    wire _3742;
    wire _3741;
    wire _3740;
    wire _3739;
    wire _3737;
    wire _3738;
    wire _3735;
    wire _3736;
    wire _3733;
    wire _3734;
    wire _3731;
    wire _3732;
    wire _3729;
    wire _3730;
    wire _3727;
    wire _3728;
    wire _3725;
    wire _3726;
    wire _3723;
    wire _3724;
    wire _3591;
    wire _3721;
    wire _3722;
    wire _3719;
    wire _3720;
    wire _3717;
    wire _3718;
    wire _3715;
    wire _3716;
    wire _3713;
    wire _3714;
    wire _3711;
    wire _3712;
    wire _3710;
    wire _3708;
    wire _3709;
    wire _3707;
    wire _3705;
    wire _3706;
    wire _3654;
    wire _3704;
    wire [1:0] _3655 = 2'b10;
    wire _3656;
    wire _3657;
    wire [1:0] _3658 = 2'b01;
    wire _3659;
    wire _3660;
    wire [4:0] _3644 = 5'b00000;
    wire [4:0] _3643;
    wire _3645;
    wire [3:0] _3647 = 4'b1100;
    wire [3:0] _3646;
    wire _3648;
    wire _3649;
    wire _3650;
    wire _3651;
    wire _3652;
    wire [1:0] _3661 = 2'b00;
    wire [1:0] _3653;
    wire _3662;
    wire _3663;
    wire [11:0] _3634 = 12'b000000000001;
    wire _3635;
    wire _3641;
    wire [6:0] _3630 = 7'b1110011;
    wire _3631;
    wire [4:0] _3603 = 5'b00000;
    wire [4:0] _3600;
    wire _3604;
    wire [4:0] _3607 = 5'b00000;
    wire [4:0] _3602;
    wire _3608;
    wire _3638;
    wire _3639;
    wire _3640;
    wire [11:0] _3636 = 12'b000000000000;
    wire [11:0] _3559;
    wire _3637;
    wire _3642;
    wire _3632;
    wire [6:0] _3628 = 7'b0001111;
    wire _3629;
    wire _3633;
    wire _3675;
    wire _3676;
    wire _3674;
    wire _3677;
    wire _3678;
    wire [6:0] _3626 = 7'b0110011;
    wire _3627;
    wire _3679;
    wire [6:0] _3595 = 7'b0100000;
    wire _3596;
    wire _3599;
    wire _3680;
    wire [6:0] _3597 = 7'b0000000;
    wire [6:0] _3558;
    wire _3598;
    wire _3681;
    wire _3682;
    wire _3683;
    wire _3592;
    wire _3684;
    wire _3685;
    wire _3686;
    wire _3588;
    wire _3671;
    wire _3672;
    wire _3673;
    wire _3594;
    wire _3593;
    wire _3667;
    wire _3668;
    wire _3669;
    wire _3670;
    wire _3590;
    wire _3589;
    wire _3664;
    wire _3665;
    wire _3666;
    wire _3687;
    wire _3688;
    wire _3689;
    wire _3690;
    wire _3691;
    wire _3692;
    wire _3693;
    wire _3694;
    wire _3695;
    wire _3696;
    wire _3697;
    wire _3698;
    wire _3699;
    wire _3700;
    wire _3701;
    wire _3702;
    wire _3703;
    wire [47:0] _3759;
    reg [47:0] _4216;
    wire [31:0] _4210 = 32'b00000000000000000000000000000000;
    wire [31:0] _4211 = 32'b00000000000000000000000000000000;
    reg [31:0] _4212;
    wire [31:0] _4206 = 32'b00000000000000000000000000000000;
    wire [31:0] _4207 = 32'b00000000000000000000000000000000;
    wire [31:0] _2785 = 32'b00000000000000000000000000000000;
    wire [31:0] _2786 = 32'b00000000000000000000000000000000;
    reg [31:0] _2787;
    reg [31:0] _4208;
    wire [31:0] _4202 = 32'b00000000000000000000000000000000;
    wire [31:0] _4203 = 32'b00000000000000000000000000000000;
    wire [31:0] _2789 = 32'b00000000000000000000000000000000;
    wire [31:0] _2790 = 32'b00000000000000000000000000000000;
    reg [31:0] _2791;
    reg [31:0] _4204;
    wire [31:0] _4198 = 32'b00000000000000000000000000000000;
    wire [31:0] _4199 = 32'b00000000000000000000000000000000;
    wire _3774;
    wire [9:0] _3771;
    wire _3772;
    wire [7:0] _3773;
    wire [2:0] _3764;
    wire [19:0] _3760;
    wire [20:0] _3761;
    wire _3762;
    wire [1:0] _3763;
    wire [3:0] _3765;
    wire [7:0] _3766;
    wire [10:0] _3767;
    wire [31:0] _3769;
    wire [11:0] _3770;
    wire [31:0] _3775;
    wire [11:0] _3813 = 12'b000000000000;
    wire [19:0] _3814;
    wire [31:0] _3815;
    wire [11:0] _3802;
    wire _3803;
    wire [1:0] _3804;
    wire [3:0] _3805;
    wire [7:0] _3806;
    wire [15:0] _3807;
    wire [19:0] _3808;
    wire [31:0] _3810;
    wire [2:0] _3795;
    wire [3:0] _3791;
    wire [5:0] _3790;
    wire _3789;
    wire _3788;
    wire [12:0] _3792;
    wire _3793;
    wire [1:0] _3794;
    wire [3:0] _3796;
    wire [7:0] _3797;
    wire [15:0] _3798;
    wire [18:0] _3799;
    wire [31:0] _3801;
    wire [4:0] _3778;
    wire [6:0] _3777;
    wire [11:0] _3779;
    wire _3780;
    wire [1:0] _3781;
    wire [3:0] _3782;
    wire [7:0] _3783;
    wire [15:0] _3784;
    wire [19:0] _3785;
    wire [31:0] _3787;
    wire [31:0] _3776 = 32'b00000000000000000000000000000000;
    wire [6:0] _3622 = 7'b0100011;
    wire _3623;
    wire [31:0] _3817;
    wire [6:0] _3618 = 7'b1100011;
    wire _3619;
    wire [31:0] _3818;
    wire [6:0] _3624 = 7'b0010011;
    wire _3625;
    wire [6:0] _3620 = 7'b0000011;
    wire _3621;
    wire _3563;
    wire _3566;
    wire _3574;
    wire _3564;
    wire _3565;
    wire _3573;
    wire _3567;
    wire _3569;
    wire _3572;
    wire _3568;
    wire _3570;
    wire _3571;
    wire _3575;
    wire _3578;
    wire _3585;
    wire _3576;
    wire _3577;
    wire _3584;
    wire _3579;
    wire _3581;
    wire _3583;
    wire _3560;
    wire _3561;
    wire _3580;
    wire [2:0] _3557;
    wire _3562;
    wire _3582;
    wire [7:0] _3586;
    wire _3587;
    wire [6:0] _3615 = 7'b1100111;
    wire _3616;
    wire _3617;
    wire _3811;
    wire _3812;
    wire [31:0] _3819;
    wire [6:0] _3611 = 7'b0010111;
    wire _3612;
    wire [6:0] _3609 = 7'b0110111;
    wire _3610;
    wire _3816;
    wire [31:0] _3820;
    wire [6:0] _3613 = 7'b1101111;
    wire [6:0] _3556;
    wire _3614;
    wire [31:0] _3821;
    reg [31:0] _4200;
    wire [31:0] _4194 = 32'b00000000000000000000000000000000;
    wire [31:0] _4195 = 32'b00000000000000000000000000000000;
    wire [31:0] _2797 = 32'b00000000000000000000000000000000;
    wire [31:0] _2798 = 32'b00000000000000000000000000000000;
    reg [31:0] _2799;
    reg [31:0] _4196;
    wire [31:0] _4190 = 32'b00000000000000000000000000000000;
    wire [31:0] _4191 = 32'b00000000000000000000000000000000;
    reg [31:0] _4153;
    reg [31:0] _4192;
    wire [31:0] _4186 = 32'b00000000000000000000000000000000;
    wire [31:0] _4187 = 32'b00000000000000000000000000000000;
    wire _4148;
    wire _4149;
    wire [31:0] _4150 = 32'b00000000000000000000000000000000;
    wire [31:0] _4151 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_31;
    wire _4143;
    wire _4144;
    wire [31:0] _4145 = 32'b00000000000000000000000000000000;
    wire [31:0] _4146 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_30;
    wire _4138;
    wire _4139;
    wire [31:0] _4140 = 32'b00000000000000000000000000000000;
    wire [31:0] _4141 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_29;
    wire _4133;
    wire _4134;
    wire [31:0] _4135 = 32'b00000000000000000000000000000000;
    wire [31:0] _4136 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_28;
    wire _4128;
    wire _4129;
    wire [31:0] _4130 = 32'b00000000000000000000000000000000;
    wire [31:0] _4131 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_27;
    wire _4123;
    wire _4124;
    wire [31:0] _4125 = 32'b00000000000000000000000000000000;
    wire [31:0] _4126 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_26;
    wire _4118;
    wire _4119;
    wire [31:0] _4120 = 32'b00000000000000000000000000000000;
    wire [31:0] _4121 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_25;
    wire _4113;
    wire _4114;
    wire [31:0] _4115 = 32'b00000000000000000000000000000000;
    wire [31:0] _4116 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_24;
    wire _4108;
    wire _4109;
    wire [31:0] _4110 = 32'b00000000000000000000000000000000;
    wire [31:0] _4111 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_23;
    wire _4103;
    wire _4104;
    wire [31:0] _4105 = 32'b00000000000000000000000000000000;
    wire [31:0] _4106 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_22;
    wire _4098;
    wire _4099;
    wire [31:0] _4100 = 32'b00000000000000000000000000000000;
    wire [31:0] _4101 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_21;
    wire _4093;
    wire _4094;
    wire [31:0] _4095 = 32'b00000000000000000000000000000000;
    wire [31:0] _4096 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_20;
    wire _4088;
    wire _4089;
    wire [31:0] _4090 = 32'b00000000000000000000000000000000;
    wire [31:0] _4091 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_19;
    wire _4083;
    wire _4084;
    wire [31:0] _4085 = 32'b00000000000000000000000000000000;
    wire [31:0] _4086 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_18;
    wire _4078;
    wire _4079;
    wire [31:0] _4080 = 32'b00000000000000000000000000000000;
    wire [31:0] _4081 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_17;
    wire _4073;
    wire _4074;
    wire [31:0] _4075 = 32'b00000000000000000000000000000000;
    wire [31:0] _4076 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_16;
    wire _4068;
    wire _4069;
    wire [31:0] _4070 = 32'b00000000000000000000000000000000;
    wire [31:0] _4071 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_15;
    wire _4063;
    wire _4064;
    wire [31:0] _4065 = 32'b00000000000000000000000000000000;
    wire [31:0] _4066 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_14;
    wire _4058;
    wire _4059;
    wire [31:0] _4060 = 32'b00000000000000000000000000000000;
    wire [31:0] _4061 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_13;
    wire _4053;
    wire _4054;
    wire [31:0] _4055 = 32'b00000000000000000000000000000000;
    wire [31:0] _4056 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_12;
    wire _4048;
    wire _4049;
    wire [31:0] _4050 = 32'b00000000000000000000000000000000;
    wire [31:0] _4051 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_11;
    wire _4043;
    wire _4044;
    wire [31:0] _4045 = 32'b00000000000000000000000000000000;
    wire [31:0] _4046 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_10;
    wire _4038;
    wire _4039;
    wire [31:0] _4040 = 32'b00000000000000000000000000000000;
    wire [31:0] _4041 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_09;
    wire _4033;
    wire _4034;
    wire [31:0] _4035 = 32'b00000000000000000000000000000000;
    wire [31:0] _4036 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_08;
    wire _4028;
    wire _4029;
    wire [31:0] _4030 = 32'b00000000000000000000000000000000;
    wire [31:0] _4031 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_07;
    wire _4023;
    wire _4024;
    wire [31:0] _4025 = 32'b00000000000000000000000000000000;
    wire [31:0] _4026 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_06;
    wire _4018;
    wire _4019;
    wire [31:0] _4020 = 32'b00000000000000000000000000000000;
    wire [31:0] _4021 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_05;
    wire _4013;
    wire _4014;
    wire [31:0] _4015 = 32'b00000000000000000000000000000000;
    wire [31:0] _4016 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_04;
    wire _4008;
    wire _4009;
    wire [31:0] _4010 = 32'b00000000000000000000000000000000;
    wire [31:0] _4011 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_03;
    wire _4003;
    wire _4004;
    wire [31:0] _4005 = 32'b00000000000000000000000000000000;
    wire [31:0] _4006 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_02;
    wire _3837;
    wire _3840;
    wire _3848;
    wire _3868;
    wire _3916;
    wire _3838;
    wire _3839;
    wire _3847;
    wire _3867;
    wire _3915;
    wire _3841;
    wire _3843;
    wire _3846;
    wire _3866;
    wire _3914;
    wire _3842;
    wire _3844;
    wire _3845;
    wire _3865;
    wire _3913;
    wire _3849;
    wire _3852;
    wire _3859;
    wire _3864;
    wire _3912;
    wire _3850;
    wire _3851;
    wire _3858;
    wire _3863;
    wire _3911;
    wire _3853;
    wire _3855;
    wire _3857;
    wire _3862;
    wire _3910;
    wire _3854;
    wire _3856;
    wire _3860;
    wire _3861;
    wire _3909;
    wire _3869;
    wire _3872;
    wire _3880;
    wire _3899;
    wire _3908;
    wire _3870;
    wire _3871;
    wire _3879;
    wire _3898;
    wire _3907;
    wire _3873;
    wire _3875;
    wire _3878;
    wire _3897;
    wire _3906;
    wire _3874;
    wire _3876;
    wire _3877;
    wire _3896;
    wire _3905;
    wire _3881;
    wire _3884;
    wire _3891;
    wire _3895;
    wire _3904;
    wire _3882;
    wire _3883;
    wire _3890;
    wire _3894;
    wire _3903;
    wire _3885;
    wire _3887;
    wire _3889;
    wire _3893;
    wire _3902;
    wire _3886;
    wire _3888;
    wire _3892;
    wire _3900;
    wire _3901;
    wire _3917;
    wire _3920;
    wire _3928;
    wire _3948;
    wire _3995;
    wire _3918;
    wire _3919;
    wire _3927;
    wire _3947;
    wire _3994;
    wire _3921;
    wire _3923;
    wire _3926;
    wire _3946;
    wire _3993;
    wire _3922;
    wire _3924;
    wire _3925;
    wire _3945;
    wire _3992;
    wire _3929;
    wire _3932;
    wire _3939;
    wire _3944;
    wire _3991;
    wire _3930;
    wire _3931;
    wire _3938;
    wire _3943;
    wire _3990;
    wire _3933;
    wire _3935;
    wire _3937;
    wire _3942;
    wire _3989;
    wire _3934;
    wire _3936;
    wire _3940;
    wire _3941;
    wire _3988;
    wire _3949;
    wire _3952;
    wire _3960;
    wire _3979;
    wire _3987;
    wire _3950;
    wire _3951;
    wire _3959;
    wire _3978;
    wire _3986;
    wire _3953;
    wire _3955;
    wire _3958;
    wire _3977;
    wire _3985;
    wire _3954;
    wire _3956;
    wire _3957;
    wire _3976;
    wire _3984;
    wire _3961;
    wire _3964;
    wire _3971;
    wire _3975;
    wire _3983;
    wire _3962;
    wire _3963;
    wire _3970;
    wire _3974;
    wire _3982;
    wire _3965;
    wire _3967;
    wire _3969;
    wire _3973;
    wire _3981;
    wire _3832;
    wire _3833;
    wire _3966;
    wire _3834;
    wire _3968;
    wire _3835;
    wire _3972;
    wire [4:0] _3831 = 5'b00000;
    wire _3836;
    wire _3980;
    wire [31:0] _3996;
    wire _3998;
    wire gnd = 1'b0;
    wire _3999;
    wire [31:0] _4000 = 32'b00000000000000000000000000000000;
    wire [31:0] _4001 = 32'b00000000000000000000000000000000;
    wire [31:0] _3117 = 32'b00000000000000000000000000000000;
    wire [31:0] _3118 = 32'b00000000000000000000000000000000;
    reg [31:0] _3119;
    reg [31:0] reg_01;
    wire [31:0] _3997 = 32'b00000000000000000000000000000000;
    reg [31:0] _4154;
    reg [31:0] _4188;
    wire _4182 = 1'b0;
    wire _4183 = 1'b0;
    wire [4:0] _3829 = 5'b00000;
    wire _3830;
    reg _4184;
    wire _4178 = 1'b0;
    wire _4179 = 1'b0;
    wire [4:0] _3825 = 5'b00000;
    wire _3826;
    reg _4180;
    wire _4174 = 1'b0;
    wire _4175 = 1'b0;
    wire [4:0] _3827 = 5'b00000;
    wire _3828;
    reg _4176;
    wire [4:0] _4170 = 5'b00000;
    wire [4:0] _4171 = 5'b00000;
    wire [4:0] _3824;
    reg [4:0] _4172;
    wire [4:0] _4166 = 5'b00000;
    wire [4:0] _4167 = 5'b00000;
    wire [4:0] _3822;
    reg [4:0] _4168;
    wire [4:0] _4162 = 5'b00000;
    wire [4:0] _4163 = 5'b00000;
    wire [4:0] _3823;
    reg [4:0] _4164;
    wire _4158 = 1'b0;
    wire _4159 = 1'b0;
    wire _4155 = 1'b0;
    wire _4156 = 1'b0;
    wire _2833 = 1'b0;
    wire vdd = 1'b1;
    wire _2834 = 1'b0;
    reg _2835;
    reg _4157;
    reg _4160;

    /* logic */
    always @(posedge clk) begin
        if (clr)
            _2759 <= _2757;
        else
            _2759 <= junk_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _4236 <= _4234;
        else
            _4236 <= _2759;
    end
    always @(posedge clk) begin
        if (clr)
            _2763 <= _2761;
        else
            _2763 <= alu_cmp_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _4232 <= _4230;
        else
            _4232 <= _2763;
    end
    always @(posedge clk) begin
        if (clr)
            _2767 <= _2765;
        else
            _2767 <= alu_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _4228 <= _4226;
        else
            _4228 <= _2767;
    end
    always @(posedge clk) begin
        if (clr)
            _2771 <= _2769;
        else
            _2771 <= fclass_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _4224 <= _4222;
        else
            _4224 <= _2771;
    end
    always @(posedge clk) begin
        if (clr)
            _2775 <= _2773;
        else
            _2775 <= is_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _4220 <= _4218;
        else
            _4220 <= _2775;
    end
    assign _3758 = _3619 & _3587;
    assign _3757 = _3619 & _3588;
    assign _3756 = _3619 & _3591;
    assign _3755 = _3619 & _3592;
    assign _3754 = _3619 & _3593;
    assign _3753 = _3619 & _3594;
    assign _3752 = _3621 & _3587;
    assign _3751 = _3621 & _3588;
    assign _3750 = _3621 & _3589;
    assign _3749 = _3621 & _3591;
    assign _3748 = _3621 & _3592;
    assign _3747 = _3623 & _3587;
    assign _3746 = _3623 & _3588;
    assign _3745 = _3623 & _3589;
    assign _3744 = _3625 & _3587;
    assign _3743 = _3625 & _3589;
    assign _3742 = _3625 & _3590;
    assign _3741 = _3625 & _3591;
    assign _3740 = _3625 & _3593;
    assign _3739 = _3625 & _3594;
    assign _3737 = _3625 & _3588;
    assign _3738 = _3737 & _3598;
    assign _3735 = _3625 & _3592;
    assign _3736 = _3735 & _3598;
    assign _3733 = _3625 & _3592;
    assign _3734 = _3733 & _3596;
    assign _3731 = _3627 & _3587;
    assign _3732 = _3731 & _3598;
    assign _3729 = _3627 & _3587;
    assign _3730 = _3729 & _3596;
    assign _3727 = _3627 & _3588;
    assign _3728 = _3727 & _3598;
    assign _3725 = _3627 & _3589;
    assign _3726 = _3725 & _3598;
    assign _3723 = _3627 & _3590;
    assign _3724 = _3723 & _3598;
    assign _3591 = _3586[4:4];
    assign _3721 = _3627 & _3591;
    assign _3722 = _3721 & _3598;
    assign _3719 = _3627 & _3592;
    assign _3720 = _3719 & _3598;
    assign _3717 = _3627 & _3592;
    assign _3718 = _3717 & _3596;
    assign _3715 = _3627 & _3593;
    assign _3716 = _3715 & _3598;
    assign _3713 = _3627 & _3594;
    assign _3714 = _3713 & _3598;
    assign _3711 = ~ _3654;
    assign _3712 = _3663 & _3711;
    assign _3710 = _3663 & _3654;
    assign _3708 = ~ _3654;
    assign _3709 = _3660 & _3708;
    assign _3707 = _3660 & _3654;
    assign _3705 = ~ _3654;
    assign _3706 = _3657 & _3705;
    assign _3654 = _3559[7:7];
    assign _3704 = _3657 & _3654;
    assign _3656 = _3653 == _3655;
    assign _3657 = _3656 & _3652;
    assign _3659 = _3653 == _3658;
    assign _3660 = _3659 & _3652;
    assign _3643 = _3559[6:2];
    assign _3645 = _3643 == _3644;
    assign _3646 = _3559[11:8];
    assign _3648 = _3646 == _3647;
    assign _3649 = _3648 & _3645;
    assign _3650 = _3608 & _3589;
    assign _3651 = _3650 & _3631;
    assign _3652 = _3651 & _3649;
    assign _3653 = _3559[1:0];
    assign _3662 = _3653 == _3661;
    assign _3663 = _3662 & _3652;
    assign _3635 = _3559 == _3634;
    assign _3641 = _3635 & _3640;
    assign _3631 = _3556 == _3630;
    assign _3600 = mio_rdata[11:7];
    assign _3604 = _3600 == _3603;
    assign _3602 = mio_rdata[19:15];
    assign _3608 = _3602 == _3607;
    assign _3638 = _3608 & _3587;
    assign _3639 = _3638 & _3604;
    assign _3640 = _3639 & _3631;
    assign _3559 = mio_rdata[31:20];
    assign _3637 = _3559 == _3636;
    assign _3642 = _3637 & _3640;
    assign _3632 = _3629 & _3588;
    assign _3629 = _3556 == _3628;
    assign _3633 = _3629 & _3587;
    assign _3675 = ~ _3674;
    assign _3676 = _3675 & _3598;
    assign _3674 = _3587 | _3592;
    assign _3677 = _3674 & _3599;
    assign _3678 = _3677 | _3676;
    assign _3627 = _3556 == _3626;
    assign _3679 = _3627 & _3678;
    assign _3596 = _3558 == _3595;
    assign _3599 = _3598 | _3596;
    assign _3680 = _3592 & _3599;
    assign _3558 = mio_rdata[31:25];
    assign _3598 = _3558 == _3597;
    assign _3681 = _3588 & _3598;
    assign _3682 = _3681 | _3680;
    assign _3683 = _3625 & _3682;
    assign _3592 = _3586[5:5];
    assign _3684 = _3588 | _3592;
    assign _3685 = ~ _3684;
    assign _3686 = _3625 & _3685;
    assign _3588 = _3586[1:1];
    assign _3671 = _3587 | _3588;
    assign _3672 = _3671 | _3589;
    assign _3673 = _3623 & _3672;
    assign _3594 = _3586[7:7];
    assign _3593 = _3586[6:6];
    assign _3667 = _3590 | _3593;
    assign _3668 = _3667 | _3594;
    assign _3669 = ~ _3668;
    assign _3670 = _3621 & _3669;
    assign _3590 = _3586[3:3];
    assign _3589 = _3586[2:2];
    assign _3664 = _3589 | _3590;
    assign _3665 = ~ _3664;
    assign _3666 = _3619 & _3665;
    assign _3687 = _3610 | _3612;
    assign _3688 = _3687 | _3614;
    assign _3689 = _3688 | _3617;
    assign _3690 = _3689 | _3666;
    assign _3691 = _3690 | _3670;
    assign _3692 = _3691 | _3673;
    assign _3693 = _3692 | _3686;
    assign _3694 = _3693 | _3683;
    assign _3695 = _3694 | _3679;
    assign _3696 = _3695 | _3633;
    assign _3697 = _3696 | _3632;
    assign _3698 = _3697 | _3642;
    assign _3699 = _3698 | _3641;
    assign _3700 = _3699 | _3663;
    assign _3701 = _3700 | _3660;
    assign _3702 = _3701 | _3657;
    assign _3703 = ~ _3702;
    assign _3759 = { _3703, _3704, _3706, _3707, _3709, _3710, _3712, _3641, _3642, _3632, _3633, _3714, _3716, _3718, _3720, _3722, _3724, _3726, _3728, _3730, _3732, _3734, _3736, _3738, _3739, _3740, _3741, _3742, _3743, _3744, _3745, _3746, _3747, _3748, _3749, _3750, _3751, _3752, _3753, _3754, _3755, _3756, _3757, _3758, _3617, _3614, _3612, _3610 };
    always @(posedge clk) begin
        if (clr)
            _4216 <= _4214;
        else
            _4216 <= _3759;
    end
    always @(posedge clk) begin
        if (clr)
            _4212 <= _4210;
        else
            _4212 <= mio_rdata;
    end
    always @(posedge clk) begin
        if (clr)
            _2787 <= _2785;
        else
            _2787 <= next_pc_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _4208 <= _4206;
        else
            _4208 <= _2787;
    end
    always @(posedge clk) begin
        if (clr)
            _2791 <= _2789;
        else
            _2791 <= pc_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _4204 <= _4202;
        else
            _4204 <= _2791;
    end
    assign _3774 = _3769[0:0];
    assign _3771 = _3769[19:10];
    assign _3772 = _3769[9:9];
    assign _3773 = _3769[8:1];
    assign _3764 = { _3763, _3762 };
    assign _3760 = mio_rdata[31:12];
    assign _3761 = { _3760, gnd };
    assign _3762 = _3761[20:20];
    assign _3763 = { _3762, _3762 };
    assign _3765 = { _3763, _3763 };
    assign _3766 = { _3765, _3765 };
    assign _3767 = { _3766, _3764 };
    assign _3769 = { _3767, _3761 };
    assign _3770 = _3769[31:20];
    assign _3775 = { _3770, _3773, _3772, _3771, _3774 };
    assign _3814 = mio_rdata[31:12];
    assign _3815 = { _3814, _3813 };
    assign _3802 = mio_rdata[31:20];
    assign _3803 = _3802[11:11];
    assign _3804 = { _3803, _3803 };
    assign _3805 = { _3804, _3804 };
    assign _3806 = { _3805, _3805 };
    assign _3807 = { _3806, _3806 };
    assign _3808 = { _3807, _3805 };
    assign _3810 = { _3808, _3802 };
    assign _3795 = { _3794, _3793 };
    assign _3791 = mio_rdata[11:8];
    assign _3790 = mio_rdata[30:25];
    assign _3789 = mio_rdata[7:7];
    assign _3788 = mio_rdata[31:31];
    assign _3792 = { _3788, _3789, _3790, _3791, gnd };
    assign _3793 = _3792[12:12];
    assign _3794 = { _3793, _3793 };
    assign _3796 = { _3794, _3794 };
    assign _3797 = { _3796, _3796 };
    assign _3798 = { _3797, _3797 };
    assign _3799 = { _3798, _3795 };
    assign _3801 = { _3799, _3792 };
    assign _3778 = mio_rdata[11:7];
    assign _3777 = mio_rdata[31:25];
    assign _3779 = { _3777, _3778 };
    assign _3780 = _3779[11:11];
    assign _3781 = { _3780, _3780 };
    assign _3782 = { _3781, _3781 };
    assign _3783 = { _3782, _3782 };
    assign _3784 = { _3783, _3783 };
    assign _3785 = { _3784, _3782 };
    assign _3787 = { _3785, _3779 };
    assign _3623 = _3556 == _3622;
    assign _3817 = _3623 ? _3787 : _3776;
    assign _3619 = _3556 == _3618;
    assign _3818 = _3619 ? _3801 : _3817;
    assign _3625 = _3556 == _3624;
    assign _3621 = _3556 == _3620;
    assign _3563 = ~ _3560;
    assign _3566 = _3564 & _3563;
    assign _3574 = _3570 & _3566;
    assign _3564 = ~ _3561;
    assign _3565 = _3564 & _3560;
    assign _3573 = _3570 & _3565;
    assign _3567 = ~ _3560;
    assign _3569 = _3561 & _3567;
    assign _3572 = _3570 & _3569;
    assign _3568 = _3561 & _3560;
    assign _3570 = ~ _3562;
    assign _3571 = _3570 & _3568;
    assign _3575 = ~ _3560;
    assign _3578 = _3576 & _3575;
    assign _3585 = _3562 & _3578;
    assign _3576 = ~ _3561;
    assign _3577 = _3576 & _3560;
    assign _3584 = _3562 & _3577;
    assign _3579 = ~ _3560;
    assign _3581 = _3561 & _3579;
    assign _3583 = _3562 & _3581;
    assign _3560 = _3557[0:0];
    assign _3561 = _3557[1:1];
    assign _3580 = _3561 & _3560;
    assign _3557 = mio_rdata[14:12];
    assign _3562 = _3557[2:2];
    assign _3582 = _3562 & _3580;
    assign _3586 = { _3582, _3583, _3584, _3585, _3571, _3572, _3573, _3574 };
    assign _3587 = _3586[0:0];
    assign _3616 = _3556 == _3615;
    assign _3617 = _3616 & _3587;
    assign _3811 = _3617 | _3621;
    assign _3812 = _3811 | _3625;
    assign _3819 = _3812 ? _3810 : _3818;
    assign _3612 = _3556 == _3611;
    assign _3610 = _3556 == _3609;
    assign _3816 = _3610 | _3612;
    assign _3820 = _3816 ? _3815 : _3819;
    assign _3556 = mio_rdata[6:0];
    assign _3614 = _3556 == _3613;
    assign _3821 = _3614 ? _3775 : _3820;
    always @(posedge clk) begin
        if (clr)
            _4200 <= _4198;
        else
            _4200 <= _3821;
    end
    always @(posedge clk) begin
        if (clr)
            _2799 <= _2797;
        else
            _2799 <= rdd_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _4196 <= _4194;
        else
            _4196 <= _2799;
    end
    always @* begin
        case (_3822)
        0: _4153 <= _3997;
        1: _4153 <= reg_01;
        2: _4153 <= reg_02;
        3: _4153 <= reg_03;
        4: _4153 <= reg_04;
        5: _4153 <= reg_05;
        6: _4153 <= reg_06;
        7: _4153 <= reg_07;
        8: _4153 <= reg_08;
        9: _4153 <= reg_09;
        10: _4153 <= reg_10;
        11: _4153 <= reg_11;
        12: _4153 <= reg_12;
        13: _4153 <= reg_13;
        14: _4153 <= reg_14;
        15: _4153 <= reg_15;
        16: _4153 <= reg_16;
        17: _4153 <= reg_17;
        18: _4153 <= reg_18;
        19: _4153 <= reg_19;
        20: _4153 <= reg_20;
        21: _4153 <= reg_21;
        22: _4153 <= reg_22;
        23: _4153 <= reg_23;
        24: _4153 <= reg_24;
        25: _4153 <= reg_25;
        26: _4153 <= reg_26;
        27: _4153 <= reg_27;
        28: _4153 <= reg_28;
        29: _4153 <= reg_29;
        30: _4153 <= reg_30;
        default: _4153 <= reg_31;
        endcase
    end
    always @(posedge clk) begin
        if (clr)
            _4192 <= _4190;
        else
            _4192 <= _4153;
    end
    assign _4148 = _3996[31:31];
    assign _4149 = gnd & _4148;
    always @(posedge clk) begin
        if (clr)
            reg_31 <= _4150;
        else
            if (_4149)
                reg_31 <= _3119;
    end
    assign _4143 = _3996[30:30];
    assign _4144 = gnd & _4143;
    always @(posedge clk) begin
        if (clr)
            reg_30 <= _4145;
        else
            if (_4144)
                reg_30 <= _3119;
    end
    assign _4138 = _3996[29:29];
    assign _4139 = gnd & _4138;
    always @(posedge clk) begin
        if (clr)
            reg_29 <= _4140;
        else
            if (_4139)
                reg_29 <= _3119;
    end
    assign _4133 = _3996[28:28];
    assign _4134 = gnd & _4133;
    always @(posedge clk) begin
        if (clr)
            reg_28 <= _4135;
        else
            if (_4134)
                reg_28 <= _3119;
    end
    assign _4128 = _3996[27:27];
    assign _4129 = gnd & _4128;
    always @(posedge clk) begin
        if (clr)
            reg_27 <= _4130;
        else
            if (_4129)
                reg_27 <= _3119;
    end
    assign _4123 = _3996[26:26];
    assign _4124 = gnd & _4123;
    always @(posedge clk) begin
        if (clr)
            reg_26 <= _4125;
        else
            if (_4124)
                reg_26 <= _3119;
    end
    assign _4118 = _3996[25:25];
    assign _4119 = gnd & _4118;
    always @(posedge clk) begin
        if (clr)
            reg_25 <= _4120;
        else
            if (_4119)
                reg_25 <= _3119;
    end
    assign _4113 = _3996[24:24];
    assign _4114 = gnd & _4113;
    always @(posedge clk) begin
        if (clr)
            reg_24 <= _4115;
        else
            if (_4114)
                reg_24 <= _3119;
    end
    assign _4108 = _3996[23:23];
    assign _4109 = gnd & _4108;
    always @(posedge clk) begin
        if (clr)
            reg_23 <= _4110;
        else
            if (_4109)
                reg_23 <= _3119;
    end
    assign _4103 = _3996[22:22];
    assign _4104 = gnd & _4103;
    always @(posedge clk) begin
        if (clr)
            reg_22 <= _4105;
        else
            if (_4104)
                reg_22 <= _3119;
    end
    assign _4098 = _3996[21:21];
    assign _4099 = gnd & _4098;
    always @(posedge clk) begin
        if (clr)
            reg_21 <= _4100;
        else
            if (_4099)
                reg_21 <= _3119;
    end
    assign _4093 = _3996[20:20];
    assign _4094 = gnd & _4093;
    always @(posedge clk) begin
        if (clr)
            reg_20 <= _4095;
        else
            if (_4094)
                reg_20 <= _3119;
    end
    assign _4088 = _3996[19:19];
    assign _4089 = gnd & _4088;
    always @(posedge clk) begin
        if (clr)
            reg_19 <= _4090;
        else
            if (_4089)
                reg_19 <= _3119;
    end
    assign _4083 = _3996[18:18];
    assign _4084 = gnd & _4083;
    always @(posedge clk) begin
        if (clr)
            reg_18 <= _4085;
        else
            if (_4084)
                reg_18 <= _3119;
    end
    assign _4078 = _3996[17:17];
    assign _4079 = gnd & _4078;
    always @(posedge clk) begin
        if (clr)
            reg_17 <= _4080;
        else
            if (_4079)
                reg_17 <= _3119;
    end
    assign _4073 = _3996[16:16];
    assign _4074 = gnd & _4073;
    always @(posedge clk) begin
        if (clr)
            reg_16 <= _4075;
        else
            if (_4074)
                reg_16 <= _3119;
    end
    assign _4068 = _3996[15:15];
    assign _4069 = gnd & _4068;
    always @(posedge clk) begin
        if (clr)
            reg_15 <= _4070;
        else
            if (_4069)
                reg_15 <= _3119;
    end
    assign _4063 = _3996[14:14];
    assign _4064 = gnd & _4063;
    always @(posedge clk) begin
        if (clr)
            reg_14 <= _4065;
        else
            if (_4064)
                reg_14 <= _3119;
    end
    assign _4058 = _3996[13:13];
    assign _4059 = gnd & _4058;
    always @(posedge clk) begin
        if (clr)
            reg_13 <= _4060;
        else
            if (_4059)
                reg_13 <= _3119;
    end
    assign _4053 = _3996[12:12];
    assign _4054 = gnd & _4053;
    always @(posedge clk) begin
        if (clr)
            reg_12 <= _4055;
        else
            if (_4054)
                reg_12 <= _3119;
    end
    assign _4048 = _3996[11:11];
    assign _4049 = gnd & _4048;
    always @(posedge clk) begin
        if (clr)
            reg_11 <= _4050;
        else
            if (_4049)
                reg_11 <= _3119;
    end
    assign _4043 = _3996[10:10];
    assign _4044 = gnd & _4043;
    always @(posedge clk) begin
        if (clr)
            reg_10 <= _4045;
        else
            if (_4044)
                reg_10 <= _3119;
    end
    assign _4038 = _3996[9:9];
    assign _4039 = gnd & _4038;
    always @(posedge clk) begin
        if (clr)
            reg_09 <= _4040;
        else
            if (_4039)
                reg_09 <= _3119;
    end
    assign _4033 = _3996[8:8];
    assign _4034 = gnd & _4033;
    always @(posedge clk) begin
        if (clr)
            reg_08 <= _4035;
        else
            if (_4034)
                reg_08 <= _3119;
    end
    assign _4028 = _3996[7:7];
    assign _4029 = gnd & _4028;
    always @(posedge clk) begin
        if (clr)
            reg_07 <= _4030;
        else
            if (_4029)
                reg_07 <= _3119;
    end
    assign _4023 = _3996[6:6];
    assign _4024 = gnd & _4023;
    always @(posedge clk) begin
        if (clr)
            reg_06 <= _4025;
        else
            if (_4024)
                reg_06 <= _3119;
    end
    assign _4018 = _3996[5:5];
    assign _4019 = gnd & _4018;
    always @(posedge clk) begin
        if (clr)
            reg_05 <= _4020;
        else
            if (_4019)
                reg_05 <= _3119;
    end
    assign _4013 = _3996[4:4];
    assign _4014 = gnd & _4013;
    always @(posedge clk) begin
        if (clr)
            reg_04 <= _4015;
        else
            if (_4014)
                reg_04 <= _3119;
    end
    assign _4008 = _3996[3:3];
    assign _4009 = gnd & _4008;
    always @(posedge clk) begin
        if (clr)
            reg_03 <= _4010;
        else
            if (_4009)
                reg_03 <= _3119;
    end
    assign _4003 = _3996[2:2];
    assign _4004 = gnd & _4003;
    always @(posedge clk) begin
        if (clr)
            reg_02 <= _4005;
        else
            if (_4004)
                reg_02 <= _3119;
    end
    assign _3837 = ~ _3832;
    assign _3840 = _3838 & _3837;
    assign _3848 = _3844 & _3840;
    assign _3868 = _3860 & _3848;
    assign _3916 = _3900 & _3868;
    assign _3838 = ~ _3833;
    assign _3839 = _3838 & _3832;
    assign _3847 = _3844 & _3839;
    assign _3867 = _3860 & _3847;
    assign _3915 = _3900 & _3867;
    assign _3841 = ~ _3832;
    assign _3843 = _3833 & _3841;
    assign _3846 = _3844 & _3843;
    assign _3866 = _3860 & _3846;
    assign _3914 = _3900 & _3866;
    assign _3842 = _3833 & _3832;
    assign _3844 = ~ _3834;
    assign _3845 = _3844 & _3842;
    assign _3865 = _3860 & _3845;
    assign _3913 = _3900 & _3865;
    assign _3849 = ~ _3832;
    assign _3852 = _3850 & _3849;
    assign _3859 = _3834 & _3852;
    assign _3864 = _3860 & _3859;
    assign _3912 = _3900 & _3864;
    assign _3850 = ~ _3833;
    assign _3851 = _3850 & _3832;
    assign _3858 = _3834 & _3851;
    assign _3863 = _3860 & _3858;
    assign _3911 = _3900 & _3863;
    assign _3853 = ~ _3832;
    assign _3855 = _3833 & _3853;
    assign _3857 = _3834 & _3855;
    assign _3862 = _3860 & _3857;
    assign _3910 = _3900 & _3862;
    assign _3854 = _3833 & _3832;
    assign _3856 = _3834 & _3854;
    assign _3860 = ~ _3835;
    assign _3861 = _3860 & _3856;
    assign _3909 = _3900 & _3861;
    assign _3869 = ~ _3832;
    assign _3872 = _3870 & _3869;
    assign _3880 = _3876 & _3872;
    assign _3899 = _3835 & _3880;
    assign _3908 = _3900 & _3899;
    assign _3870 = ~ _3833;
    assign _3871 = _3870 & _3832;
    assign _3879 = _3876 & _3871;
    assign _3898 = _3835 & _3879;
    assign _3907 = _3900 & _3898;
    assign _3873 = ~ _3832;
    assign _3875 = _3833 & _3873;
    assign _3878 = _3876 & _3875;
    assign _3897 = _3835 & _3878;
    assign _3906 = _3900 & _3897;
    assign _3874 = _3833 & _3832;
    assign _3876 = ~ _3834;
    assign _3877 = _3876 & _3874;
    assign _3896 = _3835 & _3877;
    assign _3905 = _3900 & _3896;
    assign _3881 = ~ _3832;
    assign _3884 = _3882 & _3881;
    assign _3891 = _3834 & _3884;
    assign _3895 = _3835 & _3891;
    assign _3904 = _3900 & _3895;
    assign _3882 = ~ _3833;
    assign _3883 = _3882 & _3832;
    assign _3890 = _3834 & _3883;
    assign _3894 = _3835 & _3890;
    assign _3903 = _3900 & _3894;
    assign _3885 = ~ _3832;
    assign _3887 = _3833 & _3885;
    assign _3889 = _3834 & _3887;
    assign _3893 = _3835 & _3889;
    assign _3902 = _3900 & _3893;
    assign _3886 = _3833 & _3832;
    assign _3888 = _3834 & _3886;
    assign _3892 = _3835 & _3888;
    assign _3900 = ~ _3836;
    assign _3901 = _3900 & _3892;
    assign _3917 = ~ _3832;
    assign _3920 = _3918 & _3917;
    assign _3928 = _3924 & _3920;
    assign _3948 = _3940 & _3928;
    assign _3995 = _3836 & _3948;
    assign _3918 = ~ _3833;
    assign _3919 = _3918 & _3832;
    assign _3927 = _3924 & _3919;
    assign _3947 = _3940 & _3927;
    assign _3994 = _3836 & _3947;
    assign _3921 = ~ _3832;
    assign _3923 = _3833 & _3921;
    assign _3926 = _3924 & _3923;
    assign _3946 = _3940 & _3926;
    assign _3993 = _3836 & _3946;
    assign _3922 = _3833 & _3832;
    assign _3924 = ~ _3834;
    assign _3925 = _3924 & _3922;
    assign _3945 = _3940 & _3925;
    assign _3992 = _3836 & _3945;
    assign _3929 = ~ _3832;
    assign _3932 = _3930 & _3929;
    assign _3939 = _3834 & _3932;
    assign _3944 = _3940 & _3939;
    assign _3991 = _3836 & _3944;
    assign _3930 = ~ _3833;
    assign _3931 = _3930 & _3832;
    assign _3938 = _3834 & _3931;
    assign _3943 = _3940 & _3938;
    assign _3990 = _3836 & _3943;
    assign _3933 = ~ _3832;
    assign _3935 = _3833 & _3933;
    assign _3937 = _3834 & _3935;
    assign _3942 = _3940 & _3937;
    assign _3989 = _3836 & _3942;
    assign _3934 = _3833 & _3832;
    assign _3936 = _3834 & _3934;
    assign _3940 = ~ _3835;
    assign _3941 = _3940 & _3936;
    assign _3988 = _3836 & _3941;
    assign _3949 = ~ _3832;
    assign _3952 = _3950 & _3949;
    assign _3960 = _3956 & _3952;
    assign _3979 = _3835 & _3960;
    assign _3987 = _3836 & _3979;
    assign _3950 = ~ _3833;
    assign _3951 = _3950 & _3832;
    assign _3959 = _3956 & _3951;
    assign _3978 = _3835 & _3959;
    assign _3986 = _3836 & _3978;
    assign _3953 = ~ _3832;
    assign _3955 = _3833 & _3953;
    assign _3958 = _3956 & _3955;
    assign _3977 = _3835 & _3958;
    assign _3985 = _3836 & _3977;
    assign _3954 = _3833 & _3832;
    assign _3956 = ~ _3834;
    assign _3957 = _3956 & _3954;
    assign _3976 = _3835 & _3957;
    assign _3984 = _3836 & _3976;
    assign _3961 = ~ _3832;
    assign _3964 = _3962 & _3961;
    assign _3971 = _3834 & _3964;
    assign _3975 = _3835 & _3971;
    assign _3983 = _3836 & _3975;
    assign _3962 = ~ _3833;
    assign _3963 = _3962 & _3832;
    assign _3970 = _3834 & _3963;
    assign _3974 = _3835 & _3970;
    assign _3982 = _3836 & _3974;
    assign _3965 = ~ _3832;
    assign _3967 = _3833 & _3965;
    assign _3969 = _3834 & _3967;
    assign _3973 = _3835 & _3969;
    assign _3981 = _3836 & _3973;
    assign _3832 = _3831[0:0];
    assign _3833 = _3831[1:1];
    assign _3966 = _3833 & _3832;
    assign _3834 = _3831[2:2];
    assign _3968 = _3834 & _3966;
    assign _3835 = _3831[3:3];
    assign _3972 = _3835 & _3968;
    assign _3836 = _3831[4:4];
    assign _3980 = _3836 & _3972;
    assign _3996 = { _3980, _3981, _3982, _3983, _3984, _3985, _3986, _3987, _3988, _3989, _3990, _3991, _3992, _3993, _3994, _3995, _3901, _3902, _3903, _3904, _3905, _3906, _3907, _3908, _3909, _3910, _3911, _3912, _3913, _3914, _3915, _3916 };
    assign _3998 = _3996[1:1];
    assign _3999 = gnd & _3998;
    always @(posedge clk) begin
        if (clr)
            _3119 <= _3117;
        else
            _3119 <= rdd_p_4;
    end
    always @(posedge clk) begin
        if (clr)
            reg_01 <= _4000;
        else
            if (_3999)
                reg_01 <= _3119;
    end
    always @* begin
        case (_3823)
        0: _4154 <= _3997;
        1: _4154 <= reg_01;
        2: _4154 <= reg_02;
        3: _4154 <= reg_03;
        4: _4154 <= reg_04;
        5: _4154 <= reg_05;
        6: _4154 <= reg_06;
        7: _4154 <= reg_07;
        8: _4154 <= reg_08;
        9: _4154 <= reg_09;
        10: _4154 <= reg_10;
        11: _4154 <= reg_11;
        12: _4154 <= reg_12;
        13: _4154 <= reg_13;
        14: _4154 <= reg_14;
        15: _4154 <= reg_15;
        16: _4154 <= reg_16;
        17: _4154 <= reg_17;
        18: _4154 <= reg_18;
        19: _4154 <= reg_19;
        20: _4154 <= reg_20;
        21: _4154 <= reg_21;
        22: _4154 <= reg_22;
        23: _4154 <= reg_23;
        24: _4154 <= reg_24;
        25: _4154 <= reg_25;
        26: _4154 <= reg_26;
        27: _4154 <= reg_27;
        28: _4154 <= reg_28;
        29: _4154 <= reg_29;
        30: _4154 <= reg_30;
        default: _4154 <= reg_31;
        endcase
    end
    always @(posedge clk) begin
        if (clr)
            _4188 <= _4186;
        else
            _4188 <= _4154;
    end
    assign _3830 = _3824 == _3829;
    always @(posedge clk) begin
        if (clr)
            _4184 <= _4182;
        else
            _4184 <= _3830;
    end
    assign _3826 = _3822 == _3825;
    always @(posedge clk) begin
        if (clr)
            _4180 <= _4178;
        else
            _4180 <= _3826;
    end
    assign _3828 = _3823 == _3827;
    always @(posedge clk) begin
        if (clr)
            _4176 <= _4174;
        else
            _4176 <= _3828;
    end
    assign _3824 = mio_rdata[11:7];
    always @(posedge clk) begin
        if (clr)
            _4172 <= _4170;
        else
            _4172 <= _3824;
    end
    assign _3822 = mio_rdata[24:20];
    always @(posedge clk) begin
        if (clr)
            _4168 <= _4166;
        else
            _4168 <= _3822;
    end
    assign _3823 = mio_rdata[19:15];
    always @(posedge clk) begin
        if (clr)
            _4164 <= _4162;
        else
            _4164 <= _3823;
    end
    always @(posedge clk) begin
        if (clr)
            _2835 <= _2833;
        else
            _2835 <= pen_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _4157 <= _4155;
        else
            _4157 <= _2835;
    end
    always @(posedge clk) begin
        if (clr)
            _4160 <= _4158;
        else
            _4160 <= _4157;
    end

    /* aliases */

    /* output assignments */
    assign pen = _4160;
    assign ra1 = _4164;
    assign ra2 = _4168;
    assign rad = _4172;
    assign ra1_zero = _4176;
    assign ra2_zero = _4180;
    assign rad_zero = _4184;
    assign rd1 = _4188;
    assign rd2 = _4192;
    assign rdd = _4196;
    assign imm = _4200;
    assign pc = _4204;
    assign next_pc = _4208;
    assign instr = _4212;
    assign insn = _4216;
    assign is = _4220;
    assign fclass = _4224;
    assign alu = _4228;
    assign alu_cmp = _4232;
    assign junk = _4236;

endmodule
