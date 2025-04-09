# test_sltu.s
lui  x1, 0x80000     # x1 = large positive number (2^31)
addi x2, x0, 1
sltu x3, x2, x1      # x3 = 1 (1 < 2^31)

