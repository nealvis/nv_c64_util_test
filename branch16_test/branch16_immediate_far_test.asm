//////////////////////////////////////////////////////////////////////////////
// branch16_immediate_test_far.asm
// Copyright(c) 2021 Neal Smith.
// License: MIT. See LICENSE file in root directory.
//////////////////////////////////////////////////////////////////////////////
// This program demonstrates and tests the 16 bit conditional macros 
// with immediate values in the nv_branch16_macs.asm

// import all nv_c64_util macros and data.  The data
// will go in default place
#import "../../nv_c64_util/nv_c64_util_macs_and_data.asm"
// move nv_c64_util_data closer to end of basic than the default so can
// fit more tests
//*=$9E34
//#import "../../nv_c64_util/nv_c64_util_data.asm"

// import the nv_c64_util macros 
//#import "../../nv_c64_util/nv_c64_util_macs.asm"




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
//        .byte $20, $28, $34, $30, $39, $36, $29 // ASCII for " (4096)"
        .byte $20, $28, $32, $33, $33, $36, $29 // ASCII for " (2336 aka $0920)"

        .byte $00, $00, $00      // end of basic program (addr $080E from above)

*=$0820 "Vars"

.const dollar_sign = $24
.const CMP_EQUAL = 0
.const CMP_LESS = -1
.const CMP_GREATER = 1


// program variables
equal_str: .text@" = \$00"
not_equal_str: .text@" != \$00"
greater_equal_str: .text@" >= \$00" 
less_than_str: .text@" < \$00"
greater_than_str: .text@" > \$00"
less_equal_str: .text@" <= \$00" 

title_str: .text @"BR16 IMMED FAR\$00"          // null terminated string to print
                                                // via the BASIC routine
title_beq16_immediate_str: .text @"TEST BEQ16 IMMED FAR\$00"
title_bne16_immediate_str: .text @"TEST BNE16 IMMED FAR\$00"
title_blt16_immediate_str: .text @"TEST BLT16 IMMED FAR\$00"
title_ble16_immediate_str: .text @"TEST BLE16 IMMED FAR\$00"
title_bgt16_immediate_str: .text @"TEST BGT16 IMMED FAR\$00"
title_bge16_immediate_str: .text @"TEST BGE16 IMMED FAR\$00"

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


*=$0920 "Main Start"

.var row = 0

    nv_screen_print_str(normal_control_str)
    nv_screen_clear()
    nv_screen_plot_cursor(row++, 25)
    nv_screen_print_str(title_str)

    test_beq16_immediate(0)
    test_bne16_immediate(0)
    test_blt16_immediate(0)
    test_ble16_immediate(0)
    test_bgt16_immediate(0)
    test_bge16_immediate(0)

    rts


