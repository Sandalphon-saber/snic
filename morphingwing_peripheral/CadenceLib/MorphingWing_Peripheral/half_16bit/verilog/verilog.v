// To include other Verilog files within a specified directory:
// cpp_verilator_include_dir:

// To specify Verilator command line options:
// cpp_verilator_options:

// To run a specified shell command before Verilator is run on this module:
// cpp_verilator_pre_command:

// -> Note that the above statements must be preceeded with '//' as shown

module half_16bit(in, out);


input [15:0] in;
output [15:0] out;

assign out = {1'b0,in[15:1]};

endmodule
