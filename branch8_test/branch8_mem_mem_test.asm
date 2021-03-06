//////////////////////////////////////////////////////////////////////////////
// branch8_mem_mem_test.asm
// Copyright(c) 2021 Neal Smith.
// License: MIT. See LICENSE file in root directory.
//////////////////////////////////////////////////////////////////////////////
// This program demonstrates and tests the 8bit branch operations 
// in nv_branch8_macs.asm that use two memory addrs as the operands

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

title_str: .text @"BRANCH8 MEM MEM\$00"          // null terminated string to print
                                        // via the BASIC routine
title_beq8_str: .text @"TEST BEQ8\$00"
title_beq8_far_str: .text @"TEST BEQ8 FAR\$00"
title_beq8_immediate_str: .text @"TEST BEQ8 IMMED\$00"
title_beq8_immediate_far_str: .text @"TEST BEQ8 IMMED FAR\$00"

title_blt8_str: .text @"TEST BLT8\$00"
title_blt8_far_str: .text @"TEST BLT8 FAR\$00"

title_ble8_str: .text @"TEST BLE8\$00"
title_ble8_far_str: .text @"TEST BLE8 FAR\$00"

title_bgt8_str: .text @"TEST BGT8\$00"
title_bgt8_far_str: .text @"TEST BGT8 FAR\$00"

title_bge8_str: .text @"TEST BGE8\$00"
title_bge8_far_str: .text @"TEST BGE8 FAR\$00"

title_bne8_str: .text @"TEST BNE8\$00"
title_bne8_far_str: .text @"TEST BNE8 FAR\$00"

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
    nv_screen_plot_cursor(row++, 24)
    nv_screen_print_str(title_str)

    .var use_far = false
    test_beq8(0, use_far)
    .eval use_far = true
    test_beq8(0, use_far)

    .eval use_far = false
    test_bne8(0, use_far)
    .eval use_far = true
    test_bne8(0, use_far)


    .eval use_far = false
    test_blt8(0, use_far)
    .eval use_far = true
    test_blt8(0, use_far)

    .eval use_far = false
    test_ble8(0, use_far)
    .eval use_far = true
    test_ble8(0, use_far)

    .eval use_far = false
    test_bgt8(0, use_far)
    .eval use_far = true
    test_bgt8(0, use_far)

    .eval use_far = false
    test_bge8(0, use_far)
    .eval use_far = true
    test_bge8(0, use_far)


    rts



