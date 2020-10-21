// To include other Verilog files within a specified directory:
// cpp_verilator_include_dir:

// To specify Verilator command line options:
// cpp_verilator_options:

// To run a specified shell command before Verilator is run on this module:
// cpp_verilator_pre_command:

// -> Note that the above statements must be preceeded with '//' as shown

// this moudle is a divider which is relized by IP core in FPGA,and in here,we relized it by verilog code.

module divider_frac(aclk, s_axis_dividend_tdata, s_axis_dividend_tvaild, s_axis_divisor_tdata, s_axis_divisor_tvaild, 
             m_axis_dout_tdata, m_axis_dout_tvaild);


input aclk;
input [11:0] s_axis_dividend_tdata;
input s_axis_dividend_tvaild;
input [11:0] s_axis_divisor_tdata;
input s_axis_divisor_tvaild;
output [23:0] m_axis_dout_tdata;
output m_axis_dout_tvaild;

 reg  [11:0] tempa;
 reg  [11:0] tempb;
 reg  [23:0] tempb_ex;

 always@(posedge aclk) 
 begin
   if (!(s_axis_dividend_tvaild && s_axis_divisor_tvaild))
      begin
       m_axis_dout_tdata =24'h000000;
	   m_axis_dout_tvaild <=1'b0;
	  end
   else if( s_axis_divisor_tdata == 12'b0)
      begin
           m_axis_dout_tdata =24'hffffff;
	       m_axis_dout_tvaild <=1'b1;
      end
	else
       begin
         tempa = s_axis_dividend_tdata / s_axis_divisor_tdata;
		 tempb = s_axis_dividend_tdata % s_axis_divisor_tdata;
		 tempb_ex = tempb * 4096;
		 tempb = tempb_ex / s_axis_divisor_tdata;
		 m_axis_dout_tdata[23:12] = tempa;
		 m_axis_dout_tdata[11:0] = tempb;
       end  	   
end 
  


endmodule
