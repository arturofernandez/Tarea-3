class Scoreboard;
    /*!< MONITOR QUEUE DEFINITION: */
     reg [31:0] targets_queue [$]; // Infinite Queue Definition
     reg [31:0] dest_queue [$];
    // reg [2*WIDTH-1:0] ideal_output, dut_output;

    //instanciacion de la interfaz, el core y las memorias
    virtual IF.monitor mon;
    virtual RVI32_Core Core;
    virtual dmem RAM;

    function new (virtual IF.monitor mpuertos, virtual RVI32_Core mCore, virtual dmem mRAM);
        this.mon = mpuertos;
        this.Core = mCore;
        this.RAM = mRAM;
    endfunction

    //cables para las tasks
    logic [31:0] target, op1, op2, rd, target_out, dest_data_out;
    logic Zero;
    

    // op1 = Core.datapath.Registers.Regs[mon.cb_monitor.idata[19:15]]; //dato en rs1
    // op2 = Core.datapath.Registers.Regs[mon.cb_monitor.idata[24:20]]; //dato en rs2
    // rd = mon.cb_monitor.idata[11:7];
    // assign oprd = Core.datapath.Registers.Regs[mon.cb_monitor.idata[11:7]]; //dato en rd
    
    
    task monitor_input(); //cada vez que se activa el reloj miramos la instrucción para buscar el resultado correcto y comparar
        begin
            while (1) begin       
                @(mon.cb_monitor); //Disparo del evento, cuando salta ejecuto el código que le sigue                
                case (mon.cb_monitor.idata[6:0])
                    7'b0110011: //R-format
                        case ({mon.cb_monitor.idata[30],mon.cb_monitor.idata[14:12]})
                            4'b0000: //ADD
                                begin
                                    target = Core.datapath.Registers.Regs[mon.cb_monitor.idata[19:15]] + Core.datapath.Registers.Regs[mon.cb_monitor.idata[24:20]];
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end
                            4'b1000: //SUB
                                begin
                                    target = Core.datapath.Registers.Regs[mon.cb_monitor.idata[19:15]] - Core.datapath.Registers.Regs[mon.cb_monitor.idata[24:20]];
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end
                            4'b0010: //SLT
                                begin
                                    target = Core.datapath.Registers.Regs[mon.cb_monitor.idata[19:15]] - Core.datapath.Registers.Regs[mon.cb_monitor.idata[24:20]];
                                    if (target[31] == 1'b1)
                                        target = 0;
                                    else
                                       target = 1;
                                    targets_queue.push_front(target);
                                   dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end
                            4'b0011: //SLTU
                                begin
                                    if (Core.datapath.Registers.Regs[mon.cb_monitor.idata[19:15]] < Core.datapath.Registers.Regs[mon.cb_monitor.idata[24:20]])
                                        target = 0;
                                    else
                                        target = 1;
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end
                            4'b0111: //AND
                                begin
                                    target = Core.datapath.Registers.Regs[mon.cb_monitor.idata[19:15]] & Core.datapath.Registers.Regs[mon.cb_monitor.idata[24:20]];
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end
                            4'b0110: //OR
                                begin
                                    target = Core.datapath.Registers.Regs[mon.cb_monitor.idata[19:15]] | Core.datapath.Registers.Regs[mon.cb_monitor.idata[24:20]];
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end
                            4'b0100: //XOR 
                                begin
                                    target = Core.datapath.Registers.Regs[mon.cb_monitor.idata[19:15]] ^ Core.datapath.Registers.Regs[mon.cb_monitor.idata[24:20]];
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end
                            default: target = 0;
                        endcase        
                    7'b0010011: //I-format
                        case (mon.cb_monitor.idata[14:12]) 
                            3'b000: //ADDI
                                begin
                                    target = Core.datapath.Registers.Regs[mon.cb_monitor.idata[19:15]] + Core.datapath.Immediate;
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end
                            3'b010: //SLTI
                                begin
                                    target = Core.datapath.Registers.Regs[mon.cb_monitor.idata[19:15]] - Core.datapath.Immediate;
                                    if (target[31] == 1'b1)
                                        target = 0;
                                    else
                                       target = 1;
                                    targets_queue.push_front(target);
                                   dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end         
                            3'b011: //SLTIU
                                begin
                                    if (Core.datapath.Registers.Regs[mon.cb_monitor.idata[19:15]] < Core.datapath.Immediate)
                                        target = 0;
                                    else
                                        target = 1;
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end
                            3'b100: //XORI
                                begin
                                    target = Core.datapath.Registers.Regs[mon.cb_monitor.idata[19:15]] ^ Core.datapath.Immediate;
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end
                            3'b110: //ORI
                                begin
                                    target = Core.datapath.Registers.Regs[mon.cb_monitor.idata[19:15]] | Core.datapath.Immediate;
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end
                            3'b111: //ANDI
                                begin
                                    target = Core.datapath.Registers.Regs[mon.cb_monitor.idata[19:15]] & Core.datapath.Immediate;
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                end
                            default: target = 0;
                        endcase
                    // 7'b1100011: //B-format                  
                    // 7'b0000011: //Load-I-format
                    // 7'b0100011: //S-format
                    default: target = 0; 
                endcase
            end
        end
        endtask
        task monitor_output;//cada vez que habilito el fin, extraigo de la cola el valor de la raiz cuadrada calculada de modo ideal con una funcion preestablecida y lo comparo con el que da nuestro disenyo
        // begin
        //     while (1) begin       
        //         @(virtual_monitor.cb_monitor); // Control de evento
        //         if (virtual_monitor.cb_monitor.END_MULT == 1'b1) begin                    // Compruebo que la operación ha acabado
        //             target = targets_queue.pop_back();                      // Tomo el último valor de la pila de valores precalculados 
        //             dut_output = virtual_monitor.cb_monitor.S;                             // Obtengo la salida del DUT (respetando los skews de su CB)
        //             assert (dut_output == target)                           // Compruebo si son iguales con una asercion continua
        //             else $error("ERROR: the result of %d*%d=%d and DUT obtains %d",virtual_monitor.cb_monitor.A, virtual_monitor.cb_monitor.B,target,dut_output); 
        //         end
        //     end
        // end
        begin
            while (1) begin       
                @(mon.cb_monitor); //Disparo del evento, cuando salta ejecuto el código que le sigue                
                case (mon.cb_monitor.idata[6:0])
                    7'b0110011: //R-format
                        case ({mon.cb_monitor.idata[30],mon.cb_monitor.idata[14:12]})
                            4'b0000: //ADD
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = Core.datapath.Registers.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("ADD ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            4'b1000: //SUB
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = Core.datapath.Registers.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("SUB ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            4'b0010: //SLT
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = Core.datapath.Registers.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("SLT ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            4'b0011: //SLTU
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = Core.datapath.Registers.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("SLTU ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            4'b0111: //AND
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = Core.datapath.Registers.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("AND ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            4'b0110: //OR
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = Core.datapath.Registers.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("OR ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            4'b0100: //XOR 
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = Core.datapath.Registers.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("XOR ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            default: begin target_out = 0; dest_data_out = 0; assert(1==1) else $error("Si esto falla nos dejamos la carrera"); end
                        endcase
                     7'b0010011: //I-format
                        case (mon.cb_monitor.idata[14:12])
                            3'b000: //ADDI
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = Core.datapath.Registers.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("ADDI ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            3'b010: //SLTI
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = Core.datapath.Registers.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("SLTI ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            3'b011: //SLTIU
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = Core.datapath.Registers.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("SLTIU ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            3'b111: //ANDI
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = Core.datapath.Registers.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("ANDI ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            3'b110: //ORI
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = Core.datapath.Registers.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("ORI ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            3'b100: //XORI
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = Core.datapath.Registers.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out == target_out)
                                    else $error("XORI ERROR: the result should be %d and DUT obtains %d",target_out,dest_data_out);
                                end
                            default: begin target_out = 0; dest_data_out = 0; assert(1==1) else $error("Si esto falla nos dejamos la carrera"); end
                        endcase
                    // 7'b1100011: //B-format                  
                    // 7'b0000011: //Load-I-format
                    // 7'b0100011: //S-format
                    default: begin target_out = 0; dest_data_out = 0; assert(1==1) else $error("Si esto falla nos dejamos la carrera"); end
                endcase
            end
        end
    endtask
endclass