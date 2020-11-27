vlog -work work -vopt -sv -cover sbcet3 {dmem.sv}
vlog -work work -vopt -sv -cover sbcet3 {tb_RAM.sv}
vsim -novopt work.tb_RAM
add wave -position end  sim:/tb_RAM/target
add wave -position 1  sim:/tb_RAM/input_addr
add wave -position end  sim:/tb_ROM/data_out
run -all