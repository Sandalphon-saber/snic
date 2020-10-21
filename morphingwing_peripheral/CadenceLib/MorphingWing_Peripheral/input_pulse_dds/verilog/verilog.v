// To include other Verilog files within a specified directory:
// cpp_verilator_include_dir:

// To specify Verilator command line options:
// cpp_verilator_options:

// To run a specified shell command before Verilator is run on this module:
// cpp_verilator_pre_command:

// -> Note that the above statements must be preceeded with '//' as shown

//this module's function is to transform the processed input signal to pulses
//the ip core calls are replaced by verilog code has the same function 

module input_pulse_dds(sys_clk, sys_rst, f_required_valid, f_required, dac_data, 
             dac_data_valid);


input sys_clk;
input sys_rst;
input f_required_valid;
input [15:0] f_required;
output reg [9:0] dac_data;
output reg dac_data_valid;

 //
  // regs and wires
  //
  reg           [47 : 0]  phase_acc;
  wire          [47 : 0]  duty_cycle;
  wire          [47 : 0]  phase_delta;
  wire                    phase_delta_out_valid;
  wire          [47 : 0]  phase_delta_out;
  wire                    duty_cycle_out_valid;
  wire          [47 : 0]  duty_cycle_out;
  
  always @(posedge sys_clk) begin
    if ( sys_rst == 1'b1 )
      phase_acc <= 48'h0;
    else
      phase_acc <= phase_acc + phase_delta;
  end
 

//modification start
/*   div_16b_19b U_phase_delta_divider (
    .aclk                     ( sys_clk                   ),
    .s_axis_divisor_tvalid    ( 1'b1                      ),
    .s_axis_divisor_tdata     ( 19'd15625                 ),
    .s_axis_dividend_tvalid   ( f_required_valid          ),
    .s_axis_dividend_tdata    ( f_required                ),
    .m_axis_dout_tvalid       ( phase_delta_out_valid     ),
    .m_axis_dout_tdata        ( phase_delta_out           ) 
  ); */
 // direct use "/" and "%"
 reg  [15:0] tempa;
 reg  [31:0]  tempb;
 reg  [18:0] temp_divisor;
 reg  [47:0] tempb_ex;
 always@(posedge sys_clk) begin
    if (!f_required_valid)
	   begin
         phase_delta_out = 48'd0;
	     phase_delta_out_valid <=1'b0;
       end
   else
       begin
         temp_divisor = 19'd15625;
         tempa = 	f_required / temp_divisor;
         tempb =    f_required % temp_divisor;	 
         tempb_ex = tempb * 33'b1_0000_0000_0000_0000_0000_0000_0000_0000;
         tempb = tempb_ex /temp_divisor;
		// phase_delta_out[47:32] = tempa;
		// phase_delta_out[31:0]  = tempb;
                   phase_delta_out = {tempa,tempb};
		 phase_delta_out_valid <= 1'b1;
       end  	   
end 
  

//modification end 

  
  assign phase_delta = {1'b0, phase_delta_out[47 : 1]};

//modification start  
 /*  div_16b_19b U_duty_cycle_dividr (
    .aclk                     ( sys_clk                   ),
    .s_axis_divisor_tvalid    ( 1'b1                      ),
    .s_axis_divisor_tdata     ( 19'd25                    ),
    .s_axis_dividend_tvalid   ( f_required_valid          ),
    .s_axis_dividend_tdata    ( f_required                ),
    .m_axis_dout_tvalid       ( duty_cycle_out_valid      ),
    .m_axis_dout_tdata        ( duty_cycle_out            ) 
  ); */
 // direct use / and %
 
 reg  [15:0]  tempa1;
 reg  [31:0]  tempb1;
 reg  [18:0]  temp_divisor1;
 reg  [47:0]  tempb1_ex;
 always@(posedge sys_clk) begin
    if (!f_required_valid)
	   begin
         duty_cycle_out = 48'd0;
	     duty_cycle_out_valid <=1'b0;
       end
   else
       begin
         temp_divisor1 = 19'd25;
         tempa1 = 	f_required / temp_divisor1;
         tempb1 =    f_required % temp_divisor1;
         tempb1_ex = tempb1 * 33'b1_0000_0000_0000_0000_0000_0000_0000_0000;
         tempb1 = tempb1_ex /temp_divisor1;	 
		// duty_cycle_out[47:32] = tempa1;
		// duty_cycle_out[31:0]  = tempb1;
                   duty_cycle_out = {tempa1,tempb1};
		 duty_cycle_out_valid <= 1'b1;
       end  	   
end 
  
//modification end
  
  assign duty_cycle = {duty_cycle_out[41 : 0], 6'h0};
  
  always @(posedge sys_clk) begin
    if ( sys_rst == 1'b1 )
      dac_data <= 10'h0;
    else if ( phase_acc < duty_cycle )
      dac_data <= 10'b01_1111_1111;
    else if ( phase_acc < {duty_cycle[47 : 0], 1'b0} )
      dac_data <= 10'b10_0000_0000;
    else
      dac_data <= 10'h0;
  end
  
  always @(posedge sys_clk) begin
    if ( sys_rst == 1'b1 )
      dac_data_valid <= 1'b0;
    else
      dac_data_valid <= phase_delta_out_valid;
  end
endmodule
