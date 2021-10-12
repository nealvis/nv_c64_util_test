//////////////////////////////////////////////////////////////////////////////
// test_util_code.asm
// Copyright(c) 2021 Neal Smith.
// License: MIT. See LICENSE file in root directory.
//////////////////////////////////////////////////////////////////////////////
// This file contains code, macros, and data that are utility for all 
// test programs in nv_c64_util_test

// import all nv_c64_util macros and data.  The data
// will go in default place
#import "../../nv_c64_util/nv_c64_util_macs_and_data.asm"

space_str: .text @" \$00"
passed_str: .text @" PASSED\$00"
failed_str: .text @" FAILED\$00"

fail_control_str: nv_screen_lite_red_fg_str()
pass_control_str: nv_screen_green_fg_str()
normal_control_str: nv_screen_white_fg_str()

passed: .byte 0

bad_carry_str: .text@" C\$00"
bad_overflow_str: .text@" V\$00"
bad_neg_str: .text@" N\$00"
bad_zero_str: .text@" Z\$00"
overflow_set_str: .text@" V=1\$00"
overflow_clear_str: .text@" V=0\$00"


hit_anykey_str: .text @"HIT ANY KEY ...\$00"



/////////////////////////////////////////////////////////////////////////////
// wait for key then clear screen when its detected
.macro wait_and_clear_at_row(init_row, title_str)
{
    .var row = init_row
    .eval row++
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(hit_anykey_str)

    jsr WaitAnyKey

    nv_screen_clear()
    .eval row=0
    nv_screen_plot_cursor(row++, 23)
    nv_screen_print_str(title_str)
}


//////////////////////////////////////////////////////////////////////////////
WaitAnyKey:
    nv_key_wait_any_key()
    rts

//////////////////////////////////////////////////////////////////////////////
.macro pass_or_fail_status_flags(expect_carry_set, expect_overflow_set, 
                                 expect_neg_set)
{
    php
    nv_screen_print_str(fail_control_str)
    plp
    .if (expect_carry_set)
    {
        bcs CarryGood
    }
    else 
    {
        bcc CarryGood
    }
    php
    nv_screen_print_str(bad_carry_str)
    lda #0 
    sta passed
    plp

CarryGood: 
    .if (expect_overflow_set)
    {
        bvs OverflowGood
    }
    else 
    {
        bvc OverflowGood
    }
    php
    nv_screen_print_str(bad_overflow_str)
    lda #0 
    sta passed
    plp

OverflowGood:
    .if (expect_neg_set)
    {
        bmi NegGood
    }
    else 
    {
        bpl NegGood
    }
    php
    nv_screen_print_str(bad_neg_str)
    lda #0 
    sta passed
    plp

NegGood:
    php
    nv_screen_print_str(normal_control_str)
    plp

}


//////////////////////////////////////////////////////////////////////////////
.macro pass_or_fail_carry(expect_carry_set)
{
    php
    nv_screen_print_str(fail_control_str)
    plp
    .if (expect_carry_set)
    {
        bcs CarryGood
    }
    else 
    {
        bcc CarryGood
    }
    php
    nv_screen_print_str(bad_carry_str)
    lda #0 
    sta passed
    plp

CarryGood: 

}

//////////////////////////////////////////////////////////////////////////////
.macro pass_or_fail_zero(expect_zero_set)
{
    php
    nv_screen_print_str(fail_control_str)
    plp
    .if (expect_zero_set)
    {
        beq Good
    }
    else 
    {
        bne Good
    }
    php
    nv_screen_print_str(bad_zero_str)
    lda #0 
    sta passed
    plp

Good: 

}


//////////////////////////////////////////////////////////////////////////////
.macro pass_or_fail_overflow(expect_overflow_set)
{
    php
    .if (expect_overflow_set)
    {
        bvs OverflowGood
    }
    else 
    {
        bvc OverflowGood
    }
    nv_screen_print_str(fail_control_str)
    lda #0 
    sta passed
    jmp PrintOverflowState

OverflowGood:
    nv_screen_print_str(pass_control_str)

PrintOverflowState:    
    plp
    php
    bvs OverflowSet 
OverflowClear:
    nv_screen_print_str(overflow_clear_str)
    jmp Done
OverflowSet:   
    nv_screen_print_str(overflow_set_str)

Done:
    nv_screen_print_str(normal_control_str)
    plp
}

///////////////////////////////////////////////////////////////////////
PrintHexWord:
{
    nv_screen_print_hex_word_mem(word_to_print, true)
    rts
}
word_to_print: .word 0



///////////////////////////////////////////////////////////////////////
PrintHexByteAccum:
{
    nv_screen_print_hex_byte_a(true)
    rts
}

///////////////////////////////////////////////////////////////////////
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


/////////////////////////////////////////////////////////////////
//
/*
.macro PrintCarryAndOverflow()
{
    php
    bcc NoCarry
Carry:
    bvs CarryAndOverflow 
CarryNoOverflow:
    nv_screen_print_str(carry_str)
    jmp Done
CarryAndOverflow:
    nv_screen_print_str(carry_and_overflow_str)
    jmp Done
NoCarry: 
    bvc NoCarryNoOverflow
NoCarryButOverflow:
    nv_screen_print_str(overflow_str)
    jmp Done
NoCarryNoOverflow:
Done:
    plp
}
*/