# RUN: not llvm-mc -triple=riscv32 --mattr=+xcvmem %s 2>&1 \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ERROR

cv.lhu t0, (0), 0
# CHECK-ERROR: invalid operand for instruction

cv.lhu 0, (t1), 0
# CHECK-ERROR: invalid operand for instruction

cv.lhu t0, 0(t1)
# CHECK-ERROR: invalid operand for instruction

cv.lhu t0, (t1), 2048
# CHECK-ERROR: operand must be a symbol with %lo/%pcrel_lo/%tprel_lo modifier or an integer in the range [-2048, 2047]

cv.lhu t0, (0), t1
# CHECK-ERROR: invalid operand for instruction

cv.lhu 0, (t1), t1
# CHECK-ERROR: invalid operand for instruction

cv.lhu t0, t1(0)
# CHECK-ERROR: expected register

cv.lhu 0, 0(t1)
# CHECK-ERROR: invalid operand for instruction

cv.lhu t0
# CHECK-ERROR: too few operands for instruction
