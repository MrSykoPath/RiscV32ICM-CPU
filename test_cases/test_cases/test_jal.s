# test_jal.s
jal x1, label         # x1 = PC + 4
addi x10, x0, 0       # skipped
label:
addi x10, x0, 1       # x10 = 1, reached via jump

