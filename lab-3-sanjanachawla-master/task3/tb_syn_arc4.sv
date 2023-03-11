`timescale 1ps / 1ps

module tb_syn_arc4();

// Your testbench goes here.

/*
module arc4(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);
				
				*/
				
logic clk;
logic rst_n;
logic en;
logic RDY;
logic [23:0] KEY;
logic [7:0] ct_addr;
logic [7:0] pt_addr;			
logic [7:0] pt_rddata;
logic [7:0] pt_wrdata;
logic pt_wren;
				
	
				
/*
arc4try2 arc4try2dut(.clk(clk), .rst_n(rst_n), .en(en), .rdy(RDY), .key(KEY), .ct_addr(ct_addr),
				 .ct_rddata(ct_rddata), .pt_rddata(pt_rddata), .pt_wrdata(pt_wrdata),
				 .pt_wren(pt_wren));

*/
arc4 arc4dut(.clk(clk), .rst_n(rst_n), .en(en), .rdy(RDY), .key(KEY), .ct_addr(ct_addr),
				 .ct_rddata(ct_rddata), .pt_rddata(pt_rddata), .pt_wrdata(pt_wrdata),
				 .pt_wren(pt_wren));
//logic clk;
//logic rst_n;
//logic en;
//logic rdy;
//logic [7:0] addr;
//logic [7:0] wrdata;
//logic wren;

//logic [3:0] KEY;
logic [9:0] SW;
logic [6:0] HEX0;
logic [6:0] HEX1;
logic [6:0] HEX2;
logic [6:0] HEX3;
logic [6:0] HEX4;
logic [6:0] HEX5;
logic [9:0] LEDR;
				 
	//task2 dut(.CLOCK_50(clk), .KEY(KEY), .SW(SW), .*);
				
	//init tb_init(.clk(clk), .rst_n(rst_n), .en(en), .rdy(rdy), 
	//				.addr(addr), .wrdata(wrdata), .wren(wren));
					
	 initial begin
	  assign KEY = 'h00033C;
	  assign rst_n = 1;
	  assign en = 0;
	  #5;
	  assign rst_n = 0;
	  #5;
	  assign rst_n = 1;
	  #5;
	  assign  en = 1;
	  #5;
	  assign  en = 0;
	  
    end
	 
	initial begin
	  clk =0;
	  forever#5 clk =~clk;
	  //$readmemh();
	  //dut.s.altsyncram_component.m_default.altsyncram_inst.mem_data;
	  end


endmodule: tb_syn_arc4
