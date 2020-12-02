`timescale 1ns/1ps
module tb_RVI32_Core;
    localparam T = 50;

    reg CLK, RESET_N;
    reg [31:0] idata, ddata_r; 
    wire [31:0] iaddr, daddr, ddata_w, d_rw; 

    // instanciación de la interfaz
    IF interfaz (.CLK(CLK), .RESET_N(RESET_N));

    // instanciación del core con interfaz
    // RVI32_Core myCorason (.*);
    duv myCorason (.BUS(interfaz));

    always begin
        #(T/2) CLK <= ~CLK;
    end
    
    initial begin
        
    end
endmodule