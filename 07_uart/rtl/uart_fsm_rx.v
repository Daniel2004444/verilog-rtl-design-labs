module uart_rx_fsm (
    input wire clk,
    input wire rst,
    input wire rx_in,
    input wire par_en,
    input wire [5:0] prescale,
    input wire [3:0] bit_count,
    input wire [5:0] edge_count,
    input wire par_err,
    input wire strt_glitch,
    input wire stp_err,

    output reg edge_bit_en,
    output reg data_samp_en,
    output reg par_chk_en,
    output reg strt_chk_en,
    output reg stp_chk_en,
    output reg deser_en,
    output reg data_valid
);


// State declaration
localparam [2:0]
    IDLE    = 3'b000,
    START   = 3'b001,
    DATA    = 3'b010,
    PARITY  = 3'b011,
    STOP    = 3'b100,
    ERR_CHK = 3'b101;

reg [2:0] current_state, next_state;


// 1. State register
always @(posedge clk or negedge rst)
begin
    if (!rst)
        current_state <= IDLE;
    else
        current_state <= next_state;
end


// 2. Next-state logic
always @(*)
begin
    next_state = current_state;

    case (current_state)

        IDLE:
        begin
            if (!rx_in)
                next_state = START;
        end

        START:
        begin
            if (bit_count == 4'd0 &&
                edge_count == prescale - 6'd1)
            begin
                if (!strt_glitch)
                    next_state = DATA;
                else
                    next_state = IDLE;
            end
        end

        DATA:
        begin
            if (bit_count == 4'd8 &&
                edge_count == prescale - 6'd1)
            begin
                if (par_en)
                    next_state = PARITY;
                else
                    next_state = STOP;
            end
        end

        PARITY:
        begin
            if (bit_count == 4'd9 &&
                edge_count == prescale - 6'd1)
            begin
                next_state = STOP;
            end
        end

        STOP:
        begin
            if (par_en)
            begin
                if (bit_count == 4'd10 &&
                    edge_count == prescale - 6'd2)
                begin
                    next_state = ERR_CHK;
                end
            end
            else
            begin
                if (bit_count == 4'd9 &&
                    edge_count == prescale - 6'd2)
                begin
                    next_state = ERR_CHK;
                end
            end
        end

        ERR_CHK:
        begin
            if (!rx_in)
                next_state = START;
            else
                next_state = IDLE;
        end

        default:
            next_state = IDLE;

    endcase
end


// 3. Output logic
always @(*)
begin

    // Default values
    edge_bit_en = 1'b0;
    data_samp_en = 1'b0;
    deser_en = 1'b0;
    par_chk_en = 1'b0;
    strt_chk_en = 1'b0;
    stp_chk_en = 1'b0;
    data_valid = 1'b0;

    case (current_state)

        IDLE:
        begin
            if (!rx_in)
            begin
                edge_bit_en = 1'b1;
                data_samp_en = 1'b1;
                strt_chk_en = 1'b1;
            end
        end

        START:
        begin
            edge_bit_en = 1'b1;
            data_samp_en = 1'b1;
            strt_chk_en = 1'b1;
        end

        DATA:
        begin
            edge_bit_en = 1'b1;
            data_samp_en = 1'b1;
            deser_en = 1'b1;
        end

        PARITY:
        begin
            edge_bit_en = 1'b1;
            data_samp_en = 1'b1;
            par_chk_en = 1'b1;
        end

        STOP:
        begin
            edge_bit_en = 1'b1;
            data_samp_en = 1'b1;
            stp_chk_en = 1'b1;
        end

        ERR_CHK:
        begin
            data_samp_en = 1'b1;

            if (!par_err && !stp_err)
                data_valid = 1'b1;
        end

        default:
        begin
            edge_bit_en = 1'b0;
            data_samp_en = 1'b0;
            deser_en = 1'b0;
            par_chk_en = 1'b0;
            strt_chk_en = 1'b0;
            stp_chk_en = 1'b0;
            data_valid = 1'b0;
        end

    endcase
end

endmodule