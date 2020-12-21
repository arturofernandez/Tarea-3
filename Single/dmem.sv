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

module dmem #(parameter DATA_WIDTH = 32, parameter MEM_DEPTH = 1024) (clk, RESET, write_data, addr, mem_write, dout);
    input clk;
    input RESET;
    input [DATA_WIDTH-1:0]  write_data; 
    input [$clog2(MEM_DEPTH)-1:0] addr; 
    input mem_write; 
    output [DATA_WIDTH-1:0] dout; 

    logic [DATA_WIDTH-1:0] DMEM [0:MEM_DEPTH-1]; //packed and unpacked array

    // Synchronous Write:
    always_ff @(posedge clk or negedge RESET) 
    begin
        if(!RESET)
            for (int i = 0; i < MEM_DEPTH; i++)
            DMEM[i] <= 32'hffffffff;          
        else
        begin
            if (mem_write == 1'b1) 
                    DMEM[addr]<=write_data;
        end
    end

    // Asynchronous Read:
    assign dout = DMEM[addr];
endmodule