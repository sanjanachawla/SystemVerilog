module tb_rtl_task2();

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

	// de1_gui gui(.SW, .KEY, .LEDR, .HEX5, .HEX4, .HEX3, .HEX2, .HEX1, .HEX0);
	 
	 


	 task2 dut(.CLOCK_50(CLK), .KEY(KEY), .SW(SW), .LEDR(LEDR), .HEX0(HEX0), .HEX1(HEX1), 
				  .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5), 
				  .*);

	 
initial begin
  
  CLK =0;
  forever#5 CLK =~CLK;
  end	
  
 initial begin
 assign KEY = 'b1111;
 #5;
 assign KEY = 'b0111;
 assign KEY = 'b1111;
  //assign KEY[3] = rst_n;
  //assign KEY[0] = 1;
  //assign KEY[3] = 1;
  //#5;
  //assign KEY[3] = 0;
  //#5;
  //assign KEY[3] = 1;
  //#5;
  end
  

endmodule: tb_rtl_task2
