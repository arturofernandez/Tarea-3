`include "Scoreboard.sv"
`include "aleatorizacion.sv"
`timescale 1ns/1ps 
program estimulos (IF.monitor mon);
    Scoreboard sb;
    random_inst inData;

    covergroup instrucciones; 
        rformat : coverpoint({monitor.idata[30],monitor.idata[14:12]}) iff (monitor.idata[6:0]==7'b0110011&&monitor_port.dato[31]==1'b0&&monitor_port.dato[29:25]==5'b0000)
        {
            bins add = {4'b0000};
            bins sub = {4'b1000};
            bins slt = {4'b0010};
            bins sltu = {4'b0011};
            bins r_xor = {4'b0100};
            bins r_or = {4'b0110};
            bins r_and = {4'b0111};
        }

        iformat : coverpoint({monitor.idata[14:12]}) iff (monitor.idata[6:0]==7'b0010011)
        {  
            bins addi = {3'b000};
            bins slti = {3'b010};
            bins sltui = {3'b011};
            bins xori = {3'b100};
            bins ori = {3'b110};
            bins andi = {3'b111};
        }

        iformatl : coverpoint({monitor.idata[14:12]}) iff (monitor.idata[6:0]==7'b0000011)
        {  
            bins lw = {3'b011};
        }

        sformat : coverpoint({monitor.idata[14:12]}) iff (monitor.idata[6:0]==7'b0100011)
        {  
            bins sw = {3'b010};
        }

        bformat : coverpoint({monitor.idata[14:12]}) iff (monitor.idata[6:0]==7'b1100011)
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
        // repeat(3) @(posedge mon.CLK);
        sb = new(mon);
        inData = new;
        $display("INICIO SIMULACION");

        fork
            sb.monitor_input();
            @(posedge mon.CLK) sb.monitor_output();
        join_none

        $display("FIN SIMULACION");
        $stop;
    end
endprogram