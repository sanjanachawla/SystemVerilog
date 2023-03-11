`timescale 1ps / 1ps

module tb_rtl_ksa();


// Your testbench goes here.



logic clk;
logic rst_n;
logic en;
logic rdy;
logic [7:0] addr;
logic [7:0] wrdata;
logic wren;

logic [23:0] key;
logic [7:0] rddata;



				
	ksa tb_ksa(.clk(clk), .rst_n(rst_n), .en(en), .rdy(rdy), 
					.key(key), .addr(addr), .rddata(rddata), 
					.wrdata(wrdata), .wren(wren));
					
	 initial begin
	  assign key = 'h00033C;
	  assign rst_n = 'b1;
	  #5;
	  assign rst_n ='b0;
	  #5;
	  assign rst_n = 'b1;
	  #5;
	  assign en = 1;
	 #20;
	 assign en = 0;
	  
    end
	 
	initial begin
	  clk =0;
	  forever#5 clk =~clk;
	  end



endmodule: tb_rtl_ksa
