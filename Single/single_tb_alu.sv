`timescale 1ns/1ps

module tb_alu;

localparam T = 50;

logic [3:0] ALU_op;
logic signed [31:0] op1, op2;
logic signed [31:0] ALU_res;
logic zero, clock;

ALU alu (
    .ALU_operation(ALU_op),
    .op1(op1),
    .op2(op2),
    .ALU_result(ALU_res),
    .Zero(zero));

initial begin       
    clock = 1'b0;
    
    //add
    operar(clock,ALU_op,op1,op2,4'b0000,32'd12,32'd13);
    assert ((ALU_res == op1+op2) && (zero == 0)) else $error("ADD error");
    operar(clock,ALU_op,op1,op2,4'b0000,-32'd12,32'd13);
    assert ((ALU_res == op1+op2) && (zero == 0)) else $error("ADD error");
    operar(clock,ALU_op,op1,op2,4'b0000,32'd12,-32'd13);
    assert ((ALU_res == op1+op2) && (zero == 0)) else $error("ADD error");
    operar(clock,ALU_op,op1,op2,4'b0000,-32'd12,-32'd13);
    assert ((ALU_res == op1+op2) && (zero == 0)) else $error("ADD error");
    operar(clock,ALU_op,op1,op2,4'b0000,32'd12,-32'd12);
    assert ((ALU_res == op1+op2) && (zero == 1)) else $error("ADD error");
    //sub
    operar(clock,ALU_op,op1,op2,4'b0001,45,22);
    assert ((ALU_res == op1-op2) && (zero == 0)) else $error("SUB error");
    operar(clock,ALU_op,op1,op2,4'b0001,-45,22);
    assert ((ALU_res == op1-op2) && (zero == 0)) else $error("SUB error");
    operar(clock,ALU_op,op1,op2,4'b0001,45,-22);
    assert ((ALU_res == op1-op2) && (zero == 0)) else $error("SUB error");
    operar(clock,ALU_op,op1,op2,4'b0001,-45,-22);
    assert ((ALU_res == op1-op2) && (zero == 0)) else $error("SUB error");
    operar(clock,ALU_op,op1,op2,4'b0001,2342,2342);
    assert ((ALU_res == op1-op2) && (zero == 1)) else $error("SUB error");
    //slt
    operar(clock,ALU_op,op1,op2,4'b0010,88,120);
    assert ((ALU_res == 1) && (zero == 0)) else $error("SLT error");
    operar(clock,ALU_op,op1,op2,4'b0010,-88,120);
    assert ((ALU_res == 1) && (zero == 0)) else $error("SLT error");
    operar(clock,ALU_op,op1,op2,4'b0010,88,-120);
    assert ((ALU_res == 0) && (zero == 1)) else $error("SLT error");
    operar(clock,ALU_op,op1,op2,4'b0010,-88,-120);
    assert ((ALU_res == 0) && (zero == 1)) else $error("SLT error");
    //sltu
    operar(clock,ALU_op,op1,op2,4'b0011,344,789);
    assert ((ALU_res == 1) && (zero == 0)) else $error("SLTU error");
    operar(clock,ALU_op,op1,op2,4'b0011,-344,789);
    assert ((ALU_res == 0) && (zero == 1)) else $error("SLTU error");
    operar(clock,ALU_op,op1,op2,4'b0011,344,-789);
    assert ((ALU_res == 1) && (zero == 0)) else $error("SLTU error");
    operar(clock,ALU_op,op1,op2,4'b0011,-344,-789);
    assert ((ALU_res == 0) && (zero == 1)) else $error("SLTU error");
    //and
    operar(clock,ALU_op,op1,op2,4'b0100,89341,54321);
    assert ((ALU_res == op1&op2) && (zero == 0)) else $error("AND error");
    operar(clock,ALU_op,op1,op2,4'b0100,0,12313);
    assert ((ALU_res == op1&op2) && (zero == 1)) else $error("AND error con 0");
    operar(clock,ALU_op,op1,op2,4'b0100,7898,0);
    assert ((ALU_res == op1&op2) && (zero == 1)) else $error("AND error con 0");
    //or
    operar(clock,ALU_op,op1,op2,4'b0101,5555,1212);
    assert (ALU_res == op1|op2) else $error("OR error");
    operar(clock,ALU_op,op1,op2,4'b0101,32'hffffffff,123178);
    assert (ALU_res == 32'hffffffff) else $error("OR error");
    //xor
    operar(clock,ALU_op,op1,op2,4'b0110,12,13);
    assert (ALU_res == op1^op2) else $error("XOR error");
    $stop;
end

task automatic operar;
    ref CLOCK;
    ref logic [3:0] ALU_op;
    ref logic signed [31:0] op1;
    ref logic signed [31:0] op2;
    input logic [3:0] operation;
    input logic signed [31:0] operand1;
    input logic signed [31:0] operand2;
    begin
    @(posedge CLOCK);        
    ALU_op = operation;
    op1 = operand1;
    op2 = operand2;
    @(posedge CLOCK);
    end   
endtask 

always begin
	#(T/2) clock <= ~clock;
end

endmodule

