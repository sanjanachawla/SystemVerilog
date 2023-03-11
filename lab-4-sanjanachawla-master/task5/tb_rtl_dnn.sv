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

	// master (SDRAM-facing)
	logic master_waitrequest;
	logic [31:0] master_address;
	logic master_read;
	logic [31:0] master_readdata;
	logic master_readdatavalid;
	logic master_write;
	logic [31:0] master_writedata;
		
		
	logic [31:0] SDRAM [0:127];
	logic [31:0] TEST;
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
	logic init;
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end
	
	
	
	
	
	always_comb begin
		if(start) init = 1;
		else if (init) begin
			for(i_tb = 0; i_tb < 10; i_tb = i_tb +1)
				SDRAM[i_tb] = i_tb<<<16;
			for(i_tb = 10; i_tb < 20; i_tb= i_tb +1)
				SDRAM[i_tb] = -(i_tb-10)<<<16;
			init = 0;
			end
			
		else if (master_read) begin
			/*master_readdata[7:0] <= SDRAM[master_address +3];
			master_readdata[15:8] <= SDRAM[master_address +2];
			master_readdata[23:16] <= SDRAM[master_address +1];
			master_readdata[31:24] <= SDRAM[master_address];
			*/
			master_readdata <= SDRAM[master_address];
			master_readdatavalid = 1;
		end
		else if (master_write) begin
			/*SDRAM[master_address] <= master_writedata[31:24];
			SDRAM[master_address +1] <= master_writedata[23:16];
			SDRAM[master_address +2] <= master_writedata[15:8];
			SDRAM[master_address+3] <= master_writedata[7:0];*/
			SDRAM[master_address] <= master_writedata;
			master_readdatavalid = 0;
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
		$display ("checking functionality");
		TEST = 1;
		slave_waitrequest = 0;
		master_waitrequest = 0;
		#30;
		slave_write = 1;
		
		slave_write = 1;
		slave_address = 1;
		slave_writedata = 2; // bias vector
		#10;
		
		slave_address = 2;
		slave_writedata = 3; //weight matrix
		#10;
		slave_address = 3;
		slave_writedata = 4; //in_a
		#10;
		slave_address = 5;
		slave_writedata = 1; //vect_len
		
		#10;
		slave_address = 4;
		slave_writedata = 20; //out_location
		#10;
		slave_address = 7;
		slave_writedata = 0; //no relu
		#10;
		slave_address = 0;
		slave_writedata = 0; //start
		#10;
		slave_write =0;
		#200;

		if(SDRAM[20] != 14<<<16) $display("ERROR, NOT RIGHT, VALUE IS %b SHOULD BE %b", SDRAM[20], 14<<<16);
		else $display("CORRECT");
		
	   $display ("checking RELU");
		TEST = 2;
		slave_waitrequest = 0;
		master_waitrequest = 0;
		#30;
		slave_write = 1;
		
		slave_write = 1;
		slave_address = 1;
		slave_writedata = 2; // bias vector
		#10;
		
		slave_address = 2;
		slave_writedata = 3; //weight matrix
		#10;
		slave_address = 3;
		slave_writedata = 4; //in_a
		#10;
		slave_address = 5;
		slave_writedata = 1; //vect_len
		
		#10;
		slave_address = 4;
		slave_writedata = 21; //out_location
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
		$display ("expecting 14 to be sum_temp at location 21");
		$display ("should be exact same ");
		if(SDRAM[21] != 14<<<16) $display("ERROR, NOT RIGHT, VALUE IS %b SHOULD BE %b", SDRAM[21], 14<<<16);
		else $display("CORRECT");
		
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
		master_waitrequest = 1;
		#10;
		master_waitrequest = 0;
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
		master_waitrequest = 1;
		#30;
		master_waitrequest = 0;
		#40;
		master_waitrequest = 1;
		#20;
		master_waitrequest = 0;
		#100;
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
		master_waitrequest = 1;
		#100;
		master_waitrequest = 0;
		#100;
		master_waitrequest = 1;
		#20;
		master_waitrequest = 0;
		#100;
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
		master_waitrequest = 1;
		#50;
		master_waitrequest = 0;
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
		slave_address = 5;
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
		slave_write =0;
		master_waitrequest = 1;
		#30;
		master_waitrequest = 0;
		#100;
		master_waitrequest = 1;
		#60;
		master_waitrequest = 0; 
		#400;
		
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
		master_waitrequest = 1;
		master_waitrequest = 0;
		slave_write = 1;
		slave_address = 1;
		slave_writedata = 12; // bias vector
		#10;
		
		slave_address = 2;
		slave_writedata = 12; //weight matrix
		#10;
		/*slave_address = 3;
		slave_writedata = 3; //in_a*/
		#10;
		/*slave_address = 5;
		slave_writedata = 3; //vect_len
		*/
		#10;
		slave_address = 4;
		slave_writedata = 27; //out_location
		#10;
		/*slave_address = 7;
		slave_writedata = 1; //relu*/
		#10;
		slave_address = 0;
		slave_writedata = 0; //start
		
		master_waitrequest = 1;
		#90;
		master_waitrequest = 0;
		#30;
		master_waitrequest = 1;
		#10;
		slave_write =0;
		#400;
		



	end
		
endmodule: tb_rtl_dnn
