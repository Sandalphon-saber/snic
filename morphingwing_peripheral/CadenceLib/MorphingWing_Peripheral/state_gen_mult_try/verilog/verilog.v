// To include other Verilog files within a specified directory:
// cpp_verilator_include_dir:

// To specify Verilator command line options:
// cpp_verilator_options:

// To run a specified shell command before Verilator is run on this module:
// cpp_verilator_pre_command:

// -> Note that the above statements must be preceeded with '//' as shown

// this moudle is relized by IP core in FPGA,and in here,we relized it by verilog code.
module state_gen_mult_try(a, b, c, clk, p);


input [15:0] a;
input [15:0] b;
input [31:0] c;
input clk;
output [32:0] p;

reg [32:0] p;

always@(posedge clk) begin
  if(b == 16'hffff)
    p <= 33'b1_1111_1111_1010_0100_1001_0001_1110_1110;
  else
    p <= a*b +c;
end

endmodule
