# test_bltu.s
0x000010B7   # lui x1, 0x00001
0xFFF00113   # addi x2, x0, -1
0x0020E463  # bltu x1, x2, 8
0x00000513   # addi x10, x0, 0
0x00100513   # addi x10, x0, 1

