module fetch (
    mio_data_vld,
    mio_data_rdata,
    mio_instr_vld,
    mio_instr_rdata,
    pc_p_4,
    branch_p_4,
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

    input mio_data_vld;
    input [31:0] mio_data_rdata;
    input mio_instr_vld;
    input [31:0] mio_instr_rdata;
    input [31:0] pc_p_4;
    input branch_p_4;
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
    wire _2170 = 1'b0;
    wire _2171 = 1'b0;
    wire _1815;
    wire _1816;
    wire _1817;
    wire _1818;
    wire _1819;
    wire _1820;
    wire _1821;
    wire _1822;
    wire _1823;
    wire _1824;
    wire _1825;
    wire _1826;
    wire _1827;
    wire _1828;
    wire _1829;
    wire _1830;
    wire _1831;
    wire _1832;
    wire _1833;
    wire _1834;
    wire _1835;
    wire _1836;
    wire _1837;
    wire _1838;
    wire _1839;
    wire _1840;
    wire _1841;
    wire _1842;
    wire _1843;
    wire _1844;
    wire _1845;
    wire _1846;
    wire _1847;
    wire _1848;
    wire _1849;
    wire _1850;
    wire _1851;
    wire _1852;
    wire _1853;
    wire _1854;
    wire _1855;
    wire _1856;
    wire _1857;
    wire _1858;
    wire _1859;
    wire _1860;
    wire _1861;
    wire _1862;
    wire _1863;
    wire _1864;
    wire _1865;
    wire _1866;
    wire _1867;
    wire _1868;
    wire _1869;
    wire _1870;
    wire _1871;
    wire _1872;
    wire _1873;
    wire _1874;
    wire _1875;
    wire _1876;
    wire _1877;
    wire _1878;
    wire _1879;
    wire _1880;
    wire _1881;
    wire [67:0] _1814;
    wire _1882;
    wire _1883;
    wire _1884;
    wire _1885;
    wire _1886;
    wire _1887;
    wire _1888;
    wire _1889;
    wire _1890;
    wire _1891;
    wire _1892;
    wire _1893;
    wire _1894;
    wire _1895;
    wire _1896;
    wire _1897;
    wire _1898;
    wire _1899;
    wire _1900;
    wire _1901;
    wire _1902;
    wire _1903;
    wire _1904;
    wire _1905;
    wire _1906;
    wire _1907;
    wire _1908;
    wire _1909;
    wire _1910;
    wire _1911;
    wire _1912;
    wire _1913;
    wire _1914;
    wire _1915;
    wire _1916;
    wire _1917;
    wire _1918;
    wire _1919;
    wire _1920;
    wire _1921;
    wire _1922;
    wire _1923;
    wire _1924;
    wire _1925;
    wire _1926;
    wire _1927;
    wire _1928;
    wire _1929;
    wire _1930;
    wire _1931;
    wire _1932;
    wire _1933;
    wire _1934;
    wire _1935;
    wire _1936;
    wire _1937;
    wire _1938;
    wire _1939;
    wire _1940;
    wire _1941;
    wire _1942;
    wire _1943;
    wire _1944;
    wire _1945;
    wire _1946;
    wire _1947;
    wire _1948;
    wire _1949;
    reg _2172;
    wire [3:0] _2166 = 4'b0000;
    wire [3:0] _2167 = 4'b0000;
    wire [3:0] _1951 = 4'b0000;
    reg [3:0] _2168;
    wire _2162 = 1'b0;
    wire _2163 = 1'b0;
    wire _1952 = 1'b0;
    reg _2164;
    wire _2158 = 1'b0;
    wire _2159 = 1'b0;
    wire _1953 = 1'b0;
    reg _2160;
    wire [31:0] _2154 = 32'b00000000000000000000000000000000;
    wire [31:0] _2155 = 32'b00000000000000000000000000000000;
    wire [31:0] _1954 = 32'b00000000000000000000000000000000;
    reg [31:0] _2156;
    wire [31:0] _2150 = 32'b00000000000000000000000000000000;
    wire [31:0] _2151 = 32'b00000000000000000000000000000000;
    wire [31:0] _1955 = 32'b00000000000000000000000000000000;
    reg [31:0] _2152;
    wire [3:0] _2146 = 4'b0000;
    wire [3:0] _2147 = 4'b0000;
    wire [3:0] _1994 = 4'b0000;
    reg [3:0] _2148;
    wire _2142 = 1'b0;
    wire _2143 = 1'b0;
    reg _2144;
    wire _2138 = 1'b0;
    wire _2139 = 1'b0;
    wire _1995 = 1'b0;
    reg _1996;
    reg _2140;
    wire [31:0] _2134 = 32'b00000000000000000000000000000000;
    wire [31:0] _2135 = 32'b00000000000000000000000000000000;
    wire [31:0] _1997 = 32'b00000000000000000000000000000000;
    reg [31:0] _2136;
    wire [31:0] _2130 = 32'b00000000000000000000000000000000;
    wire [31:0] _2131 = 32'b00000000000000000000000000000000;
    reg [31:0] _2132;
    wire _2126 = 1'b0;
    wire _2127 = 1'b0;
    wire _1961 = 1'b0;
    reg _2128;
    wire _2122 = 1'b0;
    wire _2123 = 1'b0;
    wire _1962 = 1'b0;
    reg _2124;
    wire _2118 = 1'b0;
    wire _2119 = 1'b0;
    wire _1963 = 1'b0;
    reg _2120;
    wire [2:0] _2114 = 3'b000;
    wire [2:0] _2115 = 3'b000;
    wire [2:0] _1964 = 3'b000;
    reg [2:0] _2116;
    wire [2:0] _2110 = 3'b000;
    wire [2:0] _2111 = 3'b000;
    wire [2:0] _1965 = 3'b000;
    reg [2:0] _2112;
    wire _2106 = 1'b0;
    wire _2107 = 1'b0;
    wire _1966 = 1'b0;
    reg _2108;
    wire _2102 = 1'b0;
    wire _2103 = 1'b0;
    wire _1967 = 1'b0;
    reg _2104;
    wire _2098 = 1'b0;
    wire _2099 = 1'b0;
    wire _1968 = 1'b0;
    reg _2100;
    wire _2094 = 1'b0;
    wire _2095 = 1'b0;
    wire _1969 = 1'b0;
    reg _2096;
    wire _2090 = 1'b0;
    wire _2091 = 1'b0;
    wire _1970 = 1'b0;
    reg _2092;
    wire _2086 = 1'b0;
    wire _2087 = 1'b0;
    wire _1971 = 1'b0;
    reg _2088;
    wire _2082 = 1'b0;
    wire _2083 = 1'b0;
    wire _1972 = 1'b0;
    reg _2084;
    wire _2078 = 1'b0;
    wire _2079 = 1'b0;
    wire _1973 = 1'b0;
    reg _2080;
    wire _2074 = 1'b0;
    wire _2075 = 1'b0;
    wire _1974 = 1'b0;
    reg _2076;
    wire _2070 = 1'b0;
    wire _2071 = 1'b0;
    wire _1975 = 1'b0;
    reg _2072;
    wire _2066 = 1'b0;
    wire _2067 = 1'b0;
    wire _1976 = 1'b0;
    reg _2068;
    wire _2062 = 1'b0;
    wire _2063 = 1'b0;
    wire _1977 = 1'b0;
    reg _2064;
    wire _2058 = 1'b0;
    wire _2059 = 1'b0;
    wire _1978 = 1'b0;
    reg _2060;
    wire [47:0] _2054 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _2055 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _1979 = 48'b000000000000000000000000000000000000000000000000;
    reg [47:0] _2056;
    wire [31:0] _2050 = 32'b00000000000000000000000000000000;
    wire [31:0] _2051 = 32'b00000000000000000000000000000000;
    wire [31:0] _1980 = 32'b00000000000000000000000000000000;
    reg [31:0] _2052;
    wire [31:0] _2046 = 32'b00000000000000000000000000000000;
    wire [31:0] _2047 = 32'b00000000000000000000000000000000;
    wire [31:0] _1807 = 32'b00000000000000000000000000010000;
    wire [31:0] _1809 = 32'b00000000000000000000000000000000;
    wire [31:0] _876 = 32'b00000000000000000000000000000000;
    wire [31:0] _877 = 32'b00000000000000000000000000000000;
    reg [31:0] _878;
    wire [31:0] _1811 = 32'b00000000000000000000000000000100;
    wire [31:0] _1812;
    wire _800 = 1'b0;
    wire _801 = 1'b0;
    reg _802;
    wire [31:0] _1813;
    wire [31:0] _1808;
    reg [31:0] _1810;
    reg [31:0] _2048;
    wire [31:0] _2042 = 32'b00000000000000000000000000000000;
    wire [31:0] _2043 = 32'b00000000000000000000000000000000;
    wire [31:0] _1982 = 32'b00000000000000000000000000000000;
    reg [31:0] _2044;
    wire [31:0] _2038 = 32'b00000000000000000000000000000000;
    wire [31:0] _2039 = 32'b00000000000000000000000000000000;
    wire [31:0] _1983 = 32'b00000000000000000000000000000000;
    reg [31:0] _2040;
    wire [31:0] _2034 = 32'b00000000000000000000000000000000;
    wire [31:0] _2035 = 32'b00000000000000000000000000000000;
    wire [31:0] _1984 = 32'b00000000000000000000000000000000;
    reg [31:0] _2036;
    wire [31:0] _2030 = 32'b00000000000000000000000000000000;
    wire [31:0] _2031 = 32'b00000000000000000000000000000000;
    wire [31:0] _1985 = 32'b00000000000000000000000000000000;
    reg [31:0] _2032;
    wire [31:0] _2026 = 32'b00000000000000000000000000000000;
    wire [31:0] _2027 = 32'b00000000000000000000000000000000;
    wire [31:0] _1986 = 32'b00000000000000000000000000000000;
    reg [31:0] _2028;
    wire _2022 = 1'b0;
    wire _2023 = 1'b0;
    wire _1987 = 1'b0;
    reg _2024;
    wire _2018 = 1'b0;
    wire _2019 = 1'b0;
    wire _1988 = 1'b0;
    reg _2020;
    wire _2014 = 1'b0;
    wire _2015 = 1'b0;
    wire _1989 = 1'b0;
    reg _2016;
    wire [4:0] _2010 = 5'b00000;
    wire [4:0] _2011 = 5'b00000;
    wire [4:0] _1990 = 5'b00000;
    reg [4:0] _2012;
    wire [4:0] _2006 = 5'b00000;
    wire [4:0] _2007 = 5'b00000;
    wire [4:0] _1991 = 5'b00000;
    reg [4:0] _2008;
    wire [4:0] _2002 = 5'b00000;
    wire [4:0] _2003 = 5'b00000;
    wire [4:0] _1992 = 5'b00000;
    reg [4:0] _2004;
    wire _1998 = 1'b0;
    wire _1999 = 1'b0;
    wire vdd = 1'b1;
    reg _2000;

    /* logic */
    assign _1815 = _1814[0:0];
    assign _1816 = _1814[1:1];
    assign _1817 = _1814[2:2];
    assign _1818 = _1814[3:3];
    assign _1819 = _1814[4:4];
    assign _1820 = _1814[5:5];
    assign _1821 = _1814[6:6];
    assign _1822 = _1814[7:7];
    assign _1823 = _1814[8:8];
    assign _1824 = _1814[9:9];
    assign _1825 = _1814[10:10];
    assign _1826 = _1814[11:11];
    assign _1827 = _1814[12:12];
    assign _1828 = _1814[13:13];
    assign _1829 = _1814[14:14];
    assign _1830 = _1814[15:15];
    assign _1831 = _1814[16:16];
    assign _1832 = _1814[17:17];
    assign _1833 = _1814[18:18];
    assign _1834 = _1814[19:19];
    assign _1835 = _1814[20:20];
    assign _1836 = _1814[21:21];
    assign _1837 = _1814[22:22];
    assign _1838 = _1814[23:23];
    assign _1839 = _1814[24:24];
    assign _1840 = _1814[25:25];
    assign _1841 = _1814[26:26];
    assign _1842 = _1814[27:27];
    assign _1843 = _1814[28:28];
    assign _1844 = _1814[29:29];
    assign _1845 = _1814[30:30];
    assign _1846 = _1814[31:31];
    assign _1847 = _1814[32:32];
    assign _1848 = _1814[33:33];
    assign _1849 = _1814[34:34];
    assign _1850 = _1814[35:35];
    assign _1851 = _1814[36:36];
    assign _1852 = _1814[37:37];
    assign _1853 = _1814[38:38];
    assign _1854 = _1814[39:39];
    assign _1855 = _1814[40:40];
    assign _1856 = _1814[41:41];
    assign _1857 = _1814[42:42];
    assign _1858 = _1814[43:43];
    assign _1859 = _1814[44:44];
    assign _1860 = _1814[45:45];
    assign _1861 = _1814[46:46];
    assign _1862 = _1814[47:47];
    assign _1863 = _1814[48:48];
    assign _1864 = _1814[49:49];
    assign _1865 = _1814[50:50];
    assign _1866 = _1814[51:51];
    assign _1867 = _1814[52:52];
    assign _1868 = _1814[53:53];
    assign _1869 = _1814[54:54];
    assign _1870 = _1814[55:55];
    assign _1871 = _1814[56:56];
    assign _1872 = _1814[57:57];
    assign _1873 = _1814[58:58];
    assign _1874 = _1814[59:59];
    assign _1875 = _1814[60:60];
    assign _1876 = _1814[61:61];
    assign _1877 = _1814[62:62];
    assign _1878 = _1814[63:63];
    assign _1879 = _1814[64:64];
    assign _1880 = _1814[65:65];
    assign _1881 = _1814[66:66];
    assign _1814 = { clk, clr, mio_instr_rdata, mio_instr_vld, mio_data_rdata, mio_data_vld };
    assign _1882 = _1814[67:67];
    assign _1883 = _1882 | _1881;
    assign _1884 = _1883 | _1880;
    assign _1885 = _1884 | _1879;
    assign _1886 = _1885 | _1878;
    assign _1887 = _1886 | _1877;
    assign _1888 = _1887 | _1876;
    assign _1889 = _1888 | _1875;
    assign _1890 = _1889 | _1874;
    assign _1891 = _1890 | _1873;
    assign _1892 = _1891 | _1872;
    assign _1893 = _1892 | _1871;
    assign _1894 = _1893 | _1870;
    assign _1895 = _1894 | _1869;
    assign _1896 = _1895 | _1868;
    assign _1897 = _1896 | _1867;
    assign _1898 = _1897 | _1866;
    assign _1899 = _1898 | _1865;
    assign _1900 = _1899 | _1864;
    assign _1901 = _1900 | _1863;
    assign _1902 = _1901 | _1862;
    assign _1903 = _1902 | _1861;
    assign _1904 = _1903 | _1860;
    assign _1905 = _1904 | _1859;
    assign _1906 = _1905 | _1858;
    assign _1907 = _1906 | _1857;
    assign _1908 = _1907 | _1856;
    assign _1909 = _1908 | _1855;
    assign _1910 = _1909 | _1854;
    assign _1911 = _1910 | _1853;
    assign _1912 = _1911 | _1852;
    assign _1913 = _1912 | _1851;
    assign _1914 = _1913 | _1850;
    assign _1915 = _1914 | _1849;
    assign _1916 = _1915 | _1848;
    assign _1917 = _1916 | _1847;
    assign _1918 = _1917 | _1846;
    assign _1919 = _1918 | _1845;
    assign _1920 = _1919 | _1844;
    assign _1921 = _1920 | _1843;
    assign _1922 = _1921 | _1842;
    assign _1923 = _1922 | _1841;
    assign _1924 = _1923 | _1840;
    assign _1925 = _1924 | _1839;
    assign _1926 = _1925 | _1838;
    assign _1927 = _1926 | _1837;
    assign _1928 = _1927 | _1836;
    assign _1929 = _1928 | _1835;
    assign _1930 = _1929 | _1834;
    assign _1931 = _1930 | _1833;
    assign _1932 = _1931 | _1832;
    assign _1933 = _1932 | _1831;
    assign _1934 = _1933 | _1830;
    assign _1935 = _1934 | _1829;
    assign _1936 = _1935 | _1828;
    assign _1937 = _1936 | _1827;
    assign _1938 = _1937 | _1826;
    assign _1939 = _1938 | _1825;
    assign _1940 = _1939 | _1824;
    assign _1941 = _1940 | _1823;
    assign _1942 = _1941 | _1822;
    assign _1943 = _1942 | _1821;
    assign _1944 = _1943 | _1820;
    assign _1945 = _1944 | _1819;
    assign _1946 = _1945 | _1818;
    assign _1947 = _1946 | _1817;
    assign _1948 = _1947 | _1816;
    assign _1949 = _1948 | _1815;
    always @(posedge clk) begin
        if (clr)
            _2172 <= _2170;
        else
            _2172 <= _1949;
    end
    always @(posedge clk) begin
        if (clr)
            _2168 <= _2166;
        else
            _2168 <= _1951;
    end
    always @(posedge clk) begin
        if (clr)
            _2164 <= _2162;
        else
            _2164 <= _1952;
    end
    always @(posedge clk) begin
        if (clr)
            _2160 <= _2158;
        else
            _2160 <= _1953;
    end
    always @(posedge clk) begin
        if (clr)
            _2156 <= _2154;
        else
            _2156 <= _1954;
    end
    always @(posedge clk) begin
        if (clr)
            _2152 <= _2150;
        else
            _2152 <= _1955;
    end
    always @(posedge clk) begin
        if (clr)
            _2148 <= _2146;
        else
            _2148 <= _1994;
    end
    always @(posedge clk) begin
        if (clr)
            _2144 <= _2142;
        else
            _2144 <= vdd;
    end
    always @(posedge clk) begin
        if (clr)
            _1996 <= vdd;
        else
            _1996 <= vdd;
    end
    always @(posedge clk) begin
        if (clr)
            _2140 <= _2138;
        else
            _2140 <= _1996;
    end
    always @(posedge clk) begin
        if (clr)
            _2136 <= _2134;
        else
            _2136 <= _1997;
    end
    always @(posedge clk) begin
        if (clr)
            _2132 <= _2130;
        else
            _2132 <= _1810;
    end
    always @(posedge clk) begin
        if (clr)
            _2128 <= _2126;
        else
            _2128 <= _1961;
    end
    always @(posedge clk) begin
        if (clr)
            _2124 <= _2122;
        else
            _2124 <= _1962;
    end
    always @(posedge clk) begin
        if (clr)
            _2120 <= _2118;
        else
            _2120 <= _1963;
    end
    always @(posedge clk) begin
        if (clr)
            _2116 <= _2114;
        else
            _2116 <= _1964;
    end
    always @(posedge clk) begin
        if (clr)
            _2112 <= _2110;
        else
            _2112 <= _1965;
    end
    always @(posedge clk) begin
        if (clr)
            _2108 <= _2106;
        else
            _2108 <= _1966;
    end
    always @(posedge clk) begin
        if (clr)
            _2104 <= _2102;
        else
            _2104 <= _1967;
    end
    always @(posedge clk) begin
        if (clr)
            _2100 <= _2098;
        else
            _2100 <= _1968;
    end
    always @(posedge clk) begin
        if (clr)
            _2096 <= _2094;
        else
            _2096 <= _1969;
    end
    always @(posedge clk) begin
        if (clr)
            _2092 <= _2090;
        else
            _2092 <= _1970;
    end
    always @(posedge clk) begin
        if (clr)
            _2088 <= _2086;
        else
            _2088 <= _1971;
    end
    always @(posedge clk) begin
        if (clr)
            _2084 <= _2082;
        else
            _2084 <= _1972;
    end
    always @(posedge clk) begin
        if (clr)
            _2080 <= _2078;
        else
            _2080 <= _1973;
    end
    always @(posedge clk) begin
        if (clr)
            _2076 <= _2074;
        else
            _2076 <= _1974;
    end
    always @(posedge clk) begin
        if (clr)
            _2072 <= _2070;
        else
            _2072 <= _1975;
    end
    always @(posedge clk) begin
        if (clr)
            _2068 <= _2066;
        else
            _2068 <= _1976;
    end
    always @(posedge clk) begin
        if (clr)
            _2064 <= _2062;
        else
            _2064 <= _1977;
    end
    always @(posedge clk) begin
        if (clr)
            _2060 <= _2058;
        else
            _2060 <= _1978;
    end
    always @(posedge clk) begin
        if (clr)
            _2056 <= _2054;
        else
            _2056 <= _1979;
    end
    always @(posedge clk) begin
        if (clr)
            _2052 <= _2050;
        else
            _2052 <= _1980;
    end
    always @(posedge clk) begin
        if (clr)
            _878 <= _876;
        else
            _878 <= pc_p_4;
    end
    assign _1812 = _1810 + _1811;
    always @(posedge clk) begin
        if (clr)
            _802 <= _800;
        else
            _802 <= branch_p_4;
    end
    assign _1813 = _802 ? _878 : _1812;
    assign _1808 = _1813;
    always @(posedge clk) begin
        if (clr)
            _1810 <= _1807;
        else
            _1810 <= _1808;
    end
    always @(posedge clk) begin
        if (clr)
            _2048 <= _2046;
        else
            _2048 <= _1810;
    end
    always @(posedge clk) begin
        if (clr)
            _2044 <= _2042;
        else
            _2044 <= _1982;
    end
    always @(posedge clk) begin
        if (clr)
            _2040 <= _2038;
        else
            _2040 <= _1983;
    end
    always @(posedge clk) begin
        if (clr)
            _2036 <= _2034;
        else
            _2036 <= _1984;
    end
    always @(posedge clk) begin
        if (clr)
            _2032 <= _2030;
        else
            _2032 <= _1985;
    end
    always @(posedge clk) begin
        if (clr)
            _2028 <= _2026;
        else
            _2028 <= _1986;
    end
    always @(posedge clk) begin
        if (clr)
            _2024 <= _2022;
        else
            _2024 <= _1987;
    end
    always @(posedge clk) begin
        if (clr)
            _2020 <= _2018;
        else
            _2020 <= _1988;
    end
    always @(posedge clk) begin
        if (clr)
            _2016 <= _2014;
        else
            _2016 <= _1989;
    end
    always @(posedge clk) begin
        if (clr)
            _2012 <= _2010;
        else
            _2012 <= _1990;
    end
    always @(posedge clk) begin
        if (clr)
            _2008 <= _2006;
        else
            _2008 <= _1991;
    end
    always @(posedge clk) begin
        if (clr)
            _2004 <= _2002;
        else
            _2004 <= _1992;
    end
    always @(posedge clk) begin
        if (clr)
            _2000 <= _1998;
        else
            _2000 <= vdd;
    end

    /* aliases */

    /* output assignments */
    assign pen = _2000;
    assign ra1 = _2004;
    assign ra2 = _2008;
    assign rad = _2012;
    assign ra1_zero = _2016;
    assign ra2_zero = _2020;
    assign rad_zero = _2024;
    assign rd1 = _2028;
    assign rd2 = _2032;
    assign rdd = _2036;
    assign rdm = _2040;
    assign imm = _2044;
    assign pc = _2048;
    assign instr = _2052;
    assign insn = _2056;
    assign trap = _2060;
    assign lui = _2064;
    assign auipc = _2068;
    assign jal = _2072;
    assign jalr = _2076;
    assign bra = _2080;
    assign ld = _2084;
    assign st = _2088;
    assign opi = _2092;
    assign opr = _2096;
    assign fen = _2100;
    assign sys = _2104;
    assign rdc = _2108;
    assign rdco = _2112;
    assign f3 = _2116;
    assign f7 = _2120;
    assign branch = _2124;
    assign rwe = _2128;
    assign mio_instr_addr = _2132;
    assign mio_instr_wdata = _2136;
    assign mio_instr_req = _2140;
    assign mio_instr_rw = _2144;
    assign mio_instr_wmask = _2148;
    assign mio_data_addr = _2152;
    assign mio_data_wdata = _2156;
    assign mio_data_req = _2160;
    assign mio_data_rw = _2164;
    assign mio_data_wmask = _2168;
    assign junk = _2172;

endmodule
