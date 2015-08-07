module opicorv32_mul (
    pcpi_rs2,
    pcpi_rs1,
    clk,
    pcpi_insn,
    pcpi_valid,
    resetn,
    pcpi_wr,
    pcpi_rd,
    pcpi_wait,
    pcpi_ready
);

    input [31:0] pcpi_rs2;
    input [31:0] pcpi_rs1;
    input clk;
    input [31:0] pcpi_insn;
    input pcpi_valid;
    input resetn;
    output pcpi_wr;
    output [31:0] pcpi_rd;
    output pcpi_wait;
    output pcpi_ready;

    /* signal declarations */
    wire _1720 = 1'b0;
    reg _1721;
    wire [31:0] _1726 = 32'b00000000000000000000000000000000;
    wire [31:0] _1725 = 32'b00000000000000000000000000000000;
    wire [31:0] _1723;
    wire [63:0] _1636 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] _1634 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] _1676 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] _1639;
    wire [63:0] _1632 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] _1630 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] _1675 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire _1649 = 1'b0;
    wire [63:0] _1643;
    wire [63:0] _1624 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] _1622 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire _1684;
    wire [1:0] _1685;
    wire [3:0] _1686;
    wire [7:0] _1687;
    wire [15:0] _1688;
    wire [31:0] _1689;
    wire [63:0] _1691;
    wire [31:0] _1681 = 32'b00000000000000000000000000000000;
    wire [63:0] _1683;
    wire [63:0] _1692;
    wire _1655 = 1'b0;
    wire [62:0] _1656;
    wire [63:0] _1657;
    wire [63:0] _1717;
    wire [63:0] _1623;
    reg [63:0] _1625;
    wire [63:0] _1644;
    wire [63:0] _1645;
    wire [63:0] _1646;
    wire [63:0] _1642;
    wire _1647;
    wire [63:0] _1648;
    wire [62:0] _1650;
    wire [63:0] _1651;
    wire [63:0] _1715;
    wire [63:0] _1631;
    reg [63:0] _1633;
    wire [63:0] _1638;
    wire [63:0] _1628 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] _1626 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire _1700;
    wire [1:0] _1701;
    wire [3:0] _1702;
    wire [7:0] _1703;
    wire [15:0] _1704;
    wire [31:0] _1705;
    wire [63:0] _1707;
    wire [31:0] _1697 = 32'b00000000000000000000000000000000;
    wire [63:0] _1699;
    wire _1615;
    wire [63:0] _1708;
    wire [62:0] _1652;
    wire _1653 = 1'b0;
    wire [63:0] _1654;
    wire [63:0] _1716;
    wire [63:0] _1627;
    reg [63:0] _1629;
    wire _1640;
    wire [63:0] _1641;
    wire [63:0] _1714;
    wire [63:0] _1635;
    reg [63:0] _1637;
    wire [31:0] _1722;
    wire [31:0] _1724;
    reg [31:0] _1727;
    wire _1718 = 1'b0;
    wire _1666 = 1'b0;
    wire _1709;
    wire _1663 = 1'b0;
    wire _1618 = 1'b0;
    reg _1619;
    wire _1620;
    wire _1616 = 1'b0;
    wire _1590 = 1'b0;
    wire [2:0] _1587 = 3'b000;
    wire [2:0] _1586;
    wire _1588;
    wire _1589;
    reg _1591;
    wire _1610;
    wire _1611;
    wire _1612;
    reg _1617;
    wire _1621;
    wire _1671;
    wire [6:0] _1660 = 7'b0000000;
    wire [6:0] _1658 = 7'b0000000;
    wire [6:0] _1673 = 7'b0111110;
    wire [6:0] _1672 = 7'b0011110;
    wire _1608 = 1'b0;
    wire [2:0] _1605 = 3'b011;
    wire [2:0] _1604;
    wire _1606;
    wire _1607;
    reg _1609;
    wire _1602 = 1'b0;
    wire [2:0] _1599 = 3'b010;
    wire [2:0] _1598;
    wire _1600;
    wire _1601;
    reg _1603;
    wire vdd = 1'b1;
    wire _1596 = 1'b0;
    wire gnd = 1'b0;
    wire [2:0] _1593 = 3'b001;
    wire [2:0] _1592;
    wire _1594;
    wire [6:0] _1578 = 7'b0000001;
    wire [6:0] _1577;
    wire _1579;
    wire [6:0] _1581 = 7'b0110011;
    wire [6:0] _1580;
    wire _1582;
    wire _1583;
    wire _1584;
    wire _1585;
    wire _1595;
    reg _1597;
    wire _1613;
    wire _1614;
    wire [6:0] _1674;
    wire [6:0] _1669 = 7'b0000001;
    wire [6:0] _1670;
    wire [6:0] _1713;
    wire [6:0] _1659;
    reg [6:0] _1661;
    wire _1668;
    wire _1711;
    wire _1712;
    wire _1662;
    reg _1664;
    wire _1710;
    wire _1665;
    reg _1667;
    reg _1719;

    /* logic */
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _1721 <= gnd;
        else
            _1721 <= _1667;
    end
    assign _1723 = _1637[63:32];
    assign _1639 = _1638 ^ _1625;
    assign _1643 = _1633 & _1625;
    assign _1684 = pcpi_rs2[31:31];
    assign _1685 = { _1684, _1684 };
    assign _1686 = { _1685, _1685 };
    assign _1687 = { _1686, _1686 };
    assign _1688 = { _1687, _1687 };
    assign _1689 = { _1688, _1688 };
    assign _1691 = { _1689, pcpi_rs2 };
    assign _1683 = { _1681, pcpi_rs2 };
    assign _1692 = _1597 ? _1691 : _1683;
    assign _1656 = _1625[62:0];
    assign _1657 = { _1656, _1655 };
    assign _1717 = _1664 ? _1692 : _1657;
    assign _1623 = _1717;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _1625 <= _1622;
        else
            _1625 <= _1623;
    end
    assign _1644 = _1637 & _1625;
    assign _1645 = _1642 | _1644;
    assign _1646 = _1645 | _1643;
    assign _1642 = _1637 & _1633;
    assign _1647 = _1629[0:0];
    assign _1648 = _1647 ? _1646 : _1642;
    assign _1650 = _1648[62:0];
    assign _1651 = { _1650, _1649 };
    assign _1715 = _1664 ? _1675 : _1651;
    assign _1631 = _1715;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _1633 <= _1630;
        else
            _1633 <= _1631;
    end
    assign _1638 = _1637 ^ _1633;
    assign _1700 = pcpi_rs1[31:31];
    assign _1701 = { _1700, _1700 };
    assign _1702 = { _1701, _1701 };
    assign _1703 = { _1702, _1702 };
    assign _1704 = { _1703, _1703 };
    assign _1705 = { _1704, _1704 };
    assign _1707 = { _1705, pcpi_rs1 };
    assign _1699 = { _1697, pcpi_rs1 };
    assign _1615 = _1597 | _1603;
    assign _1708 = _1615 ? _1707 : _1699;
    assign _1652 = _1629[63:1];
    assign _1654 = { _1653, _1652 };
    assign _1716 = _1664 ? _1708 : _1654;
    assign _1627 = _1716;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _1629 <= _1626;
        else
            _1629 <= _1627;
    end
    assign _1640 = _1629[0:0];
    assign _1641 = _1640 ? _1639 : _1638;
    assign _1714 = _1664 ? _1676 : _1641;
    assign _1635 = _1714;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _1637 <= _1634;
        else
            _1637 <= _1635;
    end
    assign _1722 = _1637[31:0];
    assign _1724 = _1614 ? _1723 : _1722;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _1727 <= _1725;
        else
            if (_1667)
                _1727 <= _1724;
    end
    assign _1709 = _1668 ? vdd : gnd;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _1619 <= gnd;
        else
            _1619 <= _1617;
    end
    assign _1620 = ~ _1619;
    assign _1586 = pcpi_insn[14:12];
    assign _1588 = _1586 == _1587;
    assign _1589 = _1585 & _1588;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _1591 <= gnd;
        else
            _1591 <= _1589;
    end
    assign _1610 = _1591 | _1597;
    assign _1611 = _1610 | _1603;
    assign _1612 = _1611 | _1609;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _1617 <= gnd;
        else
            _1617 <= _1612;
    end
    assign _1621 = _1617 & _1620;
    assign _1671 = ~ _1621;
    assign _1604 = pcpi_insn[14:12];
    assign _1606 = _1604 == _1605;
    assign _1607 = _1585 & _1606;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _1609 <= gnd;
        else
            _1609 <= _1607;
    end
    assign _1598 = pcpi_insn[14:12];
    assign _1600 = _1598 == _1599;
    assign _1601 = _1585 & _1600;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _1603 <= gnd;
        else
            _1603 <= _1601;
    end
    assign _1592 = pcpi_insn[14:12];
    assign _1594 = _1592 == _1593;
    assign _1577 = pcpi_insn[31:25];
    assign _1579 = _1577 == _1578;
    assign _1580 = pcpi_insn[6:0];
    assign _1582 = _1580 == _1581;
    assign _1583 = resetn & pcpi_valid;
    assign _1584 = _1583 & _1582;
    assign _1585 = _1584 & _1579;
    assign _1595 = _1585 & _1594;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _1597 <= gnd;
        else
            _1597 <= _1595;
    end
    assign _1613 = _1597 | _1603;
    assign _1614 = _1613 | _1609;
    assign _1674 = _1614 ? _1673 : _1672;
    assign _1670 = _1661 - _1669;
    assign _1713 = _1664 ? _1674 : _1670;
    assign _1659 = _1713;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _1661 <= _1658;
        else
            _1661 <= _1659;
    end
    assign _1668 = _1661[6:6];
    assign _1711 = _1668 ? vdd : _1664;
    assign _1712 = _1664 ? _1671 : _1711;
    assign _1662 = _1712;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _1664 <= vdd;
        else
            _1664 <= _1662;
    end
    assign _1710 = _1664 ? gnd : _1709;
    assign _1665 = _1710;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _1667 <= gnd;
        else
            _1667 <= _1665;
    end
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _1719 <= gnd;
        else
            _1719 <= _1667;
    end

    /* aliases */

    /* output assignments */
    assign pcpi_wr = _1719;
    assign pcpi_rd = _1727;
    assign pcpi_wait = _1617;
    assign pcpi_ready = _1721;

endmodule
