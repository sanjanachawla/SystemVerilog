module tb_task5();

// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 100,000 ticks (equivalent to "initial #100000 $finish();").

logic CLOCK_50;
logic [3:0] KEY;
logic [9:0] LEDR;
logic [6:0] HEX0;
logic [6:0] HEX1;
logic [6:0] HEX2;
logic [6:0] HEX3;
logic [6:0] HEX4;
logic [6:0] HEX5;

//module task5(input CLOCK_50, input[3:0] KEY, output[9:0] LEDR,
//            output[6:0] HEX5, output[6:0] HEX4, output[6:0] HEX3,
 //           output[6:0] HEX2, output[6:0] HEX1, output[6:0] HEX0);
				
task5 task5_dut(.CLOCK_50(CLOCK_50), .KEY(KEY), .LEDR(LEDR), 
					 .HEX5(HEX5), .HEX4(HEX4), .HEX3(HEX3), 
					 .HEX2(HEX2), .HEX1(HEX1), .HEX0(HEX0),);
					 
	initial begin
	
	//testing at initial moment? :$
	
	assert (LEDR ===0);
	assert (HEX0 ===0);
	assert (HEX1 ===0);
	assert (HEX2 ===0);
	assert (HEX3 ===0);
	assert (HEX4 ===0);
	assert (HEX5 ===0);
	
	end
						
endmodule

