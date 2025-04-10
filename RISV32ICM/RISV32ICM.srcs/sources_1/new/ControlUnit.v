`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2025 18:39:12
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit(
input [6:0] Instruction,
output Jump,
output Branch,
output MemRead,
output [1:0] MemtoReg,
output [1:0] ALUOp,
output MemWrite,
output [1:0] ALUSrc2,
output ALUSrc,
output RegWrite
    );

assign Jump = ((Instruction[6:2] == 5'b11001) || (Instruction[6:2] == 5'b11011)) ? 1 : 0; //Done
assign Branch = ((Instruction[6:2] == 5'b11000) || (Instruction[6:2] == 5'b11011) ) ? 1 : 0; //Done
assign MemRead = (Instruction[6:2] == 5'b00000) ? 1: 0; //Done
assign MemtoReg = ((Instruction[6:2] == 5'b00100) || (Instruction[6:2] == 5'b01100) || (Instruction[6:2] == 5'b00101)) ? 2'b00: //ALUResult
                    (Instruction[6:2] == 5'b01101) ? 2'b01 : //LUI Immgen shift left 12
                    ((Instruction[6:2] == 5'b11011) || (Instruction[6:2] == 5'b11001)) ? 2'b10 : //PC_Next
                    (Instruction[6:2] == 5'b00000) ? 2'b11 : 2'b00; //Done  //DataMemory               
assign ALUOp = ((Instruction[6:2] == 5'b01100)) ? 2'b10 :
                ((Instruction[6:2] == 5'b00100)) ? 2'b11 :
                (Instruction[6:2] == 5'b11000) ? 2'b01 : 2'b00; //Done
assign MemWrite = (Instruction[6:2] == 5'b01000) ? 1: 0; //Done
assign ALUSrc = ((Instruction[6:2] == 5'b11011) || (Instruction[6:2] == 5'b11001) || (Instruction[6:2] == 5'b00101)) ? 1 : 0; //Done 1=PC 0=Reg
assign ALUSrc2 = ((Instruction[6:2] == 5'b01101) || (Instruction[6:2] == 5'b00101)) ? 2'b01 : //Immgen shift 12
                 ((Instruction[6:2] == 5'b11001) || (Instruction[6:2] == 5'b00000) || (Instruction[6:2] == 5'b01000) || (Instruction[6:2] == 5'b00100)) ? 2'b10 : //Immgen
                 ((Instruction[6:2] == 5'b11000) || (Instruction[6:2] == 5'b01100)) ? 2'b00 : 2'b00; //Done Reg
assign RegWrite = ((Instruction[6:2] == 5'b00100) ||
                     (Instruction[6:2] == 5'b01100) ||
                      (Instruction[6:2] == 5'b00101) ||
                       (Instruction[6:2] == 5'b01101) ||
                        (Instruction[6:2] == 5'b11011) ||
                         (Instruction[6:2] == 5'b11001) ||
                          (Instruction[6:2] == 5'b00000)) ? 1 : 0; //Done
endmodule
