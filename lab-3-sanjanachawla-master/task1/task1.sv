module task1(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

    // your code here
logic en1;
logic RDY1;
logic [7:0] ADDRESS;
logic [7:0] DATA;
logic WREN;
logic [7:0] Q;
always_comb begin
	if(RDY1 ==1) en1 =1;
	else en1  = 0;
end

s_mem s( .address(ADDRESS), .clock(CLOCK_50), .data(DATA), .wren(WREN), .q(Q));
						
init s_init(.clk(CLOCK_50), .rst_n(KEY[3]), .en(en1), .rdy(RDY1),
					.addr(ADDRESS), .wrdata(DATA), .wren(WREN));

    // your code here

endmodule: task1
