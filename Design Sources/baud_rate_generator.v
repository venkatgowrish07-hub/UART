// Generates tx_tick (1 pulse per bit period) and rx_tick (16 pulses per bit period).
// For 9600 baud @ 100 MHz: txfinval=10416, rxfinval=651 (16x oversampling).
// tx_load input (from transmitter) re-syncs the TX counter on every new transmission,
// ensuring the START bit is always exactly one full baud period long.

module baud_generator(
    input  clk,
    input  rst,
    input  tx_load,        // pulse from TX when a new byte begins
    output reg tx_tick,
    output reg rx_tick
);


// Adjust these for your clock frequency and baud rate:
//   txfinval = clk_freq / baud_rate          (e.g. 100e6/9600 = 10416)
//   rxfinval = clk_freq / (baud_rate * 16)   (e.g. 100e6/(9600*16) = 651)

localparam txfinval = 10416;
localparam rxfinval = 651;

reg [13:0] tx_counter;
reg [9:0]  rx_counter;

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        tx_counter <= 0;
        rx_counter <= 0;
        tx_tick    <= 0;
        rx_tick    <= 0;
    end
    else
    begin
        // ----- TX tick -----
        // reset tx_counter when TX starts a new byte so the first
        // bit period is always a full baud period (eliminates phase ambiguity).
        if (tx_load)
        begin
            tx_counter <= 0;
            tx_tick    <= 0;
        end
        else if (tx_counter == txfinval - 1)
        begin
            tx_counter <= 0;
            tx_tick    <= 1;
        end
        else
        begin
            tx_tick    <= 0;
            tx_counter <= tx_counter + 1;
        end

        // ----- RX tick (16× oversampling) -----
        if (rx_counter == rxfinval - 1)
        begin
            rx_counter <= 0;
            rx_tick    <= 1;
        end
        else
        begin
            rx_tick    <= 0;
            rx_counter <= rx_counter + 1;
        end
    end
end
endmodule
