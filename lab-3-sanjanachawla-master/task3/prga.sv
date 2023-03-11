module prga(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] s_addr, input logic [7:0] s_rddata, output logic [7:0] s_wrdata, output logic s_wren,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);

    // your code here
/*	 
	 s_addr = 0;
	 s_wrdata = 0;
	 s_wren = 0;
	 ct_addr = 0;
	 pt_addr = 0;
	 pr_wrdata = 0;
	 pt_wren = 0;
	 
*/	
	typedef enum logic [4:0] {WAIT, INIT, GML, WAIT_GML1,WAIT_GML2, 
									  INC_I,  WAIT_SI1, WAIT_SI2, READ_SI,
									  COMP_J, WAIT_SJ1, WAIT_SJ2,  READ_SJ,
									  WRITE_SI_TO_J, WRITE_SJ_TO_I, COMP_S_INDEX, 
									  WAIT_S_IND1, WAIT_S_IND2, READ_S_INDEX,
									  WWAIT_CTK1, WAIT_CTK2, READ_CTK,
									  GET_PT_WRDATA, WRITE_PT_WRDATA,WRITE_MSG_LEN, 
									  WAIT_CTK1,
									   DONE} State;

	State currentState, nextState;
	logic [7:0] i;
	logic [7:0] j;
	logic [7:0] k;
	logic [7:0] orig_si;
	logic [7:0] orig_sj;
	logic [7:0] s_index_val;
	logic [3:0] s_index;
	logic [7:0] msg_len;
	logic [7:0] ptwrdata;
	logic [7:0] ct_k;
	logic [7:0] pad_k;
	
	
	
 always_ff@(posedge clk or negedge rst_n) begin
		if (rst_n == 0) currentState = WAIT;
		else currentState <= nextState;
	end
	
	always_comb begin
		case (currentState)
			WAIT: begin
					rdy = 1;
					 s_addr = 0;
					 s_wrdata = 0;
					 s_wren = 0;
					 ct_addr = 0;
					 pt_addr = 0;
					 pt_wrdata = 0;
					 pt_wren = 0;
					if(en == 1) begin
						nextState <= INIT;
						end
					else begin
						nextState <= WAIT;	
							end
					end
					
			INIT: begin
			
					//outputs
					rdy = 0;
					s_addr = i;
					s_wrdata = 0;
					s_wren = 0;
					ct_addr = 0;
					pt_addr = 0;
					pt_wrdata = 0;
					pt_wren = 0;
					
					//internal variables
					//msg_len = ct_rddata;
					//orig_si = 0;
					//orig_sj = 0;
					//s_index = 0;
					//s_index_val = 0;
					
					//assign i,j,k, CT_I = 0;in sequential? or in wait?
					nextState <= WAIT_GML1;
					end
			WAIT_GML1: begin
					 rdy = 0;
					 s_addr = i;
					 s_wrdata = 0;
					 s_wren = 0;
					 ct_addr = 0;
					 pt_addr = 0;
					 pt_wrdata = 0;
					 pt_wren = 0;
	

					//internal variables
					//msg_len = ct_rddata;
				/*	orig_si = 0;
					orig_sj = 0;
					s_index = 0;
					s_index_val = 0;	
					*/ 
					 
					 nextState<= WAIT_GML2;
						  //assign addr to CT_I = 0;
						  end
			WAIT_GML2: begin
					rdy = 0;
					 s_addr = i;
					 s_wrdata = 0;
					 s_wren = 0;
					 ct_addr = 0;
					 pt_addr = 0;
					 pt_wrdata = 0;
					 pt_wren = 0;
					 
					 //internal variables
					//msg_len = ct_rddata;
					/*orig_si = 0;
					orig_sj = 0;
					s_index = 0;
					s_index_val = 0;
					 */
						  nextState <= GML;
						  end
			GML: begin
				  rdy = 0;
					 s_addr = i;
					 s_wrdata = 0;
					 s_wren = 0;
					 ct_addr = 0;
					 pt_addr = 0;
					 pt_wrdata = 0;
					 pt_wren = 0;
					 
						//internal variables
					//msg_len = ct_rddata;
					/*orig_si = 0;
					orig_sj = 0;
					s_index = 0;
					s_index_val = 0;
					*/ 
				 //read the first val of CT. assign that as msg_len
				 //if(k == msg_len - 1)  nextState <= XOR;
				   nextState <= INC_I;
					end
				 
			INC_I: begin
					rdy = 0;
					 s_addr = i;
					 s_wrdata = 0;
					 s_wren = 0;
					 ct_addr = 0;
					 pt_addr = 0;
					 pt_wrdata = 0;
					 pt_wren = 0;
					//inc i in sequential;
					
					//internal variables
					//msg_len = ct_rddata;
					/*orig_si = s_rddata;
					orig_sj = 0;
					s_index = 0;
					s_index_val = 0;
*/
					
					nextState <= WAIT_SI1;
					end
			WAIT_SI1: begin
					rdy = 0;
					 s_addr = i;
					 s_wrdata = 0;
					 s_wren = 0;
					 ct_addr = 0;
					 pt_addr = 0;
					 pt_wrdata = 0;
					 pt_wren = 0;

						 nextState <= WAIT_SI2;
						 //assign addr to i
						 end
			WAIT_SI2: begin
						 rdy = 0;
					 s_addr = i;
					 s_wrdata = 0;
					 s_wren = 0;
					 ct_addr = 0;
					 pt_addr = 0;
					 pt_wrdata = 0;
					 pt_wren = 0;
					 
					 
					 //internal variables
					//msg_len = ct_rddata;
					/*orig_si = s_rddata;
					orig_sj = 0;
					s_index = 0;
					s_index_val = 0;
					*/ 
						 nextState <= READ_SI;
						 end
			READ_SI: begin
						rdy = 0;
					 s_addr = i;
					 s_wrdata = 0;
					 s_wren = 0;
					 ct_addr = 0;
					 pt_addr = 0;
					 pt_wrdata = 0;
					 pt_wren = 0;
					 //msg_len = ct_rddata;
						//assgign orig_si to q
						nextState <= COMP_J;
						end
			COMP_J: begin
					 rdy = 0;
					 s_addr = i;
					 s_wrdata = 0;
					 s_wren = 0;
					 ct_addr = 0;
					 pt_addr = 0;
					 pt_wrdata = 0;
					 pt_wren = 0;
					 //msg_len = ct_rddata;
						//compute j from formula
						nextState <= WAIT_SJ1;
						end
			WAIT_SJ1: begin
						rdy = 0;
						 s_addr = j;
					 s_wrdata = 0;
					 s_wren = 0;
					 ct_addr = 0;
					 pt_addr = 0;
					 pt_wrdata = 0;
					 pt_wren = 0;
					 //msg_len = ct_rddata;
						//assign addr to j;
						nextState <= WAIT_SJ2;
						end
			WAIT_SJ2: begin
						rdy = 0;
					 s_addr = j;
					 s_wrdata = 0;
					 s_wren = 0;
					 ct_addr = 0;
					 pt_addr = 0;
					 pt_wrdata = 0;
					 pt_wren = 0;
					 //msg_len = ct_rddata;
						nextState <= READ_SJ;
						end
			READ_SJ: begin
						rdy = 0;
					 s_addr = j;
					 s_wrdata = 0;
					 s_wren = 0;
					 ct_addr = 0;
					 pt_addr = 0;
					 pt_wrdata = 0;
					 pt_wren = 0;
					 //msg_len = ct_rddata;
						//assign orig_sj to q;
						nextState <= WRITE_SI_TO_J;
						end
			WRITE_SI_TO_J: begin
								rdy = 0;
					 s_addr = j;
					 s_wrdata = orig_si;
					 s_wren = 1;
					 ct_addr = 0;
					 pt_addr = 0;
					 pt_wrdata = 0;
					 pt_wren = 0;
					 //msg_len = ct_rddata;
								//addr is still j;
								//wrdata = orig_si;
								nextState<=WRITE_SJ_TO_I;
								end
			WRITE_SJ_TO_I: begin
								rdy = 0;
					 s_addr = i;
					 s_wrdata = orig_sj;
					 s_wren = 1;
					 ct_addr = 0;
					 pt_addr = 0;
					 pt_wrdata = 0;
					 pt_wren = 0;
					 //msg_len = ct_rddata;
								//change addr to i;
								//wrdata = orig_sj
								//
					nextState <= COMP_S_INDEX;
								
								end
			COMP_S_INDEX: begin
							  rdy = 0;
					 s_addr = j;
					 s_wrdata = 0;
					 s_wren = 0;
					 ct_addr = 0;
					 pt_addr = 0;
					 pt_wrdata = 0;
					 pt_wren = 0;
					// msg_len = ct_rddata;
							  //get s_ind by s_index = (orig_si + orig_sj) % 256;
							  nextState <= WAIT_S_IND1;
							  end
			WAIT_S_IND1: begin
			
					 rdy = 0;
					 s_addr = s_index;
					 s_wrdata = 0;
					 s_wren = 0;
					 ct_addr = 0;
					 pt_addr = 0;
					 pt_wrdata = 0;
					 pt_wren = 0;
					 //msg_len = ct_rddata;
							  nextState <=WAIT_S_IND2;
							  end
			WAIT_S_IND2: begin
					 rdy = 0;
					 s_addr = s_index;
					 s_wrdata = 0;
					 s_wren = 0;
					 ct_addr = 0;
					 pt_addr = 0;
					 pt_wrdata = 0;
					 pt_wren = 0;
					 //msg_len = ct_rddata;
					nextState <= READ_S_INDEX;
					end
			READ_S_INDEX: begin
					 rdy = 0;
					 s_addr = s_index;
					 s_wrdata = 0;
					 s_wren = 0;
					 ct_addr = 0;
					 pt_addr = 0;
					 pt_wrdata = 0;
					 pt_wren = 0;
					 //msg_len = ct_rddata;
					
				
						if(k == 0) nextState = WRITE_MSG_LEN;
						else nextState = READ_CTK;
						end

			WAIT_CTK1: begin
					rdy =0;
					s_addr = 0;
					 s_wrdata = 0;
					 s_wren = 0;
					 ct_addr = k;
					 pt_addr = k;
					 pt_wrdata = 0;
					 pt_wren = 0;
					// msg_len = ct_rddata;
					 
					nextState = WAIT_CTK2;
						end	
					
		WAIT_CTK2: begin
					rdy =0;
					s_addr = 0;
					 s_wrdata = 0;
					 s_wren = 0;
					 ct_addr = k;
					 pt_addr = k;
					 pt_wrdata = 0;
					 pt_wren = 0;
					// msg_len = ct_rddata;
					 
					nextState = READ_CTK;
						end	
			READ_CTK: begin
					rdy =0;
					s_addr = 0;
					 s_wrdata = 0;
					 s_wren = 0;
					 ct_addr = k;
					 pt_addr = k;
					 pt_wrdata = 0;
					 pt_wren = 0;
					// msg_len = ct_rddata;
					 
					nextState = GET_PT_WRDATA;
						end	
			GET_PT_WRDATA: begin
							
					rdy =0;
					 s_addr = 0;
					 s_wrdata = 0;
					 s_wren = 0;
					 ct_addr = k;
					 pt_addr = k;
					 pt_wrdata = 0;
					 pt_wren = 0;
					nextState<=WRITE_PT_WRDATA;
					end
					
			WRITE_PT_WRDATA: begin
					rdy =0;
					 s_addr = 0;
					 s_wrdata = 0;
					 s_wren = 0;
					 ct_addr = k;
					 pt_addr = k;
					 pt_wrdata = ptwrdata;
					 pt_wren = 1;
					if(k==msg_len - 1) nextState<=DONE;
					else nextState = INC_I;
					end
					
			WRITE_MSG_LEN: begin
				rdy =0;
				s_addr = 0;
				s_wrdata = 0;
				s_wren = 0;
				ct_addr = k;
				pt_addr = k;
				pt_wrdata = msg_len;
				pt_wren = 1;
				nextState <= INC_I;
			
			
			end
			
			DONE: begin
				rdy =1;
				s_addr = 0;
				s_wrdata = 0;
				s_wren = 0;
				ct_addr = 0;
				pt_addr = 0;
				pt_wrdata = 0;
				pt_wren = 0;
				nextState <= DONE;
			
			end
						
			default: nextState <=INIT;
			endcase
			
			
			end 
	
	always_ff @(posedge clk) begin
	
		//here we just want to increment the things that we need to
		//only the stuff that depends on its prev value
		if(currentState == INIT) begin
		 i = 0;
		 j = 0;
		 k = 0;
		end
		
		else if (currentState == WAIT_GML1) begin
			msg_len <= ct_rddata;
		end
		
		else if (currentState == WAIT_GML2) begin
			msg_len <= ct_rddata;
		end
		
		else if (currentState == GML) begin
			msg_len <= ct_rddata;
		end
		
		else if (currentState == INC_I) begin
			i = (i+1) % 256;
			end
		else if(currentState == COMP_J) begin
			j = (j + orig_si) % 256;
			end
			
		else if (currentState == WAIT_SI1) begin
			orig_si = s_rddata;
			end
		else if (currentState == WAIT_SI2) begin
			orig_si = s_rddata;
			end
		else if (currentState == READ_SI) begin
			orig_si = s_rddata;
			end
		else if (currentState == WAIT_SJ1) begin
			orig_sj = s_rddata;
			end
		else if (currentState == WAIT_SJ2) begin
			orig_sj = s_rddata;
			end
		else if (currentState == READ_SJ) begin
			orig_sj = s_rddata;
			end
			
		else if(currentState == COMP_S_INDEX) begin
			s_index = (orig_si +orig_sj) %256;
			end
		else if(currentState == WAIT_S_IND1) begin
			pad_k = s_rddata;
			end
			
		else if(currentState == WAIT_S_IND2) begin
			pad_k = s_rddata;
			end
		else if(currentState == READ_S_INDEX) begin
			//s_index_val = s_rddata;
			pad_k =s_rddata;
			end
			
		else if(currentState == WAIT_CTK1) begin
			ct_k = ct_rddata;
			end
		else if(currentState == WAIT_CTK2) begin
			ct_k = ct_rddata;
			end
		else if(currentState == READ_CTK) begin
			ct_k = ct_rddata;
			end
			
		else if(currentState == GET_PT_WRDATA) begin
			ptwrdata = ct_k ^ pad_k;
			//frick this is actually harder than i thought :(
		end
		else if(currentState == WRITE_MSG_LEN) begin
			k = k+1;
		end
		
		else if(currentState == WRITE_PT_WRDATA) begin
			 k = k+1;
		end		
		end	
						
	
endmodule: prga

						
		/*	WRITE_TO_PAD: begin
								rdy = 0;
								 s_addr = 0;
								 s_wrdata = 0;
								 s_wren = 0;
								 ct_addr = 0;
								 pt_addr = 0;
								 pt_wrdata = 0;
								 pt_wren = 1;
								 //pad_k = s_index_val;
								 //inc k 
								 //msg_len = ct_rddata;
					 if (k == 0) nextState = WRITE_MSG_LEN;
					 else nextState <= READ_CTK;
					 end
					*/ 
						
					
