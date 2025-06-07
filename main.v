module main (

	input				clk_1,
	input				clk_2,
	
	input				rst_1,
	input				rst_2,

	input				wr_en,
	input				rd_en,
	
	input [7:0]		din,
	output [7:0]	dout,
	
	output			full,
	output			empty
	
);
/*
	fifo_sync #(
		.DATA_WIDTH(8),
		.MEM_DEPTH(16)
	) fifo_sync_inst (
		.clk(clk_1),
		.rst(rst_1),
		.wr_en(wr_en),
		.rd_en(rd_en),
		.din(din),
		.dout(dout),
		.full(full),
		.empty(empty)
	);
*/

	fifo_async #(
		.DATA_WIDTH(8),
		.MEM_DEPTH(16)
	) fifo_async_inst (
		.wr_clk(clk_1),
		.wr_rst(rst_1),
		.wr_en(wr_en),
		.din(din),
		.full(full),

		.rd_clk(clk_2),
		.rd_rst(rst_2),
		.rd_en(rd_en),
		.dout(dout),
		.empty(empty)
	);
	
	
endmodule
