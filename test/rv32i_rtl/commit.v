module commit (
    junk_p_3,
    mio_data_wmask_p_3,
    mio_data_rw_p_3,
    mio_data_req_p_3,
    mio_data_wdata_p_3,
    mio_data_addr_p_3,
    mio_instr_wmask_p_3,
    mio_instr_rw_p_3,
    mio_instr_req_p_3,
    mio_instr_wdata_p_3,
    mio_instr_addr_p_3,
    branch_p_3,
    f7_p_3,
    f3_p_3,
    rdco_p_3,
    rdc_p_3,
    sys_p_3,
    fen_p_3,
    opr_p_3,
    opi_p_3,
    st_p_3,
    ld_p_3,
    bra_p_3,
    auipc_p_3,
    lui_p_3,
    trap_p_3,
    insn_p_3,
    instr_p_3,
    imm_p_3,
    rdm_p_3,
    pc_p_3,
    rdd_p_3,
    jalr_p_3,
    jal_p_3,
    rd2_p_3,
    rd1_p_3,
    rad_zero_p_3,
    ra2_zero_p_3,
    ra1_zero_p_3,
    rad_p_3,
    ra2_p_3,
    ra1_p_3,
    clr,
    clk,
    pen_p_3,
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

    input junk_p_3;
    input [3:0] mio_data_wmask_p_3;
    input mio_data_rw_p_3;
    input mio_data_req_p_3;
    input [31:0] mio_data_wdata_p_3;
    input [31:0] mio_data_addr_p_3;
    input [3:0] mio_instr_wmask_p_3;
    input mio_instr_rw_p_3;
    input mio_instr_req_p_3;
    input [31:0] mio_instr_wdata_p_3;
    input [31:0] mio_instr_addr_p_3;
    input branch_p_3;
    input f7_p_3;
    input [2:0] f3_p_3;
    input [2:0] rdco_p_3;
    input rdc_p_3;
    input sys_p_3;
    input fen_p_3;
    input opr_p_3;
    input opi_p_3;
    input st_p_3;
    input ld_p_3;
    input bra_p_3;
    input auipc_p_3;
    input lui_p_3;
    input trap_p_3;
    input [47:0] insn_p_3;
    input [31:0] instr_p_3;
    input [31:0] imm_p_3;
    input [31:0] rdm_p_3;
    input [31:0] pc_p_3;
    input [31:0] rdd_p_3;
    input jalr_p_3;
    input jal_p_3;
    input [31:0] rd2_p_3;
    input [31:0] rd1_p_3;
    input rad_zero_p_3;
    input ra2_zero_p_3;
    input ra1_zero_p_3;
    input [4:0] rad_p_3;
    input [4:0] ra2_p_3;
    input [4:0] ra1_p_3;
    input clr;
    input clk;
    input pen_p_3;
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
    wire _10835 = 1'b0;
    wire _10836 = 1'b0;
    wire _9420 = 1'b0;
    wire _9421 = 1'b0;
    reg _9422;
    reg _10837;
    wire [3:0] _10831 = 4'b0000;
    wire [3:0] _10832 = 4'b0000;
    wire [3:0] _9424 = 4'b0000;
    wire [3:0] _9425 = 4'b0000;
    reg [3:0] _9426;
    reg [3:0] _10833;
    wire _10827 = 1'b0;
    wire _10828 = 1'b0;
    wire _9428 = 1'b0;
    wire _9429 = 1'b0;
    reg _9430;
    reg _10829;
    wire _10823 = 1'b0;
    wire _10824 = 1'b0;
    wire _9432 = 1'b0;
    wire _9433 = 1'b0;
    reg _9434;
    reg _10825;
    wire [31:0] _10819 = 32'b00000000000000000000000000000000;
    wire [31:0] _10820 = 32'b00000000000000000000000000000000;
    wire [31:0] _9436 = 32'b00000000000000000000000000000000;
    wire [31:0] _9437 = 32'b00000000000000000000000000000000;
    reg [31:0] _9438;
    reg [31:0] _10821;
    wire [31:0] _10815 = 32'b00000000000000000000000000000000;
    wire [31:0] _10816 = 32'b00000000000000000000000000000000;
    wire [31:0] _9440 = 32'b00000000000000000000000000000000;
    wire [31:0] _9441 = 32'b00000000000000000000000000000000;
    reg [31:0] _9442;
    reg [31:0] _10817;
    wire [3:0] _10811 = 4'b0000;
    wire [3:0] _10812 = 4'b0000;
    wire [3:0] _9444 = 4'b0000;
    wire [3:0] _9445 = 4'b0000;
    reg [3:0] _9446;
    reg [3:0] _10813;
    wire _10807 = 1'b0;
    wire _10808 = 1'b0;
    wire _9448 = 1'b0;
    wire _9449 = 1'b0;
    reg _9450;
    reg _10809;
    wire _10803 = 1'b0;
    wire _10804 = 1'b0;
    wire _9452 = 1'b0;
    wire _9453 = 1'b0;
    reg _9454;
    reg _10805;
    wire [31:0] _10799 = 32'b00000000000000000000000000000000;
    wire [31:0] _10800 = 32'b00000000000000000000000000000000;
    wire [31:0] _9456 = 32'b00000000000000000000000000000000;
    wire [31:0] _9457 = 32'b00000000000000000000000000000000;
    reg [31:0] _9458;
    reg [31:0] _10801;
    wire [31:0] _10795 = 32'b00000000000000000000000000000000;
    wire [31:0] _10796 = 32'b00000000000000000000000000000000;
    wire [31:0] _9460 = 32'b00000000000000000000000000000000;
    wire [31:0] _9461 = 32'b00000000000000000000000000000000;
    reg [31:0] _9462;
    reg [31:0] _10797;
    wire _10791 = 1'b0;
    wire _10792 = 1'b0;
    wire _10658;
    wire _10659;
    wire _10660;
    wire _10661;
    wire _10662;
    reg _10793;
    wire _10787 = 1'b0;
    wire _10788 = 1'b0;
    wire _9468 = 1'b0;
    wire _9469 = 1'b0;
    reg _9470;
    wire _10651;
    wire _10652;
    wire _10653;
    reg _10789;
    wire _10783 = 1'b0;
    wire _10784 = 1'b0;
    wire _9472 = 1'b0;
    wire _9473 = 1'b0;
    reg _9474;
    reg _10785;
    wire [2:0] _10779 = 3'b000;
    wire [2:0] _10780 = 3'b000;
    wire [2:0] _9476 = 3'b000;
    wire [2:0] _9477 = 3'b000;
    reg [2:0] _9478;
    reg [2:0] _10781;
    wire [2:0] _10775 = 3'b000;
    wire [2:0] _10776 = 3'b000;
    wire [2:0] _9480 = 3'b000;
    wire [2:0] _9481 = 3'b000;
    reg [2:0] _9482;
    reg [2:0] _10777;
    wire _10771 = 1'b0;
    wire _10772 = 1'b0;
    wire _9484 = 1'b0;
    wire _9485 = 1'b0;
    reg _9486;
    reg _10773;
    wire _10767 = 1'b0;
    wire _10768 = 1'b0;
    wire _9488 = 1'b0;
    wire _9489 = 1'b0;
    reg _9490;
    reg _10769;
    wire _10763 = 1'b0;
    wire _10764 = 1'b0;
    wire _9492 = 1'b0;
    wire _9493 = 1'b0;
    reg _9494;
    reg _10765;
    wire _10759 = 1'b0;
    wire _10760 = 1'b0;
    wire _9496 = 1'b0;
    wire _9497 = 1'b0;
    reg _9498;
    reg _10761;
    wire _10755 = 1'b0;
    wire _10756 = 1'b0;
    wire _9500 = 1'b0;
    wire _9501 = 1'b0;
    reg _9502;
    reg _10757;
    wire _10751 = 1'b0;
    wire _10752 = 1'b0;
    wire _9504 = 1'b0;
    wire _9505 = 1'b0;
    reg _9506;
    reg _10753;
    wire _10747 = 1'b0;
    wire _10748 = 1'b0;
    wire _9508 = 1'b0;
    wire _9509 = 1'b0;
    reg _9510;
    reg _10749;
    wire _10743 = 1'b0;
    wire _10744 = 1'b0;
    wire _9512 = 1'b0;
    wire _9513 = 1'b0;
    reg _9514;
    reg _10745;
    wire _10739 = 1'b0;
    wire _10740 = 1'b0;
    reg _10741;
    wire _10735 = 1'b0;
    wire _10736 = 1'b0;
    reg _10737;
    wire _10731 = 1'b0;
    wire _10732 = 1'b0;
    wire _9524 = 1'b0;
    wire _9525 = 1'b0;
    reg _9526;
    reg _10733;
    wire _10727 = 1'b0;
    wire _10728 = 1'b0;
    wire _9528 = 1'b0;
    wire _9529 = 1'b0;
    reg _9530;
    reg _10729;
    wire _10723 = 1'b0;
    wire _10724 = 1'b0;
    wire _9532 = 1'b0;
    wire _9533 = 1'b0;
    reg _9534;
    reg _10725;
    wire [47:0] _10719 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _10720 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _9536 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _9537 = 48'b000000000000000000000000000000000000000000000000;
    reg [47:0] _9538;
    reg [47:0] _10721;
    wire [31:0] _10715 = 32'b00000000000000000000000000000000;
    wire [31:0] _10716 = 32'b00000000000000000000000000000000;
    wire [31:0] _9540 = 32'b00000000000000000000000000000000;
    wire [31:0] _9541 = 32'b00000000000000000000000000000000;
    reg [31:0] _9542;
    reg [31:0] _10717;
    wire [31:0] _10711 = 32'b00000000000000000000000000000000;
    wire [31:0] _10712 = 32'b00000000000000000000000000000000;
    reg [31:0] _10713;
    wire [31:0] _10707 = 32'b00000000000000000000000000000000;
    wire [31:0] _10708 = 32'b00000000000000000000000000000000;
    wire [31:0] _9548 = 32'b00000000000000000000000000000000;
    wire [31:0] _9549 = 32'b00000000000000000000000000000000;
    reg [31:0] _9550;
    reg [31:0] _10709;
    wire [31:0] _10703 = 32'b00000000000000000000000000000000;
    wire [31:0] _10704 = 32'b00000000000000000000000000000000;
    wire [31:0] _9552 = 32'b00000000000000000000000000000000;
    wire [31:0] _9553 = 32'b00000000000000000000000000000000;
    reg [31:0] _9554;
    reg [31:0] _10705;
    wire [31:0] _10699 = 32'b00000000000000000000000000000000;
    wire [31:0] _10700 = 32'b00000000000000000000000000000000;
    wire [31:0] _10654 = 32'b00000000000000000000000000000100;
    wire [31:0] _9544 = 32'b00000000000000000000000000000000;
    wire [31:0] _9545 = 32'b00000000000000000000000000000000;
    reg [31:0] _9546;
    wire [31:0] _10655;
    wire [31:0] _9556 = 32'b00000000000000000000000000000000;
    wire [31:0] _9557 = 32'b00000000000000000000000000000000;
    reg [31:0] _9558;
    wire _9516 = 1'b0;
    wire _9517 = 1'b0;
    reg _9518;
    wire _9520 = 1'b0;
    wire _9521 = 1'b0;
    reg _9522;
    wire _10656;
    wire [31:0] _10657;
    reg [31:0] _10701;
    wire [31:0] _10695 = 32'b00000000000000000000000000000000;
    wire [31:0] _10696 = 32'b00000000000000000000000000000000;
    wire [31:0] _9560 = 32'b00000000000000000000000000000000;
    wire [31:0] _9561 = 32'b00000000000000000000000000000000;
    reg [31:0] _9562;
    reg [31:0] _10697;
    wire [31:0] _10691 = 32'b00000000000000000000000000000000;
    wire [31:0] _10692 = 32'b00000000000000000000000000000000;
    wire [31:0] _9564 = 32'b00000000000000000000000000000000;
    wire [31:0] _9565 = 32'b00000000000000000000000000000000;
    reg [31:0] _9566;
    reg [31:0] _10693;
    wire _10687 = 1'b0;
    wire _10688 = 1'b0;
    wire _9568 = 1'b0;
    wire _9569 = 1'b0;
    reg _9570;
    reg _10689;
    wire _10683 = 1'b0;
    wire _10684 = 1'b0;
    wire _9572 = 1'b0;
    wire _9573 = 1'b0;
    reg _9574;
    reg _10685;
    wire _10679 = 1'b0;
    wire _10680 = 1'b0;
    wire _9576 = 1'b0;
    wire _9577 = 1'b0;
    reg _9578;
    reg _10681;
    wire [4:0] _10675 = 5'b00000;
    wire [4:0] _10676 = 5'b00000;
    wire [4:0] _9580 = 5'b00000;
    wire [4:0] _9581 = 5'b00000;
    reg [4:0] _9582;
    reg [4:0] _10677;
    wire [4:0] _10671 = 5'b00000;
    wire [4:0] _10672 = 5'b00000;
    wire [4:0] _9584 = 5'b00000;
    wire [4:0] _9585 = 5'b00000;
    reg [4:0] _9586;
    reg [4:0] _10673;
    wire [4:0] _10667 = 5'b00000;
    wire [4:0] _10668 = 5'b00000;
    wire [4:0] _9588 = 5'b00000;
    wire [4:0] _9589 = 5'b00000;
    reg [4:0] _9590;
    reg [4:0] _10669;
    wire _10663 = 1'b0;
    wire _10664 = 1'b0;
    wire _9592 = 1'b0;
    wire vdd = 1'b1;
    wire _9593 = 1'b0;
    reg _9594;
    reg _10665;

    /* logic */
    always @(posedge clk) begin
        if (clr)
            _9422 <= _9420;
        else
            _9422 <= junk_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10837 <= _10835;
        else
            _10837 <= _9422;
    end
    always @(posedge clk) begin
        if (clr)
            _9426 <= _9424;
        else
            _9426 <= mio_data_wmask_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10833 <= _10831;
        else
            _10833 <= _9426;
    end
    always @(posedge clk) begin
        if (clr)
            _9430 <= _9428;
        else
            _9430 <= mio_data_rw_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10829 <= _10827;
        else
            _10829 <= _9430;
    end
    always @(posedge clk) begin
        if (clr)
            _9434 <= _9432;
        else
            _9434 <= mio_data_req_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10825 <= _10823;
        else
            _10825 <= _9434;
    end
    always @(posedge clk) begin
        if (clr)
            _9438 <= _9436;
        else
            _9438 <= mio_data_wdata_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10821 <= _10819;
        else
            _10821 <= _9438;
    end
    always @(posedge clk) begin
        if (clr)
            _9442 <= _9440;
        else
            _9442 <= mio_data_addr_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10817 <= _10815;
        else
            _10817 <= _9442;
    end
    always @(posedge clk) begin
        if (clr)
            _9446 <= _9444;
        else
            _9446 <= mio_instr_wmask_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10813 <= _10811;
        else
            _10813 <= _9446;
    end
    always @(posedge clk) begin
        if (clr)
            _9450 <= _9448;
        else
            _9450 <= mio_instr_rw_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10809 <= _10807;
        else
            _10809 <= _9450;
    end
    always @(posedge clk) begin
        if (clr)
            _9454 <= _9452;
        else
            _9454 <= mio_instr_req_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10805 <= _10803;
        else
            _10805 <= _9454;
    end
    always @(posedge clk) begin
        if (clr)
            _9458 <= _9456;
        else
            _9458 <= mio_instr_wdata_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10801 <= _10799;
        else
            _10801 <= _9458;
    end
    always @(posedge clk) begin
        if (clr)
            _9462 <= _9460;
        else
            _9462 <= mio_instr_addr_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10797 <= _10795;
        else
            _10797 <= _9462;
    end
    assign _10658 = _9534 | _9514;
    assign _10659 = _10658 | _9506;
    assign _10660 = _10659 | _9494;
    assign _10661 = _10660 | _9486;
    assign _10662 = ~ _10661;
    always @(posedge clk) begin
        if (clr)
            _10793 <= _10791;
        else
            _10793 <= _10662;
    end
    always @(posedge clk) begin
        if (clr)
            _9470 <= _9468;
        else
            _9470 <= branch_p_3;
    end
    assign _10651 = _9514 & _9470;
    assign _10652 = _9522 | _9518;
    assign _10653 = _10652 | _10651;
    always @(posedge clk) begin
        if (clr)
            _10789 <= _10787;
        else
            _10789 <= _10653;
    end
    always @(posedge clk) begin
        if (clr)
            _9474 <= _9472;
        else
            _9474 <= f7_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10785 <= _10783;
        else
            _10785 <= _9474;
    end
    always @(posedge clk) begin
        if (clr)
            _9478 <= _9476;
        else
            _9478 <= f3_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10781 <= _10779;
        else
            _10781 <= _9478;
    end
    always @(posedge clk) begin
        if (clr)
            _9482 <= _9480;
        else
            _9482 <= rdco_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10777 <= _10775;
        else
            _10777 <= _9482;
    end
    always @(posedge clk) begin
        if (clr)
            _9486 <= _9484;
        else
            _9486 <= rdc_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10773 <= _10771;
        else
            _10773 <= _9486;
    end
    always @(posedge clk) begin
        if (clr)
            _9490 <= _9488;
        else
            _9490 <= sys_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10769 <= _10767;
        else
            _10769 <= _9490;
    end
    always @(posedge clk) begin
        if (clr)
            _9494 <= _9492;
        else
            _9494 <= fen_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10765 <= _10763;
        else
            _10765 <= _9494;
    end
    always @(posedge clk) begin
        if (clr)
            _9498 <= _9496;
        else
            _9498 <= opr_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10761 <= _10759;
        else
            _10761 <= _9498;
    end
    always @(posedge clk) begin
        if (clr)
            _9502 <= _9500;
        else
            _9502 <= opi_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10757 <= _10755;
        else
            _10757 <= _9502;
    end
    always @(posedge clk) begin
        if (clr)
            _9506 <= _9504;
        else
            _9506 <= st_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10753 <= _10751;
        else
            _10753 <= _9506;
    end
    always @(posedge clk) begin
        if (clr)
            _9510 <= _9508;
        else
            _9510 <= ld_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10749 <= _10747;
        else
            _10749 <= _9510;
    end
    always @(posedge clk) begin
        if (clr)
            _9514 <= _9512;
        else
            _9514 <= bra_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10745 <= _10743;
        else
            _10745 <= _9514;
    end
    always @(posedge clk) begin
        if (clr)
            _10741 <= _10739;
        else
            _10741 <= _9518;
    end
    always @(posedge clk) begin
        if (clr)
            _10737 <= _10735;
        else
            _10737 <= _9522;
    end
    always @(posedge clk) begin
        if (clr)
            _9526 <= _9524;
        else
            _9526 <= auipc_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10733 <= _10731;
        else
            _10733 <= _9526;
    end
    always @(posedge clk) begin
        if (clr)
            _9530 <= _9528;
        else
            _9530 <= lui_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10729 <= _10727;
        else
            _10729 <= _9530;
    end
    always @(posedge clk) begin
        if (clr)
            _9534 <= _9532;
        else
            _9534 <= trap_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10725 <= _10723;
        else
            _10725 <= _9534;
    end
    always @(posedge clk) begin
        if (clr)
            _9538 <= _9536;
        else
            _9538 <= insn_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10721 <= _10719;
        else
            _10721 <= _9538;
    end
    always @(posedge clk) begin
        if (clr)
            _9542 <= _9540;
        else
            _9542 <= instr_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10717 <= _10715;
        else
            _10717 <= _9542;
    end
    always @(posedge clk) begin
        if (clr)
            _10713 <= _10711;
        else
            _10713 <= _9558;
    end
    always @(posedge clk) begin
        if (clr)
            _9550 <= _9548;
        else
            _9550 <= imm_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10709 <= _10707;
        else
            _10709 <= _9550;
    end
    always @(posedge clk) begin
        if (clr)
            _9554 <= _9552;
        else
            _9554 <= rdm_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10705 <= _10703;
        else
            _10705 <= _9554;
    end
    always @(posedge clk) begin
        if (clr)
            _9546 <= _9544;
        else
            _9546 <= pc_p_3;
    end
    assign _10655 = _9546 + _10654;
    always @(posedge clk) begin
        if (clr)
            _9558 <= _9556;
        else
            _9558 <= rdd_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _9518 <= _9516;
        else
            _9518 <= jalr_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _9522 <= _9520;
        else
            _9522 <= jal_p_3;
    end
    assign _10656 = _9522 | _9518;
    assign _10657 = _10656 ? _10655 : _9558;
    always @(posedge clk) begin
        if (clr)
            _10701 <= _10699;
        else
            _10701 <= _10657;
    end
    always @(posedge clk) begin
        if (clr)
            _9562 <= _9560;
        else
            _9562 <= rd2_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10697 <= _10695;
        else
            _10697 <= _9562;
    end
    always @(posedge clk) begin
        if (clr)
            _9566 <= _9564;
        else
            _9566 <= rd1_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10693 <= _10691;
        else
            _10693 <= _9566;
    end
    always @(posedge clk) begin
        if (clr)
            _9570 <= _9568;
        else
            _9570 <= rad_zero_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10689 <= _10687;
        else
            _10689 <= _9570;
    end
    always @(posedge clk) begin
        if (clr)
            _9574 <= _9572;
        else
            _9574 <= ra2_zero_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10685 <= _10683;
        else
            _10685 <= _9574;
    end
    always @(posedge clk) begin
        if (clr)
            _9578 <= _9576;
        else
            _9578 <= ra1_zero_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10681 <= _10679;
        else
            _10681 <= _9578;
    end
    always @(posedge clk) begin
        if (clr)
            _9582 <= _9580;
        else
            _9582 <= rad_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10677 <= _10675;
        else
            _10677 <= _9582;
    end
    always @(posedge clk) begin
        if (clr)
            _9586 <= _9584;
        else
            _9586 <= ra2_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10673 <= _10671;
        else
            _10673 <= _9586;
    end
    always @(posedge clk) begin
        if (clr)
            _9590 <= _9588;
        else
            _9590 <= ra1_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10669 <= _10667;
        else
            _10669 <= _9590;
    end
    always @(posedge clk) begin
        if (clr)
            _9594 <= _9592;
        else
            _9594 <= pen_p_3;
    end
    always @(posedge clk) begin
        if (clr)
            _10665 <= _10663;
        else
            _10665 <= _9594;
    end

    /* aliases */

    /* output assignments */
    assign pen = _10665;
    assign ra1 = _10669;
    assign ra2 = _10673;
    assign rad = _10677;
    assign ra1_zero = _10681;
    assign ra2_zero = _10685;
    assign rad_zero = _10689;
    assign rd1 = _10693;
    assign rd2 = _10697;
    assign rdd = _10701;
    assign rdm = _10705;
    assign imm = _10709;
    assign pc = _10713;
    assign instr = _10717;
    assign insn = _10721;
    assign trap = _10725;
    assign lui = _10729;
    assign auipc = _10733;
    assign jal = _10737;
    assign jalr = _10741;
    assign bra = _10745;
    assign ld = _10749;
    assign st = _10753;
    assign opi = _10757;
    assign opr = _10761;
    assign fen = _10765;
    assign sys = _10769;
    assign rdc = _10773;
    assign rdco = _10777;
    assign f3 = _10781;
    assign f7 = _10785;
    assign branch = _10789;
    assign rwe = _10793;
    assign mio_instr_addr = _10797;
    assign mio_instr_wdata = _10801;
    assign mio_instr_req = _10805;
    assign mio_instr_rw = _10809;
    assign mio_instr_wmask = _10813;
    assign mio_data_addr = _10817;
    assign mio_data_wdata = _10821;
    assign mio_data_req = _10825;
    assign mio_data_rw = _10829;
    assign mio_data_wmask = _10833;
    assign junk = _10837;

endmodule
