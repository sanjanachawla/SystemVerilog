module task2(input logic CLOCK_50, input logic [3:0] KEY,
             input logic [9:0] SW, output logic [9:0] LEDR,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [7:0] VGA_R, output logic [7:0] VGA_G, output logic [7:0] VGA_B,
             output logic VGA_HS, output logic VGA_VS, output logic VGA_CLK,
             output logic [7:0] VGA_X, output logic [6:0] VGA_Y,
             output logic [2:0] VGA_COLOUR, output logic VGA_PLOT);

    // instantiate and connect the VGA adapter and your module
	 
//logic[7:0] x;
//logic[7:0] y;

//logic[7:0] VGA_X;
//logic[7:0] VGA_Y;

logic [9:0] VGA_R_10;
logic [9:0] VGA_G_10;
logic [9:0] VGA_B_10;
logic VGA_BLANK, VGA_SYNC;
logic[2:0] color;

//logic [9:0] VGA_R_10;
//logic [9:0] VGA_G_10;
//logic [9:0] VGA_B_10;


assign VGA_R = VGA_R_10[9:2];
assign VGA_G = VGA_G_10[9:2];
assign VGA_B = VGA_B_10[9:2];

//assign VGA_X = {3'b0,SW[4:0]};
//assign VGA_Y = {2'b0,SW[9:5]};
//assign VGA_PLOT = ~KEY[0];
//assign VGA_COLOUR = SW[2:0];

		
//assign color = 1;

fillscreen fillthescreen(.clk(CLOCK_50), .rst_n(KEY[3]), 
									 .start(KEY[0]), .done(done), .vga_x(VGA_X), 
									 .vga_y(VGA_Y), .vga_colour(VGA_COLOUR),
									 .vga_plot(VGA_PLOT));
									 
									 
									 
	 

vga_adapter#(.RESOLUTION("160x120")) vga_u(.resetn(KEY[3]), .clock(CLOCK_50), .colour(VGA_COLOUR),
                                            .x(VGA_X), .y(VGA_Y), .plot(VGA_PLOT),
                                            .VGA_R(VGA_R_10), .VGA_G(VGA_G_10), .VGA_B(VGA_B_10), .*);
                                  

	 
//assign VGA_PLOT = vga_plot;
assign LEDR = done;			
//assign VGA_X = vga_x;
//assign VGA_Y = vga_y;
//assign VGA_COLOUR = vga_color;


endmodule: task2
