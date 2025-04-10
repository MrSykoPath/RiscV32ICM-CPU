`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2025 12:59:23
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile #(parameter n = 8)(
input clk,
input rst,
input RegWrite,
input [4:0] ReadReg1,
input [4:0] ReadReg2,
input [4:0] WriteReg,
input [n-1:0] WriteData,
output [n-1:0] ReadData1,
output [n-1:0] ReadData2
    );

    wire [n-1:0] Intermediary [31:0];
    wire [31:0] RegWriteSelect;

    NDecoder #(.n(5)) decoder(
        .D(WriteReg),
        .Q(RegWriteSelect)
    );

    genvar i;
    generate
        for(i = 1; i<32; i=i+1) begin
            NBitRegisters #(.n(n)) register(
                .clk(clk),
                .rst(rst),
                .load(RegWrite & RegWriteSelect[i]),
                .D(WriteData),
                .Q(Intermediary[i])
            );
        end
    endgenerate

    assign Intermediary[0] = 32'b0; // Register 0 is always 0
    assign ReadData1 = Intermediary[ReadReg1];
    assign ReadData2 = Intermediary[ReadReg2];
endmodule
