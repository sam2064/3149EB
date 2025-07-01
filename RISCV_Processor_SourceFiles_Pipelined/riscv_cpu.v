
// riscv_cpu.v - single-cycle RISC-V CPU Processor

module riscv_cpu (
    input         clk, reset,
    output [31:0] PC,
    input  [31:0] Instr,
    output        MemWriteM,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] Result,
	 output [31:0] PCW, ALUResultW, ReadDataW,
	 input   [2:0] funct3,
	 output [2:0] funct3M
);

wire        ALUSrc, RegWrite, Jalr;
wire [1:0]  ResultSrc, ImmSrc;
wire [3:0]  ALUControl;
wire [31:0] InstrD;
wire MemWrite;

controller  c   (InstrD[6:0], InstrD[14:12], InstrD[30], 
                ResultSrc, MemWrite, ALUSrc, RegWrite, Jalr,
                ImmSrc, ALUControl, Jump , Branch);

datapath    dp  (clk, reset, ResultSrc,
                ALUSrc, RegWrite, ImmSrc, ALUControl,Jalr,
					 MemWrite, Jump, Branch,
                PC, Instr, InstrD, Mem_WrAddr, Mem_WrData, ReadData, Result,
                MemWriteM,PCW, ALUResultW,ReadDataW, funct3, funct3M);					 
					

		
endmodule

