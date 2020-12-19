module Controlpath (
    input logic clock,
    input logic [31:0] Instruction,
    input logic Zero,
    output logic MemRead,
    output logic MemtoReg,
    output logic MemWrite,
    output logic MemWrite_EX,
    output logic ALUSrc,
    output logic RegWrite,
    output logic Jump,
    output logic [3:0] Operation,
    output logic [1:0] PCSrc,
    output logic [1:0] AuipcLui,
    output logic [1:0] ForwardA, 
    output logic [1:0] ForwardB
); 

    logic [31:0] Instruction_EX, Instruction_MEM, Instruction_WB;
    logic Branch_ID, MemtoReg_ID, ALUSrc_ID, RegWrite_ID, Jump_ID;
    logic MemRead_ID, MemWrite_ID;
    logic MemRead_EX; 
    logic MemtoReg_EX, RegWrite_EX, Branch_EX, Jump_EX;
    logic Zero_MEM, MemtoReg_MEM, RegWrite_MEM, Branch_MEM, Jump_MEM;
    logic [1:0] AuipcLui_ID;
    logic [2:0] ALUOp_ID, ALUOp;

    always_comb begin
        if (Branch_MEM) begin
            case (Instruction_MEM[14:12])
                3'b000:begin //BEQ
                    if (Zero_MEM) //la codificamos como una SUB
                        PCSrc = 2'b01;
                    else
                        PCSrc = 2'b00;
                end
                3'b001:begin //BNE
                    if (!Zero_MEM) //la codificamos como una SUB
                        PCSrc = 2'b01;
                    else
                        PCSrc = 2'b00;
                end
                3'b100:begin //BLT
                    if (!Zero_MEM) //la codificamos como una SLT
                        PCSrc = 2'b01;
                    else 
                        PCSrc = 2'b00;
                end
                3'b101:begin //BGE
                    if (Zero_MEM) //la codificamos como una SLT
                        PCSrc = 2'b01;
                    else
                        PCSrc = 2'b00;
                end
                3'b110:begin //BLTU
                    if (!Zero_MEM) //la codificamos como una SLTU
                        PCSrc = 2'b01;
                    else
                        PCSrc = 2'b00;
                end
                3'b111:begin //BGEU
                    if (Zero_MEM) //la codificamos como una SLTU
                        PCSrc = 2'b01;
                    else
                        PCSrc = 2'b00;
                end
                default: PCSrc = 2'b00;
            endcase
        end
        else if (Jump_MEM)
            case (Instruction_MEM[6:0])
                7'b1101111: //JAL
                    PCSrc = 2'b10;
                7'b1100111: //JALR
                    PCSrc = 2'b10;
                default: PCSrc = 2'b00;
            endcase
        else
            PCSrc = 2'b00;
    end

    Control Control(
        .Instruction(Instruction[6:0]),
        .Branch(Branch_ID),
        .MemRead(MemRead_ID),
        .MemtoReg(MemtoReg_ID),
        .ALUOp(ALUOp_ID),
        .MemWrite(MemWrite_ID),
        .ALUSrc(ALUSrc_ID),
        .RegWrite(RegWrite_ID),
        .AuipcLui(AuipcLui_ID),
        .Jump(Jump_ID)
    );

    ALU_Control ALU_Control(
        .Instruction({Instruction_EX[30],Instruction_EX[14:12]}),
        .ALUOp(ALUOp),
        .Operation(Operation)
    );

    ForwardingUnit ForwardingUnit(
        .Rs1_EX(Instruction_EX[19:15]), 
        .Rs2_EX(Instruction_EX[24:20]), 
        .Rd_MEM(Instruction_MEM[11:7]), 
        .Rd_WB(Instruction_WB[11:7]), 
        .RegWrite_MEM(RegWrite_MEM),
        .RegWrite_WB(RegWrite),
        .ForwardA(ForwardA), 
        .ForwardB(ForwardB)
    );

    always_ff @(posedge clock)
        begin
            //IF-ID
            //ID-EX
            Instruction_EX <= Instruction;
            MemRead_EX <= MemRead_ID;
            MemtoReg_EX <= MemtoReg_ID;
            MemWrite_EX <= MemWrite_ID;
            ALUSrc <= ALUSrc_ID;
            RegWrite_EX <= RegWrite_ID;
            Branch_EX <= Branch_ID;
            AuipcLui <= AuipcLui_ID;
            ALUOp <= ALUOp_ID;
            Jump_EX <= Jump_ID;
            //EX_MEM
            Instruction_MEM <= Instruction_EX;
            Zero_MEM <= Zero;
            MemRead <= MemRead_EX;
            MemtoReg_MEM <= MemtoReg_EX;
            MemWrite <= MemWrite_EX;
            RegWrite_MEM <= RegWrite_EX;
            Branch_MEM <= Branch_EX;
            Jump_MEM <= Jump_EX;
            //MEM-WB
            Instruction_WB <= Instruction_MEM;
            MemtoReg <= MemtoReg_MEM;
            RegWrite <= RegWrite_MEM;
            Jump <= Jump_MEM;
        end

endmodule