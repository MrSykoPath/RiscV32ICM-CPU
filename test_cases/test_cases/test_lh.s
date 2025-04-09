# test_lh.s
lui x1, 0x00010       # x1 = 0x10000
lh x2, 0(x1)          # x2 = Mem[0x10000] (signed halfword)

