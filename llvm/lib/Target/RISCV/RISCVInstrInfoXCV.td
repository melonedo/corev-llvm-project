//===-- RISCVInstrInfoXCV.td - CORE-V instructions ---------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file describes the vendor extensions defined by Core-V extensions.
//
//===----------------------------------------------------------------------===//

let DecoderNamespace = "XCVbitmanip" in {
  class RVInstBitManipRII<bits<2> funct2, bits<3> funct3, dag outs, dag ins,
                      string opcodestr, string argstr>
      : RVInstI<funct3, OPC_CUSTOM_2, outs, ins, opcodestr, argstr> {
    bits<5> is3;
    bits<5> is2;
    let imm12 = {funct2, is3, is2};
  }

  class CVBitManipRII<bits<2> funct2, bits<3> funct3, string opcodestr, 
                      Operand i3type = uimm5>
      : RVInstBitManipRII<funct2, funct3, (outs GPR:$rd), 
                          (ins GPR:$rs1, i3type:$is3, uimm5:$is2),
                          opcodestr, "$rd, $rs1, $is3, $is2">;

  class CVBitManipRR<bits<7> funct7, string opcodestr>
      : RVInstR<funct7, 0b011, OPC_CUSTOM_1, (outs GPR:$rd), 
                (ins GPR:$rs1, GPR:$rs2), opcodestr, "$rd, $rs1, $rs2">;

  class CVBitManipR<bits<7> funct7, string opcodestr>
      : RVInstR<funct7, 0b011, OPC_CUSTOM_1, (outs GPR:$rd), 
                (ins GPR:$rs1, GPR:$rs2), opcodestr, "$rd, $rs1"> {
    let rs2 = 0b00000;
  }
}

let Predicates = [HasVendorXCVbitmanip, IsRV32], 
    hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
  def CV_EXTRACT : CVBitManipRII<0b00, 0b000, "cv.extract">;
  def CV_EXTRACTU : CVBitManipRII<0b01, 0b000, "cv.extractu">;

  def CV_BCLR : CVBitManipRII<0b00, 0b001, "cv.bclr">;
  def CV_BSET : CVBitManipRII<0b01, 0b001, "cv.bset">;
  def CV_BITREV : CVBitManipRII<0b11, 0b001, "cv.bitrev", uimm2>;

  def CV_EXTRACTR : CVBitManipRR<0b0011000, "cv.extractr">;
  def CV_EXTRACTUR : CVBitManipRR<0b0011001, "cv.extractur">;

  let Constraints = "$rd = $rd_wb" in {
    def CV_INSERT : RVInstBitManipRII<0b10, 0b000, (outs GPR:$rd_wb),
                             (ins GPR:$rd, GPR:$rs1, uimm5:$is3, uimm5:$is2),
                             "cv.insert", "$rd, $rs1, $is3, $is2">;
    def CV_INSERTR : RVInstR<0b0011010, 0b011, OPC_CUSTOM_1, (outs GPR:$rd_wb), 
                             (ins GPR:$rd, GPR:$rs1, GPR:$rs2), 
                             "cv.insertr", "$rd, $rs1, $rs2">;
  }

  def CV_BCLRR : CVBitManipRR<0b0011100, "cv.bclrr">;
  def CV_BSETR : CVBitManipRR<0b0011101, "cv.bsetr">;

  def CV_ROR : CVBitManipRR<0b0100000, "cv.ror">;
  def CV_FF1 : CVBitManipR<0b0100001, "cv.ff1">;
  def CV_FL1 : CVBitManipR<0b0100010, "cv.fl1">;
  def CV_CLB : CVBitManipR<0b0100011, "cv.clb">;
  def CV_CNT : CVBitManipR<0b0100100, "cv.cnt">;
}


class RVInstSIMDRR<bits<5> funct5, bit F, bit funct1, bits<3> funct3,
                   RISCVOpcode opcode, dag outs,
                   dag ins, string opcodestr, string argstr>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> rs2;
  bits<5> rs1;
  bits<5> rd;

  let Inst{31-27} = funct5;
  let Inst{26} = F;
  let Inst{25} = funct1;
  let Inst{24-20} = rs2;
  let Inst{19-15} = rs1;
  let Inst{14-12} = funct3;
  let Inst{11-7} = rd;
  let Opcode = opcode.Value;
  let DecoderNamespace = "CoreVSIMD";
}

