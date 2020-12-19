/*
 * Module: Data Path
 *    Englobes all the intances of the Data Path Modules.
 *
 * Inputs:
 *
 *  clock - clock signal required for synchronous events.
 *  reset - aaa.
 *  ALUSrc - aa.
 *  MemtoReg - aa. 
 *  PCSrc - aaa.
 *  RegWrite - aaa.
 *  Instruction - aa.
 *  Read_data - aa.
 *  ALU_operation - aa.
 *  RegWrite - aa.
 *  
 * Outputs:
 *
 *  current_PC - 
 *  ALU_result - 
 *  Read_data2 -   
 *  Zero -  
*/
module datapath 
(
    input clock, reset, ALUSrc ,MemtoReg, RegWrite, Jump_RD, 
    input [1:0] AuipcLui, PCSrc, ForwardA, ForwardB,
    input [31:0] Instruction, Read_data,
    input [3:0] ALU_operation,
    output logic [31:0] current_PC, ALU_result_MEM, Read_data2_MEM,
    output logic Zero
);
    logic [31:0] Immediate, next_PC, sum_adder1, effective_addr, Sum, ALU_B, Write_data_reg, Write_data_reg2, Read_data1, ALU_A;
    logic [31:0] current_PC_ID, current_PC_EX, Immediate_EX, effective_addr_MEM, ALU_result, ALU_result_WB, Read_data2;
    logic [31:0] Instruction_EX, Instruction_MEM, Instruction_WB, sum_adder1_ID, sum_adder1_EX, sum_adder1_MEM, sum_adder1_WB;
    logic [31:0] ALU_A_final, ALU_B_final;

    /*
    * Module: ALU
    *    Main RISC-V Arithmetic Logic Unit 
    *
    * Inputs:
    *   Op1 - First instruction operand.
    *   Op2 - Second instruction operand.
    *
    * Outputs:
    *   ALU_result
    *   Zero - Sets to high if the result is 0. 
    */
    ALU ALU (.ALU_operation(ALU_operation), .op1(ALU_A_final), .op2(ALU_B_final), .ALU_result(ALU_result), .Zero(Zero));

    /*
    * Module: banco_registros
    *    Register bank of the RISC-V core 
    *
    * Inputs:
    *   CLK - Syncronization signal.
    *   RESET
    *   ReadReg1 - register 1.
    *   ReadReg2 - register 2.
    *   WriteReg - register where you write.
    *   WriteData - data you write on WriteReg.
    *   RegWrite - flag that activates writting.
    *
    * Outputs:
    *   ReadData1 - data on register 1
    *   ReadData2 - data on register 2.
    */
    banco_registros Registers (.CLK(clock), .RESET(reset), .ReadReg1(Instruction[19:15]), .ReadReg2(Instruction[24:20]), .WriteReg(Instruction_WB[11:7]), .WriteData(Write_data_reg2), .RegWrite(RegWrite), .ReadData1(Read_data1), .ReadData2(Read_data2));

    /*
    * Module: ImmGen
    *    Generates the immediate sign extension obtained form the instruction decode. 
    *
    * Inputs:
    *   Instruction - Intruction to be processed.
    *
    * Outputs:
    *   Immediate 
    */
    ImmGen ImmGen (.Instruction(Instruction), .Immediate(Immediate));

    /*
    * Module: PC
    *    Stores the address of the next instruction to be executed. 
    *
    * Inputs:
    *   clock - Syncronization signal.
    *   reset
    *   next_PC - Program Counter Register input.
    *
    * Outputs:
    *   current_PC - Next Instruction Address. 
    */
    register PC (.clock(clock), .reset(reset), .a(next_PC), .b(current_PC));

    /*
    * Module: adder1
    *    Calculates the PC counter.
    *
    * Inputs:
    *   current_PC - Addr of the next instrucion to be read.
    *
    * Outputs:
    *   PC - Next Instruction Address. 
    */
    adder #(.size(32)) adder1 (.a(current_PC), .b(32'd4), .res(sum_adder1));

    /*
    * Module: adder2
    *    Calculates the Effective Adrres. (for Branch Instructions)
    *
    * Inputs:
    *   current_PC - output of the PC Register.
    *   Immediate - output of the Inmediate Generator module.
    *
    * Outputs:
    *   effective_addr - current_PC + Immediate * 4. 
    */
    adder #(.size(32)) adder2 (.a(current_PC_EX), .b(Immediate_EX), .res(effective_addr));

    /*
    * Module: muxPC
    *    Selects the type of PC Source (Effective adrres = PC + imm*4 or not PC + 4)
    *
    * Inputs:
    *   Incremented PC - Current PC + 4.
    *   effective_addr - PC + (Inmediate Value)*4.
    *   PCSrc - Control signal. (If Branch Instruction its value is high)
    *
    * Outputs:
    *   next_PC - Next Instruction Address to be loaded into PC Register. 
    */
    MUX3 #(.size(32)) muxPC (.a(sum_adder1), .b(effective_addr_MEM), .c(ALU_result_MEM), .select(PCSrc), .res(next_PC));

    /*
    * Module: muxALU_B
    *    Selects the type of operand of the ALUs second operand (immediate or register).
    *
    * Inputs:
    *   Read_data2 -  Second operand (Bank of registers output).
    *   Inmmediate -  Immediate Generator output.
    *   ALUSrc -  Control signal.
    *
    * Outputs:
    *   ALU_B -  ALU Second Operand. 
    */
    MUX #(.size(32)) muxALU_B (.a(Read_data2), .b(Immediate_EX), .select(ALUSrc), .res(ALU_B));

    MUX3 #(.size(32)) muxALU_B2 (.a(ALU_B), .b(Write_data_reg), .c(ALU_result_MEM), .select(ForwardB), .res(ALU_B_final));
    
    /*
    * Module: muxALU_A
    *    Selects the type of operand of the ALUs first operand (pc, zeros or register).
    *
    * Inputs:
    *   Current_PC -  PC.
    *   32'b0 - Zeros.
    *   Read_data1 -  First operand (Bank of registers output).
    *   AuipcLui -  Control signal.
    *
    * Outputs:
    *   ALU_A -  ALU First Operand. 
    */
    MUX3 #(.size(32)) muxALU_A (.a(current_PC_EX), .b({32{1'b0}}), .c(Read_data1), .select(AuipcLui), .res(ALU_A));

    MUX3 #(.size(32)) muxALU_A2 (.a(ALU_A), .b(Write_data_reg), .c(ALU_result_MEM), .select(ForwardA), .res(ALU_A_final));
    
    /*
    * Module: muxtoReg
    *    Selects the type of operand of the Bank of Registers input data (ALU_Result or Read_data).
    *
    * Inputs:
    *   ALU_result -  ALU output.
    *   Read_data -  RAM output (DMEM output).
    *   MemtoReg -  Control signal.
    *
    * Outputs:
    *   Write_data_reg -  Register input data (Bank of registers input). 
    */
    MUX #(.size(32)) muxtoReg (.a(ALU_result_WB), .b(Read_data), .select(MemtoReg), .res(Write_data_reg));

    MUX #(.size(32)) muxtoReg2 (.a(Write_data_reg), .b(sum_adder1_WB), .select(Jump_RD), .res(Write_data_reg2));

    always_ff @(posedge clock)
        begin
            //IF-ID
            current_PC_ID <= current_PC;
            sum_adder1_ID <= sum_adder1;
            //ID-EX
            Instruction_EX <= Instruction;
            current_PC_EX <= current_PC_ID;
            Immediate_EX <= Immediate;
            sum_adder1_EX <= sum_adder1_ID;
            //EX_MEM
            Instruction_MEM <= Instruction_EX;
            effective_addr_MEM <= effective_addr;
            ALU_result_MEM <= ALU_result;
            Read_data2_MEM <= Read_data2;
            sum_adder1_MEM <= sum_adder1_EX;
            //MEM-WB
            Instruction_WB <= Instruction_MEM;
            ALU_result_WB <= ALU_result_MEM;
            sum_adder1_WB <= sum_adder1_MEM;
        end

