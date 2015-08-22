module decoder (
    junk_p_0,
    mio_data_wmask_p_0,
    mio_data_rw_p_0,
    mio_data_req_p_0,
    mio_data_wdata_p_0,
    mio_data_addr_p_0,
    mio_instr_wmask_p_0,
    mio_instr_rw_p_0,
    mio_instr_req_p_0,
    mio_instr_wdata_p_0,
    mio_instr_addr_p_0,
    branch_p_0,
    pc_p_0,
    rad_p_4,
    rwe_p_4,
    rdd_p_4,
    mio_instr_rdata,
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
    rdc,
    rdco,
    f3,
    f7,
    branch,
    rwe,
    mio_instr_addr,
    mio_instr_wdata,
    mio_instr_req,
    mio_instr_rw,
    mio_instr_wmask,
    mio_data_addr,
    mio_data_wdata,
    mio_data_req,
    mio_data_rw,
    mio_data_wmask,
    junk
);

    input junk_p_0;
    input [3:0] mio_data_wmask_p_0;
    input mio_data_rw_p_0;
    input mio_data_req_p_0;
    input [31:0] mio_data_wdata_p_0;
    input [31:0] mio_data_addr_p_0;
    input [3:0] mio_instr_wmask_p_0;
    input mio_instr_rw_p_0;
    input mio_instr_req_p_0;
    input [31:0] mio_instr_wdata_p_0;
    input [31:0] mio_instr_addr_p_0;
    input branch_p_0;
    input [31:0] pc_p_0;
    input [4:0] rad_p_4;
    input rwe_p_4;
    input [31:0] rdd_p_4;
    input [31:0] mio_instr_rdata;
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
    output rdc;
    output [2:0] rdco;
    output [2:0] f3;
    output f7;
    output branch;
    output rwe;
    output [31:0] mio_instr_addr;
    output [31:0] mio_instr_wdata;
    output mio_instr_req;
    output mio_instr_rw;
    output [3:0] mio_instr_wmask;
    output [31:0] mio_data_addr;
    output [31:0] mio_data_wdata;
    output mio_data_req;
    output mio_data_rw;
    output [3:0] mio_data_wmask;
    output junk;

    /* signal declarations */
    wire _4725 = 1'b0;
    wire _4726 = 1'b0;
    wire _2181 = 1'b0;
    wire _2182 = 1'b0;
    reg _2183;
    reg _4727;
    wire [3:0] _4721 = 4'b0000;
    wire [3:0] _4722 = 4'b0000;
    wire [3:0] _2185 = 4'b0000;
    wire [3:0] _2186 = 4'b0000;
    reg [3:0] _2187;
    reg [3:0] _4723;
    wire _4717 = 1'b0;
    wire _4718 = 1'b0;
    wire _2189 = 1'b0;
    wire _2190 = 1'b0;
    reg _2191;
    reg _4719;
    wire _4713 = 1'b0;
    wire _4714 = 1'b0;
    wire _2193 = 1'b0;
    wire _2194 = 1'b0;
    reg _2195;
    reg _4715;
    wire [31:0] _4709 = 32'b00000000000000000000000000000000;
    wire [31:0] _4710 = 32'b00000000000000000000000000000000;
    wire [31:0] _2197 = 32'b00000000000000000000000000000000;
    wire [31:0] _2198 = 32'b00000000000000000000000000000000;
    reg [31:0] _2199;
    reg [31:0] _4711;
    wire [31:0] _4705 = 32'b00000000000000000000000000000000;
    wire [31:0] _4706 = 32'b00000000000000000000000000000000;
    wire [31:0] _2201 = 32'b00000000000000000000000000000000;
    wire [31:0] _2202 = 32'b00000000000000000000000000000000;
    reg [31:0] _2203;
    reg [31:0] _4707;
    wire [3:0] _4701 = 4'b0000;
    wire [3:0] _4702 = 4'b0000;
    wire [3:0] _2205 = 4'b0000;
    wire [3:0] _2206 = 4'b0000;
    reg [3:0] _2207;
    reg [3:0] _4703;
    wire _4697 = 1'b0;
    wire _4698 = 1'b0;
    wire _2209 = 1'b0;
    wire _2210 = 1'b0;
    reg _2211;
    reg _4699;
    wire _4693 = 1'b0;
    wire _4694 = 1'b0;
    wire _2213 = 1'b0;
    wire _2214 = 1'b0;
    reg _2215;
    reg _4695;
    wire [31:0] _4689 = 32'b00000000000000000000000000000000;
    wire [31:0] _4690 = 32'b00000000000000000000000000000000;
    wire [31:0] _2217 = 32'b00000000000000000000000000000000;
    wire [31:0] _2218 = 32'b00000000000000000000000000000000;
    reg [31:0] _2219;
    reg [31:0] _4691;
    wire [31:0] _4685 = 32'b00000000000000000000000000000000;
    wire [31:0] _4686 = 32'b00000000000000000000000000000000;
    wire [31:0] _2221 = 32'b00000000000000000000000000000000;
    wire [31:0] _2222 = 32'b00000000000000000000000000000000;
    reg [31:0] _2223;
    reg [31:0] _4687;
    wire _4681 = 1'b0;
    wire _4682 = 1'b0;
    reg _4683;
    wire _4677 = 1'b0;
    wire _4678 = 1'b0;
    wire _2229 = 1'b0;
    wire _2230 = 1'b0;
    reg _2231;
    reg _4679;
    wire _4673 = 1'b0;
    wire _4674 = 1'b0;
    wire _4148;
    reg _4675;
    wire [2:0] _4669 = 3'b000;
    wire [2:0] _4670 = 3'b000;
    reg [2:0] _4671;
    wire [2:0] _4665 = 3'b000;
    wire [2:0] _4666 = 3'b000;
    reg [2:0] _4667;
    wire _4661 = 1'b0;
    wire _4662 = 1'b0;
    reg _4663;
    wire _4657 = 1'b0;
    wire _4658 = 1'b0;
    reg _4659;
    wire _4653 = 1'b0;
    wire _4654 = 1'b0;
    reg _4655;
    wire _4649 = 1'b0;
    wire _4650 = 1'b0;
    reg _4651;
    wire _4645 = 1'b0;
    wire _4646 = 1'b0;
    reg _4647;
    wire _4641 = 1'b0;
    wire _4642 = 1'b0;
    reg _4643;
    wire _4637 = 1'b0;
    wire _4638 = 1'b0;
    reg _4639;
    wire _4633 = 1'b0;
    wire _4634 = 1'b0;
    reg _4635;
    wire _4629 = 1'b0;
    wire _4630 = 1'b0;
    reg _4631;
    wire _4625 = 1'b0;
    wire _4626 = 1'b0;
    reg _4627;
    wire _4621 = 1'b0;
    wire _4622 = 1'b0;
    reg _4623;
    wire _4617 = 1'b0;
    wire _4618 = 1'b0;
    reg _4619;
    wire _4613 = 1'b0;
    wire _4614 = 1'b0;
    reg _4615;
    wire [47:0] _4609 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _4610 = 48'b000000000000000000000000000000000000000000000000;
    wire _4146;
    wire _4145;
    wire _4144;
    wire _4143;
    wire _4142;
    wire _4141;
    wire _4140;
    wire _4139;
    wire _4138;
    wire _4137;
    wire _4136;
    wire _4135;
    wire _4134;
    wire _4133;
    wire _4132;
    wire _4131;
    wire _4130;
    wire _4129;
    wire _4128;
    wire _4127;
    wire _4125;
    wire _4126;
    wire _4123;
    wire _4124;
    wire _4121;
    wire _4122;
    wire _4119;
    wire _4120;
    wire _4117;
    wire _4118;
    wire _4115;
    wire _4116;
    wire _4113;
    wire _4114;
    wire _4111;
    wire _4112;
    wire _3975;
    wire _4109;
    wire _4110;
    wire _4107;
    wire _4108;
    wire _4105;
    wire _4106;
    wire _4103;
    wire _4104;
    wire _4101;
    wire _4102;
    wire [2:0] _4098 = 3'b000;
    wire _4099;
    wire _4100;
    wire [2:0] _4095 = 3'b001;
    wire _4096;
    wire _4097;
    wire [2:0] _4092 = 3'b010;
    wire _4093;
    wire _4094;
    wire [2:0] _4089 = 3'b011;
    wire _4090;
    wire _4091;
    wire [2:0] _4086 = 3'b100;
    wire _4087;
    wire _4088;
    wire [2:0] _4083 = 3'b101;
    wire _4038;
    wire [1:0] _4039;
    wire [2:0] _4040;
    wire _4084;
    wire _4085;
    wire [4:0] _4028 = 5'b00000;
    wire [4:0] _4027;
    wire _4029;
    wire [3:0] _4031 = 4'b1100;
    wire [3:0] _4030;
    wire _4032;
    wire _4033;
    wire _4034;
    wire _4035;
    wire _4036;
    wire [1:0] _4041 = 2'b11;
    wire [1:0] _4037;
    wire _4042;
    wire _4043;
    wire _4044;
    wire [11:0] _4018 = 12'b000000000001;
    wire _4019;
    wire _4025;
    wire [6:0] _4014 = 7'b1110011;
    wire _4015;
    wire [4:0] _3987 = 5'b00000;
    wire [4:0] _3984;
    wire _3988;
    wire [4:0] _3991 = 5'b00000;
    wire [4:0] _3986;
    wire _3992;
    wire _4022;
    wire _4023;
    wire _4024;
    wire [11:0] _4020 = 12'b000000000000;
    wire [11:0] _3943;
    wire _4021;
    wire _4026;
    wire _4016;
    wire [6:0] _4012 = 7'b0001111;
    wire _4013;
    wire _4017;
    wire _4056;
    wire _4057;
    wire _4055;
    wire _4058;
    wire _4059;
    wire [6:0] _4010 = 7'b0110011;
    wire _4011;
    wire _4060;
    wire [6:0] _3979 = 7'b0100000;
    wire _3980;
    wire _3983;
    wire _4061;
    wire [6:0] _3981 = 7'b0000000;
    wire [6:0] _3942;
    wire _3982;
    wire _4062;
    wire _4063;
    wire _4064;
    wire _3976;
    wire _4065;
    wire _4066;
    wire _4067;
    wire _3972;
    wire _4052;
    wire _4053;
    wire _4054;
    wire _3978;
    wire _3977;
    wire _4048;
    wire _4049;
    wire _4050;
    wire _4051;
    wire _3974;
    wire _3973;
    wire _4045;
    wire _4046;
    wire _4047;
    wire _4068;
    wire _4069;
    wire _4070;
    wire _4071;
    wire _4072;
    wire _4073;
    wire _4074;
    wire _4075;
    wire _4076;
    wire _4077;
    wire _4078;
    wire _4079;
    wire _4080;
    wire _4081;
    wire _4082;
    wire [47:0] _4147;
    reg [47:0] _4611;
    wire [31:0] _4605 = 32'b00000000000000000000000000000000;
    wire [31:0] _4606 = 32'b00000000000000000000000000000000;
    reg [31:0] _4607;
    wire [31:0] _4601 = 32'b00000000000000000000000000000000;
    wire [31:0] _4602 = 32'b00000000000000000000000000000000;
    wire [31:0] _2305 = 32'b00000000000000000000000000000000;
    wire [31:0] _2306 = 32'b00000000000000000000000000000000;
    reg [31:0] _2307;
    reg [31:0] _4603;
    wire [31:0] _4597 = 32'b00000000000000000000000000000000;
    wire [31:0] _4598 = 32'b00000000000000000000000000000000;
    reg [31:0] _4599;
    wire [31:0] _4593 = 32'b00000000000000000000000000000000;
    wire [31:0] _4594 = 32'b00000000000000000000000000000000;
    reg [31:0] _4595;
    wire [31:0] _4589 = 32'b00000000000000000000000000000000;
    wire [31:0] _4590 = 32'b00000000000000000000000000000000;
    reg [31:0] _4591;
    wire [31:0] _4585 = 32'b00000000000000000000000000000000;
    wire [31:0] _4586 = 32'b00000000000000000000000000000000;
    wire _4163;
    wire [9:0] _4160;
    wire _4161;
    wire [7:0] _4162;
    wire [2:0] _4153;
    wire [19:0] _4149;
    wire [20:0] _4150;
    wire _4151;
    wire [1:0] _4152;
    wire [3:0] _4154;
    wire [7:0] _4155;
    wire [10:0] _4156;
    wire [31:0] _4158;
    wire [11:0] _4159;
    wire [31:0] _4164;
    wire [11:0] _4202 = 12'b000000000000;
    wire [19:0] _4203;
    wire [31:0] _4204;
    wire [11:0] _4191;
    wire _4192;
    wire [1:0] _4193;
    wire [3:0] _4194;
    wire [7:0] _4195;
    wire [15:0] _4196;
    wire [19:0] _4197;
    wire [31:0] _4199;
    wire [2:0] _4184;
    wire gnd = 1'b0;
    wire [3:0] _4180;
    wire [5:0] _4179;
    wire _4178;
    wire _4177;
    wire [12:0] _4181;
    wire _4182;
    wire [1:0] _4183;
    wire [3:0] _4185;
    wire [7:0] _4186;
    wire [15:0] _4187;
    wire [18:0] _4188;
    wire [31:0] _4190;
    wire [4:0] _4167;
    wire [6:0] _4166;
    wire [11:0] _4168;
    wire _4169;
    wire [1:0] _4170;
    wire [3:0] _4171;
    wire [7:0] _4172;
    wire [15:0] _4173;
    wire [19:0] _4174;
    wire [31:0] _4176;
    wire [31:0] _4165 = 32'b00000000000000000000000000000000;
    wire [31:0] _4206;
    wire [6:0] _4002 = 7'b1100011;
    wire _4003;
    wire [31:0] _4207;
    wire _4200;
    wire _4201;
    wire [31:0] _4208;
    wire _4205;
    wire [31:0] _4209;
    wire [31:0] _4210;
    reg [31:0] _4541;
    wire _3947;
    wire _3950;
    wire _3958;
    wire _3948;
    wire _3949;
    wire _3957;
    wire _3951;
    wire _3953;
    wire _3956;
    wire _3952;
    wire _3954;
    wire _3955;
    wire _3959;
    wire _3962;
    wire _3969;
    wire _3960;
    wire _3961;
    wire _3968;
    wire _3963;
    wire _3965;
    wire _3967;
    wire _3944;
    wire _3945;
    wire _3964;
    wire [2:0] _3941;
    wire _3946;
    wire _3966;
    wire [7:0] _3970;
    wire _3971;
    wire [6:0] _3999 = 7'b1100111;
    wire _4000;
    wire _4001;
    wire [6:0] _3997 = 7'b1101111;
    wire _3998;
    wire [6:0] _4006 = 7'b0100011;
    wire _4007;
    wire [6:0] _4004 = 7'b0000011;
    wire _4005;
    wire [6:0] _3995 = 7'b0010111;
    wire _3996;
    wire [6:0] _3993 = 7'b0110111;
    wire _3994;
    wire [6:0] _4008 = 7'b0010011;
    wire [6:0] _3940;
    wire _4009;
    wire _4543;
    wire _4544;
    wire _4545;
    wire _4546;
    wire _4547;
    wire _4548;
    wire [31:0] _4549;
    reg [31:0] _4587;
    wire [31:0] _4581 = 32'b00000000000000000000000000000000;
    wire [31:0] _4582 = 32'b00000000000000000000000000000000;
    wire _4536;
    wire _4537;
    wire [31:0] _4538 = 32'b00000000000000000000000000000000;
    wire [31:0] _4539 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_31;
    wire _4531;
    wire _4532;
    wire [31:0] _4533 = 32'b00000000000000000000000000000000;
    wire [31:0] _4534 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_30;
    wire _4526;
    wire _4527;
    wire [31:0] _4528 = 32'b00000000000000000000000000000000;
    wire [31:0] _4529 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_29;
    wire _4521;
    wire _4522;
    wire [31:0] _4523 = 32'b00000000000000000000000000000000;
    wire [31:0] _4524 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_28;
    wire _4516;
    wire _4517;
    wire [31:0] _4518 = 32'b00000000000000000000000000000000;
    wire [31:0] _4519 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_27;
    wire _4511;
    wire _4512;
    wire [31:0] _4513 = 32'b00000000000000000000000000000000;
    wire [31:0] _4514 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_26;
    wire _4506;
    wire _4507;
    wire [31:0] _4508 = 32'b00000000000000000000000000000000;
    wire [31:0] _4509 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_25;
    wire _4501;
    wire _4502;
    wire [31:0] _4503 = 32'b00000000000000000000000000000000;
    wire [31:0] _4504 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_24;
    wire _4496;
    wire _4497;
    wire [31:0] _4498 = 32'b00000000000000000000000000000000;
    wire [31:0] _4499 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_23;
    wire _4491;
    wire _4492;
    wire [31:0] _4493 = 32'b00000000000000000000000000000000;
    wire [31:0] _4494 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_22;
    wire _4486;
    wire _4487;
    wire [31:0] _4488 = 32'b00000000000000000000000000000000;
    wire [31:0] _4489 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_21;
    wire _4481;
    wire _4482;
    wire [31:0] _4483 = 32'b00000000000000000000000000000000;
    wire [31:0] _4484 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_20;
    wire _4476;
    wire _4477;
    wire [31:0] _4478 = 32'b00000000000000000000000000000000;
    wire [31:0] _4479 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_19;
    wire _4471;
    wire _4472;
    wire [31:0] _4473 = 32'b00000000000000000000000000000000;
    wire [31:0] _4474 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_18;
    wire _4466;
    wire _4467;
    wire [31:0] _4468 = 32'b00000000000000000000000000000000;
    wire [31:0] _4469 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_17;
    wire _4461;
    wire _4462;
    wire [31:0] _4463 = 32'b00000000000000000000000000000000;
    wire [31:0] _4464 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_16;
    wire _4456;
    wire _4457;
    wire [31:0] _4458 = 32'b00000000000000000000000000000000;
    wire [31:0] _4459 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_15;
    wire _4451;
    wire _4452;
    wire [31:0] _4453 = 32'b00000000000000000000000000000000;
    wire [31:0] _4454 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_14;
    wire _4446;
    wire _4447;
    wire [31:0] _4448 = 32'b00000000000000000000000000000000;
    wire [31:0] _4449 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_13;
    wire _4441;
    wire _4442;
    wire [31:0] _4443 = 32'b00000000000000000000000000000000;
    wire [31:0] _4444 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_12;
    wire _4436;
    wire _4437;
    wire [31:0] _4438 = 32'b00000000000000000000000000000000;
    wire [31:0] _4439 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_11;
    wire _4431;
    wire _4432;
    wire [31:0] _4433 = 32'b00000000000000000000000000000000;
    wire [31:0] _4434 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_10;
    wire _4426;
    wire _4427;
    wire [31:0] _4428 = 32'b00000000000000000000000000000000;
    wire [31:0] _4429 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_09;
    wire _4421;
    wire _4422;
    wire [31:0] _4423 = 32'b00000000000000000000000000000000;
    wire [31:0] _4424 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_08;
    wire _4416;
    wire _4417;
    wire [31:0] _4418 = 32'b00000000000000000000000000000000;
    wire [31:0] _4419 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_07;
    wire _4411;
    wire _4412;
    wire [31:0] _4413 = 32'b00000000000000000000000000000000;
    wire [31:0] _4414 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_06;
    wire _4406;
    wire _4407;
    wire [31:0] _4408 = 32'b00000000000000000000000000000000;
    wire [31:0] _4409 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_05;
    wire _4401;
    wire _4402;
    wire [31:0] _4403 = 32'b00000000000000000000000000000000;
    wire [31:0] _4404 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_04;
    wire _4396;
    wire _4397;
    wire [31:0] _4398 = 32'b00000000000000000000000000000000;
    wire [31:0] _4399 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_03;
    wire _4391;
    wire _4392;
    wire [31:0] _4393 = 32'b00000000000000000000000000000000;
    wire [31:0] _4394 = 32'b00000000000000000000000000000000;
    reg [31:0] reg_02;
    wire _4225;
    wire _4228;
    wire _4236;
    wire _4256;
    wire _4304;
    wire _4226;
    wire _4227;
    wire _4235;
    wire _4255;
    wire _4303;
    wire _4229;
    wire _4231;
    wire _4234;
    wire _4254;
    wire _4302;
    wire _4230;
    wire _4232;
    wire _4233;
    wire _4253;
    wire _4301;
    wire _4237;
    wire _4240;
    wire _4247;
    wire _4252;
    wire _4300;
    wire _4238;
    wire _4239;
    wire _4246;
    wire _4251;
    wire _4299;
    wire _4241;
    wire _4243;
    wire _4245;
    wire _4250;
    wire _4298;
    wire _4242;
    wire _4244;
    wire _4248;
    wire _4249;
    wire _4297;
    wire _4257;
    wire _4260;
    wire _4268;
    wire _4287;
    wire _4296;
    wire _4258;
    wire _4259;
    wire _4267;
    wire _4286;
    wire _4295;
    wire _4261;
    wire _4263;
    wire _4266;
    wire _4285;
    wire _4294;
    wire _4262;
    wire _4264;
    wire _4265;
    wire _4284;
    wire _4293;
    wire _4269;
    wire _4272;
    wire _4279;
    wire _4283;
    wire _4292;
    wire _4270;
    wire _4271;
    wire _4278;
    wire _4282;
    wire _4291;
    wire _4273;
    wire _4275;
    wire _4277;
    wire _4281;
    wire _4290;
    wire _4274;
    wire _4276;
    wire _4280;
    wire _4288;
    wire _4289;
    wire _4305;
    wire _4308;
    wire _4316;
    wire _4336;
    wire _4383;
    wire _4306;
    wire _4307;
    wire _4315;
    wire _4335;
    wire _4382;
    wire _4309;
    wire _4311;
    wire _4314;
    wire _4334;
    wire _4381;
    wire _4310;
    wire _4312;
    wire _4313;
    wire _4333;
    wire _4380;
    wire _4317;
    wire _4320;
    wire _4327;
    wire _4332;
    wire _4379;
    wire _4318;
    wire _4319;
    wire _4326;
    wire _4331;
    wire _4378;
    wire _4321;
    wire _4323;
    wire _4325;
    wire _4330;
    wire _4377;
    wire _4322;
    wire _4324;
    wire _4328;
    wire _4329;
    wire _4376;
    wire _4337;
    wire _4340;
    wire _4348;
    wire _4367;
    wire _4375;
    wire _4338;
    wire _4339;
    wire _4347;
    wire _4366;
    wire _4374;
    wire _4341;
    wire _4343;
    wire _4346;
    wire _4365;
    wire _4373;
    wire _4342;
    wire _4344;
    wire _4345;
    wire _4364;
    wire _4372;
    wire _4349;
    wire _4352;
    wire _4359;
    wire _4363;
    wire _4371;
    wire _4350;
    wire _4351;
    wire _4358;
    wire _4362;
    wire _4370;
    wire _4353;
    wire _4355;
    wire _4357;
    wire _4361;
    wire _4369;
    wire _4220;
    wire _4221;
    wire _4354;
    wire _4222;
    wire _4356;
    wire _4223;
    wire _4360;
    wire [4:0] _3045 = 5'b00000;
    wire [4:0] _3046 = 5'b00000;
    reg [4:0] _3047;
    wire _4224;
    wire _4368;
    wire [31:0] _4384;
    wire _4386;
    wire _2929 = 1'b0;
    wire _2930 = 1'b0;
    reg _2931;
    wire _4387;
    wire [31:0] _4388 = 32'b00000000000000000000000000000000;
    wire [31:0] _4389 = 32'b00000000000000000000000000000000;
    wire [31:0] _3021 = 32'b00000000000000000000000000000000;
    wire [31:0] _3022 = 32'b00000000000000000000000000000000;
    reg [31:0] _3023;
    reg [31:0] reg_01;
    wire [31:0] _4385 = 32'b00000000000000000000000000000000;
    reg [31:0] _4542;
    reg [31:0] _4583;
    wire _4577 = 1'b0;
    wire _4578 = 1'b0;
    wire [4:0] _4218 = 5'b00000;
    wire _4219;
    reg _4579;
    wire _4573 = 1'b0;
    wire _4574 = 1'b0;
    wire [4:0] _4214 = 5'b00000;
    wire _4215;
    reg _4575;
    wire _4569 = 1'b0;
    wire _4570 = 1'b0;
    wire [4:0] _4216 = 5'b00000;
    wire _4217;
    reg _4571;
    wire [4:0] _4565 = 5'b00000;
    wire [4:0] _4566 = 5'b00000;
    wire [4:0] _4213;
    reg [4:0] _4567;
    wire [4:0] _4561 = 5'b00000;
    wire [4:0] _4562 = 5'b00000;
    wire [4:0] _4211;
    reg [4:0] _4563;
    wire [4:0] _4557 = 5'b00000;
    wire [4:0] _4558 = 5'b00000;
    wire [4:0] _4212;
    reg [4:0] _4559;
    wire _4553 = 1'b0;
    wire _4554 = 1'b0;
    wire _4550 = 1'b0;
    wire _4551 = 1'b0;
    wire _2353 = 1'b0;
    wire vdd = 1'b1;
    wire _2354 = 1'b0;
    reg _2355;
    reg _4552;
    reg _4555;

    /* logic */
    always @(posedge clk) begin
        if (clr)
            _2183 <= _2181;
        else
            _2183 <= junk_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _4727 <= _4725;
        else
            _4727 <= _2183;
    end
    always @(posedge clk) begin
        if (clr)
            _2187 <= _2185;
        else
            _2187 <= mio_data_wmask_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _4723 <= _4721;
        else
            _4723 <= _2187;
    end
    always @(posedge clk) begin
        if (clr)
            _2191 <= _2189;
        else
            _2191 <= mio_data_rw_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _4719 <= _4717;
        else
            _4719 <= _2191;
    end
    always @(posedge clk) begin
        if (clr)
            _2195 <= _2193;
        else
            _2195 <= mio_data_req_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _4715 <= _4713;
        else
            _4715 <= _2195;
    end
    always @(posedge clk) begin
        if (clr)
            _2199 <= _2197;
        else
            _2199 <= mio_data_wdata_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _4711 <= _4709;
        else
            _4711 <= _2199;
    end
    always @(posedge clk) begin
        if (clr)
            _2203 <= _2201;
        else
            _2203 <= mio_data_addr_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _4707 <= _4705;
        else
            _4707 <= _2203;
    end
    always @(posedge clk) begin
        if (clr)
            _2207 <= _2205;
        else
            _2207 <= mio_instr_wmask_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _4703 <= _4701;
        else
            _4703 <= _2207;
    end
    always @(posedge clk) begin
        if (clr)
            _2211 <= _2209;
        else
            _2211 <= mio_instr_rw_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _4699 <= _4697;
        else
            _4699 <= _2211;
    end
    always @(posedge clk) begin
        if (clr)
            _2215 <= _2213;
        else
            _2215 <= mio_instr_req_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _4695 <= _4693;
        else
            _4695 <= _2215;
    end
    always @(posedge clk) begin
        if (clr)
            _2219 <= _2217;
        else
            _2219 <= mio_instr_wdata_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _4691 <= _4689;
        else
            _4691 <= _2219;
    end
    always @(posedge clk) begin
        if (clr)
            _2223 <= _2221;
        else
            _2223 <= mio_instr_addr_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _4687 <= _4685;
        else
            _4687 <= _2223;
    end
    always @(posedge clk) begin
        if (clr)
            _4683 <= _4681;
        else
            _4683 <= _2931;
    end
    always @(posedge clk) begin
        if (clr)
            _2231 <= _2229;
        else
            _2231 <= branch_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _4679 <= _4677;
        else
            _4679 <= _2231;
    end
    assign _4148 = mio_instr_rdata[30:30];
    always @(posedge clk) begin
        if (clr)
            _4675 <= _4673;
        else
            _4675 <= _4148;
    end
    always @(posedge clk) begin
        if (clr)
            _4671 <= _4669;
        else
            _4671 <= _3941;
    end
    always @(posedge clk) begin
        if (clr)
            _4667 <= _4665;
        else
            _4667 <= _4040;
    end
    always @(posedge clk) begin
        if (clr)
            _4663 <= _4661;
        else
            _4663 <= _4044;
    end
    always @(posedge clk) begin
        if (clr)
            _4659 <= _4657;
        else
            _4659 <= _4015;
    end
    always @(posedge clk) begin
        if (clr)
            _4655 <= _4653;
        else
            _4655 <= _4013;
    end
    always @(posedge clk) begin
        if (clr)
            _4651 <= _4649;
        else
            _4651 <= _4011;
    end
    always @(posedge clk) begin
        if (clr)
            _4647 <= _4645;
        else
            _4647 <= _4009;
    end
    always @(posedge clk) begin
        if (clr)
            _4643 <= _4641;
        else
            _4643 <= _4007;
    end
    always @(posedge clk) begin
        if (clr)
            _4639 <= _4637;
        else
            _4639 <= _4005;
    end
    always @(posedge clk) begin
        if (clr)
            _4635 <= _4633;
        else
            _4635 <= _4003;
    end
    always @(posedge clk) begin
        if (clr)
            _4631 <= _4629;
        else
            _4631 <= _4001;
    end
    always @(posedge clk) begin
        if (clr)
            _4627 <= _4625;
        else
            _4627 <= _3998;
    end
    always @(posedge clk) begin
        if (clr)
            _4623 <= _4621;
        else
            _4623 <= _3996;
    end
    always @(posedge clk) begin
        if (clr)
            _4619 <= _4617;
        else
            _4619 <= _3994;
    end
    always @(posedge clk) begin
        if (clr)
            _4615 <= _4613;
        else
            _4615 <= _4082;
    end
    assign _4146 = _4003 & _3971;
    assign _4145 = _4003 & _3972;
    assign _4144 = _4003 & _3975;
    assign _4143 = _4003 & _3976;
    assign _4142 = _4003 & _3977;
    assign _4141 = _4003 & _3978;
    assign _4140 = _4005 & _3971;
    assign _4139 = _4005 & _3972;
    assign _4138 = _4005 & _3973;
    assign _4137 = _4005 & _3975;
    assign _4136 = _4005 & _3976;
    assign _4135 = _4007 & _3971;
    assign _4134 = _4007 & _3972;
    assign _4133 = _4007 & _3973;
    assign _4132 = _4009 & _3971;
    assign _4131 = _4009 & _3973;
    assign _4130 = _4009 & _3974;
    assign _4129 = _4009 & _3975;
    assign _4128 = _4009 & _3977;
    assign _4127 = _4009 & _3978;
    assign _4125 = _4009 & _3972;
    assign _4126 = _4125 & _3982;
    assign _4123 = _4009 & _3976;
    assign _4124 = _4123 & _3982;
    assign _4121 = _4009 & _3976;
    assign _4122 = _4121 & _3980;
    assign _4119 = _4011 & _3971;
    assign _4120 = _4119 & _3982;
    assign _4117 = _4011 & _3971;
    assign _4118 = _4117 & _3980;
    assign _4115 = _4011 & _3972;
    assign _4116 = _4115 & _3982;
    assign _4113 = _4011 & _3973;
    assign _4114 = _4113 & _3982;
    assign _4111 = _4011 & _3974;
    assign _4112 = _4111 & _3982;
    assign _3975 = _3970[4:4];
    assign _4109 = _4011 & _3975;
    assign _4110 = _4109 & _3982;
    assign _4107 = _4011 & _3976;
    assign _4108 = _4107 & _3982;
    assign _4105 = _4011 & _3976;
    assign _4106 = _4105 & _3980;
    assign _4103 = _4011 & _3977;
    assign _4104 = _4103 & _3982;
    assign _4101 = _4011 & _3978;
    assign _4102 = _4101 & _3982;
    assign _4099 = _4040 == _4098;
    assign _4100 = _4044 & _4099;
    assign _4096 = _4040 == _4095;
    assign _4097 = _4044 & _4096;
    assign _4093 = _4040 == _4092;
    assign _4094 = _4044 & _4093;
    assign _4090 = _4040 == _4089;
    assign _4091 = _4044 & _4090;
    assign _4087 = _4040 == _4086;
    assign _4088 = _4044 & _4087;
    assign _4038 = _3943[7:7];
    assign _4039 = _3943[1:0];
    assign _4040 = { _4039, _4038 };
    assign _4084 = _4040 == _4083;
    assign _4085 = _4044 & _4084;
    assign _4027 = _3943[6:2];
    assign _4029 = _4027 == _4028;
    assign _4030 = _3943[11:8];
    assign _4032 = _4030 == _4031;
    assign _4033 = _4032 & _4029;
    assign _4034 = _3992 & _3973;
    assign _4035 = _4034 & _4015;
    assign _4036 = _4035 & _4033;
    assign _4037 = _3943[1:0];
    assign _4042 = _4037 == _4041;
    assign _4043 = ~ _4042;
    assign _4044 = _4043 & _4036;
    assign _4019 = _3943 == _4018;
    assign _4025 = _4019 & _4024;
    assign _4015 = _3940 == _4014;
    assign _3984 = mio_instr_rdata[11:7];
    assign _3988 = _3984 == _3987;
    assign _3986 = mio_instr_rdata[19:15];
    assign _3992 = _3986 == _3991;
    assign _4022 = _3992 & _3971;
    assign _4023 = _4022 & _3988;
    assign _4024 = _4023 & _4015;
    assign _3943 = mio_instr_rdata[31:20];
    assign _4021 = _3943 == _4020;
    assign _4026 = _4021 & _4024;
    assign _4016 = _4013 & _3972;
    assign _4013 = _3940 == _4012;
    assign _4017 = _4013 & _3971;
    assign _4056 = ~ _4055;
    assign _4057 = _4056 & _3982;
    assign _4055 = _3971 | _3976;
    assign _4058 = _4055 & _3983;
    assign _4059 = _4058 | _4057;
    assign _4011 = _3940 == _4010;
    assign _4060 = _4011 & _4059;
    assign _3980 = _3942 == _3979;
    assign _3983 = _3982 | _3980;
    assign _4061 = _3976 & _3983;
    assign _3942 = mio_instr_rdata[31:25];
    assign _3982 = _3942 == _3981;
    assign _4062 = _3972 & _3982;
    assign _4063 = _4062 | _4061;
    assign _4064 = _4009 & _4063;
    assign _3976 = _3970[5:5];
    assign _4065 = _3972 | _3976;
    assign _4066 = ~ _4065;
    assign _4067 = _4009 & _4066;
    assign _3972 = _3970[1:1];
    assign _4052 = _3971 | _3972;
    assign _4053 = _4052 | _3973;
    assign _4054 = _4007 & _4053;
    assign _3978 = _3970[7:7];
    assign _3977 = _3970[6:6];
    assign _4048 = _3974 | _3977;
    assign _4049 = _4048 | _3978;
    assign _4050 = ~ _4049;
    assign _4051 = _4005 & _4050;
    assign _3974 = _3970[3:3];
    assign _3973 = _3970[2:2];
    assign _4045 = _3973 | _3974;
    assign _4046 = ~ _4045;
    assign _4047 = _4003 & _4046;
    assign _4068 = _3994 | _3996;
    assign _4069 = _4068 | _3998;
    assign _4070 = _4069 | _4001;
    assign _4071 = _4070 | _4047;
    assign _4072 = _4071 | _4051;
    assign _4073 = _4072 | _4054;
    assign _4074 = _4073 | _4067;
    assign _4075 = _4074 | _4064;
    assign _4076 = _4075 | _4060;
    assign _4077 = _4076 | _4017;
    assign _4078 = _4077 | _4016;
    assign _4079 = _4078 | _4026;
    assign _4080 = _4079 | _4025;
    assign _4081 = _4080 | _4044;
    assign _4082 = ~ _4081;
    assign _4147 = { _4082, _4085, _4088, _4091, _4094, _4097, _4100, _4025, _4026, _4016, _4017, _4102, _4104, _4106, _4108, _4110, _4112, _4114, _4116, _4118, _4120, _4122, _4124, _4126, _4127, _4128, _4129, _4130, _4131, _4132, _4133, _4134, _4135, _4136, _4137, _4138, _4139, _4140, _4141, _4142, _4143, _4144, _4145, _4146, _4001, _3998, _3996, _3994 };
    always @(posedge clk) begin
        if (clr)
            _4611 <= _4609;
        else
            _4611 <= _4147;
    end
    always @(posedge clk) begin
        if (clr)
            _4607 <= _4605;
        else
            _4607 <= mio_instr_rdata;
    end
    always @(posedge clk) begin
        if (clr)
            _2307 <= _2305;
        else
            _2307 <= pc_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _4603 <= _4601;
        else
            _4603 <= _2307;
    end
    always @(posedge clk) begin
        if (clr)
            _4599 <= _4597;
        else
            _4599 <= _4210;
    end
    always @(posedge clk) begin
        if (clr)
            _4595 <= _4593;
        else
            _4595 <= _4541;
    end
    always @(posedge clk) begin
        if (clr)
            _4591 <= _4589;
        else
            _4591 <= _3023;
    end
    assign _4163 = _4158[0:0];
    assign _4160 = _4158[19:10];
    assign _4161 = _4158[9:9];
    assign _4162 = _4158[8:1];
    assign _4153 = { _4152, _4151 };
    assign _4149 = mio_instr_rdata[31:12];
    assign _4150 = { _4149, gnd };
    assign _4151 = _4150[20:20];
    assign _4152 = { _4151, _4151 };
    assign _4154 = { _4152, _4152 };
    assign _4155 = { _4154, _4154 };
    assign _4156 = { _4155, _4153 };
    assign _4158 = { _4156, _4150 };
    assign _4159 = _4158[31:20];
    assign _4164 = { _4159, _4162, _4161, _4160, _4163 };
    assign _4203 = mio_instr_rdata[31:12];
    assign _4204 = { _4203, _4202 };
    assign _4191 = mio_instr_rdata[31:20];
    assign _4192 = _4191[11:11];
    assign _4193 = { _4192, _4192 };
    assign _4194 = { _4193, _4193 };
    assign _4195 = { _4194, _4194 };
    assign _4196 = { _4195, _4195 };
    assign _4197 = { _4196, _4194 };
    assign _4199 = { _4197, _4191 };
    assign _4184 = { _4183, _4182 };
    assign _4180 = mio_instr_rdata[11:8];
    assign _4179 = mio_instr_rdata[30:25];
    assign _4178 = mio_instr_rdata[7:7];
    assign _4177 = mio_instr_rdata[31:31];
    assign _4181 = { _4177, _4178, _4179, _4180, gnd };
    assign _4182 = _4181[12:12];
    assign _4183 = { _4182, _4182 };
    assign _4185 = { _4183, _4183 };
    assign _4186 = { _4185, _4185 };
    assign _4187 = { _4186, _4186 };
    assign _4188 = { _4187, _4184 };
    assign _4190 = { _4188, _4181 };
    assign _4167 = mio_instr_rdata[11:7];
    assign _4166 = mio_instr_rdata[31:25];
    assign _4168 = { _4166, _4167 };
    assign _4169 = _4168[11:11];
    assign _4170 = { _4169, _4169 };
    assign _4171 = { _4170, _4170 };
    assign _4172 = { _4171, _4171 };
    assign _4173 = { _4172, _4172 };
    assign _4174 = { _4173, _4171 };
    assign _4176 = { _4174, _4168 };
    assign _4206 = _4007 ? _4176 : _4165;
    assign _4003 = _3940 == _4002;
    assign _4207 = _4003 ? _4190 : _4206;
    assign _4200 = _4001 | _4005;
    assign _4201 = _4200 | _4009;
    assign _4208 = _4201 ? _4199 : _4207;
    assign _4205 = _3994 | _3996;
    assign _4209 = _4205 ? _4204 : _4208;
    assign _4210 = _3998 ? _4164 : _4209;
    always @* begin
        case (_4211)
        0: _4541 <= _4385;
        1: _4541 <= reg_01;
        2: _4541 <= reg_02;
        3: _4541 <= reg_03;
        4: _4541 <= reg_04;
        5: _4541 <= reg_05;
        6: _4541 <= reg_06;
        7: _4541 <= reg_07;
        8: _4541 <= reg_08;
        9: _4541 <= reg_09;
        10: _4541 <= reg_10;
        11: _4541 <= reg_11;
        12: _4541 <= reg_12;
        13: _4541 <= reg_13;
        14: _4541 <= reg_14;
        15: _4541 <= reg_15;
        16: _4541 <= reg_16;
        17: _4541 <= reg_17;
        18: _4541 <= reg_18;
        19: _4541 <= reg_19;
        20: _4541 <= reg_20;
        21: _4541 <= reg_21;
        22: _4541 <= reg_22;
        23: _4541 <= reg_23;
        24: _4541 <= reg_24;
        25: _4541 <= reg_25;
        26: _4541 <= reg_26;
        27: _4541 <= reg_27;
        28: _4541 <= reg_28;
        29: _4541 <= reg_29;
        30: _4541 <= reg_30;
        default: _4541 <= reg_31;
        endcase
    end
    assign _3947 = ~ _3944;
    assign _3950 = _3948 & _3947;
    assign _3958 = _3954 & _3950;
    assign _3948 = ~ _3945;
    assign _3949 = _3948 & _3944;
    assign _3957 = _3954 & _3949;
    assign _3951 = ~ _3944;
    assign _3953 = _3945 & _3951;
    assign _3956 = _3954 & _3953;
    assign _3952 = _3945 & _3944;
    assign _3954 = ~ _3946;
    assign _3955 = _3954 & _3952;
    assign _3959 = ~ _3944;
    assign _3962 = _3960 & _3959;
    assign _3969 = _3946 & _3962;
    assign _3960 = ~ _3945;
    assign _3961 = _3960 & _3944;
    assign _3968 = _3946 & _3961;
    assign _3963 = ~ _3944;
    assign _3965 = _3945 & _3963;
    assign _3967 = _3946 & _3965;
    assign _3944 = _3941[0:0];
    assign _3945 = _3941[1:1];
    assign _3964 = _3945 & _3944;
    assign _3941 = mio_instr_rdata[14:12];
    assign _3946 = _3941[2:2];
    assign _3966 = _3946 & _3964;
    assign _3970 = { _3966, _3967, _3968, _3969, _3955, _3956, _3957, _3958 };
    assign _3971 = _3970[0:0];
    assign _4000 = _3940 == _3999;
    assign _4001 = _4000 & _3971;
    assign _3998 = _3940 == _3997;
    assign _4007 = _3940 == _4006;
    assign _4005 = _3940 == _4004;
    assign _3996 = _3940 == _3995;
    assign _3994 = _3940 == _3993;
    assign _3940 = mio_instr_rdata[6:0];
    assign _4009 = _3940 == _4008;
    assign _4543 = _4009 | _3994;
    assign _4544 = _4543 | _3996;
    assign _4545 = _4544 | _4005;
    assign _4546 = _4545 | _4007;
    assign _4547 = _4546 | _3998;
    assign _4548 = _4547 | _4001;
    assign _4549 = _4548 ? _4210 : _4541;
    always @(posedge clk) begin
        if (clr)
            _4587 <= _4585;
        else
            _4587 <= _4549;
    end
    assign _4536 = _4384[31:31];
    assign _4537 = _2931 & _4536;
    always @(posedge clk) begin
        if (clr)
            reg_31 <= _4538;
        else
            if (_4537)
                reg_31 <= _3023;
    end
    assign _4531 = _4384[30:30];
    assign _4532 = _2931 & _4531;
    always @(posedge clk) begin
        if (clr)
            reg_30 <= _4533;
        else
            if (_4532)
                reg_30 <= _3023;
    end
    assign _4526 = _4384[29:29];
    assign _4527 = _2931 & _4526;
    always @(posedge clk) begin
        if (clr)
            reg_29 <= _4528;
        else
            if (_4527)
                reg_29 <= _3023;
    end
    assign _4521 = _4384[28:28];
    assign _4522 = _2931 & _4521;
    always @(posedge clk) begin
        if (clr)
            reg_28 <= _4523;
        else
            if (_4522)
                reg_28 <= _3023;
    end
    assign _4516 = _4384[27:27];
    assign _4517 = _2931 & _4516;
    always @(posedge clk) begin
        if (clr)
            reg_27 <= _4518;
        else
            if (_4517)
                reg_27 <= _3023;
    end
    assign _4511 = _4384[26:26];
    assign _4512 = _2931 & _4511;
    always @(posedge clk) begin
        if (clr)
            reg_26 <= _4513;
        else
            if (_4512)
                reg_26 <= _3023;
    end
    assign _4506 = _4384[25:25];
    assign _4507 = _2931 & _4506;
    always @(posedge clk) begin
        if (clr)
            reg_25 <= _4508;
        else
            if (_4507)
                reg_25 <= _3023;
    end
    assign _4501 = _4384[24:24];
    assign _4502 = _2931 & _4501;
    always @(posedge clk) begin
        if (clr)
            reg_24 <= _4503;
        else
            if (_4502)
                reg_24 <= _3023;
    end
    assign _4496 = _4384[23:23];
    assign _4497 = _2931 & _4496;
    always @(posedge clk) begin
        if (clr)
            reg_23 <= _4498;
        else
            if (_4497)
                reg_23 <= _3023;
    end
    assign _4491 = _4384[22:22];
    assign _4492 = _2931 & _4491;
    always @(posedge clk) begin
        if (clr)
            reg_22 <= _4493;
        else
            if (_4492)
                reg_22 <= _3023;
    end
    assign _4486 = _4384[21:21];
    assign _4487 = _2931 & _4486;
    always @(posedge clk) begin
        if (clr)
            reg_21 <= _4488;
        else
            if (_4487)
                reg_21 <= _3023;
    end
    assign _4481 = _4384[20:20];
    assign _4482 = _2931 & _4481;
    always @(posedge clk) begin
        if (clr)
            reg_20 <= _4483;
        else
            if (_4482)
                reg_20 <= _3023;
    end
    assign _4476 = _4384[19:19];
    assign _4477 = _2931 & _4476;
    always @(posedge clk) begin
        if (clr)
            reg_19 <= _4478;
        else
            if (_4477)
                reg_19 <= _3023;
    end
    assign _4471 = _4384[18:18];
    assign _4472 = _2931 & _4471;
    always @(posedge clk) begin
        if (clr)
            reg_18 <= _4473;
        else
            if (_4472)
                reg_18 <= _3023;
    end
    assign _4466 = _4384[17:17];
    assign _4467 = _2931 & _4466;
    always @(posedge clk) begin
        if (clr)
            reg_17 <= _4468;
        else
            if (_4467)
                reg_17 <= _3023;
    end
    assign _4461 = _4384[16:16];
    assign _4462 = _2931 & _4461;
    always @(posedge clk) begin
        if (clr)
            reg_16 <= _4463;
        else
            if (_4462)
                reg_16 <= _3023;
    end
    assign _4456 = _4384[15:15];
    assign _4457 = _2931 & _4456;
    always @(posedge clk) begin
        if (clr)
            reg_15 <= _4458;
        else
            if (_4457)
                reg_15 <= _3023;
    end
    assign _4451 = _4384[14:14];
    assign _4452 = _2931 & _4451;
    always @(posedge clk) begin
        if (clr)
            reg_14 <= _4453;
        else
            if (_4452)
                reg_14 <= _3023;
    end
    assign _4446 = _4384[13:13];
    assign _4447 = _2931 & _4446;
    always @(posedge clk) begin
        if (clr)
            reg_13 <= _4448;
        else
            if (_4447)
                reg_13 <= _3023;
    end
    assign _4441 = _4384[12:12];
    assign _4442 = _2931 & _4441;
    always @(posedge clk) begin
        if (clr)
            reg_12 <= _4443;
        else
            if (_4442)
                reg_12 <= _3023;
    end
    assign _4436 = _4384[11:11];
    assign _4437 = _2931 & _4436;
    always @(posedge clk) begin
        if (clr)
            reg_11 <= _4438;
        else
            if (_4437)
                reg_11 <= _3023;
    end
    assign _4431 = _4384[10:10];
    assign _4432 = _2931 & _4431;
    always @(posedge clk) begin
        if (clr)
            reg_10 <= _4433;
        else
            if (_4432)
                reg_10 <= _3023;
    end
    assign _4426 = _4384[9:9];
    assign _4427 = _2931 & _4426;
    always @(posedge clk) begin
        if (clr)
            reg_09 <= _4428;
        else
            if (_4427)
                reg_09 <= _3023;
    end
    assign _4421 = _4384[8:8];
    assign _4422 = _2931 & _4421;
    always @(posedge clk) begin
        if (clr)
            reg_08 <= _4423;
        else
            if (_4422)
                reg_08 <= _3023;
    end
    assign _4416 = _4384[7:7];
    assign _4417 = _2931 & _4416;
    always @(posedge clk) begin
        if (clr)
            reg_07 <= _4418;
        else
            if (_4417)
                reg_07 <= _3023;
    end
    assign _4411 = _4384[6:6];
    assign _4412 = _2931 & _4411;
    always @(posedge clk) begin
        if (clr)
            reg_06 <= _4413;
        else
            if (_4412)
                reg_06 <= _3023;
    end
    assign _4406 = _4384[5:5];
    assign _4407 = _2931 & _4406;
    always @(posedge clk) begin
        if (clr)
            reg_05 <= _4408;
        else
            if (_4407)
                reg_05 <= _3023;
    end
    assign _4401 = _4384[4:4];
    assign _4402 = _2931 & _4401;
    always @(posedge clk) begin
        if (clr)
            reg_04 <= _4403;
        else
            if (_4402)
                reg_04 <= _3023;
    end
    assign _4396 = _4384[3:3];
    assign _4397 = _2931 & _4396;
    always @(posedge clk) begin
        if (clr)
            reg_03 <= _4398;
        else
            if (_4397)
                reg_03 <= _3023;
    end
    assign _4391 = _4384[2:2];
    assign _4392 = _2931 & _4391;
    always @(posedge clk) begin
        if (clr)
            reg_02 <= _4393;
        else
            if (_4392)
                reg_02 <= _3023;
    end
    assign _4225 = ~ _4220;
    assign _4228 = _4226 & _4225;
    assign _4236 = _4232 & _4228;
    assign _4256 = _4248 & _4236;
    assign _4304 = _4288 & _4256;
    assign _4226 = ~ _4221;
    assign _4227 = _4226 & _4220;
    assign _4235 = _4232 & _4227;
    assign _4255 = _4248 & _4235;
    assign _4303 = _4288 & _4255;
    assign _4229 = ~ _4220;
    assign _4231 = _4221 & _4229;
    assign _4234 = _4232 & _4231;
    assign _4254 = _4248 & _4234;
    assign _4302 = _4288 & _4254;
    assign _4230 = _4221 & _4220;
    assign _4232 = ~ _4222;
    assign _4233 = _4232 & _4230;
    assign _4253 = _4248 & _4233;
    assign _4301 = _4288 & _4253;
    assign _4237 = ~ _4220;
    assign _4240 = _4238 & _4237;
    assign _4247 = _4222 & _4240;
    assign _4252 = _4248 & _4247;
    assign _4300 = _4288 & _4252;
    assign _4238 = ~ _4221;
    assign _4239 = _4238 & _4220;
    assign _4246 = _4222 & _4239;
    assign _4251 = _4248 & _4246;
    assign _4299 = _4288 & _4251;
    assign _4241 = ~ _4220;
    assign _4243 = _4221 & _4241;
    assign _4245 = _4222 & _4243;
    assign _4250 = _4248 & _4245;
    assign _4298 = _4288 & _4250;
    assign _4242 = _4221 & _4220;
    assign _4244 = _4222 & _4242;
    assign _4248 = ~ _4223;
    assign _4249 = _4248 & _4244;
    assign _4297 = _4288 & _4249;
    assign _4257 = ~ _4220;
    assign _4260 = _4258 & _4257;
    assign _4268 = _4264 & _4260;
    assign _4287 = _4223 & _4268;
    assign _4296 = _4288 & _4287;
    assign _4258 = ~ _4221;
    assign _4259 = _4258 & _4220;
    assign _4267 = _4264 & _4259;
    assign _4286 = _4223 & _4267;
    assign _4295 = _4288 & _4286;
    assign _4261 = ~ _4220;
    assign _4263 = _4221 & _4261;
    assign _4266 = _4264 & _4263;
    assign _4285 = _4223 & _4266;
    assign _4294 = _4288 & _4285;
    assign _4262 = _4221 & _4220;
    assign _4264 = ~ _4222;
    assign _4265 = _4264 & _4262;
    assign _4284 = _4223 & _4265;
    assign _4293 = _4288 & _4284;
    assign _4269 = ~ _4220;
    assign _4272 = _4270 & _4269;
    assign _4279 = _4222 & _4272;
    assign _4283 = _4223 & _4279;
    assign _4292 = _4288 & _4283;
    assign _4270 = ~ _4221;
    assign _4271 = _4270 & _4220;
    assign _4278 = _4222 & _4271;
    assign _4282 = _4223 & _4278;
    assign _4291 = _4288 & _4282;
    assign _4273 = ~ _4220;
    assign _4275 = _4221 & _4273;
    assign _4277 = _4222 & _4275;
    assign _4281 = _4223 & _4277;
    assign _4290 = _4288 & _4281;
    assign _4274 = _4221 & _4220;
    assign _4276 = _4222 & _4274;
    assign _4280 = _4223 & _4276;
    assign _4288 = ~ _4224;
    assign _4289 = _4288 & _4280;
    assign _4305 = ~ _4220;
    assign _4308 = _4306 & _4305;
    assign _4316 = _4312 & _4308;
    assign _4336 = _4328 & _4316;
    assign _4383 = _4224 & _4336;
    assign _4306 = ~ _4221;
    assign _4307 = _4306 & _4220;
    assign _4315 = _4312 & _4307;
    assign _4335 = _4328 & _4315;
    assign _4382 = _4224 & _4335;
    assign _4309 = ~ _4220;
    assign _4311 = _4221 & _4309;
    assign _4314 = _4312 & _4311;
    assign _4334 = _4328 & _4314;
    assign _4381 = _4224 & _4334;
    assign _4310 = _4221 & _4220;
    assign _4312 = ~ _4222;
    assign _4313 = _4312 & _4310;
    assign _4333 = _4328 & _4313;
    assign _4380 = _4224 & _4333;
    assign _4317 = ~ _4220;
    assign _4320 = _4318 & _4317;
    assign _4327 = _4222 & _4320;
    assign _4332 = _4328 & _4327;
    assign _4379 = _4224 & _4332;
    assign _4318 = ~ _4221;
    assign _4319 = _4318 & _4220;
    assign _4326 = _4222 & _4319;
    assign _4331 = _4328 & _4326;
    assign _4378 = _4224 & _4331;
    assign _4321 = ~ _4220;
    assign _4323 = _4221 & _4321;
    assign _4325 = _4222 & _4323;
    assign _4330 = _4328 & _4325;
    assign _4377 = _4224 & _4330;
    assign _4322 = _4221 & _4220;
    assign _4324 = _4222 & _4322;
    assign _4328 = ~ _4223;
    assign _4329 = _4328 & _4324;
    assign _4376 = _4224 & _4329;
    assign _4337 = ~ _4220;
    assign _4340 = _4338 & _4337;
    assign _4348 = _4344 & _4340;
    assign _4367 = _4223 & _4348;
    assign _4375 = _4224 & _4367;
    assign _4338 = ~ _4221;
    assign _4339 = _4338 & _4220;
    assign _4347 = _4344 & _4339;
    assign _4366 = _4223 & _4347;
    assign _4374 = _4224 & _4366;
    assign _4341 = ~ _4220;
    assign _4343 = _4221 & _4341;
    assign _4346 = _4344 & _4343;
    assign _4365 = _4223 & _4346;
    assign _4373 = _4224 & _4365;
    assign _4342 = _4221 & _4220;
    assign _4344 = ~ _4222;
    assign _4345 = _4344 & _4342;
    assign _4364 = _4223 & _4345;
    assign _4372 = _4224 & _4364;
    assign _4349 = ~ _4220;
    assign _4352 = _4350 & _4349;
    assign _4359 = _4222 & _4352;
    assign _4363 = _4223 & _4359;
    assign _4371 = _4224 & _4363;
    assign _4350 = ~ _4221;
    assign _4351 = _4350 & _4220;
    assign _4358 = _4222 & _4351;
    assign _4362 = _4223 & _4358;
    assign _4370 = _4224 & _4362;
    assign _4353 = ~ _4220;
    assign _4355 = _4221 & _4353;
    assign _4357 = _4222 & _4355;
    assign _4361 = _4223 & _4357;
    assign _4369 = _4224 & _4361;
    assign _4220 = _3047[0:0];
    assign _4221 = _3047[1:1];
    assign _4354 = _4221 & _4220;
    assign _4222 = _3047[2:2];
    assign _4356 = _4222 & _4354;
    assign _4223 = _3047[3:3];
    assign _4360 = _4223 & _4356;
    always @(posedge clk) begin
        if (clr)
            _3047 <= _3045;
        else
            _3047 <= rad_p_4;
    end
    assign _4224 = _3047[4:4];
    assign _4368 = _4224 & _4360;
    assign _4384 = { _4368, _4369, _4370, _4371, _4372, _4373, _4374, _4375, _4376, _4377, _4378, _4379, _4380, _4381, _4382, _4383, _4289, _4290, _4291, _4292, _4293, _4294, _4295, _4296, _4297, _4298, _4299, _4300, _4301, _4302, _4303, _4304 };
    assign _4386 = _4384[1:1];
    always @(posedge clk) begin
        if (clr)
            _2931 <= _2929;
        else
            _2931 <= rwe_p_4;
    end
    assign _4387 = _2931 & _4386;
    always @(posedge clk) begin
        if (clr)
            _3023 <= _3021;
        else
            _3023 <= rdd_p_4;
    end
    always @(posedge clk) begin
        if (clr)
            reg_01 <= _4388;
        else
            if (_4387)
                reg_01 <= _3023;
    end
    always @* begin
        case (_4212)
        0: _4542 <= _4385;
        1: _4542 <= reg_01;
        2: _4542 <= reg_02;
        3: _4542 <= reg_03;
        4: _4542 <= reg_04;
        5: _4542 <= reg_05;
        6: _4542 <= reg_06;
        7: _4542 <= reg_07;
        8: _4542 <= reg_08;
        9: _4542 <= reg_09;
        10: _4542 <= reg_10;
        11: _4542 <= reg_11;
        12: _4542 <= reg_12;
        13: _4542 <= reg_13;
        14: _4542 <= reg_14;
        15: _4542 <= reg_15;
        16: _4542 <= reg_16;
        17: _4542 <= reg_17;
        18: _4542 <= reg_18;
        19: _4542 <= reg_19;
        20: _4542 <= reg_20;
        21: _4542 <= reg_21;
        22: _4542 <= reg_22;
        23: _4542 <= reg_23;
        24: _4542 <= reg_24;
        25: _4542 <= reg_25;
        26: _4542 <= reg_26;
        27: _4542 <= reg_27;
        28: _4542 <= reg_28;
        29: _4542 <= reg_29;
        30: _4542 <= reg_30;
        default: _4542 <= reg_31;
        endcase
    end
    always @(posedge clk) begin
        if (clr)
            _4583 <= _4581;
        else
            _4583 <= _4542;
    end
    assign _4219 = _4213 == _4218;
    always @(posedge clk) begin
        if (clr)
            _4579 <= _4577;
        else
            _4579 <= _4219;
    end
    assign _4215 = _4211 == _4214;
    always @(posedge clk) begin
        if (clr)
            _4575 <= _4573;
        else
            _4575 <= _4215;
    end
    assign _4217 = _4212 == _4216;
    always @(posedge clk) begin
        if (clr)
            _4571 <= _4569;
        else
            _4571 <= _4217;
    end
    assign _4213 = mio_instr_rdata[11:7];
    always @(posedge clk) begin
        if (clr)
            _4567 <= _4565;
        else
            _4567 <= _4213;
    end
    assign _4211 = mio_instr_rdata[24:20];
    always @(posedge clk) begin
        if (clr)
            _4563 <= _4561;
        else
            _4563 <= _4211;
    end
    assign _4212 = mio_instr_rdata[19:15];
    always @(posedge clk) begin
        if (clr)
            _4559 <= _4557;
        else
            _4559 <= _4212;
    end
    always @(posedge clk) begin
        if (clr)
            _2355 <= _2353;
        else
            _2355 <= pen_p_0;
    end
    always @(posedge clk) begin
        if (clr)
            _4552 <= _4550;
        else
            _4552 <= _2355;
    end
    always @(posedge clk) begin
        if (clr)
            _4555 <= _4553;
        else
            _4555 <= _4552;
    end

    /* aliases */

    /* output assignments */
    assign pen = _4555;
    assign ra1 = _4559;
    assign ra2 = _4563;
    assign rad = _4567;
    assign ra1_zero = _4571;
    assign ra2_zero = _4575;
    assign rad_zero = _4579;
    assign rd1 = _4583;
    assign rd2 = _4587;
    assign rdd = _4591;
    assign rdm = _4595;
    assign imm = _4599;
    assign pc = _4603;
    assign instr = _4607;
    assign insn = _4611;
    assign trap = _4615;
    assign lui = _4619;
    assign auipc = _4623;
    assign jal = _4627;
    assign jalr = _4631;
    assign bra = _4635;
    assign ld = _4639;
    assign st = _4643;
    assign opi = _4647;
    assign opr = _4651;
    assign fen = _4655;
    assign sys = _4659;
    assign rdc = _4663;
    assign rdco = _4667;
    assign f3 = _4671;
    assign f7 = _4675;
    assign branch = _4679;
    assign rwe = _4683;
    assign mio_instr_addr = _4687;
    assign mio_instr_wdata = _4691;
    assign mio_instr_req = _4695;
    assign mio_instr_rw = _4699;
    assign mio_instr_wmask = _4703;
    assign mio_data_addr = _4707;
    assign mio_data_wdata = _4711;
    assign mio_data_req = _4715;
    assign mio_data_rw = _4719;
    assign mio_data_wmask = _4723;
    assign junk = _4727;

endmodule
