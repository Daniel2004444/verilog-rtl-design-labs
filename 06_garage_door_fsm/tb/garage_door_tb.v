
`timescale 1ns/1ps

module door_tb;

    reg clk;
    reg rst;
    reg act;
    reg up_max;
    reg dn_max;

    wire up_m;
    wire dn_m;

    // 50 MHz clock
    always #10 clk = ~clk;

    // Design under test
    door dut (
        .up_max(up_max),
        .dn_max(dn_max),
        .act(act),
        .clk(clk),
        .rst(rst),
        .up_m(up_m),
        .dn_m(dn_m)
    );

    initial
    begin
        clk = 0;
        rst = 1;
        act = 0;
        up_max = 0;
        dn_max = 1;

        // Reset
        #5 rst = 0;
        #5 rst = 1;

        // Test 1: Idle
        @(negedge clk);
        if (up_m == 0 && dn_m == 0)
            $display("PASS: IDLE");
        else
            $display("FAIL: IDLE");

        // Test 2: Open door
        act = 1;

        @(negedge clk);
        #1;
        if (up_m == 1 && dn_m == 0)
            $display("PASS: Moving UP");
        else
            $display("FAIL: Moving UP");

        // Test 3: Continue moving UP
        act = 0;
        dn_max = 0;

        @(negedge clk);
        #1;
        if (up_m == 1 && dn_m == 0)
            $display("PASS: Continue UP");
        else
            $display("FAIL: Continue UP");

        // Test 4: Door reaches top
        up_max = 1;

        @(negedge clk);
        #1;
        if (up_m == 0 && dn_m == 0)
            $display("PASS: Stop at top");
        else
            $display("FAIL: Stop at top");

        // Test 5: Close door
        act = 1;

        @(negedge clk);
        #1;
        if (up_m == 0 && dn_m == 1)
            $display("PASS: Moving DOWN");
        else
            $display("FAIL: Moving DOWN");

        // Test 6: Door reaches bottom
        act = 0;
        up_max = 0;
        dn_max = 0;

        @(negedge clk);
        dn_max = 1;

        @(negedge clk);
        #1;
        if (up_m == 0 && dn_m == 0)
            $display("PASS: Stop at bottom");
        else
            $display("FAIL: Stop at bottom");

        $display("Simulation completed");
        $finish;
    end

endmodule

