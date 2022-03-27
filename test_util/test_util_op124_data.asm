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
result16: .word $0000

// (signed)

op124_FFF0: .word $FFF0  // -7FF.0    
op124_FFF1: .word $FFF1  // -7FF.0625
op124_FFF2: .word $FFF2  // -7FF.125
op124_FFF4: .word $FFF4  // -7FF.25
op124_FFF8: .word $FFF8  // -7FF.5
op124_FFFC: .word $FFFC  // -7FF.75

op124_0000: .word $0000  // 0.0
op124_0001: .word $0001  // 0.0625
op124_0002: .word $0002  // 0.125
op124_0004: .word $0004  // 0.25
op124_0008: .word $0008  // 0.5
op124_000C: .word $000C  // 0.75

op124_8000: .word $8000  // -0.0
op124_8001: .word $8001  // -0.0625
op124_8002: .word $8002  // -0.125
op124_8004: .word $8004  // -0.25
op124_8008: .word $8008  // -0.5
op124_800C: .word $800C  // -0.75

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
op124_0037: .word $0037  // +3.4375
op124_0038: .word $0038  // +3.5
op124_003C: .word $003C  // +3.75
op124_003E: .word $003E  // +3.875
op124_003F: .word $003F  // +3.9375

op124_8030: .word $8030  // -3.0
op124_8031: .word $8031  // -3.0625
op124_8032: .word $8032  // -3.125
op124_8034: .word $8034  // -3.25
op124_8037: .word $8037  // -3.4375
op124_8038: .word $8038  // -3.5
op124_803C: .word $803C  // -3.75
op124_803E: .word $803E  // -3.875

op124_7FF0: .word $7FF0  // 
op124_7FF1: .word $7FF1  // 
op124_7FF2: .word $7FF2  // 
op124_7FF4: .word $7FF4  // 
op124_7FF8: .word $7FF8  // 
op124_7FFC: .word $7FFC  // 
op124_7FFE: .word $7FFE  // 
op124_7FFF: .word $7FFF  // largest positive number 

op124_800F: .word $800F // -0.9375
op124_8007: .word $8007 // -0.4375

op124_8010: .word $8010 // -1.0

op124_FFF7: .word $FFF7 
op124_FFFF: .word $FFFF 
