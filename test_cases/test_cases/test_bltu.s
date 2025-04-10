# test_bltu.s
0x000010B7 #lui x1, 0x00001      # x1 = 0x1000
0xFFF00113 #addi x2, x0, -1      # x2 = 0xFFFFFFFF (unsigned > x1)
0x0005C663 #bltu x1, x2, label
0x00000513 #addi x10, x0, 0
label:
0x00100513 #addi x10, x0, 1      # expected: x10 = 1

