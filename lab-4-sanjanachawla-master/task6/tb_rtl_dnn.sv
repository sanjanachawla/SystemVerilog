`timescale 1ps / 1ps

module tb_rtl_dnn();

	logic clk;
	logic rst_n;

	// slave (CPU-facing)
	logic slave_waitrequest;
	logic [3:0] slave_address;
	logic slave_read; 
	logic [31:0] slave_readdata;
	logic slave_write;
	logic [31:0] slave_writedata;
	logic init_0;
	logic init_vals;

	// master (SDRAM-facing)
	logic master_waitrequest;
	logic [31:0] master_address;
	logic master_read;
	logic [31:0] master_readdata;
	logic master_readdatavalid;
	logic master_write;
	logic [31:0] master_writedata;
		
		
	logic [7:0] SDRAM [0:256];
	logic [8:0] TEST;
	logic start;
	
				dnn dut(.clk(clk),
						 .rst_n(rst_n),
						 .slave_waitrequest(slave_waitrequest),
						 .slave_address(slave_address),
						 .slave_read(slave_read),
						 .slave_readdata(slave_readdata),
						 .slave_write(slave_write),
						 .slave_writedata(slave_writedata),
						 .master_waitrequest(master_waitrequest),
						 .master_address(master_address),
						 .master_read(master_read),
						 .master_readdata(master_readdata),
						 .master_readdatavalid(master_readdatavalid),
						 .master_write(master_write),
						 .master_writedata(master_writedata)
						 );
						 
	int i_tb;
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end
	
	
	
	
	
	always_comb begin
		if(start) init_0 = 1;
		else if (init_0) begin
		
			for(i_tb = 0; i_tb < 127; i_tb = i_tb +1)
				SDRAM[i_tb] = i_tb<<<16;
				init_0 = 0;
				init_vals = 1;
				end
		else if(init_vals)  begin
			for(i_tb = 1; i_tb < 18; i_tb =  i_tb+4)
				SDRAM[i_tb] = i_tb;//                       [1, 5, 9, 13, 17]
				
			for(i_tb = 21; i_tb< 38; i_tb =  i_tb+4)
				SDRAM[i_tb] = -(i_tb - 20);  //              [-1,-5,-9,-13,-17]
				
			for(i_tb = 41; i_tb< 50; i_tb =  i_tb+4)
				SDRAM[i_tb] = i_tb-40;        //             [1, 5, 9, 14, -1, -5] 
				
			for(i_tb = 53; i_tb< 60; i_tb =  i_tb+4)
				SDRAM[i_tb] = (i_tb - 50);         
				
			for(i_tb = 61; i_tb< 78; i_tb =  i_tb+4) // [1,1,1,1,1]
				SDRAM[i_tb] = 1;
				
			init_vals = 0;
			end
			
		else if (master_read) begin
			master_readdata[7:0]   <= SDRAM[master_address +3];
			master_readdata[15:8]  <= SDRAM[master_address +2];
			master_readdata[23:16] <= SDRAM[master_address +1];
			master_readdata[31:24] <= SDRAM[master_address];
			master_readdatavalid <= 1;
			end
			
		else if (master_write) begin
		   	SDRAM[master_address] <= master_writedata[31:24];
			SDRAM[master_address +1] <= master_writedata[23:16];
			SDRAM[master_address +2] <= master_writedata[15:8];
			SDRAM[master_address+3] <= master_writedata[7:0];
			master_readdatavalid <= 0;
			end
		else begin
			master_readdata<=0;
		end
	end
	
	initial begin
		
		start = 1;
		#15;
		start = 0;
		rst_n = 1;
		#10;
		rst_n = 0;
		#10;
		rst_n = 1;
		#10;
		//master_readdatavalid = 1;
		
		
		/*
	   0	when written, starts accelerator; may also be read
		1	bias vector byte address
		2	weight matrix byte address
		3	input activations vector byte address
		4	output activations vector byte address
		5	input activations vector length
		6	reserved
		7	activation function: 1 if ReLU, 0 if identity
	   */
		$display ("TEST1: checking functionality");
		TEST = 1;
		slave_waitrequest = 0;
		master_waitrequest = 0;
		#30;
		slave_write = 1;
		
		slave_write = 1;
		slave_address = 1;
		slave_writedata = 0; // bias vector
		#10;
		
		slave_address = 2;
		slave_writedata = 60; //weight matrix
		#10;
		slave_address = 3;
		slave_writedata = 0; //in_a
		#10;
		slave_address = 5;
		slave_writedata = 5; //vect_len
		
		#10;
		slave_address = 4;
		slave_writedata = 80; //out_location
		#10;
		slave_address = 7;
		slave_writedata = 0; //no relu
		#10;
		slave_address = 0;
		slave_writedata = 0; //start
		#10;
		slave_write =0;
		#500;
		
	       $display ("TEST2: now with mem");
		TEST = 2;
		slave_waitrequest = 0;
		master_waitrequest = 0;
		#30;
		slave_write = 1;
		
		slave_write = 1;
		slave_address = 1;
		slave_writedata = 0; // bias vector
		#10;
		
		slave_address = 2;
		slave_writedata = 60; //weight matrix
		#10;
		slave_address = 3;
		slave_writedata = 0; //in_a
		#10;
		slave_address = 5;
		slave_writedata = 5; //vect_len
		
		#10;
		slave_address = 4;
		slave_writedata = 88; //out_location
		#10;
		slave_address = 7;
		slave_writedata = 1; //relu
		#10;
		slave_address = 0;
		slave_writedata = 0; //start
		#10;
		slave_write =0;
		#500;


		$display ("TEST 3: new vals");
		TEST = 3;
		slave_waitrequest = 0;
		master_waitrequest = 0;
		#30;
		slave_write = 1;
		
		slave_write = 1;
		slave_address = 1;
		slave_writedata = 4; // bias vector
		#10;
		
		slave_address = 2;
		slave_writedata = 40; //weight matrix
		#10;
		slave_address = 3;
		slave_writedata = 0; //in_a
		#10;
		slave_address = 5;
		slave_writedata = 6; //vect_len
		
		#10;
		slave_address = 4;
		slave_writedata = 92; //out_location
		#10;
		slave_address = 7;
		slave_writedata = 0; //relu
		#10;
		slave_address = 0;
		slave_writedata = 0; //start
		#10;
		slave_write =0;
		#500;
		#500;
		
		 $display ("TEST 4: ONCHIP");
		TEST = 4;
		slave_waitrequest = 0;
		master_waitrequest = 0;
		#30;
		slave_write = 1;
		
		slave_write = 1;
		slave_address = 1;
		slave_writedata = 4; // bias vector
		#10;
		
		slave_address = 2;
		slave_writedata = 60; //weight matrix
		#10;
		/*slave_address = 3;
		slave_writedata = 0; //in_a
		#10;
		slave_address = 5;
		slave_writedata = 5; //vect_len
		*/
		#10;
		slave_address = 4;
		slave_writedata = 96; //out_location
		#10;
		slave_address = 7;
		slave_writedata = 0; //relu
		#10;
		slave_address = 0;
		slave_writedata = 0; //start
		#10;
		slave_write =0;
		#500;
		#500;

	
		 $display ("TEST 5: IDLE MASTER_WAITREQUEST HIGH");
		TEST = 5;
		slave_waitrequest = 0;
		master_waitrequest = 0;
		#30;
		slave_write = 1;
		
		slave_write = 1;
		slave_address = 1;
		slave_writedata = 4; // bias vector
		#10;
		master_waitrequest = 1;
		slave_address = 2;
		slave_writedata = 60; //weight matrix
		#10;
		/*slave_address = 3;
		slave_writedata = 0; //in_a
		#10;
		slave_address = 5;
		slave_writedata = 5; //vect_len
		*/
		#10;
		slave_address = 4;
		slave_writedata = 100; //out_location
		#10;
		slave_address = 7;
		slave_writedata = 0; //relu
		#10;
		slave_address = 0;
		master_waitrequest = 0;
		slave_writedata = 0; //start
		#10;
		slave_write =0;
		master_waitrequest =1;
		#200;
 		master_waitrequest = 0;
		#20;
		master_waitrequest = 1;
		#100;
		master_waitrequest = 0;
		#50;
		master_waitrequest = 1;
		#10;
		master_waitrequest = 0;
		#500;


		
		 $display ("TEST 6: ONCHIP check again, all three should be consistent");
		TEST = 6;
		slave_waitrequest = 0;
		master_waitrequest = 0;
		#30;
		slave_write = 1;
		
		slave_write = 1;
		slave_address = 1;
		slave_writedata = 4; // bias vector
		#10;
		
		slave_address = 2;
		slave_writedata = 60; //weight matrix
		#10;
		/*slave_address = 3;
		slave_writedata = 0; //in_a
		#10;
		slave_address = 5;
		slave_writedata = 5; //vect_len
		*/
		#10;
		slave_address = 4;
		slave_writedata = 104; //out_location
		#10;
		slave_address = 7;
		slave_writedata = 0; //relu
		#10;
		slave_address = 0;
		slave_writedata = 0; //start
		#10;
		slave_write =0;
		#500;

		/*$display ("expecting 12 to be sum_add");
		$display ("expecting 14 to be sum_temp at location 21");
		$display ("should be exact same ");
		//if(SDRAM[2] != 14<<<16) $display("ERROR, NOT RIGHT, VALUE IS %b SHOULD BE %b", SDRAM[21], 14<<<16);
		else $display("CORRECT");

		 $display ("now with mem");
		TEST = 2;
		slave_waitrequest = 0;
		master_waitrequest = 0;
		#30;
		slave_write = 1;
		
		slave_write = 1;
		slave_address = 1;
		slave_writedata = 0; // bias vector
		#10;
		
		slave_address = 2;
		slave_writedata = 60; //weight matrix
		#10;
		slave_address = 3;
		slave_writedata = 0; //in_a
		#10;
		slave_address = 5;
		slave_writedata = 5; //vect_len
		
		#10;
		slave_address = 4;
		slave_writedata = 88; //out_location
		#10;
		slave_address = 7;
		slave_writedata = 1; //relu
		#10;
		slave_address = 0;
		slave_writedata = 0; //start
		#10;
		slave_write =0;
		#200;





	/*	
		$display ("checking negative no relu");
		TEST =3;
		slave_waitrequest = 0;
		master_waitrequest = 0;
		#30;
		slave_write = 1;
		
		slave_write = 1;
		slave_address = 1;
		slave_writedata = 2; // bias vector
		#10;
		
		#10;
		slave_address = 2;
		slave_writedata = 13; //weight matrix
		#10;
		slave_address = 3;
		slave_writedata = 4; //in_a
		#10;
		slave_address = 5;
		slave_writedata = 1; //vect_len
		
		#10;
		slave_address = 4;
		slave_writedata = 22; //out_location
		#10;
		slave_address = 7;
		slave_writedata = 0;// relu
		#10;
		slave_address = 0;
		slave_writedata = 0; //start
		#10;
		slave_write =0;
		#200;
		$display ("expecting -12 to be sum_add");
		$display ("expecting -10 to be sum_temp at location 22");
		if(SDRAM[22] != -10<<<16) $display("ERROR, NOT RIGHT, VALUE IS %b SHOULD BE %b", SDRAM[22], -10<<<16);
		else $display("CORRECT");
                #10;
		$display ("checking double negative with relu");
		TEST = 4;
		slave_waitrequest = 0;
		master_waitrequest = 0;
		#30;
		slave_write = 1;
		
		slave_write = 1;
		slave_address = 1;
		slave_writedata = 12; // bias vector
		#10;
		
		slave_address = 2;
		slave_writedata = 13; //weight matrix
		#10;
		slave_address = 3;
		slave_writedata = 4; //in_a
		#10;
		slave_address = 5;
		slave_writedata = 1; //vect_len
		
		#10;
		slave_address = 4;
		slave_writedata = 23; //out_location
		#10;
		slave_address = 7;
		slave_writedata = 1; //relu
		#10;
		slave_address = 0;
		slave_writedata = 0; //start
		#10;
		slave_write =0;
		#200;
		$display ("expecting 12 to be sum_add");
		$display ("expecting 0 to be sum_temp at location 23");
                if(SDRAM[23] != 0<<<16) $display("ERROR, NOT RIGHT, VALUE IS %b SHOULD BE %b", SDRAM[23], 0<<<16);
		else $display("CORRECT");
		
		//now want to check weird stuff with avalon protocol


		$display ("checking negative with relu");
		TEST = 5;
		slave_waitrequest = 0;
		master_waitrequest = 0;
		#30;
		slave_write = 1;
		
		slave_write = 1;
		slave_address = 1;
		slave_writedata = 12; // bias vector
		#10;
		
		slave_address = 2;
		slave_writedata = 13; //weight matrix
		#10;
		slave_address = 3;
		slave_writedata = 14; //in_a
		#10;
		slave_address = 5;
		slave_writedata = 1; //vect_len
		
		#10;
		slave_address = 4;
		slave_writedata = 24; //out_location
		#10;
		slave_address = 7;
		slave_writedata = 1; //relu
		#10;
		slave_address = 0;
		slave_writedata = 0; //start
		#10;
		slave_write =0;
		#200;
		$display ("expecting -12 to be sum_add");
		$display ("expecting 10 to be sum_temp at location 24");
		if(SDRAM[24] != 10<<<16) $display("ERROR, NOT RIGHT, VALUE IS %b SHOULD BE %b", SDRAM[24], 10<<<16);
		else $display("CORRECT");
	


		$display ("checking vector length > 1");
		TEST = 6;
		slave_waitrequest = 0;
		master_waitrequest = 0;
		#30;
		slave_write = 1;
		
		slave_write = 1;
		slave_address = 1;
		slave_writedata = 2; // bias vector
		#10;
		
		slave_address = 2;
		slave_writedata = 2; //weight matrix
		#10;
		slave_address = 3;
		slave_writedata = 3; //in_a
		#10;
		slave_address = 5;
		slave_writedata = 3; //vect_len
		
		#10;
		slave_address = 4;
		slave_writedata = 25; //out_location
		#10;
		slave_address = 7;
		slave_writedata = 1; //relu
		#10;
		slave_address = 0;
		slave_writedata = 0; //start
		#10;
		slave_write =0;
		#300;
		//$display ("expecting 158 to be sum_add");
		$display ("expecting 50 to be sum_temp at location 25");
		if(SDRAM[25] != 50<<<16) $display("ERROR, NOT RIGHT, VALUE IS 'h%b SHOULD BE 'h%b", SDRAM[25], 50<<<16);
		else $display("CORRECT");
		
		//need to check big vector lengths - when it loops
		//check the no need to repeat at the same time
		//need to check weird avalon stuff

		$display ("checking vector length =3 with repeats");
		TEST = 7;
		slave_waitrequest = 0;
		master_waitrequest = 0;
		#30;
		slave_write = 1;
		
		/*slave_write = 1;
		slave_address = 1;
		slave_writedata = 2; // bias vector
		#10;
		
		slave_address = 2;
		slave_writedata = 2; //weight matrix
		#10;
		slave_address = 3;
		slave_writedata = 3; //in_a
		#10;*/
/*		slave_address = 5;
		slave_writedata = 4; //vect_len
		
		#10;
		slave_address = 4;
		slave_writedata = 26; //out_location
		#10;
		slave_address = 7;
		slave_writedata = 1; //relu
		#10;
		slave_address = 0;
		slave_writedata = 0; //start
		#10;
		slave_write =0;
		#400;
		$display ("expecting 68 to be sum_add");
		$display ("expecting 70 to be sum_temp at location 26");
		if(SDRAM[26] != 70<<<16) $display("ERROR, NOT RIGHT, VALUE IS %b SHOULD BE %b", SDRAM[26], 70<<<16);
		else $display("CORRECT");

		$display ("checking vector length =3 with and negative repeats");
		TEST = 8;
		slave_waitrequest = 0;
		master_waitrequest = 0;
		#30;
		slave_write = 1;
		
		slave_write = 1;
		slave_address = 1;
		slave_writedata = 12; // bias vector
		#10;
		
		slave_address = 2;
		slave_writedata = 12; //weight matrix
		#10;
		/*slave_address = 3;
		slave_writedata = 3; //in_a*/
//		#10;
		/*slave_address = 5;
		slave_writedata = 3; //vect_len
		*/
/*		#10;
		slave_address = 4;
		slave_writedata = 27; //out_location
		#10;
		/*slave_address = 7;
		slave_writedata = 1; //relu*/
/*		#10;
		slave_address = 0;
		slave_writedata = 0; //start
		#10;
		slave_write =0;
		#400;
		$display ("expecting 68 to be sum_add");
		$display ("expecting 64 to be sum_temp at location 27");
		if(SDRAM[27] != 64<<<16) $display("ERROR, NOT RIGHT, VALUE IS %b SHOULD BE %b", SDRAM[27], 64<<<16);
		else $display("CORRECT");
*/      
	      end


endmodule: tb_rtl_dnn
