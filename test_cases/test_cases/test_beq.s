# test_beq.s
0x00500093 #addi x1, x0, 5
0x00500113 #addi x2, x0, 5
0x00050663 #beq  x1, x2, label
0x00000513 #addi x10, x0, 0      # won't execute if branch is taken
label:
0x00100513 #addi x10, x0, 1      # expected: x10 = 1

