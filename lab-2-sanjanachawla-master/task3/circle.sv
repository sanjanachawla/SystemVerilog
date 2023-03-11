module circle(input logic clk, input logic rst_n, input logic [2:0] colour,
              input logic [7:0] centre_x, input logic [6:0] centre_y, input logic [7:0] radius,
              input logic start, output logic done,
              output logic [7:0] vga_x, output logic [6:0] vga_y,
              output logic [2:0] vga_colour, output logic vga_plot);
 

typedef enum logic [4:0] {NO_START,INIT,OCT1,OCT2,OCT3,OCT4,OCT5,OCT6,OCT7,OCT8,INC_OFF_Y,COND1_CRIT,COND2_INC_x_CRIT, DONE} State;

State currentState, nextState;

logic [7:0] offset_y;
logic [7:0] offset_x;
logic signed [7:0] crit;
	
always @(posedge clk or negedge rst_n)
	begin
//	if(start == 0) begin
//		currentState <= NO_START;
//		end 
	if (rst_n == 0) begin
	  currentState<= NO_START;
		end 
	else begin
		currentState <= nextState;
		end
	end
	  
always_comb begin

	case(currentState)
		NO_START:if (start == 1) nextState = INIT;
					else nextState = NO_START;
		INIT: nextState = OCT1;
		OCT1: nextState = OCT2;
		OCT2: nextState = OCT4;
		OCT4: nextState = OCT3;
		OCT3: nextState = OCT5;
		OCT5: nextState = OCT6;
		OCT6: nextState = OCT8;
		OCT8: nextState = OCT7;
		OCT7: nextState = INC_OFF_Y;
		INC_OFF_Y: if (crit < 1) nextState = COND1_CRIT;
						else nextState = COND2_INC_x_CRIT;
		COND1_CRIT: if(offset_y < offset_x) nextState = OCT1;
						else nextState = DONE;
		COND2_INC_x_CRIT: if(offset_y < offset_x) nextState = OCT1;
								else nextState = DONE;
								
		DONE: nextState = DONE;
		default: nextState = INIT;
		endcase
		
	vga_colour = colour;
	if(start == 1) vga_plot = 1;
	else vga_plot = 0;
	
	end
	
always @(posedge clk) begin
	if(currentState == INIT) begin
		offset_y =0;
		offset_x = radius;
		crit = 1 - radius;
		done = 0;
		//vga_x = centre_x;
//		vga_y = centre_y;
//		vga_colour = colour;
		end
	else if (currentState == OCT1) begin
		vga_x <= centre_x + offset_x;//setPixel(centre_x + offset_x, centre_y + offset_y)   -- octant 1
		vga_y <= centre_y + offset_y;
		//set that pixel to vga addapter?
		//instantiate VGA_x, VGA_Y to xcoord and ycoord
//		vga_colour = colour;
		done = 0;
		end
		
	else if (currentState == OCT2) begin
		vga_x <= centre_x + offset_y;//setPixel(centre_x + offset_y, centre_y + offset_x)   -- octant 2
		vga_y <= centre_y + offset_x;
//		vga_colour = colour;
		done = 0;
		end
		
	else if (currentState == OCT4) begin
		vga_x <= centre_x - offset_x;//setPixel(centre_x - offset_x, centre_y + offset_y)   -- octant 4
		vga_y <= centre_y + offset_y;
//		vga_colour = colour;
		done = 0;
		end
	else if (currentState == OCT3) begin
		vga_x <= centre_x - offset_y;//setPixel(centre_x - offset_y, centre_y + offset_x)   -- octant 3
		vga_y <= centre_y + offset_x;
//		vga_colour = colour;
		done = 0;
		end
		
	else if (currentState == OCT5) begin
		vga_x <= centre_x - offset_x;//setPixel(centre_x - offset_x, centre_y - offset_y)   -- octant 5
		vga_y <= centre_y - offset_y;
//		vga_colour = colour;
		done = 0;
		end
		
	else if (currentState == OCT6) begin
		vga_x <= centre_x - offset_y;//setPixel(centre_x - offset_y, centre_y - offset_x)   -- octant 6
		vga_y <= centre_y - offset_x;
//		vga_colour = colour;
		done = 0;
		end
	else if (currentState == OCT8) begin
		vga_x <= centre_x + offset_x;//setPixel(centre_x + offset_x, centre_y - offset_y)   -- octant 8
		vga_y <= centre_y - offset_y;
//		vga_colour = colour;
		done = 0;
		end
		
	else if (currentState == OCT7) begin
		vga_x = centre_x + offset_y;//setPixel(centre_x + offset_y, centre_y - offset_x)   -- octant 7
		vga_y = centre_y - offset_x;
//		vga_colour = colour;
		done = 0;
		end
		
	else if (currentState == INC_OFF_Y) begin
		offset_y <= offset_y +1;
//		vga_colour = colour;
		done = 0;
		end
	else if (currentState == COND1_CRIT) begin
		crit <= crit + 2 * offset_y + 1;
//		vga_colour = colour;
		done = 0;
		end
	else if(currentState == COND2_INC_x_CRIT) begin
		crit <= crit + 2 * (offset_y - offset_x) + 1;
		offset_x <= offset_x - 1;
		//vga_colour = colour;
		done = 0;
		end
	else if(currentState == DONE) begin
		//vga_colour = colour;
		done <= 1;
		end
	//else begin
	//	vga_x = centre_x;
	//	vga_y = centre_y;
	//	end

end
endmodule

    // draw the circle
	  
//	 draw_circle(centre_x, centre_y, radius):
//    offset_y = 0
//    offset_x = radius
//    crit = 1 - radius
//    while offset_y ≤ offset_x:
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



