// modules : adder(parametrizable), mux, inmGen, PC counter

module datapath (
    input clock, reset,
    input ALUSrc,MemtoReg,PCSrc,RegWrite,
    input [31:0] Instruction, Read_data,
    input [3:0] ALU_op,
    output [31:0] PC,ALU_result, Read_data2,
    output Zero
);
//cables de 32 bits
logic [31:0] Instruction,Immediate,PCcounter,sum_adder1,Sum,ALU_B,ALU_result,Write_data_reg,Read_data1;
//cables de 1 bit

//instanciaciones
ALU myALU(
    .op1(Read_data1),
    .op2(ALU_B),
    .ALU_result(ALU_result),
    .Zero(Zero)
);



ImmGen ImmGen (
    .Instruction(Instruction),
    .Immediate(Immediate)
);

register PC (
    .clock(clock),
    .reset(reset),
    .a(PCcounter),
    .b(PC)
);

adder #(.size(32)) adder1 (
    //EL que le suma cuatro
    .a(PC),
    .b(32'd4).
    .res(sum_adder1)
);

adder #(.size(32)) adder2 (
    .a(PC),
    .b(Immediate),
    .res(Sum)
);

mux #(.size(32)) muxPC (
    .a(sum_adder1),
    .b(Sum),
    .select(PCSrc),
    .res(PCcounter)
);

mux #(.size(32)) muxALU (
    .a(Read_data2),
    .b(Immediate),
    .select(ALUSrc),
    .res(ALU_B)
);

/*
 * Module: muxtoReg
 *    Selects the data to be stored in the Bank of Registers.
 * Inputs:
 *  a - ALUs Result 
 *  b -  Data Memory output 
 *  select - 
 *
*/
mux #(.size(32)) muxtoReg (
    .a(ALU_result),
    .b(Read_data),
    .select(MemtoReg),
    .res(Write_data_reg)
);
endmodule: datapath

module ImmGen (
    input [31:0] Instruction,
    output [31:0] Immediate
    );

case(Instruction[6:0])
    7'b0010011:         // I-Format
            Immediate = {20{Instruction[31]},Instruction[31:20]};
    7'b0000011:         // I-Format (de carga)
            Immediate = {20{Instruction[31]},Instruction[31:20]};
    7'b0100011:         // S-Format
            Immediate = {20{Instruction[31]},Instruction[31:25],Instruction[11:7]};
    7'b1100011:         // S-Format
            Immediate = {19{Instruction[31]},Instruction[31],Instruction[7],Instruction[30:25],Instruction[11:8],1'b0};
    default: Immediate = {32{1'b0}};   
endcase
endmodule: ImmGen

module register (
    input clock,reset,
    input [31:0] a,
    output [31:0] b
    );
always_ff (@posedge clock or negedge reset)
    if (!reset)
        b <= {32{1'b0}}
    else
        b <= a;

endmodule : register

module mux #(parameter size = 32) (
    input [size-1:0] a,b,
    input select,
    output [size-1:0] res
    );
assign res = (select)?b:a;
    
endmodule : mux

module adder #(parameter size = 32) (
    input [size-1:0] a,b,
    output [size-1:0] res
    );
assign res = a+b;   

endmodule : adder

