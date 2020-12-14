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

    wire Branch;
    wire [2:0] ALUOp;
    // assign PCSrc = Branch & Zero;

    always_comb begin
        case (Instruction[14:12])
            3'b000:begin //BEQ
                if (Zero)
                    PCSrc = 1'b1;
                else
                    PCSrc = 1'b0;
            end
            3'b001:begin //BNE
                if (!Zero)
                    PCSrc = 1'b1;
                else
                    PCSrc = 1'b0;
            end
            3'b100:begin //BLT
                if (op1<op2)
                    PCSrc = ;
                else 
                    PCSrc = 1'b0;
            end
        endcase
    end

    Control Control(
        .Instruction(Instruction[6:0]),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .AuipcLui(AuipcLui)
    );

    ALU_Control ALU_Control(
        .Instruction({Instruction[30],Instruction[14:12]}),
        .ALUOp(ALUOp),
        .Operation(Operation)
    );

    always_ff @(posedge CLK)
        begin
            //IF-ID
            
            //ID-EX
            
            //EX_MEM
            
            //MEM-WB
            
        end

endmodule