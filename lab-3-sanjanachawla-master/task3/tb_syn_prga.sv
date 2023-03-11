module tb_syn_prga();

// Your testbench goes here.

logic clk;
logic rst_n;
logic en;
logic rdy;
logic [23:0] key;
logic [7:0] s_addr;
logic [7:0] s_rddata;
logic [7:0] s_wrdata;
logic s_wren;
logic [7:0] ct_addr;
logic [7:0] ct_rddata;
logic [7:0] pt_addr;
logic [7:0] pt_rddata; 
logic [7:0] pt_wrdata; 
logic pt_wren;


s_mem s( .address(s_addr), .clock(clk), .data(s_wrdata), .wren(s_wren), .q(s_rddata));
ct_mem ct(  .address(ct_addr), .clock(clk), .data(0), .wren(0), .q(ct_rddata));
pt_mem pt(  .address(pt_addr), .clock(clk), .data(pt_wtdata), .wren(pt_wren), .q(pt_rddata));


pgra pgra_dut(.clk(clk), .rst_n(rst_n), .en(en), .rdy(rdy), .key(key), .s_addr(s_addr), .s_rddata(s_rddata),
		.s_wrdata(s_wrdata), .s_wren(s_wren), .ct_addr(ct_addr), .ct_rddata(ct_rddata), .pt_addr(pt_addr),
		.pt_rddata(pt_rddata), .pt_wrdata(pt_wrdata), .pt_wren(pt_wren));

endmodule: tb_syn_prga
