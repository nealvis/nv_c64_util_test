//////////////////////////////////////////////////////////////////////////////
// branch8_immed_mem_test.asm
// Copyright(c) 2021 Neal Smith.
// License: MIT. See LICENSE file in root directory.
//////////////////////////////////////////////////////////////////////////////
// This program demonstrates and tests the 8bit immediate branch operations 
// in nv_branch8_macs.asm that use an immediate value and a mem addr as 
// operands

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

title_str: .text @"BRANCH8 IMMED MEM\$00"          // null terminated string to print
                                        // via the BASIC routine
title_beq8_immed_str: .text @"TEST BEQ8 IMMED\$00"
title_beq8_immed_far_str: .text @"TEST BEQ8 IMMED FAR\$00"

title_blt8_immed_str: .text @"TEST BLT8 IMMED\$00"
title_blt8_immed_far_str: .text @"TEST BLT8 IMMED FAR\$00"

title_ble8_immed_str: .text @"TEST BLE8 IMMED\$00"
title_ble8_immed_far_str: .text @"TEST BLE8 IMMED FAR\$00"


title_bgt8_immed_str: .text @"TEST BGT8 IMMED\$00"
title_bgt8_immed_far_str: .text @"TEST BGT8 IMMED FAR\$00"

title_bge8_immed_str: .text @"TEST BGE8 IMMED\$00"
title_bge8_immed_far_str: .text @"TEST BGE8 IMMED FAR\$00"

title_bne8_immed_str: .text @"TEST BNE8 IMMED\$00"
title_bne8_immed_far_str: .text @"TEST BNE8 IMMED FAR\$00"

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


*=$1000 "Main Start"

.var row = 0
    nv_screen_print_str(normal_control_str)
    nv_screen_clear()
    nv_screen_plot_cursor(row++, 23)
    nv_screen_print_str(title_str)

    .var use_far = false
    test_beq8_immed(0, use_far)
    .eval use_far = true
    test_beq8_immed(0, use_far)

    .eval use_far = false
    test_bne8_immed(0, use_far)
    .eval use_far = true
    test_bne8_immed(0, use_far)

    .eval use_far = false
    test_blt8_immed(0, use_far)
    .eval use_far = true
    test_blt8_immed(0, use_far)

    .eval use_far = false
    test_ble8_immed(0, use_far)
    .eval use_far = true
    test_ble8_immed(0, use_far)

    .eval use_far = false
    test_bgt8_immed(0, use_far)
    .eval use_far = true
    test_bgt8_immed(0, use_far)

    .eval use_far = false
    test_bge8_immed(0, use_far)
    .eval use_far = true
    test_bge8_immed(0, use_far)

/*    
    test_ble16(0)
    test_bgt16(0)
    test_bge16(0)
*/
    rts


