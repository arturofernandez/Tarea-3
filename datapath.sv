/*
 * Module: Data Path
 *    Englobes all the intances of the Data Path Modules.
*/
module datapath 
(
    input clock, reset, ALUSrc ,MemtoReg, PCSrc, RegWrite,
    input [31:0] Instruction, Read_data,
    input [3:0] ALU_operation,
    output [31:0] PC, ALU_result, Read_data2,
    output Zero
);
    logic [31:0] Instruction, Immediate, next_PC, current_PC, effective_addr, Sum,ALU_B, ALU_result, Write_data_reg, Read_data1;

    /*
    * Module: ALU
    *    Main RISC-V Arithmetic Logic Unit 
    * Inputs:
    *   Op1: First instruction operand.
    *   Op2: Second instruction operand.
    * Outputs:
    *   ALU_result
    *   Zero: Sets to high if the result is 0. 
    */
    ALU ALU (.ALU_operation(ALU_operation), .op1(Read_data1), .op2(ALU_B), .ALU_result(ALU_result), .Zero(Zero));

    
    banco_registros Registers (.CLK(clock), .RESET(reset), .ReadReg1(Instruction[19:15]), .ReadReg2(Instruction[24:20]), .WriteReg(Instruction[11:7]), .WriteData(Write_data_reg), .RegWrite(RegWrite), .ReadData1(Read_data1), .ReadData2(Read_data2));

    /*
    * Module: ImmGen
    *    Generates the immediate sign extension obtained form the instruction decode. 
    * Inputs:
    *   Instruction: Intruction to be processed.
    * Outputs:
    *   Immediate 
    */
    ImmGen ImmGen (.Instruction(Instruction), .Immediate(Immediate));

    /*
    * Module: PC
    *    Stores the address of the next instruction to be executed. 
    * Inputs:
    *   clock: Syncronization signal.
    *   reset
    *   next_PC: Program Counter Register input.
    * Outputs:
    *   current_PC: Next Instruction Address. 
    */
    register PC (.clock(clock), .reset(reset), .a(next_PC), .b(current_PC));

    /*
    * Module: adder1
    *    Calculates the PC counter.
    * Inputs:
    *   current_PC: Addr of the next instrucion to be read.
    * Outputs:
    *   PC: Next Instruction Address. 
    */
    adder #(.size(32)) adder1 (.a(current_PC), .b(32'd4). .res(sum_adder1));

    /*
    * Module: adder2
    *    Calculates the Effective Adrres. (for Branch Instructions)
    * Inputs:
    *   current_PC: output of the PC Register.
    *   Immediate: output of the Inmediate Generator module.
    * Outputs:
    *   effective_addr: current_PC + Immediate * 4. 
    */
    adder #(.size(32)) adder2 ( .a(current_PC), .b(Immediate), .res(effective_addr));

    /*
    * Module: muxPC
    *    Selects the type of PC Source (Effective adrres = PC + imm*4 or not PC + 4)
    * Inputs:
    *   Incremented PC: Current PC + 4.
    *   effective_addr: PC + (Inmediate Value)*4.
    *   PCSrc: Control signal. (If Branch Instruction its value is high)
    * Outputs:
    *   next_PC: Next Instruction Address to be loaded into PC Register. 
    */
    mux #(.size(32)) muxPC ( .a(sum_adder1), .b(effective_addr), .select(PCSrc), .res(next_PC));

    /*
    * Module: muxALU
    *    Selects the type of operand of the ALUs second operand (immediate or register).
    * Inputs:
    *   Read_data2: Second operand (Bank of registers output).
    *   Inmmediate: Immediate Generator output.
    *   ALUSrc: Control signal.
    * Outputs:
    *   ALU_B: ALU Second Operand. 
    */
    mux #(.size(32)) muxALU (.a(Read_data2), .b(Immediate), .select(ALUSrc), .res(ALU_B));

    /*
    * Module: muxtoReg
    *    Englobes all the intances of the Data Path Modules.
    *
    */
    mux #(.size(32)) muxtoReg (.a(ALU_result), .b(Read_data), .select(MemtoReg), .res(Write_data_reg));
endmodule:datapath

module ImmGen 
(
    input [31:0] Instruction,
    output [31:0] Immediate
);
    case(Instruction[6:0])
        7'b0010011: // I-Format Intructions:
            Immediate = {20{Instruction[31]},Instruction[31:20]};
        7'b0000011: // I-Format Intructions: 
            Immediate = {20{Instruction[31]},Instruction[31:20]};
        7'b0100011:// S-Format Intructions:
            Immediate = {20{Instruction[31]},Instruction[31:25],Instruction[11:7]};
        7'b1100011: // S-Format Intructions:
            Immediate = {19{Instruction[31]},Instruction[31],Instruction[7],Instruction[30:25],Instruction[11:8],1'b0};
        default: Immediate = {32{1'b0}};   
    endcase
endmodule:ImmGen

module register 
(
    input clock, reset,
    input [31:0] a,
    output [31:0] b
);
always_ff (@posedge clock or negedge reset)
    if (!reset)
        b <= {32{1'b0}}
    else
        b <= a;
endmodule:register

module mux #(parameter size = 32) 
(
    input [size-1:0] a, b,
    input select,
    output [size-1:0] res
);
    assign res = (select)?b:a;  
endmodule:mux

module adder #(parameter size = 32) 
(
    input [size-1:0] a, b,
    output [size-1:0] res
);
    assign res = a+b;   
endmodule:adder

