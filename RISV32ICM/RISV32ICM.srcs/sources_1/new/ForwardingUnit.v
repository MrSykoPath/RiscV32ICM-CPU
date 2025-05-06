`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.04.2025 21:12:27
// Design Name: 
// Module Name: ForwardingUnit
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


module ForwardingUnit(
    input [4:0] ID_EX_Rs1,
    input [4:0] ID_EX_Rs2,
    input [4:0] MEM_WB_Rd,
    input MEM_WB_RegWrite,
    output ForwardA,
    output ForwardB
    );

    assign ForwardA = (MEM_WB_RegWrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == ID_EX_Rs1)) ? 1 : 0;
    assign ForwardB = (MEM_WB_RegWrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == ID_EX_Rs2)) ? 1 : 0;
    //This matches the forwarding logic needed for a 3 stage pipeline  
endmodule
