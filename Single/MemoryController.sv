module MemoryController(
    input logic [31:0] daddr,
    input logic [31:0] ddata_w,
    input logic d_rw,
    input logic [31:0] mem0_dr,
    input logic [15:0] mem1_din,
    output logic [31:0] mem0_dw,
    output logic [31:0] ddata_r,
    output logic mem0_rw,
    output logic mem0_ena,
    output logic mem1_ena,
    output logic mem1_rw,
    output logic [15:0] mem1_dout,   
    output logic [31:0] mem1_daddr
);

    always_comb begin
        if (daddr >= 0 & daddr < 4096)
            begin
                mem0_ena <= 1'b1;
                mem1_ena <= 1'b0;
                mem0_rw  <= d_rw;
                mem1_rw <= 1'b0;
                mem0_dw  <= ddata_w;
                ddata_r  <= mem0_dr;
                mem1_dout <= 16'b0;
            end
        else 
            begin
                mem0_ena <= 1'b0;
                mem1_ena <= 1'b1;
                mem0_rw  <= 1'b0;
                mem1_rw <= d_rw;
                mem0_dw  <= 32'b0;
                ddata_r <= {{16{1'b0}},mem1_din};
                mem1_dout <= ddata_w[15:0];
            end
    end

    assign mem1_daddr = daddr;

endmodule
