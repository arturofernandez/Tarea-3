/*
 * Class: inData
 *    DUT input data class.
 *
 * Parameters:
 *
 *  WIDTH - Address Width 
 *  
*/
class inData #(parameter WIDTH = 10); 
    randc bit [WIDTH-1:0] mem_addr;
    constraint underRange { mem_addr inside {[0:1023]}; }
endclass 
`timescale 1ns/1ps 
/*
 * Module: tb_ROM
 *    Test Bench for an Instruction Memory of 32KB
 *
*/
module tb_ROM ();
    localparam DATA_WIDTH = 32;
    localparam MEM_DEPTH = 1024;
    wire [DATA_WIDTH-1:0] data_out;
    reg [DATA_WIDTH-1:0] target;
    reg [$clog2(MEM_DEPTH)-1:0] input_addr; 
    reg CLK;
    localparam T = 20;

    covergroup cg_stimulus; 
        option.per_instance = 0;
        option.at_least = 1; 
        type_option.merge_instances = 1;
        addr: coverpoint input_addr {
            bins valorA = {[0:MEM_DEPTH-1]};
        }
    endgroup

       /* Object and instance Declaration */
    inData #(.WIDTH($clog2(MEM_DEPTH))) myData;
    cg_stimulus my_cg;

    imem  myROM (
        .iaddr(input_addr),
        .idata(data_out)
    );

    logic [DATA_WIDTH-1:0] ideal_ROM [0:MEM_DEPTH-1]; // Packed and unpacked array

    // Task Automatic: readIdealROM
    // Reads an Ideal ROM, acting as golden Model
    task automatic readIdealROM (ref reg [($clog2(MEM_DEPTH)-1):0] addr);
        target = ideal_ROM[addr]; 
    endtask

    initial begin
        myData = new; 
        my_cg = new; 
        $readmemh("dump_hex.txt", ideal_ROM);

        $display("INIT SIMULATION: ");
        while (my_cg.get_coverage()< 100) begin
            for (int i = 0; i<(MEM_DEPTH-1); i++) begin
                myData.underRange.constraint_mode(1);
                assert (myData.randomize()) else $fatal("randomization failed"); 
                input_addr = myData.mem_addr;
                #(T*2)
                my_cg.sample();
                readIdealROM(input_addr);
                assert (data_out == target) $display("Addr to be read = 0x%h : DUT Read = 0x%h, and target instruction was = 0x%h",input_addr,data_out, target);
                else $fatal("ERROR: Addr to be read = 0x%h : DUT Read = 0x%h, and target instruction was = 0x%h",input_addr,data_out, target);   
            end
        end
        $display("END SIMULATION");
        $stop();
    end

    always  begin
        #(T/2) CLK <= ~CLK;
    end
endmodule

