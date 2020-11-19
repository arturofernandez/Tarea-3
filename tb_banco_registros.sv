`timescale 1ns/1ps
module tb_banco_registros();

localparam T = 20;

reg CLK;
reg [4:0] ReadReg1;
reg [4:0] ReadReg2;
reg [4:0] WriteReg;
reg [31:0] WriteData;
reg RegWrite;

wire [31:0] ReadData1;
wire [31:0] ReadData2;

banco_registros banco (.*);

always forever
begin
    #T CLK = ~CLK;
end

initial begin
    CLK = 1'b0;
    ReadReg1 = 5'b0;
    ReadReg2 = 5'b0;
    WriteReg = 5'b0;
    WriteData = 32'b0;
    RegWrite = 1'b0;

    repeat(4) @(posedge CLK);

    for (int i=0;i<32;i++) begin
        write(2*i+1,i,WriteData,WriteReg,RegWrite);
        read(i,ReadReg1);
        #1 $display("Registro %d: Escribo %d Leo %d",i,2*i+1,ReadData1);
    end
    $display("Fin Simulación");
    $stop;
end

task automatic write(input bit [31:0] datos, input bit [4:0] selec, ref [31:0] entrada, ref [4:0] registro, ref enable);
    begin
        @(negedge CLK);
        enable = 1'b1;
        entrada = datos;
        registro = selec;
        @(posedge CLK);
    end
endtask

task automatic read(input bit [4:0] selec, ref [4:0] registro);
    begin
        @(negedge CLK);
        registro = selec;
    end
endtask

endmodule