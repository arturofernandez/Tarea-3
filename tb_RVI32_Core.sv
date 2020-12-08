`timescale 1ns/1ps

module tb_RVI32_Core ();
    localparam T = 50;
    parameter DATA_WIDTH = 32;
    parameter MEM_DEPTH = 1024;
    
    logic CLK, RESET_N, d_rw;
    logic [31:0] idata, ddata_r, iaddr, daddr, ddata_w; 
    logic Start_Simulation;
    logic [31:0] inst_queue [$];
    logic [31:0] inst;

    // instanciación del core 
    RVI32_Core Core (
        .CLK(CLK), 
        .RESET_N(RESET_N), 
        .idata(idata), 
        .ddata_r(ddata_r), 
        .iaddr(iaddr), 
        .daddr(daddr), 
        .ddata_w(ddata_w), 
        .d_rw(d_rw) 
    );

    dmem #(.DATA_WIDTH(DATA_WIDTH), .MEM_DEPTH(MEM_DEPTH)) RAM (
        .clk(CLK), 
        .write_data(ddata_w), 
        .addr(daddr[9:0]),
        .mem_write(d_rw), 
        .dout(ddata_r)
    );

    imem ROM (
        .iaddr(iaddr[11:2]),
        .idata(idata)
    );

    // instanciación de la interfaz
    IF #(.DATA_WIDTH(DATA_WIDTH), .MEM_DEPTH(MEM_DEPTH)) interfaz (.CLK(CLK), .RESET_N(RESET_N), .Regs(Core.datapath.Registers.Regs), .RAM(RAM.DMEM), .imm(Core.datapath.ImmGen.Immediate), .idata(idata), .ddata_r(ddata_r), .iaddr(iaddr), .daddr(daddr), .ddata_w(ddata_w), .d_rw(d_rw));

    //instanciación del program
    estimulos estimulos (.monitor(interfaz), .Start_Simulation(Start_Simulation), .inst_queue(inst_queue));

    always begin
        #(T/2) CLK <= ~CLK;
    end
    
    initial begin  
        int fd;
        fd = $fopen("./fubinachi.txt","w"); //Create for writing, overwrite if it exists
        
        wait(Start_Simulation == 1'b1)

        while(inst_queue.size() != 0) begin
            inst = inst_queue.pop_back();
            $fdisplay(fd, inst);
        end

        $fclose(fd);
        ROM.escribirROM("fubinachi.txt"); //escribimos en la memoria de instrucciones
        $display("ROM CARGADA");
        
        CLK = 1'b0;
        RESET(CLK,RESET_N);
    end

    task automatic RESET(ref CLK, ref RESET);
        begin
            repeat(1) @(posedge CLK);
            RESET = 1'b0;
            repeat(1) @(posedge CLK);
            RESET = 1'b1;
        end
    endtask
endmodule