`timescale 1ns/1ps
module tb_banco_registros();

localparam T = 20;

reg CLK;
reg RESET;
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
    RESET = 1'b1;
    ReadReg1 = 5'b0;
    ReadReg2 = 5'b0;
    WriteReg = 5'b0;
    WriteData = 32'b0;
    RegWrite = 1'b0;

    repeat(4) @(posedge CLK);

    $display("Test de la salida 1:");

    for (int i=0;i<32;i++) begin
        write(2*i+1,i,WriteData,WriteReg,RegWrite);
        read(i,ReadReg1);
        #1 $display("Registro %d: Escribo %d Leo %d",i,2*i+1,ReadData1);
        assert ((2*i+1==ReadData1&i!=0)|(0==ReadData1&i==0)) else  $error("Error en el registro %d: se lee %d y debería leerse %d",i,ReadData1,2*i+1);
    end

    $display("Test de la salida 2:");

    for (int i=0;i<32;i++) begin
        write(4*i+1,i,WriteData,WriteReg,RegWrite);
        read(i,ReadReg2);
        #1 $display("Registro %d: Escribo %d Leo %d",i,4*i+1,ReadData2);
        assert ((4*i+1==ReadData2&i!=0)|(0==ReadData2&i==0)) else  $error("Error en el registro %d: se lee %d y debería leerse %d",i,ReadData2,4*i+1);
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