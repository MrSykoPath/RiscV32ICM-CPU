# test_sh.s
addi x1, x0, 1234     # x1 = 0x04D2
lui  x2, 0x00010      # x2 = 0x10000
sh   x1, 0(x2)        # store halfword to Mem[0x10000]

