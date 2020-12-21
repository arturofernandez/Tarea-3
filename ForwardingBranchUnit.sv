module ForwardingBranchUnit(
    input [4:0] Rs1_ID, Rs2_ID, Rd_EX, Rd_MEM, Rd_WB,
    input RegWrite_EX, RegWrite_MEM, RegWrite_WB,
    output logic [1:0] ForwardBranchA, ForwardBranchB
);
    always_comb begin
        if((RegWrite_EX==1) && (Rd_EX!='0) && (Rs1_ID==Rd_EX))
        ForwardBranchA=2'b11;
        else if((RegWrite_MEM==1) && (Rd_MEM!='0) && (Rs1_ID==Rd_MEM))
        ForwardBranchA=2'b10;
        else if ((RegWrite_WB==1) && (Rd_WB!='0) && (Rs1_ID==Rd_WB))
        ForwardBranchA=2'b01;
        else
        ForwardBranchA=2'b00;
        
        if((RegWrite_EX==1)&&(Rd_EX!='0) && (Rs2_ID==Rd_EX))
        ForwardBranchB=2'b11;
        else if((RegWrite_MEM==1)&&(Rd_MEM!='0) && (Rs2_ID==Rd_MEM))
        ForwardBranchB=2'b10;
        else if ((RegWrite_WB==1)&&(Rd_WB!='0) &&(Rs2_ID==Rd_WB))
        ForwardBranchB=2'b01;
        else
        ForwardBranchB=2'b00;
    end
endmodule