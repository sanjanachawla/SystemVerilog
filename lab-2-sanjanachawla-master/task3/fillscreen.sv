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
		
		
	assign vga_colour = 'b000;


endmodule
