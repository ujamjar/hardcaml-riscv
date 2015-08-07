module opicorv32_memif (
    mem_rdata,
    reg_op2,
    mem_wordsize,
    next_pc,
    reg_op1,
    resetn,
    clk,
    mem_do_prefetch,
    mem_do_wdata,
    mem_do_rdata,
    mem_do_rinst,
    mem_ready,
    mem_done,
    mem_valid,
    mem_instr,
    mem_addr,
    mem_wdata,
    mem_wstrb,
    mem_rdata_latched,
    mem_rdata_q,
    mem_rdata_word,
    mem_la_read,
    mem_la_write,
    mem_la_addr,
    mem_la_wdata,
    mem_la_wstrb
);

    input [31:0] mem_rdata;
    input [31:0] reg_op2;
    input [1:0] mem_wordsize;
    input [31:0] next_pc;
    input [31:0] reg_op1;
    input resetn;
    input clk;
    input mem_do_prefetch;
    input mem_do_wdata;
    input mem_do_rdata;
    input mem_do_rinst;
    input mem_ready;
    output mem_done;
    output mem_valid;
    output mem_instr;
    output [31:0] mem_addr;
    output [31:0] mem_wdata;
    output [3:0] mem_wstrb;
    output [31:0] mem_rdata_latched;
    output [31:0] mem_rdata_q;
    output [31:0] mem_rdata_word;
    output mem_la_read;
    output mem_la_write;
    output [31:0] mem_la_addr;
    output [31:0] mem_la_wdata;
    output [3:0] mem_la_wstrb;

    /* signal declarations */
    wire _1326;
    wire _1327;
    wire _1328;
    wire _1329;
    wire _1313;
    wire _1330;
    wire _1331;
    wire [7:0] _1389;
    wire [23:0] _1394 = 24'b000000000000000000000000;
    wire [31:0] _1396;
    wire [7:0] _1381;
    wire [23:0] _1386 = 24'b000000000000000000000000;
    wire [31:0] _1388;
    wire [7:0] _1373;
    wire [23:0] _1378 = 24'b000000000000000000000000;
    wire [31:0] _1380;
    wire [7:0] _1365;
    wire [23:0] _1370 = 24'b000000000000000000000000;
    wire [31:0] _1372;
    wire [1:0] _1397;
    reg [31:0] _1398;
    wire [15:0] _1399;
    wire [15:0] _1403 = 16'b0000000000000000;
    wire [31:0] _1405;
    wire [15:0] _1406;
    wire [15:0] _1410 = 16'b0000000000000000;
    wire [31:0] _1412;
    wire _1413;
    wire [31:0] _1414;
    reg [31:0] _1415;
    wire _1338;
    wire [31:0] _1340 = 32'b00000000000000000000000000000000;
    wire [31:0] _1339 = 32'b00000000000000000000000000000000;
    reg [31:0] _1341;
    wire _1342;
    wire _1343;
    wire [31:0] _1344;
    wire [31:0] _1337;
    wire [3:0] _1426 = 4'b0000;
    wire [3:0] _1424 = 4'b0000;
    wire [3:0] _1432 = 4'b0000;
    wire [3:0] _1356 = 4'b1000;
    wire [3:0] _1355 = 4'b0100;
    wire [3:0] _1354 = 4'b0010;
    wire [3:0] _1353 = 4'b0001;
    wire [1:0] _1357;
    reg [3:0] _1358;
    wire [3:0] _1360 = 4'b1100;
    wire [3:0] _1359 = 4'b0011;
    wire _1361;
    wire [3:0] _1362;
    wire [3:0] _1363 = 4'b1111;
    reg [3:0] _1364;
    wire [3:0] _1440;
    wire _1441;
    wire [3:0] _1442;
    wire [3:0] _1425;
    reg [3:0] _1427;
    wire [31:0] _1422 = 32'b00000000000000000000000000000000;
    wire [31:0] _1420 = 32'b00000000000000000000000000000000;
    wire [7:0] _1348;
    wire [15:0] _1349;
    wire [31:0] _1350;
    wire [15:0] _1345;
    wire [31:0] _1346;
    reg [31:0] _1352;
    wire _1443;
    wire [31:0] _1444;
    wire [31:0] _1421;
    reg [31:0] _1423;
    wire [31:0] _1418 = 32'b00000000000000000000000000000000;
    wire [31:0] _1416 = 32'b00000000000000000000000000000000;
    wire [1:0] _1332 = 2'b00;
    wire [29:0] _1333;
    wire [31:0] _1334;
    wire _1335;
    wire [31:0] _1336;
    wire _1445;
    wire [31:0] _1446;
    wire [31:0] _1417;
    reg [31:0] _1419;
    wire _1429 = 1'b0;
    wire _1433;
    wire _1436;
    wire _1437;
    wire _1438;
    wire _1439;
    wire _1428;
    reg _1430;
    wire _1318 = 1'b0;
    wire _1447;
    wire _1448;
    wire _1449;
    wire _1450;
    wire _1451;
    wire _1452;
    wire _1453;
    wire _1454;
    wire _1455;
    wire _1456;
    wire _1317;
    reg _1319;
    wire _1314;
    wire _1320;
    wire _1321;
    wire _1322;
    wire vdd = 1'b1;
    wire [1:0] _1311 = 2'b00;
    wire gnd = 1'b0;
    wire [1:0] _1305 = 2'b00;
    wire _1434;
    wire _1435;
    wire [1:0] _1457;
    wire [1:0] _1458;
    wire _1431;
    wire [1:0] _1459;
    wire [1:0] _1460;
    wire [1:0] _1461;
    wire [1:0] _1462;
    wire [1:0] _1306 = 2'b11;
    wire _1463;
    wire [1:0] _1464;
    wire [1:0] _1307 = 2'b10;
    wire _1465;
    wire [1:0] _1466;
    wire [1:0] _1308 = 2'b01;
    wire _1467;
    wire [1:0] _1468;
    wire _1469;
    wire [1:0] _1470;
    wire [1:0] _1310;
    reg [1:0] _1312;
    wire [1:0] _1309 = 2'b00;
    wire _1315;
    wire _1316;
    wire _1323;
    wire _1324;
    wire _1325;

    /* logic */
    assign _1326 = resetn & _1313;
    assign _1327 = _1326 & mem_do_wdata;
    assign _1328 = mem_do_rinst | mem_do_prefetch;
    assign _1329 = _1328 | mem_do_rdata;
    assign _1313 = _1309 == _1312;
    assign _1330 = resetn & _1313;
    assign _1331 = _1330 & _1329;
    assign _1389 = mem_rdata[31:24];
    assign _1396 = { _1394, _1389 };
    assign _1381 = mem_rdata[23:16];
    assign _1388 = { _1386, _1381 };
    assign _1373 = mem_rdata[15:8];
    assign _1380 = { _1378, _1373 };
    assign _1365 = mem_rdata[7:0];
    assign _1372 = { _1370, _1365 };
    assign _1397 = reg_op1[1:0];
    always @* begin
        case (_1397)
        0: _1398 <= _1372;
        1: _1398 <= _1380;
        2: _1398 <= _1388;
        default: _1398 <= _1396;
        endcase
    end
    assign _1399 = mem_rdata[31:16];
    assign _1405 = { _1403, _1399 };
    assign _1406 = mem_rdata[15:0];
    assign _1412 = { _1410, _1406 };
    assign _1413 = reg_op1[1:1];
    assign _1414 = _1413 ? _1405 : _1412;
    always @* begin
        case (mem_wordsize)
        0: _1415 <= mem_rdata;
        1: _1415 <= _1414;
        default: _1415 <= _1398;
        endcase
    end
    assign _1338 = _1319 & mem_ready;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _1341 <= _1339;
        else
            if (_1338)
                _1341 <= _1337;
    end
    assign _1342 = _1319 & mem_ready;
    assign _1343 = _1342 | gnd;
    assign _1344 = _1343 ? mem_rdata : _1341;
    assign _1337 = _1344;
    assign _1357 = reg_op1[1:0];
    always @* begin
        case (_1357)
        0: _1358 <= _1353;
        1: _1358 <= _1354;
        2: _1358 <= _1355;
        default: _1358 <= _1356;
        endcase
    end
    assign _1361 = reg_op1[1:1];
    assign _1362 = _1361 ? _1360 : _1359;
    always @* begin
        case (mem_wordsize)
        0: _1364 <= _1363;
        1: _1364 <= _1362;
        default: _1364 <= _1358;
        endcase
    end
    assign _1440 = _1435 ? _1432 : _1364;
    assign _1441 = _1312 == _1309;
    assign _1442 = _1441 ? _1440 : _1427;
    assign _1425 = _1442;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _1427 <= _1424;
        else
            _1427 <= _1425;
    end
    assign _1348 = reg_op2[7:0];
    assign _1349 = { _1348, _1348 };
    assign _1350 = { _1349, _1349 };
    assign _1345 = reg_op2[15:0];
    assign _1346 = { _1345, _1345 };
    always @* begin
        case (mem_wordsize)
        0: _1352 <= reg_op2;
        1: _1352 <= _1346;
        default: _1352 <= _1350;
        endcase
    end
    assign _1443 = _1312 == _1309;
    assign _1444 = _1443 ? _1352 : _1423;
    assign _1421 = _1444;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _1423 <= _1420;
        else
            _1423 <= _1421;
    end
    assign _1333 = reg_op1[31:2];
    assign _1334 = { _1333, _1332 };
    assign _1335 = mem_do_prefetch | mem_do_rinst;
    assign _1336 = _1335 ? next_pc : _1334;
    assign _1445 = _1312 == _1309;
    assign _1446 = _1445 ? _1336 : _1419;
    assign _1417 = _1446;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _1419 <= _1416;
        else
            _1419 <= _1417;
    end
    assign _1433 = mem_do_prefetch | mem_do_rinst;
    assign _1436 = _1435 ? _1433 : _1430;
    assign _1437 = mem_do_wdata ? gnd : _1436;
    assign _1438 = _1312 == _1309;
    assign _1439 = _1438 ? _1437 : _1430;
    assign _1428 = _1439;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _1430 <= gnd;
        else
            _1430 <= _1428;
    end
    assign _1447 = _1435 ? vdd : _1319;
    assign _1448 = mem_do_wdata ? vdd : _1447;
    assign _1449 = mem_ready ? gnd : _1319;
    assign _1450 = mem_ready ? gnd : _1319;
    assign _1451 = _1312 == _1307;
    assign _1452 = _1451 ? _1450 : _1319;
    assign _1453 = _1312 == _1308;
    assign _1454 = _1453 ? _1449 : _1452;
    assign _1455 = _1312 == _1309;
    assign _1456 = _1455 ? _1448 : _1454;
    assign _1317 = _1456;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _1319 <= gnd;
        else
            _1319 <= _1317;
    end
    assign _1314 = _1306 == _1312;
    assign _1320 = _1314 & mem_do_rinst;
    assign _1321 = mem_do_rinst | mem_do_rdata;
    assign _1322 = _1321 | mem_do_wdata;
    assign _1434 = mem_do_prefetch | mem_do_rinst;
    assign _1435 = _1434 | mem_do_rdata;
    assign _1457 = _1435 ? _1308 : _1312;
    assign _1458 = mem_do_wdata ? _1307 : _1457;
    assign _1431 = mem_do_rinst | mem_do_rdata;
    assign _1459 = _1431 ? _1309 : _1306;
    assign _1460 = mem_ready ? _1459 : _1312;
    assign _1461 = mem_ready ? _1309 : _1312;
    assign _1462 = mem_do_rinst ? _1309 : _1312;
    assign _1463 = _1312 == _1306;
    assign _1464 = _1463 ? _1462 : _1312;
    assign _1465 = _1312 == _1307;
    assign _1466 = _1465 ? _1461 : _1464;
    assign _1467 = _1312 == _1308;
    assign _1468 = _1467 ? _1460 : _1466;
    assign _1469 = _1312 == _1309;
    assign _1470 = _1469 ? _1458 : _1468;
    assign _1310 = _1470;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _1312 <= _1305;
        else
            _1312 <= _1310;
    end
    assign _1315 = _1309 == _1312;
    assign _1316 = ~ _1315;
    assign _1323 = mem_ready & _1316;
    assign _1324 = _1323 & _1322;
    assign _1325 = _1324 | _1320;

    /* aliases */

    /* output assignments */
    assign mem_done = _1325;
    assign mem_valid = _1319;
    assign mem_instr = _1430;
    assign mem_addr = _1419;
    assign mem_wdata = _1423;
    assign mem_wstrb = _1427;
    assign mem_rdata_latched = _1337;
    assign mem_rdata_q = _1341;
    assign mem_rdata_word = _1415;
    assign mem_la_read = _1331;
    assign mem_la_write = _1327;
    assign mem_la_addr = _1336;
    assign mem_la_wdata = _1352;
    assign mem_la_wstrb = _1364;

endmodule
