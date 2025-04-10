# test_bne.s
0x00500093 #addi x1, x0, 5
0x00300113 #addi x2, x0, 3
0x00051663 #bne  x1, x2, label
0x00000513 #addi x10, x0, 0
label:
0x00100513 #addi x10, x0, 1      # expected: x10 = 1

