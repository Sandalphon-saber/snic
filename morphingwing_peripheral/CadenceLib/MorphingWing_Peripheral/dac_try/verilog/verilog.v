// To include other Verilog files within a specified directory:
// cpp_verilator_include_dir:

// To specify Verilator command line options:
// cpp_verilator_options:

// To run a specified shell command before Verilator is run on this module:
// cpp_verilator_pre_command:

// -> Note that the above statements must be preceeded with '//' as shown

//the code of dac is copied from the FPGA project, but the simulation result is not as same as that in vivado. We don't know why, maybe there are something we neglect

module dac_try(in, clk, rst, out);

  input                     clk               ;
  input                     rst               ;
  input         [11 : 0]    in               ;
  
  output  reg               out              ; 

  reg           [13 : 0]    delta_adder_out       ;
  reg           [13 : 0]    sigma_adder_out       ;
  reg           [13 : 0]    sigma_latch_out       ;
  reg           [13 : 0]    delta_adder_in_b      ;
  
  always @ ( sigma_latch_out ) begin
    delta_adder_in_b = {sigma_latch_out[13], sigma_latch_out[13]} << 12;
  end
  
  always @ ( in or delta_adder_in_b ) begin
    delta_adder_out = in + delta_adder_in_b;
  end
  
  always @ ( delta_adder_out or sigma_latch_out ) begin
    sigma_adder_out = delta_adder_out + sigma_latch_out;
  end
  
  always @(posedge clk) begin
    if ( rst == 1'b1 )
      sigma_latch_out <= 14'b10_0000_0000_0000;
    else
      sigma_latch_out <= sigma_adder_out;
  end
  
  always @(posedge clk) begin
    if ( rst == 1'b1 )
      out <= 1'b0;
    else
      out <= sigma_latch_out[13];
  end

endmodule
