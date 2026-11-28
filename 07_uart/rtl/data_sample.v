module data_sample (
    input wire clk,
    input wire rst,
    input wire rx_in,
    input wire data_samp_en,
    input wire [5:0] prescale,
    input wire [5:0] edge_count,
    output reg sampled_bit
);

reg sample1;
reg sample2;
reg sample3;

always @(posedge clk or negedge rst)
begin
    if (!rst)
    begin
        sample1 <= 1'b0;
        sample2 <= 1'b0;
        sample3 <= 1'b0;
    end
    else if (data_samp_en)
    begin
        if (edge_count == (prescale / 2) - 2)
        begin
            sample1 <= rx_in;
        end
        else if (edge_count == (prescale / 2) - 1)
        begin
            sample2 <= rx_in;
        end
        else if (edge_count == (prescale / 2))
        begin
            sample3 <= rx_in;
        end
    end
end

// Majority voting
always @(*)
begin
    if ((sample1 && sample2) ||
        (sample1 && sample3) ||
        (sample2 && sample3))
    begin
        sampled_bit = 1'b1;
    end
    else
    begin
        sampled_bit = 1'b0;
    end
end

endmodule