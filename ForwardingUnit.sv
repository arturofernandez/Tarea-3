/*
 * Module: ForwardingUnit
 *    Data Forwarding Unit 
 *
 * Inputs:
 *
 *  Rs1_EX - 
 *  Rs2_EX - 
 *  Rd_MEM - 
 *  Rd_WB - 
 *  
 * Outputs:
 *  ForwardA - Forwarded Data 1
 *  ForwardB - Frowarde Data 2
*/
module ForwardingUnit(
    input [4:0] Rs1_EX, Rs2_EX, Rd_MEM, Rd_WB,
    output logic [1:0] ForwardA, ForwardB
);
    always_comb begin 
        if(Rd_MEM == Rs1_EX && Rd_MEM == Rs2_EX)
            begin
                ForwardA = 2'b10;
                ForwardB = 2'b10;
            end
        else if(Rd_WB == Rs1_EX && Rd_WB == Rs2_EX)
            begin
                ForwardA = 2'b01;
                ForwardB = 2'b01;
            end
        else if(Rd_MEM == Rs1_EX)
            begin
                ForwardA = 2'b10;
                ForwardB = 2'b00;
            end
        else if(Rd_MEM == Rs2_EX)
            begin
                ForwardA = 2'b00;
                ForwardB = 2'b10;
            end
        else if(Rd_WB == Rs1_EX)
            begin
                ForwardA = 2'b01;
                ForwardB = 2'b00;
            end        
        else if(Rd_WB == Rs2_EX)
            begin
                ForwardA = 2'b00;
                ForwardB = 2'b01;
            end        
        else
            begin
                ForwardA = 2'b00;
                ForwardB = 2'b00;
            end
    end
endmodule