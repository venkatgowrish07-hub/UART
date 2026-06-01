module bintobcd(thousands,hundreds,tens,ones,bin);

input [7:0] bin;
output reg [3:0] ones,tens,hundreds,thousands;

integer i;
reg [23:0] shift;

always @(*) begin
    shift = 0;
    shift[7:0] = bin;

     for (i = 0; i < 8; i = i + 1) begin
        if (shift[11:8]  >= 5) shift[11:8]  = shift[11:8]  + 3; // ones
        if (shift[15:12] >= 5) shift[15:12] = shift[15:12] + 3; // tens
        if (shift[19:16] >= 5) shift[19:16] = shift[19:16] + 3; // hundreds
        if (shift[23:20] >= 5) shift[23:20] = shift[23:20] + 3; // thousands

        shift = shift << 1;
    end

    // Assign outputs
    ones      = shift[11:8];
    tens      = shift[15:12];
    hundreds  = shift[19:16];
    thousands = shift[23:20];
end
endmodule