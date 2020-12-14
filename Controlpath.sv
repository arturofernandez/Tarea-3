module Controlpath (
    input logic [31:0] Instruction,
    input logic Zero,
    output logic MemRead,
    output logic MemtoReg,
    output logic MemWrite,
    output logic ALUSrc,
    output logic RegWrite,
    output logic [3:0] Operation,
    output logic PCSrc,
    output logic [1:0] AuipcLui
); 

    logic [31:0] Instruction_ID, Instruction_EX, Instruction_MEM;
    logic Branch_ID, MemRead_ID, MemtoReg_ID, MemWrite_ID, ALUSrc_ID, RegWrite_ID;
    logic MemRead_EX, MemtoReg_EX, MemWrite_EX, RegWrite_EX, Branch_EX;
    logic Zero_MEM, MemtoReg_MEM, RegWrite_MEM, Branch_MEM;
    logic [1:0] AuipcLui_ID;
    logic [2:0] ALUOp_ID, ALUOp;

    always_comb begin
        case (Instruction_MEM[14:12])
            3'b000:begin //BEQ
                if (Zero_MEM) //la codificamos como una SUB
                    PCSrc = 1'b1;
                else
                    PCSrc = 1'b0;
            end
            3'b001:begin //BNE
                if (!Zero_MEM) //la codificamos como una SUB
                    PCSrc = 1'b1;
                else
                    PCSrc = 1'b0;
            end
            3'b100:begin //BLT
                if (!Zero_MEM) //la codificamos como una SLT
                    PCSrc = 1'b1;
                else 
                    PCSrc = 1'b0;
            end
            3'b101:begin //BGE
                if (Zero_MEM) //la codificamos como una SLT
                    PCSrc = 1'b1;
                else
                    PCSrc = 1'b0;
            end
            3'b110:begin //BLTU
                if (!Zero_MEM) //la codificamos como una SLTU
                    PCSrc = 1'b1;
                else
                    PCSrc = 1'b0;
            end
            3'b111:begin //BGEU
                if (Zero_MEM) //la codificamos como una SLTU
                    PCSrc = 1'b1;
                else
                    PCSrc = 1'b0;
            end
        endcase
    end

    Control Control(
        .Instruction(Instruction_ID[6:0]),
        .Branch(Branch_ID),
        .MemRead(MemRead_ID),
        .MemtoReg(MemtoReg_ID),
        .ALUOp(ALUOp_ID),
        .MemWrite(MemWrite_ID),
        .ALUSrc(ALUSrc_ID),
        .RegWrite(RegWrite_ID),
        .AuipcLui(AuipcLui_ID)
    );

    ALU_Control ALU_Control(
        .Instruction({Instruction_EX[30],Instruction_EX[14:12]}),
        .ALUOp(ALUOp),
        .Operation(Operation)
    );

    always_ff @(posedge CLK)
        begin
            //IF-ID
            Instruction_ID <= Instruction;
            //ID-EX
            Instruction_EX <= Instruction_ID;
            MemRead_EX <= MemRead_ID;
            MemtoReg_EX <= MemtoReg_ID;
            MemWrite_EX <= MemWrite_ID;
            ALUSrc <= ALUSrc_ID;
            RegWrite_EX <= RegWrite_ID;
            Branch_EX <= Branch_ID;
            AuipcLui <= AuipcLui_ID;
            ALUOp <= ALUOp_ID;
            //EX_MEM
            Instruction_MEM <= Instruction_EX;
            Zero_MEM <= Zero;
            MemRead <= MemRead_EX;
            MemtoReg_MEM <= MemtoReg_EX;
            MemWrite <= MemWrite_EX;
            RegWrite_MEM <= RegWrite_EX;
            Branch_MEM <= Branch_EX;
            //MEM-WB
            MemtoReg <= MemtoReg_MEM;
            RegWrite <= RegWrite_MEM;
        end

endmodule