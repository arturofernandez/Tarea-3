module RVI32_Core (
    input CLK, RESET_N, //reloj, reset
    input logic [31:0] idata, ddata_r, //bus de datos IMEM, bus de datos de lectura DMEM
    output logic [31:0] iaddr, daddr, ddata_w, d_rw //bus de direcciones IMEM, bus de direcciones DMEM, bus de datos de escritura DMEM, señal de lecutra/escritura
);
    //cables
    logic ALUSrc, MemtoReg, PCSrc, RegWrite, Zero;
    logic [3:0] Operation;
    
    controlpath controlpath ( 
        .Instruction(idata),
        .Zero(Zero),
        .MemRead(),
        .MemtoReg(MemtoReg),
        .MemWrite(d_rw),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .Operation(Operation),
        .PCSrc(PCSrc)
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
        .Zero(Zero)
    );

// Asserts: RTL Asserts
    R_format:assert property (@(posedge CLK) idata[6:0] == 7'b0110011 |-> PCSrc == 1'b0 && ALUSrc == 1'b0 && MemtoReg == 1'b0) else $error("R_format no funciona");
    I_format:assert property (@(posedge CLK) idata[6:0] == 7'b0010011 |-> PCSrc == 1'b0 && ALUSrc == 1'b1 && MemtoReg == 1'b0) else $error("I_format no funciona");
    Load_I_format:assert property (@(posedge CLK) idata[6:0] == 7'b0000011 |-> PCSrc == 1'b0 && ALUSrc == 1'b1 && MemtoReg == 1'b1) else $error("Load_I_format no funciona");
    S_format:assert property (@(posedge CLK) idata[6:0] == 7'b0100011 |-> PCSrc == 1'b0 && ALUSrc == 1'b1 && MemtoReg == 1'b0) else $error("S_format no funciona");
    B_format_efectivo:assert property (@(posedge CLK) idata[6:0] == 7'b1100011 && Zero == 1'b1 |-> PCSrc == 1'b1 && ALUSrc == 1'b0 && MemtoReg == 1'bx) else $error("B_format_efectivo no funciona");
    B_format_noefectivo:assert property (@(posedge CLK) idata[6:0] == 7'b1100011 && Zero == 1'b0 |-> PCSrc == 1'b0 && ALUSrc == 1'b0 && MemtoReg == 1'bx) else $error("B_format_noefectivo no funciona");
endmodule