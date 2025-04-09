# test_sw.s
addi x1, x0, 0xABCD   # x1 = 0xABCD
lui  x2, 0x00010      # x2 = 0x10000
sw   x1, 0(x2)        # store word to Mem[0x10000]

