module Controlpath (
    input logic [31:0] Instruction,
    input logic Zero,
    output logic MemRead,
    output logic MemtoReg,
    output logic MemWrite,
    output logic ALUSrc,
    output logic RegWrite,
    output logic [3:0] Operation,
    output logic PCSrc
);

wire Branch;
wire [1:0] ALUOp;

// assign PCSrc = Branch & Zero;

always_comb begin
    if (Branch) 
        begin
            if ((Instruction[14:12] == 3'b000 && Zero) || (Instruction[14:12] == 3'b001 && !Zero)) //beq y bne
                PCSrc = 1'b1;
            else 
                PCSrc = 1'b0;
        end
    else 
        PCSrc = 1'b0;
end

Control Control(
    .Instruction(Instruction[6:0]),
    .Branch(Branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .ALUOp(ALUOp),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite)
);

ALU_Control ALU_Control(
    .Instruction({Instruction[30],Instruction[14:12]}),
    .ALUOp(ALUOp),
    .Operation(Operation)
);

endmodule