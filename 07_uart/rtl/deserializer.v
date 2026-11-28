module deserializer (
    input wire clk,
    input wire rst,
    input wire sampled_bit,
    input wire deser_en,
    input wire [5:0] edge_count,
    input wire [5:0] prescale,
    output reg [7:0] p_data
);

always @(posedge clk or negedge rst)
begin
    if (!rst)
    begin
        p_data <= 8'b0;
    end
    else if (deser_en && edge_count == prescale - 1'b1)
    begin
        p_data <= {sampled_bit, p_data[7:1]};
    end
end

endmodule