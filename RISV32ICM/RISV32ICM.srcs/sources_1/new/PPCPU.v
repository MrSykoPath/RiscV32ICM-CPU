`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2025 14:28:14
// Design Name: 
// Module Name: PPCPU
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


module PPCPU(
input clk,
input reset,
input [1:0] ledSel,
input [3:0] ssdSel,
input ssdclk,
output [15:0] led,
output [12:0] seg
    );
    reg [1:0] Inst_Op_reg;
    wire [31:0] PC_Out;
    wire [31:0] PC_In;
    wire [31:0] PC_Next;
    wire [31:0] Inst_Data;
    wire [1:0] Inst_Op;
    wire [31:0] decompressed_instr;
    wire [31:0] ImmGen_Out;
    reg pc_en;
    wire Jump;
    wire Branch;
    wire MemRead;
    wire MemWrite;
    wire [1:0] MemtoReg;
    wire [1:0] ALUOp;
    wire [1:0] ALUSrc2;
    wire ALUSrc;
    wire RegWrite;
    wire [31:0] Rs1_Data;
    wire [31:0] Rs2_Data;
    wire [1:0] BranchControl;
    wire Flush;
    wire [31:0] PC_Add;
    wire ForwardA;
    wire ForwardB;
    wire [31:0] ForwardA_Data;
    wire [31:0] ForwardB_Data;
    wire [31:0] ALUSrc1_Data;
    wire [31:0] ALUSrc2_Data;
    wire [4:0] ALUSel;
    wire [31:0] ALUResult;
    wire ZeroFlag;
    wire OverflowFlag;
    wire NegativeFlag;
    wire CarryFlag;
    wire [31:0] Write_Data;
    reg [31:0] Data_Reg;
    wire [31:0] Data_Reg_out;
    wire [31:0] IF_ID_PC_Next;
    wire [31:0] IF_ID_PC_Out;
    wire [31:0] IF_ID_Inst_Data;
    wire [31:0] EX_MEM_ALUResult;
    wire [31:0] EX_MEM_Rs2_Data;
    wire [31:0] EX_MEM_PC_Add;
    wire [2:0] EX_MEM_func3;
    wire [4:0] EX_MEM_Write_Reg;
    wire [31:0] EX_MEM_PC_Next;
    wire [31:0] EX_MEM_ImmGen_Out_shifted;
    wire EX_MEM_MemRead;
    wire EX_MEM_MemWrite;
    wire EX_MEM_Branch;
    wire EX_MEM_Jump;
    wire EX_MEM_RegWrite;
    wire EX_MEM_NegativeFlag;
    wire EX_MEM_OverflowFlag;
    wire EX_MEM_CarryFlag;
    wire EX_MEM_ZeroFlag;
    wire [1:0] EX_MEM_MemtoReg;
    wire [1:0] MEM_WB_MemtoReg;
    wire MEM_WB_RegWrite;
    wire [4:0] MEM_WB_Write_Reg;
    wire [31:0] MEM_WB_ALUResult;
    wire [31:0] MEM_WB_MemData;
    wire [31:0] MEM_WB_PC_Next;
    wire [31:0] MEM_WB_ImmGen_Out_shifted;
    wire [1:0] ID_EX_MemtoReg;
    wire ID_EX_RegWrite;
    wire ID_EX_Jump;
    wire ID_EX_Branch;
    wire ID_EX_MemRead;
    wire ID_EX_MemWrite;
    wire [1:0] ID_EX_ALUOp;
    wire ID_EX_ALUSrc;
    wire [1:0] ID_EX_ALUSrc2;
    wire [31:0] ID_EX_PC_Next;
    wire [31:0] ID_EX_PC_Out;
    wire [31:0] ID_EX_Rs1_Data;
    wire [31:0] ID_EX_Rs2_Data;
    wire [4:0] ID_EX_Rs1;
    wire [4:0] ID_EX_Rs2;
    wire [31:0] ID_EX_ImmGen_Out;
    wire [4:0] ID_EX_funcs;
    wire [4:0] ID_EX_Write_Reg;

    assign PC_In = (BranchControl == 2'b01) ? EX_MEM_PC_Add : //PC_Branch_Jump
                    (BranchControl == 2'b10) ? EX_MEM_ALUResult : //ALUResult
                    (BranchControl == 2'b00) ? PC_Next : 32'b0; //PC_Next

    NBitRegisters #(32) PC( //Program Counter
        .clk(clk),
        .rst(reset),
        .load(pc_en),
        .D(PC_In),
        .Q(PC_Out)
    );

    Memory MainMemory( //Shared Memory
        .clk(clk),
        .MemRead(EX_MEM_MemRead),
        .MemWrite(EX_MEM_MemWrite),
        .func3(EX_MEM_func3),
        .addr((clk) ? PC_Out[11:0] : EX_MEM_ALUResult[11:0]),
        .data_in(EX_MEM_Rs2_Data),
        .data_out(Inst_Data)
    );

    
    always @(*) begin
        if (reset) begin
            Inst_Op_reg <= 2'b11; // Initialize to 2'b11 on reset
        end else if(clk) begin
            Inst_Op_reg <= Inst_Data[1:0]; // Update on the rising edge of the clock
        end else begin
            Inst_Op_reg <= Inst_Op_reg; // Hold the value on the falling edge
        end
    end

    assign Inst_Op = Inst_Op_reg;

    assign PC_Next = (Inst_Op == 2'b11) ? PC_Out + 4 : PC_Out + 2; //If noncompressed instruction, add 4, else add 2

    DecompressionUnit Decompressor( //Decompressor
        .clk(clk),
        .i(Inst_Data),
        .decompressed_i(decompressed_instr)
    );

    always @(posedge clk or posedge reset) begin
    if (reset) begin
        pc_en <= 1'b1; // Enable PC on reset
    end else begin
        if (pc_en) begin
            if (decompressed_instr == 32'b0) begin
                pc_en <= 1'b0; // Disable PC only if illegal instruction is detected
            end
        end
    end
end

    NBitRegisters #(96) IF_ID_Reg( //IF/ID Register
        .clk(~clk),
        .rst(reset),
        .load(1'b1),
        .D({PC_Next,PC_Out, decompressed_instr}),
        .Q({IF_ID_PC_Next, IF_ID_PC_Out, IF_ID_Inst_Data})
    );

    ImmGen ImmediateGenerator( //Immediate Generator
        .gen_out(ImmGen_Out),
        .ins(IF_ID_Inst_Data)
    );

    RegisterFile #(32) RegFile( //Register File
        .clk(~clk),
        .rst(reset),
        .RegWrite(MEM_WB_RegWrite),
        .ReadReg1(IF_ID_Inst_Data[19:15]),
        .ReadReg2(IF_ID_Inst_Data[24:20]),
        .WriteReg(MEM_WB_Write_Reg),
        .WriteData(Write_Data),
        .ReadData1(Rs1_Data),
        .ReadData2(Rs2_Data)
    );

    ControlUnit ControlUnit( //Control Unit
        .Instruction(IF_ID_Inst_Data[6:0]),
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

    HazardDetectionUnit HazardUnit( //Hazard Detection Unit
        .PCSel(BranchControl),
        .Flush(Flush)
    );

    NBitRegisters# (192) ID_EX_Reg( //ID/EX Register
        .clk(clk),
        .rst(reset),
        .load(1'b1),
        .D({
            (Flush) ? 2'b00 : MemtoReg,
            (Flush) ? 1'b0 : RegWrite,
            (Flush) ? 1'b0 : Jump,
            (Flush) ? 1'b0 : Branch,
            (Flush) ? 1'b0 : MemRead,
            (Flush) ? 1'b0 : MemWrite,
            (Flush) ? 2'b00 : ALUOp,
            (Flush) ? 1'b0 : ALUSrc,
            (Flush) ? 2'b00 : ALUSrc2,
            IF_ID_PC_Next,
            IF_ID_PC_Out,
            Rs1_Data,
            Rs2_Data,
            IF_ID_Inst_Data[19:15],
            IF_ID_Inst_Data[24:20],
            ImmGen_Out,
            {IF_ID_Inst_Data[25],IF_ID_Inst_Data[30],IF_ID_Inst_Data[14:12]},
            IF_ID_Inst_Data[11:7]
        }),
        .Q({
            ID_EX_MemtoReg,
            ID_EX_RegWrite,
            ID_EX_Jump,
            ID_EX_Branch,
            ID_EX_MemRead,
            ID_EX_MemWrite,
            ID_EX_ALUOp,
            ID_EX_ALUSrc,
            ID_EX_ALUSrc2,
            ID_EX_PC_Next,
            ID_EX_PC_Out,
            ID_EX_Rs1_Data,
            ID_EX_Rs2_Data,
            ID_EX_Rs1,
            ID_EX_Rs2,
            ID_EX_ImmGen_Out,
            ID_EX_funcs,
            ID_EX_Write_Reg
        })
    );

    assign PC_Add = ID_EX_PC_Out + (ID_EX_ImmGen_Out << 1); //PC + ImmGen_Out

    ForwardingUnit ForwardingUnit( //Forwarding Unit
        .ID_EX_Rs1(ID_EX_Rs1),
        .ID_EX_Rs2(ID_EX_Rs2),
        .MEM_WB_Rd(MEM_WB_Write_Reg),
        .MEM_WB_RegWrite(MEM_WB_RegWrite),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );

    assign ForwardA_Data = (ForwardA) ? Write_Data : ID_EX_Rs1_Data; //Forwarding A
    assign ForwardB_Data = (ForwardB) ? Write_Data : ID_EX_Rs2_Data; //Forwarding B

    assign ALUSrc1_Data = (ALUSrc) ? ID_EX_PC_Out : ForwardA_Data; //ALUSrc1
    assign ALUSrc2_Data = (ALUSrc2 == 2'b01) ? {ID_EX_ImmGen_Out[19:0], 12'b0} : //Shift left 12
                          (ALUSrc2 == 2'b10) ? ID_EX_ImmGen_Out : //Immgen
                          (ALUSrc2 == 2'b00) ? ForwardB_Data : 32'b0; //Reg

    ALUControlUnit ALUControlUnit( //ALU Control Unit
        .ALUOp(ID_EX_ALUOp),
        .Instruction(ID_EX_funcs),
        .ALUSel(ALUSel)
    );

    ALU ALU( //ALU
        .A(ALUSrc1_Data),
        .B(ALUSrc2_Data),
        .Sel(ALUSel),
        .S(ALUResult),
        .ZeroFlag(ZeroFlag),
        .OverflowFlag(OverflowFlag),
        .NegativeFlag(NegativeFlag),
        .CarryFlag(CarryFlag)
    );

    NBitRegisters #(179) EX_MEM_Reg( //EX/MEM Register
        .clk(~clk),
        .rst(reset),
        .load(1'b1),
        .D({
            ID_EX_MemtoReg,
            ID_EX_RegWrite,
            ID_EX_Jump,
            ID_EX_Branch,
            ID_EX_MemRead,
            ID_EX_MemWrite,
            ID_EX_PC_Next,
            PC_Add,
            NegativeFlag,
            OverflowFlag,
            CarryFlag,
            ZeroFlag,
            ALUResult,
            {ID_EX_ImmGen_Out[19:0], 12'b0},
            ForwardB_Data,
            ID_EX_funcs[2:0],
            ID_EX_Write_Reg
        }),
        .Q({
            EX_MEM_MemtoReg,
            EX_MEM_RegWrite,
            EX_MEM_Jump,
            EX_MEM_Branch,
            EX_MEM_MemRead,
            EX_MEM_MemWrite,
            EX_MEM_PC_Next,
            EX_MEM_PC_Add,
            EX_MEM_NegativeFlag,
            EX_MEM_OverflowFlag,
            EX_MEM_CarryFlag,
            EX_MEM_ZeroFlag,
            EX_MEM_ALUResult,
            EX_MEM_ImmGen_Out_shifted,
            EX_MEM_Rs2_Data,
            EX_MEM_func3,
            EX_MEM_Write_Reg
        })
    );

    BranchJumpControlUnit BranchJumpControlUnit( //Branch Jump Control Unit
        .Instruction(EX_MEM_func3),
        .ZeroFlag(EX_MEM_ZeroFlag),
        .NegativeFlag(EX_MEM_NegativeFlag),
        .OverflowFlag(EX_MEM_OverflowFlag),
        .CarryFlag(EX_MEM_CarryFlag),
        .Branch(EX_MEM_Branch),
        .Jump(EX_MEM_Jump),
        .PCSel(BranchControl)
    );

    always @(*) begin
        if (clk == 0) begin
            Data_Reg = Inst_Data; // Update Data_Reg with the instruction data
        end
    end

    assign Data_Reg_out = Data_Reg;

    NBitRegisters #(136) MEM_WB_Reg( //MEM/WB Register
        .clk(clk),
        .rst(reset),
        .load(1'b1),
        .D({
            EX_MEM_MemtoReg,
            EX_MEM_RegWrite,
            EX_MEM_PC_Next,
            EX_MEM_ALUResult,
            Data_Reg_out,
            EX_MEM_ImmGen_Out_shifted,
            EX_MEM_Write_Reg
        }),
        .Q({
            MEM_WB_MemtoReg,
            MEM_WB_RegWrite,
            MEM_WB_PC_Next,
            MEM_WB_ALUResult,
            MEM_WB_MemData,
            MEM_WB_ImmGen_Out_shifted,
            MEM_WB_Write_Reg
        })
    );

    assign Write_Data = (MEM_WB_MemtoReg == 2'b10) ? MEM_WB_PC_Next : //PC
                        (MEM_WB_MemtoReg == 2'b11) ? MEM_WB_MemData : //Data Memory
                        (MEM_WB_MemtoReg == 2'b01) ? MEM_WB_ImmGen_Out_shifted : //Shifted ImmGen
                        MEM_WB_ALUResult; //ALU Result
    
    assign led = (ledSel == 2'b00) ? PC_Out[15:0] :
                (ledSel == 2'b01) ? PC_Out[31:16] :
                (ledSel == 2'b10) ? Rs1_Data[15:0] :
                (ledSel == 2'b11) ? Rs1_Data[31:16] : 16'b0;
    
    assign seg = (ssdSel == 4'b0000) ? PC_Out[12:0] :
                 (ssdSel == 4'b0001) ? PC_Next[12:0] :
                 (ssdSel == 4'b0010) ? PC_Add[12:0] :
                 (ssdSel == 4'b0011) ? PC_In[12:0] :
                 (ssdSel == 4'b0100) ? Rs1_Data[12:0] :
                 (ssdSel == 4'b0101) ? Rs2_Data[12:0] :
                 (ssdSel == 4'b0110) ? Write_Data[12:0] :
                 (ssdSel == 4'b0111) ? ImmGen_Out[12:0] :
                 (ssdSel == 4'b1000) ? EX_MEM_ImmGen_Out_shifted[12:0] :
                 (ssdSel == 4'b1001) ? ALUSrc2_Data[12:0] :
                 (ssdSel == 4'b1010) ? ALUResult[12:0] :
                 (ssdSel == 4'b1011) ? Inst_Data[12:0] : 
                 (ssdSel == 4'b1100) ? {8'b0, MEM_WB_Write_Reg} : 13'b0;
    endmodule
