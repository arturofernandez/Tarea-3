`timescale 1ns/1ps 

interface IF #(parameter DATA_WIDTH = 32, parameter MEM_DEPTH = 1024) (
    input CLK, RESET_N,
    ref logic [31:0] Regs [31:0],
    ref logic [DATA_WIDTH-1:0] RAM [0:MEM_DEPTH-1],
    ref logic [31:0] imm, idata, ddata_r, iaddr, daddr, ddata_w,
    ref logic d_rw 
);

    /*!< CLOCKING BLOCK DEFINITIONS: */
    // clocking cb_stimulus @(posedge CLK); //Anyadir descripcion
    //     default input #1ns output #1ns; /*!< input and output skews sample */
    //     input #1ns S;
    //     input #1ns END_MULT;
    //     output #1ns START;
    //     output #1ns A;
    //     output #1ns B;
    // endclocking:cb_stimulus
    
    clocking cb_monitor @(negedge CLK); //Anyadir descripcion
        default input #1ns output #1ns; /*!< input and output skews sample */
        input #1ns idata;  
        input #1ns ddata_r; 
        input #1ns iaddr; 
        input #1ns daddr; 
        input #1ns ddata_w;
        input #1ns d_rw;
        input #1ns Regs;
        input #1ns RAM;
        input #1ns imm;
    endclocking:cb_monitor

    /*!< INTERFACE MODPORT DEFINITIONS: */
    modport monitor (clocking cb_monitor, input CLK);
    // modport mem (
    //     input CLK, 
    //     input iaddr,
    //     input daddr,
    //     input ddata_w,
    //     input d_rw,       
    //     output idata,
    //     output ddata_r
    // );
    // modport core (
    //     input CLK, 
    //     input RESET_N,
    //     input idata,
    //     input ddata_r,
    //     output iaddr,
    //     output daddr,
    //     output ddata_w,
    //     output d_rw
    // );
endinterface