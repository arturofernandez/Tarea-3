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
    randc bit [ADDR_WIDTH-1:0] mem_addr;
    rand bit [DATA_WIDTH-1:0] data;
    constraint underRange { mem_addr inside {[0:1023]}; }
endclass 
`timescale 1ns/1ps 
/*
 * Module: tb_RAM
 *    Test Bench for an Instruction Memory of 32KB
 *
*/
module tb_RAM ();
    localparam DATA_WIDTH = 32;
    localparam MEM_DEPTH = 1024;
    wire [DATA_WIDTH-1:0] data_out;
    reg [DATA_WIDTH-1:0] data_in;
    reg [DATA_WIDTH-1:0] target;
    reg [$clog2(MEM_DEPTH)-1:0] input_addr; 
    reg CLK, write_enable;
    localparam T = 20;
    /*
    * Cover Group: cg_stimulus
    *    Gets the coverage of the memory input address
    *
    */
    covergroup cg_stimulus; 
        option.per_instance = 0;
        option.at_least = 1; 
        type_option.merge_instances = 1;
        addr: coverpoint input_addr {
            bins valorA = {[0:MEM_DEPTH-1]};
        }
    endgroup

    covergroup cg_stimulus_2; 
        option.per_instance = 0;
        option.at_least = 1; 
        type_option.merge_instances = 1;
        addr: coverpoint input_addr {
            bins valorA = {[0:MEM_DEPTH-1]};
        }
    endgroup

    /* Object and instance Declaration */
    inData #(.ADDR_WIDTH($clog2(MEM_DEPTH)), .DATA_WIDTH(DATA_WIDTH)) myData;
    cg_stimulus my_cg;
    cg_stimulus_2 my_cg2;

    dmem  myRAM (
        .clk(CLK), 
        .write_data(data_in), 
        .addr(input_addr), 
        .mem_write(write_enable), 
        .dout(data_out)
    );

    logic [DATA_WIDTH-1:0] ideal_RAM [0:MEM_DEPTH-1]; // Packed and unpacked array

    // Task Automatic: readIdealROM
    // Reads an Ideal ROM, acting as golden Model
    task automatic readIdealRAM (ref reg [($clog2(MEM_DEPTH)-1):0] addr, ref reg [(DATA_WIDTH-1):0] ideal);
        ideal = ideal_RAM[addr]; 
    endtask

    // Task Automatic: readIdealROM
    // Reads an Ideal ROM, acting as golden Model
    task automatic writeIdealRAM (ref reg [($clog2(MEM_DEPTH)-1):0] addr, ref reg [(DATA_WIDTH-1):0] data);      
        ideal_RAM[addr] = data; 
    endtask

    initial begin
        myData = new; 
        my_cg = new; 
        my_cg2 = new; 
        //$readmemh("dump_hex.txt", ideal_ROM);
        CLK = 1'b0; 
        $display("INIT SIMULATION: ");
        // Write Full RAM:
        while (my_cg.get_coverage()< 100) begin
            for (int i = 0; i<(MEM_DEPTH-1); i++) begin
                myData.underRange.constraint_mode(1);
                assert (myData.randomize()) else $fatal("randomization failed");
                write_enable = 1'b1; 
                input_addr = myData.mem_addr;
                data_in = myData.data;
                #(T*4)
                my_cg.sample();
                writeIdealRAM(input_addr, data_in);
              assert (input_addr == input_addr) $display("Addr to be write = 0x%h : DUT write = 0x%h, and target was = 0x%h",input_addr,data_in, target);
              else $fatal("ERROR: Addr to be write = 0x%h : DUT write = 0x%h, and target was = 0x%h",input_addr,data_in, target);   
            end
        end

        $display("Coverage = 0x%d", my_cg2.get_inst_coverage());
        write_enable = 1'b0; 
        //Read full RAM:
        while (my_cg2.get_inst_coverage()< 100) begin
            for (int i = 0; i<(MEM_DEPTH-1); i++) begin
                myData.underRange.constraint_mode(1);
                assert (myData.randomize()) else $fatal("randomization failed"); 
                @(posedge CLK)
                input_addr = myData.mem_addr;
                //readIdealRAM(input_addr, target);
                my_cg2.sample();
                @(posedge CLK)
                @(posedge CLK)
                @(posedge CLK)
                assert (data_out == ideal_RAM[input_addr]) $display("Addr to be read = 0x%h : DUT Read = 0x%h, and target instruction was = 0x%h",input_addr,data_out, target);
                else $fatal("ERROR:");   
            end
        end
        $display("END SIMULATION");
        $stop();
    end

    always  begin
        #(T/2) CLK <= ~CLK;
    end
endmodule