endmodule:datapath

module ImmGen 
(
    input [31:0] Instruction,
    output logic [31:0] Immediate
);

always_comb begin
    case (Instruction[6:0])
        7'b0010011: // I-Format Intructions:
            Immediate = {{20{Instruction[31]}},Instruction[31:20]};
        7'b0000011: // Load I-Format Intructions: 
            Immediate = {{20{Instruction[31]}},Instruction[31:20]};
        7'b0100011: // S-Format Intructions:
            Immediate = {{20{Instruction[31]}},Instruction[31:25],Instruction[11:7]};
        7'b1100011: // B-Format Intructions:
            Immediate = {{19{Instruction[31]}},Instruction[31],Instruction[7],Instruction[30:25],Instruction[11:8],1'b0};
        7'b0010111: //U-Format (AUIPC)
            Immediate = {Instruction[31:12], {12{1'b0}}};
        7'b0110111: //U-Format (LUI)
            Immediate = {Instruction[31:12], {12{1'b0}}};
        7'b1101111: //UJ-Format (JAL)
            Immediate = {{11{Instruction[31]}},Instruction[19:12],Instruction[20],Instruction[30:21],1'b0};
        7'b1100111: //UJ-Format (JALR)
            Immediate = {{20{Instruction[31]}},Instruction[31:20]};
        default: Immediate = {32{1'b0}};   
    endcase
end
endmodule:ImmGen

module register 
(
    input clock, reset,
    input [31:0] a,
    output logic [31:0] b
);
always_ff @(posedge clock or negedge reset)
    if (!reset)
        b <= {32{1'b0}};
    else
        b <= a;
endmodule:register

module MUX #(parameter size = 32) 
(
    input [size-1:0] a, b,
    input select,
    output [size-1:0] res
);
    assign res = (select)?b:a;  
endmodule:MUX

module MUX3 #(parameter size = 32) 
(
    input [size-1:0] a, b, c,
    input [1:0] select,
    output reg [size-1:0] res
);
    always_comb begin
        case(select)
            2'b00: res = a;
            2'b01: res = b;
            2'b10: res = c;
            default: res = c;
        endcase
    end 
endmodule:MUX3

module adder #(parameter size = 32) 
(
    input [size-1:0] a, b,
    output [size-1:0] res
);
    assign res = a+b;   
endmodule:adder

