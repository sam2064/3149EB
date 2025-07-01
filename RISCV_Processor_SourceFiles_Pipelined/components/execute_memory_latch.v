// pipeline registers -> execute | memory  stage

module execute_memory_latch (
    input             clk,RegwriteE,MemwriteE,
    input      [1:0]  ResultSrcE,
	 input      [31:0] ALUResultE,WriteDataE,PCPlus4E,PCE,
	 input      [4:0]  RdE,
	 input		[2:0]  funct3E,
	 output reg [2:0]  funct3M,
    output reg RegWriteM,MemWriteM,
	 output reg [1:0] ResultSrcM,
	 output reg [31:0] ALUResultM,WriteDataM,PCPlus4M,
	 output reg [4:0]  RdM,
	 input [31:0] lauipcE ,
	 output reg [31:0] lauipcM,
	 output reg [31:0]PCM
);

initial begin
     RegWriteM <= 0;
	  MemWriteM <= 0;
	  ResultSrcM <= 0;
	  ALUResultM <= 0;
	  WriteDataM <= 0;
	  PCPlus4M <= 0;
	  RdM <= 0;
	  lauipcM<=0;
	  PCM <= 0;
	  funct3M <= 0;
end

always @(posedge clk) begin

	  RegWriteM <= RegwriteE;
	  MemWriteM <= MemwriteE;
	  ResultSrcM <= ResultSrcE;
	  ALUResultM <= ALUResultE;
	  WriteDataM <= WriteDataE;
	  PCPlus4M <= PCPlus4E;
	  RdM <= RdE;
     lauipcM<=lauipcE;
	  PCM <= PCE;
	  funct3M <= funct3E;			
end

endmodule