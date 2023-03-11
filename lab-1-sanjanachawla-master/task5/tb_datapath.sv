module tb_datapath();

// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").

	logic fast_clock;
	logic slow_clock;
	logic resetb;
	logic load_pcard1;
	logic load_pcard2;
	logic load_pcard3;
	logic load_dcard1;
	logic load_dcard2;
	logic load_dcard3;
	logic[3:0] pscore_out;
	logic[3:0]	dscore_out;
	logic[3:0] pcard3;
	logic [6:0] HEX0; 
	logic [6:0] HEX1;
	logic [6:0] HEX2;
	logic [6:0] HEX3;
	logic [6:0] HEX4; 
	logic [6:0] HEX5;
	logic [6:0] HEX6;
	
	
	datapath datapath_dut(.slow_clock(slow_clock),
            .fast_clock(fast_clock),
            .resetb(resetb),
            .load_pcard1(load_pcard1),
            .load_pcard2(load_pcard2),
            .load_pcard3(load_pcard3),
            .load_dcard1(load_dcard1),
            .load_dcard2(load_dcard2),
            .load_dcard3(load_dcard3),
            .dscore_out(dscore),
            .pscore_out(pscore),
            .pcard3_out(pcard3),
            .HEX5(HEX5),
            .HEX4(HEX4),
            .HEX3(HEX3),
            .HEX2(HEX2),
            .HEX1(HEX1),
            .HEX0(HEX0));
				
	initial begin
	
	//ALL A's + tie
		resetb = 1;
		fast_clock = 1;
		#5;
		slow_clock = 1;
		assert(HEX0 === 7'b0001000);
		assert (pscore ==1);
		
		#50;
		slow_clock = 0;
		#5;
		slow_clock = 1;
		assert(HEX3 === 7'b0001000);
		assert (dscore ==1);
		
		#50;
		slow_clock = 0;
		#5;
		slow_clock = 1;
		assert(HEX1 === 7'b0001000);
		assert (pscore ==2);
		
		#50;
		slow_clock = 0;
		#5;
		slow_clock = 1;
		assert(HEX4 === 7'b0001000);
		assert (dscore ==2);
		
		#50;
		slow_clock = 0;
		#5;
		slow_clock = 1;
		assert(HEX2 === 7'b0001000);
		assert (pscore ==3);
		assert(pcard3 == 1);
			
			
		#50;
		slow_clock = 0;
		#5;
		slow_clock = 1;
		assert(HEX5 === 7'b0001000);
		assert (dscore ==3);
		

		
		//end condition that it stays at the same place
		#50
		slow_clock = 0;
		#5;
		slow_clock = 1;
		
		assert(HEX0 === 7'b0001000);
		assert(HEX1 === 7'b0001000);
		assert(HEX2 === 7'b0001000);
		assert(HEX3 === 7'b0001000);
		assert(HEX4 === 7'b0001000);
		assert(HEX5 === 7'b0001000);
		
		
		//testing that they all turn off with reset
		#50;
		resetb=0;
		assert(HEX5 === 7'b1111111);
		assert(HEX5 === 7'b1111111);
		assert(HEX5 === 7'b1111111);
		assert(HEX5 === 7'b1111111);
		assert(HEX5 === 7'b1111111);
		assert(HEX5 === 7'b1111111);
		
		
		#50;
		#50;
		
		//want player to win:
		resetb = 1;
		fast_clock = 0;
		fast_clock = 1;
		//val at 2
		
		
		#5;
		slow_clock = 1;
		assert(HEX0 === 7'b0100100);
		assert (pscore ==2);
		
		fast_clock = 0;
		fast_clock = 1;
		//val at 3
		
		fast_clock = 0;
		fast_clock = 1;
		//val at 4
		
		fast_clock = 0;
		fast_clock = 1;
		//val at 5
		
				fast_clock = 0;
		fast_clock = 1;
		//val at 6
		
				fast_clock = 0;
		fast_clock = 1;
		//val at 7
		
				fast_clock = 0;
		fast_clock = 1;
		//val at 8
		
				fast_clock = 0;
		fast_clock = 1;
		//val at 9
		
				fast_clock = 0;
		fast_clock = 1;
		//val at 10
		
				fast_clock = 0;
		fast_clock = 1;
		//val at 11
		
				fast_clock = 0;
		fast_clock = 1;
		//val at 12
		
				fast_clock = 0;
		fast_clock = 1;
		//val at 13
		
				fast_clock = 0;
		fast_clock = 1;
		//val at 1
		
		#50;
		slow_clock = 0;
		#5;
		slow_clock = 1;
		assert(HEX3 === 7'b0001000);
		assert (dscore ==1);
		
		#50;
		slow_clock = 0;
		#5;
		slow_clock = 1;
		assert(HEX1 === 7'b0001000);
		assert (pscore ==3);
		
		#50;
		slow_clock = 0;
		#5;
		slow_clock = 1;
		assert(HEX4 === 7'b0001000);
		assert (dscore ==2);
		
		#50;
		slow_clock = 0;
		#5;
		slow_clock = 1;
		assert(HEX2 === 7'b0001000);
		assert (pscore ==3);
		assert(pcard3 == 1);
			
			
		#50;
		slow_clock = 0;
		#5;
		slow_clock = 1;
		assert(HEX5 === 7'b0001000);
		assert (dscore ==3);
		

		
		//end condition that it stays at the same place
		#50
		slow_clock = 0;
		#5;
		slow_clock = 1;
		
		assert(HEX0 === 7'b0001000);
		assert(HEX1 === 7'b0001000);
		assert(HEX2 === 7'b0001000);
		assert(HEX3 === 7'b0001000);
		assert(HEX4 === 7'b0001000);
		assert(HEX5 === 7'b0001000);
		
		
		//testing that they all turn off with reset
		#50;
		resetb=0;
		assert(HEX5 === 7'b1111111);
		assert(HEX5 === 7'b1111111);
		assert(HEX5 === 7'b1111111);
		assert(HEX5 === 7'b1111111);
		assert(HEX5 === 7'b1111111);
		assert(HEX5 === 7'b1111111);
		
		
		//dealer wins
		
		#50;
		#50;
		resetb = 1;
		//current val of deal_card at 1
		
		slow_clock =0;
		#5;
		slow_clock = 1;
		assert(HEX0 === 7'b0001000);
		assert (pscore ==1);
		
		
		fast_clock = 0;
		fast_clock = 1;
		//val at 2
		
		#50;
		slow_clock = 0;
		#5;
		slow_clock = 1;
		assert(HEX3 === 7'b0100100);
		assert (dscore ==2);
		
		#50;
		slow_clock = 0;
		#5;
		slow_clock = 1;
		assert(HEX1 === 7'b0001000);
		assert (pscore ==2);
		
		#50;
		slow_clock = 0;
		#5;
		slow_clock = 1;
		assert(HEX4 === 7'b0001000);
		assert (dscore ==3);
		
		#50;
		slow_clock = 0;
		#5;
		slow_clock = 1;
		assert(HEX2 === 7'b0001000);
		assert (pscore ==3);
		assert(pcard3 == 1);
			
			
		#50;
		slow_clock = 0;
		#5;
		slow_clock = 1;
		assert(HEX5 === 7'b0001000);
		assert (dscore ==4);
		
		//end condition that it stays at the same place
		#50
		slow_clock = 0;
		#5;
		slow_clock = 1;
		
		assert(HEX0 === 7'b0001000);
		assert(HEX1 === 7'b0001000);
		assert(HEX2 === 7'b0001000);
		assert(HEX3 === 7'b0001000);
		assert(HEX4 === 7'b0001000);
		assert(HEX5 === 7'b0001000);
		
		
		//testing that they all turn off with reset
		#50;
		resetb=0;
		assert(HEX5 === 7'b1111111);
		assert(HEX5 === 7'b1111111);
		assert(HEX5 === 7'b1111111);
		assert(HEX5 === 7'b1111111);
		assert(HEX5 === 7'b1111111);
		assert(HEX5 === 7'b1111111);
		
		
		
		end
						
endmodule

