# test_jalr.s
0x00C00093 #addi x1, x0, 12       # x1 = target offset
0x00008167 #jalr x2, x1, 0        # x2 = return address, jump to PC = x1
0x00000513   # addi x10, x0, 0 (skipped if jump works)
# jump target should point to:
0x00100513   # addi x10, x0, 1 (target)

