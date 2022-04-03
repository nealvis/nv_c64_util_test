//////////////////////////////////////////////////////////////////////////////
// branch124_immediate_test_far.asm
// Copyright(c) 2022 Neal Smith.
// License: MIT. See LICENSE file in root directory.
//////////////////////////////////////////////////////////////////////////////
// This program demonstrates and tests the fixed point 12.4 far branch 
// operations in nv_branch124_macs.asm

// import all nv_c64_util macros and data.  The data
// will go in default place
#import "../../nv_c64_util/nv_c64_util_macs_and_data.asm"
#import "../../nv_c64_util_test/test_util/test_util_op124_data.asm"
//#import "../../nv_c64_util/nv_screen_macs.asm"
//#import "../../nv_c64_util/nv_keyboard_macs.asm"

*=$0800 "BASIC Start"
.byte 0 // first byte should be 0
        // location to put a 1 line basic program so we can just
        // type run to execute the assembled program.
        // will just call assembled program at correct location
        //    10 SYS (4096)

        // These bytes are a one line basic program that will 
        // do a sys call to assembly language portion of
        // of the program which will be at $1000 or 4096 decimal
        // basic line is: 
        // 10 SYS (4096)
        .byte $0E, $08           // Forward address to next basic line
        .byte $0A, $00           // this will be line 10 ($0A)
        .byte $9E                // basic token for SYS
        .byte $20, $28, $34, $30, $39, $36, $29 // ASCII for " (4096)"
        .byte $00, $00, $00      // end of basic program (addr $080E from above)

*=$0820 "Vars"

.const dollar_sign = $24
.const CMP_EQUAL = 0
.const CMP_LESS = -1
.const CMP_GREATER = 1


// program variables
equal_str: .text@" = \$00"
not_equal_str: .text@" != \$00"
greater_equal_str: .text@" >= \$00" 
less_than_str: .text@" < \$00"
greater_than_str: .text@" > \$00"
less_equal_str: .text@" <= \$00" 

title_str: .text @"BR124 IMMED FAR\$00"          // null terminated string to print
                                                 // via the BASIC routine
title_cmp124u_str: .text @"CMP124U IMMED FAR \$00"
title_beq124u_str: .text @"BEQ124U IMMED FAR \$00"
title_bne124u_str: .text @"BNE124U IMMED FAR \$00"
title_blt124u_str: .text @"BLT124U IMMED FAR \$00"
title_ble124u_str: .text @"BLE124U IMMED FAR \$00"
title_bgt124u_str: .text @"BGT124U IMMED FAR \$00"
title_bge124u_str: .text @"BGE124U IMMED FAR \$00"

title_cmp124s_str: .text @"CMP124S IMMED FAR \$00"
title_beq124s_str: .text @"BEQ124S IMMED FAR \$00"
title_bne124s_str: .text @"BNE124S IMMED FAR \$00"
title_blt124s_str: .text @"BLT124S IMMED FAR \$00"
title_ble124s_str: .text @"BLE124S IMMED FAR \$00"
title_bgt124s_str: .text @"BGT124S IMMED FAR \$00"
title_bge124s_str: .text @"BGE124S IMMED FAR \$00"

result: .word $0000

op1: .word $FFFF
op2: .word $FFFF
opSmall: .word $0005
opBig:   .word $747E

op1Beef: .word $beef
op2Beef: .word $beef

opZero: .word $0000
opMax: .word $ffff
opOne: .word $0001
opTwo: .word $0002
opHighOnes: .word $FF00
opLowOnes: .word $00FF


*=$1000 "Main Start"

.var row = 0

    nv_screen_print_str(normal_control_str)
    nv_screen_clear()
    nv_screen_plot_cursor(row++, 25)
    nv_screen_print_str(title_str)

    .var do_signed = true
    //.var do_signed = false

    .if (do_signed)
    {
        // signed tests
        //test_cmp124s(0)
        test_beq124s(0)
        test_bne124s(0)
        test_blt124s(0)
        test_ble124s(0)
        test_bgt124s(0)
        test_bge124s(0)
    }
    else
    {
        //test_cmp124u(0)
        test_beq124u(0)
        test_bne124u(0)
        test_blt124u(0)
        test_ble124u(0)
        test_bgt124u(0)
        test_bge124u(0)
    }

    rts


