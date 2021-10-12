//////////////////////////////////////////////////////////////////////////////
// math16_test_bcd.asm
// Copyright(c) 2021 Neal Smith.
// License: MIT. See LICENSE file in root directory.
//////////////////////////////////////////////////////////////////////////////
// This program tests the bcd math operations in nv_math16.asm
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

// program variables
carry_str: .text @"(C) \$00"
carry_and_overflow_str:  .text @"(CV) \$00"
overflow_str:  .text @"(V) \$00"
plus_str: .text @"+\$00"
minus_str: .text @"-\$00"
equal_str: .text@"=\$00"
lsr_str: .text@">>\$00"

title_str: .text @"MATH16 BCD\$00"      // null terminated string to print
                                        // via the BASIC routine
title_bcd_adc16_str: .text @"TEST BCD ADC16\$00"
title_bcd_sbc16_str: .text @"TEST BCD SBC16\$00"
title_bcd_sbc16_immed_str: .text @"TEST BCD SBC16 IMMED\$00"
title_bcd_adc16_immed_str: .text @"TEST BCD ADC16 IMMED\$00"

#import "../test_util/test_util_op16_data.asm"

*=$1000 "Main Start"

.var row = 0

    nv_screen_print_str(normal_control_str)
    nv_screen_clear()
    nv_screen_plot_cursor(row++, 30)
    nv_screen_print_str(title_str)

    test_bcd_sbc16(0)
    test_bcd_sbc16_immed(0)
    test_bcd_adc16(0)
    test_bcd_adc16_immed(0)

    rts

