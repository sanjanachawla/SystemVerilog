module wordcopy(input logic clk, input logic rst_n,
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

    // your code here

	  logic [31:0] source_addr;
	  logic [31:0] dest_addr;
	  logic [31:0] count;
	  logic [31:0] num_copies;
	  logic [31:0] temp_wrdata;
	  logic written_0_flag;
	 
	 
	  typedef enum logic [4:0] {WAIT, INFO, READ, WRITE, INC, DONE} State; //need states for interacting with the cpu?
	  State currentState, nextState;
	  
	  always@(posedge clk or negedge rst_n) begin
			if (rst_n == 0) currentState = WAIT;
			else currentState <= nextState;
	  end
	  
	  
	  //here we assign the temporary values count, source_addr, dest_addr, numcopies, temp_wrdata.
	  always@(posedge clk) begin
			case(currentState) 
				WAIT: begin
						count <=1;
						written_0_flag = 0;
						//dest_addr = dest;
						//source_addr = 0;
						//num_copies = 0;
						//temp_wrdata = 0;
						//if(slave_write ==1) begin
						//	if(slave_address == 1) begin
						//		dest_addr<=slave_writedata;
								//nextState<=INFO;
							//end else nextState<=WAIT;
						//end //else nextState<=WAIT;

						//end
						end
				
				INFO: begin
						if(slave_write ==1) begin
							if (slave_address == 1) dest_addr <= slave_writedata;
							else if (slave_address == 2) source_addr <= slave_writedata;
							else if (slave_address == 3) num_copies <= slave_writedata;
							else if (slave_address == 0) written_0_flag = 1;
							end
						end
						
				READ: begin
						if ( master_readdatavalid) temp_wrdata <= master_readdata;
						end
						
				WRITE: begin
						 //dest_addr = dest_addr +1;
						 //count = count +1;
						 end
				INC: begin
						source_addr = source_addr +4;
						dest_addr = dest_addr +4;
						count = count +1;
					  end
				DONE: begin
				
						if(slave_read) begin 
							if(slave_address ==0) slave_readdata = slave_writedata;
							else slave_readdata = 0;
							end
							
						else slave_readdata = 0;
						count =  1;
						dest_addr = dest_addr - 4*num_copies;
						source_addr = source_addr - 4*num_copies;
						written_0_flag = 0;
						//num_copies = 0;
						//temp_wrdata = 0;
						end
			
			endcase
			end

	  
	  always_comb begin//misses info state
	  
			case(currentState) 
			WAIT: begin
					nextState <= INFO;
					slave_waitrequest = 0;
					master_address = source_addr;
					master_read = 0;
					master_write = 0;
					master_writedata = 0;
					//if(slave_write ==1) begin
							//if(slave_address == 1) begin
								//source_addr<=slave_writedata;
								nextState<=INFO;
							//end else nextState<=WAIT;
						//end else nextState<=WAIT;
					end
					
			INFO: begin
					//obtain the info from the slave interface
					slave_waitrequest = 0;
					master_address = source_addr;
					master_read = 0;
					master_write = 0;
					master_writedata = 0;
					//if(master_waitrequest ==0) begin
						if(written_0_flag) nextState <= READ;
						else nextState <= INFO;
						//end
					//else nextState<= INFO;
					
					end
					
			READ: begin
					slave_waitrequest = 1;
					master_address = source_addr;
					master_read = 1;
					master_write = 0;
					master_writedata = 0;
					
					if(master_waitrequest == 0) begin
						if(master_readdatavalid) nextState <= WRITE;
						else nextState<=READ;
						end
					else nextState<= READ;
					end
					
			WRITE: begin
					 slave_waitrequest = 1;
					 master_writedata = temp_wrdata;
					 master_address = dest_addr;
					 master_read = 0;
					 master_write = 1;

					 if(master_waitrequest ==0) begin
						 nextState <=INC;
						 end
					 else nextState<= WRITE;
					 
					 end
					 
			INC:   begin
					 slave_waitrequest = 1;
					 master_writedata = 0;
					 master_address = 0;
					 master_read = 0;
					 master_write = 0;
					 //IF(master_waitrequest !==0) begin					 
					 if(count < num_copies ) nextState<= READ;
					 else nextState <=DONE;
					 end
					 
			DONE: begin
				   slave_waitrequest = 0;
				   master_writedata = 0;
				   master_address = 0;
				   master_read = 0;
				   master_write = 0;
			      nextState<=WAIT;
					
					end
			endcase
	  end 
	 
endmodule: wordcopy
