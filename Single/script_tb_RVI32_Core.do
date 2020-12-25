# vlog -work work -vopt -sv -cover sbcet3 {single_aleatorizacion.sv}
vlog -work work -vopt -sv -cover sbcet3 {single_ALU_Control.sv}
vlog -work work -vopt -sv -cover sbcet3 {single_ALU.sv}
vlog -work work -vopt -sv -cover sbcet3 {single_banco_registros.sv}
vlog -work work -vopt -sv -cover sbcet3 {single_Control.sv}
vlog -work work -vopt -sv -cover sbcet3 {single_Controlpath.sv}
vlog -work work -vopt -sv -cover sbcet3 {single_datapath.sv}
vlog -work work -vopt -sv -cover sbcet3 {single_dmem.sv}
vlog -work work -vopt -sv -cover sbcet3 {single_estimulos.sv}
vlog -work work -vopt -sv -cover sbcet3 {single_IF.sv}
vlog -work work -vopt -sv -cover sbcet3 {single_imem.sv}
#vlog -work work -vopt -sv -cover sbcet3 {single_inData.sv}
vlog -work work -vopt -sv -cover sbcet3 {single_RVI32_Core.sv}
#vlog -work work -vopt -sv -cover sbcet3 {single_Scoreboard.sv}
vlog -work work -vopt -sv -cover sbcet3 {single_tb_RVI32_Core.sv}

vsim -novopt work.single_tb_RVI32_Core
add wave -position 1  sim:/single_tb_RVI32_Core/CLK
add wave -position 2  sim:/single_tb_RVI32_Core/RESET_N
add wave -position 3  sim:/single_tb_RVI32_Core/idata
add wave -position 4  sim:/single_tb_RVI32_Core/ddata_r
add wave -position 5  sim:/single_tb_RVI32_Core/iaddr
add wave -position 6  sim:/single_tb_RVI32_Core/daddr
add wave -position 7  sim:/single_tb_RVI32_Core/ddata_w
add wave -position end  sim:/single_tb_RVI32_Core/d_rw
run -all