// pipeline registers -> decode | execute stage

module decode_execute_latch (
    input             clk,clr,RegwriteD,MemwriteD,JumpD,BranchD,ALUSrcD,
    input      [1:0]  ResultSrcD,
	 input      [3:0]  ALUControlD,
	 input      [31:0] RD1D,RD2D,PCD,PCPlus4D,
	 input      [4:0]  Rs1D,Rs2D,RdD,
	 input      [31:0] ImmExtD,
    output reg RegWriteE,MemWriteE,JumpE,BranchE,ALUSrcE,
	 output reg [1:0] ResultSrcE,
	 output reg [3:0] ALUControlE,
	 output reg [31:0] RD1E,RD2E,PCE,PCPlus4E,
	 output reg [4:0]  Rs1E,Rs2E,RdE,
	 output reg [31:0] ImmExtE,
	 input jalrD,
	 output reg jalrE,
	 input [31:0]lauipcD,
	 output reg [31:0] lauipcE,
	 input [2:0] funct3D,
	 output reg [2:0] funct3E
);

initial begin
    RegWriteE <= 0;MemWriteE <= 0;JumpE <= 0;BranchE <= 0;ALUSrcE <= 0;ResultSrcE <= 0;ALUControlE <= 0;
	 RD1E <= 0; RD2E <= 0; PCE <= 0; PCPlus4E <= 0; Rs1E <= 0; Rs2E <= 0; RdE <= 0;ImmExtE <= 0;jalrE<=0;
	 lauipcE<=0;funct3E <=0;
end

always @(posedge clk) begin
    if (clr) begin
        RegWriteE <= 0;MemWriteE <= 0;JumpE <= 0;BranchE <= 0;ALUSrcE <= 0;ResultSrcE <= 0;ALUControlE <= 0;
		  RD1E <= 0; RD2E <= 0; PCE <= 0; PCPlus4E <= 0; Rs1E <= 0; Rs2E <= 0; RdE <= 0;ImmExtE <= 0;jalrE<=0;
		  lauipcE<=0;
    end else begin
				RegWriteE <= RegwriteD ;MemWriteE <= MemwriteD; JumpE <= JumpD ;
				BranchE <= BranchD ;ALUSrcE <=ALUSrcD;
				ResultSrcE <= ResultSrcD ; ALUControlE <= ALUControlD;
				RD1E <= RD1D; RD2E <= RD2D; PCE <= PCD; PCPlus4E <= PCPlus4D; Rs1E <= Rs1D;
				Rs2E <= Rs2D; RdE <= RdD;ImmExtE <= ImmExtD;
				jalrE<=jalrD;lauipcE<=lauipcD;funct3E <= funct3D;
				end
end

endmodule