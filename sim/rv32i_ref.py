import sys
from assemble import assemble

MASK = 0xFFFFFFFF


def sx(v, bits):
    s = 1 << (bits - 1)
    return (v & (s - 1)) - (v & s)


def run(words, max_steps=2000):
    reg = [0] * 32
    mem = bytearray(4096)
    pc = 0
    for _ in range(max_steps):
        if pc >> 2 >= len(words):
            break
        w = words[pc >> 2]
        op = w & 0x7F
        rd = (w >> 7) & 0x1F
        f3 = (w >> 12) & 0x7
        rs1 = (w >> 15) & 0x1F
        rs2 = (w >> 20) & 0x1F
        f7 = (w >> 25) & 0x7F
        a = reg[rs1]
        b = reg[rs2]
        immI = sx((w >> 20) & 0xFFF, 12)
        immS = sx((((w >> 25) & 0x7F) << 5) | ((w >> 7) & 0x1F), 12)
        immB = sx((((w >> 31) & 1) << 12) | (((w >> 7) & 1) << 11) |
                  (((w >> 25) & 0x3F) << 5) | (((w >> 8) & 0xF) << 1), 13)
        immU = w & 0xFFFFF000
        immJ = sx((((w >> 31) & 1) << 20) | (((w >> 12) & 0xFF) << 12) |
                  (((w >> 20) & 1) << 11) | (((w >> 21) & 0x3FF) << 1), 21)
        nxt = (pc + 4) & MASK

        if op == 0x33:
            sh = b & 0x1F
            r = {0x0: (a - b if f7 == 0x20 else a + b), 0x1: a << sh, 0x2: int(sx(a, 32) < sx(b, 32)),
                 0x3: int((a & MASK) < (b & MASK)), 0x4: a ^ b,
                 0x5: (sx(a, 32) >> sh if f7 == 0x20 else (a & MASK) >> sh),
                 0x6: a | b, 0x7: a & b}[f3]
            reg[rd] = r & MASK
        elif op == 0x13:
            sh = immI & 0x1F
            r = {0x0: a + immI, 0x2: int(sx(a, 32) < immI), 0x3: int((a & MASK) < (immI & MASK)),
                 0x4: a ^ immI, 0x6: a | immI, 0x7: a & immI, 0x1: a << sh,
                 0x5: (sx(a, 32) >> sh if (w >> 30) & 1 else (a & MASK) >> sh)}[f3]
            reg[rd] = r & MASK
        elif op == 0x03:
            addr = (a + immI) & MASK
            if f3 == 0x2:
                v = int.from_bytes(mem[addr:addr + 4], "little")
            elif f3 in (0x1, 0x5):
                v = int.from_bytes(mem[addr:addr + 2], "little")
                if f3 == 0x1:
                    v = sx(v, 16) & MASK
            else:
                v = mem[addr]
                if f3 == 0x0:
                    v = sx(v, 8) & MASK
            reg[rd] = v & MASK
        elif op == 0x23:
            addr = (a + immS) & MASK
            n = {0x0: 1, 0x1: 2, 0x2: 4}[f3]
            mem[addr:addr + n] = (b & ((1 << (8 * n)) - 1)).to_bytes(n, "little")
        elif op == 0x63:
            cond = {0x0: a == b, 0x1: a != b, 0x4: sx(a, 32) < sx(b, 32),
                    0x5: sx(a, 32) >= sx(b, 32), 0x6: (a & MASK) < (b & MASK),
                    0x7: (a & MASK) >= (b & MASK)}[f3]
            if cond:
                nxt = (pc + immB) & MASK
        elif op == 0x37:
            reg[rd] = immU & MASK
        elif op == 0x17:
            reg[rd] = (pc + immU) & MASK
        elif op == 0x6F:
            reg[rd] = nxt
            nxt = (pc + immJ) & MASK
        elif op == 0x67:
            t = (a + immI) & ~1 & MASK
            reg[rd] = nxt
            nxt = t
        reg[0] = 0
        if nxt == pc:
            break
        pc = nxt
    return reg, mem


if __name__ == "__main__":
    words = assemble(open(sys.argv[1]).read())
    reg, mem = run(words)
    if len(sys.argv) > 2:
        with open(sys.argv[2], "w") as f:
            f.write("\n".join(f"{reg[i] & MASK:08x}" for i in range(32)) + "\n")
    else:
        for i in range(32):
            print(f"x{i}={reg[i] & MASK:08x}")
