`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.04.2025 14:20:40
// Design Name: 
// Module Name: DecompressionUnit
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


module DecompressionUnit(
    input  wire clk,
    input  wire [31:0] i,
    output reg  [31:0] decompressed_i
);
`define ILLEGAL_INSTR 32'h00000000

always @(*) begin
    //Default to illegal instruction
    decompressed_i = `ILLEGAL_INSTR;

    // Map llegal uncompressed instructions to a reserved instruction
    if(clk == 1) begin
                if (i[1:0] == 2'b11) begin
            if (i[6:0] == 7'b0110111 || i[6:0] == 7'b0010111 || i[6:0] == 7'b1101111 || 
                i[6:0] == 7'b1100111 || i[6:0] == 7'b1100011 || i[6:0] == 7'b0000011 || 
                i[6:0] == 7'b0100011 || i[6:0] == 7'b0010011 || i[6:0] == 7'b0110011) begin
                decompressed_i = i; // Pass through uncompressed instruction
            end
        end
        // Compressed instruction
        else begin
            case(i[1:0])
                2'b00: begin
                    case (i[15:13])
                    3'b000: begin // C.ADDI4SPN
                            if ((i[12:11] == 2'b00) && (i[10:7] == 4'b0000) && (i[5] == 1'b0) && (i[6] == 1'b0)) begin
                                decompressed_i = 32'b0; // Reserved instruction (could raise trap too)
                            end else begin
                                decompressed_i = {
                                    2'b00,                // imm[11:10]
                                    i[10:7],              // imm[9:6]
                                    i[12:11],             // imm[5:4]
                                    i[5],                 // imm[3]
                                    i[6],                 // imm[2]
                                    2'b00,                // shift left by 2
                                    5'd2,                 // rs1 = x2 (sp)
                                    3'b000,               // funct3 = ADDI
                                    {2'b01, i[4:2]},      // rd = 8 + compressed rd'
                                    7'b0010011            // opcode = ADDI
                                };
                            end
                        end
                        3'b010: begin // C.LW
                            decompressed_i = {
                                5'b00000,             // unused
                                i[5],                 // imm[6]
                                i[12:10],             // imm[5:3]
                                i[6],                 // imm[2]
                                2'b00,                // shift left by 2
                                {2'b01, i[9:7]},       // rs1 = 8 + compressed rs1'
                                3'b010,               // funct3 = LW
                                {2'b01, i[4:2]},       // rd = 8 + compressed rd'
                                7'b0000011             // opcode = LW
                            };
                        end

                        3'b110: begin // C.SW
                            decompressed_i = {
                                5'b00000,             // unused
                                i[5],                 // imm[6]
                                i[12],                // imm[5]
                                {2'b01, i[4:2]},       // rs2 = 8 + compressed rs2'
                                {2'b01, i[9:7]},       // rs1 = 8 + compressed rs1'
                                3'b010,               // funct3 = SW
                                i[11:10],             // imm[4:3]
                                i[6],                 // imm[2]
                                2'b00,                // shift left by 2
                                7'b0100011             // opcode = SW
                            };
                        end

                        default: begin
                            // Reserved/unsupported compressed instructions
                            decompressed_i = `ILLEGAL_INSTR; // Or could trap/raise exception
                        end
                    endcase
                end

                2'b01: begin
                    case(i[15:13])
                        3'b000: begin
                            if (i[11:7] == 5'b00000 && {i[12], i[6:2]} == 6'b000000) begin //Valid C.NOP
                                    decompressed_i = {12'b0,5'b0,3'b0,5'b0,7'b0010011}; //NOP
                            end else if (i[11:7] == 5'b00000) begin //Illegal C.ADDI 
                                    decompressed_i = `ILLEGAL_INSTR;
                            end else begin // C.ADDI
                                decompressed_i = {
                                    {7{i[12]}},     // imm[11:6] = sign-extended
                                    i[6:2],         // imm[4:0]
                                    i[11:7],        // rs1/rd
                                    3'b000,         // funct3
                                    i[11:7],        // rd
                                    7'b0010011      // opcode = ADDI
                                };
                            end
                        end
                        3'b001: begin //C.JAL
                            decompressed_i = {
                                i[12], // imm[20]
                                i[8], // imm[10]
                                i[10:9], //imm[9:8]
                                i[6], //imm[7]
                                i[7], //imm[6]
                                i[2], //imm[5]
                                i[11], //imm[4]
                                i[5:3],  //imm[3:1]
                                i[12], //imm[11]
                                {8{i[12]}}, //imm[19:12]
                                5'b00001,   // x1
                                7'b1101111 // opcode = JAL
                            };
                        end
                        3'b010: begin // C.LI
                            if(i[11:7] == 5'b00000) begin //Illegal C.LI
                                decompressed_i = `ILLEGAL_INSTR;
                            end else begin
                                decompressed_i = {
                                    {7{i[12]}}, // imm[11:6] = sign-extended
                                    i[6:2], // imm[4:0]
                                    5'b00000,      // x0
                                    3'b000,       // funct3
                                    i[11:7],      // rd 
                                    7'b0010011    // opcode = ADDI
                                };
                            end
                        end
                        3'b011: begin
                            if(i[11:7] == 5'b00010) begin //C.ADDI16SP
                                if({i[12],i[6:2]} == 6'b000000) begin //Illegal C.ADDI16SP
                                    decompressed_i = `ILLEGAL_INSTR;
                                end else begin
                                    decompressed_i = {
                                        {3{i[12]}}, // imm[11:9] = sign-extended
                                        i[4:3], // imm[8:7]
                                        i[5], // imm[6]
                                        i[2], // imm[5]
                                        i[6], // imm[4]
                                        4'b0000, // imm[3:0]
                                        5'b00010, // x2
                                        3'b000, // funct3
                                        5'b00010, // x2
                                        7'b0010011 // opcode = ADDI
                                    }; 
                                end
                            end else if(i[11:7] == 5'b00000) begin //Illegal C.LUI
                                decompressed_i = `ILLEGAL_INSTR;
                            end else begin
                                if({i[12],i[6:2]} == 6'b000000) begin //Illegal C.LUI
                                    decompressed_i = `ILLEGAL_INSTR;
                                end else begin //C.LUI
                                    decompressed_i = {
                                        {15{i[12]}}, // imm[31:17] = sign-extended
                                        i[6:2], // imm[16:12]
                                        i[11:7], // rd 
                                        7'b0110111 // opcode = LUI
                                    };
                                end
                            end
                        end
                        3'b100: begin
                            case(i[11:10]) 
                                2'b00: begin //C.SRLI
                                    if(i[12] == 1'b1) //Illegal C.SRLI
                                        decompressed_i = `ILLEGAL_INSTR;
                                    else begin
                                        decompressed_i = {
                                            7'b0000000, // imm[31:25]
                                            i[6:2], // imm[4:0]
                                            {2'b01, i[9:7]}, // rs1 = 8 + compressed rs1'
                                            3'b101, // funct3
                                            {2'b01, i[9:7]}, // rd = 8 + compressed rd'
                                            7'b0010011 // opcode = SRLI
                                        };
                                    end
                                end
                                2'b01: begin //C.SRAI
                                    if(i[12] == 1'b1) //Illegal C.SRAI
                                        decompressed_i = `ILLEGAL_INSTR;
                                    else begin
                                        decompressed_i = {
                                            7'b0100000, // imm[31:25]
                                            i[6:2], // imm[4:0]
                                            {2'b01, i[9:7]}, // rs1 = 8 + compressed rs1'
                                            3'b101, // funct3
                                            {2'b01, i[9:7]}, // rd = 8 + compressed rd'
                                            7'b0010011 // opcode = SRAI
                                        };
                                    end     
                                end
                                2'b10: begin //C.ANDI
                                    decompressed_i = {
                                        {7{i[12]}}, // imm[11:5] = sign-extended
                                        i[6:2], // imm[4:0]
                                        {2'b01, i[9:7]}, // rs1 = 8 + compressed rs1'
                                        3'b111, // funct3
                                        {2'b01, i[9:7]}, // rd = 8 + compressed rd'
                                        7'b0010011 // opcode = ANDI
                                    };
                                end
                                2'b11: begin
                                    case(i[6:5])
                                        2'b00: begin //C.SUB
                                            decompressed_i = {
                                                7'b0100000, //funct7
                                                {2'b01, i[4:2]}, // rs2 = 8 + compressed rs2'
                                                {2'b01, i[9:7]}, // rs1 = 8 + compressed rs1'
                                                3'b000, // funct3
                                                {2'b01, i[9:7]}, // rd = 8 + compressed rd'
                                                7'b0110011 // opcode = SUB
                                            };
                                        end
                                        2'b01: begin //C.XOR
                                            decompressed_i = {
                                                7'b0000000, //funct7
                                                {2'b01, i[4:2]}, // rs2 = 8 + compressed rs2'
                                                {2'b01, i[9:7]}, // rs1 = 8 + compressed rs1'
                                                3'b100, // funct3
                                                {2'b01, i[9:7]}, // rd = 8 + compressed rd'
                                                7'b0110011 // opcode = XOR
                                            };
                                        end
                                        2'b10: begin //C.OR
                                            decompressed_i = {
                                                7'b0000000, //funct7
                                                {2'b01, i[4:2]}, // rs2 = 8 + compressed rs2'
                                                {2'b01, i[9:7]}, // rs1 = 8 + compressed rs1'
                                                3'b110, // funct3
                                                {2'b01, i[9:7]}, // rd = 8 + compressed rd'
                                                7'b0110011 // opcode = OR
                                            };
                                        end
                                        2'b11: begin //C.AND
                                            decompressed_i = {
                                                7'b0000000, //funct7
                                                {2'b01, i[4:2]}, // rs2 = 8 + compressed rs2'
                                                {2'b01, i[9:7]}, // rs1 = 8 + compressed rs1'
                                                3'b111, // funct3
                                                {2'b01, i[9:7]}, // rd = 8 + compressed rd'
                                                7'b0110011 // opcode = AND
                                            };
                                        end
                                    endcase
                                end
                            endcase
                        end
                        3'b101: begin //C.J
                            decompressed_i = {
                                i[12], // imm[20]
                                i[8], // imm[10]
                                i[10:9], //imm[9:8]
                                i[6], //imm[7]
                                i[7], //imm[6]
                                i[2], //imm[5]
                                i[11], //imm[4]
                                i[5:3],  //imm[3:1]
                                i[12], //imm[11]
                                {8{i[12]}}, //imm[19:12]
                                5'b00000,   // x1
                                7'b1101111 // opcode = JAL
                            };
                        end
                        3'b110: begin //C.BEQZ
                            decompressed_i = {
                                {4{i[12]}}, // imm[12|10:8] = sign-extended
                                i[6:5], //imm[7:6]
                                i[2], //imm[5]
                                5'b00000, // rs2 = x0
                                {2'b01, i[9:7]}, // rs1 = 8 + compressed rs1'
                                3'b000, // funct3
                                i[11:10], //imm[4:3]
                                i[4:3], //imm[2:1]
                                i[12], //imm[11]
                                7'b1100011 // opcode = BEQ
                            };
                        end
                        3'b111: begin //C.BNEZ
                            decompressed_i = {
                                {4{i[12]}}, // imm[12|10:8] = sign-extended
                                i[6:5], //imm[7:6]
                                i[2], //imm[5]
                                5'b00000, // rs2 = x0
                                {2'b01, i[9:7]}, // rs1 = 8 + compressed rs1'
                                3'b001, // funct3
                                i[11:10], //imm[4:3]
                                i[4:3], //imm[2:1]
                                i[12], //imm[11]
                                7'b1100011 // opcode = BEQ
                            };
                        end
                        default: begin
                            // Reserved/unsupported compressed instructions
                            decompressed_i = `ILLEGAL_INSTR; // Or could trap/raise exception
                        end
                    endcase
                end
                2'b10: begin
                    case(i[15:13]) //C.SLLI
                        3'b000: begin
                            if(i[12] == 1'b1) begin //Illegal C.SLLI
                                decompressed_i = `ILLEGAL_INSTR;
                            end else if(i[11:7] == 5'b00000) begin //Illegal C.SLLI
                                decompressed_i = `ILLEGAL_INSTR;
                            end else begin
                                decompressed_i = {
                                    7'b0000000, // imm[31:25]
                                    i[6:2], // imm[4:0]
                                    i[11:7], // rs1
                                    3'b001, // funct3
                                    i[11:7], // rd
                                    7'b0010011 // opcode = SLLI
                                };
                                
                            end
                        end
                        3'b010: begin //C.LWSP
                            if(i[11:7] == 5'b00000) begin //Illegal C.LWSP
                                decompressed_i = `ILLEGAL_INSTR;
                            end else begin
                                decompressed_i = {
                                    4'b0000, // unused
                                    i[3:2], // imm[7:6]
                                    i[12], // imm[5]
                                    i[6:4], // imm[4:2]
                                    2'b00, // shift left by 2
                                    5'b00010, // x2
                                    3'b010, // funct3
                                    i[11:7], // rd
                                    7'b0000011 // opcode = SLTI
                                };
                            end
                        end
                        3'b100: begin
                            case(i[12])
                                1'b0: begin
                                    if(i[6:2] == 5'b00000) begin //C.JR
                                        if(i[11:7] == 5'b00000) begin //Illegal C.JR
                                            decompressed_i = `ILLEGAL_INSTR;
                                        end else begin
                                            decompressed_i = {
                                                12'b0, // imm[11:0]
                                                i[11:7], // rs1
                                                3'b000, // funct3
                                                5'b00000, // x0
                                                7'b1100111 // opcode = JALR
                                            };
                                        end
                                    end else begin //C.MV
                                        if(i[11:7] == 5'b00000) begin //Illegal C.MV
                                            decompressed_i = `ILLEGAL_INSTR;
                                        end else begin
                                            decompressed_i = {
                                                7'b0000000, // funct7
                                                i[6:2], // rs2
                                                5'b00000, //x0
                                                3'b000, // funct3
                                                i[11:7], // rd
                                                7'b0110011 // opcode = ADD
                                            };
                                        end
                                    end
                                end
                                1'b1: begin
                                    if((i[6:2] == 5'b00000) && (i[11:7] == 5'b00000)) begin //C.EBREAK (Illegal in this CPU)
                                        decompressed_i = `ILLEGAL_INSTR;
                                    end else if(i[6:2] == 5'b00000) begin //C.JALR
                                        decompressed_i = {
                                            12'b0, // imm[11:0]
                                            i[11:7], // rs1
                                            3'b000, // funct3
                                            5'b00001, // x1
                                            7'b1100111 // opcode = JALR
                                        };
                                    end else begin //C.ADD
                                        if(i[11:7] == 5'b00000) begin //Illegal C.ADD
                                            decompressed_i = `ILLEGAL_INSTR;
                                        end else begin
                                            decompressed_i = {
                                                7'b0000000, // funct7
                                                i[6:2], // rs2
                                                i[11:7], // rs1
                                                3'b000, // funct3
                                                i[11:7], // rd
                                                7'b0110011 // opcode = ADD
                                            };
                                        end  
                                    end
                                end
                            endcase
                        end
                        3'b110: begin //C.SWSP
                            decompressed_i = {
                                4'b0000, // unused
                                i[8:7], //imm[7:6]
                                i[12], // imm[5]
                                i[6:2], //rs2
                                5'b00010, //rs1 = x2
                                3'b010, //funct3
                                i[11:9], //imm[4:2]
                                2'b00, //shift left by 2
                                7'b0100011 // opcode = SW
                            };
                        end
                        default: begin
                            // Reserved/unsupported compressed instructions
                            decompressed_i = `ILLEGAL_INSTR; // Or could trap/raise exception
                        end
                    endcase
                end
            endcase
        end
    end
    
end

endmodule

