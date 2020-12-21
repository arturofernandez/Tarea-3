vlog -work work -vopt -sv -cover sbcet3 {imem.sv}
vlog -work work -vopt -sv -cover sbcet3 {tb_ROM.sv}
vsim -novopt work.tb_ROM
add wave -position end  sim:/tb_ROM/target
add wave -position 1  sim:/tb_ROM/input_addr
add wave -position end  sim:/tb_ROM/data_out
run -all