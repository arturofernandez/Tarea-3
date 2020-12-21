/*
 * Class: random_inst
 *    Generates a random instruction for the RISC-V Core
 *
 * Parameters:
 *    instr - Randomized 32 bit RISC-V instruction.
 *    opcode - Randomized Operation Code of an instruction.
*/
class random_inst;
    randc logic [31:0] instr;
    rand logic [0:3] opcode;

    //enum logic [6:0] {R_format==7'b0110011, I_format==7'b0010011, I_format_l==7'b0000011, S_format==7'b0100011, B_format==7'b1100011} opcodes;

    //Generates a random operation code of the instruction form a finite range
    constraint opcode_const {opcode inside {[0:3]}; } //no añadimos la opción de las B_format para evitar saltos erróneos por casualidad

    // Con esta primera constraint nos quitamos sra y srl
    constraint R_format {instr[6:0]==7'b0110011 && instr[11:7]!=4'b0000 && instr[14:12]!=3'b101 && instr[14:12]!=3'b001;}
    constraint R_format_a {(instr[6:0]==7'b0110011 && instr[14:12]!=3'b000) -> instr[31:25]==7'b0000000;}
    constraint R_format_b {(instr[6:0]==7'b0110011 && instr[14:12]==3'b000) -> instr[31:25]==7'b0000000 || instr[31:25]==7'b0100000;}
    // Con esta nos quitamos slli srli srai
    constraint I_format {instr[6:0] == 7'b0010011 && instr[11:7]!=4'b0000 && instr[14:12]!=3'b001 && instr[14:12]!=3'b101;}
    // Solo se permite la instruccion de load lw
    constraint I_format_l {instr[6:0] == 7'b0000011 && instr [11:7]!=4'b0000 && instr[14:12]==3'b011 && instr[31:28]==4'b0000;} //limited to 1024
    // Solo se permite la instruccion de store sw
    constraint S_format {instr[6:0] == 7'b0100011 && instr[14:12]==3'b010 && instr[31:28]==4'b0000;} //limited to 1024
    // Solo se permite BEQ y BNE
    constraint B_format {instr[6:0] == 7'b1100011  && (instr[14:12]==3'b000  || instr[14:12]==3'b001) && instr[31:25]==7'd0 && instr[7]==1'd0;}
    //constraint B_format {instr[6:0] == 7'b1100011  && instr[14:12]==3'b000  && instr[31:25]==7'd0 && instr[7]==1'd0;}
endclass    