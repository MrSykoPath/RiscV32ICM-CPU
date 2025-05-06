`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 19:05:20
// Design Name: 
// Module Name: SCCPU
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


module SCCPU(
input clk,
input reset,
input [1:0] ledSel,
input [3:0] ssdSel,
input ssdclk,
output [15:0] led,
output [12:0] seg
    );

    wire [31:0] PC_Out;
    wire [31:0] PC_In;
    wire [31:0] PC_Next;
    wire [31:0] Inst;
    wire Jump;
    wire Branch;
    wire MemRead;
    wire [1:0] MemtoReg;
    wire [1:0] ALUOp;
    wire MemWrite;
    wire [1:0] ALUSrc2; 
    wire ALUSrc;
    wire RegWrite;
    wire [31:0] RegisterData1;
    wire [31:0] RegisterData2;
    wire [31:0] MemtoRegData;
    wire [31:0] ImmGenOut;
    wire [31:0] ALUSrc1Data;
    wire [31:0] ALUSrc2Data;
    wire [3:0] ALUControl;
    wire [31:0] ALUResult;
    wire ZeroFlag;
    wire OverflowFlag;
    wire NegativeFlag;
    wire CarryFlag;
    wire [1:0] BranchControl;
    wire [31:0] PC_Branch_Jump;
    wire [31:0] DataMemoryOut;

    NBitRegisters #(32) PC(
        .clk(clk),
        .rst(reset),
        .load(1'b1),
        .D(PC_In),
        .Q(PC_Out)
    );

    assign PC_Next = PC_Out + 4;

    InstMemory InstMem(
        .addr(PC_Out[11:0]),
        .data_out(Inst)
    );

    ControlUnit CU(
        .Instruction(Inst[6:0]),
        .Jump(Jump),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),
        .ALUSrc2(ALUSrc2),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite)
    );

    RegisterFile #(32) RF(
        .clk(clk),
        .rst(reset),
        .RegWrite(RegWrite),
        .ReadReg1(Inst[19:15]),
        .ReadReg2(Inst[24:20]),
        .WriteReg(Inst[11:7]),
        .WriteData(MemtoRegData),
        .ReadData1(RegisterData1),
        .ReadData2(RegisterData2)
    );

    ImmGen ImmGen(
        .ins(Inst),
        .gen_out(ImmGenOut)
    );

    assign ALUSrc1Data = (ALUSrc) ? PC_Out : RegisterData1;
    
    assign ALUSrc2Data = (ALUSrc2 == 2'b01) ? {ImmGenOut[19:0], 12'b0} : //Shift left 12
                         (ALUSrc2 == 2'b10) ? ImmGenOut : //Immgen
                         (ALUSrc2 == 2'b00) ? RegisterData2 : 32'b0; //Reg

    ALUControlUnit ALUCtrl(
        .ALUOp(ALUOp),
        .Instruction({Inst[30], Inst[14:12]}),
        .ALUSel(ALUControl));
    
    ALU ALU(
        .A(ALUSrc1Data),
        .B(ALUSrc2Data),
        .Sel(ALUControl),
        .S(ALUResult),
        .ZeroFlag(ZeroFlag),
        .OverflowFlag(OverflowFlag),
        .NegativeFlag(NegativeFlag),
        .CarryFlag(CarryFlag)
    );

    BranchJumpControlUnit BJC(
        .Instruction(Inst[14:12]),
        .ZeroFlag(ZeroFlag),
        .NegativeFlag(NegativeFlag),
        .OverflowFlag(OverflowFlag),
        .CarryFlag(CarryFlag),
        .Branch(Branch),
        .Jump(Jump),
        .PCSel(BranchControl)
    );

    assign PC_Branch_Jump = PC_Out + {{ImmGenOut[30:0], 1'b0}}; //Shift left 1

    assign PC_In = (BranchControl == 2'b01) ? PC_Branch_Jump : //PC_Branch_Jump
                    (BranchControl == 2'b10) ? ALUResult : //ALUResult
                    (BranchControl == 2'b00) ? PC_Next : 32'b0; //PC_Next
    
    DataMemory DM(
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .func3(Inst[14:12]),
        .addr(ALUResult[11:0]),
        .data_in(RegisterData2),
        .data_out(DataMemoryOut)
    );

    assign MemtoRegData = (MemtoReg == 2'b00) ? ALUResult : //ALUResult
                        (MemtoReg == 2'b01) ? {ImmGenOut[19:0], 12'b0} : //LUI Immgen shift left 12
                        (MemtoReg == 2'b10) ? PC_Next : //PC_Next
                        (MemtoReg == 2'b11) ? DataMemoryOut : 32'b0; //DataMemory
endmodule
