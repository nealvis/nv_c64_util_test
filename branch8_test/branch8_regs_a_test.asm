//////////////////////////////////////////////////////////////////////////////
// branch8_regs_a_test.asm
// Copyright(c) 2021 Neal Smith.
// License: MIT. See LICENSE file in root directory.
//////////////////////////////////////////////////////////////////////////////
// This program demonstrates and tests the 8bit branch operations 
// in nv_branch8_macs.asm that use accumulator as an operand

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
        .byte $20, $28, $34, $30, $39, $36, $29 // is " (4096)"
//        .byte $20, $28, $32, $33, $38, $34, $29 // is  " (2384)" aka $0950
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

title_str: .text @"BRANCH8 REGS ACCUM\$00"          // null terminated string to print
                                        // via the BASIC routine
title_beq8_a_str: .text @"TEST BEQ8 A\$00"
title_beq8_a_far_str: .text @"TEST BEQ8 A FAR\$00"

title_blt8_a_str: .text @"TEST BLT8 A\$00"
title_blt8_a_far_str: .text @"TEST BLT8 A FAR\$00"

title_ble8_a_str: .text @"TEST BLE8 A\$00"
title_ble8_a_far_str: .text @"TEST BLE8 A FAR\$00"

title_bgt8_a_str: .text @"TEST BGT8 A\$00"
title_bgt8_a_far_str: .text @"TEST BGT8 A FAR\$00"

title_bge8_a_str: .text @"TEST BGE8 A\$00"
title_bge8_a_far_str: .text @"TEST BGE8 A FAR\$00"

title_bne8_a_str: .text @"TEST BNE8 A\$00"
title_bne8_a_far_str: .text @"TEST BNE8 A FAR\$00"

hit_anykey_str: .text @"HIT ANY KEY ...\$00"

space_str: .text @" \$00"
passed_str: .text @" PASSED\$00"
failed_str: .text @" FAILED\$00"

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
    nv_screen_plot_cursor(row++, 20)
    nv_screen_print_str(title_str)

    .var use_far = false
    test_beq8_a(0, use_far)
    .eval use_far = true
    test_beq8_a(0, use_far)

    .eval use_far = false
    test_bne8_a(0, use_far)
    .eval use_far = true
    test_bne8_a(0, use_far)

    .eval use_far = false
    test_blt8_a(0, use_far)
    .eval use_far = true
    test_blt8_a(0, use_far)

    .eval use_far = false
    test_ble8_a(0, use_far)
    .eval use_far = true
    test_ble8_a(0, use_far)

    .eval use_far = false
    test_bgt8_a(0, use_far)
    .eval use_far = true
    test_bgt8_a(0, use_far)

    .eval use_far = false
    test_bge8_a(0, use_far)
    .eval use_far = true
    test_bge8_a(0, use_far)


    rts



