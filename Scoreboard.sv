class Scoreboard;
    /*!< MONITOR QUEUE DEFINITION: */
     reg [31:0] targets_queue [$]; // Infinite Queue Definition
     reg [31:0] dest_queue [$];
     reg [31:0] inst_queue [$];

    //instanciacion de la interfaz, el core y la memoria
    virtual IF.monitor mon;

    function new (virtual IF.monitor mpuertos);
        this.mon = mpuertos;
    endfunction

    //variables para las tasks
    logic [31:0] target, target_out, dest_data_out, inst_out;
    
    // mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] es el dato en rs1 (registro 1)
    // mon.cb_monitor.Regs[mon.cb_monitor.idata[24:20]] es el dato en rs2 (registro 2)
    // mon.cb_monitor.idata[11:7] es el rd (registro destino)
        
    task monitor_input(); //cada vez que se activa el reloj miramos la instrucción para buscar el resultado correcto y comparar
        begin
            while (1) begin       
                @(mon.cb_monitor); //Disparo del evento, cuando salta ejecuto el código que le sigue
                inst_queue.push_front(mon.cb_monitor.idata);              
                case (mon.cb_monitor.idata[6:0])
                    7'b0110011: //R-format
                        case ({mon.cb_monitor.idata[30],mon.cb_monitor.idata[14:12]})
                            4'b0000: //ADD
                                begin
                                    target = mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] + mon.cb_monitor.Regs[mon.cb_monitor.idata[24:20]];
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end
                            4'b1000: //SUB
                                begin
                                    target = mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] - mon.cb_monitor.Regs[mon.cb_monitor.idata[24:20]];
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end
                            4'b0010: //SLT
                                begin
                                    target = mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] - mon.cb_monitor.Regs[mon.cb_monitor.idata[24:20]];
                                    if (target[31] == 1'b1)
                                        target = 0;
                                    else
                                       target = 1;
                                    targets_queue.push_front(target);
                                   dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end
                            4'b0011: //SLTU
                                begin
                                    if (mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] < mon.cb_monitor.Regs[mon.cb_monitor.idata[24:20]])
                                        target = 0;
                                    else
                                        target = 1;
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end
                            4'b0111: //AND
                                begin
                                    target = mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] & mon.cb_monitor.Regs[mon.cb_monitor.idata[24:20]];
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end
                            4'b0110: //OR
                                begin
                                    target = mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] | mon.cb_monitor.Regs[mon.cb_monitor.idata[24:20]];
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end
                            4'b0100: //XOR 
                                begin
                                    target = mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] ^ mon.cb_monitor.Regs[mon.cb_monitor.idata[24:20]];
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end
                            default: target = 0;
                        endcase        
                    7'b0010011: //I-format
                        case (mon.cb_monitor.idata[14:12]) 
                            3'b000: //ADDI
                                begin
                                    target = mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] + mon.cb_monitor.imm;
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end
                            3'b010: //SLTI
                                begin
                                    target = mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] - mon.cb_monitor.imm;
                                    if (target[31] == 1'b1)
                                        target = 0;
                                    else
                                       target = 1;
                                    targets_queue.push_front(target);
                                   dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end         
                            3'b011: //SLTIU
                                begin
                                    if (mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] < mon.cb_monitor.imm)
                                        target = 0;
                                    else
                                        target = 1;
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end
                            3'b100: //XORI
                                begin
                                    target = mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] ^ mon.cb_monitor.imm;
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end
                            3'b110: //ORI
                                begin
                                    target = mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] | mon.cb_monitor.imm;
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end
                            3'b111: //ANDI
                                begin
                                    target = mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] & mon.cb_monitor.imm;
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end
                            default: target = 0;
                        endcase
                    7'b1100011: //B-format  
                        case (mon.cb_monitor.idata[14:12]) 
                            3'b000: //BEQ
                                begin
                                    if (mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] == mon.cb_monitor.Regs[mon.cb_monitor.idata[24:20]]) 
                                        target = mon.cb_monitor.iaddr + mon.cb_monitor.imm;
                                    else
                                        target = mon.cb_monitor.iaddr + 4;
                                    targets_queue.push_front(target);
                                end
                            3'b001: //BNE
                                begin
                                     if (mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] != mon.cb_monitor.Regs[mon.cb_monitor.idata[24:20]]) 
                                        target = mon.cb_monitor.iaddr + mon.cb_monitor.imm;
                                    else
                                        target = mon.cb_monitor.iaddr + 4;
                                    targets_queue.push_front(target);
                                end
                            default: target = 0;
                        endcase                    
                    7'b0000011: //Load-I-format
                        begin
                            target = mon.cb_monitor.RAM[mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] + mon.cb_monitor.imm];
                            targets_queue.push_front(target);
                            dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                        end
                    7'b0100011: //S-format
                        begin
                            target = mon.cb_monitor.Regs[mon.cb_monitor.idata[24:20]];
                            targets_queue.push_front(target);
                            dest_queue.push_front(mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] + mon.cb_monitor.imm);
                        end
                    default: target = 0; 
                endcase
            end
        end
        endtask

    task monitor_output; //esta task funcionará un ciclo de reloj después de la monitor_input
        begin
            while (1) begin       
                @(mon.cb_monitor); //Disparo del evento, cuando salta ejecuto el código que le sigue   
                inst_out = inst_queue.pop_back(); //Recuperamos la instrucción debido a que la comprobación se hará un ciclo después y la instrucción se actualizaría lo que daría a error en esta task         
                case (inst_out[6:0])
                    7'b0110011: //R-format
                        case ({inst_out[30],inst_out[14:12]})
                            4'b0000: //ADD
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("ADD ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            4'b1000: //SUB
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("SUB ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            4'b0010: //SLT
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("SLT ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            4'b0011: //SLTU
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("SLTU ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            4'b0111: //AND
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("AND ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            4'b0110: //OR
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("OR ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            4'b0100: //XOR 
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("XOR ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            default: begin target_out = 0; dest_data_out = 0; assert(1==1) else $error("Si esto falla nos dejamos la carrera"); end
                        endcase
                    7'b0010011: //I-format
                        case (inst_out[14:12])
                            3'b000: //ADDI
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("ADDI ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            3'b010: //SLTI
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("SLTI ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            3'b011: //SLTIU
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("SLTIU ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            3'b111: //ANDI
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("ANDI ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            3'b110: //ORI
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("ORI ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            3'b100: //XORI
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("XORI ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            default: begin target_out = 0; dest_data_out = 0; assert(1==1) else $error("Si esto falla nos dejamos la carrera"); end
                        endcase
                    7'b1100011: //B-format 
                        case (inst_out[14:12]) 
                            3'b000: //BEQ
                                begin
                                    target_out = targets_queue.pop_back();
                                    assert (target_out == mon.cb_monitor.iaddr) 
                                    else $error("BEQ ERROR: the PC should be %d and DUT points to %d",target_out,mon.cb_monitor.iaddr);
                                end
                            3'b001: //BNE
                                begin
                                    target_out = targets_queue.pop_back();
                                    assert (target_out == mon.cb_monitor.iaddr) 
                                    else $error("BNE ERROR: the PC should be %d and DUT points to %d",target_out,mon.cb_monitor.iaddr); 
                                end
                            default: target = 0;
                        endcase                                   
                    7'b0000011: //Load-I-format
                        begin
                            target_out = targets_queue.pop_back();
                            dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                            assert (target_out == dest_data_out)
                            else $error("LW ERROR: the value should be %d and DUT obtains %d",target_out,dest_data_out);
                        end
                    7'b0100011: //S-format
                        begin
                            target_out = targets_queue.pop_back();
                            dest_data_out = mon.cb_monitor.RAM[dest_queue.pop_back()];
                            assert (target_out == dest_data_out)
                            else $error("SW ERROR: the value should be %d and DUT obtains %d",target_out,dest_data_out);
                        end
                    default: begin target_out = 0; dest_data_out = 0; inst_out = 0; assert(1==1) else $error("Si esto falla nos dejamos la carrera"); end
                endcase
            end
        end
    endtask
endclass