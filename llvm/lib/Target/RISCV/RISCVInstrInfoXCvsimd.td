//===-- RISCVInstrInfoXCvsimd.td --------------------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file describes the vendor extensions defined by Core-V SIMD extension.
//
//===----------------------------------------------------------------------===//


class CVInstSIMDRR<bits<5> funct5, bit F, bit funct1, bits<3> funct3, RISCVOpcode opcode, dag outs,
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

class CVInstSIMDR<bits<5> funct5, bit F, bit funct1, bits<3> funct3, RISCVOpcode opcode, dag outs,
              dag ins, string opcodestr, string argstr>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> rs1;
  bits<5> rd;

  let Inst{31-27} = funct5;
  let Inst{26} = F;
  let Inst{25} = funct1;
  let Inst{24-20} = 0;
  let Inst{19-15} = rs1;
  let Inst{14-12} = funct3;
  let Inst{11-7} = rd;
  let Opcode = opcode.Value;
  let DecoderNamespace = "CoreVSIMD";
}

class CVInstSIMDRI<bits<5> funct5, bit F, bits<3> funct3, RISCVOpcode opcode, dag outs,
              dag ins, string opcodestr, string argstr>
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

def cv_uimm6 : Operand<XLenVT>, ImmLeaf<XLenVT, [{return isUInt<6>(Imm);}]> {
  let ParserMatchClass = UImmAsmOperand<6>;
  let EncoderMethod = "getImmOpValue";
  let DecoderMethod = "decodeUImmOperand<6>";
  let OperandType = "OPERAND_UIMM6";
  let MCOperandPredicate = [{
    int64_t Imm;
    return MCOp.evaluateAsConstantImm(Imm) && isUInt<6>(Imm);
  }];
  let OperandNamespace = "RISCVOp";
}

class CVSIMDALURR<bits<5> funct5, bit F, bit funct1, bits<3> funct3, string opcodestr>
    : CVInstSIMDRR<funct5, F, funct1, funct3, OPC_CUSTOM_3, (outs GPR:$rd),
              (ins GPR:$rs1, GPR:$rs2), opcodestr, "$rd, $rs1, $rs2">;

let Constraints = "$rd = $rd_wb" in 
class CVSIMDALURRWb<bits<5> funct5, bit F, bit funct1, bits<3> funct3, string opcodestr>
    : CVInstSIMDRR<funct5, F, funct1, funct3, OPC_CUSTOM_3, (outs GPR:$rd_wb),
              (ins GPR:$rd, GPR:$rs1, GPR:$rs2), opcodestr, "$rd, $rs1, $rs2">;

class CVSIMDALURI<bits<5> funct5, bit F, bits<3> funct3, string opcodestr>
    : CVInstSIMDRI<funct5, F, funct3, OPC_CUSTOM_3, (outs GPR:$rd),
              (ins GPR:$rs1, simm6:$imm6), opcodestr, "$rd, $rs1, $imm6">;

let Constraints = "$rd = $rd_wb" in 
class CVSIMDALURIWb<bits<5> funct5, bit F, bits<3> funct3, string opcodestr>
    : CVInstSIMDRI<funct5, F, funct3, OPC_CUSTOM_3, (outs GPR:$rd_wb),
              (ins GPR:$rd, GPR:$rs1, simm6:$imm6), opcodestr, "$rd, $rs1, $imm6">;

class CVSIMDALURU<bits<5> funct5, bit F, bits<3> funct3, string opcodestr>
    : CVInstSIMDRI<funct5, F, funct3, OPC_CUSTOM_3, (outs GPR:$rd),
              (ins GPR:$rs1, cv_uimm6:$imm6), opcodestr, "$rd, $rs1, $imm6">;

let Constraints = "$rd = $rd_wb" in 
class CVSIMDALURUWb<bits<5> funct5, bit F, bits<3> funct3, string opcodestr>
    : CVInstSIMDRI<funct5, F, funct3, OPC_CUSTOM_3, (outs GPR:$rd_wb),
              (ins GPR:$rd, GPR:$rs1, cv_uimm6:$imm6), opcodestr, "$rd, $rs1, $imm6">;

