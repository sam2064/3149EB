// pipeline registers -> fetch | decode stage

module fetch_decode_latch (
    input             clk, en, clr,
    input      [31:0] InstrF, PCF, PCPlus4F,
    output reg [31:0] InstrD, PCD, PCPlus4D,
	 input [2:0] funct3,
	 output reg [2:0] funct3D, 
	 input jalrF,
	 output reg  jalrD,
	 input [31:0] lauipc ,
	 output reg [31:0] lauipcD
);

initial begin
    InstrD = 0; PCD = 0; PCPlus4D = 0;jalrD = 0 ;lauipcD =0;funct3D <= 0;
end

always @(posedge clk) begin
    if (clr) begin
        InstrD <= 0; PCD <= 0; PCPlus4D <= 0; jalrD<=0; lauipcD<=0;
    end else if (!en) begin
        InstrD <= InstrF; PCD <= PCF;
        PCPlus4D <= PCPlus4F;
		  jalrD<= jalrF;
		  lauipcD<=lauipc;
		  funct3D <= funct3;
    end
end

endmodule
