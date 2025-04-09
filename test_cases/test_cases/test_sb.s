# test_sb.s
addi x1, x0, 97       # x1 = 97 ('a' in ASCII)
lui  x2, 0x00010      # x2 = 0x10000
sb   x1, 0(x2)        # store byte to Mem[0x10000]