class CVSIMDALUR<bits<5> funct5, bit F, bit funct1, bits<3> funct3, string opcodestr>
    : CVInstSIMDR<funct5, F, funct1, funct3, OPC_CUSTOM_3, (outs GPR:$rd),
              (ins GPR:$rs1), opcodestr, "$rd, $rs1">;

multiclass CVSIMDBinarySigned<bits<5> funct5, bit F, bit funct1, string mnemonic> {
  def CV_ # NAME # _H : CVSIMDALURR<funct5, F, funct1, 0b000, "cv." # mnemonic # ".h">;
  def CV_ # NAME # _B : CVSIMDALURR<funct5, F, funct1, 0b001, "cv." # mnemonic # ".b">;
  def CV_ # NAME # _SC_H : CVSIMDALURR<funct5, F, funct1, 0b100, "cv." # mnemonic # ".sc.h">;
  def CV_ # NAME # _SC_B : CVSIMDALURR<funct5, F, funct1, 0b101, "cv." # mnemonic # ".sc.b">;
  def CV_ # NAME # _SCI_H : CVSIMDALURI<funct5, F, 0b110, "cv." # mnemonic # ".sci.h">;
  def CV_ # NAME # _SCI_B : CVSIMDALURI<funct5, F, 0b111, "cv." # mnemonic # ".sci.b">;
}

multiclass CVSIMDBinaryUnsigned<bits<5> funct5, bit F, bit funct1, string mnemonic> {
  def CV_ # NAME # _H : CVSIMDALURR<funct5, F, funct1, 0b000, "cv." # mnemonic # ".h">;
  def CV_ # NAME # _B : CVSIMDALURR<funct5, F, funct1, 0b001, "cv." # mnemonic # ".b">;
  def CV_ # NAME # _SC_H : CVSIMDALURR<funct5, F, funct1, 0b100, "cv." # mnemonic # ".sc.h">;
  def CV_ # NAME # _SC_B : CVSIMDALURR<funct5, F, funct1, 0b101, "cv." # mnemonic # ".sc.b">;
  def CV_ # NAME # _SCI_H : CVSIMDALURU<funct5, F, 0b110, "cv." # mnemonic # ".sci.h">;
  def CV_ # NAME # _SCI_B : CVSIMDALURU<funct5, F, 0b111, "cv." # mnemonic # ".sci.b">;
}

multiclass CVSIMDBinarySignedWb<bits<5> funct5, bit F, bit funct1, string mnemonic> {
  def CV_ # NAME # _H : CVSIMDALURRWb<funct5, F, funct1, 0b000, "cv." # mnemonic # ".h">;
  def CV_ # NAME # _B : CVSIMDALURRWb<funct5, F, funct1, 0b001, "cv." # mnemonic # ".b">;
  def CV_ # NAME # _SC_H : CVSIMDALURRWb<funct5, F, funct1, 0b100, "cv." # mnemonic # ".sc.h">;
  def CV_ # NAME # _SC_B : CVSIMDALURRWb<funct5, F, funct1, 0b101, "cv." # mnemonic # ".sc.b">;
  def CV_ # NAME # _SCI_H : CVSIMDALURIWb<funct5, F, 0b110, "cv." # mnemonic # ".sci.h">;
  def CV_ # NAME # _SCI_B : CVSIMDALURIWb<funct5, F, 0b111, "cv." # mnemonic # ".sci.b">;
}

multiclass CVSIMDBinaryUnsignedWb<bits<5> funct5, bit F, bit funct1, string mnemonic> {
  def CV_ # NAME # _H : CVSIMDALURRWb<funct5, F, funct1, 0b000, "cv." # mnemonic # ".h">;
  def CV_ # NAME # _B : CVSIMDALURRWb<funct5, F, funct1, 0b001, "cv." # mnemonic # ".b">;
  def CV_ # NAME # _SC_H : CVSIMDALURRWb<funct5, F, funct1, 0b100, "cv." # mnemonic # ".sc.h">;
  def CV_ # NAME # _SC_B : CVSIMDALURRWb<funct5, F, funct1, 0b101, "cv." # mnemonic # ".sc.b">;
  def CV_ # NAME # _SCI_H : CVSIMDALURUWb<funct5, F, 0b110, "cv." # mnemonic # ".sci.h">;
  def CV_ # NAME # _SCI_B : CVSIMDALURUWb<funct5, F, 0b111, "cv." # mnemonic # ".sci.b">;
}