//////////////////////////////////////////////////////////////////////////////
//
.macro test_beq8(init_row, use_far)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    .if (use_far)
    {
        nv_screen_print_str(title_beq8_far_str)
    }
    else
    {
        nv_screen_print_str(title_beq8_str)
    }
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8(opSmall, opBig, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8(opBig, opSmall, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8(opSmall, opSmall, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8(opTwo, opOne, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8(opOne, opZero, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8(opOne, opMax, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8(opZero, opMax, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8(opZero, opOne, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8(opMax, opOne, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8(opMax, opZero, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8(opMax, opMax, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8(opOne, opOne, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8(opZero, opZero, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8(opHighOnes, opLowOnes, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8(opLowOnes, opHighOnes, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8(opHighOnes, opHighOnes, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8(opLowOnes, opLowOnes, use_far, true)

    wait_and_clear_at_row(row, title_str)
}

//////////////////////////////////////////////////////////////////////////////
//
.macro test_bne8(init_row, use_far)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    .if (use_far)
    {
        nv_screen_print_str(title_bne8_far_str)
    }
    else
    {
        nv_screen_print_str(title_bne8_str)
    }
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8(opSmall, opBig, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8(opBig, opSmall, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8(opSmall, opSmall, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8(opTwo, opOne, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8(opOne, opZero, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8(opOne, opMax, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8(opZero, opMax, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8(opZero, opOne, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8(opMax, opOne, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8(opMax, opZero, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8(opMax, opMax, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8(opOne, opOne, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8(opZero, opZero, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8(opHighOnes, opLowOnes, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8(opLowOnes, opHighOnes, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8(opHighOnes, opHighOnes, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8(opLowOnes, opLowOnes, use_far, false)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_blt8(init_row, use_far)
{
    .var row = init_row
        
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    .if (use_far)
    {
        nv_screen_print_str(title_blt8_far_str)
    }
    else
    {
        nv_screen_print_str(title_blt8_str)
    }



    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8(opSmall, opBig, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8(opBig, opSmall, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8(opSmall, opSmall, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8(opTwo, opOne, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8(opOne, opZero, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8(opOne, opMax, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8(opZero, opMax, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8(opZero, opOne, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8(opMax, opOne, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8(opMax, opZero, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8(opMax, opMax, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8(opOne, opOne, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8(opZero, opZero, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8(opHighOnes, opLowOnes, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8(opLowOnes, opHighOnes, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8(opHighOnes, opHighOnes, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8(opLowOnes, opLowOnes, use_far, false)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_ble8(init_row, use_far)
{
    .var row = init_row
        
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    .if (use_far)
    {
        nv_screen_print_str(title_ble8_far_str)
    }
    else
    {
        nv_screen_print_str(title_ble8_str)
    }



    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8(opSmall, opBig, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8(opBig, opSmall, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8(opSmall, opSmall, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8(opTwo, opOne, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8(opOne, opZero, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8(opOne, opMax, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8(opZero, opMax, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8(opZero, opOne, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8(opMax, opOne, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8(opMax, opZero, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8(opMax, opMax, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8(opOne, opOne, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8(opZero, opZero, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8(opHighOnes, opLowOnes, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8(opLowOnes, opHighOnes, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8(opHighOnes, opHighOnes, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8(opLowOnes, opLowOnes, use_far, true)

    wait_and_clear_at_row(row, title_str)
}

//////////////////////////////////////////////////////////////////////////////
//
.macro test_bgt8(init_row, use_far)
{
    .var row = init_row
        
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    .if (use_far)
    {
        nv_screen_print_str(title_bgt8_far_str)
    }
    else
    {
        nv_screen_print_str(title_bgt8_str)
    }



    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8(opSmall, opBig, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8(opBig, opSmall, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8(opSmall, opSmall, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8(opTwo, opOne, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8(opOne, opZero, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8(opOne, opMax, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8(opZero, opMax, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8(opZero, opOne, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8(opMax, opOne, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8(opMax, opZero, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8(opMax, opMax, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8(opOne, opOne, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8(opZero, opZero, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8(opHighOnes, opLowOnes, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8(opLowOnes, opHighOnes, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8(opHighOnes, opHighOnes, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8(opLowOnes, opLowOnes, use_far, false)

    wait_and_clear_at_row(row, title_str)
}

//////////////////////////////////////////////////////////////////////////////
//
.macro test_bge8(init_row, use_far)
{
    .var row = init_row
        
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    .if (use_far)
    {
        nv_screen_print_str(title_bge8_far_str)
    }
    else
    {
        nv_screen_print_str(title_bge8_str)
    }



    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8(opSmall, opBig, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8(opBig, opSmall, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8(opSmall, opSmall, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8(opTwo, opOne, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8(opOne, opZero, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8(opOne, opMax, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8(opZero, opMax, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8(opZero, opOne, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8(opMax, opOne, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8(opMax, opZero, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8(opMax, opMax, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8(opOne, opOne, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8(opZero, opZero, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8(opHighOnes, opLowOnes, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8(opLowOnes, opHighOnes, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8(opHighOnes, opHighOnes, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8(opLowOnes, opLowOnes, use_far, true)

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
.macro print_beq8(addr1, addr2, use_far, expect_to_branch)
{
    lda #1
    sta passed
    lda addr1
    jsr PrintHexByteAccum
    .if (use_far)
    {
        nv_beq8_far(addr1, addr2, Same)
    }
    else
    {
        nv_beq8(addr1, addr2, Same)
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
    lda addr2
    jsr PrintHexByteAccum

    jsr PrintPassed
}

//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either != or = ) 
// for the relationship of the two bytes in memorys.  Use nv_bne8 or
// nv_bne8_far to do it.
//   addr1: is the address byte1
//   addr2: is the address byte2
.macro print_bne8(addr1, addr2, use_far, expect_to_branch)
{
    lda #1
    sta passed
    lda addr1
    jsr PrintHexByteAccum
    .if (use_far)
    {
        nv_bne8_far(addr1, addr2, Same)
    }
    else
    {
        nv_bne8(addr1, addr2, Same)
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
Same:
    nv_screen_print_str(not_equal_str)
    .if (expect_to_branch == false)
    {   // didn't expect to branch, but did branch
        lda #$00
        sta passed
    }
Done:
    lda addr2
    jsr PrintHexByteAccum

    jsr PrintPassed
}



//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either < or >= ) 
// for the relationship of the two bytes in memory.  Use nv_blt8 or
// nv_blt8_far to do it.
// macro params
//   addr1: is the address of byte1
//   addr2: is the address of byte2
//   use_far: pass true to use the var version of nv_blt
//   expect_to_branch: pass true if the expected outcome is
//                     to branch or false if not.  pass/fail 
//                     based on this.
.macro print_blt8(addr1, addr2, use_far, expect_to_branch)
{
    lda #1
    sta passed
    lda addr1
    jsr PrintHexByteAccum
    .if (use_far)
    {
        nv_blt8_far(addr1, addr2, LessThan)
    }
    else
    {
        nv_blt8(addr1, addr2, LessThan)
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
    lda addr2
    jsr PrintHexByteAccum

    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either <= or > ) 
// for the relationship of the two bytes in memory.  Use nv_ble8 or
// nv_ble8_far to do it.
// macro params
//   addr1: is the address of byte1
//   addr2: is the address of byte2
//   use_far: pass true to use the var version of nv_blt
//   expect_to_branch: pass true if the expected outcome is
//                     to branch or false if not.  pass/fail 
//                     based on this.
.macro print_ble8(addr1, addr2, use_far, expect_to_branch)
{
    lda #1
    sta passed
    lda addr1
    jsr PrintHexByteAccum
    .if (use_far)
    {
        nv_ble8_far(addr1, addr2, BranchTarget)
    }
    else
    {
        nv_ble8(addr1, addr2, BranchTarget)
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
    lda addr2
    jsr PrintHexByteAccum

    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either >= or < ) 
// for the relationship of the two bytes in memory.  Use nv_bge8 or
// nv_bge8_far to do it.
// macro params
//   addr1: is the address of byte1
//   addr2: is the address of byte2
//   use_far: pass true to use the var version of nv_blt
//   expect_to_branch: pass true if the expected outcome is
//                     to branch or false if not.  pass/fail 
//                     based on this.
.macro print_bge8(addr1, addr2, use_far, expect_to_branch)
{
    lda #1
    sta passed
    lda addr1
    jsr PrintHexByteAccum
    .if (use_far)
    {
        nv_bge8_far(addr1, addr2, BranchTarget)
    }
    else
    {
        nv_bge8(addr1, addr2, BranchTarget)
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
    lda addr2
    jsr PrintHexByteAccum

    jsr PrintPassed
}



//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either > or <= ) 
// for the relationship of the two bytes in memory.  Use nv_bgt8 or
// nv_bgt8_far to do it.
// macro params
//   addr1: is the address of byte1
//   addr2: is the address of byte2
//   use_far: pass true to use the var version of nv_blt
//   expect_to_branch: pass true if the expected outcome is
//                     to branch or false if not.  pass/fail 
//                     based on this.
.macro print_bgt8(addr1, addr2, use_far, expect_to_branch)
{
    lda #1
    sta passed
    lda addr1
    jsr PrintHexByteAccum
    .if (use_far)
    {
        nv_bgt8_far(addr1, addr2, BranchTarget)
    }
    else
    {
        nv_bgt8(addr1, addr2, BranchTarget)
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
    lda addr2
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


#import "../test_util/test_util_code.asm"

