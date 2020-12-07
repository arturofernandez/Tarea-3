`timescale 1ns/1ps

module tb_RVI32_Core ();
    localparam T = 50;
    parameter DATA_WIDTH = 32;
    parameter MEM_DEPTH = 1024;
    
    logic CLK, RESET_N;
    logic [31:0] idata, ddata_r, iaddr, daddr, ddata_w, d_rw; 

    // instanciación del core 
    RVI32_Core Core (
        .CLK(CLK), 
        .RESET_N(RESET_N), 
        .idata(idata), 
        .ddata_r(ddata_r), 
        .iaddr(iaddr), 
        .daddr(daddr), 
        .ddata_w(ddata_w), 
        .d_rw(d_rw) 
    );

    dmem #(.DATA_WIDTH(DATA_WIDTH), .MEM_DEPTH(MEM_DEPTH)) RAM (
        .clk(CLK), 
        .write_data(ddata_w), 
        .addr(daddr),
        .mem_write(d_rw), 
        .dout(ddata_r)
    );

    imem ROM (
        .iaddr(iaddr),
        .idata(idata)
    );

    // instanciación de la interfaz
    IF #(.DATA_WIDTH(DATA_WIDTH), .MEM_DEPTH(MEM_DEPTH)) interfaz (.CLK(CLK), .RESET_N(RESET_N), .Regs(Core.datapath.Registers.Regs), .RAM(RAM.DMEM), .imm(Core.datapath.ImmGen.Immediate), .idata(idata), .ddata_r(ddata_r), .iaddr(iaddr), .daddr(daddr), .ddata_w(ddata_w), .d_rw(d_rw));

    //instanciación del program
    estimulos estimulos (.mon(interfaz));

    always begin
        #(T/2) CLK <= ~CLK;
    end
    
    initial begin
        ROM.escribirROM("fubinachi.txt"); //escribimos en la memoria de instrucciones
        $display("ROM CARGADA");
        CLK = 1'b0;
        RESET(CLK,RESET_N);
    end

    task automatic RESET(ref CLK, ref RESET);
        begin
            repeat(1) @(negedge CLK);
            RESET = 1'b0;
            repeat(1) @(negedge CLK);
            RESET = 1'b1;
        end
    endtask
endmodule