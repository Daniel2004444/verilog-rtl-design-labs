
module LFSR_MINE (
    input wire data,
    input wire rst,
    input wire clk,
    input wire active,
    output reg crc,
    output reg valid
);

    localparam [7:0] seed = 8'hD8;

    reg [7:0] lfsr;
    reg [2:0] count;
    reg received_data;

    wire f1;
    assign f1 = lfsr[0] ^ data;

    always @(posedge clk or negedge rst)
    begin
        if (!rst)
        begin
            lfsr <= seed;
            crc <= 1'b0;
            valid <= 1'b0;
            count <= 3'd0;
            received_data <= 1'b0;
        end

        // Continue sending CRC bits
        else if (count != 3'd0)
        begin
            crc <= lfsr[0];
            valid <= 1'b1;

            if (count == 3'd7)
            begin
                count <= 3'd0;
                lfsr <= seed;
            end
            else
            begin
                lfsr <= lfsr >> 1;
                count <= count + 1'b1;
            end
        end

        // Receive incoming data
        else if (active)
        begin
            lfsr[0] <= lfsr[1];
            lfsr[1] <= lfsr[2];
            lfsr[2] <= lfsr[3] ^ f1;
            lfsr[3] <= lfsr[4];
            lfsr[4] <= lfsr[5];
            lfsr[5] <= lfsr[6];
            lfsr[6] <= lfsr[7] ^ f1;
            lfsr[7] <= f1;

            received_data <= 1'b1;
            valid <= 1'b0;
            crc <= 1'b0;
        end

        // Send first CRC bit after ACTIVE goes low
        else if (received_data)
        begin
            crc <= lfsr[0];
            lfsr <= lfsr >> 1;
            valid <= 1'b1;
            count <= 3'd1;
            received_data <= 1'b0;
        end

        // Idle
        else
        begin
            valid <= 1'b0;
            crc <= 1'b0;
            lfsr <= seed;
        end
    end

endmodule
