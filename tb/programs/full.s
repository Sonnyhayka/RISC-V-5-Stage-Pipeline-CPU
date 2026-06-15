addi x1, x0, 5
addi x2, x0, 3
add x3, x1, x2
sub x4, x1, x2
sll x5, x1, x2
slt x6, x1, x2
or x7, x1, x2
and x8, x1, x2
xor x9, x1, x2
sltu x10, x2, x1
srl x11, x5, x2
addi x20, x0, -8
sra x12, x20, x2
xori x13, x1, 6
ori x14, x1, 2
andi x15, x1, 6
slti x16, x1, 10
sltiu x17, x1, 10
slli x18, x1, 2
srai x19, x20, 1
lui x21, 0x12345
auipc x22, 1
sw x3, 0(x0)
lw x23, 0(x0)
sb x1, 16(x0)
sb x2, 17(x0)
lbu x24, 16(x0)
lbu x25, 17(x0)
lw x26, 16(x0)
addi x6, x0, -1
sb x6, 24(x0)
lb x27, 24(x0)
sh x5, 20(x0)
lhu x28, 20(x0)
lw x29, 0(x0)
add x30, x29, x29
addi x6, x0, 5
beq x1, x6, Lskip
addi x6, x0, 99
Lskip:
bne x1, x6, Lpoison
jal x31, Lafter
Lpoison:
addi x5, x0, 88
Lafter:
beq x0, x0, Lend
addi x5, x0, 77
Lend:
beq x0, x0, Lend
