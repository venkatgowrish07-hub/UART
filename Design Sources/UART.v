module uarttop (
    input        clk,
    input        rst,
    input        txstart,
    input  [7:0] datain,
    output [7:0] dataout,
    output       rxdone,
    output       busy
);

wire tx_wire;
wire tx_tick;
wire rx_tick;
wire tx_load;   // baud-counter re-sync from transmitter

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
    .data_out(dataout),
    .rx_done(rxdone)
);

endmodule
