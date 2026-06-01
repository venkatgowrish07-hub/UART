module top(
    input        clk,
    input        rst,
    input        rx,
    output       tx,

    // ---------- board inputs ----------
    input  [7:0] boardip,          // SW7-SW0  (what to transmit)
    input        load,             // BTNC     (trigger TX)
    input        uart_case_switch, // SW8      (upper→lower case)
    input  [3:0] add_value,        // SW12-SW9 (digit offset)

    // ---------- outputs ---------------
    output wire [7:0] led,
    output wire [6:0] seg,
    output wire [3:0] an
);


// Internal wires / regs

wire [7:0] rxdata;
wire       rxdone;
wire       txbusy;
wire       tx_tick;
wire       rx_tick;
wire       tx_load;

reg        txstart;
reg  [7:0] txdata;
reg  [7:0] leddata;
reg  [7:0] processed_data;
wire [3:0] thousands, hundreds, tens, ones;

assign led = leddata;

// Button edge-detect (load)

reg  btn_d;
wire btn_pulse;
always @(posedge clk) btn_d <= load;
assign btn_pulse = load & ~btn_d;


// RX input synchroniser (meta-stability protection)

reg rx_sync1, rx_sync2;
always @(posedge clk) begin
    rx_sync1 <= rx;
    rx_sync2 <= rx_sync1;
end


// FIFO  (depth 16, 8-bit wide)
// Stores received bytes so none are dropped while the top-level
// logic is processing the previous one.

reg [7:0] fifo_mem [0:15];
reg [3:0] fifo_wr_ptr;   // write pointer
reg [3:0] fifo_rd_ptr;   // read pointer
reg [4:0] fifo_count;    

wire fifo_full  = (fifo_count == 5'd16);
wire fifo_empty = (fifo_count == 5'd0);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        fifo_wr_ptr <= 0;
        fifo_count  <= 0;
        fifo_rd_ptr <= 0;
    end else begin
        if (rxdone && !fifo_full) begin
            fifo_mem[fifo_wr_ptr] <= rxdata;
            fifo_wr_ptr           <= fifo_wr_ptr + 1;
            fifo_count            <= fifo_count + 1;
        end

        if (fifo_rd_en && !fifo_empty) begin
            fifo_rd_ptr <= fifo_rd_ptr + 1;
            fifo_count  <= fifo_count - 1;
        end

        if (rxdone && !fifo_full && fifo_rd_en && !fifo_empty)
            fifo_count <= fifo_count; 
    end
end

wire [7:0] fifo_rd_data = fifo_mem[fifo_rd_ptr];
reg fifo_rd_en;

always @(*) begin
    processed_data = fifo_rd_data;

    // Upper-case → lower-case when switch is on
    if (uart_case_switch) begin
        if (fifo_rd_data >= 8'd65 && fifo_rd_data <= 8'd90)
            processed_data = fifo_rd_data + 8'd32;
    end

    // Digit offset for ASCII '0'..'9'
    if (fifo_rd_data >= 8'd48 && fifo_rd_data <= 8'd57)
        processed_data = (((fifo_rd_data - 8'd48) + add_value) % 10) + 8'd48;
end

// Main control FSM

always @(posedge clk or posedge rst) begin
    if (rst) begin
        leddata    <= 8'b0;
        txstart    <= 1'b0;
        txdata     <= 8'b0;
        fifo_rd_en <= 1'b0;
    end else begin
        txstart    <= 1'b0;
        fifo_rd_en <= 1'b0;

        // --- RX path: consume FIFO head ---
        if (!fifo_empty) begin
            leddata    <= processed_data;   // show processed byte on LEDs
            fifo_rd_en <= 1'b1;            // advance FIFO next cycle
        end

        // --- TX path: send boardip on button press ---
        if (btn_pulse && !txbusy) begin
            txdata  <= boardip;
            txstart <= 1'b1;
        end
    end
end

baud_generator bg (
    .clk    (clk),
    .rst    (rst),
    .tx_load(tx_load),
    .tx_tick(tx_tick),
    .rx_tick(rx_tick)
);

tx transmitter (
    .clk      (clk),
    .rst      (rst),
    .tx_tick  (tx_tick),
    .transmit (txstart),
    .data_in  (txdata),
    .txD      (tx),
    .busy     (txbusy),
    .tx_load  (tx_load)
);

rx receiver (
    .clk     (clk),
    .rst     (rst),
    .rx_tick (rx_tick),
    .rxD     (rx_sync2),
    .data_out(rxdata),
    .rx_done (rxdone)
);

bintobcd con (
    .thousands(thousands),
    .hundreds (hundreds),
    .tens     (tens),
    .ones     (ones),
    .bin      (leddata)
);

displaymux dm (
    .an       (an),
    .seg      (seg),
    .thousands(thousands),
    .hundreds (hundreds),
    .tens     (tens),
    .ones     (ones),
    .clk      (clk)
);

endmodule
