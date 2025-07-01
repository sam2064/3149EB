// comparator.v - Module to implement comparator logic
/*
# Team ID:          eb_3149
# Theme:            EcoMender Bot
# Author List:      Advay Kunte, Samruddhee Jadhav , Prabhat Sati , Pulkit Gupta
# Filename:         comparator
# File Description: Module where comparison of inputs is made based on values
# Global variables: NA
*/


module comparator #(parameter WIDTH = 32) (
    input       [WIDTH-1:0] a, b,       // operands
    output      lessthan,     			// lessthan
    output      equalto     				// equalto
);

assign lessthan = (a<b); 	//Assigns signal value 1 if a less than b
assign equalto = (a==b);	//Assigns signal value 1 if a equal to b

endmodule
