module uarttoptb;
 
reg        clk, rst, txstart;
reg  [7:0] datain;
reg        uart_case_switch;
reg  [3:0] add_value;
 
wire [7:0] dataout;
wire       rxdone, busy;
 
uarttop uut (
    .clk              (clk),
    .rst              (rst),
    .txstart          (txstart),
    .datain           (datain),
    .uart_case_switch (uart_case_switch),
    .add_value        (add_value),
    .dataout          (dataout),
    .rxdone           (rxdone),
    .busy             (busy)
);

always #1 clk = ~clk;

initial begin
    clk = 0; rst = 1;
    txstart = 0; datain = 8'd0;uart_case_switch=0;  
    add_value = 4'd0;
    #10 rst = 0;

    #100 datain = 8'd65;  txstart = 1;
    #5   txstart = 0;
    @(posedge rxdone);

    #100 datain = 8'd66;  txstart = 1;uart_case_switch=1;
    #5   txstart = 0;
    @(posedge rxdone);

    #100 datain = 8'd50; txstart = 1;add_value = 4'd2;
    #5   txstart = 0;
    @(posedge rxdone);

    #200 $finish;
end

initial begin
    $dumpfile("uart_fixed.vcd");
    $dumpvars(0, uarttoptb);
end

always@(posedge rxdone) begin
    #1    
    $display("Time=%0t | Datain=%d | RX Done=%b | Data Out=%d",$time, datain, rxdone, dataout);
end
endmodule
