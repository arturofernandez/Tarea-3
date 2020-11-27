// INSTRUCCIONES ADD, SLT, SLTU, AND, OR, XOR, SUB,
// ADDI, SLTI, SLTIU, ANDI, ORI, XORI.
// Control de flujo BEQ, BNE
// Instrucciones de carga/almacenamiento alineadas: LW, SW. NO LAS TENEMOS EN CUENTA

// INSTRUCCIONES EXTRA SLLI, SRLI, SRAI, LUI, AUIPC.
// SLL, SRL, SRA
// JAL, JALR, BLT, BLTU, BGE, BGEU.

module ALU (
    input [3:0] ALU_operation,
    input [31:0] op1,
    input [31:0] op2,
    output logic [31:0] ALU_result,
    output logic Zero
);

logic [31:0] auxSLT;

always_comb begin
    case (ALU_operation)
        4'b0000: //ADD
            ALU_result = op1 + op2;
        4'b0001:  //SUB
            ALU_result = op1 - op2;
        4'b0010:  //SLT                                        
            begin               
                auxSLT = op1-op2;      
                if (auxSLT[31] == 1'b1)  
                    ALU_result = 1;
                else
                    ALU_result = 0;
            end             
        4'b0011:  //SLTU                                      
            begin
                if(op1<op2)
                    ALU_result = 1;
                else
                    ALU_result = 0;
            end
        4'b0100:  //AND
            ALU_result = op1 & op2;
        4'b0101:  //OR
            ALU_result = op1 | op2;
        4'b0110:  //XOR
            ALU_result = op1 ^ op2;
        endcase
    end
    
assign Zero = (ALU_result == 32'b0)? 1:0; 

endmodule

































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































