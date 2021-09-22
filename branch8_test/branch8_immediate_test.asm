//////////////////////////////////////////////////////////////////////////////
// branch8_immediate_test.asm
// Copyright(c) 2021 Neal Smith.
// License: MIT. See LICENSE file in root directory.
//////////////////////////////////////////////////////////////////////////////
// This program demonstrates and tests the 8bit immediate branch operations 
// in nv_branch8_macs.asm

// import all nv_c64_util macros and data.  The data
// will go in default place
#import "../../nv_c64_util/nv_c64_util_macs_and_data.asm"

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

// program variables
equal_str: .text@" = \$00"
not_equal_str: .text@" != \$00"
greater_equal_str: .text@" >= \$00" 
less_than_str: .text@" < \$00"
greater_than_str: .text@" > \$00"
less_equal_str: .text@" <= \$00" 

title_str: .text @"BRANCH8 IMMED\$00"          // null terminated string to print
                                        // via the BASIC routine
title_beq8_immediate_str: .text @"TEST BEQ8 IMMED\$00"
title_beq8_immediate_far_str: .text @"TEST BEQ8 IMMED FAR\$00"

title_blt8_immediate_str: .text @"TEST BLT8 IMMED\$00"
title_blt8_immediate_far_str: .text @"TEST BLT8 IMMED FAR\$00"

title_ble8_immediate_str: .text @"TEST BLE8 IMMED\$00"
title_ble8_immediate_far_str: .text @"TEST BLE8 IMMED FAR\$00"


title_bgt8_immediate_str: .text @"TEST BGT8 IMMED\$00"
title_bgt8_immediate_far_str: .text @"TEST BGT8 IMMED FAR\$00"

title_bge8_immediate_str: .text @"TEST BGE8 IMMED\$00"
title_bge8_immediate_far_str: .text @"TEST BGE8 IMMED FAR\$00"

title_bne8_immediate_str: .text @"TEST BNE8 IMMED\$00"
title_bne8_immediate_far_str: .text @"TEST BNE8 IMMED FAR\$00"

hit_anykey_str: .text @"HIT ANY KEY ...\$00"

space_str: .text @" \$00"
passed_str: .text @" PASSED\$00"
failed_str: .text @" FAILED\$00"
//passed_str: .text @" \$1EPASSED\$05\$00"
//failed_str: .text @" \$1CFAILED\$05\$00"

fail_control_str: nv_screen_red_fg_str()
pass_control_str: nv_screen_green_fg_str()
normal_control_str: nv_screen_white_fg_str()


opSmall: .byte $05
opBig:   .byte $58

opBE: .byte $be
opEF: .byte $ef

opZero: .byte $00
opMax: .byte $ff
opOne: .byte $01
opTwo: .byte $02
opHighOnes: .byte $F0
opLowOnes: .byte $0F

// byte that gets set to 0 for fail or non zero for pass during every test
passed: .byte 0


*=$1000 "Main Start"

.var row = 0
    nv_screen_print_str(normal_control_str)
    nv_screen_clear()
    nv_screen_plot_cursor(row++, 25)
    nv_screen_print_str(title_str)

    .var use_far = false
    test_beq8_immediate(0, use_far)
    .eval use_far = true
    test_beq8_immediate(0, use_far)

    .eval use_far = false
    test_blt8_immediate(0, use_far)
    .eval use_far = true
    test_blt8_immediate(0, use_far)

    .eval use_far = false
    test_ble8_immediate(0, use_far)
    .eval use_far = true
    test_ble8_immediate(0, use_far)

    .eval use_far = false
    test_bgt8_immediate(0, use_far)
    .eval use_far = true
    test_bgt8_immediate(0, use_far)

    .eval use_far = false
    test_bge8_immediate(0, use_far)
    .eval use_far = true
    test_bge8_immediate(0, use_far)

/*    
    test_ble16(0)
    test_bgt16(0)
    test_bge16(0)
*/
    rts


