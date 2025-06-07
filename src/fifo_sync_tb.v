`timescale 1ns/1ps

module fifo_sync_tb;

	localparam DATA_WIDTH = 8;
	localparam MEM_DEPTH = 16;
	
	reg			clk = 0;
	reg			rst = 1;
	
	reg			wr_en = 0;
	reg			rd_en = 0;
	
	reg	[7:0]	din = 0;
	wire	[7:0]	dout;
	
	wire			full;
	wire			empty;

	fifo_sync #(
		.DATA_WIDTH(DATA_WIDTH),
		.MEM_DEPTH(MEM_DEPTH)
	) fifo_sync_0 (
		.clk(clk),
		.rst(rst),
		
		.wr_en(wr_en),
		.rd_en(rd_en),
		
		.din(din),
		.dout(dout),
		
		.full(full),
		.empty(empty)

	);

	always begin
		#5 clk = ~clk;
	end

	// --- Task to write data
	task write_fifo(input [DATA_WIDTH-1:0] data_in);
	begin
		if (!full) begin
			@(posedge clk);
			din = data_in;
			wr_en = 1;
			@(posedge clk);
			wr_en = 0;
			din = 0;
		end
		else begin
			$display("Warning: FIFO is full at time %0t", $time);
		end
	end
	endtask

	// --- Task to read data
	task read_fifo(output [DATA_WIDTH-1:0] data_out, input [DATA_WIDTH-1:0] expected);
	begin
		if (!empty) begin
			@(posedge clk);
			rd_en = 1;
			@(posedge clk);
			rd_en = 0;
			#1
			data_out = dout;

			if (data_out !== expected) begin
				$display("ERROR: Read %h, but expected %h at time %0t", data_out, expected, $time);
				$fatal;
			end else begin
				$display("OK: Read %h is expected at time %0t", data_out, $time);
			end
		end
		else begin
			$display("Warning: FIFO is empty at time %0t", $time);
		end
	end
	endtask

	// --- Stimulus
	integer i;
	reg [7:0] data_read;
	initial begin

		// Reset for a short time
		#20 rst=0;
		
		// Write MEM_DEPTH-1 bytes
		for (i=0; i<MEM_DEPTH-1; i=i+1) begin
			write_fifo(8'h10 + i);
		end
		
		// Read the same data
		for (i=0; i<MEM_DEPTH-1; i=i+1) begin
			read_fifo(data_read, 8'h10 + i);
		end

		$display("===== SIMULATION PASSED SUCCESSFULLY =====");
		#20 $stop;

	end


endmodule
