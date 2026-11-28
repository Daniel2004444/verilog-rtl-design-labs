`timescale 1ns/1ps

module UART_TB;

// Testbench signals

reg TX_CLK_tb;
reg RX_CLK_tb;
reg RST_tb;

reg PAR_TYP_tb;
reg PAR_EN_tb;
reg [5:0] Prescale_tb;

reg [7:0] TX_IN_P_tb;
reg TX_IN_V_tb;
reg RX_IN_S_tb;

wire TX_OUT_S_tb;
wire TX_OUT_V_tb;

wire [7:0] RX_OUT_P_tb;
wire RX_OUT_V_tb;

integer passed;
integer failed;
integer rx_count;
reg [7:0] rx_last;


// DUT instantiation

UART DUT (
    .TX_CLK(TX_CLK_tb),
    .RX_CLK(RX_CLK_tb),
    .RST(RST_tb),

    .PAR_TYP(PAR_TYP_tb),
    .PAR_EN(PAR_EN_tb),
    .Prescale(Prescale_tb),

    .TX_IN_P(TX_IN_P_tb),
    .TX_IN_V(TX_IN_V_tb),

    .TX_OUT_S(TX_OUT_S_tb),
    .TX_OUT_V(TX_OUT_V_tb),

    .RX_IN_S(RX_IN_S_tb),

    .RX_OUT_P(RX_OUT_P_tb),
    .RX_OUT_V(RX_OUT_V_tb)
);


// Clock generators
// TX period = 80 ns
// RX period = 10 ns
// Prescale = 8

always #40 TX_CLK_tb = ~TX_CLK_tb;
always #5  RX_CLK_tb = ~RX_CLK_tb;


// Monitor received data

always @(negedge RX_CLK_tb)
begin
    if (RX_OUT_V_tb === 1'b1)
    begin
        rx_last = RX_OUT_P_tb;
        rx_count = rx_count + 1;
    end
end


// Task 1: Send serial data into RX

task send_rx;
    input [7:0] data;
    input parity_enable;
    input parity_type;

    integer i;

    begin
        // Start bit = 0
        @(negedge RX_CLK_tb);
        RX_IN_S_tb = 1'b0;

        repeat (8) @(negedge RX_CLK_tb);

        // Send 8 data bits, LSB first
        for (i = 0; i < 8; i = i + 1)
        begin
            RX_IN_S_tb = data[i];
            repeat (8) @(negedge RX_CLK_tb);
        end

        // Optional parity bit
        if (parity_enable)
        begin
            RX_IN_S_tb = (^data) ^ parity_type;
            repeat (8) @(negedge RX_CLK_tb);
        end

        // Stop bit = 1
        RX_IN_S_tb = 1'b1;
        repeat (8) @(negedge RX_CLK_tb);
    end
endtask


// Task 2: Check transmitted serial data

task check_tx;
    input [7:0] expected;
    input parity_enable;
    input parity_type;

    reg [7:0] received;
    reg received_parity;
    integer i;

    begin
        // Wait for TX start bit
        @(negedge TX_OUT_S_tb);

        // Sample middle of start bit
        #40;

        if (TX_OUT_S_tb !== 1'b0)
        begin
            $display("TX START FAIL");
            failed = failed + 1;
        end

        // Read 8 transmitted bits
        for (i = 0; i < 8; i = i + 1)
        begin
            #80;
            received[i] = TX_OUT_S_tb;
        end

        // Check transmitted byte
        if (received === expected)
        begin
            $display("TX DATA PASS: %h", received);
            passed = passed + 1;
        end
        else
        begin
            $display("TX DATA FAIL: expected=%h received=%h",
                      expected, received);
            failed = failed + 1;
        end

        // Check parity if enabled
        if (parity_enable)
        begin
            #80;
            received_parity = TX_OUT_S_tb;

            if (received_parity === ((^expected) ^ parity_type))
            begin
                $display("TX PARITY PASS");
                passed = passed + 1;
            end
            else
            begin
                $display("TX PARITY FAIL");
                failed = failed + 1;
            end
        end

        // Check stop bit
        #80;

        if (TX_OUT_S_tb === 1'b1)
        begin
            $display("TX STOP PASS");
            passed = passed + 1;
        end
        else
        begin
            $display("TX STOP FAIL");
            failed = failed + 1;
        end
    end
endtask


// Task 3: Test TX and RX simultaneously

task test_full_duplex;
    input [7:0] tx_data;
    input [7:0] rx_data;
    input parity_enable;
    input parity_type;

    integer previous_rx_count;

    begin
        PAR_EN_tb  = parity_enable;
        PAR_TYP_tb = parity_type;

        previous_rx_count = rx_count;

        // Start TX
        @(negedge TX_CLK_tb);

        TX_IN_P_tb = tx_data;
        TX_IN_V_tb = 1'b1;

        // TX and RX operate simultaneously
        fork

            begin
                @(negedge TX_CLK_tb);
                TX_IN_V_tb = 1'b0;
            end

            begin
                send_rx(rx_data, parity_enable, parity_type);
            end

            begin
                check_tx(tx_data, parity_enable, parity_type);
            end

        join

        // Allow RX to finish processing
        repeat (20) @(negedge RX_CLK_tb);

        // Check received byte
        if ((rx_count == previous_rx_count + 1) &&
            (rx_last === rx_data))
        begin
            $display("RX DATA PASS: %h", rx_last);
            passed = passed + 1;
        end
        else
        begin
            $display("RX DATA FAIL: expected=%h received=%h",
                      rx_data, rx_last);
            failed = failed + 1;
        end

        #80;
    end
endtask


// Main testbench

initial
begin
    $dumpfile("uart.vcd");
    $dumpvars(0, UART_TB);

    // Initialize signals
    TX_CLK_tb = 1'b0;
    RX_CLK_tb = 1'b0;
    RST_tb = 1'b0;

    PAR_TYP_tb = 1'b0;
    PAR_EN_tb = 1'b0;
    Prescale_tb = 6'd8;

    TX_IN_P_tb = 8'b0;
    TX_IN_V_tb = 1'b0;
    RX_IN_S_tb = 1'b1;

    passed = 0;
    failed = 0;
    rx_count = 0;
    rx_last = 8'b0;

    // Release reset
    #25;
    RST_tb = 1'b1;

    #80;


    // TEST CASE 1
    // Full duplex without parity

    $display("========== TEST 1: NO PARITY ==========");

    test_full_duplex(
        8'hA5,
        8'h3C,
        1'b0,
        1'b0
    );


    // TEST CASE 2
    // Full duplex with even parity

    $display("========== TEST 2: EVEN PARITY ==========");

    test_full_duplex(
        8'h55,
        8'h96,
        1'b1,
        1'b0
    );


    // TEST CASE 3
    // Full duplex with odd parity

    $display("========== TEST 3: ODD PARITY ==========");

    test_full_duplex(
        8'hC3,
        8'h69,
        1'b1,
        1'b1
    );


    // Final results

    $display("=================================");
    $display("TOTAL PASSED = %0d", passed);
    $display("TOTAL FAILED = %0d", failed);
    $display("=================================");

    if (failed == 0)
        $display("ALL UART TESTS PASSED");
    else
        $display("UART VERIFICATION FAILED");

    $finish;
end


// Simulation timeout

initial
begin
    #100000;

    $display("FAIL: SIMULATION TIMEOUT");
    $finish;
end

endmodule