//////////////////////////////////////////////////////////////////////////////
//
.macro test_beq16_immediate(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_beq16_immediate_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16_immed(opSmall, $BEEF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16_immed(op1Beef, $BEEF, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16_immed(opZero, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16_immed(opMax, $FFFF, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16_immed(opTwo, $0001, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16_immed(opTwo, $0002, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16_immed(opOne, $0002, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16_immed(opOne, $0001, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16_immed(opMax, $0000, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16_immed(opMax, $FFFE, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16_immed(opHighOnes, $FFFF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16_immed(opHighOnes, $FF00, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16_immed(opHighOnes, $FF01, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16_immed(opLowOnes, $FF01, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16_immed(opLowOnes, $01FF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16_immed(opLowOnes, $FF00, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16_immed(opLowOnes, $FE, false)


    wait_and_clear_at_row(row, title_str)
}

//////////////////////////////////////////////////////////////////////////////
//
.macro test_bne16_immediate(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_bne16_immediate_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16_immed(opSmall, $BEEF, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16_immed(op1Beef, $BEEF, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16_immed(opZero, $0000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16_immed(opMax, $FFFF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16_immed(opTwo, $0001, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16_immed(opTwo, $0002, false)


    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16_immed(opOne, $0002, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16_immed(opOne, $0001, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16_immed(opMax, $0000, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16_immed(opMax, $FFFE, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16_immed(opHighOnes, $FFFF, true)
/*
    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16_immed(opHighOnes, $FF00, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16_immed(opHighOnes, $FF01, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16_immed(opLowOnes, $FF01, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16_immed(opLowOnes, $01FF, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16_immed(opLowOnes, $FF00, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16_immed(opLowOnes, $FE, true)
*/
    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_blt16_immediate(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_blt16_immediate_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16_immed(opSmall, $BEEF, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16_immed(op1Beef, $BEEF, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16_immed(opSmall, $D3B0, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16_immed(opZero, $0000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16_immed(opMax, $FFFF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16_immed(opTwo, $0001, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16_immed(opTwo, $0002, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16_immed(opOne, $0002, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16_immed(opOne, $0001, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16_immed(opMax, $0000, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16_immed(opMax, $FFFE, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16_immed(opHighOnes, $FFFF, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16_immed(opHighOnes, $FF00, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16_immed(opHighOnes, $FF01, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16_immed(opLowOnes, $FF01, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16_immed(opLowOnes, $01FF, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16_immed(opLowOnes, $FF00, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16_immed(opLowOnes, $FE, false)


    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_ble16_immediate(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_ble16_immediate_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16_immed(opSmall, $BEEF, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16_immed(op1Beef, $BEEF, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16_immed(opSmall, $D3B0, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16_immed(opZero, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16_immed(opMax, $FFFF, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16_immed(opTwo, $0001, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16_immed(opTwo, $0002, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16_immed(opOne, $0002, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16_immed(opOne, $0001, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16_immed(opMax, $0000, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16_immed(opMax, $FFFE, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16_immed(opHighOnes, $FFFF, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16_immed(opHighOnes, $FF00, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16_immed(opHighOnes, $FF01, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16_immed(opLowOnes, $FF01, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16_immed(opLowOnes, $01FF, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16_immed(opLowOnes, $FF00, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16_immed(opLowOnes, $FE, false)


    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_bgt16_immediate(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_bgt16_immediate_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16_immed(opSmall, $BEEF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16_immed(op1Beef, $BEEF, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16_immed(opSmall, $D3B0, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16_immed(opZero, $0000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16_immed(opMax, $FFFF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16_immed(opTwo, $0001, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16_immed(opTwo, $0002, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16_immed(opOne, $0002, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16_immed(opOne, $0001, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16_immed(opMax, $0000, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16_immed(opMax, $FFFE, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16_immed(opHighOnes, $FFFF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16_immed(opHighOnes, $FF00, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16_immed(opHighOnes, $FF01, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16_immed(opLowOnes, $FF01, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16_immed(opLowOnes, $01FF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16_immed(opLowOnes, $FF00, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16_immed(opLowOnes, $FE, true)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_bge16_immediate(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_bge16_immediate_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16_immed(opSmall, $BEEF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16_immed(op1Beef, $BEEF, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16_immed(opSmall, $D3B0, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16_immed(opZero, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16_immed(opMax, $FFFF, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16_immed(opTwo, $0001, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16_immed(opTwo, $0002, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16_immed(opOne, $0002, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16_immed(opOne, $0001, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16_immed(opMax, $0000, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16_immed(opMax, $FFFE, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16_immed(opHighOnes, $FFFF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16_immed(opHighOnes, $FF00, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16_immed(opHighOnes, $FF01, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16_immed(opLowOnes, $FF01, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16_immed(opLowOnes, $01FF, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16_immed(opLowOnes, $FF00, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16_immed(opLowOnes, $FE, true)

    wait_and_clear_at_row(row, title_str)
}



//////////////////////////////////////////////////////////////////////////////
//                          Print macros 
//////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either = or != ) 
// for the relationship of one word in memory with an immediate 16 bit value
// Also use beq16 to do it.
//   addr1: is the address of LSB of one word (addr1+1 is MSB)
//   num: is the immediate value
.macro print_beq16_immed(addr1, num, expect_to_branch)
{
    lda #1
    sta passed

    //nv_screen_print_hex_word_mem(addr1, true)
    nv_xfer16_mem_mem(addr1, word_to_print)
    jsr PrintHexWord

    nv_beq16_immed_far(addr1, num, BranchTarget)
    .if (expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(not_equal_str)
    jmp Done
    // nops to make sure more than 128 bytes between branch and target label
    .var index = 0
    .for(index = 0; index < 124; index = index + 1) {nop}

BranchTarget:
    .if (!expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(equal_str)

Done:
    //nv_screen_print_hex_word_immed(num, true)
    nv_store16_immed(word_to_print, num)
    jsr PrintHexWord

    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either != or = ) 
// for the relationship of one word in memory with an immediate 16 bit value
// Use bne16_immed_far to do it.
//   addr1: is the address of LSB of one word (addr1+1 is MSB)
//   num: is the immediate value
.macro print_bne16_immed(addr1, num, expect_to_branch)
{
    lda #1
    sta passed

    //nv_screen_print_hex_word_mem(addr1, true)
    nv_xfer16_mem_mem(addr1, word_to_print)
    jsr PrintHexWord

    nv_bne16_immed_far(addr1, num, BranchTarget)
    .if (expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(equal_str)
    jmp Done
    // nops to make sure more than 128 bytes between branch and target label
    .var index = 0
    .for(index = 0; index < 124; index = index + 1) {nop}

BranchTarget:
    .if (!expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(not_equal_str)

Done:
    //nv_screen_print_hex_word_immed(num, true)
    nv_store16_immed(word_to_print, num)
    jsr PrintHexWord

    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
.macro print_blt16_immed(addr1, num, expect_to_branch)
{
    lda #1 
    sta passed
    //nv_screen_print_hex_word_mem(addr1, true)
    nv_xfer16_mem_mem(addr1, word_to_print)
    jsr PrintHexWord
    
    nv_blt16_immed_far(addr1, num, BranchTarget)
    .if (expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(greater_equal_str)
    jmp Done
    // nops to make sure more than 128 bytes between branch and target label
    .var index = 0
    .for(index = 0; index < 124; index = index + 1) {nop}

BranchTarget:
    .if (!expect_to_branch)
    {
        lda #0 
        sta passed
    }

    nv_screen_print_str(less_than_str)

Done:
    //nv_screen_print_hex_word_immed(num, true)
    nv_store16_immed(word_to_print, num)
    jsr PrintHexWord

    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
.macro print_ble16_immed(addr1, num, expect_to_branch)
{
    lda #1 
    sta passed
    //nv_screen_print_hex_word_mem(addr1, true)
    nv_xfer16_mem_mem(addr1, word_to_print)
    jsr PrintHexWord
    
    nv_ble16_immed_far(addr1, num, BranchTarget)
    .if (expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(greater_than_str)
    jmp Done
    // nops to make sure more than 128 bytes between branch and target label
    .var index = 0
    .for(index = 0; index < 124; index = index + 1) {nop}

BranchTarget:
    .if (!expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(less_equal_str)

Done:
    //nv_screen_print_hex_word_immed(num, true)
    nv_store16_immed(word_to_print, num)
    jsr PrintHexWord
    
    jsr PrintPassed
}

//////////////////////////////////////////////////////////////////////////////
.macro print_bgt16_immed(addr1, num, expect_to_branch)
{
    lda #1
    sta passed
    //nv_screen_print_hex_word_mem(addr1, true)
    nv_xfer16_mem_mem(addr1, word_to_print)
    jsr PrintHexWord

    nv_bgt16_immed_far(addr1, num, BranchTarget)
    .if (expect_to_branch)
    {
        lda #0 
        sta passed        
    }
    nv_screen_print_str(less_equal_str)
    jmp Done
    // nops to make sure more than 128 bytes between branch and target label
    .var index = 0
    .for(index = 0; index < 124; index = index + 1) {nop}

BranchTarget:
    .if (!expect_to_branch)
    {
        lda #0 
        sta passed        
    }

    nv_screen_print_str(greater_than_str)

Done:
    //nv_screen_print_hex_word_immed(num, true)
    nv_store16_immed(word_to_print, num)
    jsr PrintHexWord
    
    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
.macro print_bge16_immed(addr1, num, expect_to_branch)
{
    lda #1 
    sta passed

    //nv_screen_print_hex_word_mem(addr1, true)
    nv_xfer16_mem_mem(addr1, word_to_print)
    jsr PrintHexWord
    
    nv_bge16_immed_far(addr1, num, BranchTarget)
    .if (expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(less_than_str)
    jmp Done
    // nops to make sure more than 128 bytes between branch and target label
    .var index = 0
    .for(index = 0; index < 124; index = index + 1) {nop}

BranchTarget:
    .if (!expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(greater_equal_str)

Done:
    //nv_screen_print_hex_word_immed(num, true)
    nv_store16_immed(word_to_print, num)
    jsr PrintHexWord

    jsr PrintPassed
}


#import "../test_util/test_util_code.asm"

