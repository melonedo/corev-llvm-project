//===-- RISCVInstrInfoXCVbitmanip.td - CORE-V instructions ------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file describes the vendor extensions defined by Core-V bit-manipulation 
// extension.
//
//===----------------------------------------------------------------------===//

class RVInstBitManipRII<bits<2> funct2, bits<3> funct3, dag outs, dag ins,
                    string opcodestr, string argstr, list<dag> pattern>
    : RVInst<outs, ins, opcodestr, argstr, pattern, InstFormatOther> {
  bits<5> is3;
  bits<5> is2;
  bits<5> rs1;
  bits<5> rd;

  let Inst{31-30} = funct2;
  let Inst{29-25} = is3;
  let Inst{24-20} = is2;
  let Inst{19-15} = rs1;
  let Inst{14-12} = funct3;
  let Inst{11-7} = rd;
  let Opcode = OPC_CUSTOM_2.Value;
  let DecoderNamespace = "XCVbitmanip";
}


class RVInstBitManipRR<bits<7> funct7, bits<3> funct3, dag outs, dag ins,
                   string opcodestr, string argstr, list<dag> pattern>
    : RVInst<outs, ins, opcodestr, argstr, pattern, InstFormatOther> {
  bits<5> rs2;
  bits<5> rs1;
  bits<5> rd;

  let Inst{31-25} = funct7;
  let Inst{24-20} = rs2;
  let Inst{19-15} = rs1;
  let Inst{14-12} = funct3;
  let Inst{11-7} = rd;
  let Opcode = OPC_CUSTOM_1.Value;
  let DecoderNamespace = "XCVbitmanip";
}


class RVInstBitManipR<bits<7> funct7, bits<3> funct3, dag outs, dag ins,
                  string opcodestr, string argstr, list<dag> pattern>
    : RVInst<outs, ins, opcodestr, argstr, pattern, InstFormatOther> {
  bits<5> rs1;
  bits<5> rd;

  let Inst{31-25} = funct7;
  let Inst{24-20} = 0b00000;
  let Inst{19-15} = rs1;
  let Inst{14-12} = funct3;
  let Inst{11-7} = rd;
  let Opcode = OPC_CUSTOM_1.Value;
  let DecoderNamespace = "XCVbitmanip";
}

class CVBitManipRII<bits<2> funct2, bits<3> funct3, string opcodestr>
  : RVInstBitManipRII<funct2, funct3, (outs GPR:$rd), (ins GPR:$rs1, uimm5:$is3, uimm5:$is2),
                   opcodestr, "$rd, $rs1, $is3, $is2", []>;

class CVBitManipRR<bits<7> funct7, string opcodestr>
  : RVInstBitManipRR<funct7, 0b011, (outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2),
                   opcodestr, "$rd, $rs1, $rs2", []>;

class CVBitManipR<bits<7> funct7, string opcodestr>
  : RVInstBitManipR<funct7, 0b011, (outs GPR:$rd), (ins GPR:$rs1),
                   opcodestr, "$rd, $rs1", []>;

let Predicates = [HasVendorXCVbitmanip, IsRV32], hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
  def CV_EXTRACT : CVBitManipRII<0b00, 0b000, "cv.extract">;
  def CV_EXTRACTU : CVBitManipRII<0b01, 0b000, "cv.extractu">;

  def CV_BCLR : CVBitManipRII<0b00, 0b001, "cv.bclr">;
  def CV_BSET : CVBitManipRII<0b01, 0b001, "cv.bset">;
  def CV_BITREV : RVInstBitManipRII<0b11, 0b001, (outs GPR:$rd), 
                                    (ins GPR:$rs1, uimm2:$is3, uimm5:$is2),
                                    "cv.bitrev", "$rd, $rs1, $is3, $is2", []>;

  def CV_EXTRACTR : CVBitManipRR<0b0011000, "cv.extractr">;
  def CV_EXTRACTUR : CVBitManipRR<0b0011001, "cv.extractur">;

  let Constraints = "$rd = $rd_wb" in {
  def CV_INSERT : RVInstBitManipRII<0b10, 0b000, (outs GPR:$rd_wb),
                                 (ins GPR:$rs1, uimm5:$is3, uimm5:$is2, GPR:$rd),
                                 "cv.insert", "$rd, $rs1, $is3, $is2", []>;
  def CV_INSERTR : RVInstBitManipRR<0b0011010, 0b011, (outs GPR:$rd_wb),
                                 (ins GPR:$rs1, GPR:$rs2, GPR:$rd),
                                 "cv.insertr", "$rd, $rs1, $rs2", []>;
  }

  def CV_BCLRR : CVBitManipRR<0b0011100, "cv.bclrr">;
  def CV_BSETR : CVBitManipRR<0b0011101, "cv.bsetr">;

  def CV_ROR : CVBitManipRR<0b0100000, "cv.ror">;
  def CV_FF1 : CVBitManipR<0b0100001, "cv.ff1">;
  def CV_FL1 : CVBitManipR<0b0100010, "cv.fl1">;
  def CV_CLB : CVBitManipR<0b0100011, "cv.clb">;
  def CV_CNT : CVBitManipR<0b0100100, "cv.cnt">;
}
