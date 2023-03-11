module ksa(input logic clk, input logic rst_n,
           input logic en, output logic rdy,
           input logic [23:0] key,
           output logic [7:0] addr, input logic [7:0] rddata, 
			  output logic [7:0] wrdata, output logic wren);

    // your code here
	 
	 
	 typedef enum logic [4:0] {WAIT, INIT, READ_I, WAIT_I1, WAIT_I2, GET_KEY_INDEX, GET_KEY_VAL, COMP_J, READ_J, WAIT_J1, WAIT_J2, WRITE_I, WRITE_J, INC_I,DONE} State;

	State currentState, nextState;
	logic [7:0] i;
	logic [7:0] j;
	logic [7:0] orig_i;
	logic [7:0] orig_j;
	logic [7:0] key_val;
	logic [3:0] key_index;
//States
//WAIT: when either rdy/en = 0;
/*SWAP: 1. reads from rrdata
// loop: - in each loop we first get the val from rrdata. thats the
//				val in the address of i = s[i]
		  2. then we want to assign j = (j + s[i] + key[i % 3]) % 256 
		     how to we get key[i % 3]? hmm - i think you just use that 
			  to get the val of the array
		  3. then we put the value of s[i] (that is rrdata) to s[j], and s[j] into s[i]
			  To do that, we need to:
			  a. grab the value of s[j] - so:
					i. address <= j;
					ii. next clock cycle = rrdata <= s[j];
					iii. that val goes to s[i]. write s[j] to s[i]. wrdata <=rrdata;
//DONE: turn rdy to 1


		DESCRIPTIONS OF STATES:
		
		READ_I:
			address <= I;
			wren <= 1’b0;
			wait for up to two cycles
			ORIG_I <= RRDATA; 
			This reads the orig value of the mem, setting orig_i <== rddata
			
		COMP_J:
		no reading from memories here.
		j <= (j + orig_i + key[ i % 3]) % 256;
		
		READ_J:
			address <= J;
			wren <= 1’b0;
			wait for up to two cycles
			ORIG_J <= RRDATA; 
			This reads the orig value of the mem, setting orig_i <== rddata
			
		WRITE_I
			
			address <= I;
			wren <= 1’b1;
			wait for up to two cycles
			WRDATA <= ORIG_J; 
		
`		WRITE_J
			
			address <= J;
			wren <= 1’b1;
			wait for up to two cycles
			WRDATA <= ORIG_I; 

			Also increment i here, and loop back

*/

	always_ff@(posedge clk or negedge rst_n) begin
	//assigns what state to go to
		if (rst_n == 0) currentState = WAIT;
		else currentState <= nextState;
	end
	
	always_comb begin
		case (currentState)
			WAIT: begin
					rdy = 1;
					wren =1;
					//addr = i;
					if(en == 1) nextState <= READ_I;
					else nextState <= WAIT;		
					end
					
					
			//START: nextState <= FILL;
			READ_I: begin
					//if (i == 255) nextState <= DONE;
					nextState <= WAIT_I1;
					rdy = 0;
					wren = 0;
					//addr = i;
					end
					
			WAIT_I1: begin
				nextState<= WAIT_I2;
				rdy = 0;
				wren = 0;
				//addr = i;
				end
				
			WAIT_I2: begin
				nextState<= GET_KEY_INDEX;
				rdy = 0;
				wren = 0;
				//addr = i;
				end
					
			
					
			GET_KEY_INDEX: begin
			
					nextState<=GET_KEY_VAL;
					rdy = 0;
					wren = 0;
					//addr =j;
					end
					
			GET_KEY_VAL: begin
			
					nextState <= COMP_J;
					rdy = 0;
					wren = 0;
					//addr = j;
					end
					
			COMP_J: begin
					rdy =0;	
					wren = 0;
					nextState <= READ_J;
					//addr =j;
					//addr =
					end
					
			READ_J: begin
				//if (i == 255) nextState <= DONE;
				nextState <= WAIT_J1;
				rdy = 0;
				wren = 0;
				//addr = j;
				//wrdata = orig_i;
				//addr = i;
				//wrdata = i;
				end
				
			WAIT_J1: begin
				nextState<= WAIT_J2;
				rdy = 0;
				wren = 0;
				//addr = j;
				//wrdata = orig_i;
				end
				
			WAIT_J2: begin
				nextState<= WRITE_J;
				rdy = 0;
				wren = 0;
				//addr = j;
				//wrdata = orig_i;
				end
					
					
			WRITE_J: begin
					rdy =0;	
					wren = 1;
					nextState <= WRITE_I;
					//addr = j;
					//wrdata = orig_i;
					end
					
			WRITE_I: begin
					rdy =0;	
					wren = 1;
					nextState <= INC_I;
					//addr = i;
					//wrdata = orig_j;
					//else nextState <= READ_I;
					end
					
			INC_I: begin
					if (i == 255) nextState <= DONE;
					else nextState <= READ_I;
					rdy = 0;
					wren = 1;
					//addr = i;
					//wrdata = orig_j;
					end
					
			DONE: begin 
					nextState <=DONE;
					rdy = 1;
					wren = 0;
					//addr =i;
					//wrdata = orig_i;
					end
			default: nextState <= WAIT;
			endcase
	end

	always_ff@(posedge clk) begin
	// fill loop??
	
		if(currentState == WAIT) begin
			i <= 0;
			j <=0;
			addr <=0;
			wrdata <=0;
		
		end
	
		else if (currentState == READ_I) begin
			addr = i;
			//wren <= 1;
			//wait for up to two cycles delay?
			//#10;
			//orig_i<= rddata; 
			
		end
		
		else if (currentState == GET_KEY_INDEX) begin
		
		key_index <= i % 3;
		end
		
		else if (currentState == GET_KEY_VAL) begin
		
		if (key_index == 0) key_val <= key[23:16]; 
		else if (key_index == 1) key_val <= key[15:8];
		else if (key_index == 2) key_val <= key[7:0];
		
		end
		
		
		
		else if (currentState == COMP_J) begin
			j <= (j + orig_i + key_val) % 256;
		end
		
		else if (currentState == READ_J) begin
			addr =j;
			//wren <= 1;
			//wait for up to two cycles delay?
			//#10;
			//orig_j <= rddata; 
		end
		
		else if (currentState == WAIT_J2) begin
			orig_j <= rddata;
			end
			
		else if(currentState == WAIT_I2) begin
			orig_i <= rddata;
			end
		
		else if (currentState == WRITE_J) begin
			addr =j;
			//wren <= 1;
			//wait for up to two cycles delay?
			//#10;
			wrdata <= orig_i; 
		end
		
		
		else if (currentState == WRITE_I) begin
			addr =i;
			wrdata <= orig_j; 
		end
		
		else if (currentState == INC_I) begin
		i = i+1;
		end
		/*else if (currentState == DONE) begin
			rdy <=1;			
			end	*/
	end


endmodule: ksa
