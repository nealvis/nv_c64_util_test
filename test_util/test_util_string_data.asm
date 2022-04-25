//////////////////////////////////////////////////////////////////////////////
// test_util_string_data.asm
// Copyright(c) 2022 Neal Smith.
// License: MIT. See LICENSE file in root directory.
//////////////////////////////////////////////////////////////////////////////
// This file contains data (variables) to be used as string
// operands for testing nv_c64_util macros that need strings

// import all nv_c64_util macros and data.  The data
// will go in default place
#import "../../nv_c64_util/nv_c64_util_macs_and_data.asm"

result8: .byte $00

opStr_ABCD: .text @"ABCD\$00"
opStr_ABCZ: .text @"ABCZ\$00"
opStr_ABC: .text @"ABC\$00"
opStr_A: .text @"A\$00"
opStr_empty: .text @"\$00"

opStr_EFGH: .text @"EFGH\$00"
opStr_EFG: .text @"EFG\$00"

opStr_012: .text @"012\$00"
opStr_012_pt_345: .text @"012.345\$00"
opStr_001122: .text @"001122\$00"
opStr_12_pt_345: .text @"12.345\$00"
opStr_012_pt_3450: .text @"012.3450\$00"
opStr_0012_pt_34500: .text @"012.3450\$00"

opStr_A2Z: .text@"ABCDEFGHIJKLMNOPQRSTUVWXYZ\$00"
opStr_0to9: .text@"0123456789\$00"
opStr_0to9A: .text@"0123456789A\$00"
opStr_A2Z_0to9: .text@"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\$00"

result_str: 
.var index
.for (index = 0; index < 256; index++)
{
    .byte $00
}

