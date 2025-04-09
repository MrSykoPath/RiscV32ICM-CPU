# test_lb.s
lui x1, 0x00010       # x1 = 0x10000
lb x2, 0(x1)          # x2 = Mem[0x10000] (signed byte)

