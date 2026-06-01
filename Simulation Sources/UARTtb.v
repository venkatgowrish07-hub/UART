module uarttoptb;
reg clk, rst, txstart;
reg [7:0] datain;

wire [7:0] dataout;
wire rxdone, busy;

uarttop uut (
    .clk(clk),
    .rst(rst),
    .txstart(txstart),
    .datain(datain),
    .dataout(dataout),
    .rxdone(rxdone),
    .busy(busy)
);

always #1 clk = ~clk;

initial begin
    clk = 0; rst = 1;
    txstart = 0; datain = 8'd0;   

    #10 rst = 0;

    #100 datain = 8'd65;  txstart = 1;
    #5   txstart = 0;
    @(posedge rxdone);

    #100 datain = 8'd66;  txstart = 1;
    #5   txstart = 0;
    @(posedge rxdone);

    #100 datain = 8'd125; txstart = 1;
    #5   txstart = 0;
    @(posedge rxdone);

    #200 $finish;
end

initial begin
    $dumpfile("uart_fixed.vcd");
    $dumpvars(0, uarttoptb);
    $monitor("Time=%0t | Datain=%d | RX Done=%b | Data Out=%d",
             $time, datain, rxdone, dataout);
end
endmodule
