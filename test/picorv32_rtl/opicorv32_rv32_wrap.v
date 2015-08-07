module opicorv32_rv32_wrap (
    irq,
    pcpi_ready,
    pcpi_wait,
    pcpi_rd,
    pcpi_wr,
    mem_rdata,
    mem_ready,
    resetn,
    clk,
    trap,
    mem_valid,
    mem_instr,
    mem_addr,
    mem_wdata,
    mem_wstrb,
    mem_la_read,
    mem_la_write,
    mem_la_addr,
    mem_la_wdata,
    mem_la_wstrb,
    pcpi_valid,
    pcpi_insn,
    pcpi_rs1,
    pcpi_rs2,
    eoi
);

    input [31:0] irq;
    input pcpi_ready;
    input pcpi_wait;
    input [31:0] pcpi_rd;
    input pcpi_wr;
    input [31:0] mem_rdata;
    input mem_ready;
    input resetn;
    input clk;
    output trap;
    output mem_valid;
    output mem_instr;
    output [31:0] mem_addr;
    output [31:0] mem_wdata;
    output [3:0] mem_wstrb;
    output mem_la_read;
    output mem_la_write;
    output [31:0] mem_la_addr;
    output [31:0] mem_la_wdata;
    output [3:0] mem_la_wstrb;
    output pcpi_valid;
    output [31:0] pcpi_insn;
    output [31:0] pcpi_rs1;
    output [31:0] pcpi_rs2;
    output [31:0] eoi;

    /* signal declarations */
    wire [31:0] _9626;
    wire [31:0] _9610;
    wire [31:0] compare_eoi;
    wire [31:0] _9628;
    wire [31:0] _9629;
    wire [31:0] _9611;
    wire [31:0] compare_pcpi_rs2;
    wire [31:0] _9631;
    wire [31:0] _9632;
    wire [31:0] _9612;
    wire [31:0] compare_pcpi_rs1;
    wire [31:0] _9634;
    wire [31:0] _9635;
    wire [31:0] _9613;
    wire [31:0] compare_pcpi_insn;
    wire [31:0] _9637;
    wire _9638;
    wire _9614;
    wire compare_pcpi_valid;
    wire _9640;
    wire [3:0] _9641;
    wire [3:0] _9615;
    wire [3:0] compare_mem_la_wstrb;
    wire [3:0] _9643;
    wire [31:0] _9644;
    wire [31:0] _9616;
    wire [31:0] compare_mem_la_wdata;
    wire [31:0] _9646;
    wire [31:0] _9647;
    wire [31:0] _9617;
    wire [31:0] compare_mem_la_addr;
    wire [31:0] _9649;
    wire _9650;
    wire _9618;
    wire compare_mem_la_write;
    wire _9652;
    wire _9653;
    wire _9619;
    wire compare_mem_la_read;
    wire _9655;
    wire [3:0] _9656;
    wire [3:0] _9620;
    wire [3:0] compare_mem_wstrb;
    wire [3:0] _9658;
    wire [31:0] _9659;
    wire [31:0] _9621;
    wire [31:0] compare_mem_wdata;
    wire [31:0] _9661;
    wire [31:0] _9662;
    wire [31:0] _9622;
    wire [31:0] compare_mem_addr;
    wire [31:0] _9664;
    wire _9665;
    wire _9623;
    wire compare_mem_instr;
    wire _9667;
    wire _9668;
    wire _9624;
    wire compare_mem_valid;
    wire _9670;
    wire [269:0] _9607;
    wire _9671;
    wire [269:0] _9609;
    wire _9625;
    wire compare_trap;
    wire _9673;

    /* logic */
    assign _9626 = _9607[269:238];
    assign _9610 = _9609[269:238];
    assign compare_eoi = _9610 ^ _9626;
    assign _9628 = compare_eoi ^ _9626;
    assign _9629 = _9607[237:206];
    assign _9611 = _9609[237:206];
    assign compare_pcpi_rs2 = _9611 ^ _9629;
    assign _9631 = compare_pcpi_rs2 ^ _9629;
    assign _9632 = _9607[205:174];
    assign _9612 = _9609[205:174];
    assign compare_pcpi_rs1 = _9612 ^ _9632;
    assign _9634 = compare_pcpi_rs1 ^ _9632;
    assign _9635 = _9607[173:142];
    assign _9613 = _9609[173:142];
    assign compare_pcpi_insn = _9613 ^ _9635;
    assign _9637 = compare_pcpi_insn ^ _9635;
    assign _9638 = _9607[141:141];
    assign _9614 = _9609[141:141];
    assign compare_pcpi_valid = _9614 ^ _9638;
    assign _9640 = compare_pcpi_valid ^ _9638;
    assign _9641 = _9607[140:137];
    assign _9615 = _9609[140:137];
    assign compare_mem_la_wstrb = _9615 ^ _9641;
    assign _9643 = compare_mem_la_wstrb ^ _9641;
    assign _9644 = _9607[136:105];
    assign _9616 = _9609[136:105];
    assign compare_mem_la_wdata = _9616 ^ _9644;
    assign _9646 = compare_mem_la_wdata ^ _9644;
    assign _9647 = _9607[104:73];
    assign _9617 = _9609[104:73];
    assign compare_mem_la_addr = _9617 ^ _9647;
    assign _9649 = compare_mem_la_addr ^ _9647;
    assign _9650 = _9607[72:72];
    assign _9618 = _9609[72:72];
    assign compare_mem_la_write = _9618 ^ _9650;
    assign _9652 = compare_mem_la_write ^ _9650;
    assign _9653 = _9607[71:71];
    assign _9619 = _9609[71:71];
    assign compare_mem_la_read = _9619 ^ _9653;
    assign _9655 = compare_mem_la_read ^ _9653;
    assign _9656 = _9607[70:67];
    assign _9620 = _9609[70:67];
    assign compare_mem_wstrb = _9620 ^ _9656;
    assign _9658 = compare_mem_wstrb ^ _9656;
    assign _9659 = _9607[66:35];
    assign _9621 = _9609[66:35];
    assign compare_mem_wdata = _9621 ^ _9659;
    assign _9661 = compare_mem_wdata ^ _9659;
    assign _9662 = _9607[34:3];
    assign _9622 = _9609[34:3];
    assign compare_mem_addr = _9622 ^ _9662;
    assign _9664 = compare_mem_addr ^ _9662;
    assign _9665 = _9607[2:2];
    assign _9623 = _9609[2:2];
    assign compare_mem_instr = _9623 ^ _9665;
    assign _9667 = compare_mem_instr ^ _9665;
    assign _9668 = _9607[1:1];
    assign _9624 = _9609[1:1];
    assign compare_mem_valid = _9624 ^ _9668;
    assign _9670 = compare_mem_valid ^ _9668;
    picorv32_rv32
        the_picorv32_rv32
        ( .clk(clk), .resetn(resetn), .mem_ready(mem_ready), .mem_rdata(mem_rdata), .pcpi_wr(pcpi_wr), .pcpi_rd(pcpi_rd), .pcpi_wait(pcpi_wait), .pcpi_ready(pcpi_ready), .irq(irq), .eoi(_9607[269:238]), .pcpi_rs2(_9607[237:206]), .pcpi_rs1(_9607[205:174]), .pcpi_insn(_9607[173:142]), .pcpi_valid(_9607[141:141]), .mem_la_wstrb(_9607[140:137]), .mem_la_wdata(_9607[136:105]), .mem_la_addr(_9607[104:73]), .mem_la_write(_9607[72:72]), .mem_la_read(_9607[71:71]), .mem_wstrb(_9607[70:67]), .mem_wdata(_9607[66:35]), .mem_addr(_9607[34:3]), .mem_instr(_9607[2:2]), .mem_valid(_9607[1:1]), .trap(_9607[0:0]) );
    assign _9671 = _9607[0:0];
    opicorv32_rv32
        the_opicorv32_rv32
        ( .clk(clk), .resetn(resetn), .mem_ready(mem_ready), .mem_rdata(mem_rdata), .pcpi_wr(pcpi_wr), .pcpi_rd(pcpi_rd), .pcpi_wait(pcpi_wait), .pcpi_ready(pcpi_ready), .irq(irq), .eoi(_9609[269:238]), .pcpi_rs2(_9609[237:206]), .pcpi_rs1(_9609[205:174]), .pcpi_insn(_9609[173:142]), .pcpi_valid(_9609[141:141]), .mem_la_wstrb(_9609[140:137]), .mem_la_wdata(_9609[136:105]), .mem_la_addr(_9609[104:73]), .mem_la_write(_9609[72:72]), .mem_la_read(_9609[71:71]), .mem_wstrb(_9609[70:67]), .mem_wdata(_9609[66:35]), .mem_addr(_9609[34:3]), .mem_instr(_9609[2:2]), .mem_valid(_9609[1:1]), .trap(_9609[0:0]) );
    assign _9625 = _9609[0:0];
    assign compare_trap = _9625 ^ _9671;
    assign _9673 = compare_trap ^ _9671;

    /* aliases */

    /* output assignments */
    assign trap = _9673;
    assign mem_valid = _9670;
    assign mem_instr = _9667;
    assign mem_addr = _9664;
    assign mem_wdata = _9661;
    assign mem_wstrb = _9658;
    assign mem_la_read = _9655;
    assign mem_la_write = _9652;
    assign mem_la_addr = _9649;
    assign mem_la_wdata = _9646;
    assign mem_la_wstrb = _9643;
    assign pcpi_valid = _9640;
    assign pcpi_insn = _9637;
    assign pcpi_rs1 = _9634;
    assign pcpi_rs2 = _9631;
    assign eoi = _9628;

endmodule
