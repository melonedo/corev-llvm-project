# RUN: llvm-mc -triple=riscv32 --mattr=+xcvsimd -show-encoding %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INSTR

//===----------------------------------------------------------------------===//
// cv.cmpge.h
//===----------------------------------------------------------------------===//

cv.cmpge.h t0, t1, t2
# CHECK-INSTR: cv.cmpge.h t0, t1, t2
# CHECK-ENCODING: [0xfb,0x02,0x73,0x1c]

cv.cmpge.h t3, t4, t5
# CHECK-INSTR: cv.cmpge.h t3, t4, t5
# CHECK-ENCODING: [0x7b,0x8e,0xee,0x1d]

cv.cmpge.h a0, a1, a2
# CHECK-INSTR: cv.cmpge.h a0, a1, a2
# CHECK-ENCODING: [0x7b,0x85,0xc5,0x1c]

cv.cmpge.h s0, s1, s2
# CHECK-INSTR: cv.cmpge.h s0, s1, s2
# CHECK-ENCODING: [0x7b,0x84,0x24,0x1d]

//===----------------------------------------------------------------------===//
// cv.cmpge.b
//===----------------------------------------------------------------------===//

cv.cmpge.b t0, t1, t2
# CHECK-INSTR: cv.cmpge.b t0, t1, t2
# CHECK-ENCODING: [0xfb,0x12,0x73,0x1c]

cv.cmpge.b t3, t4, t5
# CHECK-INSTR: cv.cmpge.b t3, t4, t5
# CHECK-ENCODING: [0x7b,0x9e,0xee,0x1d]

cv.cmpge.b a0, a1, a2
# CHECK-INSTR: cv.cmpge.b a0, a1, a2
# CHECK-ENCODING: [0x7b,0x95,0xc5,0x1c]

cv.cmpge.b s0, s1, s2
# CHECK-INSTR: cv.cmpge.b s0, s1, s2
# CHECK-ENCODING: [0x7b,0x94,0x24,0x1d]

//===----------------------------------------------------------------------===//
// cv.cmpge.sc.h
//===----------------------------------------------------------------------===//

cv.cmpge.sc.h t0, t1, t2
# CHECK-INSTR: cv.cmpge.sc.h t0, t1, t2
# CHECK-ENCODING: [0xfb,0x42,0x73,0x1c]

cv.cmpge.sc.h t3, t4, t5
# CHECK-INSTR: cv.cmpge.sc.h t3, t4, t5
# CHECK-ENCODING: [0x7b,0xce,0xee,0x1d]

cv.cmpge.sc.h a0, a1, a2
# CHECK-INSTR: cv.cmpge.sc.h a0, a1, a2
# CHECK-ENCODING: [0x7b,0xc5,0xc5,0x1c]

cv.cmpge.sc.h s0, s1, s2
# CHECK-INSTR: cv.cmpge.sc.h s0, s1, s2
# CHECK-ENCODING: [0x7b,0xc4,0x24,0x1d]

//===----------------------------------------------------------------------===//
// cv.cmpge.sc.b
//===----------------------------------------------------------------------===//

cv.cmpge.sc.b t0, t1, t2
# CHECK-INSTR: cv.cmpge.sc.b t0, t1, t2
# CHECK-ENCODING: [0xfb,0x52,0x73,0x1c]

cv.cmpge.sc.b t3, t4, t5
# CHECK-INSTR: cv.cmpge.sc.b t3, t4, t5
# CHECK-ENCODING: [0x7b,0xde,0xee,0x1d]

cv.cmpge.sc.b a0, a1, a2
# CHECK-INSTR: cv.cmpge.sc.b a0, a1, a2
# CHECK-ENCODING: [0x7b,0xd5,0xc5,0x1c]

cv.cmpge.sc.b s0, s1, s2
# CHECK-INSTR: cv.cmpge.sc.b s0, s1, s2
# CHECK-ENCODING: [0x7b,0xd4,0x24,0x1d]

//===----------------------------------------------------------------------===//
// cv.cmpge.sci.h
//===----------------------------------------------------------------------===//

cv.cmpge.sci.h t0, t1, 0
# CHECK-INSTR: cv.cmpge.sci.h t0, t1, 0
# CHECK-ENCODING: [0xfb,0x62,0x03,0x1c]

cv.cmpge.sci.h t3, t4, -32
# CHECK-INSTR: cv.cmpge.sci.h t3, t4, -32
# CHECK-ENCODING: [0x7b,0xee,0x0e,0x1d]

cv.cmpge.sci.h a0, a1, 7
# CHECK-INSTR: cv.cmpge.sci.h a0, a1, 7
# CHECK-ENCODING: [0x7b,0xe5,0x35,0x1e]

cv.cmpge.sci.h s0, s1, -1
# CHECK-INSTR: cv.cmpge.sci.h s0, s1, -1
# CHECK-ENCODING: [0x7b,0xe4,0xf4,0x1f]

//===----------------------------------------------------------------------===//
// cv.cmpge.sci.b
//===----------------------------------------------------------------------===//

cv.cmpge.sci.b t0, t1, 0
# CHECK-INSTR: cv.cmpge.sci.b t0, t1, 0
# CHECK-ENCODING: [0xfb,0x72,0x03,0x1c]

cv.cmpge.sci.b t3, t4, -32
# CHECK-INSTR: cv.cmpge.sci.b t3, t4, -32
# CHECK-ENCODING: [0x7b,0xfe,0x0e,0x1d]

cv.cmpge.sci.b a0, a1, 7
# CHECK-INSTR: cv.cmpge.sci.b a0, a1, 7
# CHECK-ENCODING: [0x7b,0xf5,0x35,0x1e]

cv.cmpge.sci.b s0, s1, -1
# CHECK-INSTR: cv.cmpge.sci.b s0, s1, -1
# CHECK-ENCODING: [0x7b,0xf4,0xf4,0x1f]