class RVInstSIMDR<bits<5> funct5, bit F, bit funct1, bits<3> funct3,
                  RISCVOpcode opcode, dag outs,
                  dag ins, string opcodestr, string argstr>
    : RVInstSIMDRR<funct5, F, funct1, funct3, opcode, outs, ins, opcodestr,
                   argstr> {
  let rs2 = 0b00000;
}

class RVInstSIMDRI<bits<5> funct5, bit F, bits<3> funct3, RISCVOpcode opcode,
                   dag outs, dag ins, string opcodestr, string argstr>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatOther> {
  bits<6> imm6;
  bits<5> rs1;
  bits<5> rd;

  let Inst{31-27} = funct5;
  let Inst{26} = F;
  let Inst{25} = imm6{0}; // funct1 unused
  let Inst{24-20} = imm6{5-1};
  let Inst{19-15} = rs1;
  let Inst{14-12} = funct3;
  let Inst{11-7} = rd;
  let Opcode = opcode.Value;
  let DecoderNamespace = "CoreVSIMD";
}

class CVSIMDRR<bits<5> funct5, bit F, bit funct1, bits<3> funct3,
                  string opcodestr>
    : RVInstSIMDRR<funct5, F, funct1, funct3, OPC_CUSTOM_3, (outs GPR:$rd),
              (ins GPR:$rs1, GPR:$rs2), opcodestr, "$rd, $rs1, $rs2">;

let Constraints = "$rd = $rd_wb" in
class CVSIMDRRWb<bits<5> funct5, bit F, bit funct1, bits<3> funct3,
                    string opcodestr>
    : RVInstSIMDRR<funct5, F, funct1, funct3, OPC_CUSTOM_3, (outs GPR:$rd_wb),
              (ins GPR:$rd, GPR:$rs1, GPR:$rs2), opcodestr, "$rd, $rs1, $rs2">;

class CVSIMDRI<bits<5> funct5, bit F, bits<3> funct3, string opcodestr>
    : RVInstSIMDRI<funct5, F, funct3, OPC_CUSTOM_3, (outs GPR:$rd),
              (ins GPR:$rs1, simm6:$imm6), opcodestr, "$rd, $rs1, $imm6">;

let Constraints = "$rd = $rd_wb" in
class CVSIMDRIWb<bits<5> funct5, bit F, bits<3> funct3, string opcodestr>
    : RVInstSIMDRI<funct5, F, funct3, OPC_CUSTOM_3,
                   (outs GPR:$rd_wb), (ins GPR:$rd, GPR:$rs1, simm6:$imm6),
                   opcodestr, "$rd, $rs1, $imm6">;

class CVSIMDRU<bits<5> funct5, bit F, bits<3> funct3, string opcodestr>
    : RVInstSIMDRI<funct5, F, funct3, OPC_CUSTOM_3,
                   (outs GPR:$rd), (ins GPR:$rs1, uimm6:$imm6),
                   opcodestr, "$rd, $rs1, $imm6">;

let Constraints = "$rd = $rd_wb" in
class CVSIMDRUWb<bits<5> funct5, bit F, bits<3> funct3, string opcodestr>
    : RVInstSIMDRI<funct5, F, funct3, OPC_CUSTOM_3,
                   (outs GPR:$rd_wb),
                   (ins GPR:$rd, GPR:$rs1, uimm6:$imm6),
                   opcodestr, "$rd, $rs1, $imm6">;

class CVSIMDR<bits<5> funct5, bit F, bit funct1, bits<3> funct3,
                 string opcodestr>
    : RVInstSIMDR<funct5, F, funct1, funct3, OPC_CUSTOM_3, (outs GPR:$rd),
                  (ins GPR:$rs1), opcodestr, "$rd, $rs1">;

