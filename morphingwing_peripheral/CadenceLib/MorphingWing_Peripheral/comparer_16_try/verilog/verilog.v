// To include other Verilog files within a specified directory:
// cpp_verilator_include_dir:

// To specify Verilator command line options:
// cpp_verilator_options:

// To run a specified shell command before Verilator is run on this module:
// cpp_verilator_pre_command:

// -> Note that the above statements must be preceeded with '//' as shown

module comparer_16_try(in0, in1, out);


input [15:0] in0;
input [15:0] in1;
output out;

assign out = in0>in1	?0 : 1;

endmodule
