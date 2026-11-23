
module reg_8x16 (
    input wire wren,
    input wire rden,
    input wire clk,
    input wire rst,
    input wire [2:0] address,
    input wire [15:0] wrdata,
    output reg [15:0] rdata
);

reg [15:0] reg_f [0:7];

always @(posedge clk or negedge rst)
begin
    if (!rst)
    begin
        reg_f[0] <= 16'b0;
        reg_f[1] <= 16'b0;
        reg_f[2] <= 16'b0;
        reg_f[3] <= 16'b0;
        reg_f[4] <= 16'b0;
        reg_f[5] <= 16'b0;
        reg_f[6] <= 16'b0;
        reg_f[7] <= 16'b0;

        rdata <= 16'b0;
    end
    else if (wren && !rden)
    begin
        reg_f[address] <= wrdata;
    end
    else if (rden && !wren)
    begin
        rdata <= reg_f[address];
    end
end

endmodule
