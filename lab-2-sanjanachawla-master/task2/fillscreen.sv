module fillscreen(input logic clk, input logic rst_n, input logic [2:0] colour,
                  input logic start, output logic done,
                  output logic [7:0] vga_x, output logic [6:0] vga_y,
                  output logic [2:0] vga_colour, output logic vga_plot);
     
	//always @(posedge clk)

//logic [7:0] x;
//logic [7:0] y;
logic incx;
logic done_y;
logic done_x;
//logic done_y;

//ok so the FSM didnt work, try completely with gates: 2 sequential in series, 
// then a combinational to assign the vals?


always_ff @(posedge clk or negedge rst_n) begin
	if (rst_n == 0) begin
		vga_y<=0;
		incx<=0;
		//done <=0;
	end else if (done == 0) begin
		if (vga_y < 119) begin
			vga_y <= vga_y+1;
			incx <= 0;
			//done <=0;
			//done_y <=0;
			end
			
		else begin
			
			incx <=1;
			vga_y <= 0;
			done_y = 1;
			//done <=0;
			end
	end
	else //(rst_n ==1) and (done ==1)
		incx <= 1;
		//done = 1;
end
		
always_ff @(posedge incx or negedge rst_n) begin

	if(rst_n == 0) begin
		vga_x<=0;
		done_x<=0;
		done <= 0;
		
	end else if(done_x == 0) begin
		if (vga_x < 159) begin
			done_x <= 0;
			vga_x <= vga_x +1;
			done <=0;
			//incx <=0;
		end 
		else begin //if vga_x == 159
			done_x <=1;
			
			//incx<=0;
			//done<=1;
			//done_temp = 1;
		end
	end else if (done_x ==1) begin 
		//done <= done_x && done_y;
		vga_x <= vga_x;
		done = 1;
	end
		
	end

always_comb begin

	if (start == 1) begin 
			vga_plot = 1;
			end
	else begin
			vga_plot =0;
		
	end
	//else begin
		//vga_plot <= 0;
		//end
	end
		
		
	//assign done = done_x && done_y;
	//assign vga_x = x;
	//assign vga_y = y;
	assign vga_colour = (vga_x % 8);
	
	//assign done = done_x && done_y;



//try doing it with fsm!
//typedef enum logic [4:0] {START,INITX,INITY,INCY,INCX,DONE} State;
//State currentState, nextState;

//always @(posedge clk or negedge rstn)
 
//	begin
//	 if(rstn == 0) currentState<=START;
//	 else
//			currentState <= nextState;

//	end
			

//always_comb
//	case(currentState)
//	
//	START : nextState<=INITX;
	
//	INITX : nextState <= INITY;
	
//	INITY : nextState <= INCY;
	
//	INCY : if(y < 120) nextState <= INCY;
//			 else nextState <=INCX;
				
//	INCX : if (x < 160) nextState<= INITY;
//			 else nextState <= DONE;
				
//	default: nextState<=START;
	
//	endcase
				
	
//	assign (x=0) = currentState == INITX;
//	assign (y=0) = currentState == INITY;
//	assign (x++) = currentState == INCX;
//	assign (y++) = currentState == INCY;
//	assign done = currentState == DONE;
//	assign vga_plot = currentState == DONE;
	
	
//	assign vga_x = x;
//	assign vga_y = y;
//	assign vga_color = (x % 8 );
	

//logic [2:0] vga_colour;
//maybe try turning into a state machine instead?
//Sequential: For Loop? 
//Combinational --> assigning the states
	  
//	always @(posedge clk or negedge rst_n) begin
//		if (rst_n == 0) begin
//			y <= 0;
//			x <=0;
//			done <=0;
      	//start<=0;
//			end
//		else begin	
//			for(x = 0; x<159; x = x+1) begin
//				for(y = 0;  y< 119; y= y+1) begin
//					
//					//set the variables that will be used in the VGA_adapter
//					//vga_y =y;
///					//vga_plot =1;
//						
//				end
//				//vga_x = x;
//				//vga_colour = (x % 8);
//			end	
//		
//			done = 1;
//		
//		end
//	end
	
//	always_comb begin
//		if(start) begin
//			if(done) begin
//				vga_plot = 0;
//				vga_x <= x;
//				vga_y <= y;
//			end else begin
//				vga_plot = 1;
//				vga_x <= x;
//				vga_y <= y;
//				end
//		end else begin
//			vga_plot = 0;
//			vga_x <= x;
//			vga_y <= y;
//			end
//	end

endmodule

