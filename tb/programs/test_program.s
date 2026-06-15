# RISC-V Assembly Test Program
# This file shows the assembly instructions corresponding to the machine code
# loaded in instruction_memory.v

# Base address: 0x00000000

# Test basic arithmetic operations
main:
    # Initialize registers with test values
    addi x1, x0, 5          # x1 = 5           (0x00500093)
    addi x2, x0, 3          # x2 = 3           (0x00300113)
    
    # Test arithmetic operations  
    add  x3, x1, x2         # x3 = x1 + x2 = 8 (0x002081B3)
    sub  x4, x1, x2         # x4 = x1 - x2 = 2 (0x40208233)
    
    # Test shift operations
    sll  x5, x1, x2         # x5 = x1 << x2    (0x002092B3)
    
    # Test comparison
    slt  x6, x1, x2         # x6 = (x1 < x2)   (0x0020A333)
    
    # Test bitwise operations
    or   x7, x1, x2         # x7 = x1 | x2     (0x0020E3B3)
    and  x8, x1, x2         # x8 = x1 & x2     (0x0020F433)
    
    # End of program - infinite loop (optional)
    # beq  x0, x0, main      # Branch to main   (0xFE000EE3)

# Expected Results:
# x1 = 0x00000005 (5)
# x2 = 0x00000003 (3)  
# x3 = 0x00000008 (8)
# x4 = 0x00000002 (2)
# x5 = 0x00000028 (40)  
# x6 = 0x00000000 (0)
# x7 = 0x00000007 (7)
# x8 = 0x00000001 (1)

# To add new instructions:
# 1. Write the assembly instruction
# 2. Use a RISC-V assembler to get machine code
# 3. Add the machine code to instruction_memory.v
# 4. Update the test program comments

# Common RISC-V Instruction Formats:
# R-type: op rd, rs1, rs2    (ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLT, SLTU)
# I-type: op rd, rs1, imm    (ADDI, ANDI, ORI, XORI, SLLI, SRLI, SRAI, SLTI, SLTIU)
# I-type: op rd, imm(rs1)    (LW)  
# S-type: op rs2, imm(rs1)   (SW)
# B-type: op rs1, rs2, label (BEQ, BNE, BLT, BGE, BLTU, BGEU)
# U-type: op rd, imm         (LUI, AUIPC)
# J-type: op rd, label       (JAL)
# I-type: op rd, rs1, imm    (JALR)
