module uarttop (
    input        clk,
    input        rst,
    input        txstart,
    input        uart_case_switch,
    input  [3:0] add_value,
    input  [7:0] datain,
    output reg [7:0] dataout,
    output       rxdone,
    output       busy
);

wire tx_wire;
wire tx_tick;
wire rx_tick;
wire tx_load;   // baud-counter re-sync from transmitter
wire [7:0] rxdata;

always @(*) begin
    dataout = rxdata;

    // Upper-case → lower-case 
    if (uart_case_switch) begin
        if (rxdata >= 8'd65 && rxdata <= 8'd90)
            dataout = rxdata + 8'd32;
    end

    // Digit offset for ASCII '0'..'9'
    if (rxdata >= 8'd48 && rxdata <= 8'd57)
        dataout = (((rxdata - 8'd48) + add_value) % 10) + 8'd48;
end

baud_generator bg(
    .clk(clk),
    .rst(rst),
    .tx_load(tx_load),
    .tx_tick(tx_tick),
    .rx_tick(rx_tick)
);

tx transmitter(
    .clk(clk),
    .rst(rst),
    .tx_tick(tx_tick),
    .transmit(txstart),
    .data_in(datain),
    .txD(tx_wire),
    .busy(busy),
    .tx_load(tx_load)
);

rx receiver(
    .clk(clk),
    .rst(rst),
    .rx_tick(rx_tick),
    .rxD(tx_wire),
    .data_out(rxdata),
    .rx_done(rxdone)
);

endmodule
