
`timescale 1ns/1ps

module ALU_TOP_tb;

reg clk, rst;
reg signed [15:0] A, B;
reg [3:0] ALU_FUN;

wire signed [31:0] a_out;
wire [15:0] l_out, c_out, s_out;
wire arith_flag, logic_flag, cmp_flag, shift_flag;

// Connect the ALU
ALU_TOP DUT (
    .clk(clk),
    .rst(rst),
    .A(A),
    .B(B),
    .ALU_FUN(ALU_FUN),
    .a_out(a_out),
    .l_out(l_out),
    .c_out(c_out),
    .s_out(s_out),
    .arith_flag(arith_flag),
    .logic_flag(logic_flag),
    .cmp_flag(cmp_flag),
    .shift_flag(shift_flag)
);

// 100 kHz clock: 4000 ns LOW, 6000 ns HIGH
initial clk = 0;

always begin
    #4000 clk = 1;
    #6000 clk = 0;
end

// Display results after each rising edge
always @(posedge clk) begin
    #1;
    if (rst)
        $display("FUN=%b A=%0d B=%0d | ARITH=%0d LOGIC=%h CMP=%0d SHIFT=%h | FLAGS=%b%b%b%b",
                 ALU_FUN, A, B, a_out, l_out, c_out, s_out,
                 arith_flag, logic_flag, cmp_flag, shift_flag);
end

initial begin

    // Reset
    rst = 0;
    A = 0;
    B = 0;
    ALU_FUN = 0;

    #10000 rst = 1;

    // ADDITION (4 tests)
    ALU_FUN = 4'b0000; A = -4;  B = -10;
    #10000 A = 10;  B = -4;
    #10000 A = -4;  B = 10;
    #10000 A = 10;  B = 4;

    // SUBTRACTION (4 tests)
    #10000 ALU_FUN = 4'b0001; A = -4; B = -10;
    #10000 A = 10; B = -4;
    #10000 A = -4; B = 10;
    #10000 A = 10; B = 4;

    // MULTIPLICATION (4 tests)
    #10000 ALU_FUN = 4'b0010; A = -4; B = -10;
    #10000 A = 10; B = -4;
    #10000 A = -4; B = 10;
    #10000 A = 10; B = 4;

    // DIVISION (4 tests)
    #10000 ALU_FUN = 4'b0011; A = -20; B = -4;
    #10000 A = 20; B = -4;
    #10000 A = -20; B = 4;
    #10000 A = 20; B = 4;

    // LOGIC (4 tests)
    #10000 ALU_FUN = 4'b0100; A = 16'h00F3; B = 16'h000F; // AND
    #10000 ALU_FUN = 4'b0101;                       // OR
    #10000 ALU_FUN = 4'b0110;                       // NAND
    #10000 ALU_FUN = 4'b0111;                       // NOR

    // COMPARISON (4 tests)
    #10000 ALU_FUN = 4'b1000; A = 7; B = 3; // NOP
    #10000 ALU_FUN = 4'b1001; A = 7; B = 7; // Equal
    #10000 ALU_FUN = 4'b1010; A = 7; B = 3; // Greater
    #10000 ALU_FUN = 4'b1011; A = 3; B = 7; // Less

    // SHIFT (4 tests)
    #10000 ALU_FUN = 4'b1100; A = 8; B = 4; // A right
    #10000 ALU_FUN = 4'b1101;               // A left
    #10000 ALU_FUN = 4'b1110;               // B right
    #10000 ALU_FUN = 4'b1111;               // B left

    #10000;

    $display("All 28 test cases applied.");
    $stop;

end

endmodule

