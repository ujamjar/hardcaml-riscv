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
    wire _1557 = 1'b0;
    wire _1558 = 1'b0;
    wire _1332;
    wire _1333;
    wire _1334;
    wire _1335;
    wire _1336;
    wire _1337;
    wire _1338;
    wire _1339;
    wire _1340;
    wire _1341;
    wire _1342;
    wire _1343;
    wire _1344;
    wire _1345;
    wire _1346;
    wire _1347;
    wire _1348;
    wire _1349;
    wire _1350;
    wire _1351;
    wire _1352;
    wire _1353;
    wire _1354;
    wire _1355;
    wire _1356;
    wire _1357;
    wire _1358;
    wire _1359;
    wire _1360;
    wire _1361;
    wire _1362;
    wire _1363;
    wire _1364;
    wire _1365;
    wire [34:0] _1331;
    wire _1366;
    wire _1367;
    wire _1368;
    wire _1369;
    wire _1370;
    wire _1371;
    wire _1372;
    wire _1373;
    wire _1374;
    wire _1375;
    wire _1376;
    wire _1377;
    wire _1378;
    wire _1379;
    wire _1380;
    wire _1381;
    wire _1382;
    wire _1383;
    wire _1384;
    wire _1385;
    wire _1386;
    wire _1387;
    wire _1388;
    wire _1389;
    wire _1390;
    wire _1391;
    wire _1392;
    wire _1393;
    wire _1394;
    wire _1395;
    wire _1396;
    wire _1397;
    wire _1398;
    wire _1399;
    wire _1400;
    reg _1559;
    wire _1553 = 1'b0;
    wire _1554 = 1'b0;
    wire _1402 = 1'b0;
    reg _1555;
    wire _1549 = 1'b0;
    wire _1550 = 1'b0;
    wire _1403 = 1'b0;
    reg _1551;
    wire _1545 = 1'b0;
    wire _1546 = 1'b0;
    wire _1404 = 1'b0;
    reg _1547;
    wire _1541 = 1'b0;
    wire _1542 = 1'b0;
    wire _1405 = 1'b0;
    reg _1543;
    wire _1537 = 1'b0;
    wire _1538 = 1'b0;
    wire _1406 = 1'b0;
    reg _1539;
    wire _1533 = 1'b0;
    wire _1534 = 1'b0;
    wire _1407 = 1'b0;
    reg _1535;
    wire _1529 = 1'b0;
    wire _1530 = 1'b0;
    wire _1408 = 1'b0;
    reg _1531;
    wire _1525 = 1'b0;
    wire _1526 = 1'b0;
    wire _1409 = 1'b0;
    reg _1527;
    wire _1521 = 1'b0;
    wire _1522 = 1'b0;
    wire _1410 = 1'b0;
    reg _1523;
    wire _1517 = 1'b0;
    wire _1518 = 1'b0;
    wire _1411 = 1'b0;
    reg _1519;
    wire _1513 = 1'b0;
    wire _1514 = 1'b0;
    wire _1412 = 1'b0;
    reg _1515;
    wire _1509 = 1'b0;
    wire _1510 = 1'b0;
    wire _1413 = 1'b0;
    reg _1511;
    wire _1505 = 1'b0;
    wire _1506 = 1'b0;
    wire _1414 = 1'b0;
    reg _1507;
    wire _1501 = 1'b0;
    wire _1502 = 1'b0;
    wire _1415 = 1'b0;
    reg _1503;
    wire _1497 = 1'b0;
    wire _1498 = 1'b0;
    wire _1416 = 1'b0;
    reg _1499;
    wire [47:0] _1493 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _1494 = 48'b000000000000000000000000000000000000000000000000;
    wire [47:0] _1417 = 48'b000000000000000000000000000000000000000000000000;
    reg [47:0] _1495;
    wire [31:0] _1489 = 32'b00000000000000000000000000000000;
    wire [31:0] _1490 = 32'b00000000000000000000000000000000;
    wire [31:0] _1418 = 32'b00000000000000000000000000000000;
    reg [31:0] _1491;
    wire [31:0] _1485 = 32'b00000000000000000000000000000000;
    wire [31:0] _1486 = 32'b00000000000000000000000000000000;
    wire [31:0] _1419 = 32'b00000000000000000000000000000000;
    reg [31:0] _1487;
    wire [31:0] _1481 = 32'b00000000000000000000000000000000;
    wire [31:0] _1482 = 32'b00000000000000000000000000000000;
    wire [31:0] _1325 = 32'b00000000000000000000000000010000;
    wire [31:0] _1327 = 32'b00000000000000000000000000000000;
    wire [31:0] _1329 = 32'b00000000000000000000000000000100;
    wire [31:0] _1330;
    wire [31:0] _1326;
    reg [31:0] fetch_pc;
    reg [31:0] _1483;
    wire [31:0] _1477 = 32'b00000000000000000000000000000000;
    wire [31:0] _1478 = 32'b00000000000000000000000000000000;
    wire [31:0] _1421 = 32'b00000000000000000000000000000000;
    reg [31:0] _1479;
    wire [31:0] _1473 = 32'b00000000000000000000000000000000;
    wire [31:0] _1474 = 32'b00000000000000000000000000000000;
    wire [31:0] _1422 = 32'b00000000000000000000000000000000;
    reg [31:0] _1475;
    wire [31:0] _1469 = 32'b00000000000000000000000000000000;
    wire [31:0] _1470 = 32'b00000000000000000000000000000000;
    wire [31:0] _1423 = 32'b00000000000000000000000000000000;
    reg [31:0] _1471;
    wire [31:0] _1465 = 32'b00000000000000000000000000000000;
    wire [31:0] _1466 = 32'b00000000000000000000000000000000;
    wire [31:0] _1424 = 32'b00000000000000000000000000000000;
    reg [31:0] _1467;
    wire [31:0] _1461 = 32'b00000000000000000000000000000000;
    wire [31:0] _1462 = 32'b00000000000000000000000000000000;
    wire [31:0] _1425 = 32'b00000000000000000000000000000000;
    reg [31:0] _1463;
    wire _1457 = 1'b0;
    wire _1458 = 1'b0;
    wire _1426 = 1'b0;
    reg _1459;
    wire _1453 = 1'b0;
    wire _1454 = 1'b0;
    wire _1427 = 1'b0;
    reg _1455;
    wire _1449 = 1'b0;
    wire _1450 = 1'b0;
    wire _1428 = 1'b0;
    reg _1451;
    wire [4:0] _1445 = 5'b00000;
    wire [4:0] _1446 = 5'b00000;
    wire [4:0] _1429 = 5'b00000;
    reg [4:0] _1447;
    wire [4:0] _1441 = 5'b00000;
    wire [4:0] _1442 = 5'b00000;
    wire [4:0] _1430 = 5'b00000;
    reg [4:0] _1443;
    wire [4:0] _1437 = 5'b00000;
    wire [4:0] _1438 = 5'b00000;
    wire [4:0] _1431 = 5'b00000;
    reg [4:0] _1439;
    wire _1433 = 1'b0;
    wire _1434 = 1'b0;
    wire vdd = 1'b1;
    reg _1435;

    /* logic */
    assign _1332 = _1331[0:0];
    assign _1333 = _1331[1:1];
    assign _1334 = _1331[2:2];
    assign _1335 = _1331[3:3];
    assign _1336 = _1331[4:4];
    assign _1337 = _1331[5:5];
    assign _1338 = _1331[6:6];
    assign _1339 = _1331[7:7];
    assign _1340 = _1331[8:8];
    assign _1341 = _1331[9:9];
    assign _1342 = _1331[10:10];
    assign _1343 = _1331[11:11];
    assign _1344 = _1331[12:12];
    assign _1345 = _1331[13:13];
    assign _1346 = _1331[14:14];
    assign _1347 = _1331[15:15];
    assign _1348 = _1331[16:16];
    assign _1349 = _1331[17:17];
    assign _1350 = _1331[18:18];
    assign _1351 = _1331[19:19];
    assign _1352 = _1331[20:20];
    assign _1353 = _1331[21:21];
    assign _1354 = _1331[22:22];
    assign _1355 = _1331[23:23];
    assign _1356 = _1331[24:24];
    assign _1357 = _1331[25:25];
    assign _1358 = _1331[26:26];
    assign _1359 = _1331[27:27];
    assign _1360 = _1331[28:28];
    assign _1361 = _1331[29:29];
    assign _1362 = _1331[30:30];
    assign _1363 = _1331[31:31];
    assign _1364 = _1331[32:32];
    assign _1365 = _1331[33:33];
    assign _1331 = { clk, clr, mio_rdata, mio_vld };
    assign _1366 = _1331[34:34];
    assign _1367 = _1366 | _1365;
    assign _1368 = _1367 | _1364;
    assign _1369 = _1368 | _1363;
    assign _1370 = _1369 | _1362;
    assign _1371 = _1370 | _1361;
    assign _1372 = _1371 | _1360;
    assign _1373 = _1372 | _1359;
    assign _1374 = _1373 | _1358;
    assign _1375 = _1374 | _1357;
    assign _1376 = _1375 | _1356;
    assign _1377 = _1376 | _1355;
    assign _1378 = _1377 | _1354;
    assign _1379 = _1378 | _1353;
    assign _1380 = _1379 | _1352;
    assign _1381 = _1380 | _1351;
    assign _1382 = _1381 | _1350;
    assign _1383 = _1382 | _1349;
    assign _1384 = _1383 | _1348;
    assign _1385 = _1384 | _1347;
    assign _1386 = _1385 | _1346;
    assign _1387 = _1386 | _1345;
    assign _1388 = _1387 | _1344;
    assign _1389 = _1388 | _1343;
    assign _1390 = _1389 | _1342;
    assign _1391 = _1390 | _1341;
    assign _1392 = _1391 | _1340;
    assign _1393 = _1392 | _1339;
    assign _1394 = _1393 | _1338;
    assign _1395 = _1394 | _1337;
    assign _1396 = _1395 | _1336;
    assign _1397 = _1396 | _1335;
    assign _1398 = _1397 | _1334;
    assign _1399 = _1398 | _1333;
    assign _1400 = _1399 | _1332;
    always @(posedge clk) begin
        if (clr)
            _1559 <= _1557;
        else
            _1559 <= _1400;
    end
    always @(posedge clk) begin
        if (clr)
            _1555 <= _1553;
        else
            _1555 <= _1402;
    end
    always @(posedge clk) begin
        if (clr)
            _1551 <= _1549;
        else
            _1551 <= _1403;
    end
    always @(posedge clk) begin
        if (clr)
            _1547 <= _1545;
        else
            _1547 <= _1404;
    end
    always @(posedge clk) begin
        if (clr)
            _1543 <= _1541;
        else
            _1543 <= _1405;
    end
    always @(posedge clk) begin
        if (clr)
            _1539 <= _1537;
        else
            _1539 <= _1406;
    end
    always @(posedge clk) begin
        if (clr)
            _1535 <= _1533;
        else
            _1535 <= _1407;
    end
    always @(posedge clk) begin
        if (clr)
            _1531 <= _1529;
        else
            _1531 <= _1408;
    end
    always @(posedge clk) begin
        if (clr)
            _1527 <= _1525;
        else
            _1527 <= _1409;
    end
    always @(posedge clk) begin
        if (clr)
            _1523 <= _1521;
        else
            _1523 <= _1410;
    end
    always @(posedge clk) begin
        if (clr)
            _1519 <= _1517;
        else
            _1519 <= _1411;
    end
    always @(posedge clk) begin
        if (clr)
            _1515 <= _1513;
        else
            _1515 <= _1412;
    end
    always @(posedge clk) begin
        if (clr)
            _1511 <= _1509;
        else
            _1511 <= _1413;
    end
    always @(posedge clk) begin
        if (clr)
            _1507 <= _1505;
        else
            _1507 <= _1414;
    end
    always @(posedge clk) begin
        if (clr)
            _1503 <= _1501;
        else
            _1503 <= _1415;
    end
    always @(posedge clk) begin
        if (clr)
            _1499 <= _1497;
        else
            _1499 <= _1416;
    end
    always @(posedge clk) begin
        if (clr)
            _1495 <= _1493;
        else
            _1495 <= _1417;
    end
    always @(posedge clk) begin
        if (clr)
            _1491 <= _1489;
        else
            _1491 <= _1418;
    end
    always @(posedge clk) begin
        if (clr)
            _1487 <= _1485;
        else
            _1487 <= _1419;
    end
    assign _1330 = fetch_pc + _1329;
    assign _1326 = _1330;
    always @(posedge clk) begin
        if (clr)
            fetch_pc <= _1325;
        else
            fetch_pc <= _1326;
    end
    always @(posedge clk) begin
        if (clr)
            _1483 <= _1481;
        else
            _1483 <= fetch_pc;
    end
    always @(posedge clk) begin
        if (clr)
            _1479 <= _1477;
        else
            _1479 <= _1421;
    end
    always @(posedge clk) begin
        if (clr)
            _1475 <= _1473;
        else
            _1475 <= _1422;
    end
    always @(posedge clk) begin
        if (clr)
            _1471 <= _1469;
        else
            _1471 <= _1423;
    end
    always @(posedge clk) begin
        if (clr)
            _1467 <= _1465;
        else
            _1467 <= _1424;
    end
    always @(posedge clk) begin
        if (clr)
            _1463 <= _1461;
        else
            _1463 <= _1425;
    end
    always @(posedge clk) begin
        if (clr)
            _1459 <= _1457;
        else
            _1459 <= _1426;
    end
    always @(posedge clk) begin
        if (clr)
            _1455 <= _1453;
        else
            _1455 <= _1427;
    end
    always @(posedge clk) begin
        if (clr)
            _1451 <= _1449;
        else
            _1451 <= _1428;
    end
    always @(posedge clk) begin
        if (clr)
            _1447 <= _1445;
        else
            _1447 <= _1429;
    end
    always @(posedge clk) begin
        if (clr)
            _1443 <= _1441;
        else
            _1443 <= _1430;
    end
    always @(posedge clk) begin
        if (clr)
            _1439 <= _1437;
        else
            _1439 <= _1431;
    end
    always @(posedge clk) begin
        if (clr)
            _1435 <= _1433;
        else
            _1435 <= vdd;
    end

    /* aliases */

    /* output assignments */
    assign pen = _1435;
    assign ra1 = _1439;
    assign ra2 = _1443;
    assign rad = _1447;
    assign ra1_zero = _1451;
    assign ra2_zero = _1455;
    assign rad_zero = _1459;
    assign rd1 = _1463;
    assign rd2 = _1467;
    assign rdd = _1471;
    assign rdm = _1475;
    assign imm = _1479;
    assign pc = _1483;
    assign next_pc = _1487;
    assign instr = _1491;
    assign insn = _1495;
    assign trap = _1499;
    assign lui = _1503;
    assign auipc = _1507;
    assign jal = _1511;
    assign jalr = _1515;
    assign bra = _1519;
    assign ld = _1523;
    assign st = _1527;
    assign opi = _1531;
    assign opr = _1535;
    assign fen = _1539;
    assign sys = _1543;
    assign f3 = _1547;
    assign f7 = _1551;
    assign cond_branch = _1555;
    assign junk = _1559;

endmodule
