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

result: .word $0000

op16_0000: .word $0000
op16_0001: .word $0001
op16_0002: .word $0002
op16_0009: .word $0009
op16_0020: .word $0020
op16_007F: .word $007F
op16_0080: .word $0080 // 128
op16_0081: .word $0081 // 129
op16_0099: .word $0099
op16_00FF: .word $00FF
op16_0100: .word $0100
op16_0200: .word $0200
op16_0300: .word $0300
op16_0999: .word $0999
op16_2201: .word $2201
op16_2222: .word $2222
op16_3333: .word $3333
op16_557F: .word $557F
op16_7FFF: .word $7FFF
op16_8000: .word $8000 // high bit only set
op16_8001: .word $8001 // high bit only set
op16_9000: .word $9000
op16_9998: .word $9998
op16_9999: .word $9999
op16_BEEF: .word $BEEF
op16_FF00: .word $FF00
op16_FFFD: .word $FFFD // -3
op16_FFFE: .word $FFFE // -2
op16_FFFF: .word $FFFF // -1

op16_Small: .word $0005
op16_Big:   .word $747E
op16_Max:   .word $FFFF
