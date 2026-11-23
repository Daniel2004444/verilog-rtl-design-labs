module shift_unit #(
    parameter IN_DATA_WIDTH = 16,
    parameter OUT_DATA_WIDTH = 16
)(
    input wire [3:0] ALU_FUN,
    input wire [IN_DATA_WIDTH-1:0] A,
    input wire [IN_DATA_WIDTH-1:0] B,
    input wire clk,
    input wire rst,
    input wire shift_enable,
    output reg [OUT_DATA_WIDTH-1:0] a_out,
    output reg shift_flag
);

always @(posedge clk or negedge rst)
begin
    if (!rst)
    begin
        a_out <= 16'b0;
        shift_flag <= 1'b0;
    end
    else
    begin
        if (shift_enable)
        begin
            case (ALU_FUN[1:0])

                2'b00: begin
                    shift_flag <= 1'b1;
                    a_out <= A >> 1;
                end

                2'b01: begin
                    shift_flag <= 1'b1;
                    a_out <= A << 1;
          
                end

                2'b10: begin
                    shift_flag <= 1'b1;
                    a_out <= B >> 1;
                end

                2'b11: begin
                    shift_flag <= 1'b1;
                    a_out <= B << 1;
                end
  
                default: begin
                    shift_flag <= 1'b0;
                    a_out <= 0;
                end

            endcase
        end
        else
        begin
            shift_flag <= 1'b0;
            a_out <= 16'd0;
        end
    end
end

endmodule

