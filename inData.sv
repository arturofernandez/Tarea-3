/*
 * Class: inData
 *    DUT input data class.
 *
 * Parameters:
 *
 *  WIDTH - Address Width 
 *  
*/
class inData #(parameter ADDR_WIDTH = 10, parameter DATA_WIDTH = 32); 
     CLK, RESET_N, 
    input logic [DATA_WIDTH-1:0] idata, ddata_r, 
    output logic [DATA_WIDTH-1:0] iaddr, daddr, ddata_w, d_rw 
    //constraint underRange { mem_addr inside {[0:1023]}; }
    constraint opCode { };
endclass 