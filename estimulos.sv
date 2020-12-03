`include "Scoreboard.sv"
`timescale 1ns/1ps 
program estimulos (IF.monitor mon, RVI32_Core Core, dmem RAM);
    Scoreboard sb = new(mon, Core, RAM);

    initial begin
        // repeat(3) @(posedge mon.CLK);

        $display("INICIO SIMULACION");

        fork
            sb.monitor_input();
            @(posedge mon.CLK) sb.monitor_output();
        join_none

        $display("FIN SIMULACION");
        $stop;
    end
endprogram