module opicorv32_pcpi_if (
    pcpi_wait,
    pcpi_rd,
    pcpi_rs2,
    pcpi_rs1,
    pcpi_wr,
    clk,
    pcpi_insn,
    pcpi_valid,
    resetn,
    pcpi_ready,
    pcpi_int_wr,
    pcpi_int_rd,
    pcpi_int_wait,
    pcpi_int_ready
);

    input pcpi_wait;
    input [31:0] pcpi_rd;
    input [31:0] pcpi_rs2;
    input [31:0] pcpi_rs1;
    input pcpi_wr;
    input clk;
    input [31:0] pcpi_insn;
    input pcpi_valid;
    input resetn;
    input pcpi_ready;
    output pcpi_int_wr;
    output [31:0] pcpi_int_rd;
    output pcpi_int_wait;
    output pcpi_int_ready;

    /* signal declarations */
    wire _2534;
    wire _2529;
    wire _2530;
    wire _2531;
    wire [31:0] _2527 = 32'b00000000000000000000000000000000;
    wire [31:0] _2526 = 32'b00000000000000000000000000000000;
    wire [31:0] _2524;
    wire [63:0] _2437 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] _2435 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] _2477 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] _2440;
    wire [63:0] _2433 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] _2431 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] _2476 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire _2450 = 1'b0;
    wire [63:0] _2444;
    wire [63:0] _2425 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] _2423 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire _2485;
    wire [1:0] _2486;
    wire [3:0] _2487;
    wire [7:0] _2488;
    wire [15:0] _2489;
    wire [31:0] _2490;
    wire [63:0] _2492;
    wire [31:0] _2482 = 32'b00000000000000000000000000000000;
    wire [63:0] _2484;
    wire [63:0] _2493;
    wire _2456 = 1'b0;
    wire [62:0] _2457;
    wire [63:0] _2458;
    wire [63:0] _2518;
    wire [63:0] _2424;
    reg [63:0] _2426;
    wire [63:0] _2445;
    wire [63:0] _2446;
    wire [63:0] _2447;
    wire [63:0] _2443;
    wire _2448;
    wire [63:0] _2449;
    wire [62:0] _2451;
    wire [63:0] _2452;
    wire [63:0] _2516;
    wire [63:0] _2432;
    reg [63:0] _2434;
    wire [63:0] _2439;
    wire [63:0] _2429 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire [63:0] _2427 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    wire _2501;
    wire [1:0] _2502;
    wire [3:0] _2503;
    wire [7:0] _2504;
    wire [15:0] _2505;
    wire [31:0] _2506;
    wire [63:0] _2508;
    wire [31:0] _2498 = 32'b00000000000000000000000000000000;
    wire [63:0] _2500;
    wire _2416;
    wire [63:0] _2509;
    wire [62:0] _2453;
    wire _2454 = 1'b0;
    wire [63:0] _2455;
    wire [63:0] _2517;
    wire [63:0] _2428;
    reg [63:0] _2430;
    wire _2441;
    wire [63:0] _2442;
    wire [63:0] _2515;
    wire [63:0] _2436;
    reg [63:0] _2438;
    wire [31:0] _2523;
    wire [31:0] _2525;
    reg [31:0] _2528;
    wire [31:0] _2537 = 32'b00000000000000000000000000000000;
    wire [31:0] _2538;
    wire [31:0] _2539;
    wire _2519 = 1'b0;
    reg _2520;
    wire _2521 = 1'b0;
    wire _2467 = 1'b0;
    wire _2510;
    wire _2464 = 1'b0;
    wire _2419 = 1'b0;
    reg _2420;
    wire _2421;
    wire _2417 = 1'b0;
    wire _2391 = 1'b0;
    wire [2:0] _2388 = 3'b000;
    wire [2:0] _2387;
    wire _2389;
    wire _2390;
    reg _2392;
    wire _2411;
    wire _2412;
    wire _2413;
    reg _2418;
    wire _2422;
    wire _2472;
    wire [6:0] _2461 = 7'b0000000;
    wire [6:0] _2459 = 7'b0000000;
    wire [6:0] _2474 = 7'b0111110;
    wire [6:0] _2473 = 7'b0011110;
    wire _2409 = 1'b0;
    wire [2:0] _2406 = 3'b011;
    wire [2:0] _2405;
    wire _2407;
    wire _2408;
    reg _2410;
    wire _2403 = 1'b0;
    wire [2:0] _2400 = 3'b010;
    wire [2:0] _2399;
    wire _2401;
    wire _2402;
    reg _2404;
    wire _2397 = 1'b0;
    wire [2:0] _2394 = 3'b001;
    wire [2:0] _2393;
    wire _2395;
    wire [6:0] _2379 = 7'b0000001;
    wire [6:0] _2378;
    wire _2380;
    wire [6:0] _2382 = 7'b0110011;
    wire [6:0] _2381;
    wire _2383;
    wire _2384;
    wire _2385;
    wire _2386;
    wire _2396;
    reg _2398;
    wire _2414;
    wire _2415;
    wire [6:0] _2475;
    wire [6:0] _2470 = 7'b0000001;
    wire [6:0] _2471;
    wire [6:0] _2514;
    wire [6:0] _2460;
    reg [6:0] _2462;
    wire _2469;
    wire _2512;
    wire _2513;
    wire _2463;
    reg _2465;
    wire _2511;
    wire _2466;
    reg _2468;
    reg _2522;
    wire vdd = 1'b1;
    wire _2532;
    wire _2535;
    wire gnd = 1'b0;
    wire _2533;
    wire _2536;

    /* logic */
    assign _2534 = _2533 | _2532;
    assign _2529 = vdd & _2418;
    assign _2530 = gnd & pcpi_wait;
    assign _2531 = _2530 | _2529;
    assign _2524 = _2438[63:32];
    assign _2440 = _2439 ^ _2426;
    assign _2444 = _2434 & _2426;
    assign _2485 = pcpi_rs2[31:31];
    assign _2486 = { _2485, _2485 };
    assign _2487 = { _2486, _2486 };
    assign _2488 = { _2487, _2487 };
    assign _2489 = { _2488, _2488 };
    assign _2490 = { _2489, _2489 };
    assign _2492 = { _2490, pcpi_rs2 };
    assign _2484 = { _2482, pcpi_rs2 };
    assign _2493 = _2398 ? _2492 : _2484;
    assign _2457 = _2426[62:0];
    assign _2458 = { _2457, _2456 };
    assign _2518 = _2465 ? _2493 : _2458;
    assign _2424 = _2518;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _2426 <= _2423;
        else
            _2426 <= _2424;
    end
    assign _2445 = _2438 & _2426;
    assign _2446 = _2443 | _2445;
    assign _2447 = _2446 | _2444;
    assign _2443 = _2438 & _2434;
    assign _2448 = _2430[0:0];
    assign _2449 = _2448 ? _2447 : _2443;
    assign _2451 = _2449[62:0];
    assign _2452 = { _2451, _2450 };
    assign _2516 = _2465 ? _2476 : _2452;
    assign _2432 = _2516;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _2434 <= _2431;
        else
            _2434 <= _2432;
    end
    assign _2439 = _2438 ^ _2434;
    assign _2501 = pcpi_rs1[31:31];
    assign _2502 = { _2501, _2501 };
    assign _2503 = { _2502, _2502 };
    assign _2504 = { _2503, _2503 };
    assign _2505 = { _2504, _2504 };
    assign _2506 = { _2505, _2505 };
    assign _2508 = { _2506, pcpi_rs1 };
    assign _2500 = { _2498, pcpi_rs1 };
    assign _2416 = _2398 | _2404;
    assign _2509 = _2416 ? _2508 : _2500;
    assign _2453 = _2430[63:1];
    assign _2455 = { _2454, _2453 };
    assign _2517 = _2465 ? _2509 : _2455;
    assign _2428 = _2517;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _2430 <= _2427;
        else
            _2430 <= _2428;
    end
    assign _2441 = _2430[0:0];
    assign _2442 = _2441 ? _2440 : _2439;
    assign _2515 = _2465 ? _2477 : _2442;
    assign _2436 = _2515;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _2438 <= _2435;
        else
            _2438 <= _2436;
    end
    assign _2523 = _2438[31:0];
    assign _2525 = _2415 ? _2524 : _2523;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _2528 <= _2526;
        else
            if (_2468)
                _2528 <= _2525;
    end
    assign _2538 = _2532 ? _2528 : _2537;
    assign _2539 = _2533 ? pcpi_rd : _2538;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _2520 <= gnd;
        else
            _2520 <= _2468;
    end
    assign _2510 = _2469 ? vdd : gnd;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _2420 <= gnd;
        else
            _2420 <= _2418;
    end
    assign _2421 = ~ _2420;
    assign _2387 = pcpi_insn[14:12];
    assign _2389 = _2387 == _2388;
    assign _2390 = _2386 & _2389;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _2392 <= gnd;
        else
            _2392 <= _2390;
    end
    assign _2411 = _2392 | _2398;
    assign _2412 = _2411 | _2404;
    assign _2413 = _2412 | _2410;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _2418 <= gnd;
        else
            _2418 <= _2413;
    end
    assign _2422 = _2418 & _2421;
    assign _2472 = ~ _2422;
    assign _2405 = pcpi_insn[14:12];
    assign _2407 = _2405 == _2406;
    assign _2408 = _2386 & _2407;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _2410 <= gnd;
        else
            _2410 <= _2408;
    end
    assign _2399 = pcpi_insn[14:12];
    assign _2401 = _2399 == _2400;
    assign _2402 = _2386 & _2401;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _2404 <= gnd;
        else
            _2404 <= _2402;
    end
    assign _2393 = pcpi_insn[14:12];
    assign _2395 = _2393 == _2394;
    assign _2378 = pcpi_insn[31:25];
    assign _2380 = _2378 == _2379;
    assign _2381 = pcpi_insn[6:0];
    assign _2383 = _2381 == _2382;
    assign _2384 = resetn & pcpi_valid;
    assign _2385 = _2384 & _2383;
    assign _2386 = _2385 & _2380;
    assign _2396 = _2386 & _2395;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _2398 <= gnd;
        else
            _2398 <= _2396;
    end
    assign _2414 = _2398 | _2404;
    assign _2415 = _2414 | _2410;
    assign _2475 = _2415 ? _2474 : _2473;
    assign _2471 = _2462 - _2470;
    assign _2514 = _2465 ? _2475 : _2471;
    assign _2460 = _2514;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _2462 <= _2459;
        else
            _2462 <= _2460;
    end
    assign _2469 = _2462[6:6];
    assign _2512 = _2469 ? vdd : _2465;
    assign _2513 = _2465 ? _2472 : _2512;
    assign _2463 = _2513;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _2465 <= vdd;
        else
            _2465 <= _2463;
    end
    assign _2511 = _2465 ? gnd : _2510;
    assign _2466 = _2511;
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _2468 <= gnd;
        else
            _2468 <= _2466;
    end
    always @(posedge clk or negedge resetn) begin
        if (resetn == 0)
            _2522 <= gnd;
        else
            _2522 <= _2468;
    end
    assign _2532 = vdd & _2522;
    assign _2535 = _2532 ? _2520 : gnd;
    assign _2533 = gnd & pcpi_ready;
    assign _2536 = _2533 ? pcpi_wr : _2535;

    /* aliases */

    /* output assignments */
    assign pcpi_int_wr = _2536;
    assign pcpi_int_rd = _2539;
    assign pcpi_int_wait = _2531;
    assign pcpi_int_ready = _2534;

endmodule
