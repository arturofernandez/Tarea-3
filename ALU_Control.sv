module ALU_Control (
    input logic [3:0] Instruction,
    input logic [1:0] ALUOp,
    output logic [3:0] Operation
);

always @(Instruction,ALUOp)
begin
case (ALUOp)
    2'b00:
    begin
        case (Instruction)
            4'b0000: Operation = 4'b0000; //ADD
            4'b1000: Operation = 4'b0001; //SUB
            4'b0010: Operation = 4'b0010; //SLT
            4'b0011: Operation = 4'b0011; //SLTU
            4'b0111: Operation = 4'b0100; //AND
            4'b0110: Operation = 4'b0101; //OR
            4'b0100: Operation = 4'b0110; //XOR
            default: Operation = 4'b0000;
        endcase
    end
    2'b01:
    begin
        case (Instruction[2:0])
            3'b000: Operation = 4'b0000;
            3'b010: Operation = 4'b0010;
            3'b111: Operation = 4'b0100;
            3'b110: Operation = 4'b0101;
            3'b100: Operation = 4'b0110;
            default: Operation = 4'b0000;
        endcase
    end
    2'b10: Operation = 4'b0001;
    2'b11: Operation = 4'b0000; 
    default: Operation = 4'b0000; 
endcase
end
endmodule