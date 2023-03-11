`timescale 1ps / 1ps

module tb_rtl_task1();

// Your testbench goes here.

logic clk;
logic rst_n;
logic en;
logic rdy;
logic [7:0] addr;
logic [7:0] wrdata;
logic wren;

logic [3:0] KEY;
logic [9:0] SW;
logic [6:0] HEX0;
logic [6:0] HEX1;
logic [6:0] HEX2;
logic [6:0] HEX3;
logic [6:0] HEX4;
logic [6:0] HEX5;
logic [9:0] LEDR;

task1 dut(.CLOCK_50(clk), .KEY(KEY), .SW(SW), .*);

initial begin

	  assign KEY = 'b1110;
	  #5;
	  assign KEY ='b0110;
	  #5;
	  assign KEY = 'b1110;
	  #5;
	  assign KEY = 'b1111;
	 #20;
	 assign KEY = 'b1110;
	  
    end
initial begin
	  clk =0;
	  forever#5 clk =~clk;
	  //$readmemh();
	  //dut.s.altsyncram_component.m_default.altsyncram_inst.mem_data;
	  end

endmodule: tb_rtl_task1
