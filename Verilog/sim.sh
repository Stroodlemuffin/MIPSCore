#!/bin/bash

# Create a project if it doesn't exist
if [ ! -d "work" ]; then
	vlib work 
	vmap work $PWD/work
fi

# Compile the design files
vlog -work work mainmemory.v
vlog -work work fetch.v 
vlog -work work registerfile.v
vlog -work work decode.v
vlog -work work alu.v
vlog -work work execute.v
vlog -work work loadstore.v
vlog -work work writeback.v
vlog -work work pd3_tb.v

# Simulate the top-level design 
vsim -c -lib work -do "add wave *; add wave /pd3_tb/loadstore_mod/*; add wave /pd3_tb/loadstore_mod/data_mem_module/*; add wave /pd3_tb/rf_mod/*; add wave /pd3_tb/execute_mod/*; run -all; view wave; quit" pd3_tb mainmemory 

