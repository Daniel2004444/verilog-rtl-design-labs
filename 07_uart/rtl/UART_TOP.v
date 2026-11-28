module UART (
    input wire TX_CLK,
    input wire RX_CLK,
    input wire RST,
    input wire PAR_TYP,
    input wire PAR_EN,
    input wire [5:0] Prescale,

    input wire [7:0] TX_IN_P,
    input wire TX_IN_V,

    input wire RX_IN_S,

    output wire TX_OUT_S,
    output wire TX_OUT_V,

    output wire [7:0] RX_OUT_P,
    output wire RX_OUT_V
);

// Internal wires

wire par_err;
wire stp_err;


// UART Transmitter

U_TX TX_1 (
    .clk(TX_CLK),
    .rst(RST),
    .par_typ(PAR_TYP),
    .par_en(PAR_EN),
    .p_data(TX_IN_P),
    .data_valid(TX_IN_V),
    .tx_out(TX_OUT_S),
    .busy(TX_OUT_V)
);


// UART Receiver

UART_RX RX_1 (
    .clk(RX_CLK),
    .rst(RST),
    .rx_in(RX_IN_S),
    .par_en(PAR_EN),
    .par_typ(PAR_TYP),
    .prescale(Prescale),
    .p_data(RX_OUT_P),
    .data_valid(RX_OUT_V),
    .par_err(par_err),
    .stp_err(stp_err)
);

endmodule