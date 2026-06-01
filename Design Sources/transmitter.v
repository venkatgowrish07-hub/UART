// tx_load output pulses when a new byte starts, re-syncing the baud counter.
// This ensures every bit (including the start bit) is exactly one baud period long.
module tx(
    input        clk,
    input        rst,
    input        tx_tick,
    input        transmit,
    input  [7:0] data_in,
    output       txD,       
    output reg   busy,
    output reg   tx_load    // NEW: tells baud_generator to re-sync
);

reg [1:0] state;
reg [7:0] shift_reg;
reg [2:0] bit_count;

parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

assign txD = (state == START) ? 1'b0 :
             (state == DATA)  ? shift_reg[bit_count] :
             1'b1;  // IDLE and STOP drive the line high

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        state     <= IDLE;
        busy      <= 0;
        shift_reg <= 0;
        bit_count <= 0;
        tx_load   <= 0;
    end
    else
    begin
        tx_load <= 0;  // default: no re-sync

        case (state)

        IDLE:
        begin
            busy <= 0;
            if (transmit)
            begin
                busy      <= 1;
                shift_reg <= data_in;
                bit_count <= 0;
                tx_load   <= 1;  // reset baud counter 
                state     <= START;
            end
        end

        START:
        begin
            if (tx_tick)
                state <= DATA;
        end

        DATA:
        begin
            if (tx_tick)
            begin
                if (bit_count == 3'd7)
                begin
                    bit_count <= 0;
                    state     <= STOP;
                end
                else
                    bit_count <= bit_count + 1;
            end
        end

        STOP:
        begin
            if (tx_tick)
                state <= IDLE;
        end

        default: state <= IDLE;

        endcase
    end
end
endmodule
