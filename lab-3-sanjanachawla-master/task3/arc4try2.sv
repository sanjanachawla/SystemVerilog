module arc4try2(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);

    // your code here
/*
	 logic RDY1;
	 logic RDY2;
	 logic RDY3;
	 
	 logic [7:0] S_WRDATA;
	 logic [7:0] S_WRDATA1;
	 logic [7:0] S_WRDATA2;
	 logic [7:0] S_WRDATA3;

	 logic [7:0] S_Q;
	 
	 logic [7:0] S_ADDR;
	 logic [7:0] S_ADDR1;
	 logic [7:0] S_ADDR2;
	 logic [7:0] S_ADDR3;
	 
	 logic EN3;
	 logic EN2;
	 logic EN1;
	 logic EN;
	 
	 logic [7:0] S_WREN;
	 logic [7:0] S_WREN1;
	 logic [7:0] S_WREN2;
	 logic [7:0] S_WREN3;
	 
	 logic [23:0] SECRET_KEY;
	 
	 logic [7:0] PT_ADDR;
	 logic [7:0] PT_WRDATA;
	 logic [7:0] PT_RDDATA;
	 logic PT_WREN;
	 
	 logic [7:0] CT_RDDATA;
	 logic [7:0] CT_ADDR;
	
	 logic INIT_DONE;
	 logic KSA_DONE;
	 logic PGRA_DONE;
	 
	 
	 assign SECRET_KEY = key;
typedef enum logic [4:0]{ARC4_WAIT, INIT, INIT_RUN, KSA, KSA_RUN, PGRA, PGRA_RUN, DONE} State;
	State stateNow, next;
*/
	
