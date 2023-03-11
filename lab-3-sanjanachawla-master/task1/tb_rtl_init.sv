module tb_rtl_init();

// Your testbench goes here.

logic clk;
logic rst_n;
logic en1;
logic RDY1;
logic [7:0] ADDRESS1;
logic [7:0] DATA1;
logic WREN1;
logic [7:0] i;

init init_dut(.clk(clk), .rst_n(rst_n), .en(en1), .rdy(RDY1),
					.addr(ADDRESS1), .wrdata(DATA1), .wren(WREN1));
					
initial begin

	  assign rst_n =1;
	  assign en1 = 0;
	  #5;
	  assign rst_n = 0;
	  #5;
	  assign rst_n = 1;
	  #5;
	  assign en1 = 1;
	 #20;
	 assign en1 = 0;
	   $monitor(ADDRESS1, DATA1);
        /*for (int i=0; i<255; i=i+1) begin
            {ADDRESS1, DATA1} = i;
            #5;
        end*/
	if(ADDRESS1 !== DATA1) $display("ERR0R MISMATCH ADDRESS/DATA");
	
    end

/*always @(posedge clk)
if(rst_n == 0) i = 0 ;
else if(i < 255) begin
	i = i+1;
	assert ADDRESS1 == i
	assert WRDATA == ADDRESS1;
end
end*/

   /* initial begin
        $monitor(ADDRESS1, DATA1);
        for (int i=0; i<255; i=i+1) begin
            {ADDRESS1, DATA1} = i;
            #5;
        end
    end*/

initial begin
	  clk =0;
	  forever#5 clk =~clk;
	  //$readmemh();
	  //dut.s.altsyncram_component.m_default.altsyncram_inst.mem_data;
	  end
endmodule: tb_rtl_init
