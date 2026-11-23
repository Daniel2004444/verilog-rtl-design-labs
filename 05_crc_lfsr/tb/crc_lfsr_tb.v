
`timescale 1ns/1ps

module LFSR_MINE_TB;

    reg clk = 1'b0;
    reg rst = 1'b1;
    reg data = 1'b0;
    reg active = 1'b0;

    wire crc;
    wire valid;

    reg [7:0] test_data [0:9];
    reg [7:0] expected_crc [0:9];
    reg [7:0] received_crc;

    reg valid_ok;
    integer test_num, bit_num;
    integer passed = 0;

    // 10 MHz clock
    always #50 clk = ~clk;

    // Design under test
    LFSR_MINE dut (
        .data(data),
        .rst(rst),
        .clk(clk),
        .active(active),
        .crc(crc),
        .valid(valid)
    );

    initial begin

        $dumpfile("LFSR_MINE.vcd");
        $dumpvars(0, LFSR_MINE_TB);

        // Read 10 test cases
        $readmemh("05_crc_lfsr/DATA_h.txt", test_data);
        $readmemh("05_crc_lfsr/Expec_Out_h.txt", expected_crc);

        for (test_num = 0; test_num < 10;
             test_num = test_num + 1)
        begin

            // Reset LFSR
            @(negedge clk);
            rst = 1'b0;
            active = 1'b0;
            data = 1'b0;

            @(negedge clk);
            rst = 1'b1;

            // Send 8 data bits LSB first
            for (bit_num = 0; bit_num < 8;
                 bit_num = bit_num + 1)
            begin
                @(negedge clk);
                active = 1'b1;
                data = test_data[test_num][bit_num];
            end

            // Stop receiving data
            @(negedge clk);
            active = 1'b0;
            data = 1'b0;

            // Collect 8 CRC output bits
            valid_ok = 1'b1;
            received_crc = 8'b0;

            for (bit_num = 0; bit_num < 8;
                 bit_num = bit_num + 1)
            begin
                @(negedge clk);

                received_crc[bit_num] = crc;

                if (valid !== 1'b1)
                    valid_ok = 1'b0;
            end

            // Check that valid returns to zero
            @(negedge clk);

            if (valid !== 1'b0)
                valid_ok = 1'b0;

            // Compare calculated and expected CRC
            // Reject unknown/uninitialized test vectors and CRC values.
            // Case equality alone would incorrectly accept xx == xx.
            if (valid_ok &&
                (^test_data[test_num] !== 1'bx) &&
                (^expected_crc[test_num] !== 1'bx) &&
                (^received_crc !== 1'bx) &&
                (received_crc === expected_crc[test_num]))
            begin
                passed = passed + 1;

                $display(
                    "PASS test %0d: data=%h CRC=%h",
                    test_num + 1,
                    test_data[test_num],
                    received_crc
                );
            end
            else
            begin
                $display(
                    "FAIL test %0d: data=%h got=%h expected=%h valid_ok=%b",
                    test_num + 1,
                    test_data[test_num],
                    received_crc,
                    expected_crc[test_num],
                    valid_ok
                );
            end

        end

        $display("RESULT: %0d / 10 passed", passed);
        $finish;

    end

endmodule
