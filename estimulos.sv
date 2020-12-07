`include "Scoreboard.sv"
`include "aleatorizacion.sv"
`timescale 1ns/1ps 
program estimulos (IF.monitor monitor);
    Scoreboard sb;
    random_inst inData;

    covergroup instrucciones; 
        rformat : coverpoint({monitor.cb_monitor.idata[30],monitor.cb_monitor.idata[14:12]}) iff (monitor.cb_monitor.idata[6:0]==7'b0110011&&monitor.cb_monitor.idata[31]==1'b0&&monitor.cb_monitor.idata[29:25]==5'b0000)
        {
            bins add = {4'b0000};
            bins sub = {4'b1000};
            bins slt = {4'b0010};
            bins sltu = {4'b0011};
            bins r_xor = {4'b0100};
            bins r_or = {4'b0110};
            bins r_and = {4'b0111};
        }

        iformat : coverpoint({monitor.cb_monitor.idata[14:12]}) iff (monitor.cb_monitor.idata[6:0]==7'b0010011)
        {  
            bins addi = {3'b000};
            bins slti = {3'b010};
            bins sltui = {3'b011};
            bins xori = {3'b100};
            bins ori = {3'b110};
            bins andi = {3'b111};
        }

        iformatl : coverpoint({monitor.cb_monitor.idata[14:12]}) iff (monitor.cb_monitor.idata[6:0]==7'b0000011)
        {  
            bins lw = {3'b011};
        }

        sformat : coverpoint({monitor.cb_monitor.idata[14:12]}) iff (monitor.cb_monitor.idata[6:0]==7'b0100011)
        {  
            bins sw = {3'b010};
        }

        bformat : coverpoint({monitor.cb_monitor.idata[14:12]}) iff (monitor.cb_monitor.idata[6:0]==7'b1100011)
        {  
            bins beq = {3'b000};
            bins bne = {3'b001};
        }

        illegal_format : cross  rformat, iformat, iformatl, sformat, bformat 
        {
            illegal_bins illegal_formats = !binsof(rformat) || !binsof(iformat) || !binsof(iformatl) || !binsof(sformat) || !binsof(bformat);
        }
    endgroup

    initial begin
        sb = new(monitor);
        inData = new;
        $display("INICIO SIMULACION");

        repeat (3) @(posedge monitor.CLK);
        fork
            sb.monitor_input();
            sb.monitor_output();
        join_none  

        @(posedge monitor.CLK)
        @(negedge monitor.CLK) 
        wait(monitor.cb_monitor.idata === {32{1'bx}});
        $display("FIN SIMULACION");
        $stop;
    end
endprogram