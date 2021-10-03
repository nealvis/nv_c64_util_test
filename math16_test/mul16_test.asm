//////////////////////////////////////////////////////////////////////////////
// mul16_test.asm
// Copyright(c) 2021 Neal Smith.
// License: MIT. See LICENSE file in root directory.
//////////////////////////////////////////////////////////////////////////////
// This program is a tester for the 16 bit multiplication macros in
// nv_math16_*.asm files in the nv_c64_util repository

// import all nv_c64_util macros and data.  The data
// will go in default place
#import "../../nv_c64_util/nv_c64_util_macs_and_data.asm"

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

space_str: .text @" \$00"
passed_str: .text @" PASSED\$00"
failed_str: .text @" FAILED\$00"

fail_control_str: nv_screen_lite_red_fg_str()
pass_control_str: nv_screen_green_fg_str()
normal_control_str: nv_screen_white_fg_str()

passed: .byte 0
temp_byte: .byte 0
result16: .word $0000


// program variables
times_str: .text @" * \$00"
equal_str: .text@" = \$00"
minus_str: .text@" - \$00"
transform_str: .text@" -> \$00"

bad_carry_str: .text@" C\$00"
overflow_set_str: .text@" V=1\$00"
overflow_clear_str: .text@" V=0\$00"
bad_neg_str: .text@" N\$00"

title_str: .text @"MUL16\$00"          // null terminated string to print
                                        // via the BASIC routine
title_mul16_x_1_str: .text @"TEST MUL16 x 1\$00"
title_mul16_x_2_str: .text @"TEST MUL16 x 2\$00"
title_mul16_x_3_str: .text @"TEST MUL16 x 3\$00"


title_mul16_immed_1_str: .text @"TEST MUL16 IMMED 1\$00"

hit_anykey_str: .text @"HIT ANY KEY ...\$00"


op1: .word $FFFF
op2: .word $FFFF
result: .word $0000

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
op16_7FFF: .word $7FFF
op16_FFFE: .word $FFFE
op16_0080: .word $0080 // 128
op16_0081: .word $0081 // 129
op16_8000: .word $8000 // high bit only set
op16_FFFF: .word $FFFF // all bits
op16_00FF: .word $00FF // all bits

op16_0000: .word $0000
op16_0001: .word $0001
op16_0002: .word $0002
op16_0003: .word $0003
op16_0004: .word $0004
op16_0005: .word $0005
op16_0006: .word $0006
op16_0007: .word $0007
op16_0008: .word $0008
op16_0010: .word $0010
op16_0020: .word $0020
op16_0040: .word $0040


op8_7F: .byte $7F
op8_FF: .byte $FF
op8_0F: .byte $0F
op8_F0: .byte $F0
op8_80: .byte $80  // -128
op8_81: .byte $81  // -127
op8_FE: .byte $FE

op8_99: .byte $99
op8_3F: .byte $3F  // 63
op8_7D: .byte $7D  // 125

op8_00: .byte $00
op8_01: .byte $01
op8_02: .byte $02
op8_03: .byte $03
op8_04: .byte $04
op8_05: .byte $05
op8_06: .byte $06
op8_07: .byte $07
op8_08: .byte $08
op8_10: .byte $10
op8_20: .byte $20
op8_40: .byte $40


*=$1000 "Main Start"

.var row = 0

    nv_screen_print_str(normal_control_str)
    nv_screen_clear()
    nv_screen_plot_cursor(row++, 33)
    nv_screen_print_str(title_str)

    test_mul16_x_1(0)

    rts
