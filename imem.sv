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
module imem #(parameter DATA_WIDTH = 32, parameter MEM_DEPTH = 1024) (iaddr,idata,clock);
    input [$clog2(MEM_DEPTH)-1:0] iaddr;
    input clock;
    output logic [DATA_WIDTH-1:0] idata;

    logic [DATA_WIDTH-1:0] IMEM [0:MEM_DEPTH-1]; //packed and unpacked array

    //lectura síncrona
    //always_ff @(posedge clock) begin
        //idata <= IMEM[iaddr];
    //end

    function escribirROM (input string text);
        $readmemh(text, IMEM); 
    endfunction 
    
    //Asynchronous Read
    assign idata = IMEM[iaddr];
endmodule
