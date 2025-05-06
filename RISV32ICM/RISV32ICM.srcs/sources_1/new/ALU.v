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
input [4:0] Sel,
output signed [31:0] S,
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
    wire [63:0] Mul;
    wire [63:0] MULHSU;
    wire [63:0] MULHU;
    wire [31:0] Div;
    wire [31:0] Divu;
    wire [31:0] Rem;
    wire [31:0] Remu;


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
    assign Mul = $signed(A) * $signed(B);
    assign MULHSU = $signed(A) * B;
    assign MULHU = A * B;
    assign Div = (B == 0) ? {32{1'b1}} : $signed(A) / $signed(B);
    assign Divu = (B == 0) ? {32{1'b1}} : A / B;
    assign Rem = $signed(A) % $signed(B);
    assign Remu = A % B;

    assign S = (Sel == 5'b00000) ? Add[31:0] :
               (Sel == 5'b00001) ? Sub[31:0] :
               (Sel == 5'b00010) ? Sll :
               (Sel == 5'b00011) ? Slt :
               (Sel == 5'b00100) ? Sltu :
               (Sel == 5'b00101) ? Xor :
               (Sel == 5'b00110) ? Srl :
               (Sel == 5'b00111) ? Sra :
               (Sel == 5'b01000) ? Or :
               (Sel == 5'b01001) ? And :
               (Sel == 5'b01010) ? Mul[31:0]:
               (Sel == 5'b01011) ? Mul[63:32]:
               (Sel == 5'b01100) ? MULHSU[63:32]:
               (Sel == 5'b01101) ? MULHU[63:32]:
               (Sel == 5'b01110) ? Div :
               (Sel == 5'b01111) ? Divu :
               (Sel == 5'b10000) ? Rem :
               (Sel == 5'b10001) ? Remu : 32'b0;

    assign ZeroFlag = (S == 32'b0);
    assign OverflowFlag = 
    (Sel == 5'b00000) ? ((A[31] == B[31]) && (S[31] != A[31])) :  
    (Sel == 5'b00001) ? ((A[31] != B[31]) && (S[31] != A[31])) :  
    1'b0;
    assign NegativeFlag = S[31];
    assign CarryFlag = (Sel == 5'b00000) ? Add[32] : 
                       (Sel == 5'b00001) ? Sub[32] : 
                       1'b0;


endmodule
