module Control (
    input logic [6:0] Instruction,
    output logic Branch,
    output logic MemRead,
    output logic MemtoReg,
    output logic [2:0] ALUOp,
    output logic MemWrite,
    output logic ALUSrc,
    output logic RegWrite,
    output logic [1:0] AuipcLui,
    output logic Jump
);

always @(Instruction)
begin
    case (Instruction)
        7'b0110011: //R-format
        begin
            Branch = 1'b0;
            MemRead = 1'b0;
            MemtoReg = 1'b0;
            ALUOp = 3'b000;
            MemWrite = 1'b0;
            ALUSrc = 1'b0;
            RegWrite = 1'b1;
            AuipcLui = 2'b10;
            Jump = 1'b0;
        end

        7'b0010011: //I-format
        begin
            Branch = 1'b0;
            MemRead = 1'b0;
            MemtoReg = 1'b0;
            ALUOp = 3'b001;
            MemWrite = 1'b0;
            ALUSrc = 1'b1;
            RegWrite = 1'b1;
            AuipcLui = 2'b10;
            Jump = 1'b0;
        end

        7'b1100011: //B-format
        begin
            Branch = 1'b1;
            MemRead = 1'b0;
            MemtoReg = 1'b0;
            ALUOp = 3'b010;
            MemWrite = 1'b0;
            ALUSrc = 1'b0;
            RegWrite = 1'b0;
            AuipcLui = 2'b10;
            Jump = 1'b0;
        end

        7'b0000011: //Load-I-format
        begin
            Branch = 1'b0;
            MemRead = 1'b1;
            MemtoReg = 1'b1;
            ALUOp = 3'b011;
            MemWrite = 1'b0;
            ALUSrc = 1'b1;
            RegWrite = 1'b1;
            AuipcLui = 2'b10;
            Jump = 1'b0;
        end

        7'b0100011: // S-format
        begin
            Branch = 1'b0;
            MemRead = 1'b0;
            MemtoReg = 1'b0;
            ALUOp = 3'b011;
            MemWrite = 1'b1;
            ALUSrc = 1'b0;
            RegWrite = 1'b0;
            AuipcLui = 2'b10;
            Jump = 1'b0;
        end

        7'b0010111: // Auipc
        begin
            Branch = 1'b0;
            MemRead = 1'b0;
            MemtoReg = 1'b0;
            ALUOp = 3'b100;
            MemWrite = 1'b0;
            ALUSrc = 1'b1;
            RegWrite = 1'b1;
            AuipcLui = 2'b00;
            Jump = 1'b0;
        end

        7'b0110111: // Lui
        begin
            Branch = 1'b0;
            MemRead = 1'b0;
            MemtoReg = 1'b0;
            ALUOp = 3'b100;
            MemWrite = 1'b0;
            ALUSrc = 1'b1;
            RegWrite = 1'b1;
            AuipcLui = 2'b01;
            Jump = 1'b0;
        end

        7'b1101111: //Instrucciones UJ (JAL)
        begin
            Branch = 1'b0;
            MemRead = 1'b0;
            MemtoReg = 1'b0;
            ALUOp = 3'b101;
            MemWrite = 1'b0;
            ALUSrc = 1'b1;
            RegWrite = 1'b1;
            AuipcLui = 2'b00;
            Jump = 1'b1;
        end

        7'b1100111: //Instrucciones UJ (JALR)
        begin
            Branch = 1'b0;
            MemRead = 1'b0;
            MemtoReg = 1'b0;
            ALUOp = 3'b101;
            MemWrite = 1'b0;
            ALUSrc = 1'b1;
            RegWrite = 1'b1;
            AuipcLui = 2'b10;
            Jump = 1'b1;
        end

        default: 
        begin
            Branch = 1'b0;
            MemRead = 1'b0;
            MemtoReg = 1'b0;
            ALUOp = 3'b000;
            MemWrite = 1'b0;
            ALUSrc = 1'b0;
            RegWrite = 1'b0;
            AuipcLui = 2'b00;
            Jump = 1'b0;
        end
    endcase
end

endmodule