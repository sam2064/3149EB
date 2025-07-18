////
//module data_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 64) (
//    input       clk, wr_en,
//    input       [ADDR_WIDTH-1:0] wr_addr, wr_data,
//    output reg  [DATA_WIDTH-1:0] rd_data_mem,
//    input       [2:0] funct3
//);
//  
//  
//  
//
//// Array of 64 32-bit words or data
//reg [DATA_WIDTH-1:0] data_ram [0:MEM_SIZE-1];
//wire [5:0] word_addr;
//assign word_addr[5:0] = wr_addr[7:2];
//
//	 
//
//// Synchronous write logic
//always @(posedge clk) begin
///*
//Purpose:
//---
//< Based on the funct3[1:0] and wr_addr[1:0] values store instructions 
//are executed >
//*/
//
//   if (wr_en) begin
//case (funct3[1:0])
//    2'b00: begin // Store byte (sb)
//        data_ram[word_addr] <= (data_ram[word_addr] & ~(8'hFF << (wr_addr[1:0] * 8))) |
//                               (wr_data[7:0] << (wr_addr[1:0] * 8));
//    end
//    2'b01: begin // Store half-word (sh)
//        data_ram[word_addr] <= (data_ram[word_addr] & ~(16'hFFFF << (wr_addr[1] * 16))) |
//                               (wr_data[15:0] << (wr_addr[1] * 16));
//    end
//    2'b10: data_ram[word_addr] <= wr_data; // Store word (sw)
//endcase
//
//end
//end
//
//// Read logic with sign and zero extension
//always @(*) begin
///*
//Purpose:
//---
//< Based on the funct3[1:0] and wr_addr[1:0] values load instructions 
//are executed >
//*/
//
//case (funct3[1:0])
//    2'b00: begin // Load byte (lb or lbu)
//        rd_data_mem <= funct3[2] ? {24'b0, data_ram[word_addr] >> (wr_addr[1:0] * 8) & 8'hFF} :
//                                   {{24{data_ram[word_addr][(wr_addr[1:0] * 8) + 7]}}, data_ram[word_addr] >> (wr_addr[1:0] * 8) & 8'hFF};
//    end
//    2'b01: begin // Load half-word (lh or lhu)
//        rd_data_mem <= funct3[2] ? {16'b0, data_ram[word_addr] >> (wr_addr[1] * 16) & 16'hFFFF} :
//                                   {{16{data_ram[word_addr][(wr_addr[1] * 16) + 15]}}, data_ram[word_addr] >> (wr_addr[1] * 16) & 16'hFFFF};
//    end
//    2'b10: rd_data_mem <= data_ram[word_addr]; // Load word (lw)
//    default: rd_data_mem <= 32'bx; // Undefined
//endcase
//
//end
//
//
//endmodule

//
module data_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 64) (
    input       clk, wr_en,
    input       [ADDR_WIDTH-1:0] wr_addr, wr_data,
    output reg  [DATA_WIDTH-1:0] rd_data_mem,
    input       [2:0] funct3
);

// Array of 64 32-bit words or data
reg [DATA_WIDTH-1:0] data_ram [0:MEM_SIZE-1];
wire [5:0] word_addr;
assign word_addr[5:0] = wr_addr[7:2];

