proc AddWaves {} {
	;#Add waves we're interested in to the Wave window
    add wave -position end sim:/two_bit_tb/clk
    add wave -position end sim:/two_bit_tb/s_reset
    add wave -position end sim:/two_bit_tb/s_enable
    add wave -position end sim:/two_bit_tb/s_update
	add wave -position end sim:/two_bit_tb/s_output
    add wave -position end sim:/two_bit_tb/s_branchLSB
    add wave -position end sim:/two_bit_tb/s_updateBits
}

vlib work

;# Compile components if any
vcom two_bit_branch_history.vhd
vcom two_bit_branch_predictor.vhd
vcom two_bit_tb.vhd

;# Start simulation
vsim two_bit_tb

;# Generate a clock with 1ns period
force -deposit clk 0 0 ns, 1 0.5 ns -repeat 1 ns

;# Add the waves
AddWaves

;# Run for 50 ns
run 50ns