//////////////////////////////////////////////////////////////////////////////
//
.macro test_beq8_immed(init_row, use_far)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    .if (use_far)
    {
        nv_screen_print_str(title_beq8_immed_far_str)
    }
    else
    {
        nv_screen_print_str(title_beq8_immed_str)
    }
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immed(opSmall, $58, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immed(opBig, $05, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immed(opSmall, $05, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immed(opTwo, $01, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immed(opOne, $00, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immed(opOne, $FF, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immed(opZero, $FF, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immed(opZero, $01, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immed(opMax, $01, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immed(opMax, $00, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immed(opMax, $FF, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immed(opOne, $01, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immed(opZero, $00, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immed(opHighOnes, $0F, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immed(opLowOnes, $F0, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immed(opHighOnes, $F0, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_immed(opLowOnes, $0F, use_far, true)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_bne8_immed(init_row, use_far)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    .if (use_far)
    {
        nv_screen_print_str(title_bne8_immed_far_str)
    }
    else
    {
        nv_screen_print_str(title_bne8_immed_str)
    }
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_immed(opSmall, $58, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_immed(opBig, $05, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_immed(opSmall, $05, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_immed(opTwo, $01, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_immed(opOne, $00, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_immed(opOne, $FF, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_immed(opZero, $FF, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_immed(opZero, $01, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_immed(opMax, $01, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_immed(opMax, $00, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_immed(opMax, $FF, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_immed(opOne, $01, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_immed(opZero, $00, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_immed(opHighOnes, $0F, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_immed(opLowOnes, $F0, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_immed(opHighOnes, $F0, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_immed(opLowOnes, $0F, use_far, false)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_blt8_immed(init_row, use_far)
{
    .var row = init_row
        
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    .if (use_far)
    {
        nv_screen_print_str(title_blt8_immed_far_str)
    }
    else
    {
        nv_screen_print_str(title_blt8_immed_str)
    }



    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immed(opSmall, $58, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immed(opBig, $05, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immed(opSmall, $05, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immed(opTwo, $01, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immed(opOne, $00, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immed(opOne, $FF, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immed(opZero, $FF, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immed(opZero, $01, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immed(opMax, $01, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immed(opMax, $00, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immed(opMax, $FF, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immed(opOne, $01, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immed(opZero, $00, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immed(opHighOnes, $0F, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immed(opLowOnes, $F0, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immed(opHighOnes, $F0, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_immed(opLowOnes, $0F, use_far, false)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_ble8_immed(init_row, use_far)
{
    .var row = init_row
        
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    .if (use_far)
    {
        nv_screen_print_str(title_ble8_immed_far_str)
    }
    else
    {
        nv_screen_print_str(title_ble8_immed_str)
    }

    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immed(opSmall, $58, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immed(opBig, $05, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immed(opSmall, $05, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immed(opTwo, $01, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immed(opOne, $00, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immed(opOne, $FF, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immed(opZero, $FF, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immed(opZero, $01, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immed(opMax, $01, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immed(opMax, $00, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immed(opMax, $FF, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immed(opOne, $01, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immed(opZero, $00, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immed(opHighOnes, $0F, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immed(opLowOnes, $F0, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immed(opHighOnes, $F0, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_immed(opLowOnes, $0F, use_far, true)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_bgt8_immed(init_row, use_far)
{
    .var row = init_row
        
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    .if (use_far)
    {
        nv_screen_print_str(title_bgt8_immed_far_str)
    }
    else
    {
        nv_screen_print_str(title_bgt8_immed_str)
    }



    //////////////////////////////////////////////////////////////////////////
    .eval row++


    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immed(opSmall, $58, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immed(opBig, $05, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immed(opSmall, $05, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immed(opTwo, $01, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immed(opOne, $00, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immed(opOne, $FF, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immed(opZero, $FF, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immed(opZero, $01, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immed(opMax, $01, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immed(opMax, $00, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immed(opMax, $FF, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immed(opOne, $01, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immed(opZero, $00, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immed(opHighOnes, $0F, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immed(opLowOnes, $F0, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immed(opHighOnes, $F0, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_immed(opLowOnes, $0F, use_far, false)

    wait_and_clear_at_row(row, title_str)
}

//////////////////////////////////////////////////////////////////////////////
//
.macro test_bge8_immed(init_row, use_far)
{
    .var row = init_row
        
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    .if (use_far)
    {
        nv_screen_print_str(title_bge8_immed_far_str)
    }
    else
    {
        nv_screen_print_str(title_bge8_immed_str)
    }

    //////////////////////////////////////////////////////////////////////////
    .eval row++


    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immed(opSmall, $58, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immed(opBig, $05, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immed(opSmall, $05, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immed(opTwo, $01, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immed(opOne, $00, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immed(opOne, $FF, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immed(opZero, $FF, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immed(opZero, $01, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immed(opMax, $01, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immed(opMax, $00, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immed(opMax, $FF, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immed(opOne, $01, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immed(opZero, $00, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immed(opHighOnes, $0F, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immed(opLowOnes, $F0, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immed(opHighOnes, $F0, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_immed(opLowOnes, $0F, use_far, true)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//                          Print macros 
//////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either = or != ) 
// for the relationship of the two word in memorys.  Use beq16 to do it.
//   addr1: is the address of LSB of one word (addr1+1 is MSB)
//   addr2: is the address of LSB of the other word (addr2+1 is MSB)
.macro print_beq8_immed(addr1, num, use_far, expect_to_branch)
{
    lda #1
    sta passed
    lda addr1
    jsr PrintHexByteAccum
    .if (use_far)
    {
        nv_beq8_immed_far(addr1, num, Same)
    }
    else
    {
        nv_beq8_immed(addr1, num, Same)
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
// Print to current screen location the expression (either != or = ) 
// for the relationship of the two bytes in memory.  Use nv_bne8 to do it.
//   addr1: is the address of byte1
//   addr2: is the address of byte2
.macro print_bne8_immed(addr1, num, use_far, expect_to_branch)
{
    lda #1
    sta passed
    lda addr1
    jsr PrintHexByteAccum
    .if (use_far)
    {
        nv_bne8_immed_far(addr1, num, BranchTarget)
    }
    else
    {
        nv_bne8_immed(addr1, num, BranchTarget)
    }
    nv_screen_print_str(equal_str)
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
BranchTarget:
    nv_screen_print_str(not_equal_str)
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
// 8 bit value.  Uses the macros nv_ble8_immed and   
// nv_ble8_immed_far to do it.
// macro params
//   addr1: is the address of byte1
//   num: is the immediate 8 bit value
//   use_far: pass true to use the var version of nv_blt
//   expect_to_branch: pass true if the expected outcome is
//                     to branch or false if not.  pass/fail 
//                     based on this.
.macro print_ble8_immed(addr1, num, use_far, expect_to_branch)
{
    lda #1
    sta passed
    lda addr1
    jsr PrintHexByteAccum
    .if (use_far)
    {
        nv_ble8_immed_far(addr1, num, BranchTarget)
    }
    else
    {
        nv_ble8_immed(addr1, num, BranchTarget)
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
// 8 bit value.  Uses the macros nv_bge8_immed and   
// nv_bge8_immed_far to do it.
// macro params
//   addr1: is the address of byte1
//   num: is the immediate 8 bit value
//   use_far: pass true to use the var version of nv_blt
//   expect_to_branch: pass true if the expected outcome is
//                     to branch or false if not.  pass/fail 
//                     based on this.
.macro print_bge8_immed(addr1, num, use_far, expect_to_branch)
{
    lda #1
    sta passed
    lda addr1
    jsr PrintHexByteAccum
    .if (use_far)
    {
        nv_bge8_immed_far(addr1, num, BranchTarget)
    }
    else
    {
        nv_bge8_immed(addr1, num, BranchTarget)
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
// 8 bit value.  Use nv_blt8_immed or nv_blt8_immed_far to do it.
// macro params
//   addr1: is the address of byte1
//   num: is the immediate value
//   use_far: pass true to use the var version of nv_blt
//   expect_to_branch: pass true if the expected outcome is
//                     to branch or false if not.  pass/fail 
//                     based on this.
.macro print_blt8_immed(addr1, num, use_far, expect_to_branch)
{
    lda #1
    sta passed
    lda addr1
    jsr PrintHexByteAccum
    .if (use_far)
    {
        nv_blt8_immed_far(addr1, num, LessThan)
    }
    else
    {
        nv_blt8_immed(addr1, num, LessThan)
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
// 8 bit value.  Use nv_blt8_immed or nv_blt8_immed_far to do it.
// macro params
//   addr1: is the address of byte1
//   num: is the immediate value
//   use_far: pass true to use the var version of nv_blt
//   expect_to_branch: pass true if the expected outcome is
//                     to branch or false if not.  pass/fail 
//                     based on this.
.macro print_bgt8_immed(addr1, num, use_far, expect_to_branch)
{
    lda #1
    sta passed
    lda addr1
    jsr PrintHexByteAccum
    .if (use_far)
    {
        nv_bgt8_immed_far(addr1, num, BranchTarget)
    }
    else
    {
        nv_bgt8_immed(addr1, num, BranchTarget)
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

#import "../test_util/test_util_code.asm"
