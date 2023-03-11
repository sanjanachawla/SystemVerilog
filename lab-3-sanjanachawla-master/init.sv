module init(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            output logic [7:0] addr, output logic [7:0] wrdata, output logic wren);

// your code here
//


typedef enum logic [4:0] {INIT_WAIT, FILL, DONE} State;

State currentState, nextState;
logic [7:0] i;

//States
//WAIT: when either rdy/en = 0;
//Start: accept msg? turn rdy = 0;
//FILL: begin block that fills the wrdata. 
//DONE: turn rdy to 1


	always_ff@(posedge clk or negedge rst_n) begin
	//assigns what state to go to
		if (rst_n == 0) currentState = INIT_WAIT;
		else currentState <= nextState;
	end
	
	always_comb begin
		case (currentState)
			INIT_WAIT: begin
					rdy = 1;
					wren =1;
					if(en == 1) nextState <= FILL;
					else nextState <= INIT_WAIT;		
					end
					
					
			//START: nextState <= FILL;
			FILL: begin
					if (i == 255) nextState <= DONE;
					else nextState <= FILL;
					rdy = 0;
					wren = 1;
					//wrdata = i;
					end
					
			DONE: begin
					rdy <=1;	
					wren = 0;
					nextState <= DONE;
					end
			endcase
	
	end


	always_ff@(posedge clk) begin
	// fill loop??
	
		if(currentState == INIT_WAIT) begin
			i <= 0;
			addr <=0;
			wrdata <=0;
		
		end
	
		else if (currentState == FILL) begin
			wrdata <= i+1;
			i = i+1;
			addr = addr +1;
		end
		
		/*else if (currentState == DONE) begin
			rdy <=1;			
			end	*/
	end

endmodule: init