//////////////////////////////////////////////////////////////////////////////
//
.macro test_beq8_immediate(init_row, use_far)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    .if (use_far)
    {
        nv_screen_print_str(title_beq8_immediate_far_str)
    }
    else
    {
        nv_screen_print_str(title_beq8_immediate_str)
    }
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immediate(opBE, $BE, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immediate(opSmall, $58, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immediate(opBig, $05, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immediate(opSmall, $05, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immediate(opTwo, $01, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immediate(opOne, $00, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immediate(opOne, $FF, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immediate(opZero, $FF, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immediate(opZero, $01, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immediate(opMax, $01, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immediate(opMax, $00, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immediate(opMax, $FF, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immediate(opOne, $01, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immediate(opZero, $00, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immediate(opHighOnes, $0F, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immediate(opLowOnes, $F0, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immediate(opHighOnes, $F0, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immediate(opLowOnes, $0F, use_far, true)

    wait_and_clear_at_row(row)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_blt8_immediate(init_row, use_far)
{
    .var row = init_row
        
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    .if (use_far)
    {
        nv_screen_print_str(title_blt8_immediate_far_str)
    }
    else
    {
        nv_screen_print_str(title_blt8_immediate_str)
    }



    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immediate(opBE, $BE, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immediate(opSmall, $58, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immediate(opBig, $05, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immediate(opSmall, $05, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immediate(opTwo, $01, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immediate(opOne, $00, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immediate(opOne, $FF, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immediate(opZero, $FF, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immediate(opZero, $01, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immediate(opMax, $01, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immediate(opMax, $00, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immediate(opMax, $FF, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immediate(opOne, $01, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immediate(opZero, $00, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immediate(opHighOnes, $0F, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immediate(opLowOnes, $F0, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immediate(opHighOnes, $F0, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immediate(opLowOnes, $0F, use_far, false)

    wait_and_clear_at_row(row)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_ble8_immediate(init_row, use_far)
{
    .var row = init_row
        
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    .if (use_far)
    {
        nv_screen_print_str(title_ble8_immediate_far_str)
    }
    else
    {
        nv_screen_print_str(title_ble8_immediate_str)
    }

    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immediate(opBE, $BE, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immediate(opSmall, $58, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immediate(opBig, $05, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immediate(opSmall, $05, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immediate(opTwo, $01, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immediate(opOne, $00, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immediate(opOne, $FF, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immediate(opZero, $FF, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immediate(opZero, $01, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immediate(opMax, $01, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immediate(opMax, $00, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immediate(opMax, $FF, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immediate(opOne, $01, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immediate(opZero, $00, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immediate(opHighOnes, $0F, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immediate(opLowOnes, $F0, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immediate(opHighOnes, $F0, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immediate(opLowOnes, $0F, use_far, true)

    wait_and_clear_at_row(row)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_bgt8_immediate(init_row, use_far)
{
    .var row = init_row
        
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    .if (use_far)
    {
        nv_screen_print_str(title_bgt8_immediate_far_str)
    }
    else
    {
        nv_screen_print_str(title_bgt8_immediate_str)
    }



    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immediate(opBE, $BE, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immediate(opSmall, $58, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immediate(opBig, $05, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immediate(opSmall, $05, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immediate(opTwo, $01, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immediate(opOne, $00, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immediate(opOne, $FF, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immediate(opZero, $FF, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immediate(opZero, $01, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immediate(opMax, $01, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immediate(opMax, $00, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immediate(opMax, $FF, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immediate(opOne, $01, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immediate(opZero, $00, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immediate(opHighOnes, $0F, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immediate(opLowOnes, $F0, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immediate(opHighOnes, $F0, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immediate(opLowOnes, $0F, use_far, false)

    wait_and_clear_at_row(row)
}

//////////////////////////////////////////////////////////////////////////////
//
.macro test_bge8_immediate(init_row, use_far)
{
    .var row = init_row
        
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    .if (use_far)
    {
        nv_screen_print_str(title_bge8_immediate_far_str)
    }
    else
    {
        nv_screen_print_str(title_bge8_immediate_str)
    }

    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immediate(opBE, $BE, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immediate(opSmall, $58, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immediate(opBig, $05, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immediate(opSmall, $05, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immediate(opTwo, $01, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immediate(opOne, $00, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immediate(opOne, $FF, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immediate(opZero, $FF, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immediate(opZero, $01, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immediate(opMax, $01, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immediate(opMax, $00, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immediate(opMax, $FF, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immediate(opOne, $01, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immediate(opZero, $00, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immediate(opHighOnes, $0F, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immediate(opLowOnes, $F0, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immediate(opHighOnes, $F0, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immediate(opLowOnes, $0F, use_far, true)

    wait_and_clear_at_row(row)
}




/*

.macro test_ble16(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_ble16_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(op1Beef, op2Beef)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opSmall, opBig)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opBig, opSmall)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opSmall, opSmall)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opBig, opSmall)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opTwo, opOne)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opOne, opZero)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opOne, opMax)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opZero, opMax)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opZero, opOne)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opMax, opOne)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opMax, opZero)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opMax, opMax)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opOne, opOne)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opZero, opZero)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opHighOnes, opLowOnes)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opLowOnes, opHighOnes)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opHighOnes, opHighOnes)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opLowOnes, opLowOnes)

    wait_and_clear_at_row(row)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_bgt16(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_bgt16_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(op1Beef, op2Beef)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opSmall, opBig)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opBig, opSmall)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opSmall, opSmall)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opBig, opSmall)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opTwo, opOne)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opOne, opZero)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opOne, opMax)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opZero, opMax)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opZero, opOne)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opMax, opOne)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opMax, opZero)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opMax, opMax)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opOne, opOne)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opZero, opZero)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opHighOnes, opLowOnes)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opLowOnes, opHighOnes)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opHighOnes, opHighOnes)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opLowOnes, opLowOnes)

    wait_and_clear_at_row(row)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_bge16(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_bge16_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(op1Beef, op2Beef)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opSmall, opBig)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opBig, opSmall)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opSmall, opSmall)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opBig, opSmall)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opTwo, opOne)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opOne, opZero)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opOne, opMax)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opZero, opMax)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opZero, opOne)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opMax, opOne)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opMax, opZero)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opMax, opMax)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opOne, opOne)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opZero, opZero)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opHighOnes, opLowOnes)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opLowOnes, opHighOnes)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opHighOnes, opHighOnes)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opLowOnes, opLowOnes)

    wait_and_clear_at_row(row)
}
*/


/////////////////////////////////////////////////////////////////////////////
// wait for key then clear screen when its detected
.macro wait_and_clear_at_row(init_row)
{
    .var row = init_row
    .eval row++
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(hit_anykey_str)

    nv_key_wait_any_key()

    nv_screen_clear()
    .eval row=0
    nv_screen_plot_cursor(row++, 25)
    nv_screen_print_str(title_str)
}

//////////////////////////////////////////////////////////////////////////////
//                          Print macros 
//////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either = or != ) 
// for the relationship of the two word in memorys.  Use beq16 to do it.
//   addr1: is the address of LSB of one word (addr1+1 is MSB)
//   addr2: is the address of LSB of the other word (addr2+1 is MSB)
.macro print_beq8_immediate(addr1, num, use_far, expect_to_branch)
{
    lda #1
    sta passed
    lda addr1
    jsr PrintHexByteAccum
    .if (use_far)
    {
        nv_beq8_immediate_far(addr1, num, Same)
    }
    else
    {
        nv_beq8_immediate(addr1, num, Same)
    }
    nv_screen_print_str(not_equal_str)
    .if (expect_to_branch)
    {   // expected to branch, but didn't branch
        lda #$00
        sta passed
    }
    jmp Done
    .if (use_far)
    {
        // nops to make sure more than 128 bytes between branch and target label
        .var index = 0
        .for(index = 0; index < 124; index = index + 1) {nop}
    }
Same:
    nv_screen_print_str(equal_str)
    .if (expect_to_branch == false)
    {   // didn't expect to branch, but did branch
        lda #$00
        sta passed
    }
Done:
    lda #num
    jsr PrintHexByteAccum

    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either <= or > ) 
// for the relationship of one byte in memory and an immediate value
// 8 bit value.  Uses the macros nv_ble8_immediate and   
// nv_ble8_immediate_far to do it.
// macro params
//   addr1: is the address of byte1
//   num: is the immediate 8 bit value
//   use_far: pass true to use the var version of nv_blt
//   expect_to_branch: pass true if the expected outcome is
//                     to branch or false if not.  pass/fail 
//                     based on this.
.macro print_ble8_immediate(addr1, num, use_far, expect_to_branch)
{
    lda #1
    sta passed
    lda addr1
    jsr PrintHexByteAccum
    .if (use_far)
    {
        nv_ble8_immediate_far(addr1, num, BranchTarget)
    }
    else
    {
        nv_ble8_immediate(addr1, num, BranchTarget)
    }
    nv_screen_print_str(greater_than_str)
    .if (expect_to_branch == true)
    {   // expected to branch, but did not branch
        lda #$00
        sta passed
    }

    jmp Done
    .if (use_far)
    {
        // nops to make sure more than 128 bytes between branch and target label
        .var index = 0
        .for(index = 0; index < 124; index = index + 1) {nop}
    }

BranchTarget:
    .if (expect_to_branch == false)
    {   // didn't expect to branch, but did branch
        lda #$00
        sta passed
    }
    nv_screen_print_str(less_equal_str)

Done:
    lda #num
    jsr PrintHexByteAccum

    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either >= or < ) 
// for the relationship of one byte in memory and an immediate value
// 8 bit value.  Uses the macros nv_bge8_immediate and   
// nv_bge8_immediate_far to do it.
// macro params
//   addr1: is the address of byte1
//   num: is the immediate 8 bit value
//   use_far: pass true to use the var version of nv_blt
//   expect_to_branch: pass true if the expected outcome is
//                     to branch or false if not.  pass/fail 
//                     based on this.
.macro print_bge8_immediate(addr1, num, use_far, expect_to_branch)
{
    lda #1
    sta passed
    lda addr1
    jsr PrintHexByteAccum
    .if (use_far)
    {
        nv_bge8_immediate_far(addr1, num, BranchTarget)
    }
    else
    {
        nv_bge8_immediate(addr1, num, BranchTarget)
    }
    nv_screen_print_str(less_than_str)
    .if (expect_to_branch == true)
    {   // expected to branch, but did not branch
        lda #$00
        sta passed
    }

    jmp Done
    .if (use_far)
    {
        // nops to make sure more than 128 bytes between branch and target label
        .var index = 0
        .for(index = 0; index < 124; index = index + 1) {nop}
    }

BranchTarget:
    .if (expect_to_branch == false)
    {   // didn't expect to branch, but did branch
        lda #$00
        sta passed
    }
    nv_screen_print_str(greater_equal_str)

Done:
    lda #num
    jsr PrintHexByteAccum

    jsr PrintPassed
}




//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either < or >= ) 
// for the relationship of the one byte in memory and an immediate 
// 8 bit value.  Use nv_blt8_immediate or nv_blt8_immediate_far to do it.
// macro params
//   addr1: is the address of byte1
//   num: is the immediate value
//   use_far: pass true to use the var version of nv_blt
//   expect_to_branch: pass true if the expected outcome is
//                     to branch or false if not.  pass/fail 
//                     based on this.
.macro print_blt8_immediate(addr1, num, use_far, expect_to_branch)
{
    lda #1
    sta passed
    lda addr1
    jsr PrintHexByteAccum
    .if (use_far)
    {
        nv_blt8_immediate_far(addr1, num, LessThan)
    }
    else
    {
        nv_blt8_immediate(addr1, num, LessThan)
    }
    nv_screen_print_str(greater_equal_str)
    .if (expect_to_branch == true)
    {   // expected to branch, but did not branch
        lda #$00
        sta passed
    }

    jmp Done
    .if (use_far)
    {
        // nops to make sure more than 128 bytes between branch and target label
        .var index = 0
        .for(index = 0; index < 124; index = index + 1) {nop}
    }

LessThan:
    .if (expect_to_branch == false)
    {   // didn't expect to branch, but did branch
        lda #$00
        sta passed
    }
    nv_screen_print_str(less_than_str)

Done:
    lda #num
    jsr PrintHexByteAccum
    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either < or >= ) 
// for the relationship of the one byte in memory and an immediate 
// 8 bit value.  Use nv_blt8_immediate or nv_blt8_immediate_far to do it.
// macro params
//   addr1: is the address of byte1
//   num: is the immediate value
//   use_far: pass true to use the var version of nv_blt
//   expect_to_branch: pass true if the expected outcome is
//                     to branch or false if not.  pass/fail 
//                     based on this.
.macro print_bgt8_immediate(addr1, num, use_far, expect_to_branch)
{
    lda #1
    sta passed
    lda addr1
    jsr PrintHexByteAccum
    .if (use_far)
    {
        nv_bgt8_immediate_far(addr1, num, BranchTarget)
    }
    else
    {
        nv_bgt8_immediate(addr1, num, BranchTarget)
    }
    nv_screen_print_str(less_equal_str)
    .if (expect_to_branch == true)
    {   // expected to branch, but did not branch
        lda #$00
        sta passed
    }

    jmp Done
    .if (use_far)
    {
        // nops to make sure more than 128 bytes between branch and target label
        .var index = 0
        .for(index = 0; index < 124; index = index + 1) {nop}
    }

BranchTarget:
    .if (expect_to_branch == false)
    {   // didn't expect to branch, but did branch
        lda #$00
        sta passed
    }
    nv_screen_print_str(greater_than_str)

Done:
    lda #num
    jsr PrintHexByteAccum
    jsr PrintPassed
}


/*

//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either <= or >)
// for the relationship of the two word in memorys.  Use ble16 to do it.
//   addr1: is the address of LSB of word1 (addr1+1 is MSB)
//   addr2: is the address of LSB of word2 (addr2+1 is MSB)
.macro print_ble16(addr1, addr2)
{
    nv_screen_print_hex_word_mem(addr1, true)
    nv_ble16(addr1, addr2, LessThanEqual)
    nv_screen_print_str(greater_than_str)
    jmp Done
LessThanEqual:
    nv_screen_print_str(less_equal_str)

Done:
    nv_screen_print_hex_word_mem(addr2, true)
}


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either > or <= ) 
// for the relationship of the two word in memorys.  Use bgt16 to do it.
//   addr1: is the address of LSB of word1 (addr1+1 is MSB)
//   addr2: is the address of LSB of word2 (addr2+1 is MSB)
.macro print_bgt16(addr1, addr2)
{
    nv_screen_print_hex_word_mem(addr1, true)
    nv_bgt16(addr1, addr2, GreaterThan)
    nv_screen_print_str(less_equal_str)
    jmp Done
GreaterThan:
    nv_screen_print_str(greater_than_str)

Done:
    nv_screen_print_hex_word_mem(addr2, true)
}


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either >= or <)
// for the relationship of the two word in memorys.  Use bge16 to do it.
//   addr1: is the address of LSB of word1 (addr1+1 is MSB)
//   addr2: is the address of LSB of word2 (addr2+1 is MSB)
.macro print_bge16(addr1, addr2)
{
    nv_screen_print_hex_word_mem(addr1, true)
    nv_bge16(addr1, addr2, GreaterThanEqual)
    nv_screen_print_str(less_than_str)
    jmp Done
GreaterThanEqual:
    nv_screen_print_str(greater_equal_str)

Done:
    nv_screen_print_hex_word_mem(addr2, true)
}


//////////////////////////////////////////////////////////////////////////////
.macro print_blt16_immediate(addr1, num)
{
    nv_screen_print_hex_word_mem(addr1, true)
    nv_blt16_immediate(addr1, num, LessThan)
    nv_screen_print_str(greater_equal_str)
    jmp Done
LessThan:
    nv_screen_print_str(less_than_str)

Done:
    nv_screen_print_hex_word_immed(num, true)

}


//////////////////////////////////////////////////////////////////////////////
.macro print_ble16_immediate(addr1, num)
{
    nv_screen_print_hex_word_mem(addr1, true)
    nv_ble16_immediate(addr1, num, LessEqual)
    nv_screen_print_str(greater_than_str)
    jmp Done
LessEqual:
    nv_screen_print_str(less_equal_str)

Done:
    nv_screen_print_hex_word_immed(num, true)

}

//////////////////////////////////////////////////////////////////////////////
.macro print_bgt16_immediate(addr1, num)
{
    nv_screen_print_hex_word_mem(addr1, true)
    nv_bgt16_immediate(addr1, num, GreaterThan)
    nv_screen_print_str(less_equal_str)
    jmp Done
GreaterThan:
    nv_screen_print_str(greater_than_str)

Done:
    nv_screen_print_hex_word_immed(num, true)
}


//////////////////////////////////////////////////////////////////////////////
.macro print_bge16_immediate(addr1, num)
{
    nv_screen_print_hex_word_mem(addr1, true)
    nv_bge16_immediate(addr1, num, GreaterEqual)
    nv_screen_print_str(less_than_str)
    jmp Done
GreaterEqual:
    nv_screen_print_str(greater_equal_str)

Done:
    nv_screen_print_hex_word_immed(num, true)
}
*/


PrintHexByteAccum:
{
    nv_screen_print_hex_byte_a(true)
    rts
}


PrintPassed:
{
    nv_screen_print_str(space_str)
    lda passed
    bne PrintPassed
PrintFailed:
    nv_screen_print_str(fail_control_str)
    nv_screen_print_str(failed_str)
    jmp Done

PrintPassed:
    nv_screen_print_str(pass_control_str)
    nv_screen_print_str(passed_str)

Done:
    nv_screen_print_str(normal_control_str)
    rts
}