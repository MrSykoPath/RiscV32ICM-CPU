`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.03.2025 11:21:20
// Design Name: 
// Module Name: InstMemory
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


module InstMemory(
input [11:0] addr,
output [31:0] data_out
    );
    reg [7:0] mem[(4*1024-1):0];
    assign data_out = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};

    initial begin

        $readmemh("test_cases/test_xori.hex", mem);
    // // Existing instructions
    // mem[0] = 8'h93; // 8-bit hexadecimal
    // mem[1] = 8'h00; // 8-bit hexadecimal
    // mem[2] = 8'h50; // 8-bit hexadecimal
    // mem[3] = 8'h00; // 8-bit hexadecimal
    // mem[4] = 8'h13; // 8-bit hexadecimal
    // mem[5] = 8'h01; // 8-bit hexadecimal
    // mem[6] = 8'hA0; // 8-bit hexadecimal
    // mem[7] = 8'h00; // 8-bit hexadecimal

    // // New instruction 0x002081B3
    // mem[8]  = 8'hB3; // Least significant byte
    // mem[9]  = 8'h81;
    // mem[10] = 8'h20;
    // mem[11] = 8'h00; // Most significant byte
end
endmodule
