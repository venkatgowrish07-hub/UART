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

// ---- Internal wires ----
wire        tx_wire;        // serial line: TX1 -> RX1
wire        tx_wire2;       // serial line: TX2 -> RX2

wire        tx_tick1, tx_tick2;
wire        rx_tick1, rx_tick2;
wire        tx_load1, tx_load2;

wire [7:0]  rx_raw;         // byte captured by RX1 (unprocessed)
wire        rx1_done;       // RX1 has a new byte

reg  [7:0]  processed_data; // combinational processing result
reg         tx2_start;      // one-cycle pulse to kick TX2
reg  [7:0]  tx2_data;       // latched processed byte for TX2
wire        busy2;          // TX2 busy flag

// ---- Processing block (combinational) ----
always @(*) begin
    processed_data = rx_raw;
    if (uart_case_switch) begin
        if (rx_raw >= 8'd65 && rx_raw <= 8'd90)
            processed_data = rx_raw + 8'd32;   // A-Z -> a-z
    end
    if (rx_raw >= 8'd48 && rx_raw <= 8'd57) begin
        processed_data = (((rx_raw - 8'd48) + add_value) % 10) + 8'd48;
    end
end

// ---- Latch processed byte and trigger TX2 on rx1_done ----
always @(posedge clk or posedge rst) begin
    if (rst) begin
        tx2_start <= 0;
        tx2_data  <= 0;
    end else begin
        tx2_start <= 0;             // default: no pulse
        if (rx1_done && !busy2) begin
            tx2_data  <= processed_data;   // capture processed result
            tx2_start <= 1;                // kick TX2 for one cycle
        end
    end
end

// ---- Baud generator 1  (for TX1 / RX1) ----
baud_generator bg1 (
    .clk(clk), .rst(rst),
    .tx_load(tx_load1),
    .tx_tick(tx_tick1),
    .rx_tick(rx_tick1)
);

// ---- TX1 : sends datain over tx_wire ----
tx transmitter (
    .clk(clk), .rst(rst),
    .tx_tick(tx_tick1),
    .transmit(txstart),
    .data_in(datain),
    .txD(tx_wire),
    .busy(busy),
    .tx_load(tx_load1)
);

// ---- RX1 : receives raw byte from tx_wire ----
rx receiver1 (
    .clk(clk), .rst(rst),
    .rx_tick(rx_tick1),
    .rxD(tx_wire),
    .data_out(rx_raw),
    .rx_done(rx1_done)
);

// ---- Baud generator 2  (for TX2 / RX2) ----
baud_generator bg2 (
    .clk(clk), .rst(rst),
    .tx_load(tx_load2),
    .tx_tick(tx_tick2),
    .rx_tick(rx_tick2)
);

// ---- TX2 : re-transmits processed_data over tx_wire2 ----
tx transmitter2 (
    .clk(clk), .rst(rst),
    .tx_tick(tx_tick2),
    .transmit(tx2_start),
    .data_in(tx2_data),
    .txD(tx_wire2),
    .busy(busy2),
    .tx_load(tx_load2)
);

// ---- RX2 : receives processed byte from tx_wire2 -> dataout ----
rx receiver2 (
    .clk(clk), .rst(rst),
    .rx_tick(rx_tick2),
    .rxD(tx_wire2),
    .data_out(dataout),
    .rx_done(rxdone)
);

endmodule
