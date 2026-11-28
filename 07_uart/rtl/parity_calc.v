module parity_calc (
    input wire clk,
    input wire rst,
    input wire data_valid,
    input wire busy,
    input wire [7:0] p_data,
    input wire par_typ,
    input wire par_en,
    output reg par_bit
);

reg [7:0] data_reg;


// Store the data
always @(posedge clk or negedge rst)
begin
    if (!rst)
    begin
        data_reg <= 8'b0;
    end
    else if (data_valid && !busy)
    begin
        data_reg <= p_data;
    end
end


// Calculate parity
always @(*)
begin
    par_bit = 1'b0;

    if (par_en && par_typ == 1'b0)
    begin
        par_bit = ^data_reg;
    end
    else if (par_en && par_typ == 1'b1)
    begin
        par_bit = ~^data_reg;
    end
end

endmodule