module imem #(parameter DATA_WIDTH = 32, parameter MEM_DEPTH = 1024) (
    input iaddr[$clog2(MEM_DEPTH)-1:0],
    output idata [DATA_WIDTH-1:0]
);
    reg [DATA_WIDTH-1:0] IMEM [0:MEM_DEPTH-1];

    initial begin
        $readmemh("instructions_hex.mem", IMEM); //Preguntar si hay que alojar el programa en alguna dirección en especifico
    end

    assign idata = IMEM[iaddr];
endmodule