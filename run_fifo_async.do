#pwd
#do ../../run_fifo_async.do

# -----------------------------------------------------------
#  run_fifo_async.do  –  simulation script for fifo_async_tb
# -----------------------------------------------------------

# Create a new working library (if not exists)
vlib work

# Map the "work" library
vmap work work

# Compile the design file (fifo_async.v)
vlog ../../src/fifo_async.v
# Compile the testbench file
vlog ../../src/fifo_async_tb.v

# Start simulation of the testbench
vsim work.fifo_async_tb

# Add signals to the waveform viewer
add wave /fifo_async_tb/wr_clk
add wave /fifo_async_tb/rd_clk
add wave /fifo_async_tb/wr_rst
add wave /fifo_async_tb/rd_rst
add wave /fifo_async_tb/wr_en
add wave /fifo_async_tb/rd_en
add wave -hex /fifo_async_tb/din
add wave -hex /fifo_async_tb/dout
add wave -hex /fifo_async_tb/data_read
add wave /fifo_async_tb/full
add wave /fifo_async_tb/empty

# Run simulation
run -all