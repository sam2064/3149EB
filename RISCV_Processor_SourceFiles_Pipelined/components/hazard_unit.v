//module hazard_unit(
//    input [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW,
//    input PcSrcE, RegWriteM, RegWriteW, JalrE,
//    input [1:0] ResultSrcE,
//    input clk,
//    output reg StallF, StallD, FlushD, FlushE,
//    output [1:0] ForwardAE, ForwardBE
//);
////
//reg stallsignal;
//
//assign ForwardAE =  (((Rs1E == RdM) && RegWriteM)&(Rs1E!=0))?2'b10:(((Rs1E==RdW)&RegWriteW)&(Rs1E!=0))?2'b01:2'b00;
//assign ForwardBE =  (((Rs2E == RdM) && RegWriteM)&(Rs2E!=0))?2'b10:(((Rs2E==RdW)&RegWriteW)&(Rs2E!=0))?2'b01:2'b00;
//
//initial  begin
//        // Reset all outputs to default values
////        ForwardAE <= 2'b00;
////        ForwardBE <= 2'b00;
//        StallF <= 0;
//        StallD <= 0;
//        FlushD <= 0;
//        FlushE <= 0;
//        stallsignal <= 0;
//end 
//
//always @(posedge clk) begin
////        // Forwarding logic for Source A
////        if (((Rs1E == RdM) && RegWriteM) && (Rs1E != 0))
////            ForwardAE <= 2'b10;
////        else if (((Rs1E == RdW) && RegWriteW) && (Rs1E != 0))
////            ForwardAE <= 2'b01;
////        else
////            ForwardAE <= 2'b00;
////
////        // Forwarding logic for Source B
////        if (((Rs2E == RdM) && RegWriteM) && (Rs2E != 0))
////            ForwardBE <= 2'b10;
////        else if (((Rs2E == RdW) && RegWriteW) && (Rs2E != 0))
////            ForwardBE <= 2'b01;
////        else
////            ForwardBE <= 2'b00;
////
//        // Stall signal logic
//        stallsignal <= (ResultSrcE[0] && ((Rs1D == RdE) || (Rs2D == RdE)));
//
//        // Assign stalling and flushing signals
//        StallD <= stallsignal;
//        StallF <= stallsignal;
//        FlushD <= PcSrcE || JalrE;
//        FlushE <= stallsignal || PcSrcE || JalrE;
//end
//
//endmodule

//module hazard_unit(input [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM , RdW,
//input  PcSrcE, RegWriteM , RegWriteW, JalrE,
//input [1:0] ResultSrcE,
//output StallF, StallD, FlushD, FlushE,
//output [1:0] ForwardAE, ForwardBE
//);
//assign ForwardAE =  (((Rs1E == RdM) && RegWriteM)&(Rs1E!=0))?2'b10:(((Rs1E==RdW)&RegWriteW)&(Rs1E!=0))?2'b01:2'b00;
//assign ForwardBE =  (((Rs2E == RdM) && RegWriteM)&(Rs2E!=0))?2'b10:(((Rs2E==RdW)&RegWriteW)&(Rs2E!=0))?2'b01:2'b00;
//wire stallsignal;
//assign stallsignal = (ResultSrcE[0] &(Rs1D==RdE)|(Rs2D==RdE));
//assign StallD = stallsignal;
//assign StallF = stallsignal;
//assign FlushD = PcSrcE|JalrE;
//assign FlushE = (stallsignal|PcSrcE)|(JalrE);
//endmodule

//assign ForwardAE =  0;
//assign ForwardBE =  0;
//wire stallsignal;
//assign stallsignal = 0;
//assign StallD = stallsignal;
//assign StallF = stallsignal;
//assign FlushD = 0;
//assign FlushE = 0;

//endmodule

module hazard_unit(
    input [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW,
    input PcSrcE, RegWriteM, RegWriteW, JalrE,
    input [1:0] ResultSrcE,
    input clk, reset, // Added reset for initialization
    output reg StallF, StallD, // Still sequential for stalling
    output FlushD, FlushE,    // Instantaneous flush signals
    output [1:0] ForwardAE, ForwardBE
);

wire stallsignal;

// Forwarding logic (combinational)
assign ForwardAE = (((Rs1E == RdM) && RegWriteM) && (Rs1E != 0)) ? 2'b10 :
                   (((Rs1E == RdW) && RegWriteW) && (Rs1E != 0)) ? 2'b01 : 2'b00;

assign ForwardBE = (((Rs2E == RdM) && RegWriteM) && (Rs2E != 0)) ? 2'b10 :
                   (((Rs2E == RdW) && RegWriteW) && (Rs2E != 0)) ? 2'b01 : 2'b00;

// Stall signal (combinational)
assign stallsignal = (ResultSrcE[0] && ((Rs1D == RdE) || (Rs2D == RdE)));

// Flush signals (combinational, immediate updates)
assign FlushD = PcSrcE || JalrE;
assign FlushE = stallsignal || PcSrcE || JalrE;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize sequential signals during reset
        StallF <= 0;
        StallD <= 0;
    end else begin
        // Sequential stalling signals
        StallD <= stallsignal;
        StallF <= stallsignal;
    end
end

endmodule

