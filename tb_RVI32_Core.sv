`timescale 1ns/1ps

module tb_RVI32_Core;
    localparam T = 50;

    reg CLK, RESET_N;
    reg [31:0] idata, ddata_r; 
    wire [31:0] iaddr, daddr, ddata_w, d_rw; 

    // instanciación de la interfaz
    IF interfaz (.CLK(CLK), .RESET_N(RESET_N));

    // instanciación del core 
    RVI32_Core myCorason (
        .CLK(interfaz.core.CLK), 
        .RESET_N(interfaz.core.RESET_N), 
        .idata(interfaz.core.idata), 
        .ddata_r(interfaz.core.ddata_r), 
        .iaddr(interfaz.core.iaddr), 
        .daddr(interfaz.core.daddr), 
        .ddata_w(interfaz.core.ddata_w), 
        .d_rw(interfaz.core.d_rw) 
    );

    dmem RAM (
        .clk(interfaz.mem.CLK), 
        .write_data(interfaz.mem.ddata_w), 
        .addr(interfaz.mem.daddr),
        .mem_write(interfaz.mem.d_rw), 
        .dout(interfaz.mem.ddata_r)
    );

    imem ROM (
        .iaddr(interfaz.mem.iaddr),
        .idata(interfaz.mem.idata)
    );

    estimulos estimulos (.mon(interfaz), .Core(myCorason), .RAM(RAM));

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