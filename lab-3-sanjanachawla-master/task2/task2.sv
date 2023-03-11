module task2(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

   // s_mem s( /* connect ports */ );

    // your code here

	 
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
	 logic en;
	 logic[7:0] WREN1;
	 logic[7:0] WREN2;
	 logic [23:0] KEY_INPUT;


	assign KEY_INPUT[23:10] = 0;
	assign KEY_INPUT[9:0] = SW;

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

	//assign SECRET_KEY = 'h00033C;
	  
   s_mem s( .address(ADDRESS), .clock(CLOCK_50), .data(DATA), .wren(WREN), .q(Q));
						
	init s_init(.clk(CLOCK_50), .rst_n(KEY[3]), .en(en1), .rdy(RDY1),
					.addr(ADDRESS1), .wrdata(DATA1), .wren(WREN1));
					

	
	ksa s_ksa(.clk(CLOCK_50), .rst_n(KEY[3]), .rdy(RDY2), .en(en2), .key(KEY_INPUT), 
				.addr(ADDRESS2), .rddata(Q), .wrdata(DATA2), .wren(WREN2));
					
	

    // your code here
endmodule: task2
