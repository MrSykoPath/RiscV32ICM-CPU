`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.02.2025 12:51:20
// Design Name: 
// Module Name: ImmGen
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


module ImmGen(
 output [31:0] gen_out, 
 input [31:0] ins
    );

    wire [31:0] I_gen_out;
    wire [31:0] S_gen_out;
    wire [31:0] SB_gen_out;
    wire [31:0] U_gen_out;
    wire [31:0] UJ_gen_out;

    assign I_gen_out = {(ins[31] == 1) ? 20'b11111111111111111111 : 20'b00000000000000000000, ins[31:20]};
    assign S_gen_out = {(ins[31] == 1) ? 20'b11111111111111111111 : 20'b00000000000000000000, ins[31:25], ins[11:7]};
    assign SB_gen_out = {(ins[31] == 1) ? 20'b11111111111111111111 : 20'b00000000000000000000, ins[31], ins[7], ins[30:25], ins[11:8]};
    assign U_gen_out = {(ins[31] == 1) ? 12'b111111111111 : 12'b000000000000, ins[31:12]};
    assign UJ_gen_out = {(ins[31] == 1) ? 12'b111111111111 : 12'b000000000000, ins[31], ins[19:12],ins[20], ins[30:21]};

    assign gen_out =((ins[6:2] == 5'b00100) && ((ins[14:12] == 5'b001) || (ins[14:12] == 5'b101))) ? {7'b0,I_gen_out[4:0]} :
                    ((ins[6:2] == 5'b11001) || (ins[6:2] == 5'b00000) || (ins[6:2] == 5'b00100)) ? I_gen_out :
                    (ins[6:2] == 5'b01000) ? S_gen_out :
                    (ins[6:2] == 5'b11000) ? SB_gen_out :
                    ((ins[6:2] == 5'b01101) || (ins[6:2] == 5'b00101)) ? U_gen_out :
                    (ins[6:2] == 5'b11011) ? UJ_gen_out : I_gen_out;


endmodule
