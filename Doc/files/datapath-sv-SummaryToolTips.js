﻿NDSummary.OnToolTipsLoaded("File:datapath.sv",{29:"<div class=\"NDToolTip TModule LSystemVerilog\"><div class=\"TTSummary\">Englobes all the intances of the Data Path Modules.</div></div>",30:"<div class=\"NDToolTip TModule LSystemVerilog\"><div id=\"NDPrototype30\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><table><tr><td class=\"PBeforeParameters\">ALU ALU (</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PSymbols first\">.</td><td class=\"PName last\">ALU_operation(ALU_operation),</td></tr><tr><td class=\"PSymbols first\">.</td><td class=\"PName last\">op1(ALU_A),</td></tr><tr><td class=\"PSymbols first\">.</td><td class=\"PName last\">op2(ALU_B),</td></tr><tr><td class=\"PSymbols first\">.</td><td class=\"PName last\">ALU_result(ALU_result),</td></tr><tr><td class=\"PSymbols first\">.</td><td class=\"PName last\">Zero(Zero)</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div></div><div class=\"TTSummary\">Main RISC-V Arithmetic Logic Unit</div></div>",31:"<div class=\"NDToolTip TModule LSystemVerilog\"><div id=\"NDPrototype31\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><table><tr><td class=\"PBeforeParameters\">banco_registros Registers (</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PSymbols first\">.</td><td class=\"PName last\">CLK(clock),</td></tr><tr><td class=\"PSymbols first\">.</td><td class=\"PName last\">RESET(reset),</td></tr><tr><td class=\"PSymbols first\">.</td><td class=\"PName last\">ReadReg1(Instruction[<span class=\"SHNumber\">19</span>:<span class=\"SHNumber\">15</span>]),</td></tr><tr><td class=\"PSymbols first\">.</td><td class=\"PName last\">ReadReg2(Instruction[<span class=\"SHNumber\">24</span>:<span class=\"SHNumber\">20</span>]),</td></tr><tr><td class=\"PSymbols first\">.</td><td class=\"PName last\">WriteReg(Instruction[<span class=\"SHNumber\">11</span>:<span class=\"SHNumber\">7</span>]),</td></tr><tr><td class=\"PSymbols first\">.</td><td class=\"PName last\">WriteData(Write_data_reg),</td></tr><tr><td class=\"PSymbols first\">.</td><td class=\"PName last\">RegWrite(RegWrite),</td></tr><tr><td class=\"PSymbols first\">.</td><td class=\"PName last\">ReadData1(Read_data1),</td></tr><tr><td class=\"PSymbols first\">.</td><td class=\"PName last\">ReadData2(Read_data2)</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div></div><div class=\"TTSummary\">Register bank of the RISC-V core</div></div>",32:"<div class=\"NDToolTip TModule LSystemVerilog\"><div id=\"NDPrototype32\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><table><tr><td class=\"PBeforeParameters\">ImmGen ImmGen (</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PSymbols first\">.</td><td class=\"PName last\">Instruction(Instruction),</td></tr><tr><td class=\"PSymbols first\">.</td><td class=\"PName last\">Immediate(Immediate)</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div></div><div class=\"TTSummary\">Generates the immediate sign extension obtained form the instruction decode.</div></div>",33:"<div class=\"NDToolTip TModule LSystemVerilog\"><div id=\"NDPrototype33\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><table><tr><td class=\"PBeforeParameters\"><span class=\"SHKeyword\">register</span> PC (</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PSymbols first\">.</td><td class=\"PName last\">clock(clock),</td></tr><tr><td class=\"PSymbols first\">.</td><td class=\"PName last\">reset(reset),</td></tr><tr><td class=\"PSymbols first\">.</td><td class=\"PName last\">a(next_PC),</td></tr><tr><td class=\"PSymbols first\">.</td><td class=\"PName last\">b(current_PC)</td></tr></table></td><td class=\"PAfterParameters\">)</td></tr></table></div></div><div class=\"TTSummary\">Stores the address of the next instruction to be executed.</div></div>",34:"<div class=\"NDToolTip TModule LSystemVerilog\"><div class=\"TTSummary\">Calculates the PC counter.</div></div>",35:"<div class=\"NDToolTip TModule LSystemVerilog\"><div id=\"NDPrototype35\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><table><tr><td class=\"PBeforeParameters\">adder #(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PSymbols first\">.</td><td class=\"PName last\">size(<span class=\"SHNumber\">32</span>)</td></tr></table></td><td class=\"PAfterParameters\">) adder2 (.a(current_PC), .b(Immediate), .res(effective_addr))</td></tr></table></div></div><div class=\"TTSummary\">Calculates the Effective Adrres. (for Branch Instructions)</div></div>",36:"<div class=\"NDToolTip TModule LSystemVerilog\"><div id=\"NDPrototype36\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><table><tr><td class=\"PBeforeParameters\">MUX #(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PSymbols first\">.</td><td class=\"PName last\">size(<span class=\"SHNumber\">32</span>)</td></tr></table></td><td class=\"PAfterParameters\">) muxPC (.a(sum_adder1), .b(effective_addr), .select(PCSrc), .res(next_PC))</td></tr></table></div></div><div class=\"TTSummary\">Selects the type of PC Source (Effective adrres = PC + imm*4 or not PC + 4)</div></div>",37:"<div class=\"NDToolTip TModule LSystemVerilog\"><div id=\"NDPrototype37\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><table><tr><td class=\"PBeforeParameters\">MUX #(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PSymbols first\">.</td><td class=\"PName last\">size(<span class=\"SHNumber\">32</span>)</td></tr></table></td><td class=\"PAfterParameters\">) muxALU_B (.a(Read_data2), .b(Immediate), .select(ALUSrc), .res(ALU_B))</td></tr></table></div></div><div class=\"TTSummary\">Selects the type of operand of the ALUs second operand (immediate or register).</div></div>",38:"<div class=\"NDToolTip TModule LSystemVerilog\"><div id=\"NDPrototype38\" class=\"NDPrototype WideForm\"><div class=\"PSection PParameterSection CStyle\"><table><tr><td class=\"PBeforeParameters\">MUX #(</td><td class=\"PParametersParentCell\"><table class=\"PParameters\"><tr><td class=\"PSymbols first\">.</td><td class=\"PName last\">size(<span class=\"SHNumber\">32</span>)</td></tr></table></td><td class=\"PAfterParameters\">) muxtoReg (.a(ALU_result), .b(Read_data), .select(MemtoReg), .res(Write_data_reg))</td></tr></table></div></div><div class=\"TTSummary\">Selects the type of operand of the Bank of Registers input data (ALU_Result or Read_data).</div></div>",39:"<div class=\"NDToolTip TModule LSystemVerilog\"><div class=\"TTSummary\">Selects the type of operand of the ALUs first operand (pc, zeros or register).</div></div>"});