module Controlpath (
    input logic [6:0] InstructionC,
    input logic [3:0] InstructionALUC,
    input logic Zero,
    output logic MemRead,
    output logic MemtoReg,
    output logic MemWrite,
    output logic ALUSrc,
    output logic RegWrite,
    output logic [3:0] Operation
    output logic PCSrc
);

wire Branch;
wire [1:0] ALUOp;

assign PCSrc = Branch & Zero;

Control Control(
    .Instruction(InstructionC),
    .Branch(Branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .ALUOp(ALUOp),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite)
);

ALU_Control ALU_Control(
    .Instruction(InstructionALUC),
    .ALUOp(ALUOp),
    .Operation(Operation)
);

endmodule