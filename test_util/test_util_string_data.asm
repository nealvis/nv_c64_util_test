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

opStr_BCD: .text @"BCD\$00"
opStr_ABCD: .text @"ABCD\$00"
opStr_ABCZ: .text @"ABCZ\$00"
opStr_ABC: .text @"ABC\$00"
opStr_A: .text @"A\$00"
opStr_AA: .text @"AA\$00"
opStr_AAA: .text @"AAA\$00"
opStr_empty: .text @"\$00"

opStr_EFGH: .text @"EFGH\$00"
opStr_EFG: .text @"EFG\$00"

opStr_012: .text @"012\$00"
opStr_012_pt_3400: .text @"012.3400\$00"
opStr_012_pt_34: .text @"012.34\$00"
opStr_12_pt_3400: .text @"12.3400\$00"
opStr_12_pt_340: .text @"12.340\$00"
opStr_12_pt_34: .text @"12.34\$00"

opStr_0012_pt_345: .text @"0012.345\$00"

opStr_012_pt_345: .text @"012.345\$00"
opStr_001122: .text @"001122\$00"
opStr_12_pt_345: .text @"12.345\$00"
opStr_12_pt_3450: .text @"12.3450\$00"
opStr_012_pt_3450: .text @"012.3450\$00"
opStr_0012_pt_3450: .text @"0012.3450\$00"

opStr_0001_pt_5000: .text @"0001.5000\$00"
opStr_0001_pt_0000: .text @"0001.0000\$00"
opStr_1_pt_5: .text @"1.5\$00"
opStr_1: .text @"1\$00"
opStr_0: .text @"0\$00"
opStr_n_1: .text @"-1\$00"
opStr_n_0: .text @"-0\$00"

opStr_n_0_pt_9375: .text @"-0.9375\$00"
opStr_n_3_pt_25: .text @"-3.25\$00"
opStr_3_pt_25: .text @"3.25\$00"

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

