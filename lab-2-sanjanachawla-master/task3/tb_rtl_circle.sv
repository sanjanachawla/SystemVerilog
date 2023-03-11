module tb_rtl_circle();

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
logic [7:0] tb_offset_y;
logic [7:0] tb_offset_x;
logic signed [7:0] tb_crit;

//module circle(input logic clk, input logic rst_n, input logic [2:0] colour,
//              input logic [7:0] centre_x, input logic [6:0] centre_y, input logic [7:0] radius,
//              input logic start, output logic done,
//              output logic [7:0] vga_x, output logic [6:0] vga_y,
//              output logic [2:0] vga_colour, output logic vga_plot);
						
	circle circledut(.clk(clk), .rst_n(rst_n), .colour('b010), .start(start),.centre_y(60), .centre_x(80),
									 .radius(40), .done(done), .vga_x(vga_x), .vga_y(vga_y),
									 .vga_colour(vga_colour), . vga_plot(vga_plot));


	initial begin
	  
	  clk =0;
	  forever#5 clk =~clk;
	  end
	  
	  always @(posedge clk) begin
		while (tb_offset_y < tb_offset_x) begin
			  if (tb_crit < 1) begin
            tb_crit = tb_crit + 2 * tb_offset_y + 1;
				end
        else begin
            tb_offset_x = tb_offset_x - 1;
            tb_crit = tb_crit + 2 * (tb_offset_y - tb_offset_x) + 1;
				end
				end
			
	  end
	  
	  
	 // $display (circledut.currentState);
	  //$display (circledut.vga_x);
	  //$display (circledut.vga_y);
	  //$display (circledut.offset_x);
	  //$display (circledut.offset_y);
	  //$display (circledut.crit);
	  
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
	
	
	end

//draw_circle(centre_x, centre_y, radius):
 //   tb_offset_y = 0
 //   tb_offset_x = radius
 //   tb_crit = 1 - radius
//    while (offset_y ≤ offset_x):
//        setPixel(centre_x + offset_x, centre_y + offset_y)   -- octant 1
//        setPixel(centre_x + offset_y, centre_y + offset_x)   -- octant 2
//        setPixel(centre_x - offset_x, centre_y + offset_y)   -- octant 4
//        setPixel(centre_x - offset_y, centre_y + offset_x)   -- octant 3
//        setPixel(centre_x - offset_x, centre_y - offset_y)   -- octant 5
//        setPixel(centre_x - offset_y, centre_y - offset_x)   -- octant 6
//        setPixel(centre_x + offset_x, centre_y - offset_y)   -- octant 8
//        setPixel(centre_x + offset_y, centre_y - offset_x)   -- octant 7
//        offset_y = offset_y + 1
//        if crit ≤ 0:
//            crit = crit + 2 * offset_y + 1
//        else:
//            offset_x = offset_x - 1
//            crit = crit + 2 * (offset_y - offset_x) + 1	

endmodule: tb_rtl_circle
