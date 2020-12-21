`timescale 1ns/1ps 
/*
 * Interface: IF
 *    DUT input data class.
 *
 * Parameters:
 *
 *  WIDTH - Address Width 
 *  
*/
interface single_IF #(parameter DATA_WIDTH = 32, parameter MEM_DEPTH = 1024) (
    input CLK, RESET_N,
    ref logic [31:0] Regs [31:0],
    ref logic [DATA_WIDTH-1:0] RAM [0:MEM_DEPTH-1],
    ref logic [31:0] imm, idata, ddata_r, iaddr, daddr, ddata_w,
    ref logic d_rw 
);
   
    clocking cb_monitor @(negedge CLK); 
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
endinterface