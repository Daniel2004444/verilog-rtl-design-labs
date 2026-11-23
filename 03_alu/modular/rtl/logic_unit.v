module logic_unit #(
    parameter IN_DATA_WIDTH = 16,
    parameter OUT_DATA_WIDTH = 16
)(
    input wire [3:0] ALU_FUN,
    input wire [IN_DATA_WIDTH-1:0] A,
    input wire [IN_DATA_WIDTH-1:0] B,
    input wire clk,
    input wire rst,
    input wire logic_enable,
    output reg [OUT_DATA_WIDTH-1:0] a_out,
    output reg logic_flag
);

always @(posedge clk or negedge rst)
begin
    if (!rst)
    begin
        a_out <= 16'b0;
        logic_flag <= 1'b0;
    end
    else
    begin
        if (logic_enable)
        begin
            case (ALU_FUN[1:0])

                2'b00: begin
                    logic_flag <= 1'b1;
                    a_out <= A & B;
                end

                2'b01: begin
                    logic_flag <= 1'b1;
                    a_out <= A | B;
                end

                2'b10: begin
                    logic_flag <= 1'b1;
                    a_out <= ~(A & B);
                end

                2'b11: begin
                    logic_flag <= 1'b1;
                    a_out <= ~(A | B);
                end

                default: begin
                    logic_flag <= 1'b0;
                    a_out <= 0;
                end

            endcase
        end
        else
        begin
            logic_flag <= 1'b0;
            a_out <= 32'd0;
        end
    end
end

endmodule