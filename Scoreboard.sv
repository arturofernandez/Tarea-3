/*
 * Class: Scoreboard
 *    DUT input data class.
 *
 * Parameters:
 *
 *  targets_queue - Queue of the target values (sum, subtraction etc)
 *  dest_queue - 
 *  inst_queue - 
*/
class Scoreboard;
    /*!< MONITOR QUEUEs DEFINITION: */
     reg [31:0] targets_queue [$]; // Infinite Queue Definition
     reg [31:0] dest_queue [$];
     reg [31:0] inst_queue [$];

    /*!< Interface Instance: */
    virtual IF.monitor mon;

    function new (virtual IF.monitor mpuertos);
        this.mon = mpuertos;
    endfunction

    /*!< Class members: */
    logic [31:0] target, target_out, dest_data_out, inst_out;
    int num_instructions = 0; // Just to know the number of instructions executed
 
    /*
    * Task: monitor_input
    *    monitors the input stimulus of the Device under test (DUT). This function is trigered each time positive CLK edge occours.
    *
    */   
    task monitor_input(); 
        begin
            while (1) begin       
                @(posedge mon.CLK); 
                num_instructions++; 
                //$display("0x%08h", mon.cb_monitor.idata);
                inst_queue.push_front(mon.cb_monitor.idata);              
                case (mon.cb_monitor.idata[6:0])
                    7'b0110011: //R-format
                        case ({mon.cb_monitor.idata[30],mon.cb_monitor.idata[14:12]})
                            4'b0000: //ADD
                                begin
                                    target = mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] + mon.cb_monitor.Regs[mon.cb_monitor.idata[24:20]];
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                    $display("    instruction(%0d): add x%0d, x%0d,x%0d :: 0x%08h", num_instructions, mon.cb_monitor.idata[11:7],mon.cb_monitor.idata[19:15], mon.cb_monitor.idata[24:20], mon.cb_monitor.idata);
                                end
                            4'b1000: //SUB
                                begin
                                    target = mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] - mon.cb_monitor.Regs[mon.cb_monitor.idata[24:20]];
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                    $display("    instruction(%0d): sub x%0d, x%0d,x%0d :: 0x%08h", num_instructions, mon.cb_monitor.idata[11:7],mon.cb_monitor.idata[19:15], mon.cb_monitor.idata[24:20], mon.cb_monitor.idata);

                                end
                            4'b0010: //SLT
                                begin
                                    target = mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] - mon.cb_monitor.Regs[mon.cb_monitor.idata[24:20]];
                                    if (target[31] === 1'b1)
                                        target = 0;
                                    else
                                       target = 1;
                                    targets_queue.push_front(target);
                                   dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                    $display("    instruction(%0d): slt x%0d, x%0d,x%0d :: 0x%08h", num_instructions, mon.cb_monitor.idata[11:7],mon.cb_monitor.idata[19:15], mon.cb_monitor.idata[24:20], mon.cb_monitor.idata);
                                end
                            4'b0011: //SLTU
                                begin
                                    if (mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] < mon.cb_monitor.Regs[mon.cb_monitor.idata[24:20]])
                                        target = 0;
                                    else
                                        target = 1;
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                    $display("    instruction(%0d): sltu x%0d, x%0d,x%0d :: 0x%08h", num_instructions, mon.cb_monitor.idata[11:7],mon.cb_monitor.idata[19:15], mon.cb_monitor.idata[24:20], mon.cb_monitor.idata);
                                end
                            4'b0111: //AND
                                begin
                                    target = mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] & mon.cb_monitor.Regs[mon.cb_monitor.idata[24:20]];
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                    $display("    instruction(%0d): and x%0d, x%0d,x%0d :: 0x%08h", num_instructions, mon.cb_monitor.idata[11:7],mon.cb_monitor.idata[19:15], mon.cb_monitor.idata[24:20], mon.cb_monitor.idata);
                                end
                            4'b0110: //OR
                                begin
                                    target = mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] | mon.cb_monitor.Regs[mon.cb_monitor.idata[24:20]];
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                    $display("    instruction(%0d): or x%0d, x%0d,x%0d :: 0x%08h", num_instructions, mon.cb_monitor.idata[11:7],mon.cb_monitor.idata[19:15], mon.cb_monitor.idata[24:20], mon.cb_monitor.idata);

                                end
                            4'b0100: //XOR 
                                begin
                                    target = mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] ^ mon.cb_monitor.Regs[mon.cb_monitor.idata[24:20]];
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                    $display("    instruction(%0d): xor x%0d, x%0d,x%0d :: 0x%08h", num_instructions, mon.cb_monitor.idata[11:7],mon.cb_monitor.idata[19:15], mon.cb_monitor.idata[24:20], mon.cb_monitor.idata);
                                end
                            default: 
                                begin
                                    target = 0;
                                    $display("monitor_input didn't find instruction with op code: %0b", mon.cb_monitor.idata[6:0]);
                                end
                        endcase        
                    7'b0010011: //I-format
                        case (mon.cb_monitor.idata[14:12]) 
                            3'b000: //ADDI
                                begin
                                    target = mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] + mon.cb_monitor.imm;
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                    $display("    instruction(%0d): addi x%0d, x%0d,%0d :: 0x%08h ", num_instructions, mon.cb_monitor.idata[11:7],mon.cb_monitor.idata[19:15], mon.cb_monitor.imm, mon.cb_monitor.idata);
                                end
                            3'b010: //SLTI
                                begin
                                    target = mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] - mon.cb_monitor.imm;
                                    if (target[31] === 1'b1)
                                        target = 0;
                                    else
                                       target = 1;
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                    $display("    instruction(%0d): slti x%0d, x%0d,%0d :: 0x%08h ", num_instructions, mon.cb_monitor.idata[11:7],mon.cb_monitor.idata[19:15], mon.cb_monitor.imm, mon.cb_monitor.idata);
                                end         
                            3'b011: //SLTIU
                                begin
                                    if (mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] < mon.cb_monitor.imm)
                                        target = 0;
                                    else
                                        target = 1;
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                    $display("    instruction(%0d): sltiu x%0d, x%0d,%0d :: 0x%08h ", num_instructions, mon.cb_monitor.idata[11:7],mon.cb_monitor.idata[19:15], mon.cb_monitor.imm, mon.cb_monitor.idata);
                                end
                            3'b100: //XORI
                                begin
                                    target = mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] ^ mon.cb_monitor.imm;
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                    $display("    instruction(%0d): xori x%0d, x%0d,%0d :: 0x%08h ", num_instructions, mon.cb_monitor.idata[11:7],mon.cb_monitor.idata[19:15], mon.cb_monitor.imm, mon.cb_monitor.idata);
                                end
                            3'b110: //ORI
                                begin
                                    target = mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] | mon.cb_monitor.imm;
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                    $display("    instruction(%0d): ori x%0d, x%0d,%0d :: 0x%08h ", num_instructions, mon.cb_monitor.idata[11:7],mon.cb_monitor.idata[19:15], mon.cb_monitor.imm, mon.cb_monitor.idata);
                                end
                            3'b111: //ANDI
                                begin
                                    target = mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] & mon.cb_monitor.imm;
                                    targets_queue.push_front(target);
                                    dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                                    $display("    instruction(%0d): andi x%0d, x%0d,%0d :: 0x%08h ", num_instructions, mon.cb_monitor.idata[11:7],mon.cb_monitor.idata[19:15], mon.cb_monitor.imm, mon.cb_monitor.idata);
                                end
                            default: 
                                begin
                                    target = 0;
                                    $display("monitor_input didn't find instruction with op code: %0b", mon.cb_monitor.idata[6:0]);
                                end
                        endcase
                    7'b1100011: //B-format  
                        case (mon.cb_monitor.idata[14:12]) 
                            3'b000: //BEQ
                                begin
                                    if (mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] === mon.cb_monitor.Regs[mon.cb_monitor.idata[24:20]]) 
                                        target = mon.cb_monitor.iaddr + mon.cb_monitor.imm;
                                    else
                                        target = mon.cb_monitor.iaddr + 4;
                                    targets_queue.push_front(target);
                                    $display("    instruction(%0d): beq x%0d, x%0d,%0d :: 0x%08h ", num_instructions, mon.cb_monitor.idata[19:15],mon.cb_monitor.idata[24:20], (mon.cb_monitor.iaddr+mon.cb_monitor.imm), mon.cb_monitor.idata);
                                end
                            3'b001: //BNE
                                begin
                                     if (mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] !== mon.cb_monitor.Regs[mon.cb_monitor.idata[24:20]]) 
                                        target = mon.cb_monitor.iaddr + mon.cb_monitor.imm;
                                    else
                                        target = mon.cb_monitor.iaddr + 4;
                                    targets_queue.push_front(target);
                                    $display("    instruction(%0d): bne x%0d, x%0d,%0d :: 0x%08h ", num_instructions, mon.cb_monitor.idata[19:15],mon.cb_monitor.idata[24:20], (mon.cb_monitor.iaddr+mon.cb_monitor.imm), mon.cb_monitor.idata);
                                end
                            default: 
                                begin
                                    target = 0;
                                    $display("monitor_input didn't find instruction with op code: %0b", mon.cb_monitor.idata[6:0]);
                                end
                        endcase                    
                    7'b0000011: //Load-I-format
                        begin
                            target = mon.cb_monitor.RAM[mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] + mon.cb_monitor.imm];
                            targets_queue.push_front(target);
                            dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                            $display("    instruction(%0d): lw x%0d, %0d(x%0d) :: 0x%08h ", num_instructions, mon.cb_monitor.idata[11:7], mon.cb_monitor.imm, mon.cb_monitor.idata[19:15], mon.cb_monitor.idata);
                        end
                    7'b0100011: //S-format
                        begin
                            target = mon.cb_monitor.Regs[mon.cb_monitor.idata[24:20]];
                            targets_queue.push_front(target);
                            dest_queue.push_front(mon.cb_monitor.Regs[mon.cb_monitor.idata[19:15]] + mon.cb_monitor.imm);
                            $display("    instruction(%0d): sw x%0d, %0d(x%0d) :: 0x%08h ", num_instructions, mon.cb_monitor.idata[24:20], mon.cb_monitor.imm, mon.cb_monitor.idata[19:15], mon.cb_monitor.idata);
                        end
                    7'b0010111: //Auipc
                        begin
                            target = mon.cb_monitor.imm + mon.cb_monitor.iaddr;
                            targets_queue.push_front(target);
                            dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                            $display("    instruction(%0d): auipc x%0d, 0x%0h :: 0x%08h ", num_instructions, mon.cb_monitor.idata[11:7], mon.cb_monitor.imm, mon.cb_monitor.idata);
                        end
                    7'b0110111: //Lui
                        begin
                            target = mon.cb_monitor.imm;
                            targets_queue.push_front(target);
                            dest_queue.push_front(mon.cb_monitor.idata[11:7]);
                            $display("    instruction(%0d): lui x%0d, 0x%0h :: 0x%08h ", num_instructions, mon.cb_monitor.idata[11:7], mon.cb_monitor.imm, mon.cb_monitor.idata);
                        end
                    default: target = 0; 
                endcase
            end
        end
        endtask
    /*
    * Task: monitor_output
    *    monitors the output stimulus of the Device under test (DUT). This function is trigered each time positive CLK edge occours.
    *
    */ 
    task monitor_output; 
        begin
            while (1) begin       
                @(posedge mon.CLK); 
                inst_out = inst_queue.pop_back(); 
                case (inst_out[6:0])
                    7'b0110011: //R-format
                        case ({inst_out[30],inst_out[14:12]})
                            4'b0000: //ADD
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out === target_out)
                                    else $error("ADD ERROR: the result should be %0d and DUT obtains %0d",target_out,dest_data_out);
                                end
                            4'b1000: //SUB
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out === target_out)
                                    else $error("SUB ERROR: the result should be %0d and DUT obtains %0d",target_out,dest_data_out);
                                end
                            4'b0010: //SLT
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out === target_out)
                                    else $error("SLT ERROR: the result should be %0d and DUT obtains %0d",target_out,dest_data_out);
                                end
                            4'b0011: //SLTU
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out === target_out)
                                    else $error("SLTU ERROR: the result should be %0d and DUT obtains %0d",target_out,dest_data_out);
                                end
                            4'b0111: //AND
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out === target_out)
                                    else $error("AND ERROR: the result should be %0d and DUT obtains %0d",target_out,dest_data_out);
                                end
                            4'b0110: //OR
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out === target_out)
                                    else $error("OR ERROR: the result should be %0d and DUT obtains %0d",target_out,dest_data_out);
                                end
                            4'b0100: //XOR 
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out === target_out)
                                    else $error("XOR ERROR: the result should be %0d and DUT obtains %0d",target_out,dest_data_out);
                                end
                            default: begin target_out = 0; dest_data_out = 0; assert(1===1) else $error("Si esto falla nos dejamos la carrera"); end
                        endcase
                    7'b0010011: //I-format
                        case (inst_out[14:12])
                            3'b000: //ADDI
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out === target_out)
                                    else $error("ADDI ERROR: the result should be %0d and DUT obtains %0d",target_out,dest_data_out);
                                end
                            3'b010: //SLTI
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out === target_out)
                                    else $error("SLTI ERROR: the result should be %0d and DUT obtains %0d",target_out,dest_data_out);
                                end
                            3'b011: //SLTIU
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out === target_out)
                                    else $error("SLTIU ERROR: the result should be %0d and DUT obtains %0d",target_out,dest_data_out);
                                end
                            3'b111: //ANDI
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out === target_out)
                                    else $error("ANDI ERROR: the result should be %0d and DUT obtains %0d",target_out,dest_data_out);
                                end
                            3'b110: //ORI
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out === target_out)
                                    else $error("ORI ERROR: the result should be %0d and DUT obtains %0d",target_out,dest_data_out);
                                end
                            3'b100: //XORI
                                begin
                                    target_out = targets_queue.pop_back();
                                    dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                                    assert (dest_data_out === target_out)
                                    else $error("XORI ERROR: the result should be %0d and DUT obtains %0d",target_out,dest_data_out);
                                end
                            default: begin target_out = 0; dest_data_out = 0; assert(1===1) else $error("Si esto falla nos dejamos la carrera"); end
                        endcase
                    7'b1100011: //B-format 
                        case (inst_out[14:12]) 
                            3'b000: //BEQ
                                begin
                                    target_out = targets_queue.pop_back();
                                    assert (target_out === mon.cb_monitor.iaddr) 
                                    else $error("BEQ ERROR: the PC should be %0d and DUT points to %0d",target_out,mon.cb_monitor.iaddr);
                                end
                            3'b001: //BNE
                                begin
                                    target_out = targets_queue.pop_back();
                                    assert (target_out === mon.cb_monitor.iaddr) 
                                    else $error("BNE ERROR: the PC should be %0d and DUT points to %0d",target_out,mon.cb_monitor.iaddr); 
                                end
                            default: target = 0;
                        endcase                                   
                    7'b0000011: //Load-I-format
                        begin
                            target_out = targets_queue.pop_back();
                            dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                            assert (target_out === dest_data_out)
                            else $error("LW ERROR: the value should be %0d and DUT obtains %0d",target_out,dest_data_out);
                        end
                    7'b0100011: //S-format
                        begin
                            target_out = targets_queue.pop_back();
                            dest_data_out = mon.cb_monitor.RAM[dest_queue.pop_back()];
                            assert (target_out === dest_data_out)
                            else $error("SW ERROR: the value should be %0d and DUT obtains %0d",target_out,dest_data_out);
                        end
                    7'b0010111: //Auipc
                        begin
                            target_out = targets_queue.pop_back();
                            dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                            assert (target_out === dest_data_out)
                            else $error("AUIPC ERROR: the value should be %0d and DUT obtains %0d",target_out,dest_data_out);
                        end
                    7'b0110111: //Lui
                        begin
                            target_out = targets_queue.pop_back();
                            dest_data_out = mon.cb_monitor.Regs[dest_queue.pop_back()];
                            assert (target_out === dest_data_out)
                            else $error("LUI ERROR: the value should be %0d and DUT obtains %0d",target_out,dest_data_out);
                        end
                    default: begin target_out = 0; dest_data_out = 0; inst_out = 0; assert(1===1) else $error("Si esto falla nos dejamos la carrera"); end
                endcase
            end
        end
    endtask
endclass