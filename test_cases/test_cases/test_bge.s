# test_bge.s
addi x1, x0, 5
addi x2, x0, 4
bge  x1, x2, label
addi x10, x0, 0
label:
addi x10, x0, 1      # expected: x10 = 1

