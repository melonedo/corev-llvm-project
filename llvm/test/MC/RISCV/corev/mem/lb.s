# RUN: llvm-mc -triple=riscv32 --mattr=+xcvmem -show-encoding %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INSTR

cv.lb t0, (t1), 0
# CHECK-INSTR: cv.lb t0, (t1), 0
# CHECK-ENCODING: [0x8b,0x02,0x03,0x00]

cv.lb a0, (a1), 2047
# CHECK-INSTR: cv.lb a0, (a1), 2047
# CHECK-ENCODING: [0x0b,0x85,0xf5,0x7f]



cv.lb t0, (t1), t2
# CHECK-INSTR: cv.lb t0, (t1), t2
# CHECK-ENCODING: [0xab,0x32,0x73,0x00]

cv.lb a0, (a1), a2
# CHECK-INSTR: cv.lb a0, (a1), a2
# CHECK-ENCODING: [0x2b,0xb5,0xc5,0x00]



cv.lb t0, t2(t1)
# CHECK-INSTR: cv.lb t0, t2(t1)
# CHECK-ENCODING: [0xab,0x32,0x73,0x08]

cv.lb a0, a2(a1)
# CHECK-INSTR: cv.lb a0, a2(a1)
# CHECK-ENCODING: [0x2b,0xb5,0xc5,0x08]
