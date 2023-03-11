module tb_rtl_fillscreen();

// Your testbench goes here. Our toplevel will give up after 1,000,000 ticks.

//inputs
logic clk;
logic rst_n;
logic [2:0] colour;
logic start;

//outputs
logic done;
logic [7:0] vga_x;
logic [6:0] vga_y;
logic [2:0] vga_colour;
logic vga_plot;
						
fillscreen fillscreendut(.clk(clk), .rst_n(rst_n), .colour(colour), .start(start),
								 .done(done), .vga_x(vga_x), .vga_y(vga_y), 
								 .vga_colour(vga_colour), . vga_plot(vga_plot));


initial begin
  
  clk =0;
  forever#5 clk =~clk;
  end	
  
  initial begin
  
  assign start = 1;
  assign rst_n = 1;
  #5;
  assign rst_n = 0;
  #5;
  assign rst_n = 1;
  #5;
  
  end
  
  initial begin
  
  if (fillscreendut.vga_y == 119) begin
	assert (fillscreendut.done == 0);
	end
	
	#5;
	if (fillscreendut.vga_x == 159) begin
	assert (fillscreendut.done == 1);
	end
	
	#5;
	
	if (fillscreendut.start == 1) begin
	assert (fillscreendut.vga_plot == 1);
	end
	#5;
	
	if (fillscreendut.start == 0) begin
	assert (fillscreendut.vga_plot == 0);
	end
	#5;
	
  end

endmodule: tb_rtl_fillscreen
