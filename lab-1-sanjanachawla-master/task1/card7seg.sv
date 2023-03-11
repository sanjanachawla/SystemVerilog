module card7seg(input [3:0] SW, output [6:0] HEX0);
		
   // your code goes here
	    always_comb
       case (SW) //case statement
            0 : HEX0 = 7'b1111111;
            1 : HEX0 = 7'b1111001;
            2 : HEX0 = 7'b0100100;
            3 : HEX0 = 7'b0110000;
            4 : HEX0 = 7'b0011001;
            5 : HEX0 = 7'b0010010;
            6 : HEX0 = 7'b0000010;
            7 : HEX0 = 7'b1111000;
            8 : HEX0 = 7'b0000000;
            9 : HEX0 = 7'b0010000;
				10 : HEX0 = 7'b1000000;
				11 : HEX0 = 7'b1100001;
				12 : HEX0 = 7'b0011000;
				13 : HEX0 = 7'b0001001;
				14 : HEX0 = 7'b1111111;
				15 : HEX0 = 7'b1111111;
            //switch off 7 segment character when the bcd digit is not a decimal number.
            default : HEX0 = 7'b1111111; 
        endcase
endmodule
