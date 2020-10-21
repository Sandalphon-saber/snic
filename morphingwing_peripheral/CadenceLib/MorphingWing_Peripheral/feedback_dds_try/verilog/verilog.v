// To include other Verilog files within a specified directory:
// cpp_verilator_include_dir:

// To specify Verilator command line options:
// cpp_verilator_options:

// To run a specified shell command before Verilator is run on this module:
// cpp_verilator_pre_command:

// -> Note that the above statements must be preceeded with '//' as shown
// this module' function is to genrate feedback signal according to actuation signal
// this module is relized by IP core in FPGA,and in here,we relized it by verilog code


module feedback_dds_try(sys_clk, sys_rst, y, dac_data, dac_data_valid,  v_z);


localparam START_TIME = 27'd9584_0000	;
localparam PHASE_DELTA = 48'h0000_007a_0420	;

input sys_clk;
input sys_rst;
input [11:0] y;

output reg [1:0] dac_data;
output reg       dac_data_valid;
output reg [10:0] v_z;

 //
  // regs and wires
  //
  reg           [47 : 0]  phase_acc;
  
  reg           [26 : 0]  start_counter;
  wire                    start;
  reg                     start_dly;
  wire                    start_op;

  reg           [11 : 0]  y_1;
  reg           [11 : 0]  y_2;
  wire  signed  [12 : 0]  delta_y;
  reg   signed  [23 : 0]  delta_y_sum;
  reg           [11 : 0]  delta_y_num;
  reg           [10 : 0]  delta_y_bar;
  reg                     delta_y_bar_valid;
  
  reg                     delta_y_bar_div_en;
  wire          [25 : 0]  delta_y_bar_div_out;
  wire                    delta_y_bar_div_out_valid;
  
  reg           [ 9 : 0]  v_z_mag;
  
  reg                     update_trig;
  wire                    update_trig_dly1;
  wire                    update_trig_dly33;
  
  // **********************************************************************************************
  // DDS for the required frequency
  // the required frequency for z is (1/4.4) Hz, the pulse width is 20ms
  // phase_delta and duty_cycle are fixed in this case
  // 48 bits, 16 bits for fraction
  // **********************************************************************************************
  always @(posedge sys_clk) begin
    if ( sys_rst == 1'b1 )
      phase_acc <= 48'h0;
    else if ( start == 1'b1 )
      phase_acc <= phase_acc + PHASE_DELTA;
  end

  always @(posedge sys_clk) begin
    if ( sys_rst == 1'b1 )
      dac_data <= 2'b0;
    else if ( phase_acc < 48'h0129_e412_9e41)
      dac_data <= 2'b00;
    else if ( phase_acc < 48'h0253_c825_3c82)
      dac_data <= 2'b11;
    else if ( phase_acc < 48'h037d_ac37_dac3)
      dac_data <= 2'b00;
    else if ( phase_acc < 48'h04a7_904a_7905)
      dac_data <= 2'b11;
    else if ( phase_acc < 48'h05d1_745d_1746)
      dac_data <= 2'b00;
    else if ( phase_acc < 48'h06fb_586f_b587)
      dac_data <= 2'b11;
    else if ( phase_acc < 48'h0825_3c82_53c8)
      dac_data <= 2'b00;
    else if ( phase_acc < 48'h094f_2094_f209)
      dac_data <= 2'b11;
    else if ( phase_acc < 48'h0a79_04a7_904a)
      dac_data <= 2'b00;
    else if ( phase_acc < 48'h0ba2_e8ba_2e8c)
      dac_data <= 2'b11;
 
    else if ( phase_acc < 48'h8129_e412_9e41)
      dac_data <= 2'b00;
    else if ( phase_acc < 48'h8253_c825_3c82)
      dac_data <= 2'b01;
    else if ( phase_acc < 48'h837d_ac37_dac3)
      dac_data <= 2'b00;
    else if ( phase_acc < 48'h84a7_904a_7905)
      dac_data <= 2'b01;
    else if ( phase_acc < 48'h85d1_745d_1746)
      dac_data <= 2'b00;
    else if ( phase_acc < 48'h86fb_586f_b587)
      dac_data <= 2'b01;
    else if ( phase_acc < 48'h8825_3c82_53c8)
      dac_data <= 2'b00;
    else if ( phase_acc < 48'h894f_2094_f209)
      dac_data <= 2'b01;
    else if ( phase_acc < 48'h8a79_04a7_904a)
      dac_data <= 2'b00;
    else if ( phase_acc < 48'h8ba2_e8ba_2e8c)
      dac_data <= 2'b01;
    else
      dac_data <= 2'b00;
  end
  
  always @(posedge sys_clk) begin
    if ( sys_rst == 1'b1 )
      dac_data_valid <= 1'b0;
    else if ( start == 1'b1 )
      dac_data_valid <= 1'b1;
  end

  // **********************************************************************************************
  // Calculate for the maginitude of V_z
  // generate the first after a response time (START_TIME), and then generate based on actuation
  // signal y.
  // **********************************************************************************************
  always @(posedge sys_clk) begin
    if ( sys_rst == 1'b1 )
      start_counter <= 27'h0;
    else if ( start_counter < START_TIME + 27'd0000_4400 )
      start_counter <= start_counter + 1;
  end
  
  assign start = start_counter >= START_TIME;
  assign start_op = start_counter >= START_TIME + 27'd0000_4400;
  
  always @(posedge sys_clk) begin
    if ( sys_rst == 1'b1 )
      update_trig <= 1'b0;
    else if ( (start_op == 1'b1) && (phase_acc < PHASE_DELTA) )
      update_trig <= 1'b1;
    else
      update_trig <= 1'b0;
  end

  
//modification start  
/*   dly_cell #(.DLY(10),.BW(1)) U_update_trig_dly1 (
    .sys_clk    ( sys_clk                     ),
    .sys_rst    ( sys_rst                     ),
    .din        ( update_trig                 ),
    .dout       ( update_trig_dly1            )
  ); */
  
 reg [9:0] din_dly;
 always@(posedge sys_clk) begin
    if (sys_rst)
	   din_dly[0] <= 0;
    else
	   din_dly[0] <= update_trig;
  end
 
  genvar i;
  generate for (i = 1;i <10; i=i+1) begin
    always@(posedge sys_clk) begin
	  if (sys_rst == 1'b1)
	    din_dly[i] <=0			  ;
	  else
	    din_dly[i] <=din_dly[i-1];
	end
  end
  endgenerate
  assign update_trig_dly1 = din_dly[9];
  
/*   dly_cell #(.DLY(32),.BW(1)) U_update_trig_dly32 (
    .sys_clk    ( sys_clk                     ),
    .sys_rst    ( sys_rst                     ),
    .din        ( update_trig_dly1            ),
    .dout       ( update_trig_dly33           )
  ); */
  
  reg [31:0] din_dly1;
  always@(posedge sys_clk) begin
      if (sys_rst)
	   din_dly1[0] <= 0;
      else
	   din_dly1[0] <= update_trig;
  end
 
  genvar j;
  generate for (j = 1;j <32; j=j+1) begin
    always@(posedge sys_clk) begin
	  if (sys_rst == 1'b1)
	    din_dly1[j] <=0			  ;
	  else
	    din_dly1[j] <=din_dly1[j-1];
	end
  end
  endgenerate
  assign update_trig_dly33 = din_dly1[31];  
 // modification end 
 
 
  always @ (posedge sys_clk) begin
    if ( sys_rst )
      y_1 <= 0;
    else if ( update_trig == 1'b1 )
      y_1 <= y_2;
  end

  always @ (posedge sys_clk)
  begin
    if ( sys_rst )  
      y_2 <= 12'h0;
    else if ( update_trig == 1'b1 )
      y_2 <= y;
  end

  assign delta_y = {1'b0, y_2} - {1'b0, y_1};
  
  always @(posedge sys_clk)
  begin
    if ( sys_rst == 1'b1 )
      delta_y_num <= 0;
    else if ( (start_op == 1'b1) && (update_trig_dly1 == 1'b1) )
      delta_y_num <= delta_y_num + 1;
  end

  always @(posedge sys_clk)
  begin
    if ( sys_rst == 1'b1 ) 
      delta_y_sum <= 24'h0;
    else if ( (start_op == 1'b1) && (update_trig_dly1 == 1'b1) )
      delta_y_sum <= delta_y_sum + {{11{delta_y[12]}}, delta_y};
  end

  always @(posedge sys_clk) begin
    if ( sys_rst == 1'b1 )
      delta_y_bar_div_en <= 1'b0;
    else if ( (start_op == 1'b1) && (update_trig_dly1 == 1'b1) )
      delta_y_bar_div_en <= 1'b1;
  end

  
  //modification start
/*   div_int U_int_div (
  .aclk                     ( sys_clk                     ),                                      
  .s_axis_divisor_tvalid    ( delta_y_bar_div_en          ),    
  .s_axis_divisor_tdata     ( {1'b0, delta_y_num}         ),      
  .s_axis_dividend_tvalid   ( delta_y_bar_div_en          ),  
  .s_axis_dividend_tdata    ( delta_y_sum                 ),   
  .m_axis_dout_tvalid       ( delta_y_bar_div_out_valid   ),          
  .m_axis_dout_tdata        ( delta_y_bar_div_out         )           
  ); */
 // direct use "/" and "%"
 reg signed [23:0] tempa;
 reg signed [1:0]  tempb;
 reg [12:0] temp_divisor;
 always@(posedge sys_clk) begin
    if (!delta_y_bar_div_en)
       begin
         delta_y_bar_div_out = 26'd0;
	     delta_y_bar_div_out_valid <=1'b0;
       end
   else
       begin
         temp_divisor = {1'b0,delta_y_num};
         tempa =    delta_y_sum / temp_divisor;
         tempb =    delta_y_sum % temp_divisor;	 
         delta_y_bar_div_out[25:2] =tempa;
         delta_y_bar_div_out[1:0] = tempb;
         delta_y_bar_div_out_valid <=1'b1;
       end  	   
end 
  
 
//modification end
  
  
  always @(posedge sys_clk) begin
    if ( sys_rst == 1'b1 )
      delta_y_bar <= 0;
    else if ( delta_y_bar_div_out_valid == 1'b1 )
      delta_y_bar <= delta_y_bar_div_out[12:2];
  end

  always @(posedge sys_clk) begin
    if ( sys_rst == 1'b1 )
      delta_y_bar_valid <= 1'b0;
    else
      delta_y_bar_valid <= delta_y_bar_div_out_valid;
  end
  
  always @(posedge sys_clk) begin
    if ( sys_rst == 1'b1 )
      start_dly <= 1'b0;
    else
      start_dly <= start;
  end
  
  always @(posedge sys_clk) begin
    if ( sys_rst == 1'b1 )
      v_z_mag <= 10'h0;
    else if ( (start == 1'b1) && (start_dly == 1'b0) )
      v_z_mag <= 10'h180;
    else if ( (update_trig_dly33 == 1'b1) && (delta_y_bar_valid == 1'b1) ) begin
      if ( delta_y_bar > 11'h200 )
        v_z_mag <= 10'h180;
      else if ( delta_y_bar < 11'h055 )
        v_z_mag <= 10'h040;
      else
        v_z_mag <= delta_y_bar[10:1] + delta_y_bar[10:3] + (delta_y_bar[0] && delta_y_bar[2]);
    end
  end

  always @(posedge sys_clk) begin
    if ( sys_rst == 1'b1 )
	  v_z <= 11'h0;
    else begin
      case ( dac_data )
        2'b00     : v_z <= 11'h0;
        2'b01     : v_z <= {1'b0, v_z_mag};
        2'b11     : v_z <= {1'b1, (~v_z_mag) + 1};
        default   : v_z <= 11'h0;
      endcase
    end
  end
  
  
endmodule
