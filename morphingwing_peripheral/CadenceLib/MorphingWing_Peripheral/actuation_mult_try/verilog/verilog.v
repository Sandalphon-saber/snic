// To include other Verilog files within a specified directory:
// cpp_verilator_include_dir:

// To specify Verilator command line options:
// cpp_verilator_options:

// To run a specified shell command before Verilator is run on this module:
// cpp_verilator_pre_command:

// -> Note that the above statements must be preceeded with '//' as shown

//// this moudle is relized by IP core in FPGA,and in here,we relized it by verilog code

module actuation_mult_try(a, b, c, d, clk, 
             sclr, p);


input [11:0] a;
input [7:0] b;
input [19:0] c;
input [11:0] d;
input clk;
input sclr;
output [20:0] p;

reg [11:0] temp;

always@(posedge clk) begin
  if (sclr == 1'b1)
     p = 21'b0000_0000_0000_0000_0000_0	;
  else if(d >= a)
     p = (d-a)*b+c	;
  else
    begin
      temp = a-d;
      temp = ~temp + 1'b1;
      p = temp*b+c;
    end
end
 

endmodule
