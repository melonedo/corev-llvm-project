# RUN: llvm-mc -triple=riscv32 --mattr=+xcvsimd -show-encoding %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INSTR

//===----------------------------------------------------------------------===//
// cv.cmpgt.h
//===----------------------------------------------------------------------===//

cv.cmpgt.h t0, t1, t2
# CHECK-INSTR: cv.cmpgt.h t0, t1, t2
# CHECK-ENCODING: [0xfb,0x02,0x73,0x14]

cv.cmpgt.h t3, t4, t5
# CHECK-INSTR: cv.cmpgt.h t3, t4, t5
# CHECK-ENCODING: [0x7b,0x8e,0xee,0x15]

cv.cmpgt.h a0, a1, a2
# CHECK-INSTR: cv.cmpgt.h a0, a1, a2
# CHECK-ENCODING: [0x7b,0x85,0xc5,0x14]

cv.cmpgt.h s0, s1, s2
# CHECK-INSTR: cv.cmpgt.h s0, s1, s2
# CHECK-ENCODING: [0x7b,0x84,0x24,0x15]

//===----------------------------------------------------------------------===//
// cv.cmpgt.b
//===----------------------------------------------------------------------===//

cv.cmpgt.b t0, t1, t2
# CHECK-INSTR: cv.cmpgt.b t0, t1, t2
# CHECK-ENCODING: [0xfb,0x12,0x73,0x14]

cv.cmpgt.b t3, t4, t5
# CHECK-INSTR: cv.cmpgt.b t3, t4, t5
# CHECK-ENCODING: [0x7b,0x9e,0xee,0x15]

cv.cmpgt.b a0, a1, a2
# CHECK-INSTR: cv.cmpgt.b a0, a1, a2
# CHECK-ENCODING: [0x7b,0x95,0xc5,0x14]

cv.cmpgt.b s0, s1, s2
# CHECK-INSTR: cv.cmpgt.b s0, s1, s2
# CHECK-ENCODING: [0x7b,0x94,0x24,0x15]

//===----------------------------------------------------------------------===//
// cv.cmpgt.sc.h
//===----------------------------------------------------------------------===//

cv.cmpgt.sc.h t0, t1, t2
# CHECK-INSTR: cv.cmpgt.sc.h t0, t1, t2
# CHECK-ENCODING: [0xfb,0x42,0x73,0x14]

cv.cmpgt.sc.h t3, t4, t5
# CHECK-INSTR: cv.cmpgt.sc.h t3, t4, t5
# CHECK-ENCODING: [0x7b,0xce,0xee,0x15]

cv.cmpgt.sc.h a0, a1, a2
# CHECK-INSTR: cv.cmpgt.sc.h a0, a1, a2
# CHECK-ENCODING: [0x7b,0xc5,0xc5,0x14]

cv.cmpgt.sc.h s0, s1, s2
# CHECK-INSTR: cv.cmpgt.sc.h s0, s1, s2
# CHECK-ENCODING: [0x7b,0xc4,0x24,0x15]

//===----------------------------------------------------------------------===//
// cv.cmpgt.sc.b
//===----------------------------------------------------------------------===//

cv.cmpgt.sc.b t0, t1, t2
# CHECK-INSTR: cv.cmpgt.sc.b t0, t1, t2
# CHECK-ENCODING: [0xfb,0x52,0x73,0x14]

cv.cmpgt.sc.b t3, t4, t5
# CHECK-INSTR: cv.cmpgt.sc.b t3, t4, t5
# CHECK-ENCODING: [0x7b,0xde,0xee,0x15]

cv.cmpgt.sc.b a0, a1, a2
# CHECK-INSTR: cv.cmpgt.sc.b a0, a1, a2
# CHECK-ENCODING: [0x7b,0xd5,0xc5,0x14]

cv.cmpgt.sc.b s0, s1, s2
# CHECK-INSTR: cv.cmpgt.sc.b s0, s1, s2
# CHECK-ENCODING: [0x7b,0xd4,0x24,0x15]

//===----------------------------------------------------------------------===//
// cv.cmpgt.sci.h
//===----------------------------------------------------------------------===//

cv.cmpgt.sci.h t0, t1, 0
# CHECK-INSTR: cv.cmpgt.sci.h t0, t1, 0
# CHECK-ENCODING: [0xfb,0x62,0x03,0x14]

cv.cmpgt.sci.h t3, t4, -32
# CHECK-INSTR: cv.cmpgt.sci.h t3, t4, -32
# CHECK-ENCODING: [0x7b,0xee,0x0e,0x15]

cv.cmpgt.sci.h a0, a1, 7
# CHECK-INSTR: cv.cmpgt.sci.h a0, a1, 7
# CHECK-ENCODING: [0x7b,0xe5,0x35,0x16]

cv.cmpgt.sci.h s0, s1, -1
# CHECK-INSTR: cv.cmpgt.sci.h s0, s1, -1
# CHECK-ENCODING: [0x7b,0xe4,0xf4,0x17]

//===----------------------------------------------------------------------===//
// cv.cmpgt.sci.b
//===----------------------------------------------------------------------===//

cv.cmpgt.sci.b t0, t1, 0
# CHECK-INSTR: cv.cmpgt.sci.b t0, t1, 0
# CHECK-ENCODING: [0xfb,0x72,0x03,0x14]

cv.cmpgt.sci.b t3, t4, -32
# CHECK-INSTR: cv.cmpgt.sci.b t3, t4, -32
# CHECK-ENCODING: [0x7b,0xfe,0x0e,0x15]

cv.cmpgt.sci.b a0, a1, 7
# CHECK-INSTR: cv.cmpgt.sci.b a0, a1, 7
# CHECK-ENCODING: [0x7b,0xf5,0x35,0x16]

cv.cmpgt.sci.b s0, s1, -1
# CHECK-INSTR: cv.cmpgt.sci.b s0, s1, -1
# CHECK-ENCODING: [0x7b,0xf4,0xf4,0x17]

