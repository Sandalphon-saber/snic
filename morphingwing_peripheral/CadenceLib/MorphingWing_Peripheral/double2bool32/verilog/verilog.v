// To include other Verilog files within a specified directory:
// cpp_verilator_include_dir:

// To specify Verilator command line options:
// cpp_verilator_options:

// To run a specified shell command before Verilator is run on this module:
// cpp_verilator_pre_command:

// -> Note that the above statements must be preceeded with '//' as shown

module double2bool32(in, out);

parameter scale1 = 0;

input in;
output [31:0] out;


endmodule