//////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////
//
.macro test_mul16_x_1(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_mul16_x_1_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul16_x(op16_FFFF, op8_02, $FFFE, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul16_x(op16_0001, op8_01, $0001, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul16_x(op16_0001, op8_02, $0002, false)


    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul16_x(op16_0002, op8_02, $0004, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul16_x(op16_0007, op8_00, $0000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul16_x(op16_0000, op8_04, $0000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul16_x(op16_0000, op8_00, $0000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul16_x(op16_0000, op8_00, $0000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul16_x(op16_0001, op8_03, $0003, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul16_x(op16_00FF, op8_FF, $FE01, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul16_x(op16_FFFF, op8_01, $FFFF, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul16_x(op16_FFFF, op8_02, $FFFE, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul16_x(op16_FFFF, op8_03, $FFFD, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul16_x(op16_FFFF, op8_FF, $FF01, true)

    wait_and_clear_at_row(row)
}



/*
//////////////////////////////////////////////////////////////////////////////
//
.macro test_mul8_mem_mem_1(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_mul8_mem_mem_1_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_01, $0001)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_02, $0002)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_02, op8_02, $0004)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_07, op8_00, $0000)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_00, op8_04, $0000)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_00, op8_00, $0000)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_00, $0000)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_03, $0003)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_FF, op8_FF, $FE01)

    wait_and_clear_at_row(row)

}

//////////////////////////////////////////////////////////////////////////////
//
.macro test_mul8_mem_mem_2(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_mul8_mem_mem_2_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_00, $0000) // 0

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_01, $0001) // 1

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_02, $0002) // 2

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_04, $0004) // 4

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_08, $0008) // 8

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_10, $0010) // 16

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_20, $0020) //32

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_40, $0040) //64

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_80, $0080) //128

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_FF, op8_01, $00FF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_FF, op8_02, $01FE)


    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_04, $0004)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_08, $0008)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_10, $0010) // 16

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_20, $0020) //32

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_40, $0040) //64

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_80, $0080) //128

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_FF, op8_80, $7F80)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_99, op8_10, $0990)


    wait_and_clear_at_row(row)

}

//////////////////////////////////////////////////////////////////////////////
//
.macro test_mul8_mem_mem_3(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_mul8_mem_mem_3_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++


    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_3F, $003F)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_02, op8_3F, $007E)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_03, op8_3F, $00BD)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_04, op8_3F, $00FC)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_05, op8_3F, $013B)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_06, op8_3F, $017A)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_3F, op8_01, $003F)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_3F, op8_02, $007E)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_3F, op8_03, $00BD)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_3F, op8_04, $00FC)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_3F, op8_05, $013B)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_3F, op8_06, $017A)




    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_7D, op8_02, $00FA)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_7D, op8_7D, $3D09)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_7D, op8_FF, $7C83)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_FF, op8_7D, $7C83)
  
    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_FF, op8_FF, $FE01)


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

    jsr WaitAnyKey

    nv_screen_clear()
    .eval row=0
    nv_screen_plot_cursor(row++, 33)
    nv_screen_print_str(title_str)
}


//////////////////////////////////////////////////////////////////////////////
//
WaitAnyKey:
    nv_key_wait_any_key()
    rts

//////////////////////////////////////////////////////////////////////////////
//                          Print macros 
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
// addr1: address of word in memory thats op1 for multiplication
// addr2: address of byte in memory thats op2 for multipliection
// expected_result: is 16 bit immediate value that is the expected result
.macro print_mul16_x(addr1, addr2, expected_result, expect_overflow_set)
{
    // set passed to true until evidence of a fail below
    lda #1
    sta passed

    // put some garbage in the result
    nv_store16_immediate(result16, $BEEF)

    // print the first operand
    nv_xfer16_mem_mem(addr1, word_to_print)
    jsr PrintHexWord 

    // print multiplication operator *
    nv_screen_print_str(times_str)

    // do multiplication
    ldx addr2
    nv_mul16_x(addr1, result16, NV_PROCSTAT_OVERFLOW)
    php // save status register
    
    // if match expected result then skip setting passed to false
    nv_beq16_immed(result16, expected_result, GoodResult)
    ldx #0
    stx passed

GoodResult:
    // print the second operand
    lda addr2
    jsr PrintHexByteAccum  // print result of operation in accum

    // print = sign
    nv_screen_print_str(equal_str)

    // print the result
    nv_xfer16_mem_mem(result16, word_to_print)
    jsr PrintHexWord 

    plp // pull saved status reg
    pass_or_fail_overflow(expect_overflow_set)

    // print if passed or failed
    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
/*
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
    plp
    lda #0 
    sta passed

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
    plp
    lda #0 
    sta passed

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
    plp
    lda #0 
    sta passed
    
NegGood:
    nv_screen_print_str(normal_control_str)

}
*/


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
PrintHexByteAccum:
{
    nv_screen_print_hex_byte_a(true)
    rts
}


///////////////////////////////////////////////////////////////////////
PrintHexWord:
{
    nv_screen_print_hex_word_mem(word_to_print, true)
    rts
}
word_to_print: .word 0


///////////////////////////////////////////////////////////////////////
PrintPassed:
{
    nv_screen_print_str(space_str)
    lda passed
    bne PrintPass
PrintFail:
    nv_screen_print_str(fail_control_str)
    nv_screen_print_str(failed_str)
    jmp Done

PrintPass:
    nv_screen_print_str(pass_control_str)
    nv_screen_print_str(passed_str)

Done:
    nv_screen_print_str(normal_control_str)
    rts
}