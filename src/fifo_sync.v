module fifo_sync #(
	parameter DATA_WIDTH = 8,
	parameter MEM_DEPTH = 16
)

(
	input									clk,
	input 								rst,
	
	input 								wr_en,
	input 								rd_en,
	
	input 		[DATA_WIDTH-1:0]	din,
	output reg	[DATA_WIDTH-1:0]	dout,
	
	output 								full,
	output 								empty
	
);

	localparam ADDR = $clog2(MEM_DEPTH);

	reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];

	reg [ADDR-1:0] wr_ptr;
	reg [ADDR-1:0] rd_ptr;
	
	wire [ADDR-1:0] wr_ptr_next = (wr_ptr == MEM_DEPTH-1) ? 0 : wr_ptr + 1;
	
	assign full = (wr_ptr_next  == rd_ptr);
	assign empty = (wr_ptr == rd_ptr);
	
	always @(posedge clk) begin
		if (rst) begin
			wr_ptr <= 0;
		end
		else if (wr_en && !full) begin
			mem[wr_ptr] <= din;
			
			if (wr_ptr == MEM_DEPTH-1) begin
				wr_ptr <= 0;
			end
			else begin
				wr_ptr <= wr_ptr + 1;
			end
		end
	end

	always @(posedge clk) begin
		if (rst) begin
			dout <= 0;
			rd_ptr <= 0;
		end
		else if (rd_en && !empty) begin		
			dout <= mem[rd_ptr];
			
			if (rd_ptr == MEM_DEPTH-1) begin
				rd_ptr <= 0;
			end
			else begin
				rd_ptr <= rd_ptr + 1;
			end
		end
	end
	

endmodule

