module task3(input logic CLOCK_50, input logic [3:0] KEY,
             input logic [9:0] SW, output logic [9:0] LEDR,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [7:0] VGA_R, output logic [7:0] VGA_G, output logic [7:0] VGA_B,
             output logic VGA_HS, output logic VGA_VS, output logic VGA_CLK,
             output logic [7:0] VGA_X, output logic [6:0] VGA_Y,
             output logic [2:0] VGA_COLOUR, output logic VGA_PLOT);

    // instantiate and connect the VGA adapter and your module
	 
//	 module circle(input logic clk, input logic rst_n, input logic [2:0] colour,
//              input logic [7:0] centre_x, input logic [6:0] centre_y, input logic [7:0] radius,
//             input logic start, output logic done,
//              output logic [7:0] vga_x, output logic [6:0] vga_y,
//              output logic [2:0] vga_colour, output logic vga_plot);

logic [9:0] VGA_R_10;
logic [9:0] VGA_G_10;
logic [9:0] VGA_B_10;
logic VGA_BLANK, VGA_SYNC;
logic[2:0] color;
logic done_blackscreen;
logic done_circle;
logic VGA_PLOT1;
logic VGA_PLOT2;
logic [7:0] VGA_X1;
logic [7:0] VGA_Y1;
logic [7:0] VGA_X2;
logic [7:0] VGA_Y2;
logic [2:0] VGA_COLOUR1;
logic [2:0] VGA_COLOUR2;


//logic [9:0] VGA_R_10;
//logic [9:0] VGA_G_10;
//logic [9:0] VGA_B_10;


assign VGA_R = VGA_R_10[9:2];
assign VGA_G = VGA_G_10[9:2];
assign VGA_B = VGA_B_10[9:2];


always_comb begin
	if (done_blackscreen == 0) begin
		VGA_X <= VGA_X1;
		end
		else VGA_X = VGA_X2;
		end

always_comb begin
if (done_blackscreen == 0) begin
		VGA_Y <= VGA_Y1;
		end
		else
		VGA_Y = VGA_Y2;
	end

always_comb begin
	if (done_blackscreen == 0) VGA_COLOUR <= VGA_COLOUR1;
	else VGA_COLOUR = VGA_COLOUR2;
 end

//module fillscreen(input logic clk, input logic rst_n, input logic [2:0] colour,
//                  input logic start, output logic done,
//                  output logic [7:0] vga_x, output logic [6:0] vga_y,
//                  output logic [2:0] vga_colour, output logic vga_plot);

	fillscreen blackscreen(.clk(CLOCK_50), .rst_n(KEY[3]), .colour('b000), .start(KEY[0]), 
									.done(done_blackscreen),.vga_x(VGA_X1),.vga_y(VGA_Y1),.vga_colour(VGA_COLOUR1),
									.vga_plot(VGA_PLOT1));
	 
	circle greencircle(.clk(CLOCK_50), .rst_n(KEY[3]), .colour ('b010),
							 .centre_x(80), .centre_y(60), .radius(40),.start(done_blackscreen), .done(done_circle),
							 .vga_x(VGA_X2), .vga_y(VGA_Y2), .vga_colour(VGA_COLOUR2),
							 .vga_plot(VGA_PLOT2));
							 
	vga_adapter#(.RESOLUTION("160x120")) vga_u(.resetn(KEY[3]), .clock(CLOCK_50), .colour(VGA_COLOUR),
                                            .x(VGA_X), .y(VGA_Y), .plot(VGA_PLOT),
                                            .VGA_R(VGA_R_10), .VGA_G(VGA_G_10), .VGA_B(VGA_B_10), .*);
							 
	assign VGA_PLOT = VGA_PLOT1 || VGA_PLOT2;
	//assign done_blackscreen = LEDR[0];
	//assign done_circle = LEDR[1];

endmodule: task3