// Synchronous write logic
always @(posedge clk) begin
/*
Purpose:
---
< Based on the funct3[1:0] and wr_addr[1:0] values store instructions 
are executed >
*/

   if (wr_en) begin
       case (funct3[1:0])
           2'b00: begin // Store byte (sb)
               case (wr_addr[1:0])
                   2'b00: data_ram[word_addr][7:0]   <= wr_data[7:0];
                   2'b01: data_ram[word_addr][15:8]  <= wr_data[7:0];
                   2'b10: data_ram[word_addr][23:16] <= wr_data[7:0];
                   2'b11: data_ram[word_addr][31:24] <= wr_data[7:0];
               endcase
           end
           2'b01: begin // Store half-word (sh)
               if (wr_addr[1] == 1'b0)
                   data_ram[word_addr][15:0] <= wr_data[15:0];
               else
                   data_ram[word_addr][31:16] <= wr_data[15:0];
           end
           2'b10: data_ram[word_addr] <= wr_data; // Store word (sw)
       endcase
   end
end

// Read logic with sign and zero extension
always @(*) begin
/*
Purpose:
---
< Based on the funct3[1:0] and wr_addr[1:0] values load instructions 
are executed >
*/

    case (funct3[1:0])
        2'b00: begin // Load byte (lb or lbu)
            case (wr_addr[1:0])
                2'b00: rd_data_mem <= funct3[2] ? {24'b0, data_ram[word_addr][7:0]}   : {{24{data_ram[word_addr][7]}}, data_ram[word_addr][7:0]};
                2'b01: rd_data_mem <= funct3[2] ? {24'b0, data_ram[word_addr][15:8]}  : {{24{data_ram[word_addr][15]}}, data_ram[word_addr][15:8]};
                2'b10: rd_data_mem <= funct3[2] ? {24'b0, data_ram[word_addr][23:16]} : {{24{data_ram[word_addr][23]}}, data_ram[word_addr][23:16]};
                2'b11: rd_data_mem <= funct3[2] ? {24'b0, data_ram[word_addr][31:24]} : {{24{data_ram[word_addr][31]}}, data_ram[word_addr][31:24]};
            endcase
        end
        2'b01: begin // Load half-word (lh or lhu)
            if (wr_addr[1] == 1'b0)
                rd_data_mem <= funct3[2] ? {16'b0, data_ram[word_addr][15:0]} : {{16{data_ram[word_addr][15]}}, data_ram[word_addr][15:0]};
            else
                rd_data_mem <= funct3[2] ? {16'b0, data_ram[word_addr][31:16]} : {{16{data_ram[word_addr][31]}}, data_ram[word_addr][31:16]};
        end
        2'b10: rd_data_mem <= data_ram[word_addr]; // Load word (lw)
        default: rd_data_mem <= 32'bx; // Undefined
    endcase
end

endmodule



//
//// data_mem.v - data memory
//
//module data_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 64) (
//    input       clk, wr_en,
//    input [2:0] funct3,
//    input       [ADDR_WIDTH-1:0] wr_addr, wr_data,
//    output reg  [DATA_WIDTH-1:0] rd_data_mem
//);
//
//// array of 64 32-bit data
//reg [DATA_WIDTH-1:0] data_ram [0:MEM_SIZE-1];
//
//wire [ADDR_WIDTH-1:0] word_addr = wr_addr[DATA_WIDTH-1:2] % 64;
//
//// synchronous write logic
//always @(posedge clk) begin
//    if (wr_en) begin
//        case (funct3)
//            3'b000: begin // sb
//                case (wr_addr[1:0])
//                    2'b00: data_ram[word_addr][ 7: 0] = wr_data[7:0];
//                    2'b01: data_ram[word_addr][15: 8] = wr_data[7:0];
//                    2'b10: data_ram[word_addr][23:16] = wr_data[7:0];
//                    2'b11: data_ram[word_addr][31:24] = wr_data[7:0];
//                endcase
//            end
//            3'b010: data_ram[word_addr] <= wr_data; // sw
//        endcase
//    end
//end
//
//always @(*) begin
//    case (funct3)
//        3'b000: begin // lb
//            case (wr_addr[1:0])
//                2'b00: rd_data_mem = {{24{data_ram[word_addr][ 7]}}, data_ram[word_addr][ 7: 0]};
//                2'b01: rd_data_mem = {{24{data_ram[word_addr][15]}}, data_ram[word_addr][15: 8]};
//                2'b10: rd_data_mem = {{24{data_ram[word_addr][23]}}, data_ram[word_addr][23:16]};
//                2'b11: rd_data_mem = {{24{data_ram[word_addr][31]}}, data_ram[word_addr][31:24]};
//            endcase
//        end
//        3'b100: begin // lbu
//            case (wr_addr[1:0])
//                2'b00: rd_data_mem = {24'b0, data_ram[word_addr][ 7: 0]};
//                2'b01: rd_data_mem = {24'b0, data_ram[word_addr][15: 8]};
//                2'b10: rd_data_mem = {24'b0, data_ram[word_addr][23:16]};
//                2'b11: rd_data_mem = {24'b0, data_ram[word_addr][31:24]};
//            endcase
//        end
//        3'b010: rd_data_mem = data_ram[word_addr]; // lw
//        default: rd_data_mem = 32'bx;
//    endcase
//end
//
//endmodule

