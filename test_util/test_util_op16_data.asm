//////////////////////////////////////////////////////////////////////////////
// test_util_op16_data.asm
// Copyright(c) 2021 Neal Smith.
// License: MIT. See LICENSE file in root directory.
//////////////////////////////////////////////////////////////////////////////
// This file contains data (variables) to be used as 16 bit operands
// for testing nv_c64_util macros that need 16 bit operands

// import all nv_c64_util macros and data.  The data
// will go in default place
#import "../../nv_c64_util/nv_c64_util_macs_and_data.asm"

op16_FFFF:
op1: .word $FFFF
op2: .word $FFFF

op16_0000: .word $0000

result: .word $0000

opSmall: .word $0005
opBig:   .word $747E

op16_BEEF: .word $BEEF

op1Beef: .word $beef
op2Beef: .word $beef

opZero: .word $0000

op16_AllBits:
opMax: .word $FFFF

op16_0001:
opOne: .word $0001

op16_0002:
opTwo: .word $0002

op16_557F: .word $557F
op16_2201: .word $2201
op16_007F: .word $007F

op16_FF00:
opHighOnes: .word $FF00

op16_00FF:
opLowOnes: .word $00FF

op16_7FFF:
op_7FFF: .word $7FFF

op16_FFFE: 
op_FFFE: .word $FFFE

op16_0080:
op_0080: .word $0080 // 128

op16_0081: 
op_0081: .word $0081 // 129

op16_8000:
op_8000: .word $8000 // high bit only set

op_8001: .word $8001 // high bit only set
op_FFFF: .word $FFFF // all bits
op_0000: .word $0000 // all bits
op_0001: .word $0001 // all bits
op_0002: .word $0002 // all bits
op_00FF: .word $00FF 
op_0100: .word $0100
op_0200: .word $0200
op_0300: .word $0300
op_3333: .word $3333
op_2222: .word $2222
op_FFFD: .word $FFFD // -3
