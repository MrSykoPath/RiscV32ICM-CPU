# test_lhu.s
lui x1, 0x00010       # x1 = 0x10000
lhu x2, 0(x1)         # x2 = Mem[0x10000] (unsigned halfword)

