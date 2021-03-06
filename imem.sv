/*
 * Module: imem
 *    Instruction Memory of 32KB
 *
 * Inputs:
 *
 *  iaddr - Read memory address.
 *  
 * Outputs:
 *  idata - Read Instruction output.
*/
module imem #(parameter DATA_WIDTH = 32, parameter MEM_DEPTH = 1024) (iaddr,idata);
    input [$clog2(MEM_DEPTH)-1:0] iaddr;
    output [DATA_WIDTH-1:0] idata;

    logic [DATA_WIDTH-1:0] IMEM [0:MEM_DEPTH-1]; //packed and unpacked array

    function escribirROM (input string text);
        $readmemh(text, IMEM); 
    endfunction 
    
    //Asynchronous Read
    assign idata = IMEM[iaddr];
endmodule
