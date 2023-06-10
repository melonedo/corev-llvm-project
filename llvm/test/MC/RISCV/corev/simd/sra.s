# RUN: llvm-mc -triple=riscv32 --mattr=+xcvsimd -show-encoding %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INSTR

//===----------------------------------------------------------------------===//
// cv.sra.h
//===----------------------------------------------------------------------===//

cv.sra.h t0, t1, t2
# CHECK-INSTR: cv.sra.h t0, t1, t2
# CHECK-ENCODING: [0xfb,0x02,0x73,0x48]

cv.sra.h t3, t4, t5
# CHECK-INSTR: cv.sra.h t3, t4, t5
# CHECK-ENCODING: [0x7b,0x8e,0xee,0x49]

cv.sra.h a0, a1, a2
# CHECK-INSTR: cv.sra.h a0, a1, a2
# CHECK-ENCODING: [0x7b,0x85,0xc5,0x48]

cv.sra.h s0, s1, s2
# CHECK-INSTR: cv.sra.h s0, s1, s2
# CHECK-ENCODING: [0x7b,0x84,0x24,0x49]

//===----------------------------------------------------------------------===//
// cv.sra.b
//===----------------------------------------------------------------------===//

cv.sra.b t0, t1, t2
# CHECK-INSTR: cv.sra.b t0, t1, t2
# CHECK-ENCODING: [0xfb,0x12,0x73,0x48]

cv.sra.b t3, t4, t5
# CHECK-INSTR: cv.sra.b t3, t4, t5
# CHECK-ENCODING: [0x7b,0x9e,0xee,0x49]

cv.sra.b a0, a1, a2
# CHECK-INSTR: cv.sra.b a0, a1, a2
# CHECK-ENCODING: [0x7b,0x95,0xc5,0x48]

cv.sra.b s0, s1, s2
# CHECK-INSTR: cv.sra.b s0, s1, s2
# CHECK-ENCODING: [0x7b,0x94,0x24,0x49]

//===----------------------------------------------------------------------===//
// cv.sra.sc.h
//===----------------------------------------------------------------------===//

cv.sra.sc.h t0, t1, t2
# CHECK-INSTR: cv.sra.sc.h t0, t1, t2
# CHECK-ENCODING: [0xfb,0x42,0x73,0x48]

cv.sra.sc.h t3, t4, t5
# CHECK-INSTR: cv.sra.sc.h t3, t4, t5
# CHECK-ENCODING: [0x7b,0xce,0xee,0x49]

cv.sra.sc.h a0, a1, a2
# CHECK-INSTR: cv.sra.sc.h a0, a1, a2
# CHECK-ENCODING: [0x7b,0xc5,0xc5,0x48]

cv.sra.sc.h s0, s1, s2
# CHECK-INSTR: cv.sra.sc.h s0, s1, s2
# CHECK-ENCODING: [0x7b,0xc4,0x24,0x49]

//===----------------------------------------------------------------------===//
// cv.sra.sc.b
//===----------------------------------------------------------------------===//

cv.sra.sc.b t0, t1, t2
# CHECK-INSTR: cv.sra.sc.b t0, t1, t2
# CHECK-ENCODING: [0xfb,0x52,0x73,0x48]

cv.sra.sc.b t3, t4, t5
# CHECK-INSTR: cv.sra.sc.b t3, t4, t5
# CHECK-ENCODING: [0x7b,0xde,0xee,0x49]

cv.sra.sc.b a0, a1, a2
# CHECK-INSTR: cv.sra.sc.b a0, a1, a2
# CHECK-ENCODING: [0x7b,0xd5,0xc5,0x48]

cv.sra.sc.b s0, s1, s2
# CHECK-INSTR: cv.sra.sc.b s0, s1, s2
# CHECK-ENCODING: [0x7b,0xd4,0x24,0x49]

//===----------------------------------------------------------------------===//
// cv.sra.sci.h
//===----------------------------------------------------------------------===//

cv.sra.sci.h t0, t1, 0
# CHECK-INSTR: cv.sra.sci.h t0, t1, 0
# CHECK-ENCODING: [0xfb,0x62,0x03,0x48]

cv.sra.sci.h t3, t4, 32
# CHECK-INSTR: cv.sra.sci.h t3, t4, 32
# CHECK-ENCODING: [0x7b,0xee,0x0e,0x49]

cv.sra.sci.h a0, a1, 7
# CHECK-INSTR: cv.sra.sci.h a0, a1, 7
# CHECK-ENCODING: [0x7b,0xe5,0x35,0x4a]

cv.sra.sci.h s0, s1, 63
# CHECK-INSTR: cv.sra.sci.h s0, s1, 63
# CHECK-ENCODING: [0x7b,0xe4,0xf4,0x4b]

//===----------------------------------------------------------------------===//
// cv.sra.sci.b
//===----------------------------------------------------------------------===//

cv.sra.sci.b t0, t1, 0
# CHECK-INSTR: cv.sra.sci.b t0, t1, 0
# CHECK-ENCODING: [0xfb,0x72,0x03,0x48]

cv.sra.sci.b t3, t4, 32
# CHECK-INSTR: cv.sra.sci.b t3, t4, 32
# CHECK-ENCODING: [0x7b,0xfe,0x0e,0x49]

cv.sra.sci.b a0, a1, 7
# CHECK-INSTR: cv.sra.sci.b a0, a1, 7
# CHECK-ENCODING: [0x7b,0xf5,0x35,0x4a]

cv.sra.sci.b s0, s1, 63
# CHECK-INSTR: cv.sra.sci.b s0, s1, 63
# CHECK-ENCODING: [0x7b,0xf4,0xf4,0x4b]

