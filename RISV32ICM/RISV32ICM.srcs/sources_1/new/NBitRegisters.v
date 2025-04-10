`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.02.2025 12:08:54
// Design Name: 
// Module Name: NBitRegisters
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


module NBitRegisters #(parameter n = 8) (
    input clk, input rst, input load, input [n-1:0] D, output [n-1:0] Q
    );
    genvar i;
    wire [n-1:0] Intermediary;
    generate
        for(i = 0; i<n; i=i+1) begin
            Mux2x1 mux(
                .A(D[i]),
                .B(Q[i]),
                .sel(load),
                .S(Intermediary[i])
            );
            DFlipFlop flipflop(
                .clk(clk),
                .rst(rst),
                .D(Intermediary[i]),
                .Q(Q[i])
            );
        end
    endgenerate

endmodule
