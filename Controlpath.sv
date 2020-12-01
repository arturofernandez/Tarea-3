module controlpath (
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

assign PCSrc = Branch & Zero;

control control(
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