multiclass CVSIMDBinarySigned<bits<5> funct5, bit F, bit funct1, string mnemonic> {
  def CV_ # NAME # _H : CVSIMDRR<funct5, F, funct1, 0b000, "cv." # mnemonic # ".h">;
  def CV_ # NAME # _B : CVSIMDRR<funct5, F, funct1, 0b001, "cv." # mnemonic # ".b">;
  def CV_ # NAME # _SC_H : CVSIMDRR<funct5, F, funct1, 0b100, "cv." # mnemonic # ".sc.h">;
  def CV_ # NAME # _SC_B : CVSIMDRR<funct5, F, funct1, 0b101, "cv." # mnemonic # ".sc.b">;
  def CV_ # NAME # _SCI_H : CVSIMDRI<funct5, F, 0b110, "cv." # mnemonic # ".sci.h">;
  def CV_ # NAME # _SCI_B : CVSIMDRI<funct5, F, 0b111, "cv." # mnemonic # ".sci.b">;
}

multiclass CVSIMDBinaryUnsigned<bits<5> funct5, bit F, bit funct1, string mnemonic> {
  def CV_ # NAME # _H : CVSIMDRR<funct5, F, funct1, 0b000, "cv." # mnemonic # ".h">;
  def CV_ # NAME # _B : CVSIMDRR<funct5, F, funct1, 0b001, "cv." # mnemonic # ".b">;
  def CV_ # NAME # _SC_H : CVSIMDRR<funct5, F, funct1, 0b100, "cv." # mnemonic # ".sc.h">;
  def CV_ # NAME # _SC_B : CVSIMDRR<funct5, F, funct1, 0b101, "cv." # mnemonic # ".sc.b">;
  def CV_ # NAME # _SCI_H : CVSIMDRU<funct5, F, 0b110, "cv." # mnemonic # ".sci.h">;
  def CV_ # NAME # _SCI_B : CVSIMDRU<funct5, F, 0b111, "cv." # mnemonic # ".sci.b">;
}

multiclass CVSIMDBinarySignedWb<bits<5> funct5, bit F, bit funct1, string mnemonic> {
  def CV_ # NAME # _H : CVSIMDRRWb<funct5, F, funct1, 0b000, "cv." # mnemonic # ".h">;
  def CV_ # NAME # _B : CVSIMDRRWb<funct5, F, funct1, 0b001, "cv." # mnemonic # ".b">;
  def CV_ # NAME # _SC_H : CVSIMDRRWb<funct5, F, funct1, 0b100, "cv." # mnemonic # ".sc.h">;
  def CV_ # NAME # _SC_B : CVSIMDRRWb<funct5, F, funct1, 0b101, "cv." # mnemonic # ".sc.b">;
  def CV_ # NAME # _SCI_H : CVSIMDRIWb<funct5, F, 0b110, "cv." # mnemonic # ".sci.h">;
  def CV_ # NAME # _SCI_B : CVSIMDRIWb<funct5, F, 0b111, "cv." # mnemonic # ".sci.b">;
}

multiclass CVSIMDBinaryUnsignedWb<bits<5> funct5, bit F, bit funct1, string mnemonic> {
  def CV_ # NAME # _H : CVSIMDRRWb<funct5, F, funct1, 0b000, "cv." # mnemonic # ".h">;
  def CV_ # NAME # _B : CVSIMDRRWb<funct5, F, funct1, 0b001, "cv." # mnemonic # ".b">;
  def CV_ # NAME # _SC_H : CVSIMDRRWb<funct5, F, funct1, 0b100, "cv." # mnemonic # ".sc.h">;
  def CV_ # NAME # _SC_B : CVSIMDRRWb<funct5, F, funct1, 0b101, "cv." # mnemonic # ".sc.b">;
  def CV_ # NAME # _SCI_H : CVSIMDRUWb<funct5, F, 0b110, "cv." # mnemonic # ".sci.h">;
  def CV_ # NAME # _SCI_B : CVSIMDRUWb<funct5, F, 0b111, "cv." # mnemonic # ".sci.b">;
}


