module banco_registros(
    input CLK,
    input logic [4:0] ReadReg1,
    input logic [4:0] ReadReg2,
    input logic [4:0] WriteReg,
    input logic [31:0] WriteData,
    input logic RegWrite,
    output logic [31:0] ReadData1,
    output logic [31:0] ReadData2
);

logic [31:0] Regs [31:0]; 

initial begin
    Regs[0] <= 32'b0;
end
always @(posedge CLK)
begin
    if(!RESET)
         Regs <= 0;
    else
    begin
        if(RegWrite)
        begin
            if(WriteReg != 0)
                Regs[WriteReg] <= WriteData;
            else
                Regs[WriteReg] <= 32'b0;
        end
        else
            Regs <= Regs;
    end
end

assign ReadData1 = Regs[ReadReg1];
assign ReadData2 = Regs[ReadReg2];

endmodule