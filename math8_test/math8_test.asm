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

fail_control_str: nv_screen_red_fg_str()
pass_control_str: nv_screen_green_fg_str()
normal_control_str: nv_screen_white_fg_str()

passed: .byte 0
temp_byte: .byte 0


// program variables
bit_str: .text @" BIT \$00"
negated_str: .text @" NEGATED \$00"
equal_str: .text@" = \$00"

title_str: .text @"MATH8\$00"          // null terminated string to print
                                        // via the BASIC routine
title_mask_from_bit_num_mem_str: .text @"TEST MASK FROM BIT NUM MEM\$00"
title_mask_from_bit_num_a_str: .text @"TEST MASK FROM BIT NUM ACCUM\$00"
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

op_00: .byte $00
op_01: .byte $01
op_02: .byte $02
op_03: .byte $03
op_04: .byte $04
op_05: .byte $05
op_06: .byte $06
op_07: .byte $07


*=$1000 "Main Start"

.var row = 0

    nv_screen_print_str(normal_control_str)
    nv_screen_clear()
    nv_screen_plot_cursor(row++, 33)
    nv_screen_print_str(title_str)

    test_mask_from_bit_num_mem(0)
    test_mask_from_bit_num_a(0)

    rts


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
    //sta temp_byte
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
    //sta temp_byte
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


PrintHexByteAccum:
{
    nv_screen_print_hex_byte_a(true)
    rts
}


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
