//
//// mux2.v - logic for 2-to-1 multiplexer
//
//module mux2 #(parameter WIDTH = 8) (
//    input       [WIDTH-1:0] d0, d1,
//    input       sel,
//    output      [WIDTH-1:0] y
//);
//
//assign y = sel ? d1 : d0;
//
//endmodule

// mux2.v - logic for 2-to-1 multiplexer

module mux2 #(parameter WIDTH = 8) (
    input       [WIDTH-1:0] d0, d1,
    input       sel,
    output reg  [WIDTH-1:0] y
);

always @(*) begin
    case (sel)
        1'b0: y = d0;      // Select d0 when sel is 0
        1'b1: y = d1;      // Select d1 when sel is 1
        default: y = d0;   // Default to d0 for undefined sel (x or z)
    endcase
end

endmodule
