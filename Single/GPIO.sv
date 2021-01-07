module GPIO(
    input mem1_ena,
    input  [7:0] mem1_dout,
    input  [7:0] DIN,
    output [7:0] mem1_din,
    output l0gic [7:0] DOUT1,
    output l0gic [7:0] DOUT2,
    output l0gic [7:0] DOUT3,
    output l0gic [7:0] DOUT4
);
    
    always_comb begin
        if(mem1_ena) begin
            if(daddr == 4096) begin
                DOUT1 <= DIN;
                DOUT2 <= DOUT2;
                DOUT3 <= DOUT3;
                DOUT4 <= DOUT4;
            end
            else if (daddr == 4097) begin
                DOUT1 <= DOUT1;
                DOUT2 <= DIN;
                DOUT3 <= DOUT3;
                DOUT4 <= DOUT4;
            end
            else if (daddr == 4098) begin
                DOUT1 <= DOUT1;
                DOUT2 <= DOUT2;
                DOUT3 <= DIN;
                DOUT4 <= DOUT4;
            end
            else if (daddr == 4099) begin
                DOUT1 <= DOUT1;
                DOUT2 <= DOUT2;
                DOUT3 <= DOUT3;
                DOUT4 <= DIN;
            end
            else begin
                DOUT1 <= DOUT1;
                DOUT2 <= DOUT2;
                DOUT3 <= DOUT3;
                DOUT4 <= DOUT4;
            end
        end
        else begin
            DOUT1 <= DOUT1;
            DOUT2 <= DOUT2;
            DOUT3 <= DOUT3;
            DOUT4 <= DOUT4;
        end
    end

    // Programa:
    // H 1001000 
    // O 0000001
    // L 1110001
    // A 0001000

endmodule
