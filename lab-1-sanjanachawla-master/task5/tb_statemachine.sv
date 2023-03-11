module tb_statemachine();

// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").

	logic slow_clock;
	logic resetb;
	logic load_pcard1;
	logic load_pcard2;
	logic load_pcard3;
	logic load_dcard1;
	logic load_dcard2;
	logic load_dcard3;
	logic[3:0] pscore;
	logic[3:0]dscore;
	logic[3:0] pcard3;
	logic player_win_light; 
	logic dealer_win_light;
	logic dcard3;
	
	statemachine statemachine_dut(.slow_clock(slow_clock), .resetb(resetb), .dscore(dscore), .pscore(pscore), .pcard3(pcard3),
												.load_pcard1(load_pcard1), .load_pcard2(load_pcard2), .load_pcard3(load_pcard3),
												.load_dcard1(load_dcard1), .load_dcard2(load_dcard2), .load_dcard3(load_dcard3),
												.player_win_light(player_win_light), .dealer_win_light(dealer_win_light));

	//want to test every possible state? :(											
	initial begin
	//test tie first, since it is easy???
	
	//module statemachine(input slow_clock, input resetb,
     //               input [3:0] dscore, input [3:0] pscore, input [3:0] pcard3,
       //             output load_pcard1, output load_pcard2,output load_pcard3,
         //           output load_dcard1, output load_dcard2, output load_dcard3,
           //         output player_win_light, output dealer_win_light);
	
	//first testing tie, player_win, dealer_win;
		//tie
	assign dscore = 2;
	assign pscore = 3;
	assign pcard3 = 1;
	assert (player_win_light ==1);
	assert (dealer_win_light == 0);
	

	#50;
		//player
	assign dscore = 3;
	assign pscore = 3;
	assign pcard3 = 1;
	assert (player_win_light ==1);
	assert (dealer_win_light ==1);
	
		#50;
	//dealer
	assign dscore = 4;
	assign pscore = 3;
	assign pcard3 = 1;
	assert (dealer_win_light ==1);
	assert (player_win_light == 0);
	
	#50
	
	//testing following the clock pulses gives the right load_card
	
	assign slow_clock = 0;
	#5;
	assign slow_clock = 1;
	assert (load_pcard1 ==1);
	#5;
	
		assign slow_clock = 0;
	#5;
	assign slow_clock = 1;
	assert (load_dcard1 ==1);
	#5;
	
		assign slow_clock = 0;
	#5;
	assign slow_clock = 1;
	assert (load_pcard2 ==1);
	#5;
	
		assign slow_clock = 0;
	#5;
	assign slow_clock = 1;
	assert (load_dcard2 ==1);
	#5;
	
	//assign slow_clock = 0;
	//#5;
	//assign slow_clock = 1;
	//assert (load_pcard3 ==1);
	#5;
	
	//assign slow_clock = 0;
	//#5;
	//assign slow_clock = 1;
	//assert (load_dcard3 ==1);
	#5;
	
	//want to test reset
	
	assign resetb = 1;
	#5;
	assign resetb = 0;
	#5;
	assign resetb = 1;
	assert (load_pcard1 == 0);
	assert (load_pcard2 == 0);
	assert (load_pcard3 == 0);
	assert (load_dcard1 == 0);
	assert (load_dcard2 == 0);
	assert (load_dcard3 == 0);
	
	//base functionallity right, now want to look at paths :(.

	//first case, one bigger than 8/9
	
	assign pscore = 8;
	assign dscore = 7;
	assert (player_win_light == 1);
	assert (dealer_win_light == 0);
	
	#50;
	
	assign dscore = 8;
	assign pscore = 7;
	assert (dealer_win_light == 1);
	assert (player_win_light == 0);
	
	
	//player less that 0-5
	#50
	assign pscore = 5;
	assert(load_pcard3 ==1);
	
	//dscore  = 7
	assign dscore = 7;
	assert(load_dcard3 ==0);
	#5;
	assign pcard3 = 3;
	assert (dealer_win_light == 0);
	assert (player_win_light == 1);
	
	#50;
	
	//dscore  = 6
	assign dscore = 6;
	assign pcard3 = 6;
	assert(load_dcard3 ==1);
	#5;
	assign dcard3 = 3;
	assert (dealer_win_light == 1);
	assert (player_win_light == 0);
	
	#50;
	
	//dscore  = 5
	assign dscore = 5;
	assign pcard3 = 4;
	assert(load_dcard3 ==1);
	#5;

	assign dcard3 = 3;
	assert (dealer_win_light == 0);
	assert (player_win_light == 1);
	
	#50;
		//dscore  = 4
	assign dscore = 4;
	assign pcard3 = 3;
	assert(load_dcard3 ==1);
	#5;

	assign dcard3 = 3;
	assert (dealer_win_light == 0);
	assert (player_win_light == 1);
	
	#50;
	//dscore  = 3
	assign dscore = 3;
	assign pcard3 = 8;
	assert(load_dcard3 ==0);
	#5;

	//assign dcard3 = 3
	assert (dealer_win_light == 1);
	assert (player_win_light == 1);
	
	#50;
	//dscore  = 2
	assign dscore = 2;
	assign pcard3 = 8;
	assert(load_dcard3 ==1);
	#5;

	assign dcard3 = 3;
	assert (dealer_win_light == 1);
	assert (player_win_light == 0);
	
	#50;
	
	// if pscore == 6 or 7
	
	assign pscore = 6;
	assign dscore = 3;
	assert (load_dcard3 ==1);
	assert (load_pcard3 ==0);
	
	#50;
	
	assign pscore = 6;
	assign dscore = 6;
	assert (load_dcard3 ==0);
	assert (load_pcard3 ==0);
	assert (dealer_win_light == 1);
	assert (player_win_light == 1);
	
	end
						
endmodule

