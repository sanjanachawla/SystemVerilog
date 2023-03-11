module init(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            output logic [7:0] addr, output logic [7:0] wrdata, output logic wren);

// your code here


typedef enum logic[4:0]{WAIT, FILL, DONE} State;
State currentState, nextState;

always_ff@(posedge clk or negedge rst_n) begin

	if(rst_n ==0) currentState <= WAIT;
	else currentState <= nextState;

end

always_comb begin
	begin case(currentState)
		WAIT: begin
				rdy = 1;
				wren = 1;
				wrdata = addr;
				if (en == 1) nextState <= FILL;
				else nextState<=WAIT;
				end
				
		FILL: begin
				rdy = 0;
				wren = 1;
				wrdata = addr;
				if(addr < 254) nextState<= FILL;
				else nextState <= DONE;
				end
				
		DONE: begin
				rdy = 1;
				wren = 0;
				wrdata = addr;
				nextState<=DONE;
				end

endcase
end
end
	
always_ff @(posedge clk) begin

	if (currentState == WAIT)begin
		addr = 0;
		end
	else if(currentState == FILL) begin
		addr = addr +1;
		end
	else if(currentState == DONE) begin
		//addr = 255;
		end
end

endmodule: init