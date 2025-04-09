# test_blt.s
addi x1, x0, 2
addi x2, x0, 4
blt  x1, x2, label
addi x10, x0, 0
label:
addi x10, x0, 1      # expected: x10 = 1

