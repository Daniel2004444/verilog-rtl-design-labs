
module counter_5(
    input wire clock,
    input wire down,
    input wire up,
    input wire load,
    input wire [4:0] in,
    output wire high,
    output wire low,
    output reg [4:0] count
);

always @(posedge clock) begin
    if (load) begin
        count <= in;
    end
    else if (down && !low) begin
        count <= count - 5'd1;
    end
    else if (up && !high && !down) begin
        count <= count + 5'd1;
    end
    else begin
        count <= count;
    end
end

assign low  = (count == 5'd0);
assign high = (count == 5'd31);

endmodule
