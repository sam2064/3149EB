
// controller.v - controller for RISC-V CPU

module controller (
    input [6:0]  op,
    input [2:0]  funct3,
    input        funct7b5,
    output       [1:0] ResultSrc,
    output       MemWrite,
    output       ALUSrc,
    output       RegWrite, Jalr,
    output [1:0] ImmSrc,
    output [3:0] ALUControl,
	 output		  Jump,
	 output		  Branch
);

wire [1:0] ALUOp;
//wire       Branch;
//wire		  Jump; 

main_decoder    md (op, ResultSrc, MemWrite, Branch,
                    ALUSrc, RegWrite, Jump, Jalr, ImmSrc, ALUOp);

alu_decoder     ad (op, op[5],op[4], funct3, funct7b5, ALUOp, ALUControl);



endmodule

