module tb_card7seg();

// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").

logic [3:0] SW;
logic [6:0] HEX0;

card7seg card7seg_dut(.SW(SW), .HEX0(HEX0));

initial begin
	 assign SW = 0;
	 assert(HEX0 == 7'b1111111);
	 #5;
	 assign SW = 1 ;
	 assert( HEX0 == 7'b1111001);
	 #5;
	 
	 assign SW = 2;
	 assert( HEX0 == 7'b0100100);
	 #5;
	 
	 assign SW = 3;
	 assert( HEX0 == 7'b0110000);
	 #5;
	 
	 assign SW = 4;
	assert( HEX0 == 7'b0011001);

	#5;
	assign SW = 5;
	assert( HEX0 == 7'b0010010);

	#5;
	assign SW = 6 ;
	assert( HEX0 == 7'b0000010);

	#5;
	assign SW = 7 ;
	assert( HEX0 == 7'b1111000);

	#5;
	assign SW = 8 ; 
	assert (HEX0 == 7'b0000000);

	#5;
	assign SW == 9 ;
	assert( HEX0 == 7'b0010000);

	#5;
	assign SW = 10 ;
	assert( HEX0 == 7'b1000000);

	#5;
	assign SW = 11 ;
	assert( HEX0 == 7'b1100001);

	#5;
	assign SW = 12 ;
	assert( HEX0 ==7'b0011000);

	#5;
	assign SW = 13 ;
	assert( HEX0 == 7'b0001001);

	#5;
	assign SW = 14 ;
	assert( HEX0 == 7'b1111111);

	#5;
	assign SW = 15 ;
	assert( HEX0 == 7'b1111111);

	#5;
end
						
endmodule