/*

always_comb begin

	if (RDY1 == 1) EN1 = 1;
	else EN1 = 0;

end


always_comb begin

	if (RDY2 == 1) begin
			if(S_WREN1 ==0) EN2 = 1;
			else EN2 = 0;
			end
	else EN2 = 0;
end



always_comb begin

	if (WREN1 == 1) WREN = WREN1;
	else WREN = WREN2;
	end

always_comb begin

	if (WREN1 == 1) ADDRESS = ADDRESS1;
	else ADDRESS = ADDRESS2;
	end

always_comb begin

	if (WREN1 == 1) DATA = DATA1;
	else DATA = DATA2;
	end

	*/
	/*
	
always@(posedge RDY1) begin
	if(RDY1 == 1) INIT_DONE = 1;
	else INIT_DONE = 0;
end


always@(posedge RDY2) begin
	if(RDY2 == 1) KSA_DONE = 1;
	else KSA_DONE = 0;
end

always@(posedge RDY3) begin
	if(RDY3 == 1) PGRA_DONE = 1;
	else INIT_DONE = 0;
end


*//*
always@(posedge clk or negedge rst_n or posedge RDY1 or posedge RDY2 or posedge RDY3) begin

	if(rst_n ==0) begin 
			stateNow <=ARC4_WAIT;
			end
			
	else begin 
			stateNow <= next;
		end
end	
	
	
	always_comb begin
		begin case(stateNow)
		
		ARC4_WAIT:begin
				EN1 = 0;
				EN2 = 0;
				EN3 = 0;
				rdy = 1;
				S_ADDR = 0;
				S_WRDATA =0;
				S_WREN = 0;
				if (en==1)next <= INIT;
				else next <= ARC4_WAIT;
			  end
		
		INIT: begin
				EN1 = 1;
				EN2 = 0;
				EN3 = 0;
				rdy = 0;
				S_ADDR = S_ADDR1;
				S_WRDATA = S_WRDATA1;
				S_WREN = S_WREN1;
			   next <= INIT_RUN;
				
				end
				
		INIT_RUN: begin
					EN1 = 1;
					EN2 = 0;
					EN3 = 0;
					rdy = 0;
					S_ADDR = S_ADDR1;
					S_WRDATA = S_WRDATA1;
					S_WREN = S_WREN1;
					if (RDY1 ==1 && RDY2 ==1 && RDY3 ==1) next <= INIT_RUN;
					else next <= INIT_RUN;
					end
				
		KSA: 	begin
				EN1 = 0;
				EN2 = 1;
				EN3 = 0;
				rdy = 0;
				S_ADDR = S_ADDR2;
				S_WRDATA = S_WRDATA2;
				S_WREN = S_WREN2;
				 next <= KSA_RUN;
				//else nextState <= KSA;
				end
				
		KSA_RUN: 	begin
				EN1 = 0;
				EN2 = 0;
				EN3 = 0;
				rdy = 0;
				S_ADDR = S_ADDR2;
				S_WRDATA = S_WRDATA2;
				S_WREN = S_WREN2;
				if(RDY1 ==1 && RDY2 ==1 && RDY3 ==1) next <= PGRA;
				else next <= KSA_RUN;
				end
				
		PGRA: begin
				EN1 = 0;
				EN2 = 0;
				EN3 = 1;
				rdy = 0;
				S_ADDR = S_ADDR3;
				S_WRDATA = S_WRDATA3;
				S_WREN = S_WREN3;
				 next <= PGRA_RUN;
				//else nextState <= PGRA;
				end
				
		PGRA_RUN: begin
					EN1 = 0;
					EN2 = 0;
					EN3 = 1;
					rdy = 0;
					S_ADDR = S_ADDR3;
					S_WRDATA = S_WRDATA3;
					S_WREN = S_WREN3;
					if(RDY1 ==1 && RDY2 ==1 && RDY3 ==1) next <= DONE;
					else next <= PGRA_RUN;
					end
				
		DONE: begin
				EN1 = 0;
				EN2 = 0;
				EN3 = 0;
				rdy = 1;
				rdy = 0;
				S_ADDR = S_ADDR3;
				S_WRDATA = S_WRDATA3;
				S_WREN = S_WREN3;
				next <=DONE;
		
				end
		
		endcase
		end
	end 
	
	
	
	s_mem s( .address(S_ADDR), .clock(CLOCK_50), .data(S_WRDATA), .wren(S_WREN), .q(S_Q));
						
	init s_init(.clk(CLOCK_50), .rst_n(rst_n), .en(EN1), .rdy(RDY1),
					.addr(S_ADDR1), .wrdata(S_WRDATA1), .wren(s_WREN1));
	
	ksa s_ksa(.clk(CLOCK_50), .rst_n(rst_n), .rdy(RDY2), .en(EN2), .key(SECRET_KEY), 
				.addr(S_ADDR2), .rddata(S_Q), .wrdata(S_WRDATA2), .wren(s_WREN2));
				
	prga all_pgra(.clk(CLOCK_50), .rst_n(rst_n), .en(EN3), .rdy(RDY3), .key(SECRET_KEY), .s_addr(S_ADDR3),
					  .s_rddata(S_Q), .s_wrdata(S_WRDATA3), .s_wren(S_WREN3), .ct_addr(CT_ADDR), .ct_rddata(CT_RDDATA), 
					  .pt_addr(PT_ADDR), .pt_rddata(PT_RDDATA), .pt_wrdata(PT_WRDATA), .pt_wren(PT_WREN));
					  
					  

	*/
	
	logic RDY1;
	 logic RDY2;
	 logic [7:0] ADDRESS;
	 logic [7:0] DATA;
	 logic [7:0] DATA1;
	 logic [7:0] DATA2;
	 logic[7:0] WREN;
	 logic [7:0] Q;
	 logic [7:0] ADDRESS1;
	 logic [7:0] ADDRESS2;
	 logic en2;
	 logic en1;
	 //logic en;
	 logic[7:0] WREN1;
	 logic[7:0] WREN2;
	 logic [23:0] SECRET_KEY;

always_comb begin

	if (RDY1 == 1) en1 = 1;
	else en1 = 0;

end


always_comb begin

	if (RDY2 == 1) begin
			if(WREN1 ==0) en2 = 1;
			else en2 = 0;
			end
	else en2 = 0;
end


always_comb begin

	if (WREN1 == 1) WREN = WREN1;
	else WREN = WREN2;
	end

always_comb begin

	if (WREN1 == 1) ADDRESS = ADDRESS1;
	else ADDRESS = ADDRESS2;
	end

always_comb begin

	if (WREN1 == 1) DATA = DATA1;
	else DATA = DATA2;
	end

	assign SECRET_KEY = 'h00033C;
	  
   s_mem s( .address(ADDRESS), .clock(CLOCK_50), .data(DATA), .wren(WREN), .q(Q));
						
	init s_init(.clk(CLOCK_50), .rst_n(rst_n), .en(en1), .rdy(RDY1),
					.addr(ADDRESS1), .wrdata(DATA1), .wren(WREN1));
					

	
	ksa s_ksa(.clk(CLOCK_50), .rst_n(rst_n), .rdy(RDY2), .en(en2), .key(SECRET_KEY), 
				.addr(ADDRESS2), .rddata(Q), .wrdata(DATA2), .wren(WREN2));
					
				
endmodule: arc4try2