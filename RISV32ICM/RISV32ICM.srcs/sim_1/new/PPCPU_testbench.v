`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2025 23:14:55
// Design Name: 
// Module Name: PPCPU_testbench
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


module PPCPU_testbench(

    );
    localparam clock = 200;
    reg clk;
    reg reset;
    reg [1:0] ledSel;
    reg [3:0] ssdSel;
    reg ssdclk;
    wire [15:0] led;
    wire [12:0] seg;

    PPCPU uut(
        .clk(clk),
        .reset(reset),
        .ledSel(ledSel),
        .ssdSel(ssdSel),
        .ssdclk(ssdclk),
        .led(led),
        .seg(seg)
    );

        initial begin
        clk = 0;
        forever begin
            # (clock / 2);
            clk = ~clk;
        end
    end

     initial begin
    ledSel <= 2'b10;
        reset = 1;
        # ((clock-10) * 2);
        reset = 0;
        # (clock * 15);
    end
endmodule
