# test_lw.s
lui x1, 0x00010       # x1 = 0x10000
lw x2, 0(x1)          # x2 = Mem[0x10000] (word)

