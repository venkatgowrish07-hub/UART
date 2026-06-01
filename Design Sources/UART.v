module uarttop (
    input        clk,
    input        rst,
    input        txstart,
    input  [7:0] datain,
    input        uart_case_switch,
    input  [3:0] add_value,
    output [7:0] dataout,
    output       rxdone,
    output       busy
);
 
wire        tx_wire;
wire        tx_tick;
wire        rx_tick;
wire        tx_load;
wire [7:0]  rx_data;       
reg  [7:0]  processed_data; 
 
// ---- Data post-processing ----
always @(*) begin
    processed_data = rx_data;
    if (uart_case_switch) begin
        if (rx_data >= 8'd65 && rx_data <= 8'd90)
            processed_data = rx_data + 8'd32;  // uppercase -> lowercase
    end
    if (rx_data >= 8'd48 && rx_data <= 8'd57) begin
        processed_data = (((rx_data - 8'd48) + add_value) % 10) + 8'd48; // digit rotate
    end
end
 
assign dataout = processed_data;

baud_generator bg (
    .clk(clk),
    .rst(rst),
    .tx_load(tx_load),
    .tx_tick(tx_tick),
    .rx_tick(rx_tick)
);
 
tx transmitter (
    .clk(clk),
    .rst(rst),
    .tx_tick(tx_tick),
    .transmit(txstart),
    .data_in(datain),
    .txD(tx_wire),
    .busy(busy),
    .tx_load(tx_load)
);
 
rx receiver (
    .clk(clk),
    .rst(rst),
    .rx_tick(rx_tick),
    .rxD(tx_wire),
    .data_out(rx_data),   
    .rx_done(rxdone)
);
 
endmodule
 
