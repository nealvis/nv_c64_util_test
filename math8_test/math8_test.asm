//////////////////////////////////////////////////////////////////////////////
// math8_test.asm
// Copyright(c) 2021 Neal Smith.
// License: MIT. See LICENSE file in root directory.
//////////////////////////////////////////////////////////////////////////////
// This program is a tester for nv_math8_*.asm files in the nv_c64_util
// repository

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

temp_byte: .byte 0

// program variables
bit_str: .text @" BIT \$00"
negated_str: .text @" NEGATED \$00"
equal_str: .text@" = \$00"
minus_str: .text@" - \$00"
transform_str: .text@" -> \$00"

title_str: .text @"MATH8\$00"          // null terminated string to print
                                        // via the BASIC routine
title_mask_from_bit_num_mem_str: .text @"TEST MASK FROM BIT NUM MEM\$00"
title_mask_from_bit_num_a_str: .text @"TEST MASK FROM BIT NUM ACCUM\$00"
title_sbc8_mem_mem_str: .text @"TEST SBC8 MEM MEM\$00"
title_sbc8_mem_immed_str: .text @"TEST SBC8 MEM IMMED\$00"

title_twos_comp_a_str: .text @"TEST TWOS COMP A\$00"
title_twos_comp_mem_str: .text @"TEST TWOS COMP MEM\$00"

#import "../test_util/test_util_op8_data.asm"


result_byte: .byte 0


*=$1000 "Main Start"

.var row = 0

    nv_screen_print_str(normal_control_str)
    nv_screen_clear()
    nv_screen_plot_cursor(row++, 33)
    nv_screen_print_str(title_str)

    test_twos_comp_mem(0)
    test_twos_comp_a(0)
    test_sbc8_mem_mem(0)
    test_sbc8_mem_immed(0)

    test_mask_from_bit_num_mem(0)
    test_mask_from_bit_num_a(0)

    rts
