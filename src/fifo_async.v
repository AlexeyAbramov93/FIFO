// 1. FIFO stores up to MEM_DEPTH-1 elements, because the logic "full" compares wr_ptr_gray_next and rd_ptr_gray
// 2. MEM_DEPTH must be a power of 2, because in gray code with MEM_DEPTH = 13 two bits will bw changed (12 (bin 1100) → 0 (bin 0000))

module fifo_async #(
	parameter DATA_WIDTH = 8,
	parameter MEM_DEPTH = 16
)

(
	input wr_clk,
	input wr_rst,
	input wr_en,
	input [DATA_WIDTH-1:0] din,
	output full,

	input rd_clk,
	input rd_rst,
	input rd_en,
	output reg [DATA_WIDTH-1:0] dout,
	output empty
);

	localparam ADDR = $clog2(MEM_DEPTH);

	reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];

	reg [ADDR-1:0] wr_ptr_bin;
	reg [ADDR-1:0] rd_ptr_bin;

	reg [ADDR-1:0] wr_ptr_gray;
	reg [ADDR-1:0] rd_ptr_gray;	
		
	wire [ADDR-1:0] wr_ptr_bin_next = (wr_ptr_bin == MEM_DEPTH-1) ? 0 : wr_ptr_bin + 1;
	wire [ADDR-1:0] rd_ptr_bin_next = (rd_ptr_bin == MEM_DEPTH-1) ? 0 : rd_ptr_bin + 1;
	
	wire [ADDR-1:0] wr_ptr_gray_next = wr_ptr_bin_next^(wr_ptr_bin_next >> 1);
	wire [ADDR-1:0] rd_ptr_gray_next = rd_ptr_bin_next^(rd_ptr_bin_next >> 1);
	
	always @(posedge wr_clk) begin
		if (wr_rst) begin
			wr_ptr_bin <= 0;
			wr_ptr_gray <= 0;
		end
		else begin
			if (wr_en && !full) begin
				mem[wr_ptr_bin] <= din;
				wr_ptr_bin <= wr_ptr_bin_next;
				wr_ptr_gray <= wr_ptr_gray_next;
			end
		end
	end

	always @(posedge rd_clk) begin
		if (rd_rst) begin
			rd_ptr_bin <= 0;
			rd_ptr_gray <= 0;
		end
		else begin
			if (rd_en && !empty) begin
				dout <= mem[rd_ptr_bin];
				rd_ptr_bin <= rd_ptr_bin_next;
				rd_ptr_gray <= rd_ptr_gray_next;
			end
		end
	end
	
	reg [ADDR-1:0] wr_ptr_gray_sync_1;
	reg [ADDR-1:0] wr_ptr_gray_sync_2;	
  	// Sync of wr_ptr_gray in rd_clk domain
    always @(posedge rd_clk) begin
		if (rd_rst) begin
			wr_ptr_gray_sync_1 <= 0;
			wr_ptr_gray_sync_2 <= 0;
		end
		else begin
			wr_ptr_gray_sync_1  <= wr_ptr_gray;
			wr_ptr_gray_sync_2  <= wr_ptr_gray_sync_1;
		end
	end
	
	reg [ADDR-1:0] rd_ptr_gray_sync_1;
	reg [ADDR-1:0] rd_ptr_gray_sync_2;
 	// Sync of rd_ptr_gray in wr_clk domain
    always @(posedge wr_clk) begin
		if (wr_rst) begin
			rd_ptr_gray_sync_1 <= 0;
			rd_ptr_gray_sync_2 <= 0;
		end
		else begin
			rd_ptr_gray_sync_1  <= rd_ptr_gray;
			rd_ptr_gray_sync_2  <= rd_ptr_gray_sync_1;
		end
	end
	
	assign full = (wr_ptr_gray_next == rd_ptr_gray_sync_2);
	assign empty = (rd_ptr_gray == wr_ptr_gray_sync_2);
	
endmodule
