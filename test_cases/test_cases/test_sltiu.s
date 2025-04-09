# test_sltiu.s
lui x1, 0x80000      # x1 = 2^31
sltiu x2, x0, 1      # x2 = 1 (0 < 2^31)

