
module door(
    input wire up_max,
    input wire dn_max,
    input wire act,
    input wire clk,
    input wire rst,
    output reg up_m,
    output reg dn_m
);

    // State declarations
    localparam [1:0] IDLE  = 2'b00,
                     mv_up = 2'b01,
                     mv_dn = 2'b10;

    reg [1:0] current_state, next_state;

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
                if (act && dn_max && !up_max)
                    next_state = mv_up;

                else if (act && up_max && !dn_max)
                    next_state = mv_dn;
            end

            mv_up:
            begin
                if (up_max)
                    next_state = IDLE;
            end

            mv_dn:
            begin
                if (dn_max)
                    next_state = IDLE;
            end

            default:
                next_state = IDLE;

        endcase
    end

    // 3. Moore output logic
    always @(*)
    begin
        up_m = 1'b0;
        dn_m = 1'b0;

        case (current_state)

            IDLE:
            begin
                up_m = 1'b0;
                dn_m = 1'b0;
            end

            mv_up:
            begin
                up_m = 1'b1;
                dn_m = 1'b0;
            end

            mv_dn:
            begin
                up_m = 1'b0;
                dn_m = 1'b1;
            end

            default:
            begin
                up_m = 1'b0;
                dn_m = 1'b0;
            end

        endcase
    end

endmodule
