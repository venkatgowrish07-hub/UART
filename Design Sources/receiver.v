module rx(
    input        clk,
    input        rst,
    input        rx_tick,
    input        rxD,
    output reg [7:0] data_out,
    output reg   rx_done
);

reg [1:0] state;
reg [3:0] sample_count;
reg [2:0] bit_count;
reg [7:0] shift_reg;

parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        state        <= IDLE;
        sample_count <= 0;
        bit_count    <= 0;
        shift_reg    <= 0;
        data_out     <= 0;
        rx_done      <= 0;
    end
    else
    begin
        rx_done <= 0;   // rx_done is a 1-cycle pulse

        if (rx_tick)
        begin
            case (state)

            IDLE:
            begin
                sample_count <= 0;
                bit_count    <= 0;
                if (rxD == 0)       // falling edge: start bit detected
                    state <= START;
            end

            START:
            begin
                sample_count <= sample_count + 1;
                if (sample_count == 4'd7)
                begin
                    if (rxD == 0)       // confirmed start bit at mid-point
                    begin
                        sample_count <= 0;
                        state        <= DATA;
                    end
                    else
                        state <= IDLE;  // false start, abort
                end
            end

            DATA:
            begin
                // Sample each data bit at its mid-point (every 16 rx_ticks).
                sample_count <= sample_count + 1;
                if (sample_count == 4'd15)
                begin
                    sample_count        <= 0;
                    shift_reg[bit_count] <= rxD;
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
                sample_count <= sample_count + 1;
                if (sample_count == 4'd15)
                begin
                    sample_count <= 0;
                    if (rxD == 1)       // valid stop bit
                    begin
                        data_out <= shift_reg;
                        rx_done  <= 1;
                    end
                    state <= IDLE;
                end
            end

            default: state <= IDLE;

            endcase
        end
    end
end
endmodule
