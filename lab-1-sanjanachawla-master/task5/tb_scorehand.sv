module tb_scorehand();

// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").

logic [3:0] card1; 
logic [3:0] card2; 
logic [3:0] card3; 
logic [3:0] total;
logic clk;

scorehand scorehand_dut (.clk(clk), .card1(card1), .card2(card2), .card3(card3), .total(total));
initial begin
	clk = 0;
	forever #5 clk = ~clk;
end


	initial begin
		card1 = 1;
		card2 = 1;
		card3 = 1;
		assert (total ===3);
		
		#50
		card1 = 3;
		card2 = 4;
		card3 = 5;
		assert (total ==2);

		
		#50
		card1 = 5;
		card2 = 5;
		card3 = 5;
		assert(total == 5);
		
		#50
		card1 = 10;
		card2 = 11;
		card3 = 12;
		
		assert(total == 3);
		
		#50
		card1 = 0;
		card2 = 1;
		card3 = 2;
		assert (total ==3);
		
	end

						
endmodule

