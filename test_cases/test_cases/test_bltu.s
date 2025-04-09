# test_bltu.s
lui x1, 0x00001      # x1 = 0x1000
addi x2, x0, -1      # x2 = 0xFFFFFFFF (unsigned > x1)
bltu x1, x2, label
addi x10, x0, 0
label:
addi x10, x0, 1      # expected: x10 = 1

