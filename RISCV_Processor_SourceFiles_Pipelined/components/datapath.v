// datapath.v
module datapath (
    input         clk, reset,
    input [1:0]   ResultSrc,
    input         ALUSrc,
    input         RegWrite,
    input [1:0]   ImmSrc,
    input [3:0]   ALUControl,
    input         Jalr,
    input         Memwrite, Jump, Branch,
    output [31:0] PC,
    input  [31:0] Instr,
	 output [31:0] InstrD,
    output [31:0] ALUResultM, WriteDataM,
    input  [31:0] ReadData,
    output [31:0] ResultW,
    output        MemWriteM,
    output [31:0] PCW, ALUResultW, WriteDataW,
	 input [2:0] funct3,
	 output [2:0] funct3M
);

wire [2:0] funct3D, funct3E;

// Fetch stage wires
wire [31:0] PCNext, PCNext2, PCPlus4, PCTargetE, AuiPC, lAuiPCResult;
wire [31:0] ImmExt, SrcA, SrcB, ALUResult;
wire FlushD, StallD, FlushE, StallF;


// Latch outputs
// Latch 1 outputs
wire [31:0] /*InstrD,*/ PCD, PCPlus4D;
wire jalrD;
wire [31:0] LauipcD;
wire [4:0] Rs1D, Rs2D;
assign Rs1D = InstrD[19:15];
assign Rs2D = InstrD[24:20];

// Latch 2 outputs
wire RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE;
wire [1:0] ResultSrcE;
wire [3:0] ALUControlE;
wire [31:0] RD1E, RD2E, PCE, PCPlus4E;
wire [4:0] Rs1E, Rs2E, RdE;
wire [31:0] ImmExtE;
wire jalrE,PCSrcE;
wire [31:0] LauipcE;

// Latch 3 outputs
wire [1:0] ResultSrcM;
wire [4:0] RdM;
wire [31:0] LauipcM;
wire [31:0] PCM;
wire [31:0] PCPlus4M;

// Latch 4 outputs
wire RegWriteW;
wire [1:0] ResultSrcW;
wire [31:0] PCPlus4W, ReadDataW;
wire [4:0] RdW;
wire [31:0] LauipcW;

