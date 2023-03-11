module dnn(input logic clk, input logic rst_n,
           // slave (CPU-facing)
           output logic slave_waitrequest,
           input logic [3:0] slave_address,
           input logic slave_read, output logic [31:0] slave_readdata,
           input logic slave_write, input logic [31:0] slave_writedata,
           // master (SDRAM-facing)
           input logic master_waitrequest,
           output logic [31:0] master_address,
           output logic master_read, input logic [31:0] master_readdata, input logic master_readdatavalid,
           output logic master_write, output logic [31:0] master_writedata);
	 
	 
			 logic written_0_flag; // 0
			 logic [31:0] bias_vector_address; //1
			 logic [31:0] w_address; //2
			 logic [31:0] ifmap_address_new;//3
			 logic [31:0] ofmap_address;//4
			 logic [31:0] vect_len_new;//5
			 logic [31:0] vect_len_old;
			 logic [31:0] ifmap_address_old;
			 logic use_relu; //7
			 
			 
			 logic signed [31:0] bias_vector;
			 logic signed [31:0] sum_temp;
			 logic signed [63:0] sum_add;
			 logic signed [31:0] w_wo_plus_i;
			 logic signed [31:0] in_a;
			 logic [64:0] i;
			 logic signed [31:0] ram_wrdata;
			 logic signed [31:0] ram_rddata;
			 logic [9:0] ram_addr;
			 logic ram_wren;
			 logic [3:0] num_wait;
			 logic use_ram;
			 
			 RAM1 ram(
					 .address(ram_addr),
					 .clock(clk),
					 .data(ram_wrdata),
					 .wren(ram_wren),
					 .q(ram_rddata));
 
    typedef enum logic [4:0] {INIT,INFO, GET_B_FROM_MASTER, GET_W_FROM_MASTER,
										GET_A_SDRAM, GET_A_ONCHIP, COMPUTE_MUL, CHECKSAT, ADD_SHIFT,
										CHOP, INC_VALS, RELU, WRITE_SUM} State; //need states for interacting with the cpu?
    
	 State currentState, nextState;
	 
	 always@(posedge clk or negedge rst_n) begin
			if (rst_n == 0) currentState = INIT;
			else currentState <= nextState;
	  end
	 
	 always_ff@(posedge clk) begin //for temporary values that need updating
	 
	 case(currentState)
			
			 INIT: begin
					 bias_vector_address = 0;
					 w_address<= 0;
					 ifmap_address_new <= 0;
					 ofmap_address <= 0;
					 vect_len_new<= 0;
					 use_relu <= 0;
					 written_0_flag <= 0;
					 i <=0;
					 sum_temp<=0;
					 bias_vector <=0;
					  w_wo_plus_i<=0;
					  sum_add<=0;
					  use_ram = 0;
					  num_wait = 0;
					  ifmap_address_old<=0;
					  vect_len_old <= 0;
					  
					 end
	 
			 INFO: begin
					 if(slave_write ==1) begin
						if (slave_address == 1) bias_vector_address <= slave_writedata;
						else if (slave_address == 2) w_address<= slave_writedata;
						else if (slave_address == 3) ifmap_address_new <= slave_writedata;
						else if (slave_address == 4) ofmap_address <= slave_writedata;
						else if (slave_address == 5) vect_len_new<= slave_writedata;
						else if (slave_address == 7) use_relu <= slave_writedata;
						else if (slave_address == 0) written_0_flag <= 1;
						end
						i <= 0;
						if(ifmap_address_new == ifmap_address_old && vect_len_new == vect_len_old) use_ram <=1;
						else use_ram <=0;
					 end
				
  GET_B_FROM_MASTER: begin
	  					   if ( master_readdatavalid) begin 
								 bias_vector <= master_readdata;	
								 sum_temp <= master_readdata;	 
							end
							end
							
							
  GET_W_FROM_MASTER: begin
							if ( master_readdatavalid) w_wo_plus_i <= master_readdata;
							num_wait<=0;
	   					end
							
    GET_A_SDRAM: begin
							if (master_readdatavalid) begin 
								in_a <= master_readdata;	
								//ram_wrdata <= master_readdata;
								//ram_address <= i;
								//ram_wren <=1;
								ifmap_address_old<=ifmap_address_new;
								vect_len_old<=vect_len_new;
							end 
							end
							
		GET_A_ONCHIP: begin
							in_a <= ram_rddata;
							num_wait<= num_wait +1;
							end
							
		  COMPUTE_MUL: begin
							sum_add = (w_wo_plus_i *in_a);
							num_wait = 0;
							end
			
			CHECKSAT:begin
					   //
						end
						
			ADD_SHIFT: sum_add = ((sum_add + 'h8000)>>>16);
			
			CHOP: sum_add = sum_add[31:0];
			
			INC_VALS: begin
						  i = i+1;
						  sum_temp <= sum_temp + sum_add;
						 end
						 
			RELU: if (use_relu) sum_temp <= (sum_temp < 0) ? 0 : sum_temp;
			
			WRITE_SUM: begin
						  written_0_flag <= 0; //done
						  //num_wait = 0;
						  end
			endcase
	      end
	 
	 	  always_comb begin//misses info state
	  
			case(currentState) 
			
			INIT: begin
					slave_waitrequest = 0;
					master_address = 0;
					master_read = 0;
					master_write = 0;
					master_writedata = 0;
					nextState<=INFO;
					ram_addr=0;
					ram_wren =0;
					ram_wrdata = 0;
					end
	
			INFO: begin
					//obtain the info from the slave interface
					slave_waitrequest = 0;
					master_address = bias_vector_address;
					master_read = 0;
					master_write = 0;
					master_writedata = 0;
					ram_addr=0;
					ram_wren =0;
					ram_wrdata = 0;
					
					if(written_0_flag) nextState <= GET_B_FROM_MASTER;
					else nextState <= INFO;
					end
					
	GET_B_FROM_MASTER: begin
							 slave_waitrequest = 1;
							 master_address = bias_vector_address;
							 master_read = 1;
							 master_write = 0;
							 master_writedata = 0;
							 ram_addr=0;
						    ram_wren =0;
							 ram_wrdata = 0;
							 if(master_waitrequest == 0) begin
							   	if(master_readdatavalid) nextState <= GET_W_FROM_MASTER;
								   else nextState<=GET_B_FROM_MASTER;
							      end
							 else nextState<= GET_B_FROM_MASTER;
							 end
							
	GET_W_FROM_MASTER: begin
							 slave_waitrequest = 1;
							 master_address = w_address + 4*i;
							 master_read = 1;
							 master_write = 0;
							 master_writedata = 0;
							 ram_addr=0;
						    ram_wren =0;
							 ram_wrdata = 0;
							 if(master_waitrequest == 0) begin
							   	if(master_readdatavalid) begin
										if(~use_ram) nextState <= GET_A_SDRAM;
										else nextState<= GET_A_ONCHIP;
										end
								   else nextState<=GET_W_FROM_MASTER;
							      end
							 else nextState<= GET_W_FROM_MASTER;
							 end
	
	GET_A_SDRAM: begin
						  slave_waitrequest = 1;
						  master_address = ifmap_address_new +4*i;
						  master_read = 1;
						  master_write = 0;
						  master_writedata = 0;
						  ram_addr<=i;
						  ram_wren <=1;
						  ram_wrdata = master_readdata;
						  if(master_waitrequest == 0) begin
								if(master_readdatavalid) nextState <= COMPUTE_MUL;
								else nextState<=GET_A_SDRAM;
						      end
						  else nextState<= GET_A_SDRAM;
						  end
						  
	GET_A_ONCHIP: begin
					  slave_waitrequest = 1;
					  master_address =0;
					  master_read = 0;
					  master_write = 0;
					  master_writedata = 0;
					  ram_addr = i;
					  ram_wren = 0;
					  ram_wrdata = 0;
					  if(num_wait<3) nextState<= GET_A_ONCHIP;
					  else nextState<= COMPUTE_MUL;
					  end
						  
	COMPUTE_MUL: begin
					 slave_waitrequest = 1;
					 master_address = 0;
					 master_read = 0;
					 master_write = 0;
					 master_writedata = 0;
					 nextState <=CHECKSAT;
					 ram_addr=0;
					 ram_wren =0;
					 ram_wrdata = 0;
					 end
	
	CHECKSAT: begin
				 slave_waitrequest = 1;
				 master_address = 0;
				 master_read = 0;
				 master_write = 0;
				 master_writedata = 0;
				 ram_addr=0;
				 ram_wren =0;
				 nextState <=ADD_SHIFT;
				 ram_wrdata = 0;
				 end
	ADD_SHIFT: begin
				 slave_waitrequest = 1;
				 master_address = 0;
				 master_read = 0;
				 master_write = 0;
				 master_writedata = 0;
				 ram_addr=0;
				 ram_wren =0;
				 ram_wrdata = 0;
				 nextState <=CHOP;
				 end
	CHOP: begin
				 slave_waitrequest = 1;
				 master_address = 0;
				 master_read = 0;
				 master_write = 0;
				 master_writedata = 0;
				 ram_addr=0;
				 ram_wren =0;
				 ram_wrdata = 0;
				 nextState <=INC_VALS;
				 end
	
	INC_VALS:begin
				slave_waitrequest = 1;
				master_address = 0;
				master_read = 0;
				master_write = 0;
				master_writedata = 0;
				ram_addr=0;
				ram_wren =0;
				ram_wrdata = 0;
				if( i == (vect_len_new -1)) nextState<= RELU;
				/*if(i < (vect_len ))*/ else nextState<= GET_W_FROM_MASTER;

				//else  nextState<= RELU;
				end
				
	RELU: begin
			slave_waitrequest = 1;
			master_address = 0;;
			master_read = 0;
			master_write = 0;
			master_writedata = 0;
			nextState<= WRITE_SUM;
			ram_addr=0;
			ram_wren =0;
			ram_wrdata = 0;
			end
	
					
		WRITE_SUM: begin
					  slave_waitrequest = 1;
					  master_writedata = sum_temp;
					  master_address = ofmap_address;
					  master_read = 0;
					  master_write = 1;
					  ram_addr=0;
					  ram_wren =0;
					  ram_wrdata = 0;

					  if(master_waitrequest ==0) nextState <=INFO;
					  else nextState<= WRITE_SUM;
					 
					  end
					 
		endcase
		end

endmodule: dnn



    
	 
	     // your code here
	 
	     // your code here
	
	  /*
		0	when written, starts accelerator; may also be read
		1	bias vector byte address
		2	weight matrix byte address
		3	input activations vector byte address
		4	output activations vector byte address
		5	input activations vector length
		6	reserved
		7	activation function: 1 if ReLU, 0 if identity
		
		
		
		  int sum = b[o];  bias for the current output index 
        for (unsigned i = 0; i < n_in; ++i) { / Q16 dot product 
            sum += (int) (((long long) w[wo + i] * (long long) ifmap[i]) >> 16);
        }
        if (use_relu) sum = (sum < 0) ? 0 : sum; /* ReLU activation 
        ofmap[o] = sum;
		  
		  
		  
		  1. make temporary variable sum =  value ot bias_addr;//get all temporary variables and store
		  2. then we loop 
		  3. for( unsigned i = 0; i< in_length; i++)
		  
		  logic signed [31:0] a, b, output
		  logic signed [63:0] c

		  c = ((a * b + 'h8000) >>> 16)

		  output = c[31:0]
		  
		  4. incriment sum: thing at weight_addr + i * thing at ifmap_addr
		  // instead of incrimenting the address itself we wanna incriment i. 
		  // ok lets looop!	 
	 */
	 
	 
