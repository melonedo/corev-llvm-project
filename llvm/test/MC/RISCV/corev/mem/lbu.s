# RUN: llvm-mc -triple=riscv32 --mattr=+xcvmem -show-encoding %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INSTR

cv.lbu t0, (t1), 0
# CHECK-INSTR: cv.lbu t0, (t1), 0
# CHECK-ENCODING: [0x8b,0x42,0x03,0x00]

cv.lbu a0, (a1), 2047
# CHECK-INSTR: cv.lbu a0, (a1), 2047
# CHECK-ENCODING: [0x0b,0xc5,0xf5,0x7f]



cv.lbu t0, (t1), t2
# CHECK-INSTR: cv.lbu t0, (t1), t2
# CHECK-ENCODING: [0xab,0x32,0x73,0x10]

cv.lbu a0, (a1), a2
# CHECK-INSTR: cv.lbu a0, (a1), a2
# CHECK-ENCODING: [0x2b,0xb5,0xc5,0x10]



cv.lbu t0, t2(t1)
# CHECK-INSTR: cv.lbu t0, t2(t1)
# CHECK-ENCODING: [0xab,0x32,0x73,0x18]

cv.lbu a0, a2(a1)
# CHECK-INSTR: cv.lbu a0, a2(a1)
# CHECK-ENCODING: [0x2b,0xb5,0xc5,0x18]
