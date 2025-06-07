#pwd
#do ../../run_fifo_sync.do

# -----------------------------------------------------------
#  run_fifo_sync.do  –  simulation script for fifo_sync_tb
# -----------------------------------------------------------

# Create a new working library (if not exists)
vlib work

# Map the "work" library
vmap work work

# Compile the design file (fifo_sync.v)
vlog ../../src/fifo_sync.v
# Compile the testbench file
vlog ../../src/fifo_sync_tb.v

# Start simulation of the testbench
vsim work.fifo_sync_tb

# Add signals to the waveform viewer
add wave /fifo_sync_tb/clk
add wave /fifo_sync_tb/rst
add wave /fifo_sync_tb/wr_en
add wave /fifo_sync_tb/rd_en
add wave -hex /fifo_sync_tb/din
add wave -hex /fifo_sync_tb/dout
add wave -hex /fifo_sync_tb/data_read
add wave /fifo_sync_tb/full
add wave /fifo_sync_tb/empty

# Set format to HEX for all multi-bit signals
#property wave -format hex /fifo_sync_tb/din
#property wave -format hex /fifo_sync_tb/dout
#property wave -format hex /fifo_sync_tb/data_read

# Run simulation for 1000 nanoseconds
run -all