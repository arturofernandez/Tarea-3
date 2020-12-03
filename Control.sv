module Control (
    input logic [6:0] Instruction,
    output logic Branch,
    output logic MemRead,
    output logic MemtoReg,
    output logic [1:0] ALUOp,
    output logic MemWrite,
    output logic ALUSrc,
    output logic RegWrite
);

always @(Instruction)
begin
    case (Instruction)
        7'b0110011: //R-format
        begin
            Branch = 1'b0;
            MemRead = 1'b0;
            MemtoReg = 1'b0;
            ALUOp = 2'b00;
            MemWrite = 1'b0;
            ALUSrc = 1'b0;
            RegWrite = 1'b1;
        end

        7'b0010011: //I-format
        begin
            Branch = 1'b0;
            MemRead = 1'b0;
            MemtoReg = 1'b0;
            ALUOp = 2'b01;
            MemWrite = 1'b0;
            ALUSrc = 1'b1;
            RegWrite = 1'b1;
        end

        7'b1100011: //B-format
        begin
            Branch = 1'b1;
            MemRead = 1'b0;
            MemtoReg = 1'b0;
            ALUOp = 2'b10;
            MemWrite = 1'b0;
            ALUSrc = 1'b0;
            RegWrite = 1'b0;
        end

        7'b0000011: //Load-I-format
        begin
            Branch = 1'b0;
            MemRead = 1'b1;
            MemtoReg = 1'b1;
            ALUOp = 2'b11;
            MemWrite = 1'b0;
            ALUSrc = 1'b1;
            RegWrite = 1'b1;
        end

        7'b0100011: // S-format
        begin
            Branch = 1'b0;
            MemRead = 1'b0;
            MemtoReg = 1'b0;
            ALUOp = 2'b11;
            MemWrite = 1'b1;
            ALUSrc = 1'b1;
            RegWrite = 1'b0;
        end

        default: 
        begin
            Branch = 1'b0;
            MemRead = 1'b0;
            MemtoReg = 1'b0;
            ALUOp = 2'b00;
            MemWrite = 1'b0;
            ALUSrc = 1'b0;
            RegWrite = 1'b0;
        end
    endcase
end

endmodule