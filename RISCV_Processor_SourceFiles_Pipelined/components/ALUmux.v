module ALUmux(input[31:0] A,B,C,
					input [1:0] sel,
					output [31:0] out	);

assign out=(sel==2'b00)?A:(sel==2'b01)?B:(sel==2'b10)?C:32'b0;
					
			
endmodule