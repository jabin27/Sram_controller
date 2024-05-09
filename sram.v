module sram(

input wire [17:0] ad,   // address input 
input wire we_n, oe_n, ce_a_n,  //  write enale, output enable, chip selector
inout wire [15:0] dio_a   // bi-directional data
);

// internal variables 
reg [15:0] mem [256000:0];
reg [15:0] data_f2s;

//----------code starts here------

//Tri-state buffer control
//output : When we_n = 1, oe_n = 0, ce_a_n = 0
assign dio_a=( !ce_a_n &&!oe_n && we_n)? data_f2s:16'bz;

//Write Operation : When rw = 0, ce_a_n = 0
always @(ad or dio_a or we_n or !ce_a_n)
begin
  if (!ce_a_n && !we_n)
      mem[ad]=dio_a;
end
//Read Operation : When oe_n = 0, ce_a_n = 0
always @(ad or we_n or oe_n or !ce_a_n)
begin
  if (!ce_a_n && we_n && ~oe_n)
      data_f2s=mem[ad];
end
endmodule
   
