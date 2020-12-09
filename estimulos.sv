`include "Scoreboard.sv"
`include "aleatorizacion.sv"
`timescale 1ns/1ps 
program estimulos (IF.monitor monitor, output logic Start_Simulation);

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
        /*
        illegal_format : cross  rformat, iformat, iformatl, sformat, bformat 
        {
            illegal_bins illegal_formats = !binsof(rformat) || !binsof(iformat) || !binsof(iformatl) || !binsof(sformat) || !binsof(bformat);
        }*/
    endgroup

    Scoreboard sb;
    random_inst inData;
    instrucciones my_cg;
    logic [31:0] instt_queue [$];
    logic [31:0] inst;
    int fd, i;


task generar_inst;
        inData.opcode_const.constraint_mode(1);
        inData.I_format.constraint_mode(0);
        inData.I_format_l.constraint_mode(0);
        inData.S_format.constraint_mode(0);
        inData.B_format.constraint_mode(0);
        inData.R_format.constraint_mode(0);
        inData.randomize(); //Type of instruction to be randomized
        assert (inData.randomize()) else $fatal("Op Code Randomization failed");
        //$display("OP CODE %0b - %0t\n", inData.opcode, $time);
        case(inData.opcode)
            0:
                begin
    	            inData.R_format.constraint_mode(1);
                    inData.I_format.constraint_mode(0);
                    inData.I_format_l.constraint_mode(0);
                    inData.S_format.constraint_mode(0);
                    inData.B_format.constraint_mode(0);
                end
            1:
                begin
    	            inData.R_format.constraint_mode(0);
                    inData.I_format.constraint_mode(1);
                    inData.I_format_l.constraint_mode(0);
                    inData.S_format.constraint_mode(0);
                    inData.B_format.constraint_mode(0);
                end
            2:
                begin
    	            inData.R_format.constraint_mode(0);
                    inData.I_format.constraint_mode(0);
                    inData.I_format_l.constraint_mode(1);
                    inData.S_format.constraint_mode(0);
                    inData.B_format.constraint_mode(0);
                end
            3:
                begin
    	            inData.R_format.constraint_mode(0);
                    inData.I_format.constraint_mode(0);
                    inData.I_format_l.constraint_mode(0);
                    inData.S_format.constraint_mode(1);
                    inData.B_format.constraint_mode(0);
                end
            4:
                begin
    	            inData.R_format.constraint_mode(0);
                    inData.I_format.constraint_mode(0);
                    inData.I_format_l.constraint_mode(0);
                    inData.S_format.constraint_mode(0);
                    inData.B_format.constraint_mode(1);
                end
            default:
                begin
                    $error("ERROR: Illegar Operation Code Randomized");
                end
        endcase
        inData.randomize();
    endtask

    initial begin
        sb = new(monitor);
        inData = new;
        my_cg = new;

        Start_Simulation = 1'b0;
        $display("INIT random instruction generation - time=%0t", $time);

        fd = $fopen("./fubinachi.txt","w"); 

        if(fd) $display("   File was opened succesfully with Code: %0d",fd);
        else $display("     ERROR: File was NOT opened succesfully: %0d", fd);

        $display("   Random Instructions generated");
        for (i=0; i<12; i++) begin
            generar_inst();
            $fdisplay(fd, "%h",inData.instr);
            $display("      0x%h",inData.instr);
        end

        $fclose(fd);

        $display("END random instruction generation - time=%0t\n", $time);
        Start_Simulation = 1'b1;
        repeat (2) @(posedge monitor.CLK);
        $display("INIT verification - time=%0t", $time);

        //repeat (2) @(posedge monitor.CLK);
        fork
            sb.monitor_input();
            @(posedge monitor.CLK)
            sb.monitor_output();
        join_none  

        wait(monitor.cb_monitor.idata === {32{1'bx}});
        repeat (1) @(posedge monitor.CLK);
        $display("END verification - time=%0t\n", $time);
        $stop;
    end
endprogram