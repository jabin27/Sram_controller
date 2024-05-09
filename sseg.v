module sseg(bcd,seven_seg_out);

input wire  bcd;
output wire [6:0] seven_seg_out;

reg [6:0] seven_seg;

assign seven_seg_out = seven_seg;

always @(bcd)
 begin
  case (bcd)
   1'b0 : begin seven_seg = 7'b1000000; end
   1'b1 : begin seven_seg = 7'b1111001; end
   
  endcase
 end

endmodule