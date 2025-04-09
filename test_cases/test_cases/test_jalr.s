# test_jalr.s
addi x1, x0, 12       # x1 = target offset
jalr x2, x1, 0        # x2 = return address, jump to PC = x1
addi x10, x0, 0       # skipped if jump works
# jump target should point to:
addi x10, x0, 1       # x10 = 1

