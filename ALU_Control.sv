module ALU_Control (
    input logic [3:0] Instruction,
    input logic [2:0] ALUOp,
    output logic [3:0] Operation
);

    always_comb begin
        case (ALUOp)
            3'b000: //Instrucciones R-format
            begin
                case (Instruction) //Los 4 bits de la instrucción son el bit 30 concantenado con los bits [14:12]
                    4'b0000: Operation = 4'b0000; //ADD
                    4'b1000: Operation = 4'b0001; //SUB
                    4'b0010: Operation = 4'b0010; //SLT
                    4'b0011: Operation = 4'b0011; //SLTU
                    4'b0111: Operation = 4'b0100; //AND
                    4'b0110: Operation = 4'b0101; //OR
                    4'b0100: Operation = 4'b0110; //XOR
                    4'b0101: Operation = 4'b0111; //SRL
                    4'b0001: Operation = 4'b1000; //SLL
                    4'b1101: Operation = 4'b1001; //SRA 
                    
                    default: Operation = 4'b0000;
                endcase
            end
            3'b001: //Instrucciones I-format
            begin
                case (Instruction[2:0]) // El funct3
                    3'b000: Operation = 4'b0000; //ADDI
                    3'b010: Operation = 4'b0010; //SLTI
                    3'b011: Operation = 4'b0011; //TODO: REVISAR
                    3'b111: Operation = 4'b0100; //ANDI
                    3'b110: Operation = 4'b0101; //ORI
                    3'b100: Operation = 4'b0110; //XORI
                    3'b001: Operation = 4'b1000; //SLLI
                    3'b101: 
                        begin
                            if (Instruction[3]) //Bit 30
                                Operation = 4'b1001; //SRAI
                            else
                                Operation = 4'b0111; //SRLI
                        end

                    default: Operation = 4'b0000;
                endcase
            end
            3'b010: //Instrucciones B-format
            begin
                case (Instruction[2:0]) // El funct3
                    3'b000: //BEQ
                        Operation = 4'b0001; //SUB
                    3'b001: //BNE
                        Operation = 4'b0001; //SUB
                    3'b100: //BLT
                        Operation = 4'b0010; //SLT
                    3'b101: //BGE
                        Operation = 4'b0010; //SLT
                    3'b110: //BLTU
                        Operation = 4'b0011; //SLTU
                    3'b111: //BGEU
                        Operation = 4'b0011; //SLTU
                    default: Operation = 4'b0000;
                endcase
            end
            3'b011: Operation = 4'b0000; //Load-I format y S-format
            3'b100: Operation = 4'b0000; //U-format
            3'b101: Operation = 4'b0000; //UJ-format (jal, jalr)
            default: Operation = 4'b0000;  
        endcase
    end
endmodule