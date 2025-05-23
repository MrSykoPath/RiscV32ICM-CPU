`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.03.2025 11:37:47
// Design Name: 
// Module Name: DataMemory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DataMemory(
input clk,
input MemRead,
input MemWrite,
input [2:0] func3,
input [11:0] addr,
input [31:0] data_in,
output [31:0] data_out
    );
    reg [7:0] mem[(4*1024-1):0];

     initial begin
    mem[0] = 8'd1;
    mem[1] = 8'd0;
    mem[2] = 8'd0;
    mem[3] = 8'd1; //(word at 0: 0x00000001)
    end

   always @(posedge clk) begin
    if (MemWrite) begin
        case (func3)
            3'b000: begin // Byte
                mem[addr] <= data_in[7:0];
            end
            3'b001: begin // Halfword
                mem[addr]     <= data_in[7:0];
                mem[addr + 1] <= data_in[15:8];
            end
            3'b010: begin // Word
                mem[addr]     <= data_in[7:0];
                mem[addr + 1] <= data_in[15:8];
                mem[addr + 2] <= data_in[23:16];
                mem[addr + 3] <= data_in[31:24];
            end
            default: begin
                mem[addr] <= data_in[7:0]; // Defaulting to byte write
            end
        endcase
    end
end


    assign data_out = (MemRead) ? ((func3 == 3'b000) ? {(mem[addr][7] == 1) ? 24'b111111111111111111111111 : 24'b0, mem[addr]} : //lb
                                   (func3 == 3'b001) ? {(mem[addr+1][7] == 1) ? 16'b1111111111111111 : 16'b0, mem[addr + 1], mem[addr]} : //lh
                                   (func3 == 3'b010) ? {mem[addr + 3], mem[addr + 2], mem[addr + 1], mem[addr]} : //lw
                                   (func3 == 3'b100) ? {24'b0, mem[addr]} : //lbu
                                   (func3 == 3'b101) ? {16'b0, mem[addr + 1], mem[addr]} : 32'b0) : 32'b0; //lhu
endmodule