//////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////
//
.macro test_twos_comp_mem(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_twos_comp_mem_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_twos_comp_mem(op8_01, $FF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_twos_comp_mem(op8_FF, $01)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_twos_comp_mem(op8_00, $00)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_twos_comp_mem(op8_02, $FE)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_twos_comp_mem(op8_FE, $02)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_twos_comp_mem(op8_7F, $81)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_twos_comp_mem(op8_81, $7F)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_twos_comp_mem(op8_80, $80)


    wait_and_clear_at_row(row, title_str)

}



//////////////////////////////////////////////////////////////////////////////
//
.macro test_twos_comp_a(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_twos_comp_a_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_twos_comp_a(op8_01, $FF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_twos_comp_a(op8_FF, $01)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_twos_comp_a(op8_00, $00)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_twos_comp_a(op8_02, $FE)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_twos_comp_a(op8_FE, $02)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_twos_comp_a(op8_7F, $81)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_twos_comp_a(op8_81, $7F)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_twos_comp_a(op8_80, $80)


    wait_and_clear_at_row(row, title_str)

}

//////////////////////////////////////////////////////////////////////////////
//
.macro test_sbc8_mem_mem(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_sbc8_mem_mem_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    // carry, overflow, negative flags

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)     // C      V      N
    print_sbc8_mem_mem(op8_01, op8_00, $01, true, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)      // C      V      N
    print_sbc8_mem_mem(op8_00, op8_01, $FF, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)      // C      V      N
    print_sbc8_mem_mem(op8_02, op8_FF, $03, false, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)      // C      V      N
    print_sbc8_mem_mem(op8_02, op8_0F, $F3, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)      // C      V      N
    print_sbc8_mem_mem(op8_80, op8_01, $7F, true, true, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)      // C      V      N
    print_sbc8_mem_mem(op8_80, op8_7F, $01, true, true, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)      // C      V     N
    print_sbc8_mem_mem(op8_00, op8_00, $00, true, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_mem(op8_00, op8_FF, $01, false, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_mem(op8_00, op8_7F, $81, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_mem(op8_00, op8_FE, $02, false, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_mem(op8_FE, op8_01, $FD, true, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_mem(op8_FF, op8_7F, $80, true, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_mem(op8_02, op8_01, $01,   true,  false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_mem(op8_01, op8_02, $FF,   false,  false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)         // C      V     N
    print_sbc8_mem_mem(op8_80, op8_01, $7F,   true,  true, false)

    wait_and_clear_at_row(row, title_str)
}

//////////////////////////////////////////////////////////////////////////////
//
.macro test_sbc8_mem_immed(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_sbc8_mem_immed_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    // carry, overflow, negative flags

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)     // C      V      N
    print_sbc8_mem_immed(op8_01, $00, $01, true, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)      // C      V      N
    print_sbc8_mem_immed(op8_00, $01, $FF, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)      // C      V      N
    print_sbc8_mem_immed(op8_02, $FF, $03, false, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)      // C      V      N
    print_sbc8_mem_immed(op8_02, $0F, $F3, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)      // C      V      N
    print_sbc8_mem_immed(op8_80, $01, $7F, true, true, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)      // C      V      N
    print_sbc8_mem_immed(op8_80, $7F, $01, true, true, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)      // C      V     N
    print_sbc8_mem_immed(op8_00, $00, $00, true, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_immed(op8_00, $FF, $01, false, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_immed(op8_00, $7F, $81, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_immed(op8_00, $FE, $02, false, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_immed(op8_FE, $01, $FD, true, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_immed(op8_FF, $7F, $80, true, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_immed(op8_02, $01, $01,   true,  false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_immed(op8_01, $02, $FF,   false,  false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)         // C      V     N
    print_sbc8_mem_immed(op8_80, $01, $7F,   true,  true, false)

    wait_and_clear_at_row(row, title_str)
}

//////////////////////////////////////////////////////////////////////////////
//
.macro test_mask_from_bit_num_mem(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_mask_from_bit_num_mem_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_mem(op8_00, $01)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_mem(op8_01, $02)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_mem(op8_02, $04)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_mem(op8_03, $08)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_mem(op8_04, $10)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_mem(op8_05, $20)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_mem(op8_06, $40)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_mem(op8_07, $80)

    wait_and_clear_at_row(row, title_str)
}

//////////////////////////////////////////////////////////////////////////////
//
.macro test_mask_from_bit_num_a(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_mask_from_bit_num_a_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_a(op8_00, $01, $FE)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_a(op8_01, $02, $FD)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_a(op8_02, $04, ~$04)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_a(op8_03, $08, ~$08)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_a(op8_04, $10, ~$10)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_a(op8_05, $20, ~$20)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_a(op8_06, $40, ~$40)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_a(op8_07, $80, ~$80)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//                          Print macros 
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
.macro print_twos_comp_mem(addr1, expected_result)
{
    lda #1
    sta passed

    lda addr1
    sta temp_byte
    jsr PrintHexByteAccum  // print init accum before operation
    nv_screen_print_str(transform_str)

    nv_twos_comp8x_mem(temp_byte)
    lda temp_byte
    nv_beq8_immed_a(expected_result, GoodResult)
    ldx #0
    stx passed

GoodResult:
    lda temp_byte
    jsr PrintHexByteAccum  // print result of operation in accum
    jsr PrintPassed
}



//////////////////////////////////////////////////////////////////////////////
.macro print_twos_comp_a(addr1, expected_result)
{
    lda #1
    sta passed

    lda addr1
    jsr PrintHexByteAccum  // print init accum before operation
    nv_screen_print_str(transform_str)

    lda addr1
    nv_twos_comp8x_a()
    nv_beq8_immed_a(expected_result, GoodResult)
    ldx #0
    stx passed

GoodResult:
    jsr PrintHexByteAccum  // print result of operation in accum
    jsr PrintPassed
}

//////////////////////////////////////////////////////////////////////////////
.macro print_sbc8_mem_mem(addr1, addr2, expected_result, expect_carry_set, 
                          expect_overflow_set, expect_neg_set)
{
    lda #1
    sta passed
    lda addr1 
    jsr PrintHexByteAccum 
    nv_screen_print_str(minus_str)
    lda addr2   
    jsr PrintHexByteAccum
    nv_screen_print_str(equal_str)
    nv_sbc8x(addr1, addr2, result_byte)
    php
    lda result_byte
    nv_beq8_immed_a(expected_result, ResultGood)
    lda #0 
    sta passed

ResultGood:
    lda result_byte
    jsr PrintHexByteAccum

    plp
    pass_or_fail_status_flags(expect_carry_set, expect_overflow_set, 
                             expect_neg_set)
    
    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
.macro print_sbc8_mem_immed(addr1, num, expected_result, expect_carry_set, 
                          expect_overflow_set, expect_neg_set)
{
    lda #1
    sta passed
    lda addr1 
    jsr PrintHexByteAccum 
    nv_screen_print_str(minus_str)
    lda #num   
    jsr PrintHexByteAccum
    nv_screen_print_str(equal_str)
    nv_sbc8x_mem_immed(addr1, num, result_byte)
    php
    lda result_byte
    nv_beq8_immed_a(expected_result, ResultGood)
    lda #0 
    sta passed

ResultGood:
    lda result_byte
    jsr PrintHexByteAccum

    plp
    pass_or_fail_status_flags(expect_carry_set, expect_overflow_set, 
                             expect_neg_set)
    
    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified mask from bit number operation
// at the current cursor location
// nv_mask_from_bit_num is used to do the operation.  
// it will look like this
//    BIT $00 = MASK $01
//    BIT $01 = MASK $02
.macro print_mask_from_bit_num_mem(op1, expected_mask)
{
    .var expected_neg_mask = ~expected_mask
    lda #1
    sta passed
    nv_screen_print_str(bit_str)
    nv_screen_print_hex_byte_mem(op1, true)
    nv_screen_print_str(equal_str)

    nv_mask_from_bit_num_mem(op1, false)
    nv_beq8_immed_a(expected_mask, MaskGood)
    ldx #0 
    stx passed

MaskGood:    
    nv_screen_print_hex_byte_a(true)
    nv_screen_print_str(negated_str)
    nv_mask_from_bit_num_mem(op1, true)
    nv_beq8_immed_a(expected_neg_mask, NegMaskGood)
    ldx #0 
    stx passed
NegMaskGood:
    nv_screen_print_hex_byte_a(true)

    jsr PrintPassed
}

//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified mask from bit number operation
// at the current cursor location
// nv_mask_from_bit_num is used to do the operation.  
// it will look like this
//    BIT $00 = MASK $01
//    BIT $01 = MASK $02
.macro print_mask_from_bit_num_a(op1, expected_mask, expected_neg_mask)
{
    lda #1
    sta passed
    nv_screen_print_str(bit_str)
    nv_screen_print_hex_byte_mem(op1, true)
    nv_screen_print_str(equal_str)
    lda op1
    nv_mask_from_bit_num_a(false)
    sta temp_byte
    nv_beq8_immed_a(expected_mask, MaskGood)
    lda #0
    sta passed
    lda temp_byte
MaskGood:
    jsr PrintHexByteAccum
    //nv_screen_print_hex_byte_a(true)

    nv_screen_print_str(negated_str)
    lda op1
    nv_mask_from_bit_num_a(true)
    sta temp_byte
    nv_beq8_immed_a(expected_neg_mask, NegMaskGood)
    lda #0 
    sta passed
    lda temp_byte
NegMaskGood:
    jsr PrintHexByteAccum
    //nv_screen_print_hex_byte_a(true)

    jsr PrintPassed
}


#import "../test_util/test_util_code.asm"
