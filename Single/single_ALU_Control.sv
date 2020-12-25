/*
 * Module: single_ALU_Control
 *    ALU Control signals Unit
 *
 * Inputs:
 *
 *  Instruction - FUNCT3 (bits [14:12]) concatenaded with 30th bit (inside FUNCT7) of 32 bit instruction
 *  ALUOp - TODO: 
 *
 * Outputs:
 *  Operation - 4 bits cobination withc associates an instrucyion with the respective ALU operation (add, substraction etc.) 
*/
module single_ALU_Control (
    input logic [3:0] Instruction,
    input logic [2:0] ALUOp,
    output logic [3:0] Operation
);

    always_comb begin
        case (ALUOp)
            3'b000: //Instrucciones R-format
            begin
                case (Instruction)
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
                case (Instruction[2:0])
                    3'b000: Operation = 4'b0000;
                    3'b010: Operation = 4'b0010;
                    3'b011: Operation = 4'b0011;
                    3'b111: Operation = 4'b0100;
                    3'b110: Operation = 4'b0101;
                    3'b100: Operation = 4'b0110;
                    3'b001: Operation = 4'b1000; //SLLI
                    default: Operation = 4'b0000;
                endcase
            end
            3'b010: 
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