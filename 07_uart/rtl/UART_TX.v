module U_TX (
    input wire clk,
    input wire rst,
    input wire par_typ,
    input wire par_en,
    input wire [7:0] p_data,
    input wire data_valid,
    output wire tx_out,
    output wire busy
);

wire ser_done;
wire ser_en;
wire par_bit;
wire ser_data;
wire [1:0] mux_sel;


// FSM
uart_fsm_tx fsm_1 (
    .data_valid(data_valid),
    .clk(clk),
    .rst(rst),
    .par_en(par_en),
    .ser_done(ser_done),
    .ser_en(ser_en),
    .busy(busy),
    .mux_sel(mux_sel)
);


// Serializer
serializer srl_1 (
    .clk(clk),
    .rst(rst),
    .P_DATA(p_data),
    .data_valid(data_valid),
    .ser_en(ser_en),
    .busy(busy),
    .ser_done(ser_done),
    .ser_data(ser_data)
);


// Parity Calculator
parity_calc par_1 (
    .clk(clk),
    .rst(rst),
    .busy(busy),
    .par_en(par_en),
    .data_valid(data_valid),
    .p_data(p_data),
    .par_typ(par_typ),
    .par_bit(par_bit)
);


// MUX
mux mux_1 (
    .mux_sel(mux_sel),
    .start_bit(1'b0),
    .stop_bit(1'b1),
    .par_bit(par_bit),
    .ser_data(ser_data),
    .clk(clk),
    .rst(rst),
    .tx_out(tx_out)
);

endmodule