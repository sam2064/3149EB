// add_sub.v - Module to implement complementary addition subtraction based on ripple carry adder logic

/*
# Team ID:          eb_3149
# Theme:            EcoMender Bot
# Author List:      Advay Kunte, Samruddhee Jadhav , Prabhat Sati , Pulkit Gupta
# Filename:         add_sub
# File Description: Module where addition and subtraction is carried out complementarily using full adder logic
# Global variables: NA
*/


module add_sub (
    input  [31:0] a, b,       // 32-bit operands
    input         op,         // Operation: 0 for add, 1 for subtract
    output [31:0] sum,        // 32-bit result
    output        cout        // Carry-out
);
    wire [31:0] b_xor_op;     // XOR-ed b based on operation
    wire [32:0] carry;        // Carry wires (extra bit for carry out)
    assign carry[0] = op;     // Initial carry-in (1 for subtraction, 0 for addition)

    // XOR gates for conditional inversion of b
    assign b_xor_op[0] = b[0] ^ op;
    assign b_xor_op[1] = b[1] ^ op;
    assign b_xor_op[2] = b[2] ^ op;
    assign b_xor_op[3] = b[3] ^ op;
    assign b_xor_op[4] = b[4] ^ op;
    assign b_xor_op[5] = b[5] ^ op;
	 assign b_xor_op[6] = b[6] ^ op;
    assign b_xor_op[7] = b[7] ^ op;
    assign b_xor_op[8] = b[8] ^ op;
    assign b_xor_op[9] = b[9] ^ op;
    assign b_xor_op[10] = b[10] ^ op;
    assign b_xor_op[11] = b[11] ^ op;
    assign b_xor_op[12] = b[12] ^ op;
    assign b_xor_op[13] = b[13] ^ op;
    assign b_xor_op[14] = b[14] ^ op;
    assign b_xor_op[15] = b[15] ^ op;
    assign b_xor_op[16] = b[16] ^ op;
    assign b_xor_op[17] = b[17] ^ op;
    assign b_xor_op[18] = b[18] ^ op;
    assign b_xor_op[19] = b[19] ^ op;
    assign b_xor_op[20] = b[20] ^ op;
    assign b_xor_op[21] = b[21] ^ op;
    assign b_xor_op[22] = b[22] ^ op;
    assign b_xor_op[23] = b[23] ^ op;
    assign b_xor_op[24] = b[24] ^ op;
    assign b_xor_op[25] = b[25] ^ op;
    assign b_xor_op[26] = b[26] ^ op;
    assign b_xor_op[27] = b[27] ^ op;
    assign b_xor_op[28] = b[28] ^ op;
    assign b_xor_op[29] = b[29] ^ op;
    assign b_xor_op[30] = b[30] ^ op;
    assign b_xor_op[31] = b[31] ^ op;

    // Manually instantiated ripple carry adder logic
    assign sum[0] = a[0] ^ b_xor_op[0] ^ carry[0];
    assign carry[1] = (a[0] & b_xor_op[0]) | (carry[0] & (a[0] ^ b_xor_op[0]));

    assign sum[1] = a[1] ^ b_xor_op[1] ^ carry[1];
    assign carry[2] = (a[1] & b_xor_op[1]) | (carry[1] & (a[1] ^ b_xor_op[1]));

    assign sum[2] = a[2] ^ b_xor_op[2] ^ carry[2];
    assign carry[3] = (a[2] & b_xor_op[2]) | (carry[2] & (a[2] ^ b_xor_op[2]));

    assign sum[3] = a[3] ^ b_xor_op[3] ^ carry[3];
    assign carry[4] = (a[3] & b_xor_op[3]) | (carry[3] & (a[3] ^ b_xor_op[3]));

    assign sum[4] = a[4] ^ b_xor_op[4] ^ carry[4];
    assign carry[5] = (a[4] & b_xor_op[4]) | (carry[4] & (a[4] ^ b_xor_op[4]));

    assign sum[5] = a[5] ^ b_xor_op[5] ^ carry[5];
    assign carry[6] = (a[5] & b_xor_op[5]) | (carry[5] & (a[5] ^ b_xor_op[5]));

    assign sum[6] = a[6] ^ b_xor_op[6] ^ carry[6];
    assign carry[7] = (a[6] & b_xor_op[6]) | (carry[6] & (a[6] ^ b_xor_op[6]));

    assign sum[7] = a[7] ^ b_xor_op[7] ^ carry[7];
    assign carry[8] = (a[7] & b_xor_op[7]) | (carry[7] & (a[7] ^ b_xor_op[7]));

    assign sum[8] = a[8] ^ b_xor_op[8] ^ carry[8];
    assign carry[9] = (a[8] & b_xor_op[8]) | (carry[8] & (a[8] ^ b_xor_op[8]));

    assign sum[9] = a[9] ^ b_xor_op[9] ^ carry[9];
    assign carry[10] = (a[9] & b_xor_op[9]) | (carry[9] & (a[9] ^ b_xor_op[9]));

    assign sum[10] = a[10] ^ b_xor_op[10] ^ carry[10];
    assign carry[11] = (a[10] & b_xor_op[10]) | (carry[10] & (a[10] ^ b_xor_op[10]));

    assign sum[11] = a[11] ^ b_xor_op[11] ^ carry[11];
    assign carry[12] = (a[11] & b_xor_op[11]) | (carry[11] & (a[11] ^ b_xor_op[11]));

    assign sum[12] = a[12] ^ b_xor_op[12] ^ carry[12];
    assign carry[13] = (a[12] & b_xor_op[12]) | (carry[12] & (a[12] ^ b_xor_op[12]));

    assign sum[13] = a[13] ^ b_xor_op[13] ^ carry[13];
    assign carry[14] = (a[13] & b_xor_op[13]) | (carry[13] & (a[13] ^ b_xor_op[13]));

    assign sum[14] = a[14] ^ b_xor_op[14] ^ carry[14];
    assign carry[15] = (a[14] & b_xor_op[14]) | (carry[14] & (a[14] ^ b_xor_op[14]));

    assign sum[15] = a[15] ^ b_xor_op[15] ^ carry[15];
    assign carry[16] = (a[15] & b_xor_op[15]) | (carry[15] & (a[15] ^ b_xor_op[15]));

    assign sum[16] = a[16] ^ b_xor_op[16] ^ carry[16];
    assign carry[17] = (a[16] & b_xor_op[16]) | (carry[16] & (a[16] ^ b_xor_op[16]));

    assign sum[17] = a[17] ^ b_xor_op[17] ^ carry[17];
    assign carry[18] = (a[17] & b_xor_op[17]) | (carry[17] & (a[17] ^ b_xor_op[17]));

    assign sum[18] = a[18] ^ b_xor_op[18] ^ carry[18];
    assign carry[19] = (a[18] & b_xor_op[18]) | (carry[18] & (a[18] ^ b_xor_op[18]));

    assign sum[19] = a[19] ^ b_xor_op[19] ^ carry[19];
    assign carry[20] = (a[19] & b_xor_op[19]) | (carry[19] & (a[19] ^ b_xor_op[19]));

    assign sum[20] = a[20] ^ b_xor_op[20] ^ carry[20];
    assign carry[21] = (a[20] & b_xor_op[20]) | (carry[20] & (a[20] ^ b_xor_op[20]));

    assign sum[21] = a[21] ^ b_xor_op[21] ^ carry[21];
    assign carry[22] = (a[21] & b_xor_op[21]) | (carry[21] & (a[21] ^ b_xor_op[21]));

    assign sum[22] = a[22] ^ b_xor_op[22] ^ carry[22];
    assign carry[23] = (a[22] & b_xor_op[22]) | (carry[22] & (a[22] ^ b_xor_op[22]));

    assign sum[23] = a[23] ^ b_xor_op[23] ^ carry[23];
    assign carry[24] = (a[23] & b_xor_op[23]) | (carry[23] & (a[23] ^ b_xor_op[23]));

    assign sum[24] = a[24] ^ b_xor_op[24] ^ carry[24];
    assign carry[25] = (a[24] & b_xor_op[24]) | (carry[24] & (a[24] ^ b_xor_op[24]));

    assign sum[25] = a[25] ^ b_xor_op[25] ^ carry[25];
    assign carry[26] = (a[25] & b_xor_op[25]) | (carry[25] & (a[25] ^ b_xor_op[25]));

    assign sum[26] = a[26] ^ b_xor_op[26] ^ carry[26];
    assign carry[27] = (a[26] & b_xor_op[26]) | (carry[26] & (a[26] ^ b_xor_op[26]));

    assign sum[27] = a[27] ^ b_xor_op[27] ^ carry[27];
    assign carry[28] = (a[27] & b_xor_op[27]) | (carry[27] & (a[27] ^ b_xor_op[27]));

    assign sum[28] = a[28] ^ b_xor_op[28] ^ carry[28];
    assign carry[29] = (a[28] & b_xor_op[28]) | (carry[28] & (a[28] ^ b_xor_op[28]));

    assign sum[29] = a[29] ^ b_xor_op[29] ^ carry[29];
    assign carry[30] = (a[29] & b_xor_op[29]) | (carry[29] & (a[29] ^ b_xor_op[29]));

    assign sum[30] = a[30] ^ b_xor_op[30] ^ carry[30];
    assign carry[31] = (a[30] & b_xor_op[30]) | (carry[30] & (a[30] ^ b_xor_op[30]));

    assign sum[31] = a[31] ^ b_xor_op[31] ^ carry[31];
    assign cout = (a[31] & b_xor_op[31]) | (carry[31] & (a[31] ^ b_xor_op[31]));
endmodule
