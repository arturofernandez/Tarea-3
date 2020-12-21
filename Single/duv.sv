module duv (IF.core BUS);
    RVI32_Core DUV (
        .CLK(BUS.CLK), 
        .RESET_N(BUS.RESET_N), 
        .idata(BUS.idata), 
        .ddata_r(BUS.ddata_r), 
        .iaddr(BUS.iaddr), 
        .daddr(BUS.daddr), 
        .ddata_w(BUS.ddata_w), 
        .d_rw(BUS.d_rw) 
    );
endmodule