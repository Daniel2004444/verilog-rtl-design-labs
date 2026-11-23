
module ALU_TOP #(
    parameter IN_DATA_WIDTH = 16,
    parameter OUT_DATA_WIDTH = 16,
    parameter ARITH_OUT_WIDTH = 32
)(
    input wire [3:0] ALU_FUN,
    input wire signed [IN_DATA_WIDTH-1:0] A,
    input wire signed [IN_DATA_WIDTH-1:0] B,
    input wire clk,
    input wire rst,

    output wire signed [ARITH_OUT_WIDTH-1:0] a_out,
    output wire [OUT_DATA_WIDTH-1:0] l_out,
    output wire [OUT_DATA_WIDTH-1:0] c_out,
    output wire [OUT_DATA_WIDTH-1:0] s_out,

    output wire arith_flag,
    output wire logic_flag,
    output wire cmp_flag,
    output wire shift_flag
);

// Internal enable wires
wire arith_enable;
wire logic_enable;
wire cmp_enable;
wire shift_enable;

// 1. Decoder
Decoder decoder_1 (
    .ALU_FUN(ALU_FUN),
    .arith_enable(arith_enable),
    .logic_enable(logic_enable),
    .cmp_enable(cmp_enable),
    .shift_enable(shift_enable)
);

// 2. Arithmetic Unit
arth_unit #(
    .IN_DATA_WIDTH(IN_DATA_WIDTH),
    .OUT_DATA_WIDTH(ARITH_OUT_WIDTH)
) arith_1 (
    .ALU_FUN(ALU_FUN),
    .A(A),
    .B(B),
    .clk(clk),
    .rst(rst),
    .arith_enable(arith_enable),
    .arith_flag(arith_flag),
    .a_out(a_out)
);

// 3. Logic Unit
logic_unit #(
    .IN_DATA_WIDTH(IN_DATA_WIDTH),
    .OUT_DATA_WIDTH(OUT_DATA_WIDTH)
) logic_1 (
    .ALU_FUN(ALU_FUN),
    .A(A),
    .B(B),
    .clk(clk),
    .rst(rst),
    .logic_enable(logic_enable),
    .logic_flag(logic_flag),
    .a_out(l_out)
);

// 4. Comparison Unit
cmp_unit #(
    .IN_DATA_WIDTH(IN_DATA_WIDTH),
    .OUT_DATA_WIDTH(OUT_DATA_WIDTH)
) cmp_1 (
    .ALU_FUN(ALU_FUN),
    .A(A),
    .B(B),
    .clk(clk),
    .rst(rst),
    .cmp_enable(cmp_enable),
    .cmp_flag(cmp_flag),
    .a_out(c_out)
);

// 5. Shift Unit
shift_unit #(
    .IN_DATA_WIDTH(IN_DATA_WIDTH),
    .OUT_DATA_WIDTH(OUT_DATA_WIDTH)
) shift_1 (
    .ALU_FUN(ALU_FUN),
    .A(A),
    .B(B),
    .clk(clk),
    .rst(rst),
    .shift_enable(shift_enable),
    .shift_flag(shift_flag),
    .a_out(s_out)
);

endmodule
