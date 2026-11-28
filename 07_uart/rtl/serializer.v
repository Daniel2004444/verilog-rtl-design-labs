module serializer (
    input wire clk,
    input wire rst,
    input wire [7:0] P_DATA,
    input wire data_valid,
    input wire ser_en,
    input wire busy,
    output wire ser_done,
    output wire ser_data
);
reg [7:0] data_reg;
reg [2:0] bit_count;
wire ser_count;

assign ser_data = data_reg[0];
assign ser_done = (bit_count == 3'd7);

always @(posedge clk or negedge rst)
begin
    if (!rst)
    begin
        data_reg <= 8'b0;
        bit_count <= 3'b0;
    end

    else if (data_valid && !busy)
    begin
        data_reg <= P_DATA;
        bit_count <= 3'b0;
    end

    else if (ser_en)
    begin
        data_reg <= data_reg >> 1;
        bit_count <= bit_count + 1'b1;
    end

    else
    begin
        bit_count <= 3'b0;
    end
end

endmodule 