module arc4(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);

    // your code here

	logic RDY1;
	 logic RDY2;
	 logic [7:0] ADDRESS;
	 logic [7:0] DATA;
	 logic [7:0] DATA1;
	 logic [7:0] DATA2;
	logic [7:0] DATA3;
	 logic[7:0] WREN;
	 logic [7:0] Q;
	 logic [7:0] ADDRESS1;
	 logic [7:0] ADDRESS2;
	 logic [7:0] ADDRESS3;
	 logic en2;
	 logic en1;
	logic EN1;
	logic EN2;
	logic EN3;
	 //logic en;
	 logic[7:0] WREN1;
	 logic[7:0] WREN2;
	logic [7:0] WREN3;
	 logic [23:0] SECRET_KEY;

/*
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
	end */

always_comb begin

	if (ADDRESS1<255 && ADDRESS2 <255) ADDRESS = ADDRESS1;
	else if (ADDRESS1 == 255 && ADDRESS2 <255) ADDRESS= ADDRESS2;
	else if(ADDRESS1 ==255 && ADDRESS2 ==255) ADDRESS = ADDRESS3;
	else ADDRESS = 123;
	end


always_comb begin

	if (ADDRESS1<255 && ADDRESS2 <255) DATA = DATA1;
	else if (ADDRESS1 == 255 && ADDRESS2 <255) DATA= DATA2;
	else if(ADDRESS1 ==255 && ADDRESS2 ==255) DATA = DATA3;
	else DATA = 123;
	end

always_comb begin

	if (ADDRESS1<255 && ADDRESS2 <255) WREN= WREN1;
	else if (ADDRESS1 == 255 && ADDRESS2 <255) WREN= WREN2;
	else if(ADDRESS1 ==255 && ADDRESS2 ==255) WREN = WREN3;
	else WREN = 123;
	end
always_comb begin

	if (ADDRESS1 ==0&& ADDRESS2 <255 && ADDRESS3 < 255 )begin
		 EN1 = 1;
		 EN2 = 0;
		EN3 = 0;
		end
	else if (ADDRESS1 == 255 && ADDRESS2 == 0 &&ADDRESS3 <255) begin
		 EN1 = 0;
		 EN2 = 1;
		EN3 = 0;
		end 
	else if(ADDRESS1 ==255 && ADDRESS2 ==255 && ADDRESS3 ==0) begin
		 EN1 = 0;
		 EN2 = 0;
		EN3 = 1;
	end
	else begin
		 EN1 = 0;
		 EN2 = 0;
		EN3 = 0;
	end
	end

/*
always_comb begin

	if (WREN1 == 1) DATA = DATA1;
	else DATA = DATA2;
	end
*/
/*always_comb begin

end*/
	//assign SECRET_KEY = 'h00033C;
	  
   s_mem arc4_s( .address(ADDRESS), .clock(clk), .data(DATA), .wren(WREN), .q(Q));
						
   init arc4_init(.clk(clk), .rst_n(rst_n), .en(EN1), .rdy(RDY1),
					.addr(ADDRESS1), .wrdata(DATA1), .wren(WREN1));
					
   ksa arc4_ksa(.clk(clk), .rst_n(rst_n), .rdy(RDY2), .en(EN2), .key(key), 
				.addr(ADDRESS2), .rddata(Q), .wrdata(DATA2), .wren(WREN2));
	
  prga all_pgra(.clk(clk), .rst_n(rst_n), .en(EN3), .rdy(RDY3), .key(key), .s_addr(ADDRESS3),
					  .s_rddata(Q), .s_wrdata(DATA3), .s_wren(WREN3), .ct_addr(CT_ADDR), .ct_rddata(CT_RDDATA), 
					  .pt_addr(PT_ADDR), .pt_rddata(PT_RDDATA), .pt_wrdata(PT_WRDATA), .pt_wren(PT_WREN));
					  

					
				
endmodule: arc4