//////////////////////////////////////////////////////////////////////////////
//
.macro test_beq8_a(init_row, use_far)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    .if (use_far)
    {
        nv_screen_print_str(title_beq8_a_far_str)
    }
    else
    {
        nv_screen_print_str(title_beq8_a_str)
    }
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_a(opSmall, opBig, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_a(opBig, opSmall, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_a(opSmall, opSmall, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_a(opTwo, opOne, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_a(opOne, opZero, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_a(opOne, opMax, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_a(opZero, opMax, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_a(opZero, opOne, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_a(opMax, opOne, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_a(opMax, opZero, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_a(opMax, opMax, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_a(opOne, opOne, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_a(opZero, opZero, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_a(opHighOnes, opLowOnes, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_a(opLowOnes, opHighOnes, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_a(opHighOnes, opHighOnes, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq8_a(opLowOnes, opLowOnes, use_far, true)

    wait_and_clear_at_row(row)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_bne8_a(init_row, use_far)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    .if (use_far)
    {
        nv_screen_print_str(title_bne8_a_far_str)
    }
    else
    {
        nv_screen_print_str(title_bne8_a_str)
    }
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_a(opSmall, opBig, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_a(opBig, opSmall, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_a(opSmall, opSmall, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_a(opTwo, opOne, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_a(opOne, opZero, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_a(opOne, opMax, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_a(opZero, opMax, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_a(opZero, opOne, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_a(opMax, opOne, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_a(opMax, opZero, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_a(opMax, opMax, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_a(opOne, opOne, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_a(opZero, opZero, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_a(opHighOnes, opLowOnes, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_a(opLowOnes, opHighOnes, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_a(opHighOnes, opHighOnes, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne8_a(opLowOnes, opLowOnes, use_far, false)

    wait_and_clear_at_row(row)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_blt8_a(init_row, use_far)
{
    .var row = init_row
        
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    .if (use_far)
    {
        nv_screen_print_str(title_blt8_a_far_str)
    }
    else
    {
        nv_screen_print_str(title_blt8_a_str)
    }



    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_a(opSmall, opBig, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_a(opBig, opSmall, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_a(opSmall, opSmall, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_a(opTwo, opOne, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_a(opOne, opZero, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_a(opOne, opMax, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_a(opZero, opMax, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_a(opZero, opOne, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_a(opMax, opOne, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_a(opMax, opZero, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_a(opMax, opMax, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_a(opOne, opOne, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_a(opZero, opZero, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_a(opHighOnes, opLowOnes, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_a(opLowOnes, opHighOnes, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_a(opHighOnes, opHighOnes, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt8_a(opLowOnes, opLowOnes, use_far, false)

    wait_and_clear_at_row(row)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_ble8_a(init_row, use_far)
{
    .var row = init_row
        
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    .if (use_far)
    {
        nv_screen_print_str(title_ble8_a_far_str)
    }
    else
    {
        nv_screen_print_str(title_ble8_a_str)
    }



    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_a(opSmall, opBig, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_a(opBig, opSmall, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_a(opSmall, opSmall, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_a(opTwo, opOne, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_a(opOne, opZero, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_a(opOne, opMax, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_a(opZero, opMax, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_a(opZero, opOne, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_a(opMax, opOne, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_a(opMax, opZero, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_a(opMax, opMax, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_a(opOne, opOne, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_a(opZero, opZero, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_a(opHighOnes, opLowOnes, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_a(opLowOnes, opHighOnes, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_a(opHighOnes, opHighOnes, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble8_a(opLowOnes, opLowOnes, use_far, true)

    wait_and_clear_at_row(row)
}

//////////////////////////////////////////////////////////////////////////////
//
.macro test_bgt8_a(init_row, use_far)
{
    .var row = init_row
        
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    .if (use_far)
    {
        nv_screen_print_str(title_bgt8_a_far_str)
    }
    else
    {
        nv_screen_print_str(title_bgt8_a_str)
    }



    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_a(opSmall, opBig, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_a(opBig, opSmall, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_a(opSmall, opSmall, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_a(opTwo, opOne, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_a(opOne, opZero, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_a(opOne, opMax, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_a(opZero, opMax, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_a(opZero, opOne, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_a(opMax, opOne, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_a(opMax, opZero, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_a(opMax, opMax, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_a(opOne, opOne, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_a(opZero, opZero, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_a(opHighOnes, opLowOnes, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_a(opLowOnes, opHighOnes, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_a(opHighOnes, opHighOnes, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt8_a(opLowOnes, opLowOnes, use_far, false)

    wait_and_clear_at_row(row)
}

//////////////////////////////////////////////////////////////////////////////
//
.macro test_bge8_a(init_row, use_far)
{
    .var row = init_row
        
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    .if (use_far)
    {
        nv_screen_print_str(title_bge8_a_far_str)
    }
    else
    {
        nv_screen_print_str(title_bge8_a_str)
    }



    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_a(opSmall, opBig, use_far, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_a(opBig, opSmall, use_far, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_a(opSmall, opSmall, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_a(opTwo, opOne, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_a(opOne, opZero, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_a(opOne, opMax, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_a(opZero, opMax, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_a(opZero, opOne, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_a(opMax, opOne, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_a(opMax, opZero, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_a(opMax, opMax, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_a(opOne, opOne, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_a(opZero, opZero, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_a(opHighOnes, opLowOnes, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_a(opLowOnes, opHighOnes, use_far, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_a(opHighOnes, opHighOnes, use_far, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge8_a(opLowOnes, opLowOnes, use_far, true)

    wait_and_clear_at_row(row)
}


/////////////////////////////////////////////////////////////////////////////
// wait for key then clear screen when its detected
.macro wait_and_clear_at_row(init_row)
{
    .var row = init_row
    .eval row++
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(hit_anykey_str)

    jsr WaitAnyKey

    nv_screen_clear()
    .eval row=0
    nv_screen_plot_cursor(row++, 20)
    nv_screen_print_str(title_str)
}


///////////
WaitAnyKey:
{
    nv_key_wait_any_key()
    rts
}

//////////////////////////////////////////////////////////////////////////////
//                          Print macros 
//////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either = or != ) 
// for the relationship of the two butes in memorys.  Use nv_beq8_a to do it.
//   addr1: is the address of one byte
//   addr2: is the address of another byte
.macro print_beq8_a(addr1, addr2, use_far, expect_to_branch)
{
    lda #1
    sta passed
    lda addr1
    jsr PrintHexByteAccum
    .if (use_far)
    {   
        lda addr2
        nv_beq8_a_far(addr1, BranchTarget)
    }
    else
    {
        lda addr2
        nv_beq8_a(addr1, BranchTarget)
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
BranchTarget:
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
.macro print_bne8_a(addr1, addr2, use_far, expect_to_branch)
{
    lda #1
    sta passed
    lda addr1
    jsr PrintHexByteAccum
    .if (use_far)
    {
        lda addr2
        nv_bne8_a_far(addr1, BranchTarget)
    }
    else
    {
        lda addr2
        nv_bne8_a(addr1, BranchTarget)
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
    lda addr2
    jsr PrintHexByteAccum

    jsr PrintPassed
}



//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either < or >= ) 
// for the relationship of the two bytes in memory.  Use nv_blt8_a or
// nv_blt8_a_far to do it.
// macro params
//   addr1: is the address of byte1
//   addr2: is the address of byte2 
//   use_far: pass true to use the var version of nv_blt
//   expect_to_branch: pass true if the expected outcome is
//                     to branch or false if not.  pass/fail 
//                     based on this.
.macro print_blt8_a(addr1, addr2, use_far, expect_to_branch)
{
    lda #1
    sta passed
    lda addr1
    jsr PrintHexByteAccum
    .if (use_far)
    {
        lda addr2
        nv_blt8_a_far(addr1, BranchTarget)
    }
    else
    {
        lda addr2
        nv_blt8_a(addr1, BranchTarget)
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

BranchTarget:
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
// for the relationship of the two bytes in memory.  Use nv_ble8_a or
// nv_ble8_a_far to do it.
// macro params
//   addr1: is the address of byte12
//   use_far: pass true to use the var version of nv_blt
//   expect_to_branch: pass true if the expected outcome is
//                     to branch or false if not.  pass/fail 
//                     based on this.
.macro print_ble8_a(addr1, addr2, use_far, expect_to_branch)
{
    lda #1
    sta passed
    lda addr1
    jsr PrintHexByteAccum
    .if (use_far)
    {
        lda addr2
        nv_ble8_a_far(addr1, BranchTarget)
    }
    else
    {
        lda addr2
        nv_ble8_a(addr1, BranchTarget)
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
// for the relationship of the two bytes in memory.  Use nv_bge8_a or
// nv_bge8_a_far to do it.
// macro params
//   addr1: is the address of byte1
//   addr2: is the address of byte2
//   use_far: pass true to use the var version of nv_blt
//   expect_to_branch: pass true if the expected outcome is
//                     to branch or false if not.  pass/fail 
//                     based on this.
.macro print_bge8_a(addr1, addr2, use_far, expect_to_branch)
{
    lda #1
    sta passed
    lda addr1
    jsr PrintHexByteAccum
    .if (use_far)
    {
        lda addr2
        nv_bge8_a_far(addr1, BranchTarget)
    }
    else
    {
        lda addr2
        nv_bge8_a(addr1, BranchTarget)
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
.macro print_bgt8_a(addr1, addr2, use_far, expect_to_branch)
{
    lda #1
    sta passed
    lda addr1
    jsr PrintHexByteAccum
    .if (use_far)
    {
        lda addr2
        nv_bgt8_a_far(addr1, BranchTarget)
    }
    else
    {
        lda addr2
        nv_bgt8_a(addr1, BranchTarget)
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




//////////////////////////////////////////////////////////////////////////////
PrintHexByteAccum:
{
    nv_screen_print_hex_byte_a(true)
    rts
}

//////////////////////////////////////////////////////////////////////////////
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