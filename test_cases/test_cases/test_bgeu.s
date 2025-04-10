# test_bgeu.s
0xFFF00093 #addi x1, x0, -1      # x1 = 0xFFFFFFFF
addi x2, x0, 1       # x2 = 1
0x00100113 #bgeu x1, x2, label
0x00000513 #addi x10, x0, 0
label:
0x00100513 #addi x10, x0, 1      # expected: x10 = 1

