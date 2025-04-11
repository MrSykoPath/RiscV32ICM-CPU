# test_bgeu.s
0xFFF00093   # addi x1, x0, -1
0x00100113   # addi x2, x0, 1
0x00857163   # bgeu x1, x2, 8
0x00000513   # addi x10, x0, 0
0x00100513   # addi x10, x0, 1

