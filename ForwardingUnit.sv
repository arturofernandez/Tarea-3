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
 *  ForwardB - Frowarded Data 2
 *
 *  |          Conditions           | ForwardA  | ForwardB  | 
 *  |-------------------------------|-----------|-----------|
 *  | No data needs to be forwarded |    00     |     00    |
 *  |          Rd_WB == Rs2         |    00     |     01    |
 *  |          Rd_WB == Rs1         |    01     |     00    |
 *  |      Rd_WB == Rs1 == Rs2      |    01     |     01    |
 *  |                               |    01     |     10    |
 *  |                               |    01     |     11    |
 *  |
 *
 *
*/
module ForwardingUnit(
    input [4:0] Rs1_EX, Rs2_EX, Rd_MEM, Rd_WB,
    input RegWrite_MEM, RegWrite_WB,
    output logic [1:0] ForwardA, ForwardB
);
    always_comb begin
        if((RegWrite_MEM==1) && (Rd_MEM!='0) && (Rs1_EX==Rd_MEM))
        ForwardA=2'b10;
        else if ((RegWrite_WB==1) && (Rd_WB!='0) && (Rs1_EX==Rd_WB))
        ForwardA=2'b01;
        else
        ForwardA=2'b00;
        
        if((RegWrite_MEM==1)&&(Rd_MEM!='0) && (Rs2_EX==Rd_MEM))
        ForwardB=2'b10;
        else if ((RegWrite_WB==1)&&(Rd_WB!='0) &&(Rs2_EX==Rd_WB))
        ForwardB=2'b01;
        else
        ForwardB=2'b00;
    end
    // always_comb begin 
    //     if(Rd_MEM == Rs1_EX && Rd_MEM == Rs2_EX) //Rs1 y Rs2 coinciden con Rd_MEM : cogen ALU_result_MEM
    //         begin
    //             if(Rd_MEM != 0 && RegWrite_MEM) begin //comprobamos que Rd no sea x0 y RegWrite esté activado
    //                 ForwardA = 2'b10;
    //                 ForwardB = 2'b10;
    //             end
    //             else begin 
    //                 ForwardA = 2'b00;
    //                 ForwardB = 2'b00;
    //             end
    //         end
    //     else if(Rd_WB == Rs1_EX && Rd_WB == Rs2_EX) //Rs1 y Rs2 coinciden con Rd_WB : cogen Write_data_reg
    //         begin
    //             if(Rd_WB != 0 && RegWrite_WB) begin //comprobamos que Rd no sea x0 y RegWrite esté activado
    //                 ForwardA = 2'b01;
    //                 ForwardB = 2'b01;
    //             end
    //             else begin 
    //                 ForwardA = 2'b00;
    //                 ForwardB = 2'b00;
    //             end
    //         end
    //     else if(Rd_WB == Rs1_EX && Rd_MEM == Rs1_EX) //Rs1 coincide con Rd_WB y Rd_MEM : coge ALU_result_MEM
    //         begin
    //             if(Rs1_EX != 0 && RegWrite_WB && RegWrite_MEM) begin //comprobamos que Rd no sea x0 y RegWrite esté activado
    //                 ForwardA = 2'b10;
    //                 ForwardB = 2'b00;
    //             end
    //             else if(Rs1_EX != 0 && !RegWrite_WB && RegWrite_MEM) begin 
    //                 ForwardA = 2'b10;
    //                 ForwardB = 2'b00;
    //             end
    //             else if(Rs1_EX != 0 && RegWrite_WB && !RegWrite_MEM) begin 
    //                 ForwardA = 2'b01;
    //                 ForwardB = 2'b00;
    //             end
    //             else begin 
    //                 ForwardA = 2'b00;
    //                 ForwardB = 2'b00;
    //             end
    //         end
    //     else if(Rd_WB == Rs2_EX && Rd_MEM == Rs2_EX) //Rs2 coincide con Rd_WB y Rd_MEM : coge ALU_result_MEM
    //         begin
    //             if(Rs2_EX != 0 && RegWrite_WB && RegWrite_MEM) begin //comprobamos que Rd no sea x0 y RegWrite esté activado
    //                 ForwardA = 2'b00;
    //                 ForwardB = 2'b10;
    //             end
    //             else if(Rs2_EX != 0 && !RegWrite_WB && RegWrite_MEM) begin 
    //                 ForwardA = 2'b00;
    //                 ForwardB = 2'b10;
    //             end
    //             else if(Rs2_EX != 0 && RegWrite_WB && !RegWrite_MEM) begin 
    //                 ForwardA = 2'b00;
    //                 ForwardB = 2'b01;
    //             end
    //             else begin 
    //                 ForwardA = 2'b00;
    //                 ForwardB = 2'b00;
    //             end
    //         end
    //     else if(Rd_WB == Rs1_EX && Rd_MEM == Rs2_EX) //Rs1 coincide con Rd_WB y Rs2 coincide con Rd_MEM : cogen Write_data_reg y ALU_result_MEM
    //         begin
    //             if(Rd_WB != 0 && Rd_MEM != 0 && RegWrite_WB && RegWrite_MEM) begin //comprobamos que Rd no sea x0 y RegWrite esté activado
    //                 ForwardA = 2'b01;
    //                 ForwardB = 2'b10;
    //             end
    //             else if((Rd_WB == 0 || !RegWrite_WB) && Rd_MEM != 0) begin 
    //                 ForwardA = 2'b00;
    //                 ForwardB = 2'b10;
    //             end
    //             else if(Rd_WB != 0 && (Rd_MEM == 0 || !RegWrite_MEM)) begin 
    //                 ForwardA = 2'b01;
    //                 ForwardB = 2'b00;
    //             end
    //             else begin 
    //                 ForwardA = 2'b00;
    //                 ForwardB = 2'b00;
    //             end
    //         end
    //     else if(Rd_MEM == Rs1_EX && Rd_WB == Rs2_EX) //Rs1 coincide con Rd_MEM y Rs2 coincide con Rd_WB : cogen ALU_result_MEM y Write_data_reg
    //         begin
    //             if(Rd_WB != 0 && Rd_MEM != 0 && RegWrite_WB && RegWrite_MEM) begin //comprobamos que Rd no sea x0 y RegWrite esté activado
    //                 ForwardA = 2'b10;
    //                 ForwardB = 2'b01;
    //             end
    //             else if(Rd_WB != 0 && (Rd_MEM == 0 || !RegWrite_MEM)) begin 
    //                 ForwardA = 2'b00;
    //                 ForwardB = 2'b01;
    //             end
    //             else if((Rd_WB == 0 || !RegWrite_WB) && Rd_MEM != 0) begin 
    //                 ForwardA = 2'b10;
    //                 ForwardB = 2'b00;
    //             end
    //             else begin 
    //                 ForwardA = 2'b00;
    //                 ForwardB = 2'b00;
    //             end
    //         end
    //     else if(Rd_MEM == Rs1_EX) //Rs1 coincide con Rd_MEM : coge ALU_result_MEM
    //         begin
    //             if(Rd_MEM != 0 && RegWrite_MEM) begin //comprobamos que Rd no sea x0 y RegWrite esté activado
    //                 ForwardA = 2'b10;
    //                 ForwardB = 2'b00;
    //             end
    //             else begin 
    //                 ForwardA = 2'b00;
    //                 ForwardB = 2'b00;
    //             end
    //         end
    //     else if(Rd_MEM == Rs2_EX) //Rs2 coincide con Rd_MEM : coge ALU_result_MEM
    //         begin
    //             if(Rd_MEM != 0 && RegWrite_MEM) begin //comprobamos que Rd no sea x0 y RegWrite esté activado
    //                 ForwardA = 2'b00;
    //                 ForwardB = 2'b10;
    //             end
    //             else begin 
    //                 ForwardA = 2'b00;
    //                 ForwardB = 2'b00;
    //             end
    //         end
    //     else if(Rd_WB == Rs1_EX) //Rs1 coincide con Rd_WB : coge Write_data_reg
    //         begin
    //             if(Rd_WB != 0 && RegWrite_WB) begin //comprobamos que Rd no sea x0 y RegWrite esté activado
    //                 ForwardA = 2'b01;
    //                 ForwardB = 2'b00;
    //             end
    //             else begin 
    //                 ForwardA = 2'b00;
    //                 ForwardB = 2'b00;
    //             end
    //         end        
    //     else if(Rd_WB == Rs2_EX) //Rs2 coincide con Rd_WB : coge Write_data_reg
    //         begin
    //             if(Rd_WB != 0 && RegWrite_WB) begin //comprobamos que Rd no sea x0 y RegWrite esté activado
    //                 ForwardA = 2'b00;
    //                 ForwardB = 2'b01;
    //             end
    //             else begin 
    //                 ForwardA = 2'b00;
    //                 ForwardB = 2'b00;
    //             end
    //         end        
    //     else                    //Ninguno coincide : no se hace Forwarding
    //         begin
    //             ForwardA = 2'b00;
    //             ForwardB = 2'b00;
    //         end
    // end
endmodule