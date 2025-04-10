# test_blt.s
0x00200093 #addi x1, x0, 2
0x00400113 #addi x2, x0, 4
0x00054663 #blt  x1, x2, label
0x00000513 #addi x10, x0, 0
label:
0x00100513 #addi x10, x0, 1      # expected: x10 = 1

