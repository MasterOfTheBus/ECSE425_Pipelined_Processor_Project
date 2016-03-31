proc AddWaves {} {
	add wave -position end /wb_tb/clk
	add wave -position end /wb_tb/s_reset
	add wave -position end /wb_tb/s_memtoReg
	add wave -position end /wb_tb/s_regWrite_in
	add wave -position end /wb_tb/s_wraddr_in
	add wave -position end /wb_tb/s_rdata
	add wave -position end /wb_tb/s_aluResult
	add wave -position end /wb_tb/s_regWrite_out
	add wave -position end /wb_tb/s_wraddr_out
	add wave -position end /wb_tb/s_writedata	
}

vlib work

vcom wb.vhd
vcom wb_tb.vhd

vsim -t ps work.wb_tb

force -deposit /wb_tb/clk 0 0 ns, 1 0.5 ns -repeat 1 ns

AddWaves

run 11ns