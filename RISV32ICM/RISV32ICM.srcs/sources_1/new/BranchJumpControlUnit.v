`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2025 23:03:32
// Design Name: 
// Module Name: BranchJumpControlUnit
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


module BranchJumpControlUnit(
input [2:0] Instruction,
input ZeroFlag,
input NegativeFlag,
input OverflowFlag,
input CarryFlag,
input Branch,
input Jump,
output [1:0] PCSel
    );

    assign PCSel = (Jump == 1 && Branch == 1) ? 2'b01 : //JAL PC_Branch_Jump
                    (Jump == 1 && Branch == 0) ? 2'b10 : //JALR ALUResult
                    (Jump == 0 && Branch == 1) ? ((Instruction == 3'b000) ? ((ZeroFlag) ? 2'b01 : 2'b00) :
                                                  (Instruction == 3'b001) ? ((!ZeroFlag) ? 2'b01 : 2'b00) :
                                                  (Instruction == 3'b100) ? ((NegativeFlag != OverflowFlag) ? 2'b01 : 2'b00) :
                                                  (Instruction == 3'b101) ? ((NegativeFlag == OverflowFlag) ? 2'b01 : 2'b00) :
                                                  (Instruction == 3'b110) ? ((!CarryFlag) ? 2'b01 : 2'b00) :
                                                  (Instruction == 3'b111) ? ((CarryFlag) ? 2'b01 : 2'b00) : 2'b00) : 2'b00; //PC_Next
endmodule
