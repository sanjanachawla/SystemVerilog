module scorehand(input [3:0] card1, input [3:0] card2, input [3:0] card3, output [3:0] total);

// The code describing scorehand will go here.  Remember this is a combinational
// block. The function is described in the handout.  Be sure to review the section
// on representing numbers in the lecture notes.

	logic [3:0] val1;
	logic [3:0] val2;
	logic [3:0] val3;

	always_comb
		case (card1)
		0:  val1  = 0;
		1:  val1  = 1;
		2:  val1  = 2;
		3:  val1  = 3;
		4:  val1  = 4;
		5:  val1  = 5;
		6:  val1  = 6;
		7:  val1  = 7;
		8:  val1  = 8;
		9:  val1  = 9;
		10: val1  = 0;
		11: val1  = 0;
		12: val1  = 0;
		13: val1  = 0;
		default: val1 = 0;
		endcase
	always_comb
		case (card2)
		0:  val2  = 0;
		1:  val2  = 1;
		2:  val2  = 2;
		3:  val2  = 3;
		4:  val2  = 4;
		5:  val2  = 5;
		6:  val2  = 6;
		7:  val2  = 7;
		8:  val2  = 8;
		9:  val2  = 9;
		10: val2  = 0;
		11: val2  = 0;
		12: val2  = 0;
		13: val2  = 0;
		default: val2 =0;
		endcase
		
	always_comb
		case (card3)
		0:  val3  = 0;
		1:  val3  = 1;
		2:  val3  = 2;
		3:  val3  = 3;
		4:  val3  = 4;
		5:  val3  = 5;
		6:  val3  = 6;
		7:  val3  = 7;
		8:  val3  = 8;
		9:  val3  = 9;
		10: val3  = 0;
		11: val3  = 0;
		12: val3  = 0;
		13: val3  = 0;
		default: val3 = 0;
		endcase
	
	logic [5:0] sum;
	assign sum = val1 + val2 + val3;
	assign total = sum %10;

endmodule

