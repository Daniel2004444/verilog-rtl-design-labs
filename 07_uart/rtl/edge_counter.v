module edge_bit_counter (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire [5:0] prescale,
    output reg [3:0] bit_count,
    output reg [5:0] edge_count
);

always @(posedge clk or negedge rst)
begin
    if (!rst)
    begin
        bit_count  <= 4'd0;
        edge_count <= 6'd0;
    end
    else if (enable)
    begin
        if (edge_count == prescale - 1'b1)
        begin
            edge_count <= 6'd0;
            bit_count  <= bit_count + 1'b1;
        end
        else
        begin
            edge_count <= edge_count + 1'b1;
        end
    end
    else
    begin
        bit_count  <= 4'd0;
        edge_count <= 6'd0;
    end
end

endmodule