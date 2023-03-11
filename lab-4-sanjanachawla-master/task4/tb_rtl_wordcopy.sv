
module tb_rtl_wordcopy();

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
		
		
	logic [7:0] SDRAM [0:127];
	logic start;
//logic [3:0] CPU[0:127];


		wordcopy dut(.clk(clk),
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
						 
	int i;
	logic init;
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end
	
	always_comb begin
		if(start) init = 1;
		else if (init) begin
			for(i = 0; i < 64; i = i +1)
				SDRAM[i] = i;
				init = 0;
			end
		else if (master_read) begin
			master_readdata[7:0] <= SDRAM[master_address +3];
			master_readdata[15:8] <= SDRAM[master_address +2];
			master_readdata[23:16] <= SDRAM[master_address +1];
			master_readdata[31:24] <= SDRAM[master_address];
			master_readdatavalid = 1;
		end
		else if (master_write) begin
			SDRAM[master_address] <= master_writedata[31:24];
			SDRAM[master_address +1] <= master_writedata[23:16];
			SDRAM[master_address +2] <= master_writedata[15:8];
			SDRAM[master_address+3] <= master_writedata[7:0];
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

		slave_waitrequest = 0;
		master_waitrequest = 0;
		#30;
		slave_write = 1;
		
		slave_write = 1;
		slave_address = 1;
		slave_writedata = 2; //destination address
		#10;
		
		slave_address = 2;
		slave_writedata = 3; //value to write;
		#10;
		slave_address = 3;
		slave_writedata = 4; //num copies
		#10;
		slave_address = 0;
		slave_writedata = 1; //write to 0 to initialize.
		#10;
		slave_write =0;
		
		#200;
		//checking repeats
		slave_write = 1;
		slave_address = 1;
		slave_writedata = 24;
		#10;
		slave_address = 0;
		slave_writedata = 1;
		#10;
		slave_write = 0;
		
		#300;
		//checking repeats
		slave_write = 1;
		
		slave_address = 1;
		slave_writedata = 28;
		#10;
		slave_address = 0;
		slave_writedata = 1;
		master_waitrequest =1;
		#50;
		master_waitrequest = 0;
		#30;
		master_waitrequest = 1;
		#10;
		master_wait_request = 0;
		#10;
		slave_write = 0;
		#300;
		
		
		//checking diff values
		slave_write = 1;

		slave_address = 1;
		slave_writedata = 44; //destination address
		#10;
		
		slave_address = 2;
		slave_writedata = 9; //src address;
		#10;
		slave_address = 3;
		slave_writedata = 9; //num copies
		#10;
		slave_address = 0;
		slave_writedata = 1; //write to 0 to initialize.
		master_waitrequest =1;
		#100;
		master_waitrequest = 0
		#100;
		master_waitrequest = 1;
		#40;
		master_waitrequest = 0;
		#10;
		slave_write =0;
		#1000;
		
		//checking diff values
		slave_write = 1;

		slave_address = 1;
		slave_writedata = 60; //destination address
		#10;
		
		slave_address = 2;
		slave_writedata = 24; //src address;
		#10;
		slave_address = 3;
		slave_writedata = 10; //num copies
		#10;
		slave_address = 0;
		slave_writedata = 1; //write to 0 to initialize.
		master_waitrequest =1;
		#80;
		master_waitrequest = 0
		#70;
		master_waitrequest = 1;
		#20;
		master_waitrequest = 0;
		#10;
		slave_write =0;
		#1000;
		
		
		
	
	end

endmodule: tb_rtl_wordcopy
