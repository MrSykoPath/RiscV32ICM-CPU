# test_sra.s
addi x1, x0, -8
addi x2, x0, 1
sra  x3, x1, x2      # x3 = -4 (preserves sign bit)

