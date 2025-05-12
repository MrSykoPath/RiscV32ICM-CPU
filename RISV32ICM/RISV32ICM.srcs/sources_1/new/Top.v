`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.05.2025 16:32:48
// Design Name: 
// Module Name: Top
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


module Top(
input clk,
input reset,
input [1:0] ledSel,
input [3:0] ssdSel,
input ssdclk,
output [15:0] led,
output [3:0] Anode,
output [6:0] LED_out
    );
    wire [12:0] seg;
    PPCPU ppcpu(
        .clk(clk),
        .reset(reset),
        .ledSel(ledSel),
        .ssdSel(ssdSel),
        .ssdclk(ssdclk),
        .led(led),
        .seg(seg)
    );

    Four_Digit_Seven_Segment_Driver fssd(
        .clk(clk),
        .num1(seg),
        .Anode(Anode),
        .LED_out(LED_out)
    );
endmodule