// Fetch stage logic
reset_ff #(32) pcreg(clk, reset, StallF, PCNext2, PC);
adder pcadd4(PC, 32'd4, PCPlus4);
mux2 #(32) pcmux(PCPlus4, PCTargetE, PCSrcE, PCNext);
mux2 #(32) jalrmux(PCNext, ALUResult, jalrD, PCNext2);
adder #(32) auipcadder({Instr[31:12], 12'b0}, PC, AuiPC);
mux2 #(32) lauipcmux(AuiPC, {Instr[31:12], 12'b0}, Instr[5], lAuiPCResult);
fetch_decode_latch latch1(
    .clk(clk), .en(StallD), .clr(FlushD), 
    .InstrF(Instr), .PCF(PC), .PCPlus4F(PCPlus4),
    .InstrD(InstrD), .PCD(PCD), .PCPlus4D(PCPlus4D),
    .jalrF(Jalr), .jalrD(jalrD), .lauipc(lAuiPCResult), .lauipcD(LauipcD), .funct3(funct3), . funct3D(funct3D)
);

// Decode stage logic
reg_file rf(clk, RegWriteW, InstrD[19:15], InstrD[24:20], RdW, ResultW, SrcA, SrcB);
imm_extend ext(.instr(InstrD[31:7]), .immsrc(ImmSrc), .immext(ImmExt));
decode_execute_latch latch2(
    .clk(clk), .clr(FlushE),
    .RegwriteD(RegWrite), .MemwriteD(Memwrite), .JumpD(Jump), .BranchD(Branch), .ALUSrcD(ALUSrc),
    .ResultSrcD(ResultSrc), .ALUControlD(ALUControl),
    .RD1D(SrcA), .RD2D(SrcB), .PCD(PCD), .PCPlus4D(PCPlus4D),
    .Rs1D(Rs1D), .Rs2D(InstrD[24:20]), .RdD(InstrD[11:7]), .ImmExtD(ImmExt),
    .RegWriteE(RegWriteE), .MemWriteE(MemWriteE), .JumpE(JumpE), .BranchE(BranchE), .ALUSrcE(ALUSrcE),
    .ResultSrcE(ResultSrcE), .ALUControlE(ALUControlE),
    .RD1E(RD1E), .RD2E(RD2E), .PCE(PCE), .PCPlus4E(PCPlus4E),
    .Rs1E(Rs1E), .Rs2E(Rs2E), .RdE(RdE), .ImmExtE(ImmExtE),
    .jalrD(jalrD), .jalrE(jalrE), .lauipcD(LauipcD), .lauipcE(LauipcE) , .funct3D(funct3D) , .funct3E(funct3E)
);

// Execute stage logic
wire [31:0] SrcAE, out2, SrcBE;
wire ZeroE;
wire [1:0] ForwardAE, ForwardBE;

ALUmux muxalu1(.A(RD1E), .B(ResultW), .C(ALUResultM), .sel(ForwardAE), .out(SrcAE));
ALUmux muxalu2(.A(RD2E), .B(ResultW), .C(ALUResultM), .sel(ForwardBE), .out(out2));
mux2 #(32) srcbmux(.d0(out2), .d1(ImmExtE), .sel(ALUSrcE), .y(SrcBE));
alu alu(.a(SrcAE), .b(SrcBE), .alu_ctrl(ALUControlE), .alu_out(ALUResult), .zero(ZeroE));
adder #(32) adder2(.a(PCE), .b(ImmExtE), .sum(PCTargetE));
assign PCSrcE = (BranchE & ZeroE) | JumpE;

execute_memory_latch latch3(
    .clk(clk),
    .RegwriteE(RegWriteE), .MemwriteE(MemWriteE), .ResultSrcE(ResultSrcE),
    .ALUResultE(ALUResult), .WriteDataE(out2), .PCPlus4E(PCPlus4E), .RdE(RdE),
    .RegWriteM(RegWriteM), .MemWriteM(MemWriteM), .ResultSrcM(ResultSrcM),
    .ALUResultM(ALUResultM), .WriteDataM(WriteDataM), .PCPlus4M(PCPlus4M), .RdM(RdM),
    .lauipcE(LauipcE), .lauipcM(LauipcM), .PCE(PCE), .PCM(PCM), .funct3E(funct3E) , .funct3M(funct3M)
);

// Memory stage logic
memory_writeback_latch latch4(
    .clk(clk),
    .RegwriteM(RegWriteM), .ResultSrcM(ResultSrcM), .ALUResultM(ALUResultM),
    .ReadDataM(ReadData), .PCPlus4M(PCPlus4M), .RdM(RdM),
    .RegWriteW(RegWriteW), .ResultSrcW(ResultSrcW), .ALUResultW(ALUResultW),
    .ReadDataW(ReadDataW), .PCPlus4W(PCPlus4W), .RdW(RdW), .lauipcM(LauipcM), .lauipcW(LauipcW),
    .PCM(PCM), .PCW(PCW) , .WriteDataM(WriteDataM) , .WriteDataW(WriteDataW)
);

// Write-back stage
mux4 #(32) resultmux(ALUResultW, ReadDataW, PCPlus4W, LauipcW, ResultSrcW, ResultW);

// Hazard unit
hazard_unit hazard(
    .Rs1D(Rs1D), .Rs2D(Rs2D), .Rs1E(Rs1E), .Rs2E(Rs2E), .RdE(RdE), .RdM(RdM), .RdW(RdW),
    .PcSrcE(PCSrcE), .RegWriteM(RegWriteM), .RegWriteW(RegWriteW), .JalrE(jalrE), .ResultSrcE(ResultSrcE), .clk(clk),
    .StallF(StallF), .StallD(StallD), .FlushD(FlushD), .FlushE(FlushE), .ForwardAE(ForwardAE), .ForwardBE(ForwardBE)
);

endmodule