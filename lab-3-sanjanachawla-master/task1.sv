module task1(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

    // your code here
	 //Add an instance of your init module and connect it to the RAM instance. 
	 //For the final submission, make sure that init is activated exactly once 
	 //every time after reset, and that S is not written to after init finishes. 
	 //Note: do not rename the memory instance — we need to be able to access it 
	 //from a testbench to test your code.
	 
	 
	 //Remember to follow the ready-enable microprotocol we defined earlier. It 
	 //is not outside the realm of possibility that we could replace either init
	 // or task1 with another implementation when testing your code.
	 //wren = enable?
	 //data = is s right
	 // q = ?
	 //address = ?
	 
	 logic RDY;
	 logic [7:0] ADDRESS;
	 logic [7:0] DATA;
	 logic[7:0] WREN;
	 logic [7:0] Q;
	 logic en;


 always_comb begin

	if (RDY == 1) en = 1;
	else en = 0;

end
	 
   s_mem s( .address(ADDRESS), .clock(CLOCK_50), .data(DATA), .wren(WREN), .q(Q));
						
	init s_init(.clk(CLOCK_50), .rst_n(KEY[3]), .en(en), .rdy(RDY),
					.addr(ADDRESS), .wrdata(DATA), .wren(WREN));
					
	

    // your code here

endmodule: task1
