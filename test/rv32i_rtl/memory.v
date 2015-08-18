module memory (
    junk_p_2,
    cond_branch_p_2,
    f7_p_2,
    f3_p_2,
    sys_p_2,
    fen_p_2,
    opr_p_2,
    opi_p_2,
    st_p_2,
    ld_p_2,
    bra_p_2,
    jalr_p_2,
    jal_p_2,
    auipc_p_2,
    lui_p_2,
    trap_p_2,
    insn_p_2,
    instr_p_2,
    next_pc_p_2,
    pc_p_2,
    imm_p_2,
    rdm_p_2,
    rdd_p_2,
    rd2_p_2,
    rd1_p_2,
    rad_zero_p_2,
    ra2_zero_p_2,
    ra1_zero_p_2,
    rad_p_2,
    ra2_p_2,
    ra1_p_2,
    clr,
    clk,
    pen_p_2,
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

    input junk_p_2;
    input cond_branch_p_2;
    input f7_p_2;
    input [2:0] f3_p_2;
    input sys_p_2;
    input fen_p_2;
    input opr_p_2;
    input opi_p_2;
    input st_p_2;
    input ld_p_2;
    input bra_p_2;
    input jalr_p_2;
    input jal_p_2;
    input auipc_p_2;
    input lui_p_2;
    input trap_p_2;
    input [47:0] insn_p_2;
    input [31:0] instr_p_2;
    input [31:0] next_pc_p_2;
    input [31:0] pc_p_2;
    input [31:0] imm_p_2;
    input [31:0] rdm_p_2;
    input [31:0] rdd_p_2;
    input [31:0] rd2_p_2;
    input [31:0] rd1_p_2;
    input rad_zero_p_2;
    input ra2_zero_p_2;
    input ra1_zero_p_2;
    input [4:0] rad_p_2;
    input [4:0] ra2_p_2;
    input [4:0] ra1_p_2;
    input clr;
    input clk;
    input pen_p_2;
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
    output [2:0] f3;
    output f7;
    output cond_branch;
    output junk;

    /* signal declarations */
    wire _6556 = 1'b0;
    wire _6557 = 1'b0;
    wire _5409 = 1'b0;
    wire _5410 = 1'b0;
    reg _5411;
    reg _6558;
    wire _6552 = 1'b0;
    wire _6553 = 1'b0;
    wire _5413 = 1'b0;
    wire _5414 = 1'b0;
    reg _5415;
    reg _6554;
    wire _6548 = 1'b0;
    wire _6549 = 1'b0;
    wire _5417 = 1'b0;
    wire _5418 = 1'b0;
    reg _5419;
    reg _6550;
    wire [2:0] _6544 = 3'b000;
    wire [2:0] _6545 = 3'b000;
    wire [2:0] _5421 = 3'b000;
    wire [2:0] _5422 = 3'b000;
    reg [2:0] _5423;
    reg [2:0] _6546;
    wire _6540 = 1'b0;
    wire _6541 = 1'b0;
    wire _5425 = 1'b0;
    wire _5426 = 1'b0;
    reg _5427;
    reg _6542;
    wire _6536 = 1'b0;
    wire _6537 = 1'b0;
    wire _5429 = 1'b0;
    wire _5430 = 1'b0;
    reg _5431;
    reg _6538;
    wire _6532 = 1'b0;
    wire _6533 = 1'b0;
    wire _5433 = 1'b0;
    wire _5434 = 1'b0;
    reg _5435;
    reg _6534;
    wire _6528 = 1'b0;
    wire _6529 = 1'b0;
    wire _5437 = 1'b0;
    wire _5438 = 1'b0;
    reg _5439;
    reg _6530;
    wire _6524 = 1'b0;
    wire _6525 = 1'b0;
    wire _5441 = 1'b0;
    wire _5442 = 1'b0;
    reg _5443;
    reg _6526;
    wire _6520 = 1'b0;
    wire _6521 = 1'b0;
    wire _5445 = 1'b0;
    wire _5446 = 1'b0;
    reg _5447;
    reg _6522;
    wire _6516 = 1'b0;
    wire _6517 = 1'b0;
    wire _5449 = 1'b0;
    wire _5450 = 1'b0;
    reg _5451;
    reg _6518;
    wire _6512 = 1'b0;
    wire _6513 = 1'b0;
    wire _5453 = 1'b0;
    wire _5454 = 1'b0;
    reg _5455;
    reg _6514;
    wire _6508 = 1'b0;
    wire _6509 = 1'b0;
    wire _5457 = 1'b0;
    wire _5458 = 1'b0;
    reg _5459;
    reg _6510;
    wire _6504 = 1'b0;
    wire _6505 = 1'b0;
    wire _5461 = 1'b0;
    wire _5462 = 1'b0;
    reg _5463;
    reg _6506;
    wire _6500 = 1'b0;
    wire _6501 = 1'b0;
    wire _5465 = 1'b0;
    wire _5466 = 1'b0;
    reg _5467;
    reg _6502;
    wire _6496 = 1'b0;
    wire _6497 = 1'b0;
    wire _5469 = 1'b0;
    wire _5470 = 1'b0;
    reg _5471;
    reg _6498;
    wire [47:0] _6492 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _6493 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _5473 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _5474 = 48'b000000000000000000000000000000000000000000000000;
    reg [47:0] _5475;
    reg [47:0] _6494;
    wire [31:0] _6488 = 32'b00000000000000000000000000000000;
    wire [31:0] _6489 = 32'b00000000000000000000000000000000;
    wire [31:0] _5477 = 32'b00000000000000000000000000000000;
    wire [31:0] _5478 = 32'b00000000000000000000000000000000;
    reg [31:0] _5479;
    reg [31:0] _6490;
    wire [31:0] _6484 = 32'b00000000000000000000000000000000;
    wire [31:0] _6485 = 32'b00000000000000000000000000000000;
    wire [31:0] _5481 = 32'b00000000000000000000000000000000;
    wire [31:0] _5482 = 32'b00000000000000000000000000000000;
    reg [31:0] _5483;
    reg [31:0] _6486;
    wire [31:0] _6480 = 32'b00000000000000000000000000000000;
    wire [31:0] _6481 = 32'b00000000000000000000000000000000;
    wire [31:0] _5485 = 32'b00000000000000000000000000000000;
    wire [31:0] _5486 = 32'b00000000000000000000000000000000;
    reg [31:0] _5487;
    reg [31:0] _6482;
    wire [31:0] _6476 = 32'b00000000000000000000000000000000;
    wire [31:0] _6477 = 32'b00000000000000000000000000000000;
    wire [31:0] _5489 = 32'b00000000000000000000000000000000;
    wire [31:0] _5490 = 32'b00000000000000000000000000000000;
    reg [31:0] _5491;
    reg [31:0] _6478;
    wire [31:0] _6472 = 32'b00000000000000000000000000000000;
    wire [31:0] _6473 = 32'b00000000000000000000000000000000;
    wire [31:0] _5493 = 32'b00000000000000000000000000000000;
    wire [31:0] _5494 = 32'b00000000000000000000000000000000;
    reg [31:0] _5495;
    reg [31:0] _6474;
    wire [31:0] _6468 = 32'b00000000000000000000000000000000;
    wire [31:0] _6469 = 32'b00000000000000000000000000000000;
    wire [31:0] _5497 = 32'b00000000000000000000000000000000;
    wire [31:0] _5498 = 32'b00000000000000000000000000000000;
    reg [31:0] _5499;
    reg [31:0] _6470;
    wire [31:0] _6464 = 32'b00000000000000000000000000000000;
    wire [31:0] _6465 = 32'b00000000000000000000000000000000;
    wire [31:0] _5501 = 32'b00000000000000000000000000000000;
    wire [31:0] _5502 = 32'b00000000000000000000000000000000;
    reg [31:0] _5503;
    reg [31:0] _6466;
    wire [31:0] _6460 = 32'b00000000000000000000000000000000;
    wire [31:0] _6461 = 32'b00000000000000000000000000000000;
    wire [31:0] _5505 = 32'b00000000000000000000000000000000;
    wire [31:0] _5506 = 32'b00000000000000000000000000000000;
    reg [31:0] _5507;
    reg [31:0] _6462;
    wire _6456 = 1'b0;
    wire _6457 = 1'b0;
    wire _5509 = 1'b0;
    wire _5510 = 1'b0;
    reg _5511;
    reg _6458;
    wire _6452 = 1'b0;
    wire _6453 = 1'b0;
    wire _5513 = 1'b0;
    wire _5514 = 1'b0;
    reg _5515;
    reg _6454;
    wire _6448 = 1'b0;
    wire _6449 = 1'b0;
    wire _5517 = 1'b0;
    wire _5518 = 1'b0;
    reg _5519;
    reg _6450;
    wire [4:0] _6444 = 5'b00000;
    wire [4:0] _6445 = 5'b00000;
    wire [4:0] _5521 = 5'b00000;
    wire [4:0] _5522 = 5'b00000;
    reg [4:0] _5523;
    reg [4:0] _6446;
    wire [4:0] _6440 = 5'b00000;
    wire [4:0] _6441 = 5'b00000;
    wire [4:0] _5525 = 5'b00000;
    wire [4:0] _5526 = 5'b00000;
    reg [4:0] _5527;
    reg [4:0] _6442;
    wire [4:0] _6436 = 5'b00000;
    wire [4:0] _6437 = 5'b00000;
    wire [4:0] _5529 = 5'b00000;
    wire [4:0] _5530 = 5'b00000;
    reg [4:0] _5531;
    reg [4:0] _6438;
    wire _6432 = 1'b0;
    wire _6433 = 1'b0;
    wire _5533 = 1'b0;
    wire vdd = 1'b1;
    wire _5534 = 1'b0;
    reg _5535;
    reg _6434;

    /* logic */
    always @(posedge clk) begin
        if (clr)
            _5411 <= _5409;
        else
            _5411 <= junk_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6558 <= _6556;
        else
            _6558 <= _5411;
    end
    always @(posedge clk) begin
        if (clr)
            _5415 <= _5413;
        else
            _5415 <= cond_branch_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6554 <= _6552;
        else
            _6554 <= _5415;
    end
    always @(posedge clk) begin
        if (clr)
            _5419 <= _5417;
        else
            _5419 <= f7_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6550 <= _6548;
        else
            _6550 <= _5419;
    end
    always @(posedge clk) begin
        if (clr)
            _5423 <= _5421;
        else
            _5423 <= f3_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6546 <= _6544;
        else
            _6546 <= _5423;
    end
    always @(posedge clk) begin
        if (clr)
            _5427 <= _5425;
        else
            _5427 <= sys_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6542 <= _6540;
        else
            _6542 <= _5427;
    end
    always @(posedge clk) begin
        if (clr)
            _5431 <= _5429;
        else
            _5431 <= fen_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6538 <= _6536;
        else
            _6538 <= _5431;
    end
    always @(posedge clk) begin
        if (clr)
            _5435 <= _5433;
        else
            _5435 <= opr_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6534 <= _6532;
        else
            _6534 <= _5435;
    end
    always @(posedge clk) begin
        if (clr)
            _5439 <= _5437;
        else
            _5439 <= opi_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6530 <= _6528;
        else
            _6530 <= _5439;
    end
    always @(posedge clk) begin
        if (clr)
            _5443 <= _5441;
        else
            _5443 <= st_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6526 <= _6524;
        else
            _6526 <= _5443;
    end
    always @(posedge clk) begin
        if (clr)
            _5447 <= _5445;
        else
            _5447 <= ld_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6522 <= _6520;
        else
            _6522 <= _5447;
    end
    always @(posedge clk) begin
        if (clr)
            _5451 <= _5449;
        else
            _5451 <= bra_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6518 <= _6516;
        else
            _6518 <= _5451;
    end
    always @(posedge clk) begin
        if (clr)
            _5455 <= _5453;
        else
            _5455 <= jalr_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6514 <= _6512;
        else
            _6514 <= _5455;
    end
    always @(posedge clk) begin
        if (clr)
            _5459 <= _5457;
        else
            _5459 <= jal_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6510 <= _6508;
        else
            _6510 <= _5459;
    end
    always @(posedge clk) begin
        if (clr)
            _5463 <= _5461;
        else
            _5463 <= auipc_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6506 <= _6504;
        else
            _6506 <= _5463;
    end
    always @(posedge clk) begin
        if (clr)
            _5467 <= _5465;
        else
            _5467 <= lui_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6502 <= _6500;
        else
            _6502 <= _5467;
    end
    always @(posedge clk) begin
        if (clr)
            _5471 <= _5469;
        else
            _5471 <= trap_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6498 <= _6496;
        else
            _6498 <= _5471;
    end
    always @(posedge clk) begin
        if (clr)
            _5475 <= _5473;
        else
            _5475 <= insn_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6494 <= _6492;
        else
            _6494 <= _5475;
    end
    always @(posedge clk) begin
        if (clr)
            _5479 <= _5477;
        else
            _5479 <= instr_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6490 <= _6488;
        else
            _6490 <= _5479;
    end
    always @(posedge clk) begin
        if (clr)
            _5483 <= _5481;
        else
            _5483 <= next_pc_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6486 <= _6484;
        else
            _6486 <= _5483;
    end
    always @(posedge clk) begin
        if (clr)
            _5487 <= _5485;
        else
            _5487 <= pc_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6482 <= _6480;
        else
            _6482 <= _5487;
    end
    always @(posedge clk) begin
        if (clr)
            _5491 <= _5489;
        else
            _5491 <= imm_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6478 <= _6476;
        else
            _6478 <= _5491;
    end
    always @(posedge clk) begin
        if (clr)
            _5495 <= _5493;
        else
            _5495 <= rdm_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6474 <= _6472;
        else
            _6474 <= _5495;
    end
    always @(posedge clk) begin
        if (clr)
            _5499 <= _5497;
        else
            _5499 <= rdd_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6470 <= _6468;
        else
            _6470 <= _5499;
    end
    always @(posedge clk) begin
        if (clr)
            _5503 <= _5501;
        else
            _5503 <= rd2_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6466 <= _6464;
        else
            _6466 <= _5503;
    end
    always @(posedge clk) begin
        if (clr)
            _5507 <= _5505;
        else
            _5507 <= rd1_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6462 <= _6460;
        else
            _6462 <= _5507;
    end
    always @(posedge clk) begin
        if (clr)
            _5511 <= _5509;
        else
            _5511 <= rad_zero_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6458 <= _6456;
        else
            _6458 <= _5511;
    end
    always @(posedge clk) begin
        if (clr)
            _5515 <= _5513;
        else
            _5515 <= ra2_zero_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6454 <= _6452;
        else
            _6454 <= _5515;
    end
    always @(posedge clk) begin
        if (clr)
            _5519 <= _5517;
        else
            _5519 <= ra1_zero_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6450 <= _6448;
        else
            _6450 <= _5519;
    end
    always @(posedge clk) begin
        if (clr)
            _5523 <= _5521;
        else
            _5523 <= rad_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6446 <= _6444;
        else
            _6446 <= _5523;
    end
    always @(posedge clk) begin
        if (clr)
            _5527 <= _5525;
        else
            _5527 <= ra2_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6442 <= _6440;
        else
            _6442 <= _5527;
    end
    always @(posedge clk) begin
        if (clr)
            _5531 <= _5529;
        else
            _5531 <= ra1_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6438 <= _6436;
        else
            _6438 <= _5531;
    end
    always @(posedge clk) begin
        if (clr)
            _5535 <= _5533;
        else
            _5535 <= pen_p_2;
    end
    always @(posedge clk) begin
        if (clr)
            _6434 <= _6432;
        else
            _6434 <= _5535;
    end

    /* aliases */

    /* output assignments */
    assign pen = _6434;
    assign ra1 = _6438;
    assign ra2 = _6442;
    assign rad = _6446;
    assign ra1_zero = _6450;
    assign ra2_zero = _6454;
    assign rad_zero = _6458;
    assign rd1 = _6462;
    assign rd2 = _6466;
    assign rdd = _6470;
    assign rdm = _6474;
    assign imm = _6478;
    assign pc = _6482;
    assign next_pc = _6486;
    assign instr = _6490;
    assign insn = _6494;
    assign trap = _6498;
    assign lui = _6502;
    assign auipc = _6506;
    assign jal = _6510;
    assign jalr = _6514;
    assign bra = _6518;
    assign ld = _6522;
    assign st = _6526;
    assign opi = _6530;
    assign opr = _6534;
    assign fen = _6538;
    assign sys = _6542;
    assign f3 = _6546;
    assign f7 = _6550;
    assign cond_branch = _6554;
    assign junk = _6558;

endmodule
