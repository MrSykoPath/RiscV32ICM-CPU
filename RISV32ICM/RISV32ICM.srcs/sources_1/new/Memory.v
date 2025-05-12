`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2025 14:34:26
// Design Name: 
// Module Name: Memory
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


module Memory(
input clk,
input MemRead,
input MemWrite,
input [2:0] func3,
input [11:0] addr,
input [31:0] data_in,
output [31:0] data_out
    );
    reg [7:0] mem[(4*1024-1):0];

    integer i;

    initial begin
  
        // Initialize all memory to 0
        for (i = 0; i < (4*1024); i = i + 2) begin
            {mem[i+1],mem[i]} = 16'b0000000000000001; // C.NOP
        end
    //    {mem[7], mem[6]} = 16'b0000000001000000; // Word at address 0 (c.addi4spn x8, 4) correct
    //     {mem[9],mem[8]} = 16'b0100010000000001; //c.li x8, 0
    //     {mem[11],mem[10]} = 16'b0100000000100000; //c.lw x8, 64(x8) 
    //     {mem[13],mem[12]} = 16'b1100000011000000; //c.sw x8, 4(x9)
    //    {mem[67], mem[66], mem[65], mem[64]} = 32'd303; //Data here
    // {mem[9], mem[8]} = 16'b0010000000000001; //c.jal 0
    // $readmemb("output (2).txt",mem);
    // {mem[5], mem[4]} = 16'b0110000101000001; // c.addi16sp 16
    //  {mem[5], mem[4]} = 16'b0101010001111101; //c.lui x8, -1
    //  {mem[7], mem[6]} = 16'b1000000000000101; // c.srli x8, 1
    //{mem[7], mem[6]} = 16'b1000010000000101; // c.srai x8, 1
    //{mem[7], mem[6]} = 16'b1000100000001101; // c.andi x8, 3
    // {mem[7], mem[6]} = 16'b0100010000011001; // c.li x8, 6
    // {mem[7], mem[6]} = 16'b0100010010010101; // c.li x9, 5
    //{mem[9], mem[8]} = 16'b1000110000000101; // c.sub x8, x9
    //{mem[9], mem[8]} = 16'b1000110000100101; // c.xor x8, x9
    //{mem[9], mem[8]} = 16'b1000110001000101; // c.or x8, x9
    // {mem[9], mem[8]} = 16'b1000110001100101; // c.and x8, x9
    //  {mem[5], mem[4]} = 16'b1010000011100001; //c.j 200
    //  {mem[7], mem[6]} = 16'b1100000000000101; //c.beqz x8, 32
    //  {mem[7], mem[6]} = 16'b1110000000000101; //c.bnez x8, 32
    //{mem[7], mem[6]} = 16'b0000010000000110; //c.slli x8, 1
    // {mem[5], mem[4]} = 16'b0000000101000001; // c.addi x2, 16
    // {mem[7], mem[6]} = 16'b0000000101000001; // c.addi x2, 16
    //  {mem[9], mem[8]} = 16'b0101010000000010; //c.lwsp x8, 32
    //{mem[9], mem[8]} = 16'b1000000100000010; //c.jr x2
    // {mem[9], mem[8]} = 16'b1000010000001010; //c.mv x8, x2
    //{mem[9], mem[8]} = 16'b1001000100000010; //c.jalr x2
    // {mem[9], mem[8]} = 16'b1001010000001010; //c.add x8, x2
    // {mem[11], mem[10]} = 16'b1101000000100010; //c.swsp x8, 32
        // {mem[67], mem[66], mem[65], mem[64]} = 32'hfffffffd; //Data here
        // {mem[11], mem[10],mem[9], mem[8]} = 32'b00000010100000010000010000110011; //mul x8, x2, x8
        // {mem[7], mem[6],mem[5], mem[4]} = 32'b10000100000000000000010000110111; //lui x8, -507904
        // {mem[11], mem[10],mem[9], mem[8]} = 32'b01111100000000000000000100110111; //lui x2, 507904
        // {mem[15], mem[14],mem[13], mem[12]} = 32'b00000010100000010001010000110011; //mulh x8, x2, x8
        // {mem[15], mem[14],mem[13], mem[12]} = 32'b00000010100000010010010000110011; //mulhsu x8, x2, x8
        //  {mem[7], mem[6],mem[5], mem[4]} = 32'b00001100000000000000010000110111; //lui x8, 49152
        //  {mem[11], mem[10],mem[9], mem[8]} = 32'b00001100000000000000000100110111; //lui x2, 49152
        //  {mem[15], mem[14],mem[13], mem[12]} = 32'b00000010100000010011010000110011; //mulhu x8, x2, x8
        //  {mem[7], mem[6],mem[5], mem[4]} = 32'b00000000000000000001010000110111; //lui x8, 1
        //  {mem[11], mem[10],mem[9], mem[8]} = 32'b00000100000000000010000100000011; //lw x2, 64(x0)
        // {mem[15], mem[14],mem[13], mem[12]} = 32'b00000010001001000100010000110011; //div x8, x8, x2
        // {mem[15], mem[14],mem[13], mem[12]} = 32'b00000010001001000101010000110011; //divu x8, x8, x2
        // {mem[15], mem[14],mem[13], mem[12]} = 32'b00000010001001000110010000110011; //rem x8, x8, x2
        // {mem[15], mem[14],mem[13], mem[12]} = 32'b00000010001001000111010000110011; //remu x8, x8, x2
        // -------------------------------------------------------------------------------------------------
        // {mem[131], mem[130],mem[129], mem[128]} = 32'd5; //Data to store
        // {mem[7], mem[6],mem[5], mem[4]} = 32'b00001000000000000010011110000011; //lw x15, 128(x0)
        // {mem[9],mem[8]} = 16'b0100011100000101; //c.li x14, 1
        // {mem[11],mem[10]} = 16'b1100011110001001; //c.beqz x15, 10
        // {mem[15],mem[14],mem[13], mem[12]} = 32'b00000010111101110000011100110011; //mul x14, x14, x15
        // {mem[17],mem[16]} = 16'b0001011111111101; //c.addi x15, -1
        // {mem[19],mem[18]} = 16'b1111111111101101; //c.bnez x15, -6
        // {mem[21],mem[20]} = 16'b1000011110111010; //c.mv x15, x14
        // {mem[23],mem[22]} = 16'b1001000000000010; //c.ebreak
        // -------------------------------------------------------------------------------------------------
        {mem[131], mem[130],mem[129], mem[128]} = 32'd5; //Data to store
        {mem[7], mem[6],mem[5], mem[4]} = 32'b00001000000000000010011110000011; //lw x15, 128(x0) a0
        {mem[9],mem[8]} = 16'b0110000101111101; //c.addi16sp 496
        {mem[11],mem[10]} = 16'b0100011100000101; //c.li x14, 1 a1 //Factorial
        {mem[13],mem[12]} = 16'b0100011010000101; //c.li x13, 1 a2
        {mem[17],mem[16],mem[15],mem[14]} = 32'b00000000110101111101010001100011; //bge x15, x13, 8
        {mem[19],mem[18]} = 16'b1000011110111010; //c.mv x15, x14
        {mem[21],mem[20]} = 16'b1000000010000010; //c.jr x1
        {mem[23],mem[22]} = 16'b0111000101111101; //c.addi16sp -16 //Recurse
        {mem[25],mem[24]} = 16'b1100011000000110; //c.swsp x1, 12
        {mem[27],mem[26]} = 16'b1100010000111110; //c.swsp x15, 8
        {mem[29],mem[28]} = 16'b0001011111111101; //c.addi x15, -1
        {mem[31],mem[30]} = 16'b0011011111110101; //c.jal -20
        {mem[33],mem[32]} = 16'b0100011100100010; //c.lwsp x14, 8
        {mem[37],mem[36],mem[35],mem[34]} = 32'b00000010111001111000011110110011; //mul x15, x15, x14
        {mem[39],mem[38]} = 16'b0100000010110010; //c.lwsp x1, 12
        {mem[41],mem[40]} = 16'b0110000101000001; //c.addi16sp 16
        {mem[45],mem[44],mem[43],mem[42]} = 32'b00000000000000001000001101100011; //beq x1, x0, 6
        {mem[47],mem[46]} = 16'b1000000010000010; //c.jr x1
        {mem[51],mem[50]} = 16'b1001000000000010; //c.ebreak
    end


   always @(negedge clk) begin
    if (MemWrite) begin
        case (func3)
            3'b000: begin // Byte
                mem[addr] <= data_in[7:0];
            end
            3'b001: begin // Halfword
                mem[addr]     <= data_in[7:0];
                mem[addr + 1] <= data_in[15:8];
            end
            3'b010: begin // Word
                mem[addr]     <= data_in[7:0];
                mem[addr + 1] <= data_in[15:8];
                mem[addr + 2] <= data_in[23:16];
                mem[addr + 3] <= data_in[31:24];
            end
            default: begin
                mem[addr] <= data_in[7:0]; // Defaulting to byte write
            end
        endcase
    end
end


    assign data_out = (clk) ? {mem[addr + 3], mem[addr + 2], mem[addr + 1], mem[addr]} : // Read Instruction
                                   ((MemRead) ? ((func3 == 3'b000) ? {(mem[addr][7] == 1) ? 24'b111111111111111111111111 : 24'b0, mem[addr]} : //lb
                                   (func3 == 3'b001) ? {(mem[addr+1][7] == 1) ? 16'b1111111111111111 : 16'b0, mem[addr + 1], mem[addr]} : //lh
                                   (func3 == 3'b010) ? {mem[addr + 3], mem[addr + 2], mem[addr + 1], mem[addr]} : //lw
                                   (func3 == 3'b100) ? {24'b0, mem[addr]} : //lbu
                                   (func3 == 3'b101) ? {16'b0, mem[addr + 1], mem[addr]} : 32'b0) : 32'b0); //lhu ; 
endmodule
