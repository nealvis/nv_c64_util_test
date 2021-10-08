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

space_str: .text @" \$00"
passed_str: .text @" PASSED\$00"
failed_str: .text @" FAILED\$00"

fail_control_str: nv_screen_lite_red_fg_str()
pass_control_str: nv_screen_green_fg_str()
normal_control_str: nv_screen_white_fg_str()

passed: .byte 0
temp_byte: .byte 0


// program variables
bit_str: .text @" BIT \$00"
negated_str: .text @" NEGATED \$00"
equal_str: .text@" = \$00"
minus_str: .text@" - \$00"
transform_str: .text@" -> \$00"

bad_carry_str: .text@" C\$00"
bad_overflow_str: .text@" V\$00"
bad_neg_str: .text@" N\$00"

title_str: .text @"MATH8\$00"          // null terminated string to print
                                        // via the BASIC routine
title_mask_from_bit_num_mem_str: .text @"TEST MASK FROM BIT NUM MEM\$00"
title_mask_from_bit_num_a_str: .text @"TEST MASK FROM BIT NUM ACCUM\$00"
title_sbc8_mem_mem_str: .text @"TEST SBC8 MEM MEM\$00"
title_sbc8_mem_immed_str: .text @"TEST SBC8 MEM IMMED\$00"

title_twos_comp_a_str: .text @"TEST TWOS COMP A\$00"
title_twos_comp_mem_str: .text @"TEST TWOS COMP MEM\$00"

hit_anykey_str: .text @"HIT ANY KEY ...\$00"

word_to_print: .word $DEAD
another_word:  .word $BEEF

counter: .byte 0

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
op_7FFF: .word $7FFF
op_FFFE: .word $FFFE
op_0080: .word $0080 // 128
op_0081: .word $0081 // 129
op_8000: .word $8000 // high bit only set
op_FFFF: .word $FFFF // all bits

op8_7F: .byte $7F
op8_FF: .byte $FF
op8_0F: .byte $0F
op8_F0: .byte $F0
op8_80: .byte $80  // -128
op8_81: .byte $81  // -127
op8_FE: .byte $FE

op_00: .byte $00
op_01: .byte $01
op_02: .byte $02
op_03: .byte $03
op_04: .byte $04
op_05: .byte $05
op_06: .byte $06
op_07: .byte $07

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
    print_twos_comp_mem(op_01, $FF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_twos_comp_mem(op8_FF, $01)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_twos_comp_mem(op_00, $00)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_twos_comp_mem(op_02, $FE)

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


    wait_and_clear_at_row(row)

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
    print_twos_comp_a(op_01, $FF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_twos_comp_a(op8_FF, $01)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_twos_comp_a(op_00, $00)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_twos_comp_a(op_02, $FE)

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


    wait_and_clear_at_row(row)

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
    print_sbc8_mem_mem(op_01, op_00, $01, true, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)      // C      V      N
    print_sbc8_mem_mem(op_00, op_01, $FF, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)      // C      V      N
    print_sbc8_mem_mem(op_02, op8_FF, $03, false, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)      // C      V      N
    print_sbc8_mem_mem(op_02, op8_0F, $F3, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)      // C      V      N
    print_sbc8_mem_mem(op8_80, op_01, $7F, true, true, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)      // C      V      N
    print_sbc8_mem_mem(op8_80, op8_7F, $01, true, true, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)      // C      V     N
    print_sbc8_mem_mem(op_00, op_00, $00, true, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_mem(op_00, op8_FF, $01, false, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_mem(op_00, op8_7F, $81, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_mem(op_00, op8_FE, $02, false, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_mem(op8_FE, op_01, $FD, true, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_mem(op8_FF, op8_7F, $80, true, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_mem(op_02, op_01, $01,   true,  false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_mem(op_01, op_02, $FF,   false,  false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)         // C      V     N
    print_sbc8_mem_mem(op8_80, op_01, $7F,   true,  true, false)

    wait_and_clear_at_row(row)
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
    print_sbc8_mem_immed(op_01, $00, $01, true, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)      // C      V      N
    print_sbc8_mem_immed(op_00, $01, $FF, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)      // C      V      N
    print_sbc8_mem_immed(op_02, $FF, $03, false, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)      // C      V      N
    print_sbc8_mem_immed(op_02, $0F, $F3, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)      // C      V      N
    print_sbc8_mem_immed(op8_80, $01, $7F, true, true, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)      // C      V      N
    print_sbc8_mem_immed(op8_80, $7F, $01, true, true, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)      // C      V     N
    print_sbc8_mem_immed(op_00, $00, $00, true, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_immed(op_00, $FF, $01, false, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_immed(op_00, $7F, $81, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_immed(op_00, $FE, $02, false, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_immed(op8_FE, $01, $FD, true, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_immed(op8_FF, $7F, $80, true, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_immed(op_02, $01, $01,   true,  false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)        // C      V     N
    print_sbc8_mem_immed(op_01, $02, $FF,   false,  false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)         // C      V     N
    print_sbc8_mem_immed(op8_80, $01, $7F,   true,  true, false)

    wait_and_clear_at_row(row)
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
    print_mask_from_bit_num_mem(op_00, $01)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_mem(op_01, $02)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_mem(op_02, $04)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_mem(op_03, $08)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_mem(op_04, $10)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_mem(op_05, $20)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_mem(op_06, $40)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_mem(op_07, $80)

    wait_and_clear_at_row(row)
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
    print_mask_from_bit_num_a(op_00, $01, $FE)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_a(op_01, $02, $FD)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_a(op_02, $04, ~$04)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_a(op_03, $08, ~$08)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_a(op_04, $10, ~$10)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_a(op_05, $20, ~$20)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_a(op_06, $40, ~$40)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mask_from_bit_num_a(op_07, $80, ~$80)

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

    nv_key_wait_any_key()

    nv_screen_clear()
    .eval row=0
    nv_screen_plot_cursor(row++, 33)
    nv_screen_print_str(title_str)
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
