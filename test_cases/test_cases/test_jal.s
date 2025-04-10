# test_jal.s
0x008000EF  #jal x1, label         # x1 = PC + 4 # jal x1, label (8-byte forward jump)
0x00000513 #addi x10, x0, 0       # skipped
label:
0x00100513 #addi x10, x0, 1       # x10 = 1, reached via jump

