# test_jalr.s
0x00C00093   # addi x1, x0, 12
0x00008167   # jalr x2, x1, 0
0x00000513   # addi x10, x0, 0 (skipped)
0x00100513   # addi x10, x0, 1 (target)
