//////////////////////////////////////////////////////////////////////////////
// math16_test.asm
// Copyright(c) 2021 Neal Smith.
// License: MIT. See LICENSE file in root directory.
//////////////////////////////////////////////////////////////////////////////
// This program tests the 16bit math operations in the nv_c64_util 
// repository in the file nv_math16_macs.asm 
// such as  add, subtract, and compare, etc.
//////////////////////////////////////////////////////////////////////////////

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

result_byte: .byte 0


// program variables
carry_str: .text @"(C) \$00"
carry_and_overflow_str:  .text @"(CV) \$00"
overflow_str:  .text @"(V) \$00"
plus_str: .text @"+\$00"
minus_str: .text @"-\$00"
equal_str: .text@"=\$00"
lsr_str: .text@">>\$00"

title_str: .text @"MATH16\$00"          // null terminated string to print
                                        // via the BASIC routine
title_adc16_str: .text @"TEST ADC16 \$00"
title_adc16_8u_str: .text @"TEST ADC16 8U \$00"
title_adc16_8s_str: .text @"TEST ADC16 8S \$00"
title_adc16_immediate_str: .text @"TEST ADC16 IMMED\$00"
title_lsr16_str: .text @"TEST LSR16 \$00"
title_sbc16_str: .text @"TEST SBC16 \$00"

word_to_print: .word $DEAD
another_word:  .word $BEEF

counter: .byte 0

op16_FFFF:
op1: .word $FFFF
op2: .word $FFFF
result: .word $0000

opSmall: .word $0005
opBig:   .word $747E

op1Beef: .word $beef
op2Beef: .word $beef

opZero: .word $0000
opMax: .word $ffff
op16_0001:
opOne: .word $0001
op16_0002:
opTwo: .word $0002

op16_557F: .word $557F
op16_2201: .word $2201
op16_007F: .word $007F
op16_FF00:
opHighOnes: .word $FF00
op16_00FF:
opLowOnes: .word $00FF
op16_7FFF:
op_7FFF: .word $7FFF
op16_FFFE: 
op_FFFE: .word $FFFE
op_0080: .word $0080 // 128
op_0081: .word $0081 // 129
op_8000: .word $8000 // high bit only set
op_8001: .word $8001 // high bit only set
op_FFFF: .word $FFFF // all bits
op_0000: .word $0000 // all bits
op_0001: .word $0001 // all bits
op_0002: .word $0002 // all bits
op_00FF: .word $00FF 
op_0100: .word $0100
op_0200: .word $0200
op_0300: .word $0300
op_3333: .word $3333
op_2222: .word $2222
op_FFFD: .word $FFFD // -3

op_00: .byte $00
op_01: .byte $01

op8_7F: .byte $7F
op8_FF: .byte $FF
op8_0F: .byte $0F
op8_F0: .byte $F0
op8_80: .byte $80  // -128
op8_81: .byte $81  // -127

op_02: .byte $02
op_08: .byte $08
op_09: .byte $09
op_80: .byte $80
op_81: .byte $81
op_7F: .byte $7F
op_FF: .byte $FF
op_10: .byte $10
op_0F: .byte $0F
op_FD: .byte $FD
op_33: .byte $33
op_22: .byte $22
op_FE: .byte $FE


*=$1000 "Main Start"

.var row = 0

    nv_screen_print_str(normal_control_str)
    nv_screen_clear()
    nv_screen_plot_cursor(row++, 33)
    nv_screen_print_str(title_str)

    test_adc16(0)
    test_adc16_immediate(0)
    test_adc16_8u(0)
    test_adc16_8s(0)
    test_lsr16(0)

    rts


