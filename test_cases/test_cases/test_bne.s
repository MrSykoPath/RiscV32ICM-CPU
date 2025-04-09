# test_bne.s
addi x1, x0, 5
addi x2, x0, 3
bne  x1, x2, label
addi x10, x0, 0
label:
addi x10, x0, 1      # expected: x10 = 1

