package op_code;
    enum logic [6:0] 
    {
        OP_R_format = 7'b0110011, 
        OP_I_format = 7'b0010011, 
        OP_I_format_l = 7'b0000011, 
        OP_S_format = 7'b0100011, 
        OP_B_format = 7'b1100011,
        OP_U_format_AUIPC = 7'b0010111,
        OP_U_format_LUI = 7'b0110111
    } opcodes;
endpackage