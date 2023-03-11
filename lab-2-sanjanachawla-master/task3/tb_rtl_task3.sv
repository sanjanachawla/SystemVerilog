module tb_rtl_task3();

// Your testbench goes here. Our toplevel will give up after 1,000,000 ticks.



    logic CLK;
    logic [3:0] KEY;
    logic [9:0] SW;
    logic [9:0] LEDR;
    logic [6:0] HEX0;
    logic [6:0] HEX1;
    logic [6:0] HEX2;
    logic [6:0] HEX3;
    logic [6:0] HEX4;
    logic [6:0] HEX5;
	 //logic VGA_HS(), .VGA_VS(), .VGA_CLK(),
	 
	
	 logic [7:0] VGA_R;
	 logic [7:0] VGA_G;
	 logic [7:0] VGA_B;
	 logic VGA_HS;
	 logic VGA_VS;
	 logic VGA_CLK;
	 logic [7:0] VGA_X;
	 logic [6:0] VGA_Y;
	 logic [2:0] VGA_COLOUR;
	 logic VGA_PLOT;
	 logic start;
	 logic rst_n;

//de1_gui gui(.SW, .KEY, .LEDR, .HEX5, .HEX4, .HEX3, .HEX2, .HEX1, .HEX0);
	 typedef enum logic [4:0] {NO_START,INIT,OCT1,OCT2,OCT3,OCT4,OCT5,OCT6,OCT7,OCT8,INC_OFF_Y,COND1_CRIT,COND2_INC_x_CRIT, DONE} State;

State currentState, nextState;

task3 dut(.CLOCK_50(CLK), .KEY(KEY), .SW(SW), .LEDR(LEDR), .HEX0(HEX0), .HEX1(HEX1), 
				  .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5), .VGA_X(VGA_X), .VGA_Y(VGA_Y),
				  .VGA_PLOT(VGA_PLOT), .VGA_COLOUR(VGA_COLOUR),
				  .*);
				  
							 
  initial begin

	  assign KEY = 'b1111;
	  #5;
	  assign KEY ='b0111;
	  #5;
	  assign KEY = 'b1111;
		#5;
    end
	 
	initial begin
	  CLK =0;
	  forever#2 CLK =~CLK;
	  end	
	initial begin
	
	if (dut.blackscreen.done == 0) begin
	assert (dut.greencircle.start == 0);
	assert (dut.greencircle.currentState == NO_START);
	assert (dut.VGA_Y == dut.blackscreen.VGA_Y1);
	assert (dut.VGA_X == dut.blackscreen.VGA_X1);
	assert (dut.VGA_COLOUR == dut.blackscreen.VGA_COLOUR1);
	end
	#5;
	if (dut.blackscreen.done == 1) begin
	assert (dut.greencircle.start == 1);
	assert (dut.VGA_Y == dut.blackscreen.VGA_Y2);
	assert (dut.VGA_X == dut.blackscreen.VGA_X2);
	assert (dut.VGA_COLOUR == dut.blackscreen.VGA_COLOUR2);
	end
	end
endmodule: tb_rtl_task3
