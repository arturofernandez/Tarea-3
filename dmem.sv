module dmem (parameter DATA_WIDTH = 32, parameter MEM_DEPTH = 1024) (
    input clk,
    input [DATA_WIDTH-1:0]  mem0_dw,
    input [$clog2(MEM_DEPTH)-1:0] daddr_r, daddr_w;
    output mem0_ena, mem0_rw,
    output [DATA_WIDTH-1:0] mem0_dr, 
);
    
logic [DATA_WIDTH-1:0] DMEM [MEM_DEPTH-1:0];
 
always_ff @(posedge clk)
  if (mem0_rw==1'b1)
        mem[wraddress]<=data_in;
always_ff @(posedge clk)
  if (rden==1'b1)
        DPO<=mem[rdaddress];   
   
   assign mem0_dr = (mem0_rw==1'b1)? DMEM[daddr_r]:1'b0;

endmodule