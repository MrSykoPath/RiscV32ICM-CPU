# test_beq.s
addi x1, x0, 5
addi x2, x0, 5
beq  x1, x2, label
addi x10, x0, 0      # won't execute if branch is taken
label:
addi x10, x0, 1      # expected: x10 = 1

