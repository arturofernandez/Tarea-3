/*
 * Module: RVI32_Core
 *    RISC V I 32 bits Core
 *
 * Inputs:
 *  CLK - clock signal required for synchronous events.
 *  RESET_N
 *  idata - Intruction (ROM data output).
 *  ddata_r - Data RAM (DMEM data output).
 *  
 * Outputs:
 *  iaddr - Intruccion Address (ROM address input).
 *  daddr - RAM (DMEM input address).
 *  ddata_w - Data RAM (DMEM data input). 
 *  d_rw - R/W Control signal RAM (DMEM).
*/
module RVI32_Core (
    input CLK, RESET_N, 
    input logic [31:0] idata, ddata_r, 
    output logic [31:0] iaddr, daddr, ddata_w,
    //output logic d_rw 
    output logic MemRead, MemWrite
);
    // Conections:
    logic ALUSrc, MemtoReg, RegWrite, Zero, Jump_RD, MemWrite_EX;
    logic [3:0] Operation;
    logic [1:0] AuipcLui, PCSrc, ForwardA, ForwardB;
    
    Controlpath Controlpath ( 
        .clock(CLK),
        .Instruction(idata),
        .Zero(Zero),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        //.MemWrite(d_rw),
        .MemWrite(MemWrite),
        .MemWrite_EX(MemWrite_EX),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .Operation(Operation),
        .PCSrc(PCSrc),
        .AuipcLui(AuipcLui),
        .Jump(Jump_RD),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );

    datapath datapath (
        .clock(CLK), 
        .reset(RESET_N), 
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg), 
        .PCSrc(PCSrc),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB), 
        .RegWrite(RegWrite),
        .Instruction(idata), 
        .Read_data(ddata_r),
        .ALU_operation(Operation),
        .current_PC(iaddr), 
        .ALU_result_MEM(daddr), 
        .Read_data2_MEM(ddata_w),
        .Zero(Zero),
        .AuipcLui(AuipcLui),
        .Jump_RD(Jump_RD),
        .MemWrite_EX(MemWrite_EX)
    );


    // Asserts: RTL Asserts
    // R_format:assert property (@(posedge CLK) idata[6:0] == 7'b0110011 |-> PCSrc == 1'b0 && ALUSrc == 1'b0 && MemtoReg == 1'b0) else $error("R_format no funciona");
    // I_format:assert property (@(posedge CLK) idata[6:0] == 7'b0010011 |-> PCSrc == 1'b0 && ALUSrc == 1'b1 && MemtoReg == 1'b0) else $error("I_format no funciona");
    // Load_I_format:assert property (@(posedge CLK) idata[6:0] == 7'b0000011 |-> PCSrc == 1'b0 && ALUSrc == 1'b1 && MemtoReg == 1'b1) else $error("Load_I_format no funciona");
    // S_format:assert property (@(posedge CLK) idata[6:0] == 7'b0100011 |-> PCSrc == 1'b0 && ALUSrc == 1'b1 && MemtoReg == 1'b0) else $error("S_format no funciona");
    // B_format_beq_efectivo:assert property (@(posedge CLK) idata[6:0] == 7'b1100011 && idata[14:12] == 3'b000 && Zero == 1'b1 |-> PCSrc == 1'b1 && ALUSrc == 1'b0 && MemtoReg == 1'b0) else $error("BEQ efectivo no funciona");
    // B_format_beq_noefectivo:assert property (@(posedge CLK) idata[6:0] == 7'b1100011 && idata[14:12] == 3'b000 && Zero == 1'b0 |-> PCSrc == 1'b0 && ALUSrc == 1'b0 && MemtoReg == 1'b0) else $error("BEQ no efectivo no funciona");
    // B_format_bne_efectivo:assert property (@(posedge CLK) idata[6:0] == 7'b1100011 && idata[14:12] == 3'b001 && Zero == 1'b0 |-> PCSrc == 1'b1 && ALUSrc == 1'b0 && MemtoReg == 1'b0) else $error("BNE efectivo no funciona");
    // B_format_bne_noefectivo:assert property (@(posedge CLK) idata[6:0] == 7'b1100011 && idata[14:12] == 3'b001 && Zero == 1'b1 |-> PCSrc == 1'b0 && ALUSrc == 1'b0 && MemtoReg == 1'b0) else $error("BNE no efectivo no funciona");
endmodule