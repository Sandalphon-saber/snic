// To include other Verilog files within a specified directory:
// cpp_verilator_include_dir:

// To specify Verilator command line options:
// cpp_verilator_options:

// To run a specified shell command before Verilator is run on this module:
// cpp_verilator_pre_command:

// -> Note that the above statements must be preceeded with '//' as shown

module mux2_try(in0, in1, s, out);


input [11:0] in0;
input [11:0] in1;
input s;
output [11:0] out;
reg out [11:0];
always@(*)begin
if (s==1) out = in0;
else out = in1;
end
endmodule
