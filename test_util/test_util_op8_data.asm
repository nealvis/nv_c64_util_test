//////////////////////////////////////////////////////////////////////////////
// test_util_op8_data.asm
// Copyright(c) 2021 Neal Smith.
// License: MIT. See LICENSE file in root directory.
//////////////////////////////////////////////////////////////////////////////
// This file contains data (variables) to be used as 8 bit operands
// for testing nv_c64_util macros that need 8 bit operands

// import all nv_c64_util macros and data.  The data
// will go in default place
#import "../../nv_c64_util/nv_c64_util_macs_and_data.asm"

op8_00: .byte $00
op8_01: .byte $01
op8_02: .byte $02
op8_03: .byte $03
op8_04: .byte $04
op8_05: .byte $05
op8_06: .byte $06
op8_07: .byte $07
op8_08: .byte $08
op8_09: .byte $09
op8_10: .byte $10
op8_0F: .byte $0F
op8_20: .byte $20
op8_22: .byte $22
op8_33: .byte $33
op8_3F: .byte $3F
op8_40: .byte $40
op8_7D: .byte $7D
op8_7F: .byte $7F
op8_80: .byte $80  // -128
op8_81: .byte $81  // -127
op8_99: .byte $99
op8_AA: .byte $AA
op8_F0: .byte $F0
op8_FD: .byte $FD
op8_FE: .byte $FE
op8_FF: .byte $FF

