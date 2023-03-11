module card7seg(input [3:0] card, output[6:0] seg7);

   // your code goes here

		 always_comb
       case (card) //case statement
            0 : seg7 = 7'b1111111;
            1 : seg7 = 7'b0001000;
            2 : seg7 = 7'b0100100;
            3 : seg7 = 7'b0110000;
            4 : seg7 = 7'b0011001;
            5 : seg7 = 7'b0010010;
            6 : seg7 = 7'b0000010;
            7 : seg7 = 7'b1111000;
            8 : seg7 = 7'b0000000;
            9 : seg7 = 7'b0010000;
				10 : seg7 = 7'b1000000;
				11 : seg7 = 7'b1100001;
				12 : seg7 = 7'b0011000;
				13 : seg7 = 7'b0001001;
				//14 : seg7 = 7'b1111111;
				//15 : seg7 = 7'b1111111;
            //switch off 7 segment character when the bcd digit is not a decimal number.
            default : seg7 = 7'b1111111; 
        endcase
	
endmodule

