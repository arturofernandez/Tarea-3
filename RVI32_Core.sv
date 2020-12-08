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
    output logic d_rw 
);
    // Conections:
    logic ALUSrc, MemtoReg, PCSrc, RegWrite, Zero;
    logic [3:0] Operation;
    logic [1:0] AuipcLui;
    
    Controlpath Controlpath ( 
        .Instruction(idata),
        .Zero(Zero),
        .MemRead(),
        .MemtoReg(MemtoReg),
        .MemWrite(d_rw),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .Operation(Operation),
        .PCSrc(PCSrc),
        .AuipcLui(AuipcLui)
    );

    datapath datapath (
        .clock(CLK), 
        .reset(RESET_N), 
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg), 
        .PCSrc(PCSrc), 
        .RegWrite(RegWrite),
        .Instruction(idata), 
        .Read_data(ddata_r),
        .ALU_operation(Operation),
        .current_PC(iaddr), 
        .ALU_result(daddr), 
        .Read_data2(ddata_w),
        .Zero(Zero),
        .AuipcLui(AuipcLui)
    );

// Asserts: RTL Asserts
    R_format:assert property (@(posedge CLK) idata[6:0] == 7'b0110011 |-> PCSrc == 1'b0 && ALUSrc == 1'b0 && MemtoReg == 1'b0) else $fatal("R_format no funciona");
    I_format:assert property (@(posedge CLK) idata[6:0] == 7'b0010011 |-> PCSrc == 1'b0 && ALUSrc == 1'b1 && MemtoReg == 1'b0) else $fatal("I_format no funciona");
    Load_I_format:assert property (@(posedge CLK) idata[6:0] == 7'b0000011 |-> PCSrc == 1'b0 && ALUSrc == 1'b1 && MemtoReg == 1'b1) else $fatal("Load_I_format no funciona");
    S_format:assert property (@(posedge CLK) idata[6:0] == 7'b0100011 |-> PCSrc == 1'b0 && ALUSrc == 1'b1 && MemtoReg == 1'b0) else $fatal("S_format no funciona");
    B_format_efectivo:assert property (@(posedge CLK) idata[6:0] == 7'b1100011 && Zero == 1'b1 |-> PCSrc == 1'b1 && ALUSrc == 1'b0 && MemtoReg == 1'bx) else $fatal("B_format_efectivo no funciona");
    B_format_noefectivo:assert property (@(posedge CLK) idata[6:0] == 7'b1100011 && Zero == 1'b0 |-> PCSrc == 1'b0 && ALUSrc == 1'b0 && MemtoReg == 1'bx) else $fatal("B_format_noefectivo no funciona");
endmodule