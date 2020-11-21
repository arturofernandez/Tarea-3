/*
 * Module: dmem
 *    Data Memory of 32KB
 *
 * Inputs:
 *
 *  clk - clock signal required for synchronous events.
 *  mem0_ena - Memory enable signal. 
 *  mem0_dw - Memory write input data.
 *  daddr_r - Read memory Address.
 *  daddr_w - Write memory Address.
 *  mem0_rw - Read and Write enable signal. (Write: mem0_rw==1 and Read: mem0_rw==0)
 *  
 * Outputs:
 *  mem0_dr - Read data output.
*/

module dmem #(parameter DATA_WIDTH = 32, parameter MEM_DEPTH = 1024) (clk, mem0_dw, daddr_r, daddr_w, mem0_ena, mem0_rw, mem0_dr);
    input clk;
    input [DATA_WIDTH-1:0]  mem0_dw; 
    input [$clog2(MEM_DEPTH)-1:0] daddr_r, daddr_w; 
    input mem0_ena, mem0_rw; 
    output [DATA_WIDTH-1:0] mem0_dr; 

    logic [DATA_WIDTH-1:0] DMEM [0:MEM_DEPTH-1]; //packed and unpacked array

    // Synchronous Write:
    always_ff @(posedge clk) begin
    if (mem0_ena && mem0_rw == 1'b1) 
            DMEM[daddr_w]<=mem0_dw;
    end

    // Asynchronous Read:
    assign mem0_dr =  (mem0_rw==1'b0 && mem0_ena) ? DMEM[daddr_r]:1'b0;
endmodule