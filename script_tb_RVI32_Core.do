
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
# vlog -work work -vopt -sv -cover sbcet3 {Scoreboard.sv}
vlog -work work -vopt -sv -cover sbcet3 {Scoreboard_sencillo.sv}
vlog -work work -vopt -sv -cover sbcet3 {tb_RVI32_Core.sv}
vlog -work work -vopt -sv -cover sbcet3 {ForwardingUnit.sv}
vlog -work work -vopt -sv -cover sbcet3 {ForwardingBranchUnit.sv}
vlog -work work -vopt -sv -cover sbcet3 {hazardUnit.sv}
vlog -work work -vopt -sv -cover sbcet3 {Comparador.sv}

# Single Cycle Compilation
vlog -work work -vopt -sv -cover sbcet3 {./Single/single_ALU_Control.sv}
vlog -work work -vopt -sv -cover sbcet3 {./Single/single_ALU.sv}
vlog -work work -vopt -sv -cover sbcet3 {./Single/single_banco_registros.sv}
vlog -work work -vopt -sv -cover sbcet3 {./Single/single_Control.sv}
vlog -work work -vopt -sv -cover sbcet3 {./Single/single_Controlpath.sv}
vlog -work work -vopt -sv -cover sbcet3 {./Single/single_datapath.sv}
vlog -work work -vopt -sv -cover sbcet3 {./Single/single_dmem.sv}
vlog -work work -vopt -sv -cover sbcet3 {./Single/single_imem.sv}
vlog -work work -vopt -sv -cover sbcet3 {./Single/single_RVI32_Core.sv}

# CMD to execute Fibonacci program: vsim -novopt work.tb_RVI32_Core +FIBONACCI
# CMD to execute Buble program: vsim -novopt work.tb_RVI32_Core +BUBLE
# CMD to execute Fibonacci program: vsim -novopt work.tb_RVI32_Core +PROG_FILE="filename"

vsim -novopt work.tb_RVI32_Core 

add wave -position 1  sim:/tb_RVI32_Core/CLK
add wave -position 2  sim:/tb_RVI32_Core/RESET_N
add wave -position 3  sim:/tb_RVI32_Core/idata
add wave -position 4  sim:/tb_RVI32_Core/ddata_r
add wave -position 5  sim:/tb_RVI32_Core/iaddr
add wave -position 6  sim:/tb_RVI32_Core/daddr
add wave -position 7  sim:/tb_RVI32_Core/ddata_w
add wave -position 8  sim:/tb_RVI32_Core/Core/ForwardA
add wave -position 9  sim:/tb_RVI32_Core/Core/ForwardB
add wave -position 10  sim:/tb_RVI32_Core/Core/ControlBubble_EX
add wave -position 11  sim:/tb_RVI32_Core/Core/IF_IDWrite
add wave -position 12  sim:/tb_RVI32_Core/Core/Controlpath/ControlSrc
add wave -position 13  sim:/tb_RVI32_Core/Core/datapath/ALU_A_final
add wave -position 14  sim:/tb_RVI32_Core/Core/datapath/ALU_B_final
add wave -position 15  sim:/tb_RVI32_Core/Core/datapath/ALU_result
add wave -position end  sim:/tb_RVI32_Core/d_rw
run -all