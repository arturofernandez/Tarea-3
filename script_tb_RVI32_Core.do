vlog -work work -vopt -sv -cover sbcet3 {aleatorizacion.sv}
vlog -work work -vopt -sv -cover sbcet3 {ALU_Control.sv}
vlog -work work -vopt -sv -cover sbcet3 {ALU.sv}
vlog -work work -vopt -sv -cover sbcet3 {banco_registros.sv}
vlog -work work -vopt -sv -cover sbcet3 {Control.sv}
vlog -work work -vopt -sv -cover sbcet3 {Controlpath.sv}
vlog -work work -vopt -sv -cover sbcet3 {datapath.sv}
vlog -work work -vopt -sv -cover sbcet3 {dmem.sv}
vlog -work work -vopt -sv -cover sbcet3 {estimulos.sv}
vlog -work work -vopt -sv -cover sbcet3 {IF.sv}
vlog -work work -vopt -sv -cover sbcet3 {imem.sv}
vlog -work work -vopt -sv -cover sbcet3 {inData.sv}
vlog -work work -vopt -sv -cover sbcet3 {RVI32_Core.sv}
vlog -work work -vopt -sv -cover sbcet3 {Scoreboard.sv}
vlog -work work -vopt -sv -cover sbcet3 {tb_RVI32_Core.sv}

vsim -novopt work.tb_RVI32_Core
add wave -position 1  sim:/tb_RVI32_Core/CLK
add wave -position 2  sim:/tb_RVI32_Core/RESET_N
add wave -position 3  sim:/tb_RVI32_Core/idata
add wave -position 4  sim:/tb_RVI32_Core/ddata_r
add wave -position 5  sim:/tb_RVI32_Core/iaddr
add wave -position 6  sim:/tb_RVI32_Core/daddr
add wave -position 7  sim:/tb_RVI32_Core/ddata_w
add wave -position end  sim:/tb_RVI32_Core/d_rw
run -all