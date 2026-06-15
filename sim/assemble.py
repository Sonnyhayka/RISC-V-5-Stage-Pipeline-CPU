import sys, re

REG = {f"x{i}": i for i in range(32)}

R = {
    "add": (0x00, 0x0), "sub": (0x20, 0x0), "sll": (0x00, 0x1),
    "slt": (0x00, 0x2), "sltu": (0x00, 0x3), "xor": (0x00, 0x4),
    "srl": (0x00, 0x5), "sra": (0x20, 0x5), "or": (0x00, 0x6),
    "and": (0x00, 0x7),
}
I_ALU = {
    "addi": 0x0, "slti": 0x2, "sltiu": 0x3, "xori": 0x4,
    "ori": 0x6, "andi": 0x7,
}
I_SH = {"slli": (0x00, 0x1), "srli": (0x00, 0x5), "srai": (0x20, 0x5)}
LOAD = {"lb": 0x0, "lh": 0x1, "lw": 0x2, "lbu": 0x4, "lhu": 0x5}
STORE = {"sb": 0x0, "sh": 0x1, "sw": 0x2}
BRANCH = {"beq": 0x0, "bne": 0x1, "blt": 0x4, "bge": 0x5, "bltu": 0x6, "bgeu": 0x7}


def reg(t):
    t = t.strip()
    if t not in REG:
        raise ValueError(f"bad register {t!r}")
    return REG[t]


def imm(t):
    return int(t.strip(), 0)


def enc_r(f7, rd, f3, rs1, rs2, op):
    return (f7 << 25) | (rs2 << 20) | (rs1 << 15) | (f3 << 12) | (rd << 7) | op


def enc_i(immv, rs1, f3, rd, op):
    return ((immv & 0xFFF) << 20) | (rs1 << 15) | (f3 << 12) | (rd << 7) | op


def enc_s(immv, rs2, rs1, f3, op):
    immv &= 0xFFF
    return ((immv >> 5) << 25) | (rs2 << 20) | (rs1 << 15) | (f3 << 12) | ((immv & 0x1F) << 7) | op


def enc_b(immv, rs2, rs1, f3, op):
    immv &= 0x1FFF
    b12 = (immv >> 12) & 1
    b11 = (immv >> 11) & 1
    b10_5 = (immv >> 5) & 0x3F
    b4_1 = (immv >> 1) & 0xF
    return (b12 << 31) | (b10_5 << 25) | (rs2 << 20) | (rs1 << 15) | (f3 << 12) | (b4_1 << 8) | (b11 << 7) | op


def enc_u(immv, rd, op):
    return ((immv & 0xFFFFF) << 12) | (rd << 7) | op


def enc_j(immv, rd, op):
    immv &= 0x1FFFFF
    b20 = (immv >> 20) & 1
    b10_1 = (immv >> 1) & 0x3FF
    b11 = (immv >> 11) & 1
    b19_12 = (immv >> 12) & 0xFF
    return (b20 << 31) | (b10_1 << 21) | (b11 << 20) | (b19_12 << 12) | (rd << 7) | op


MEMREF = re.compile(r"(-?\w+)\((x\d+)\)")


def parse(lines):
    items, labels, addr = [], {}, 0
    for raw in lines:
        line = raw.split("#")[0].strip()
        if not line:
            continue
        while ":" in line:
            label, _, rest = line.partition(":")
            labels[label.strip()] = addr
            line = rest.strip()
            if not line:
                break
        if not line:
            continue
        items.append((addr, line))
        addr += 4
    return items, labels


def assemble(text):
    items, labels = parse(text.splitlines())
    words = []
    for addr, line in items:
        parts = line.replace(",", " ").split()
        op = parts[0].lower()
        a = parts[1:]
        if op == "nop":
            words.append(enc_i(0, 0, 0, 0, 0x13))
        elif op in R:
            f7, f3 = R[op]
            words.append(enc_r(f7, reg(a[0]), f3, reg(a[1]), reg(a[2]), 0x33))
        elif op in I_ALU:
            words.append(enc_i(imm(a[2]), reg(a[1]), I_ALU[op], reg(a[0]), 0x13))
        elif op in I_SH:
            f7, f3 = I_SH[op]
            words.append(enc_i((f7 << 5) | (imm(a[2]) & 0x1F), reg(a[1]), f3, reg(a[0]), 0x13))
        elif op in LOAD:
            m = MEMREF.match(a[1])
            words.append(enc_i(imm(m.group(1)), reg(m.group(2)), LOAD[op], reg(a[0]), 0x03))
        elif op in STORE:
            m = MEMREF.match(a[1])
            words.append(enc_s(imm(m.group(1)), reg(a[0]), reg(m.group(2)), STORE[op], 0x23))
        elif op in BRANCH:
            target = labels[a[2]] if a[2] in labels else imm(a[2])
            words.append(enc_b(target - addr, reg(a[1]), reg(a[0]), BRANCH[op], 0x63))
        elif op == "lui":
            words.append(enc_u(imm(a[1]), reg(a[0]), 0x37))
        elif op == "auipc":
            words.append(enc_u(imm(a[1]), reg(a[0]), 0x17))
        elif op == "jal":
            target = labels[a[1]] if a[1] in labels else imm(a[1])
            words.append(enc_j(target - addr, reg(a[0]), 0x6F))
        elif op == "jalr":
            words.append(enc_i(imm(a[2]), reg(a[1]), 0x0, reg(a[0]), 0x67))
        else:
            raise ValueError(f"unknown instruction {op!r}")
    return words


if __name__ == "__main__":
    src = open(sys.argv[1]).read()
    out = sys.argv[2] if len(sys.argv) > 2 else None
    words = assemble(src)
    text = "\n".join(f"{w & 0xFFFFFFFF:08x}" for w in words) + "\n"
    if out:
        open(out, "w").write(text)
    else:
        sys.stdout.write(text)
