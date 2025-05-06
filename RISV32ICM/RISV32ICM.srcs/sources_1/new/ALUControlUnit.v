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
input [4:0] Instruction,
output [4:0] ALUSel
    );

assign ALUSel = (ALUOp == 2'b00) ? 5'b00000 : //Add
                (ALUOp == 2'b01) ? 5'b00001 : //Sub
                (ALUOp == 2'b10) ? ((Instruction[2:0] == 3'b000) ? ((Instruction[4] == 1'b1) ? 5'b01010 : ((Instruction[3] == 1'b0) ? 5'b00000 : 5'b00001)) : //Add/Sub/Mul
                                    (Instruction[2:0] == 3'b001) ? ((Instruction[4] == 1'b1) ? 5'b01011 : 5'b00010) : //Sll/Mulh
                                    (Instruction[2:0] == 3'b010) ? ((Instruction[4] == 1'b1) ? 5'b01100 : 5'b00011) : //Slt/Mulhsu
                                    (Instruction[2:0] == 3'b011) ? ((Instruction[4] == 1'b1) ? 5'b01101 : 5'b00100) : //Sltu/Mulhu
                                    (Instruction[2:0] == 3'b100) ? ((Instruction[4] == 1'b1) ? 5'b01110 : 5'b00101) : //Xor/Div
                                    (Instruction[2:0] == 3'b101) ? ((Instruction[4] == 1'b1) ? 5'b01111 : ((Instruction[3] == 1'b0) ? 5'b00110 : 5'b00111)) : //Srl/Sra/Divu
                                    (Instruction[2:0] == 3'b110) ? ((Instruction[4] == 1'b1) ? 5'b10000 : 5'b01000) : //Or/Rem
                                    (Instruction[2:0] == 3'b111) ? ((Instruction[4] == 1'b1) ? 5'b10001 : 5'b01001) : 5'b00000) : //And/Remu/Default
                (ALUOp == 2'b11) ? ((Instruction[2:0] == 3'b000) ? 5'b00000 : //Addi
                                    (Instruction[2:0] == 3'b010) ? 5'b00011 : //Slti
                                    (Instruction[2:0] == 3'b011) ? 5'b00100 : //Sltiu
                                    (Instruction[2:0] == 3'b100) ? 5'b00101 : //Xori
                                    (Instruction[2:0] == 3'b110) ? 5'b01000 : //Ori
                                    (Instruction[2:0] == 3'b111) ? 5'b01001 : //Andi
                                    (Instruction[2:0] == 3'b001) ? 5'b00010 : //Slli
                                    (Instruction[2:0] == 3'b101) ? ((Instruction[3] == 1'b0) ? 5'b00110 : 5'b00111) : 5'b00000) : //Srai/Srli/Default
                5'b00000; // Default case
                
endmodule
