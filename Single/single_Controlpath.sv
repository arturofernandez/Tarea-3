/*
 * Module: single_Controlpath
 *    Englobes all the intances of the Data Path Modules.
 *
 * Inputs:
 *
 *  Instruction - 32 bit instruction stored in the Instruction Memory (IMEM).
 *  Zero - ALU output (high if result is zero, and low for the rest of cases)
 *  
 * Outputs:
 *
 *  clock - clock signal required for synchronous events.
 *  ALUSrc - MUX select singal.
 *  MemtoReg - aa. 
 *  PCSrc - aaa.
 *  RegWrite - aaa.
 *  Instruction - 32 bit Instruction.
 *  Read_data - aa.
 *  ALU_operation - aa.
 *  RegWrite - aa.
*/
module single_Controlpath (
    input logic [31:0] Instruction,
    input logic Zero,
    output logic MemRead,
    output logic MemtoReg,
    output logic MemWrite,
    output logic ALUSrc,
    output logic RegWrite,
    output logic Jump,
    output logic [3:0] Operation,
    output logic [1:0] PCSrc,
    output logic [1:0] AuipcLui
); 

wire Branch;
wire [2:0] ALUOp;
// assign PCSrc = Branch & Zero;

// always_comb begin
//     if (Branch) 
//         begin
//             if ((Instruction[14:12] == 3'b000 && Zero) || (Instruction[14:12] == 3'b001 && !Zero)) //beq y bne
//                 PCSrc = 1'b1;
//             else 
//                 PCSrc = 1'b0;
//         end
//     else 
//         PCSrc = 1'b0;
// end

always_comb begin
        if (Branch) begin
            case (Instruction[14:12])
                3'b000:begin //BEQ
                    if (Zero) //la codificamos como una SUB
                        PCSrc = 2'b01;
                    else
                        PCSrc = 2'b00;
                end
                3'b001:begin //BNE
                    if (!Zero) //la codificamos como una SUB
                        PCSrc = 2'b01;
                    else
                        PCSrc = 2'b00;
                end
                3'b100:begin //BLT
                    if (!Zero) //la codificamos como una SLT
                        PCSrc = 2'b01;
                    else 
                        PCSrc = 2'b00;
                end
                3'b101:begin //BGE
                    if (Zero) //la codificamos como una SLT
                        PCSrc = 2'b01;
                    else
                        PCSrc = 2'b00;
                end
                3'b110:begin //BLTU
                    if (!Zero) //la codificamos como una SLTU
                        PCSrc = 2'b01;
                    else
                        PCSrc = 2'b00;
                end
                3'b111:begin //BGEU
                    if (Zero) //la codificamos como una SLTU
                        PCSrc = 2'b01;
                    else
                        PCSrc = 2'b00;
                end
                default: PCSrc = 2'b00;
            endcase
        end
        else if (Jump)
            case (Instruction[6:0])
                7'b1101111: //JAL
                    PCSrc = 2'b10;
                7'b1100111: //JALR
                    PCSrc = 2'b10;
                default: PCSrc = 2'b00;
            endcase
        else
            PCSrc = 2'b00;
    end

single_Control Control(
    .Instruction(Instruction[6:0]),
    .Branch(Branch),
    .MemRead(MemRead),
    .MemtoReg(MemtoReg),
    .ALUOp(ALUOp),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .AuipcLui(AuipcLui),
    .Jump(Jump)
);

single_ALU_Control ALU_Control(
    .Instruction({Instruction[30],Instruction[14:12]}),
    .ALUOp(ALUOp),
    .Operation(Operation)
);

endmodule