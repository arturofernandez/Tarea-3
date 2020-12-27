class Scoreboard_sencillo;
    /*!< MONITOR QUEUEs DEFINITION: */
    // reg [31:0] targets_queue [$]; // Infinite Queue Definition
    // reg [31:0] dest_queue [$];
    // reg [31:0] inst_queue [$];

    /*!< Interface Instance: */
    virtual IF.monitor mon;

    function new (virtual IF.monitor mpuertos);
        this.mon = mpuertos;
    endfunction

    /*!< Class members: */
    // logic [31:0] target, target_out, dest_data_out, inst_out, dir;
    // int num_instructions = 0; // Just to know the number of instructions executed

    task monitor_output(); 
        begin
            for (int i = 0; i < 32; i++) begin
                assert (mon.cb_monitor.Regs[i] === mon.cb_monitor.GRegs[i])
                else $error("REG[%0d] ERROR: the result should be %0d and DUT obtains %0d",i,mon.cb_monitor.GRegs[i],mon.cb_monitor.Regs[i]);
            end

            for (int j = 0; j < 1024; j++) begin
                assert (mon.cb_monitor.RAM[j] === mon.cb_monitor.GRAM[j])
                else $error("RAM[%0d] ERROR: the result should be %0d and DUT obtains %0d",j,mon.cb_monitor.GRAM[j],mon.cb_monitor.RAM[j]);
            end
        end
    endtask
endclass