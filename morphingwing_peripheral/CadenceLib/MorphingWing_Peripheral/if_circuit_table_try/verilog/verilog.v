// To include other Verilog files within a specified directory:
// cpp_verilator_include_dir:

// To specify Verilator command line options:
// cpp_verilator_options:

// To run a specified shell command before Verilator is run on this module:
// cpp_verilator_pre_command:

// -> Note that the above statements must be preceeded with '//' as shown

//using ram to save the lookup table for input and output of IF circuit
//The reason is that FPGA can not relize an analog IF circuit

module if_circuit_table_try(addra, addrb, clka, clkb, dina, 
             dinb, ena, enb, wea, web, 
             douta, doutb);


input [11:0] addra;
input [11:0] addrb;
input clka;
input clkb;
input [11:0] dina;
input [11:0] dinb;
input ena;
input enb;
input wea;
input web;
output [11:0] douta;
output [11:0] doutb;

reg [11:0] mem[(1<<12)-1:0];

initial
begin
   $readmemb("ram_data.txt",mem);
end
always @(*)
begin 
if (wea && ena)
    mem[addra] = dina;
if (web && enb)
    mem[addrb] = dinb;
end

reg [11:0] rdata_a;

always@(posedge clka)
begin
  if (ena)
      rdata_a <= mem[addra];
end

reg [11:0] rdata_b;

always@(posedge clkb)
begin
   if(enb)
      rdata_b <= mem[addrb];
end
assign douta = rdata_a;
assign doutb = rdata_b;


endmodule