//////////////////////////////////////////////////////////////////////////////
// Test the cmp_124 macro
.macro test_cmp124u(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_cmp124u_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_cmp124_immed( false, op1Beef, $BEEF, CMP_EQUAL)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_cmp124_immed( false, opSmall, $747E, CMP_LESS)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_cmp124_immed( false, opBig, $0005, CMP_GREATER)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_cmp124_immed( false, opSmall, $0005, CMP_EQUAL)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_cmp124_immed( false, opBig, $0005, CMP_GREATER)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_cmp124_immed( false, opTwo, $0001, CMP_GREATER)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_cmp124_immed( false, opOne, $0000, CMP_GREATER)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_cmp124_immed( false, opOne, $FFFF, CMP_LESS)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_cmp124_immed( false, opZero, $FFFF, CMP_LESS)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_cmp124_immed( false, opZero, $0001, CMP_LESS)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_cmp124_immed( false, opMax, $0001, CMP_GREATER)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_cmp124_immed( false, opMax, $0000, CMP_GREATER)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_cmp124_immed( false, opMax, $FFFF, CMP_EQUAL)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_cmp124_immed( false, opOne, $0001, CMP_EQUAL)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_cmp124_immed( false, opZero, $0000, CMP_EQUAL)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_cmp124_immed( false, opHighOnes, $00FF, CMP_GREATER)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_cmp124_immed( false, opLowOnes, $FF00, CMP_LESS)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_cmp124_immed( false, opHighOnes, $FF00, CMP_EQUAL)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_cmp124_immed( false, opLowOnes, $00FF, CMP_EQUAL)


    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
// Test the cmp124s macro
.macro test_cmp124s(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_cmp124s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_cmp124_immed( true, op1Beef, $FFFF, CMP_EQUAL)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_beq124u(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_beq124u_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  op1Beef, $BEEF, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opSmall, $747E, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opBig, $0005, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opSmall, $0005, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opBig, $0005, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opTwo, $0001, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opOne, $0000, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opOne, $FFFF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opZero, $FFFF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opZero, $0001, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opMax, $0001, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opMax, $0000, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opMax, $FFFF, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opOne, $0001, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opZero, $0000, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opHighOnes, $00FF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opLowOnes, $FF00, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opHighOnes, $FF00, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opLowOnes, $00FF, true)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
// Test the beq124s macro
.macro test_beq124s(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_beq124s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(true, op124_0000, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  op1Beef, $BEEF, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opSmall, $747E, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opBig, $0005, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opSmall, $0005, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opBig, $0005, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opTwo, $0001, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opOne, $0000, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opOne, $FFFF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opZero, $FFFF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opZero, $0001, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opMax, $0001, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opMax, $0000, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opMax, $FFFF, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opOne, $0001, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opZero, $0000, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opHighOnes, $00FF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opLowOnes, $FF00, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opHighOnes, $FF00, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124_immed(false,  opLowOnes, $00FF, true)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_bne124u(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_bne124u_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(false, op1Beef, $BEEF, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(false, opSmall, $747E, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(false, opBig, $0005, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(false, opSmall, $0005, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(false, opBig, $0005, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(false, opTwo, $0001, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(false, opOne, $0000, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(false, opOne, $FFFF, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(false, opZero, $FFFF, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(false, opZero, $0001, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(false, opMax, $0001, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(false, opMax, $0001, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(false, opMax, $FFFF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(false, opOne, $0001, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(false, opZero, $0000, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(false, opHighOnes, $00FF, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(false, opLowOnes, $FF00, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(false, opHighOnes, $FF00, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(false, opLowOnes, $00FF, false)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
// Test the bne124s macro
.macro test_bne124s(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_bne124s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(true, op124_0000, $0000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(true, op124_0000, $8000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(true, op124_8000, $0000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(true, op124_8000, $8000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(true, op124_8030, $0030, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(true, op124_0030, $8030, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(true, op124_0030, $0031, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(true, op124_8030, $8031, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(true, op124_FFFF, $FFF7, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(true, op124_FFF7, $FFF7, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(true, op124_FE00, $7E00, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(true, op124_7E00, $7F00, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124_immed(true, op124_7E00, $7E00, false)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_blt124u(init_row)
{
    .var row = init_row
        
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_blt124u_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(false, op1Beef, $BEEF, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(false, opSmall, $747E, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(false, opBig, $0005, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(false, opSmall, $0005, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(false, opTwo, $0001, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(false, opOne, $0000, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(false, opOne, $FFFF, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(false, opZero, $FFFF, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(false, opZero, $0001, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(false, opMax, $0001, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(false, opMax, $0000, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(false, opMax, $FFFF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(false, opOne, $0001, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(false, opZero, $0000, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(false, opHighOnes, $00FF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(false, opLowOnes, $FF00, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(false, opHighOnes, $FF00, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(false, opLowOnes, $00FF, false)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
// Test the blt124s macro
.macro test_blt124s(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_blt124s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(true, op124_0000, $0000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(true, op124_0000, $8000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(true, op124_8000, $0000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(true, op124_8000, $8000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(true, op124_8030, $0030, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(true, op124_0030, $8030, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(true, op124_0030, $0031, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(true, op124_8030, $8031, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(true, op124_FFFF, $FFF7, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(true, op124_FFF7, $FFF7, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(true, op124_FE00, $7E00, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(true, op124_7E00, $7F00, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124_immed(true, op124_7E00, $7E00, false)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_ble124u(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_ble124u_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(false, op1Beef, $BEEF, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(false, opSmall, $747E, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(false, opBig, $0005, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(false, opSmall, $0005, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(false, opBig, $0005, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(false, opTwo, $0001, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(false, opOne, $0000, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(false, opOne, $FFFF, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(false, opZero, $FFFF, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(false, opZero, $0001, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(false, opMax, $0001, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(false, opMax, $0000, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(false, opMax, $FFFF, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(false, opOne, $0001, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(false, opZero, $0000, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(false, opHighOnes, $00FF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(false, opLowOnes, $FF00, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(false, opHighOnes, $FF00, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(false, opLowOnes, $00FF, true)

    wait_and_clear_at_row(row, title_str)
}

//////////////////////////////////////////////////////////////////////////////
// Test the ble124s macro
.macro test_ble124s(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_ble124s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(true, op124_0000, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(true, op124_0000, $8000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(true, op124_8000, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(true, op124_8000, $8000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(true, op124_8030, $0030, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(true, op124_0030, $8030, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(true, op124_0030, $0031, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(true, op124_8030, $8031, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(true, op124_FFFF, $FFF7, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(true, op124_FFF7, $FFF7, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(true, op124_FE00, $7E00, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(true, op124_7E00, $7F00, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124_immed(true, op124_7E00, $7E00, true)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_bgt124u(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_bgt124u_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(false, op1Beef, $BEEF, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(false, opSmall, $747E, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(false, opBig, $0005, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(false, opSmall, $0005, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(false, opTwo, $0001, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(false, opOne, $0000, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(false, opOne, $FFFF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(false, opZero, $FFFF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(false, opZero, $0001, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(false, opMax, $0001, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(false, opMax, $0000, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(false, opMax, $FFFF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(false, opOne, $0001, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(false, opZero, $0000, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(false, opHighOnes, $00FF, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(false, opLowOnes, $FF00, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(false, opHighOnes, $FF00, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(false, opLowOnes, $00FF, false)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
// Test the bgt124s macro
.macro test_bgt124s(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_bgt124s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(true, op124_0000, $0000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(true, op124_0000, $8000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(true, op124_8000, $0000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(true, op124_8000, $8000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(true, op124_8030, $0030, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(true, op124_0030, $8030, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(true, op124_0030, $0031, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(true, op124_8030, $8031, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(true, op124_FFFF, $FFF7, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(true, op124_FFF7, $FFF7, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(true, op124_FE00, $7E00, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(true, op124_7E00, $7F00, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124_immed(true, op124_7E00, $7E00, false)

    wait_and_clear_at_row(row, title_str)
}




//////////////////////////////////////////////////////////////////////////////
//
.macro test_bge124u(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_bge124u_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(false, op1Beef, $BEEF, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(false, opSmall, $747E, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(false, opBig, $0005, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(false, opSmall, $0005, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(false, opTwo, $0001, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(false, opOne, $0000, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(false, opOne, $FFFF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(false, opZero, $FFFF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(false, opZero, $0001, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(false, opMax, $0001, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(false, opMax, $0000, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(false, opMax, $FFFF, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(false, opOne, $0001, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(false, opZero, $0000, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(false, opHighOnes, $00FF, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(false, opLowOnes, $FF00, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(false, opHighOnes, $FF00, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(false, opLowOnes, $00FF, true)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
// Test the bge124s macro
.macro test_bge124s(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_bge124s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(true, op124_0000, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(true, op124_0000, $8000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(true, op124_8000, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(true, op124_8000, $8000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(true, op124_8030, $0030, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(true, op124_0030, $8030, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(true, op124_0030, $0031, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(true, op124_8030, $8031, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(true, op124_FFFF, $FFF7, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(true, op124_FFF7, $FFF7, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(true, op124_FE00, $7E00, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(true, op124_7E00, $7F00, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124_immed(true, op124_7E00, $7E00, true)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//                          Print macros 
//////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////
// Print a comparison of two fp124u values one at a memory location and
// one as an immediate value 
// Prints at the current cursor location via a basic call
.macro print_cmp124_immed(signed, addr1, num, expected_cmp)
{
    lda #1 
    sta passed

    nv_xfer124_mem_mem(addr1, fp124_to_print)
    jsr PrintHexFP124

    .if (signed)
    {
        nv_cmp124s_immed(addr1, num)
    }
    else
    {
        nv_cmp124u_immed(addr1, num)
    }

    bne NotEq
// Equal here
    .if (expected_cmp != CMP_EQUAL)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(equal_str)
    jmp PrintOp2

NotEq:
    bcs GreaterOrEqual
// less than here
    .if (expected_cmp != CMP_LESS)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(less_than_str)
    jmp PrintOp2

// Greater here
GreaterOrEqual:
    .if (expected_cmp != CMP_GREATER)
    {
        lda #0 
        sta passed
    }

    nv_screen_print_str(greater_than_str)

PrintOp2:

    //nv_xfer124_mem_mem(addr2, fp124_to_print)
    nv_store16_immed(fp124_to_print, num)
    jsr PrintHexFP124

    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either = or != ) 
// for the relationship of the two word in memorys.  Use beq124u to do it.
//   addr1: is the address of LSB of one fp124u (addr1+1 is MSB)
//   addr2: is the address of LSB of the other fp124u (addr2+1 is MSB)
.macro print_beq124_immed(signed, addr1, num, expect_to_branch)
{
    lda #1 
    sta passed

    nv_xfer124_mem_mem(addr1, fp124_to_print)
    jsr PrintHexFP124
   
    .if (signed)
    {
        nv_beq124s_immed_far(addr1, num, BranchTarget)
    }
    else
    {
        nv_beq124u_immed_far(addr1, num, BranchTarget)
    }
    .if (expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(not_equal_str)
    jmp Done

    .var index = 0
    .for(index = 0; index < 124; index = index + 1) {nop}
BranchTarget:
    .if (!expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(equal_str)

Done:
    //nv_xfer124_mem_mem(addr2, fp124_to_print)
    nv_store16_immed(fp124_to_print, num)
    jsr PrintHexFP124

    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either != or = ) 
// for the relationship of the two word in memorys.  Use bne124u to do it.
//   addr1: is the address of LSB of one fp124u (addr1+1 is MSB)
//   num: is the immediate numberof the other fp124u
.macro print_bne124_immed(signed, addr1, num, expect_to_branch)
{
    lda #1 
    sta passed

    nv_xfer124_mem_mem(addr1, fp124_to_print)
    jsr PrintHexFP124
    .if (signed)   
    {
        nv_bne124s_immed_far(addr1, num, BranchTarget)
    }
    else
    {
        nv_bne124u_immed_far(addr1, num, BranchTarget)
    }
    .if (expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(not_equal_str)
    jmp Done

    .var index = 0
    .for(index = 0; index < 124; index = index + 1) {nop}
BranchTarget:
    .if (!expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(equal_str)

Done:
    nv_store16_immed(fp124_to_print, num)
    //nv_xfer124_mem_mem(addr2, fp124_to_print)
    jsr PrintHexFP124

    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either < or >= ) 
// for the relationship of the one fp124u in memory and an immediate value.
// Use blt124u_immed to do it.
//   addr1: is the address of LSB of fp124u (addr1+1 is MSB)
//   num: is the immediate value for the other fp124u
.macro print_blt124_immed(signed, addr1, num, expect_to_branch)
{
    lda #1 
    sta passed

    nv_xfer124_mem_mem(addr1, fp124_to_print)
    jsr PrintHexFP124
       
    .if (signed)   
    {
        nv_blt124s_immed_far(addr1, num, BranchTarget)
    }
    else
    {
        nv_blt124u_immed_far(addr1, num, BranchTarget)
    }
    .if (expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(greater_equal_str)
    jmp Done

    .var index = 0
    .for(index = 0; index < 124; index = index + 1) {nop}
BranchTarget:
    .if (!expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(less_than_str)

Done:
    nv_store16_immed(fp124_to_print, num)
    //nv_xfer124_mem_mem(addr2, fp124_to_print)
    jsr PrintHexFP124

    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either <= or >)
// for the relationship of the two word in memorys.  Use ble124u to do it.
//   addr1: is the address of LSB of fp124u (addr1+1 is MSB)
//   num: is the immediate value of another fp124u 
.macro print_ble124_immed(signed, addr1, num, expect_to_branch)
{
    lda #1 
    sta passed

    nv_xfer124_mem_mem(addr1, fp124_to_print)
    jsr PrintHexFP124
    
    .if (signed)   
    {
        nv_ble124s_immed_far(addr1, num, BranchTarget)
    }
    else
    {
        nv_ble124u_immed_far(addr1, num, BranchTarget)
    }
    .if (expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(greater_than_str)
    jmp Done

    .var index = 0
    .for(index = 0; index < 124; index = index + 1) {nop}
BranchTarget:
    .if (!expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(less_equal_str)

Done:
    nv_store16_immed(fp124_to_print, num)
    //nv_xfer124_mem_mem(addr2, fp124_to_print)
    jsr PrintHexFP124


    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either > or <= ) 
// for the relationship of the two word in memorys.  Use bgt124u to do it.
//   addr1: is the address of LSB of fp124u (addr1+1 is MSB
//   num: is the immediate value of another fp124u
.macro print_bgt124_immed(signed, addr1, num, expect_to_branch)
{
    lda #1
    sta passed

    nv_xfer124_mem_mem(addr1, fp124_to_print)
    jsr PrintHexFP124

    .if (signed)   
    {
        nv_bgt124s_immed_far(addr1, num, BranchTarget)
    }
    else
    {
        nv_bgt124u_immed_far(addr1, num, BranchTarget)
    }
    .if (expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(less_equal_str)
    jmp Done

    .var index = 0
    .for(index = 0; index < 124; index = index + 1) {nop}
BranchTarget:
    .if (!expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(greater_than_str)

Done:
    nv_store16_immed(fp124_to_print, num)
    //nv_xfer124_mem_mem(addr2, fp124_to_print)
    jsr PrintHexFP124
    
    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either >= or <)
// for the relationship of the two word in memorys.  Use bge124u to do it.
//   addr1: is the address of LSB of fp124u (addr1+1 is MSB)
//   num: is the immediate value of another fp124u
.macro print_bge124_immed(signed, addr1, num, expect_to_branch)
{
    lda #1 
    sta passed

    nv_xfer124_mem_mem(addr1, fp124_to_print)
    jsr PrintHexFP124
   
    .if (signed)   
    {
        nv_bge124s_immed_far(addr1, num, BranchTarget)
    }
    else
    {
        nv_bge124u_immed_far(addr1, num, BranchTarget)
    }

    .if (expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(less_than_str)
    jmp Done

    .var index = 0
    .for(index = 0; index < 124; index = index + 1) {nop}
BranchTarget:
    .if (!expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(greater_equal_str)

Done:
    nv_store16_immed(fp124_to_print, num)
    //nv_xfer124_mem_mem(addr2, fp124_to_print)
    jsr PrintHexFP124

    jsr PrintPassed
}


#import "../test_util/test_util_code.asm"