//////////////////////////////////////////////////////////////////////////////
//
.macro test_bcd_adc16_immed(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_bcd_adc16_immed_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                          c
    print_bcd_adc16_immed(op16_0000, $0001, result, $0001, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                          c
    print_bcd_adc16_immed(op16_0009, $0001, result, $0010, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                          c
    print_bcd_adc16_immed(op16_0009, $0020, result, $0029, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                          c
    print_bcd_adc16_immed(op16_0099, $0001, result, $0100, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                          c
    print_bcd_adc16_immed(op16_0099, $0002, result, $0101, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                          c
    print_bcd_adc16_immed(op16_0999, $9000, result, $9999, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                          c
    print_bcd_adc16_immed(op16_9999, $0001, result, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                          c
    print_bcd_adc16_immed(op16_9999, $0099, result, $0098, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                          c
    print_bcd_adc16_immed(op16_9999, $9999, result, $9998, true)


    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_bcd_adc16(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_bcd_adc16_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                    C  
    print_bcd_adc16(op16_9999, op16_0001, result, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                    C  
    print_bcd_adc16(op16_0000, op16_0001, result, $0001, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                    C  
    print_bcd_adc16(op16_0009, op16_0001, result, $0010, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                    C  
    print_bcd_adc16(op16_0009, op16_0020, result, $0029, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                    C  
    print_bcd_adc16(op16_0099, op16_0001, result, $0100, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                    C  
    print_bcd_adc16(op16_0099, op16_0002, result, $0101, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                    C  
    print_bcd_adc16(op16_0999, op16_9000, result, $9999, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                    C  
    print_bcd_adc16(op16_9999, op16_0001, result, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                    C  
    print_bcd_adc16(op16_9999, op16_0099, result, $0098, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                    C  
    print_bcd_adc16(op16_9999, op16_9999, result, $9998, true)

    wait_and_clear_at_row(row, title_str)
}

//////////////////////////////////////////////////////////////////////////////
//
.macro test_bcd_sbc16(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_bcd_sbc16_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                    C  
    print_bcd_sbc16(op16_0002, op16_0001, result, $0001, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                    C  
    print_bcd_sbc16(op16_0001, op16_0002, result, $9999, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                    C  
    print_bcd_sbc16(op16_9999, op16_9999, result, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                    C  
    print_bcd_sbc16(op16_9998, op16_9999, result, $9999, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                    C  
    print_bcd_sbc16(op16_0000, op16_9999, result, $0001, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                    C  
    print_bcd_sbc16(op16_0100, op16_0002, result, $0098, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                    C  
    print_bcd_sbc16(op16_9000, op16_0999, result, $8001, true)


    wait_and_clear_at_row(row, title_str)

}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_bcd_sbc16_immed(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_bcd_sbc16_immed_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                    C  
    print_bcd_sbc16_immed(op16_0002, $0001, result, $0001, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                    C  
    print_bcd_sbc16_immed(op16_0001, $0002, result, $9999, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                    C  
    print_bcd_sbc16_immed(op16_9999, $9999, result, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                    C  
    print_bcd_sbc16_immed(op16_9998, $9999, result, $9999, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                    C  
    print_bcd_sbc16_immed(op16_0000, $9999, result, $0001, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                    C  
    print_bcd_sbc16_immed(op16_0100, $0002, result, $0098, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                    C  
    print_bcd_sbc16_immed(op16_9000, $0999, result, $8001, true)


    wait_and_clear_at_row(row, title_str)

}


//////////////////////////////////////////////////////////////////////////////
//                          Print macros 
//////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified addition at the current curor location
// nv_bcd_adc16 is used to do the addition.
// C, will show up to indicate the carry  

// Will look like this when carry set but no overflow
//    9999 + 0001 = (C) 0000
// Will look like this when no carry and no overflow
//    0001 - 0002 = 0003
.macro print_bcd_adc16(op1, op2, result, expected_result, expect_carry_set)
{
    lda #1
    sta passed 

    //nv_screen_print_bcd_word_mem(op1)
    nv_xfer16_mem_mem(op1, word_to_print)
    jsr PrintHexWord

    nv_screen_print_str(plus_str)

    //nv_screen_print_bcd_word_mem(op2)
    nv_xfer16_mem_mem(op2, word_to_print)
    jsr PrintHexWord

    nv_screen_print_str(equal_str)

    nv_bcd_adc16(op1, op2, result)
    php
    nv_beq16_immed(result, expected_result, ResultGood)
    lda #0 
    sta passed

ResultGood:
    //nv_screen_print_bcd_word_mem(result)
    nv_xfer16_mem_mem(result, word_to_print)
    jsr PrintHexWord
    plp
    pass_or_fail_carry(expect_carry_set)
    jsr PrintPassed
}



//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified addition at the current curor location
// nv_bcd_adc16 is used to do the addition.
// C, will show up to indicate the carry  

// Will look like this when carry set but no overflow
//    9999 + 0001 = (C) 0000
// Will look like this when no carry and no overflow
//    0001 - 0002 = 0003
.macro print_bcd_adc16_immed(op1, num, result, expected_result, 
                                 expect_carry_set)
{
    //nv_screen_print_bcd_word_mem(op1)
    nv_xfer16_mem_mem(op1, word_to_print)
    jsr PrintHexWord
    
    nv_screen_print_str(plus_str)
    
    //nv_screen_print_bcd_word_immed(num)
    nv_store16_immed(word_to_print, num)
    jsr PrintHexWord

    nv_screen_print_str(equal_str)

    nv_bcd_adc16_mem_immed(op1, num, result)
    php
    nv_beq16_immed(result, expected_result, ResultGood)
    lda #0 
    sta passed

ResultGood:
    //nv_screen_print_bcd_word_mem(result)
    nv_xfer16_mem_mem(result, word_to_print)
    jsr PrintHexWord
    plp
    pass_or_fail_carry(expect_carry_set)
    jsr PrintPassed
}

//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified subtraction at the current curor
// location nv_bcd_sbc16 is used to do the subtraction.
.macro print_bcd_sbc16(op1, op2, result, expected_result, expect_carry_set)
{
    lda #1
    sta passed 

    //nv_screen_print_bcd_word_mem(op1)
    nv_xfer16_mem_mem(op1, word_to_print)
    jsr PrintHexWord

    nv_screen_print_str(minus_str)

    //nv_screen_print_bcd_word_mem(op2)
    nv_xfer16_mem_mem(op2, word_to_print)
    jsr PrintHexWord

    nv_screen_print_str(equal_str)

    nv_bcd_sbc16(op1, op2, result)
    php
    nv_beq16_immed(result, expected_result, ResultGood)
    lda #0 
    sta passed

ResultGood:
    //nv_screen_print_bcd_word_mem(result)
    nv_xfer16_mem_mem(result, word_to_print)
    jsr PrintHexWord
    plp
    pass_or_fail_carry(expect_carry_set)
    jsr PrintPassed
}

//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified subtraction at the current curor
// location nv_bcd_sbc16_mem_immed is used to do the subtraction.
.macro print_bcd_sbc16_immed(op1, num, result, expected_result, 
                             expect_carry_set)
{
    lda #1
    sta passed 

    //nv_screen_print_bcd_word_mem(op1)
    nv_xfer16_mem_mem(op1, word_to_print)
    jsr PrintHexWord

    nv_screen_print_str(minus_str)

    nv_store16_immed(word_to_print, num)
    jsr PrintHexWord

    nv_screen_print_str(equal_str)

    nv_bcd_sbc16_mem_immed(op1, num, result)
    php
    nv_beq16_immed(result, expected_result, ResultGood)
    lda #0 
    sta passed

ResultGood:
    //nv_screen_print_bcd_word_mem(result)
    nv_xfer16_mem_mem(result, word_to_print)
    jsr PrintHexWord
    plp
    pass_or_fail_carry(expect_carry_set)
    jsr PrintPassed
}



#import "../test_util/test_util_code.asm"