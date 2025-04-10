`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.03.2025 11:21:20
// Design Name: 
// Module Name: InstMemory
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


module InstMemory(
input [7:0] addr,
output [31:0] data_out
    );
    reg [7:0] mem[255:0];
    assign data_out = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};

    // initial begin

    // end
endmodule
