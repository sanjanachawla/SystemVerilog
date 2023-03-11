module tb_syn_circle();

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

//module circle(input logic clk, input logic rst_n, input logic [2:0] colour,
//              input logic [7:0] centre_x, input logic [6:0] centre_y, input logic [7:0] radius,
//              input logic start, output logic done,
//              output logic [7:0] vga_x, output logic [6:0] vga_y,
//              output logic [2:0] vga_colour, output logic vga_plot);
						
circle circledut(.clk(clk), .rst_n(rst_n), .colour('b010), .start(start),.centre_y(80), .centre_x(40),
								 .radius(40), .done(done), .vga_x(vga_x), .vga_y(vga_y), 
								 .vga_colour(vga_colour), . vga_plot(vga_plot));
								 



initial begin
  
  clk =0;
  forever#5 clk =~clk;

 // $display (currentState);
  //$display (vga_x);
  //$display (vga_y);
  //$display (offset_x);
  //$display (offset_y);
  //$display (crit);
	  
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
						 


endmodule: tb_syn_circle
