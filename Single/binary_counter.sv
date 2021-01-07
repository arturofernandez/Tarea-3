module binary_counter
#(parameter fin_cuenta = 25000000)
(
    input clk, enable, reset,
    output logic [$clog2(fin_cuenta)-1:0] count,
    output TC
); 
    always_ff @ (posedge clk or negedge reset)
        begin
            if (!reset)
                count <= 0;
            else if (enable)
                begin
                    if(count == fin_cuenta)
                        count <= 0;
                    else
                        count <= count + 1;
                end
            else
                count <= count;
        end
        
    assign TC = (count == fin_cuenta-1)? 1:0;
        
endmodule