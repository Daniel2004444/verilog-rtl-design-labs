module mux (
    input wire [1:0] mux_sel,
    input wire start_bit,
    input wire stop_bit,
    input wire par_bit,
    input wire ser_data,
    input wire clk,
    input wire rst,
    output reg tx_out
);

reg mux_data;

always @(*)
begin
    case(mux_sel)
        2'b00: mux_data = start_bit;
        2'b01: mux_data = ser_data;
        2'b10: mux_data = par_bit;
        2'b11: mux_data = stop_bit;
        default: mux_data = 1'b1;
    endcase
end

always @(posedge clk or negedge rst)
begin 
  if(!rst)
    begin
      tx_out<= 1'b1;
    end
  else
  begin
    tx_out <=mux_data;
  end
end
endmodule