let Predicates = [HasExtXcvsimd], hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
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
  defm OR :     CVSIMDBinaryUnsigned<0b01011, 0, 0, "or">;
  defm XOR :    CVSIMDBinaryUnsigned<0b01100, 0, 0, "xor">;
  defm AND :    CVSIMDBinaryUnsigned<0b01101, 0, 0, "and">;

  def CV_ABS_H :    CVSIMDALUR<0b01110, 0, 0, 0b000, "cv.abs.h">;
  def CV_ABS_B :    CVSIMDALUR<0b01110, 0, 0, 0b001, "cv.abs.b">;

  // 0b01111xx: UNDEF

  defm DOTUP :   CVSIMDBinaryUnsigned<0b10000, 0, 0, "dotup">;
  defm DOTUSP :  CVSIMDBinarySigned<0b10001, 0, 0, "dotusp">;
  defm DOTSP :   CVSIMDBinarySigned<0b10010, 0, 0, "dotsp">;
  defm SDOTUP :  CVSIMDBinaryUnsignedWb<0b10011, 0, 0, "sdotup">;
  defm SDOTUSP : CVSIMDBinarySignedWb<0b10100, 0, 0, "sdotusp">;
  defm SDOTSP :  CVSIMDBinarySignedWb<0b10101, 0, 0, "sdotsp">;

  // 0b10110xx: UNDEF

  def CV_EXTRACT_H :    CVSIMDALURU<0b10111, 0, 0b000, "cv.extract.h">;
  def CV_EXTRACT_B :    CVSIMDALURU<0b10111, 0, 0b001, "cv.extract.b">;
  def CV_EXTRACTU_H :   CVSIMDALURU<0b10111, 0, 0b010, "cv.extractu.h">;
  def CV_EXTRACTU_B :   CVSIMDALURU<0b10111, 0, 0b011, "cv.extractu.b">;
  def CV_INSERT_H :     CVSIMDALURUWb<0b10111, 0, 0b100, "cv.insert.h">;
  def CV_INSERT_B :     CVSIMDALURUWb<0b10111, 0, 0b101, "cv.insert.b">;

  def CV_SHUFFLE_H :    CVSIMDALURR<0b11000, 0, 0, 0b000, "cv.shuffle.h">;
  def CV_SHUFFLE_B :    CVSIMDALURR<0b11000, 0, 0, 0b001, "cv.shuffle.b">;
  def CV_SHUFFLE_SCI_H : CVSIMDALURU<0b11000, 0, 0b110, "cv.shuffle.sci.h">;
  def CV_SHUFFLEI0_SCI_B : CVSIMDALURU<0b11000, 0, 0b111, "cv.shufflei0.sci.b">;

  def CV_SHUFFLEI1_SCI_B : CVSIMDALURU<0b11001, 0, 0b111, "cv.shufflei1.sci.b">;

  def CV_SHUFFLEI2_SCI_B : CVSIMDALURU<0b11010, 0, 0b111, "cv.shufflei2.sci.b">;

  def CV_SHUFFLEI3_SCI_B : CVSIMDALURU<0b11011, 0, 0b111, "cv.shufflei3.sci.b">;

  def CV_SHUFFLE2_H :    CVSIMDALURRWb<0b11100, 0, 0, 0b000, "cv.shuffle2.h">;
  def CV_SHUFFLE2_B :    CVSIMDALURRWb<0b11100, 0, 0, 0b001, "cv.shuffle2.b">;

  // 0b11101xx: UNDEF

  def CV_PACK :      CVSIMDALURR<0b11110, 0, 0, 0b000, "cv.pack">;
  def CV_PACK_H :    CVSIMDALURR<0b11110, 0, 1, 0b000, "cv.pack.h">;
  
  def CV_PACKHI_B : CVSIMDALURRWb<0b11111, 0, 1, 0b001, "cv.packhi.b">;
  def CV_PACKLO_B : CVSIMDALURRWb<0b11111, 0, 0, 0b001, "cv.packlo.b">;
  
  defm CMPEQ : CVSIMDBinarySigned<0b00000, 1, 0, "cmpeq">;
  defm CMPNE :  CVSIMDBinarySigned<0b00001, 1, 0, "cmpne">;
  defm CMPGT :  CVSIMDBinarySigned<0b00010, 1, 0, "cmpgt">;
  defm CMPGE :  CVSIMDBinarySigned<0b00011, 1, 0, "cmpge">;
  defm CMPLT :  CVSIMDBinarySigned<0b00100, 1, 0, "cmplt">;
  defm CMPLE :  CVSIMDBinarySigned<0b00101, 1, 0, "cmple">;
  defm CMPGTU : CVSIMDBinaryUnsigned<0b00110, 1, 0, "cmpgtu">;
  defm CMPGEU : CVSIMDBinaryUnsigned<0b00111, 1, 0, "cmpgeu">;
  defm CMPLTU : CVSIMDBinaryUnsigned<0b01000, 1, 0, "cmpltu">;
  defm CMPLEU : CVSIMDBinaryUnsigned<0b01001, 1, 0, "cmpleu">;

  def CV_CPLXMUL_R :    CVSIMDALURRWb<0b01010, 1, 0, 0b000, "cv.cplxmul.r">;
  def CV_CPLXMUL_I :    CVSIMDALURRWb<0b01010, 1, 1, 0b000, "cv.cplxmul.i">;
  def CV_CPLXMUL_R_DIV2 :    CVSIMDALURRWb<0b01010, 1, 0, 0b010, "cv.cplxmul.r.div2">;
  def CV_CPLXMUL_I_DIV2 :    CVSIMDALURRWb<0b01010, 1, 1, 0b010, "cv.cplxmul.i.div2">;
  def CV_CPLXMUL_R_DIV4 :    CVSIMDALURRWb<0b01010, 1, 0, 0b100, "cv.cplxmul.r.div4">;
  def CV_CPLXMUL_I_DIV4 :    CVSIMDALURRWb<0b01010, 1, 1, 0b100, "cv.cplxmul.i.div4">; 
  def CV_CPLXMUL_R_DIV8 :    CVSIMDALURRWb<0b01010, 1, 0, 0b110, "cv.cplxmul.r.div8">;
  def CV_CPLXMUL_I_DIV8 :    CVSIMDALURRWb<0b01010, 1, 1, 0b110, "cv.cplxmul.i.div8">;

  def CV_CPLXCONJ :    CVSIMDALUR<0b01011, 1, 0, 0b000, "cv.cplxconj">;

  // 0b01011xx: UNDEF

  def CV_SUBROTMJ :    CVSIMDALURR<0b01100, 1, 0, 0b000, "cv.subrotmj">;
  def CV_SUBROTMJ_DIV2 :    CVSIMDALURR<0b01100, 1, 0, 0b010, "cv.subrotmj.div2">;
  def CV_SUBROTMJ_DIV4 :    CVSIMDALURR<0b01100, 1, 0, 0b100, "cv.subrotmj.div4">; 
  def CV_SUBROTMJ_DIV8 :    CVSIMDALURR<0b01100, 1, 0, 0b110, "cv.subrotmj.div8">;  

  def CV_ADD_DIV2 :    CVSIMDALURR<0b01101, 1, 0, 0b010, "cv.add.div2">;
  def CV_ADD_DIV4 :    CVSIMDALURR<0b01101, 1, 0, 0b100, "cv.add.div4">;
  def CV_ADD_DIV8 :    CVSIMDALURR<0b01101, 1, 0, 0b110, "cv.add.div8">;

  def CV_SUB_DIV2 :    CVSIMDALURR<0b01110, 1, 0, 0b010, "cv.sub.div2">;
  def CV_SUB_DIV4 :    CVSIMDALURR<0b01110, 1, 0, 0b100, "cv.sub.div4">;
  def CV_SUB_DIV8 :    CVSIMDALURR<0b01110, 1, 0, 0b110, "cv.sub.div8">; 
}
