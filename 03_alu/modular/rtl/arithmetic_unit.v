
module arth_unit #(
    parameter IN_DATA_WIDTH = 16,
    parameter OUT_DATA_WIDTH = 32
)(
    input wire [3:0] ALU_FUN,
    input wire signed [IN_DATA_WIDTH-1:0] A,
    input wire signed [IN_DATA_WIDTH-1:0] B,
    input wire clk,
    input wire rst,
    input wire arith_enable,
    output reg signed [OUT_DATA_WIDTH-1:0] a_out,
    output reg arith_flag
);

always @(posedge clk or negedge rst)
begin
    if (!rst)
    begin
        a_out <= 32'd0;
        arith_flag <= 1'b0;
    end
    else
    begin
        if (arith_enable)
        begin
            case (ALU_FUN[1:0])

                2'b00: begin
                    arith_flag <= 1'b1;
                    a_out <= A + B;
                end

                2'b01: begin
                    arith_flag <= 1'b1;
                    a_out <= A - B;
                end

                2'b10: begin
                    arith_flag <= 1'b1;
                    a_out <= A * B;
                end

                2'b11: begin
                    arith_flag <= 1'b1;
                    a_out <= (B != 0) ? A / B : 0;
                end

                default: begin
                    arith_flag <= 1'b0;
                    a_out <= 0;
                end

            endcase
        end
        else
        begin
            arith_flag <= 1'b0;
            a_out <= 32'd0;
        end
    end
end

endmodule
