`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2025 20:46:31
// Design Name: 
// Module Name: ALU
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


module ALU(
input [31:0] A,
input [31:0] B,
input [3:0] Sel,
output [31:0] S,
output ZeroFlag,
output OverflowFlag,
output NegativeFlag,
output CarryFlag
    );

    wire [32:0] Add;
    wire [32:0] Sub;
    wire [31:0] Sll;
    wire [31:0] Slt;
    wire [31:0] Sltu;
    wire [31:0] Xor;
    wire [31:0] Srl;
    wire [31:0] Sra;
    wire [31:0] Or;
    wire [31:0] And;

    assign Add = A + B;
    assign Sub = A + (~B) + 1;
    assign Sll = A << B[4:0];
    assign Slt = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0;
    assign Sltu = (A < B) ? 32'b1 : 32'b0;
    assign Xor = A ^ B;
    assign Srl = A >> B[4:0];
    assign Sra = $signed(A) >>> B[4:0];
    assign Or = A | B;
    assign And = A & B;

    assign S = (Sel == 4'b0000) ? Add[31:0] :
               (Sel == 4'b0001) ? Sub[31:0] :
               (Sel == 4'b0010) ? Sll :
               (Sel == 4'b0011) ? Slt :
               (Sel == 4'b0100) ? Sltu :
               (Sel == 4'b0101) ? Xor :
               (Sel == 4'b0110) ? Srl :
               (Sel == 4'b0111) ? Sra :
               (Sel == 4'b1000) ? Or :
               (Sel == 4'b1001) ? And : 32'b0;

    assign ZeroFlag = (S == 32'b0);
    assign OverflowFlag = 
    (Sel == 4'b0000) ? ((A[31] == B[31]) && (S[31] != A[31])) :  
    (Sel == 4'b0001) ? ((A[31] != B[31]) && (S[31] != A[31])) :  
    1'b0;
    assign NegativeFlag = S[31];
    assign CarryFlag = (Sel == 4'b0000) ? Add[32] : 
                       (Sel == 4'b0001) ? Sub[32] : 
                       1'b0;


endmodule
