module task3(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

    // your code here

	 logic [23:0] TEST_KEY;
	 assign TEST_KEY[23:10] = 0;
	 assign TEST_KEY[9:0] = SW;
    ct_mem ct(  .address(CT_ADDR), .clock(CLOCK_50), .data(0), .wren(0), .q(CT_RDDATA));
    pt_mem pt(  .address(PT_ADDR), .clock(CLOCK_50), .data(PT_WRDATA), .wren(PT_WREN), .q(PT_RDDATA));
    arc4try2 a4( .clk(CLOCK_50), .rst_n(KEY[3]), . en(KEY[0]), .key(TEST_KEY), .ct_addr(CT_ADDR), .ct_rddata(CT_RDDATA), 
				 .pt_addr(PT_ADDR), .pt_rddata(PT_RDDATA), .pt_wrdata(PT_WRDATA), .pt_wren(PT_WREN));

	 
endmodule: task3
