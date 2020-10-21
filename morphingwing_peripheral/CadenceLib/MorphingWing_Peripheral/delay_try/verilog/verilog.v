  // To include other Verilog files within a specified directory:
// cpp_verilator_include_dir:

// To specify Verilator command line options:
// cpp_verilator_options:

// To run a specified shell command before Verilator is run on this module:
// cpp_verilator_pre_command:

// -> Note that the above statements must be preceeded with '//' as shown
//The reason why we create three delay modules is that if we just use one,the program will report an error.
//So,we can only do this to avoid this problem 

//`define dly 100
//`define bw  12

module delay_try (in, clk, reset, out);


parameter dly = 104 ;

input [11:0] in;
input clk;
input reset;
output wire  [11:0] out;

reg [11:0] din_dly[dly-1:0];

always@(posedge clk) begin
    if( reset == 1'b1 )
      din_dly[0] <= 0   ;
    else
      din_dly[0] <= in ;
end

  genvar i;
  generate for(i = 1; i < dly; i = i + 1) begin
    always@(posedge clk) begin
      if( reset == 1'b1 )
        din_dly[i] <= 0               ;
      else
        din_dly[i] <= din_dly[i - 1]  ;
      end
  end
  endgenerate
  
  assign out = din_dly[dly - 1]  ;

endmodule
