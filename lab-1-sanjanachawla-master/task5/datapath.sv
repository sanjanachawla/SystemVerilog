module datapath(input slow_clock, input fast_clock, input resetb,
                input load_pcard1, input load_pcard2, input load_pcard3,
                input load_dcard1, input load_dcard2, input load_dcard3,
                output [3:0] pcard3_out,
                output [3:0] pscore_out, output [3:0] dscore_out,
                output[6:0] HEX5, output[6:0] HEX4, output[6:0] HEX3,
                output[6:0] HEX2, output[6:0] HEX1, output[6:0] HEX0);
						
// The code describing your datapath will go here.  Your datapath 
// will hierarchically instantiate six card7seg blocks, two scorehand
// blocks, and a dealcard block.  The registers may either be instatiated
// or included as sequential always blocks directly in this file.
//
// Follow the block diagram in the Lab 1 handout closely as you write this code.

wire[3:0] new_card;
dealcard get_dealcard(.clock(fast_clock), .resetb(resetb), .new_card(new_card));



wire [3:0] pcard1;
wire [3:0] pcard2;
wire [3:0] pcard3;
wire [3:0] dcard1;
wire [3:0] dcard2;
wire [3:0] dcard3;

//registers

reg4 reg4p1(.card(new_card), .card_enable(load_pcard1), 
				.resetb(resetb), .slow_clock(slow_clock),
			   .fast_clock(fast_clock), .value(pcard1));
				
reg4 reg4p2(.card(new_card), .card_enable(load_pcard2), 
				.resetb(resetb), .slow_clock(slow_clock), 
				.fast_clock(fast_clock), .value(pcard2));
				
reg4 reg4p3(.card(new_card), .card_enable(load_pcard3), 
				.resetb(resetb), .slow_clock(slow_clock), 
				.fast_clock(fast_clock), .value(pcard3));
				
assign pcard3_out = pcard3;
				
reg4 reg4d1(.card(new_card), .card_enable(load_dcard1), 
				.resetb(resetb), .slow_clock(slow_clock), 
				.fast_clock(fast_clock),.value(dcard1));
				
reg4 reg4d2(.card(new_card), .card_enable(load_dcard2), 
				.resetb(resetb), .slow_clock(slow_clock), 
				.fast_clock(fast_clock), .value(dcard2));
				
reg4 reg4d3(.card(new_card), .card_enable(load_dcard3), 
				.resetb(resetb), .fast_clock(fast_clock),
				.slow_clock(slow_clock), .value(dcard3));
				


//card displays
card7seg segHEX0(.card(pcard1), .seg7(HEX0));
card7seg segHEX1(.card(pcard2), .seg7(HEX1));
card7seg segHEX2(.card(pcard3), .seg7(HEX2));
card7seg segHEX3(.card(dcard1), .seg7(HEX3));
card7seg segHEX4(.card(dcard2), .seg7(HEX4));
card7seg segHEX5(.card(dcard3), .seg7(HEX5));


//scorehands

scorehand get_pscore(.card1(pcard1), .card2(pcard2), .card3(pcard3), .total(pscore_out));
scorehand get_dscore(.card1(dcard1), .card2(dcard2), .card3(dcard3), .total(dscore_out));



//module reg4(input slow_clock, input reset_b, input load_pcard1 input [3:0] new_card)


endmodule

