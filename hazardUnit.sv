module hazardUnit (
    input [4:0] Rs1_ID, Rs2_ID, Rd_EX,
    input MemRead_EX,
    input ControlBubble,
    output logic PCWrite, IF_IDWrite, ControlSrc 
);

    always_comb begin
        if(MemRead_EX && ((Rd_EX == Rs1_ID) || (Rd_EX == Rs2_ID)))
            begin
                ControlSrc = 0;  // el mux elige 0 en lugar de control
                PCWrite = 0;
                IF_IDWrite = 0;
            end
        else if(MemRead_MEM && (opcode == 7'b1100011 || opcode == 7'b1100111) && ((Rd_MEM == Rs1_ID) || (Rd_MEM == Rs2_ID)))
            begin
                ControlSrc = 0;  // el mux elige 0 en lugar de control
                PCWrite = 0;
                IF_IDWrite = 0;
            end    
        else if (ControlBubble)
            begin
                ControlSrc = 0;  // el mux elige control en lugar de 0
                PCWrite = 1;
                IF_IDWrite = 1;            
            end
        else 
            begin
                ControlSrc = 1;  // el mux elige control en lugar de 0
                PCWrite = 1;
                IF_IDWrite = 1;            
            end
    end

endmodule

