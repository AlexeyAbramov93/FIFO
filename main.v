module main (

	input				clk,
	input				rst,
	
	input				wr_en,
	input				rd_en,
	
	input [7:0]		din,
	
	output [7:0]	dout,
	output			full,
	output			empty
	
);

	fifo_sync #(
		.DATA_WIDTH(8),
		.MEM_DEPTH(16)
	) fifo_sync_inst (
		.clk(clk),
		.rst(rst),
		.wr_en(wr_en),
		.rd_en(rd_en),
		.din(din),
		.dout(dout),
		.full(full),
		.empty(empty)
	);

endmodule
