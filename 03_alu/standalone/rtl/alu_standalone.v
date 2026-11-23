
module ALU(
    input wire CLK,
    input wire [15:0] A,
    input wire [15:0] B,
    input wire [3:0] ALU_FUN,
    output reg [15:0] ALU_OUT,
    output reg c_flag,
    output reg arth_flag,
    output reg logic_flag,
    output reg cmp_flag,
    output reg shift_flag
);

always @(posedge CLK) begin

    // Default flag values
    c_flag     <= 1'b0;
    arth_flag  <= 1'b0;
    logic_flag <= 1'b0;
    cmp_flag   <= 1'b0;
    shift_flag <= 1'b0;

    // ALU operations
    case (ALU_FUN)

        // Arithmetic
        4'b0000: begin
            {c_flag, ALU_OUT} <= {1'b0, A} + {1'b0, B};
        end

        4'b0001: begin
            ALU_OUT <= A - B;
            if (A < B)
                c_flag <= 1'b1;
        end

        4'b0010: ALU_OUT <= A * B;

        4'b0011: begin
            if (B != 16'd0)
                ALU_OUT <= A / B;
            else
                ALU_OUT <= 16'd0;
        end

        // Logic
        4'b0100: ALU_OUT <= A & B;
        4'b0101: ALU_OUT <= A | B;
        4'b0110: ALU_OUT <= ~(A & B);
        4'b0111: ALU_OUT <= ~(A | B);
        4'b1000: ALU_OUT <= A ^ B;
        4'b1001: ALU_OUT <= A ~^ B;

        // Comparison
        4'b1010: ALU_OUT <= (A == B) ? 16'd1 : 16'd0;
        4'b1011: ALU_OUT <= (A > B)  ? 16'd2 : 16'd0;
        4'b1100: ALU_OUT <= (A < B)  ? 16'd3 : 16'd0;

        // Shift
        4'b1101: ALU_OUT <= A >> 1;
        4'b1110: ALU_OUT <= A << 1;

        // Invalid operation
        default: ALU_OUT <= 16'd0;

    endcase

    // Operation category flags
    if (ALU_FUN <= 4'b0011)
        arth_flag <= 1'b1;

    else if (ALU_FUN >= 4'b0100 && ALU_FUN <= 4'b1001)
        logic_flag <= 1'b1;

    else if (ALU_FUN >= 4'b1010 && ALU_FUN <= 4'b1100)
        cmp_flag <= 1'b1;

    else if (ALU_FUN >= 4'b1101 && ALU_FUN <= 4'b1110)
        shift_flag <= 1'b1;

end

endmodule
