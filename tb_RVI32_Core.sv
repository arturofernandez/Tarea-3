    `timescale 1ns/1ps
    `include "./Single/single_imem.sv"
    `include "./Single/single_dmem.sv"
    `include "./Single/single_RVI32_Core.sv"

module tb_RVI32_Core ();
    localparam T = 50;
    parameter DATA_WIDTH = 32;
    parameter MEM_DEPTH = 1024;

    logic CLK, RESET_N, d_rw;
    logic [31:0] idata, ddata_r, iaddr, daddr, ddata_w;
    logic Start_Simulation, MemRead, MemWrite, write_en;

    logic Gd_rw;
    logic [31:0] Gidata, Gddata_r, Giaddr, Gdaddr, Gddata_w;
    string filename;
    //logic [31:0] inst_queue [$];
    //logic [31:0] inst;

    // CORE SEGMENTADO
    RVI32_Core Core (
        .CLK(CLK),
        .RESET_N(RESET_N),
        .idata(idata),
        .ddata_r(ddata_r),
        .iaddr(iaddr),
        .daddr(daddr),
        .ddata_w(ddata_w),
        //.d_rw(d_rw)
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .IF_IDWrite(write_en)
    );

    dmem #(.DATA_WIDTH(DATA_WIDTH), .MEM_DEPTH(MEM_DEPTH)) RAM (
        .clk(CLK),
        .RESET(RESET_N),
        .write_data(ddata_w),
        .addr(daddr[11:2]),
        //.mem_write(d_rw),
        .mem_write(MemWrite),
        .mem_read(MemRead),
        .dout(ddata_r)
    );

    imem ROM (
        .iaddr(iaddr[11:2]),
        .clock(CLK),
        .idata(idata),
        .write_en(write_en)
    );

    //GOLDEN MODEL
    single_RVI32_Core GCore (
        .CLK(CLK),
        .RESET_N(RESET_N),
        .idata(Gidata),
        .ddata_r(Gddata_r),
        .iaddr(Giaddr),
        .daddr(Gdaddr),
        .ddata_w(Gddata_w),
        .d_rw(Gd_rw)
    );

    single_dmem #(.DATA_WIDTH(DATA_WIDTH), .MEM_DEPTH(MEM_DEPTH)) GRAM (
        .clk(CLK),
        .RESET(RESET_N),
        .write_data(Gddata_w),
        .addr(Gdaddr[11:2]),
        .mem_write(Gd_rw),
        .dout(Gddata_r)
    );

    single_imem GROM (
        .iaddr(Giaddr[11:2]),
        .idata(Gidata)
    );

    // instanciación de la interfaz
    IF #(.DATA_WIDTH(DATA_WIDTH), .MEM_DEPTH(MEM_DEPTH)) interfaz (
        .CLK(CLK),
        .RESET_N(RESET_N),
        .Regs(Core.datapath.Registers.Regs),
        .GRegs(GCore.datapath.Registers.Regs),
        .RAM(RAM.DMEM),
        .GRAM(GRAM.DMEM),
        .idata(idata),
        .Gidata(Gidata),
        .daddr(daddr),
        .Gdaddr(Gdaddr),
        .BubbleDetector(Core.ControlSrc),
        .iaddr(iaddr),
        .Giaddr(Giaddr)
        // .imm(Core.datapath.ImmGen.Immediate),
        // .ddata_r(ddata_r),
        // .daddr(daddr),
        // .ddata_w(ddata_w),
        // .d_rw(d_rw)
    );

    //instanciación del program
    estimulos estimulos (.monitor(interfaz), .Start_Simulation(Start_Simulation));

    always begin
        #(T/2) CLK <= ~CLK;
    end

    initial begin

        wait(Start_Simulation == 1'b1)

        if ($value$plusargs("PROG_FILE=%s",filename)) begin
            ROM.escribirROM({"./MachineCode/", filename, ".txt"});
            GROM.escribirROM({"./MachineCode/", filename, ".txt"});
            $display("ROM Writed %s program file - time=%0t\n",filename,$time);
        end
        else if ($test$plusargs("FIBONACCI")) begin
            ROM.escribirROM("./MachineCode/fibonacci_adaptado_cod_maquina.txt");
            GROM.escribirROM("./MachineCode/fibonacci_adaptado_cod_maquina.txt");
            $display("ROM Writed FIBONACCI program file - time=%0t\n",$time);
        end
        else if ($test$plusargs("BUBLE")) begin
            ROM.escribirROM("./MachineCode/burbuja_adaptado_cod_maquina.txt");
            GROM.escribirROM("./MachineCode/burbuja_adaptado_cod_maquina.txt");
            $display("ROM Writed BUBLE program file - time=%0t\n", $time);
        end
        else begin
            $display("ROM was writed randomly - time=%0t\n", $time);
        end
        //ROM.escribirROM("./MachineCode/random_program.txt"); //escribimos en la memoria de instrucciones las instrucciones aleatorias generadas en estimulos.sv
        //GROM.escribirROM("./MachineCode/random_program.txt"); //escribimos en la memoria de instrucciones las instrucciones aleatorias generadas en estimulos.sv
        ROM.escribirROM("./MachineCode/burbuja_adaptado_cod_maquina.txt"); //escribimos en la memoria de instrucciones del código del bubble sort
        GROM.escribirROM("./MachineCode/burbuja_adaptado_cod_maquina.txt"); //escribimos en la memoria de instrucciones del código del bubble sort
        //ROM.escribirROM("./MachineCode/fibonacci_adaptado_cod_maquina.txt"); //escribimos en la memoria de instrucciones del código de fibonacci para 20 ítems de la sucesión
        //GROM.escribirROM("./MachineCode/fibonacci_adaptado_cod_maquina.txt"); //escribimos en la memoria de instrucciones del código de fibonacci para 20 ítems de la sucesión
        //ROM.escribirROM("prueba.txt");
        //GROM.escribirROM("prueba.txt");

        $display("ROM Writed - time=%0t\n", $time);

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