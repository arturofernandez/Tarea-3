module Comparador (
    input [31:0] Instruction,
    input [31:0] A,B,
    output logic [1:0] PCSrc
);
    logic [31:0] aux;
    always_comb begin
        aux = A - B;
        casex ({Instruction[6:0],Instruction[14:12]})
            10'b1100011000:begin //BEQ
                if (A == B) //la codificamos como una SUB
                    PCSrc = 2'b01;
                else
                    PCSrc = 2'b00;
            end
            10'b1100011001:begin //BNE
                if (A != B) //la codificamos como una SUB
                    PCSrc = 2'b01;
                else
                    PCSrc = 2'b00;
            end
            10'b1100011100:begin //BLT
                if (aux[31] == 1'b1) //la codificamos como una SLT
                    PCSrc = 2'b01;
                else 
                    PCSrc = 2'b00;
            end
            10'b1100011101:begin //BGE
                if (aux[31] != 1'b1) //la codificamos como una SLT
                    PCSrc = 2'b01;
                else
                    PCSrc = 2'b00;
            end
            10'b1100011110:begin //BLTU
                if (A < B) //la codificamos como una SLTU
                    PCSrc = 2'b01;
                else
                    PCSrc = 2'b00;
            end
            10'b1100011111:begin //BGEU
                if (A >= B) //la codificamos como una SLTU
                    PCSrc = 2'b01;
                else
                    PCSrc = 2'b00;
            end
            10'b1101111xxx: //JAL
                PCSrc = 2'b01; //Pc + imm
            10'b1100111xxx: //JALR
                PCSrc = 2'b10; //Rs1 + imm
            default: PCSrc = 2'b00;
        endcase
    end
endmodule