//////////////////////////////////////////////////////////////////////////////
//
.macro test_adc16(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_adc16_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //            C      V      N
    print_adc16(opMax, op16_FFFF, result, $FFFE, true, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                 C      V      N
    print_adc16(op16_0001, op16_0002, result, $0003, false, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                 C      V      N
    print_adc16(op16_7FFF, op16_0002, result, $8001, false, true, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                C      V      N
    print_adc16(op16_0001, op16_FFFF, result, $0000, true, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //          C      V      N
    print_adc16(opMax, opZero, result, $FFFF, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //               C      V      N
    print_adc16(op16_00FF, op16_0001, result, $0100, false, false, false)


    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                 C      V      N
    print_adc16(op16_00FF, op16_FF00, result, $FFFF, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                 C      V      N
    print_adc16(op16_FF00, op16_00FF, result, $FFFF, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //              C      V      N
    print_adc16(op_7FFF, op16_FFFF, result, $7FFE, true, false, false)


    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                C      V      N
    print_adc16(op16_7FFF, op16_0001, result, $8000, false, true, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //              C      V      N
    print_adc16(op_7FFF, op16_0002, result, $8001, false, true, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //              C      V      N
    print_adc16(op_FFFE, op16_0002, result, $0000, true, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //              C      V      N
    print_adc16(op_FFFE, op16_0001, result, $FFFF, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                C      V      N
    print_adc16(op16_007F, op16_0001, result, $0080, false, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                C      V      N
    print_adc16(op16_557F, op16_2201, result, $7780, false, false, false)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_adc16_8u(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_adc16_8u_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8u(op1, op2, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8u(opOne, opTwo, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8u(opOne, opMax, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8u(opMax, opZero, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8u(opOne, opMax, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8u(opLowOnes, opOne, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8u(opLowOnes, op8_7F, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8u(opHighOnes, opMax, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8u(op_7FFF, opOne, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8u(op1Beef, op8_0F, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8u(op1Beef, op8_F0, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8u(opMax, op8_F0, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8u(opMax, op8_FF, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8u(op_7FFF, op8_FF, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8u(op_7FFF, opOne, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8u(op_7FFF, opTwo, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8u(op_FFFE, opTwo, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8u(op_FFFE, opOne, result)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_adc16_8s(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_adc16_8s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8s(op1, op2, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8s(opOne, opTwo, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8s(opOne, opMax, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8s(opMax, opZero, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8s(opOne, op8_80, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8s(op_0080, op8_80, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8s(op_0081, op8_80, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8s(opLowOnes, opOne, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8s(opLowOnes, op8_7F, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8s(opHighOnes, opMax, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8s(op_7FFF, opOne, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8s(op1Beef, op8_0F, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8s(op1Beef, op8_F0, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8s(opMax, op8_F0, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8s(opMax, op8_FF, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8s(op_7FFF, op8_FF, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8s(op_7FFF, opOne, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8s(op_7FFF, opTwo, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8s(op_FFFE, opTwo, result)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_adc16_8s(op_FFFE, opOne, result)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_adc16_immediate(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_adc16_immediate_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                      C      V      N
    print_adc16_immediate(op16_FFFF, $36B1, result, $36B0, true, false, false)


    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                      C      V      N
    print_adc16_immediate(op16_0001, $0002, result, $0003, false, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                      C      V      N
    print_adc16_immediate(op16_0001, $FFFF, result, $0000, true, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                      C      V      N
    print_adc16_immediate(op16_FFFF, $0000, result, $FFFF, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                      C      V      N
    print_adc16_immediate(op16_00FF, $0001, result, $0100, false, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                      C      V      N
    print_adc16_immediate(op16_00FF, $FF00, result, $FFFF, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                      C      V      N
    print_adc16_immediate(op16_FF00, $00FF, result, $FFFF, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                      C      V      N
    print_adc16_immediate(op16_7FFF, $FFFF, result, $7FFE, true, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                      C      V      N
    print_adc16_immediate(op16_7FFF, $0001, result, $8000, false, true, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                      C      V      N
    print_adc16_immediate(op16_7FFF, $0002, result, $8001, false, true, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                      C      V      N
    print_adc16_immediate(op16_FFFE, $0002, result, $0000, true, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                      C      V      N
    print_adc16_immediate(op16_FFFE, $0001, result, $FFFF, false, false, true)

    wait_and_clear_at_row(row, title_str)
}

//////////////////////////////////////////////////////////////////////////////
//
.macro test_lsr16(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_lsr16_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op_8000, 0)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op_8000, 1)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op_8000, 2)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op_8000, 3)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op_8000, 4)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op_8000, 5)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op_8000, 6)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op_8000, 7)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op_8000, 8)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op_8000, 9)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op_8000, 10)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op_8000, 11)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op_8000, 12)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op_8000, 13)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op_8000, 14)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op_8000, 15)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op_8000, 16)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op_FFFF, 1)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op_FFFF, 2)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op_FFFF, 3)
}


//////////////////////////////////////////////////////////////////////////////
//                          Print macros 
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified addition at the current curor location
// nv_adc16x is used to do the addition.  
.macro print_adc16(op1, op2, result, expected_result, 
                   expect_carry_set, expect_overflow_set, expect_neg_set)
{
    lda #1
    sta passed

    nv_screen_print_hex_word_mem(op1, true)
    nv_screen_print_str(plus_str)
    nv_screen_print_hex_word_mem(op2, true)
    nv_screen_print_str(equal_str)

    nv_adc16x(op1, op2, result)
    php
    nv_beq16_immed(result, expected_result, ResultGood)
    lda #0 
    sta passed

ResultGood:
    nv_screen_print_hex_word_mem(result, true)
    plp
    pass_or_fail_status_flags(expect_carry_set, expect_overflow_set, 
                              expect_neg_set)

    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified addition at the current curor location
// nv_adc16_8u us used to do the addition.  
// it will look like this with no carry:
//    $2222 + $33 = $2255
// or look like this if there is a carry:
//    $FFFF + $01 = (C) $0000
.macro print_adc16_8u(op16, op8, result)
{
    nv_screen_print_hex_word_mem(op16, true)
    nv_screen_print_str(plus_str)
    nv_screen_print_hex_byte_mem(op8, true)
    nv_screen_print_str(equal_str)

    nv_adc16_8unsigned(op16, op8, result)
    bcc NoCarry
    nv_screen_print_str(carry_str)
NoCarry:
    nv_screen_print_hex_word_mem(result, true)
}


//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified addition at the current curor location
// nv_adc16_8s us used to do the addition.  
// it will look like this with no carry:
//    $2222 + $33 = $2255
// or look like this if there is a carry:
//    $FFFF + $01 = (C) $0000
.macro print_adc16_8s(op16, op8, result)
{
    nv_screen_print_hex_word_mem(op16, true)
    nv_screen_print_str(plus_str)
    nv_screen_print_hex_byte_mem(op8, true)
    nv_screen_print_str(equal_str)

    nv_adc16_8signed(op16, op8, result)
    bcc NoCarry
    nv_screen_print_str(carry_str)
NoCarry:
    nv_screen_print_hex_word_mem(result, true)
}



//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified addition at the current curor location
// nv_adc16x_mem_immed us used to do the addition.  
// it will look like this with no carry:
//    $2222 + $3333 = $5555
// or look like this if there is a carry:
//    $FFFF + $0001 = (C) $0000
.macro print_adc16_immediate(op1, num, result, expected_result, 
                             expect_carry_set, expect_overflow_set, 
                             expect_neg_set)
{
    nv_screen_print_hex_word_mem(op1, true)
    nv_screen_print_str(plus_str)
    nv_screen_print_hex_word_immed(num, true)
    nv_screen_print_str(equal_str)

    nv_adc16x_mem_immed(op1, num, result)
    php
    nv_beq16_immed(result, expected_result, ResultGood)
    lda #0 
    sta passed

ResultGood:
    nv_screen_print_hex_word_mem(result, true)
    plp
    pass_or_fail_status_flags(expect_carry_set, expect_overflow_set, 
                              expect_neg_set)

    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specifiied logical shift right at the current 
// cursor position.  nv_lsr16 will be used to do the operation.
// it will look like this
//   $0001 >> 3 = $0004 
// op1 is the address of the LSB of the 16 bit number to shift
// num_rots is the number of rotations to do
.macro print_lsr16(op1, num_rots)
{
    lda op1
    sta temp_lsr16
    lda op1+1
    sta temp_lsr16 + 1
    nv_screen_print_hex_word_mem(temp_lsr16, true)
    nv_screen_print_str(lsr_str)
    nv_screen_print_hex_word_immed(num_rots, true)
    nv_screen_print_str(equal_str)

    nv_lsr16(temp_lsr16, num_rots)
    nv_screen_print_hex_word_mem(temp_lsr16, true)
}

temp_lsr16: .word 0


#import "../test_util/test_util_code.asm"
