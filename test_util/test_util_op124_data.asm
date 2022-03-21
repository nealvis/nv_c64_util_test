//////////////////////////////////////////////////////////////////////////////
// test_util_op124_data.asm
// Copyright(c) 2022 Neal Smith.
// License: MIT. See LICENSE file in root directory.
//////////////////////////////////////////////////////////////////////////////
// This file contains data (variables) to be used as fixed point 12.4
// operands for testing nv_c64_util macros that need FP124 bit operands

// import all nv_c64_util macros and data.  The data
// will go in default place
#import "../../nv_c64_util/nv_c64_util_macs_and_data.asm"

result124: .word $0000

// FP124 
op124_FFF0: .word $FFF0  // -1.0
op124_FFF1: .word $FFF1  // -1.0625
op124_FFF2: .word $FFF2  // -1.125
op124_FFF4: .word $FFF4  // -1.25
op124_FFF8: .word $FFF8  // -1.5
op124_FFFC: .word $FFFC  // -1.75

op124_0010: .word $0010  // 1.0
op124_0011: .word $0011  // 1.0625
op124_0012: .word $0012  // 1.125
op124_0014: .word $0014  // 1.25
op124_0018: .word $0018  // 1.5
op124_001C: .word $001C  // 1.75

op124_0030: .word $0030  // +3.0
op124_0031: .word $0031  // +3.0625
op124_0032: .word $0032  // +3.125
op124_0034: .word $0034  // +3.25
op124_0038: .word $0038  // +3.5
op124_003C: .word $003C  // +3.75
op124_003E: .word $003E  // +3.875

