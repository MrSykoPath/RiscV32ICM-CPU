`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2025 13:15:35
// Design Name: 
// Module Name: NDecoder
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


module NDecoder#(parameter n = 8) (
    input [n-1:0] D,
    output [2**n-1:0] Q
    );

    genvar i;
    generate
        for(i = 0; i<2**n; i=i+1) begin
            assign Q[i] = (D == i);
        end
    endgenerate
endmodule
