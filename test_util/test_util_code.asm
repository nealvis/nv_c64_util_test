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
    nv_screen_plot_cursor(row++, 33)
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
