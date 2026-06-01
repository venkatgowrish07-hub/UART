module displaymux(an,seg,thousands,hundreds,tens,ones,clk);
input clk;
input [3:0] ones,tens,hundreds,thousands;
output reg [3:0] an;
output [6:0]seg;
reg [3:0] digit;

reg [19:0]refresh = 0;
reg [1:0]sel;

always @(posedge clk) begin
    refresh <= refresh + 1;
    sel <= refresh[19:18];
end

always @(*) 
    case(sel)
    2'b00:begin
        an<=4'b1110;
        digit<=ones;
    end
    2'b01:begin
        an<=4'b1101;
        digit<=tens;
    end
    2'b10:begin
        an<=4'b1011;
        digit<=hundreds;
    end
    2'b11:begin
        an<=4'b0111;
        digit<=thousands;
    end
    default:begin
        an<=4'b1110;
        digit<=4'b0000;
    end
    endcase 
segment se(seg,digit);
endmodule