let Predicates = [HasVendorXCvsimd, IsRV32],
    hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
  defm ADD :    CVSIMDBinarySigned<0b00000, 0, 0, "add">;
  defm SUB :    CVSIMDBinarySigned<0b00001, 0, 0, "sub">;
  defm AVG :    CVSIMDBinarySigned<0b00010, 0, 0, "avg">;
  defm AVGU :   CVSIMDBinarySigned<0b00011, 0, 0, "avgu">;
  defm MIN :    CVSIMDBinarySigned<0b00100, 0, 0, "min">;
  defm MINU : CVSIMDBinaryUnsigned<0b00101, 0, 0, "minu">;
  defm MAX :    CVSIMDBinarySigned<0b00110, 0, 0, "max">;
  defm MAXU : CVSIMDBinaryUnsigned<0b00111, 0, 0, "maxu">;
  defm SRL :  CVSIMDBinaryUnsigned<0b01000, 0, 0, "srl">;
  defm SRA :  CVSIMDBinaryUnsigned<0b01001, 0, 0, "sra">;
  defm SLL :  CVSIMDBinaryUnsigned<0b01010, 0, 0, "sll">;
  defm OR :   CVSIMDBinaryUnsigned<0b01011, 0, 0, "or">;
  defm XOR :  CVSIMDBinaryUnsigned<0b01100, 0, 0, "xor">;
  defm AND :  CVSIMDBinaryUnsigned<0b01101, 0, 0, "and">;

  def CV_ABS_H :    CVSIMDR<0b01110, 0, 0, 0b000, "cv.abs.h">;
  def CV_ABS_B :    CVSIMDR<0b01110, 0, 0, 0b001, "cv.abs.b">;

  // 0b01111xx: UNDEF

  defm DOTUP :   CVSIMDBinaryUnsigned<0b10000, 0, 0, "dotup">;
  defm DOTUSP :  CVSIMDBinarySigned<0b10001, 0, 0, "dotusp">;
  defm DOTSP :   CVSIMDBinarySigned<0b10010, 0, 0, "dotsp">;
  defm SDOTUP :  CVSIMDBinaryUnsignedWb<0b10011, 0, 0, "sdotup">;
  defm SDOTUSP : CVSIMDBinarySignedWb<0b10100, 0, 0, "sdotusp">;
  defm SDOTSP :  CVSIMDBinarySignedWb<0b10101, 0, 0, "sdotsp">;

  // 0b10110xx: UNDEF

  def CV_EXTRACT_H :    CVSIMDRU<0b10111, 0, 0b000, "cv.extract.h">;
  def CV_EXTRACT_B :    CVSIMDRU<0b10111, 0, 0b001, "cv.extract.b">;
  def CV_EXTRACTU_H :   CVSIMDRU<0b10111, 0, 0b010, "cv.extractu.h">;
  def CV_EXTRACTU_B :   CVSIMDRU<0b10111, 0, 0b011, "cv.extractu.b">;
  def CV_INSERT_H :     CVSIMDRUWb<0b10111, 0, 0b100, "cv.insert.h">;
  def CV_INSERT_B :     CVSIMDRUWb<0b10111, 0, 0b101, "cv.insert.b">;

  def CV_SHUFFLE_H :    CVSIMDRR<0b11000, 0, 0, 0b000, "cv.shuffle.h">;
  def CV_SHUFFLE_B :    CVSIMDRR<0b11000, 0, 0, 0b001, "cv.shuffle.b">;
  def CV_SHUFFLE_SCI_H : CVSIMDRU<0b11000, 0, 0b110, "cv.shuffle.sci.h">;
  def CV_SHUFFLEI0_SCI_B : CVSIMDRU<0b11000, 0, 0b111, "cv.shufflei0.sci.b">;

  def CV_SHUFFLEI1_SCI_B : CVSIMDRU<0b11001, 0, 0b111, "cv.shufflei1.sci.b">;

  def CV_SHUFFLEI2_SCI_B : CVSIMDRU<0b11010, 0, 0b111, "cv.shufflei2.sci.b">;

  def CV_SHUFFLEI3_SCI_B : CVSIMDRU<0b11011, 0, 0b111, "cv.shufflei3.sci.b">;

  def CV_SHUFFLE2_H :    CVSIMDRRWb<0b11100, 0, 0, 0b000, "cv.shuffle2.h">;
  def CV_SHUFFLE2_B :    CVSIMDRRWb<0b11100, 0, 0, 0b001, "cv.shuffle2.b">;

  // 0b11101xx: UNDEF

  def CV_PACK :      CVSIMDRR<0b11110, 0, 0, 0b000, "cv.pack">;
  def CV_PACK_H :    CVSIMDRR<0b11110, 0, 1, 0b000, "cv.pack.h">;
  
  def CV_PACKHI_B : CVSIMDRRWb<0b11111, 0, 1, 0b001, "cv.packhi.b">;
  def CV_PACKLO_B : CVSIMDRRWb<0b11111, 0, 0, 0b001, "cv.packlo.b">;
  
  defm CMPEQ :  CVSIMDBinarySigned<0b00000, 1, 0, "cmpeq">;
  defm CMPNE :  CVSIMDBinarySigned<0b00001, 1, 0, "cmpne">;
  defm CMPGT :  CVSIMDBinarySigned<0b00010, 1, 0, "cmpgt">;
  defm CMPGE :  CVSIMDBinarySigned<0b00011, 1, 0, "cmpge">;
  defm CMPLT :  CVSIMDBinarySigned<0b00100, 1, 0, "cmplt">;
  defm CMPLE :  CVSIMDBinarySigned<0b00101, 1, 0, "cmple">;
  defm CMPGTU : CVSIMDBinaryUnsigned<0b00110, 1, 0, "cmpgtu">;
  defm CMPGEU : CVSIMDBinaryUnsigned<0b00111, 1, 0, "cmpgeu">;
  defm CMPLTU : CVSIMDBinaryUnsigned<0b01000, 1, 0, "cmpltu">;
  defm CMPLEU : CVSIMDBinaryUnsigned<0b01001, 1, 0, "cmpleu">;

  def CV_CPLXMUL_R : CVSIMDRRWb<0b01010, 1, 0, 0b000, "cv.cplxmul.r">;
  def CV_CPLXMUL_I : CVSIMDRRWb<0b01010, 1, 1, 0b000, "cv.cplxmul.i">;
  def CV_CPLXMUL_R_DIV2 : CVSIMDRRWb<0b01010, 1, 0, 0b010, "cv.cplxmul.r.div2">;
  def CV_CPLXMUL_I_DIV2 : CVSIMDRRWb<0b01010, 1, 1, 0b010, "cv.cplxmul.i.div2">;
  def CV_CPLXMUL_R_DIV4 : CVSIMDRRWb<0b01010, 1, 0, 0b100, "cv.cplxmul.r.div4">;
  def CV_CPLXMUL_I_DIV4 : CVSIMDRRWb<0b01010, 1, 1, 0b100, "cv.cplxmul.i.div4">;
  def CV_CPLXMUL_R_DIV8 : CVSIMDRRWb<0b01010, 1, 0, 0b110, "cv.cplxmul.r.div8">;
  def CV_CPLXMUL_I_DIV8 : CVSIMDRRWb<0b01010, 1, 1, 0b110, "cv.cplxmul.i.div8">;

  def CV_CPLXCONJ :    CVSIMDR<0b01011, 1, 0, 0b000, "cv.cplxconj">;

  // 0b01011xx: UNDEF

  def CV_SUBROTMJ : CVSIMDRR<0b01100, 1, 0, 0b000, "cv.subrotmj">;
  def CV_SUBROTMJ_DIV2 : CVSIMDRR<0b01100, 1, 0, 0b010, "cv.subrotmj.div2">;
  def CV_SUBROTMJ_DIV4 : CVSIMDRR<0b01100, 1, 0, 0b100, "cv.subrotmj.div4">;
  def CV_SUBROTMJ_DIV8 : CVSIMDRR<0b01100, 1, 0, 0b110, "cv.subrotmj.div8">;

  def CV_ADD_DIV2 :    CVSIMDRR<0b01101, 1, 0, 0b010, "cv.add.div2">;
  def CV_ADD_DIV4 :    CVSIMDRR<0b01101, 1, 0, 0b100, "cv.add.div4">;
  def CV_ADD_DIV8 :    CVSIMDRR<0b01101, 1, 0, 0b110, "cv.add.div8">;

  def CV_SUB_DIV2 :    CVSIMDRR<0b01110, 1, 0, 0b010, "cv.sub.div2">;
  def CV_SUB_DIV4 :    CVSIMDRR<0b01110, 1, 0, 0b100, "cv.sub.div4">;
  def CV_SUB_DIV8 :    CVSIMDRR<0b01110, 1, 0, 0b110, "cv.sub.div8">;
}
