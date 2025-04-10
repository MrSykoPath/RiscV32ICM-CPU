`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.03.2025 14:09:54
// Design Name: 
// Module Name: ALUControlUnit
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


module ALUControlUnit(
input [1:0] ALUOp,
input [3:0] Instruction,
output [3:0] ALUSel
    );

assign ALUSel = (ALUOp == 2'b00) ? 4'b0000 : //Add
                (ALUOp == 2'b01) ? 4'b0001 : //Sub
                (ALUOp == 2'b10) ? ((Instruction[2:0] == 3'b000) ? ((Instruction[3] == 1'b0) ? 4'b0000 : 4'b0001) : //Add/Sub
                                    (Instruction[2:0] == 3'b001) ? 4'b0010 : //Sll
                                    (Instruction[2:0] == 3'b010) ? 4'b0011 : //Slt
                                    (Instruction[2:0] == 3'b011) ? 4'b0100 : //Sltu
                                    (Instruction[2:0] == 3'b100) ? 4'b0101 : //Xor
                                    (Instruction[2:0] == 3'b101) ? ((Instruction[3] == 1'b0) ? 4'b0110 : 4'b0111) : //Srl/Sra
                                    (Instruction[2:0] == 3'b110) ? 4'b1000 : //Or
                                    (Instruction[2:0] == 3'b111) ? 4'b1001 : 4'b0000) : //And
                (ALUOp == 2'b11) ? ((Instruction[2:0] == 3'b000) ? 4'b0000 : //Addi
                                    (Instruction[2:0] == 3'b010) ? 4'b0011 : //Slti
                                    (Instruction[2:0] == 3'b011) ? 4'b0100 : //Sltiu
                                    (Instruction[2:0] == 3'b100) ? 4'b0101 : //Xori
                                    (Instruction[2:0] == 3'b110) ? 4'b1000 : //Ori
                                    (Instruction[2:0] == 3'b111) ? 4'b1001 : //Andi
                                    (Instruction[2:0] == 3'b001) ? 4'b0010 : //Slli
                                    (Instruction[2:0] == 3'b101) ? ((Instruction[3] == 1'b0) ? 4'b0110 : 4'b0111) : 4'b0000) : //Srai/Srli
                4'b0000; // Default case
                
endmodule
