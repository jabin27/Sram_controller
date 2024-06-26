`timescale 1ns/1ps
module dual_clk_design_2_tb;

reg clk_w,clk_r, reset;
reg [7:0] sw;
reg [2:0] btn;
wire ready;
wire [17:0] ad;
wire we_n, oe_n; 
// sram chip a 
wire [15:0] dio_a;  
wire ce_a_n, ub_a_n, lb_a_n;
reg mem, rw;
reg [15:0] data_f2s;
wire [15:0] data_s2f;
wire [17:0] addr;
reg [7:0] data_reg;
wire [15:0] led;


initial begin
   		clk_w = 0;
		reset =1;
		sw=8'b00000000;
		btn=3'b000;
		data_reg=8'b00000000;
		forever begin
		#10 clk_w = ~clk_w;
		end
	
	end
initial begin
   		clk_r = 0;
		forever begin
		#5 clk_r = ~clk_r;
		end
	
	end
initial begin
#100 reset=0; sw=8'b11110000;   //1st address  
       
      btn=3'b001;        //data goes to data_reg from data_f2s  
#40   btn=3'b010;       // write
#40   btn=3'b100;       // read
#40   btn=3'b000;
#40   sw=8'b11111111;   //  2nd address
       
      btn=3'b001;        //address goes to data_reg from addr 
#40  btn=3'b010;       // write
#40    btn=3'b100;       // read

#40   btn=3'b000;     //idle state




end

dual_clk_design_2 ctrl_unit
(.clk_w(clk_w),.clk_r(clk_r), .reset (reset), .mem(mem), .rw(rw), .addr(addr), .data_f2s(data_f2s), .ready(ready),
 .data_s2f_r (data_s2f), .data_s2f_ur(), .ad(ad),
.we_n(we_n), .oe_n(oe_n), .dio_a(dio_a), 
.ce_a_n (ce_a_n) , .ub_a_n (ub_a_n) , .lb_a_n(lb_a_n)) ;

sram1 sram_unit (.ad(ad),.we_n(we_n), .oe_n(oe_n), .ce_a_n(ce_a_n), .dio_a(dio_a));

// d a t a r e g i s t e r s
always @*
if (btn[0] )
data_reg <= sw;
// a d d r e s s
assign addr = {12'b0, sw};

 //
always @*
begin
data_f2s = 0;
if (btn[1]) // w r i t e
begin
mem = 1'b1;
rw = 1'b0;
data_f2s = {8'b0, data_reg};
end
//always @(posedge clk_r)
else if (btn[2]) // r e a d
begin
mem = 1'b1;
rw = 1'b1;
end
else
begin
mem = 1'b0;
rw = 1'b1;
end
end

assign led = data_s2f [15:0] ;

endmodule

