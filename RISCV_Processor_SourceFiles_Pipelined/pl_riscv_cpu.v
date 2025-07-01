
// pl_riscv_cpu.v - Top Module to test riscv_cpu


module pl_riscv_cpu (
    input         clk, reset,
    input         Ext_MemWrite,
    input  [31:0] Ext_WriteData, Ext_DataAdr,
    output        MemWrite,
    output [31:0] WriteData, DataAdr, ReadData,
    output [31:0] PCW, Result, ALUResultW, WriteDataW
);

wire [31:0] Instr, PC;
wire [31:0] DataAdr_rv32, WriteData_rv32;
wire [ 2:0] Store, funct3;
wire        MemWrite_rv32;

assign funct3 = Instr[14:12];
wire [2:0]funct3M;

// instantiate processor and memories
riscv_cpu rvcpu    (clk, reset, PC, Instr,
                    MemWrite_rv32, DataAdr_rv32,
                    WriteData_rv32, ReadData, Result,
                    PCW, ALUResultW, WriteDataW , funct3 , funct3M);
						  
						  
//riscv_cpu rvcpu    (clk, reset, PC, Instr,
//                    MemWrite_rv32, DataAdr_rv32,
//                    WriteData_rv32, ReadData, Result);						  
						  
instr_mem instrmem (PC, Instr);
data_mem  datamem  (clk, MemWrite, DataAdr, WriteData, ReadData, Store);

assign Store = (Ext_MemWrite && reset) ? 3'b010 : funct3M;
assign MemWrite  = (Ext_MemWrite && reset) ? 1'b1 : MemWrite_rv32;
assign WriteData = (Ext_MemWrite && reset) ? Ext_WriteData : WriteData_rv32;
assign DataAdr   = reset ? Ext_DataAdr : DataAdr_rv32;

endmodule

