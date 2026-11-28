module uart_fsm_tx (
  input wire data_valid,
  input wire clk,
  input wire rst,
  input wire par_en,
  input wire ser_done,
  output reg ser_en,
  output reg busy,
  output reg [1:0] mux_sel
  );
  
reg [2:0] current_state, next_state;
  
localparam [2:0] IDLE   = 3'b000, // states
                 START  = 3'b001,
                 DATA   = 3'b010,
                 PARITY = 3'b011,
                 STOP   = 3'b100;
                 
always @(posedge clk or negedge rst) // state register
    begin
        if (!rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end
    
always @(*)//next state logic
begin
    next_state = current_state;

    case(current_state)

        IDLE:
        begin
            if(data_valid)
                next_state = START;
        end

        START:
        begin
            next_state = DATA;
        end

        DATA:
        begin
            if(ser_done)
            begin
                if(par_en)
                    next_state = PARITY;
                else
                    next_state = STOP;
            end
        end

        PARITY:
        begin
            next_state = STOP;
        end

        STOP:
        begin
            next_state = IDLE;
        end

        default:
        begin
            next_state = IDLE;
        end

    endcase
end

always @(*)
begin
    mux_sel = 2'b11;
    busy = 1'b0;
    ser_en = 1'b0;

    case (current_state)

        IDLE:
        begin
            mux_sel = 2'b11;
            busy = 1'b0;
            ser_en = 1'b0;
        end

        START:
        begin
            mux_sel = 2'b00;
            busy = 1'b1;
            ser_en = 1'b0;
        end

        DATA:
        begin
            mux_sel = 2'b01;
            busy = 1'b1;
            ser_en = !ser_done;
        end

        PARITY:
        begin
            mux_sel = 2'b10;
            busy = 1'b1;
            ser_en = 1'b0;
        end

        STOP:
        begin
            mux_sel = 2'b11;
            busy = 1'b1;
            ser_en = 1'b0;
        end

        default:
        begin
            mux_sel = 2'b11;
            busy = 1'b0;
            ser_en = 1'b0;
        end

    endcase
end

endmodule

        
          
