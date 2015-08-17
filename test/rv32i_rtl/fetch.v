module fetch (
    mio_vld,
    mio_rdata,
    clr,
    clk,
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

    input mio_vld;
    input [31:0] mio_rdata;
    input clr;
    input clk;
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
    wire _1017 = 1'b0;
    wire _1018 = 1'b0;
    wire _852;
    wire _853;
    wire _854;
    wire _855;
    wire _856;
    wire _857;
    wire _858;
    wire _859;
    wire _860;
    wire _861;
    wire _862;
    wire _863;
    wire _864;
    wire _865;
    wire _866;
    wire _867;
    wire _868;
    wire _869;
    wire _870;
    wire _871;
    wire _872;
    wire _873;
    wire _874;
    wire _875;
    wire _876;
    wire _877;
    wire _878;
    wire _879;
    wire _880;
    wire _881;
    wire _882;
    wire _883;
    wire _884;
    wire _885;
    wire [34:0] _851;
    wire _886;
    wire _887;
    wire _888;
    wire _889;
    wire _890;
    wire _891;
    wire _892;
    wire _893;
    wire _894;
    wire _895;
    wire _896;
    wire _897;
    wire _898;
    wire _899;
    wire _900;
    wire _901;
    wire _902;
    wire _903;
    wire _904;
    wire _905;
    wire _906;
    wire _907;
    wire _908;
    wire _909;
    wire _910;
    wire _911;
    wire _912;
    wire _913;
    wire _914;
    wire _915;
    wire _916;
    wire _917;
    wire _918;
    wire _919;
    wire _920;
    reg _1019;
    wire _1013 = 1'b0;
    wire _1014 = 1'b0;
    wire _922 = 1'b0;
    reg _1015;
    wire [31:0] _1009 = 32'b00000000000000000000000000000000;
    wire [31:0] _1010 = 32'b00000000000000000000000000000000;
    wire [31:0] _923 = 32'b00000000000000000000000000000000;
    reg [31:0] _1011;
    wire [5:0] _1005 = 6'b000000;
    wire [5:0] _1006 = 6'b000000;
    wire [5:0] _924 = 6'b000000;
    reg [5:0] _1007;
    wire [14:0] _1001 = 15'b000000000000000;
    wire [14:0] _1002 = 15'b000000000000000;
    wire [14:0] _925 = 15'b000000000000000;
    reg [14:0] _1003;
    wire [47:0] _997 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _998 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _926 = 48'b000000000000000000000000000000000000000000000000;
    reg [47:0] _999;
    wire [31:0] _993 = 32'b00000000000000000000000000000000;
    wire [31:0] _994 = 32'b00000000000000000000000000000000;
    wire [31:0] _927 = 32'b00000000000000000000000000000000;
    reg [31:0] _995;
    wire [31:0] _989 = 32'b00000000000000000000000000000000;
    wire [31:0] _990 = 32'b00000000000000000000000000000000;
    wire [31:0] _928 = 32'b00000000000000000000000000000000;
    reg [31:0] _991;
    wire [31:0] _985 = 32'b00000000000000000000000000000000;
    wire [31:0] _986 = 32'b00000000000000000000000000000000;
    wire [31:0] _845 = 32'b00000000000000000000000000010000;
    wire [31:0] _847 = 32'b00000000000000000000000000000000;
    wire [31:0] _849 = 32'b00000000000000000000000000000100;
    wire [31:0] _850;
    wire [31:0] _846;
    reg [31:0] fetch_pc;
    reg [31:0] _987;
    wire [31:0] _981 = 32'b00000000000000000000000000000000;
    wire [31:0] _982 = 32'b00000000000000000000000000000000;
    wire [31:0] _930 = 32'b00000000000000000000000000000000;
    reg [31:0] _983;
    wire [31:0] _977 = 32'b00000000000000000000000000000000;
    wire [31:0] _978 = 32'b00000000000000000000000000000000;
    wire [31:0] _931 = 32'b00000000000000000000000000000000;
    reg [31:0] _979;
    wire [31:0] _973 = 32'b00000000000000000000000000000000;
    wire [31:0] _974 = 32'b00000000000000000000000000000000;
    wire [31:0] _932 = 32'b00000000000000000000000000000000;
    reg [31:0] _975;
    wire [31:0] _969 = 32'b00000000000000000000000000000000;
    wire [31:0] _970 = 32'b00000000000000000000000000000000;
    wire [31:0] _933 = 32'b00000000000000000000000000000000;
    reg [31:0] _971;
    wire _965 = 1'b0;
    wire _966 = 1'b0;
    wire _934 = 1'b0;
    reg _967;
    wire _961 = 1'b0;
    wire _962 = 1'b0;
    wire _935 = 1'b0;
    reg _963;
    wire _957 = 1'b0;
    wire _958 = 1'b0;
    wire _936 = 1'b0;
    reg _959;
    wire [4:0] _953 = 5'b00000;
    wire [4:0] _954 = 5'b00000;
    wire [4:0] _937 = 5'b00000;
    reg [4:0] _955;
    wire [4:0] _949 = 5'b00000;
    wire [4:0] _950 = 5'b00000;
    wire [4:0] _938 = 5'b00000;
    reg [4:0] _951;
    wire [4:0] _945 = 5'b00000;
    wire [4:0] _946 = 5'b00000;
    wire [4:0] _939 = 5'b00000;
    reg [4:0] _947;
    wire _941 = 1'b0;
    wire _942 = 1'b0;
    wire vdd = 1'b1;
    reg _943;

    /* logic */
    assign _852 = _851[0:0];
    assign _853 = _851[1:1];
    assign _854 = _851[2:2];
    assign _855 = _851[3:3];
    assign _856 = _851[4:4];
    assign _857 = _851[5:5];
    assign _858 = _851[6:6];
    assign _859 = _851[7:7];
    assign _860 = _851[8:8];
    assign _861 = _851[9:9];
    assign _862 = _851[10:10];
    assign _863 = _851[11:11];
    assign _864 = _851[12:12];
    assign _865 = _851[13:13];
    assign _866 = _851[14:14];
    assign _867 = _851[15:15];
    assign _868 = _851[16:16];
    assign _869 = _851[17:17];
    assign _870 = _851[18:18];
    assign _871 = _851[19:19];
    assign _872 = _851[20:20];
    assign _873 = _851[21:21];
    assign _874 = _851[22:22];
    assign _875 = _851[23:23];
    assign _876 = _851[24:24];
    assign _877 = _851[25:25];
    assign _878 = _851[26:26];
    assign _879 = _851[27:27];
    assign _880 = _851[28:28];
    assign _881 = _851[29:29];
    assign _882 = _851[30:30];
    assign _883 = _851[31:31];
    assign _884 = _851[32:32];
    assign _885 = _851[33:33];
    assign _851 = { clk, clr, mio_rdata, mio_vld };
    assign _886 = _851[34:34];
    assign _887 = _886 | _885;
    assign _888 = _887 | _884;
    assign _889 = _888 | _883;
    assign _890 = _889 | _882;
    assign _891 = _890 | _881;
    assign _892 = _891 | _880;
    assign _893 = _892 | _879;
    assign _894 = _893 | _878;
    assign _895 = _894 | _877;
    assign _896 = _895 | _876;
    assign _897 = _896 | _875;
    assign _898 = _897 | _874;
    assign _899 = _898 | _873;
    assign _900 = _899 | _872;
    assign _901 = _900 | _871;
    assign _902 = _901 | _870;
    assign _903 = _902 | _869;
    assign _904 = _903 | _868;
    assign _905 = _904 | _867;
    assign _906 = _905 | _866;
    assign _907 = _906 | _865;
    assign _908 = _907 | _864;
    assign _909 = _908 | _863;
    assign _910 = _909 | _862;
    assign _911 = _910 | _861;
    assign _912 = _911 | _860;
    assign _913 = _912 | _859;
    assign _914 = _913 | _858;
    assign _915 = _914 | _857;
    assign _916 = _915 | _856;
    assign _917 = _916 | _855;
    assign _918 = _917 | _854;
    assign _919 = _918 | _853;
    assign _920 = _919 | _852;
    always @(posedge clk) begin
        if (clr)
            _1019 <= _1017;
        else
            _1019 <= _920;
    end
    always @(posedge clk) begin
        if (clr)
            _1015 <= _1013;
        else
            _1015 <= _922;
    end
    always @(posedge clk) begin
        if (clr)
            _1011 <= _1009;
        else
            _1011 <= _923;
    end
    always @(posedge clk) begin
        if (clr)
            _1007 <= _1005;
        else
            _1007 <= _924;
    end
    always @(posedge clk) begin
        if (clr)
            _1003 <= _1001;
        else
            _1003 <= _925;
    end
    always @(posedge clk) begin
        if (clr)
            _999 <= _997;
        else
            _999 <= _926;
    end
    always @(posedge clk) begin
        if (clr)
            _995 <= _993;
        else
            _995 <= _927;
    end
    always @(posedge clk) begin
        if (clr)
            _991 <= _989;
        else
            _991 <= _928;
    end
    assign _850 = fetch_pc + _849;
    assign _846 = _850;
    always @(posedge clk) begin
        if (clr)
            fetch_pc <= _845;
        else
            fetch_pc <= _846;
    end
    always @(posedge clk) begin
        if (clr)
            _987 <= _985;
        else
            _987 <= fetch_pc;
    end
    always @(posedge clk) begin
        if (clr)
            _983 <= _981;
        else
            _983 <= _930;
    end
    always @(posedge clk) begin
        if (clr)
            _979 <= _977;
        else
            _979 <= _931;
    end
    always @(posedge clk) begin
        if (clr)
            _975 <= _973;
        else
            _975 <= _932;
    end
    always @(posedge clk) begin
        if (clr)
            _971 <= _969;
        else
            _971 <= _933;
    end
    always @(posedge clk) begin
        if (clr)
            _967 <= _965;
        else
            _967 <= _934;
    end
    always @(posedge clk) begin
        if (clr)
            _963 <= _961;
        else
            _963 <= _935;
    end
    always @(posedge clk) begin
        if (clr)
            _959 <= _957;
        else
            _959 <= _936;
    end
    always @(posedge clk) begin
        if (clr)
            _955 <= _953;
        else
            _955 <= _937;
    end
    always @(posedge clk) begin
        if (clr)
            _951 <= _949;
        else
            _951 <= _938;
    end
    always @(posedge clk) begin
        if (clr)
            _947 <= _945;
        else
            _947 <= _939;
    end
    always @(posedge clk) begin
        if (clr)
            _943 <= _941;
        else
            _943 <= vdd;
    end

    /* aliases */

    /* output assignments */
    assign pen = _943;
    assign ra1 = _947;
    assign ra2 = _951;
    assign rad = _955;
    assign ra1_zero = _959;
    assign ra2_zero = _963;
    assign rad_zero = _967;
    assign rd1 = _971;
    assign rd2 = _975;
    assign rdd = _979;
    assign imm = _983;
    assign pc = _987;
    assign next_pc = _991;
    assign instr = _995;
    assign insn = _999;
    assign is = _1003;
    assign fclass = _1007;
    assign alu = _1011;
    assign alu_cmp = _1015;
    assign junk = _1019;

endmodule
