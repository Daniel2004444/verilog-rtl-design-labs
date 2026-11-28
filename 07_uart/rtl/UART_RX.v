module UART_RX (
    input wire clk,
    input wire rst,
    input wire rx_in,
    input wire par_en,
    input wire par_typ,
    input wire [5:0] prescale,

    output wire [7:0] p_data,
    output wire data_valid,
    output wire par_err,
    output wire stp_err
);

// Internal connections

wire edge_bit_en;
wire data_samp_en;
wire strt_chk_en;
wire par_chk_en;
wire stp_chk_en;
wire deser_en;

wire sampled_bit;
wire strt_glitch;
wire par_err_raw;

wire [3:0] bit_count;
wire [5:0] edge_count;

// Ignore parity errors when parity is disabled
assign par_err = par_en && par_err_raw;


// 1. UART RX FSM

uart_rx_fsm fsm_1 (
    .clk(clk),
    .rst(rst),
    .rx_in(rx_in),
    .par_en(par_en),
    .prescale(prescale),
    .bit_count(bit_count),
    .edge_count(edge_count),
    .par_err(par_err),
    .strt_glitch(strt_glitch),
    .stp_err(stp_err),

    .edge_bit_en(edge_bit_en),
    .data_samp_en(data_samp_en),
    .strt_chk_en(strt_chk_en),
    .par_chk_en(par_chk_en),
    .stp_chk_en(stp_chk_en),
    .deser_en(deser_en),
    .data_valid(data_valid)
);


// 2. Edge/Bit Counter

edge_bit_counter counter_1 (
    .clk(clk),
    .rst(rst),
    .enable(edge_bit_en),
    .prescale(prescale),
    .bit_count(bit_count),
    .edge_count(edge_count)
);


// 3. Data Sampling

data_sample sampling_1 (
    .clk(clk),
    .rst(rst),
    .rx_in(rx_in),
    .data_samp_en(data_samp_en),
    .prescale(prescale),
    .edge_count(edge_count),
    .sampled_bit(sampled_bit)
);


// 4. Deserializer

deserializer deser_1 (
    .clk(clk),
    .rst(rst),
    .sampled_bit(sampled_bit),
    .deser_en(deser_en),
    .edge_count(edge_count),
    .prescale(prescale),
    .p_data(p_data)
);


// 5. Parity Checker

parity_checker parity_1 (
    .clk(clk),
    .rst(rst),
    .p_data(p_data),
    .par_typ(par_typ),
    .par_chk_en(par_chk_en),
    .sampled_bit(sampled_bit),
    .par_err(par_err_raw)
);


// 6. Stop Bit Checker

stop_checker stop_1 (
    .clk(clk),
    .rst(rst),
    .stp_chk_en(stp_chk_en),
    .sampled_bit(sampled_bit),
    .stp_err(stp_err)
);


// 7. Start Bit Checker

strt_check start_1 (
    .clk(clk),
    .rst(rst),
    .sampled_bit(sampled_bit),
    .strt_chk_en(strt_chk_en),
    .strt_glitch(strt_glitch)
);

endmodule
