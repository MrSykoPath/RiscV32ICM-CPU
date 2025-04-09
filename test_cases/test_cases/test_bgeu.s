# test_bgeu.s
addi x1, x0, -1      # x1 = 0xFFFFFFFF
addi x2, x0, 1       # x2 = 1
bgeu x1, x2, label
addi x10, x0, 0
label:
addi x10, x0, 1      # expected: x10 = 1

