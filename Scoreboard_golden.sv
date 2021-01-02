class Scoreboard_golden;
    /*!< MONITOR QUEUEs DEFINITION: */
    reg [31:0] res_queue [$]; // Infinite Queue Definition
    reg [9:0] dest_queue [$];
    reg [9:0] daddr_queue [$];
    reg [31:0] inst_queue [$];
    reg [31:0] inst_pipe_queue [$];
    reg [31:0] PC_queue [$];
    reg bubble_queue [$];

    /*!< Interface Instance: */
    virtual IF.monitor mon;

    function new (virtual IF.monitor mpuertos);
        this.mon = mpuertos;
    endfunction
    
    /*!< Class members: */
    logic [31:0] res_out, inst_out, inst_pipe_out, PC_out; 
    logic [9:0] daddr_out, dest_out; 
    logic bubble_out; 
    bit errRAM, errRegs;
    
    task monitor_input(); // Saves Golden Inputs 
        begin
            while (1) begin       
                @(posedge mon.CLK); 
                inst_queue.push_front(mon.cb_monitor.Gidata); //Push the 32 bit instruction 
                daddr_queue.push_front(mon.cb_monitor.Gdaddr[11:2]); //Push the write addres for the RAM
            end
        end
    endtask 
    
    task monitor_golden(); // Queues Golden Model results to be compared with DUT
        begin
            while (1) begin       
                @(posedge mon.CLK);     
                inst_out = inst_queue.pop_back();
                daddr_out = daddr_queue.pop_back();
                inst_pipe_queue.push_front(mon.cb_monitor.idata);
                bubble_queue.push_front(mon.cb_monitor.BubbleDetector);
                PC_queue.push_front(mon.cb_monitor.iaddr[11:2]);

                if (inst_out[6:0] == 7'b1100011 || inst_out[6:0] == 7'b1101111 || inst_out[6:0] == 7'b1100111) begin // Branch and Jump
                    res_queue.push_front(mon.cb_monitor.Giaddr[11:2]); // Next PC (with jump or not jump)
                    dest_queue.push_front(10'b0); // Random numer (we do not need it)
                end
                else if (inst_out[6:0] == 7'b0100011) begin // S-Format (Escritura en memoria)
                    res_queue.push_front(mon.cb_monitor.GRAM[daddr_out]); // Content stored in the Addr
                    dest_queue.push_front(daddr_out); // Write Address
                end
                else begin // Resto de formatos (Escritura en Registros)
                    res_queue.push_front(mon.cb_monitor.GRegs[inst_out[11:7]]); // Content on Rd
                    dest_queue.push_front(inst_out[11:7]); // Rd
                end
            end
        end
    endtask 

    task monitor_dut_output(); // Compares Golden and DUT outputs
        begin    
            while (1) begin       
                @(posedge mon.CLK);     
                dest_out = dest_queue.pop_back();
                res_out = res_queue.pop_back();
                inst_pipe_out = inst_pipe_queue.pop_back();
                bubble_out = bubble_queue.pop_back();
                PC_out = PC_queue.pop_back();
                
                if (bubble_out === 1'b0) begin //Detectamos burbuja para no realizar comprobaciones
                    $display("      BUBLE Detected");
                    // assert (1 !== 1)
                    // else $error("      BUBLE Detected");
                    res_queue.push_back(res_out);
                    dest_queue.push_back(dest_out);
                end
                else if (inst_pipe_out[6:0] == 7'b1100011 || inst_pipe_out[6:0] == 7'b1101111 || inst_pipe_out[6:0] == 7'b1100111) begin // Branch and Jump
                    bubble_out = bubble_queue.pop_back();
                    if(bubble_out === 1'b1) begin //salto no efectivo (NextPC == PC+4), no hay burbuja
                        assert (PC_out === res_out)
                        else $error("       PC ERROR: the result should be %0d and DUT obtains %0d",res_out,PC_out);
                    end
                    else begin //salto efectivo (NextPC == PC+imm), hay burbuja
                        PC_out = PC_queue.pop_back();
                        assert (PC_out === res_out)
                        else $error("       PC ERROR: the result should be %0d and DUT obtains %0d",res_out,PC_out);
                        PC_queue.push_back(PC_out);
                    end
                    bubble_queue.push_back(bubble_out);
                end
                else if (inst_pipe_out[6:0] == 7'b0100011) begin // S-Format (Escritura en memoria)
                    assert (mon.cb_monitor.RAM[dest_out] === res_out)
                    else $error("       RAM ERROR: the result should be %0d and DUT obtains %0d",res_out,mon.cb_monitor.RAM[dest_out]);
                end
                else begin // Resto de formatos (Escritura en Registros)
                    if (res_out !== 32'bx && dest_out !== 10'bx) begin
                        assert (mon.cb_monitor.Regs[dest_out] === res_out)
                        else $error("       Regs ERROR: the result should be %0d and DUT obtains %0d",res_out,mon.cb_monitor.Regs[dest_out]);
                    end
                    else
                        begin
                            $display("      XXXXXXXX Instruction");
                            // assert (1 !== 1)
                            // else $error("      XXXXXXXX Instruction");
                        end
                end
            end
        end
    endtask 

    // Task: monitor_Regs
    // Compares Golden Model Register Bank with DUTs Register Bank at the end of the program execution
     task monitor_Regs(); 
        begin
            errRegs = 0;
            for (int i = 0; i < 32; i++) begin
                assert (mon.cb_monitor.Regs[i] === mon.cb_monitor.GRegs[i])
                else begin 
                    errRegs = 1; 
                    $error("      REG[%0d] ERROR: the result should be %0d and DUT obtains %0d",i,mon.cb_monitor.GRegs[i],mon.cb_monitor.Regs[i]);
                end
            end
            if (!errRegs) $display("     Golden Model and DUT Register Bank match");
        end 
     endtask

    // Task: monitor_RAM
    // Compares Golden Model RAM with DUTs RAM at the end of the program execution
     task monitor_RAM();
        begin 
            errRAM = 0;
            for (int j = 0; j < 1024; j++) begin
                assert (mon.cb_monitor.RAM[j] === mon.cb_monitor.GRAM[j]) 
                else begin
                    errRAM = 1;    
                    $error("      RAM[%0d] ERROR: the result should be %0d and DUT obtains %0d",j,mon.cb_monitor.GRAM[j],mon.cb_monitor.RAM[j]);
                end
            end
            if(!errRAM) $display("     Golden Model and DUT RAM match");
        end
    endtask
endclass