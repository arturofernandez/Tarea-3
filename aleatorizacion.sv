class random_inst;
    rand logic [31:0] instr;
    rand logic [6:0] opcode
    // Con esta primera constraint nos quitamos sra y srl
    constraint R_format {instr[6:0] == 7'b0110011 && instr[14:12]!=3'b101 && instr[14:12]!=3'b001;}
    constraint R_format_a {(instr[6:0] == 7'b0110011 && instr[14:12]!=3'b000) -> instr[31:25]==7'b0000000 ;}
    constraint R_format_b {(instr[6:0] == 7'b0110011 && instr[14:12]=3'b000) -> instr[31:25]==7'b0000000 || instr[31:25]==7'b0100000 ;}
    // Con esta nos quitamos slli srli srai
    constraint I_format {instr[6:0] == 7'b0010011 && instr[14:12]!=3'b001 && instr[14:12]!=3'b101;}
    // Solo se permite la instruccion de load lw
    constraint I_format_l {instr[6:0] == 7'b0000011 && instr[14:12]=3'b011;}
    // Solo se permite la instruccion de store sw
    constraint S_format {instr[6:0] == 7'b0100011 && instr[14:12]=3'b010;}
    // Solo se permite BEQ y BNE
    constraint B_format {instr[6:0] == 7'b1100011  && instr[14:12]=3'b000  && instr[14:12]=3'b001;}

    constraint opcode_const{opcode==7'b0110011 || opcode==7'b0010011 || opcode==7'b0000011 || opcode==7'b0100011 || opcode==7'b1100011}

    function generar_inst;
        this.opcode_const.constraintmode(1);
        this.randomize();
        case(this.opcode)
            7'b0110011:
                begin
    	            this.R_format.constraintmode(1);
                    this.I_format.constraintmode(0);
                    this.I_format_l.constraintmode(0);
                    this.S_format.constraintmode(0);
                    this.B_format.constraintmode(0);
                end
            7'b0010011:
                begin
    	            this.R_format.constraintmode(0);
                    this.I_format.constraintmode(1);
                    this.I_format_l.constraintmode(0);
                    this.S_format.constraintmode(0);
                    this.B_format.constraintmode(0);
                end
            7'b0000011:
                begin
    	            this.R_format.constraintmode(0);
                    this.I_format.constraintmode(0);
                    this.I_format_l.constraintmode(1);
                    this.S_format.constraintmode(0);
                    this.B_format.constraintmode(0);
                end
            7'b0100011:
                begin
    	            this.R_format.constraintmode(0);
                    this.I_format.constraintmode(0);
                    this.I_format_l.constraintmode(0);
                    this.S_format.constraintmode(1);
                    this.B_format.constraintmode(0);
                end
            7'b1100011:
                begin
    	            this.R_format.constraintmode(0);
                    this.I_format.constraintmode(0);
                    this.I_format_l.constraintmode(0);
                    this.S_format.constraintmode(0);
                    this.B_format.constraintmode(1);
                end
            default:
                begin
    	            this.R_format.constraintmode(0);
                    this.I_format.constraintmode(0);
                    this.I_format_l.constraintmode(0);
                    this.S_format.constraintmode(0);
                    this.B_format.constraintmode(0);
                end
        endcase

        this.randomize();
    endfunction

endclass    


class covergroups_CORE; // se quita la clase pero por ahora por decorar
    covergroup instrucciones; 
        rformat : coverpoint({monitor.idata[30],monitor.idata[14:12]}) iff (monitor.idata[6:0]==7'b0110011&&monitor_port.dato[31]==1'b0&&monitor_port.dato[29:25]==5'b0000)
        {
            bins add = {4'b0000};
            bins sub = {4'b1000};
            bins slt = {4'b0010};
            bins sltu = {4'b0011};
            bins r_xor = {4'b0100};
            bins r_or = {4'b0110};
            bins r_and = {4'b0111};
            // aqui habria que meter illegal bins y los bins de las instrucciones que no 
            // hemos implementado, con nuestro randomize solo se generan estas instrucciones
            // que ya tienen bin

        }

        iformat : coverpoint({monitor.idata[14:12]}) iff (monitor.idata[6:0]==7'b0010011)
        {  
            bins addi = {3'b000};
            bins slti = {3'b010};
            bins sltui = {3'b011};
            bins xori = {3'b100};
            bins ori = {3'b110};
            bins andi = {3'b111};
            // lo mismo de las illegal bins y las bins de instrucciones no implementadas
        }

        iformatl : coverpoint({monitor.idata[14:12]}) iff (monitor.idata[6:0]==7'b0000011)
        {  
            bins lw = {3'b011};
            // lo mismo de las illegal bins y las bins de instrucciones no implementadas
        }

        sformat : coverpoint({monitor.idata[14:12]}) iff (monitor.idata[6:0]==7'b0100011)
        {  
            bins sw = {3'b010};
            // lo mismo de las illegal bins y las bins de instrucciones no implementadas
        }

        bformat : coverpoint({monitor.idata[14:12]}) iff (monitor.idata[6:0]==7'b1100011)
        {  
            bins beq = {3'b000};
            bins bne = {3'b001};
            // lo mismo de las illegal bins y las bins de instrucciones no implementadas
        }
endclass