//
//module alu #(parameter WIDTH = 32) (
//    input       [WIDTH-1:0] a, b,       // operands
//    input       [3:0] alu_ctrl,         // ALU control
//    output  wire    [WIDTH-1:0] alu_out,    // ALU output
//    output  wire   zero                    // zero flag
//);
//
//
//wire [WIDTH-1:0] ca, cb;  //Comparator inputs  
//wire alb,aeb,agb;			  //Comparator output signals
//wire csig;					  //Logical signal for Alu_ctrl signals that need signed input
//assign csig = ((alu_ctrl[1]&alu_ctrl[0])|(alu_ctrl[3]&alu_ctrl[1])|(alu_ctrl[3]&(~alu_ctrl[1])));
//assign ca = csig?$signed(a):a; 		//Comparator input based on type 
//assign cb = csig?$signed(b):b;
//comparator c1(ca,cb,alb,aeb);	//Comparator instantiation
//assign agb = ~alb;				//Assigning less than signal
//
//
////Assigning signals as per instruction output required
//wire SLT, SLTU, BEQ, BNE, BLT , BGE , BLTU , BGEU ;
//assign SLT = alb;					
//assign SLTU = alb;
//assign BEQ = aeb;
//assign BNE = ~aeb;
//assign BLT = alb;
//assign BGE = agb;
//assign BLTU = alb;
//assign BGEU = agb;
//
//
////Assigning wires for addition subtraction output
//wire [31:0] ab;
//wire  cout;
//add_sub a1(a,b,alu_ctrl[3],ab,cout);	//Addition - SUbtraction using Ripple carry adder instantiation
//
//
//   
//    // Continuous assignments for ALU operations
//    assign alu_out = (alu_ctrl == 4'b0000) ? ab :                // ADD
//                     (alu_ctrl == 4'b0001) ? (a << b[4:0]) :    // Shift left logical
//                     (alu_ctrl == 4'b0010) ? SLT :               // SLT signed
//                     (alu_ctrl == 4'b0011) ? SLTU :              // SLT unsigned
//                     (alu_ctrl == 4'b0100) ? (a ^ b) :           // XOR
//                     (alu_ctrl == 4'b0101) ? (a >> b[4:0]) :    // Shift right logical
//                     (alu_ctrl == 4'b0110) ? (a | b) :           // OR
//                     (alu_ctrl == 4'b0111) ? (a & b) :           // AND
//                     (alu_ctrl == 4'b1010) ? ab :                // SUB
//                     (alu_ctrl == 4'b1011) ? ($signed(a) >>> b[4:0]) : // Shift right arithmetic
//                     0;  // Default to 0 if no valid control signal
//
//    // Continuous assignment for zero flag
//    assign zero = (alu_ctrl == 4'b1000) ? BEQ :                 // BEQ
//                  (alu_ctrl == 4'b1001) ? BNE :                 // BNE
//                  (alu_ctrl == 4'b1100) ? BLT :                 // BLT
//                  (alu_ctrl == 4'b1101) ? BGE :                 // BGE
//                  (alu_ctrl == 4'b1110) ? BLTU :                // BLTU
//                  (alu_ctrl == 4'b1111) ? BGEU :                // BGEU
//                  0;  // Default to 0 for zero flag if no valid control signal
//                  
//
//
//
//endmodule


// alu.v - ALU module

module alu #(parameter WIDTH = 32) (
    input       [WIDTH-1:0] a, b,       // operands
    input       [3:0] alu_ctrl,         // ALU control
    output reg  [WIDTH-1:0] alu_out,    // ALU output
    output   reg   zero                    // zero flag
);

	reg [4:0]btemp; // temporary variable to get uimm.

always @(a, b, alu_ctrl) begin
/*
Purpose:
---
< Based on the alu_ctrl signal and inputs, output generated based on the instruction necessary>
*/
    case (alu_ctrl)
        4'b0000:  alu_out <= a + b;       // ADD
        4'b1010:  alu_out <= a + ~b + 1;  // SUB
        4'b0111:  alu_out <= a & b;       // AND
        4'b0110:  alu_out <= a | b;       // OR
        4'b0010:  begin                   // SLT signed
                     if (a[31] != b[31]) alu_out <= a[31] ? 1 : 0;
                     else alu_out <= a < b ? 1 : 0;
                 end
		  4'b0001: alu_out <= a<<b;        // shift left
		  4'b0100: alu_out<= a^b;          // xor
		  4'b0101: alu_out<= a>>b;         //shift logical right
		  4'b1011: begin
						btemp=b[4:0];
						alu_out= $signed(a) >>> btemp; 
						end
														// shift arithmetic right
		  4'b0011:  begin                   // SLT unsigned
                     if (a[31] != b[31]) alu_out <= a[31] ? 0: 1;
                     else alu_out <= a < b ? 1 : 0;
                 end
			4'b1000:  zero <= (a==b) ? 1'b1 : 1'b0; //beq
			4'b1001:  zero <= (a!=b) ? 1'b1 : 1'b0; //bne
			4'b1100: begin                   
                     if (a[31] != b[31]) zero <= a[31] ? 1 : 0; //blt
                     else zero <= a < b ? 1 : 0;
                 end
			4'b1101: 
			begin                   
                     if (a == b) zero <=  1;
							else if(a[31] != b[31])  zero <= a[31] ? 0 : 1; //bge
                     else zero = a > b ? 1: 0;
						end
			4'b1110:  zero <= (a<b) ? 1'b1 : 1'b0; //bltu
			4'b1111:  zero <= (a>=b) ? 1'b1 : 1'b0; //bgeu
			 
		  
        default: alu_out = 0;
    endcase
end







endmodule




