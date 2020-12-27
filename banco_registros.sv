module banco_registros(
    input CLK,
    input RESET,
    input logic [4:0] ReadReg1,
    input logic [4:0] ReadReg2,
    input logic [4:0] WriteReg,
    input logic [31:0] WriteData,
    input logic RegWrite,
    output logic [31:0] ReadData1,
    output logic [31:0] ReadData2
);

logic [31:0] Regs [31:0];// = { 32{32'd0} }; 

initial begin
    Regs[0] <= 32'b0;
end

always @(posedge CLK, negedge RESET)
    begin
        if(!RESET)
            begin
                for (int i = 0; i < 32; i++) begin
                    Regs[i] <= 32'b0; 
                end 
                ReadData1 <= 32'b0; 
                ReadData2 <= 32'b0;
            end  
        else begin  
            if (RegWrite)
                begin
                    // if((ReadReg1 != WriteReg) && (ReadReg2 != WriteReg)) begin
                    //     ReadData1 <= Regs[ReadReg1]; //lectura síncrona
                    //     ReadData2 <= Regs[ReadReg2];
                    // end
                    if (ReadReg1 == WriteReg && ReadReg2 == WriteReg) begin
                        ReadData1 <= WriteData;
                        ReadData2 <= WriteData;
                    end
                    else if (ReadReg1 == WriteReg) begin
                        ReadData1 <= WriteData;
                        ReadData2 <= Regs[ReadReg2];
                    end 
                    else if (ReadReg2 == WriteReg) begin
                        ReadData1 <= Regs[ReadReg1];
                        ReadData2 <= WriteData;
                    end
                    else begin
                        ReadData1 <= Regs[ReadReg1]; //lectura síncrona
                        ReadData2 <= Regs[ReadReg2];
                    end
                end
            else
                begin
                    ReadData1 <= Regs[ReadReg1]; //lectura síncrona
                    ReadData2 <= Regs[ReadReg2];
                end
            if(WriteReg != 0 && RegWrite)
                Regs[WriteReg] <= WriteData;
            else if(WriteReg == 0)
                Regs[WriteReg] <= 32'b0;
            else
                Regs <= Regs;
        end
    end

endmodule