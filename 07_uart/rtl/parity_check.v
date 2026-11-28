module parity_checker (
    input wire clk,
    input wire rst,
    input wire [7:0] p_data,
    input wire par_typ,
    input wire par_chk_en,
    input wire sampled_bit,
    output reg par_err
);

always @(posedge clk or negedge rst)
begin
    if (!rst)
    begin
        par_err <= 1'b0;
    end
    else if (par_chk_en)
    begin
        if (par_typ == 1'b0)
        begin
            // Even parity
            par_err <= (^p_data != sampled_bit);
        end
        else
        begin
            // Odd parity
            par_err <= (~^p_data != sampled_bit);
        end
    end
end

endmodule