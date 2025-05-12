`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.04.2025 22:05:45
// Design Name: 
// Module Name: HazardDetectionUnit
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


module HazardDetectionUnit(
input [1:0] PCSel,
output Flush
    );

    assign Flush = ((PCSel == 2'b01) || (PCSel == 2'b10)) ? 1'b1 : 1'b0; //Flush the pipeline if a branch or jump is taken
endmodule
