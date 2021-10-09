//////////////////////////////////////////////////////////////////////////////
// branch16_far_test.asm
// Copyright(c) 2021 Neal Smith.
// License: MIT. See LICENSE file in root directory.
//////////////////////////////////////////////////////////////////////////////
// This program demonstrates and tests the 16bit branch operations 
// in nv_branch16_macs.asm that branch to far labels

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
//        .byte $20, $28, $34, $30, $39, $36, $29 // ASCII for " (4096)"
        .byte $20, $28, $32, $33, $30, $34, $29 // ASCII for " (2304)"
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

title_str: .text @"B16 FAR\$00"          // null terminated string to print
                                        // via the BASIC routine
title_beq16_str: .text @"TEST BEQ16 FAR \$00"
title_bne16_str: .text @"TEST BNE16 FAR \$00"
title_blt16_str: .text @"TEST BLT16 FAR \$00"
title_ble16_str: .text @"TEST BLE16 FAR \$00"
title_bgt16_str: .text @"TEST BGT16 FAR \$00"
title_bge16_str: .text @"TEST BGE16 FAR \$00"

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


*=$0900 "Main Start"

.var row = 0

    nv_screen_print_str(normal_control_str)
    nv_screen_clear()
    nv_screen_plot_cursor(row++, 31)
    nv_screen_print_str(title_str)

    test_beq16(0)
    test_bne16(0)
    test_blt16(0)
    test_ble16(0)
    test_bgt16(0)
    test_bge16(0)

    rts


//////////////////////////////////////////////////////////////////////////////
//
.macro test_beq16(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_beq16_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16(op1Beef, op2Beef, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16(opSmall, opBig, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16(opBig, opSmall, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16(opOne, opZero, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16(opOne, opMax, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16(opZero, opMax, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16(opMax, opOne, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16(opMax, opZero, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16(opMax, opMax, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16(opOne, opOne, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16(opZero, opZero, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16(opHighOnes, opLowOnes, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16(opLowOnes, opHighOnes, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16(opHighOnes, opHighOnes, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq16(opLowOnes, opLowOnes, true)

    wait_and_clear_at_row(row, title_str)
}

//////////////////////////////////////////////////////////////////////////////
//
.macro test_bne16(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_bne16_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16(op1Beef, op2Beef, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16(opSmall, opBig, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16(opBig, opSmall, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16(opSmall, opSmall, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16(opOne, opZero, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16(opOne, opMax, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16(opZero, opMax, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16(opHighOnes, opLowOnes, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne16(opLowOnes, opHighOnes, true)

    wait_and_clear_at_row(row, title_str)
}



//////////////////////////////////////////////////////////////////////////////
//
.macro test_blt16(init_row)
{
    .var row = init_row
        
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_blt16_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16(op1Beef, op2Beef, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16(opSmall, opBig, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16(opBig, opSmall, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16(opSmall, opSmall, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16(opTwo, opOne, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16(opOne, opZero, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16(opOne, opMax, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16(opZero, opMax, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16(opZero, opOne, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16(opMax, opOne, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16(opMax, opZero, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16(opMax, opMax, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16(opOne, opOne, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16(opZero, opZero, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16(opHighOnes, opLowOnes, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16(opLowOnes, opHighOnes, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16(opHighOnes, opHighOnes, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt16(opLowOnes, opLowOnes, false)

    wait_and_clear_at_row(row, title_str)
}


.macro test_ble16(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_ble16_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(op1Beef, op2Beef, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opSmall, opBig, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opBig, opSmall, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opSmall, opSmall, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opBig, opSmall, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opTwo, opOne, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opOne, opZero, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opOne, opMax, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opZero, opMax, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opZero, opOne, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opMax, opOne, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opMax, opZero, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opMax, opMax, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opOne, opOne, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opZero, opZero, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opHighOnes, opLowOnes, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opLowOnes, opHighOnes, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opHighOnes, opHighOnes, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble16(opLowOnes, opLowOnes, true)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_bgt16(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_bgt16_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(op1Beef, op2Beef, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opSmall, opBig, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opBig, opSmall, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opSmall, opSmall, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opTwo, opOne, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opOne, opZero, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opOne, opMax, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opZero, opMax, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opZero, opOne, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opMax, opOne, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opMax, opZero, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opMax, opMax, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opOne, opOne, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opZero, opZero, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opHighOnes, opLowOnes, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opLowOnes, opHighOnes, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opHighOnes, opHighOnes, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt16(opLowOnes, opLowOnes, false)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_bge16(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_bge16_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(op1Beef, op2Beef, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opSmall, opBig, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opBig, opSmall, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opSmall, opSmall, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opTwo, opOne, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opOne, opZero, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opOne, opMax, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opZero, opMax, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opZero, opOne, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opMax, opOne, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opMax, opZero,true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opMax, opMax, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opOne, opOne, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opZero, opZero, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opHighOnes, opLowOnes, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opLowOnes, opHighOnes, false)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opHighOnes, opHighOnes, true)

    ////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge16(opLowOnes, opLowOnes, true)

    wait_and_clear_at_row(row, title_str)
}



//////////////////////////////////////////////////////////////////////////////
//                          Print macros 
//////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either = or != ) 
// for the relationship of the two word in memorys.  Use beq16 to do it.
//   addr1: is the address of LSB of one word (addr1+1 is MSB)
//   addr2: is the address of LSB of the other word (addr2+1 is MSB)
.macro print_beq16(addr1, addr2, expect_to_branch)
{
    lda #1 
    sta passed
    //nv_screen_print_hex_word_mem(addr1, true)
    nv_xfer16_mem_mem(addr1, word_to_print)
    jsr PrintHexWord

    nv_beq16_far(addr1, addr2, BranchTarget)
    .if (expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(not_equal_str)
    jmp Done
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
    //nv_screen_print_hex_word_mem(addr2, true)
    nv_xfer16_mem_mem(addr2, word_to_print)
    jsr PrintHexWord
    
    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either != or = ) 
// for the relationship of the two word in memorys.  Use bne16 to do it.
//   addr1: is the address of LSB of one word (addr1+1 is MSB)
//   addr2: is the address of LSB of the other word (addr2+1 is MSB)
.macro print_bne16(addr1, addr2, expect_to_branch)
{
    lda #1 
    sta passed
    
    //nv_screen_print_hex_word_mem(addr1, true)
    nv_xfer16_mem_mem(addr1, word_to_print)
    jsr PrintHexWord

    nv_bne16_far(addr1, addr2, BranchTarget)
    .if (expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(equal_str)
    jmp Done
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
    //nv_screen_print_hex_word_mem(addr2, true)
    nv_xfer16_mem_mem(addr2, word_to_print)
    jsr PrintHexWord

    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either < or >= ) 
// for the relationship of the two word in memorys.  Use blt16 to do it.
//   addr1: is the address of LSB of word1 (addr1+1 is MSB)
//   addr2: is the address of LSB of word2 (addr2+1 is MSB)
.macro print_blt16(addr1, addr2, expect_to_branch)
{
    lda #1 
    sta passed

    //nv_screen_print_hex_word_mem(addr1, true)
    nv_xfer16_mem_mem(addr1, word_to_print)
    jsr PrintHexWord

    nv_blt16_far(addr1, addr2, BranchTarget)
    .if (expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(greater_equal_str)
    jmp Done
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
    //nv_screen_print_hex_word_mem(addr2, true)
    nv_xfer16_mem_mem(addr2, word_to_print)
    jsr PrintHexWord
    
    jsr PrintPassed
}



//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either <= or >)
// for the relationship of the two word in memorys.  Use ble16 to do it.
//   addr1: is the address of LSB of word1 (addr1+1 is MSB)
//   addr2: is the address of LSB of word2 (addr2+1 is MSB)
.macro print_ble16(addr1, addr2, expect_to_branch)
{
    lda #1 
    sta passed

    //nv_screen_print_hex_word_mem(addr1, true)
    nv_xfer16_mem_mem(addr1, word_to_print)
    jsr PrintHexWord
    
    nv_ble16_far(addr1, addr2, BranchTarget)
    .if (expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(greater_than_str)
    jmp Done
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
    //nv_screen_print_hex_word_mem(addr2, true)
    nv_xfer16_mem_mem(addr2, word_to_print)
    jsr PrintHexWord
    
    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either > or <= ) 
// for the relationship of the two word in memorys.  Use bgt16 to do it.
//   addr1: is the address of LSB of word1 (addr1+1 is MSB)
//   addr2: is the address of LSB of word2 (addr2+1 is MSB)
.macro print_bgt16(addr1, addr2, expect_to_branch)
{
    lda #1
    sta passed

    //nv_screen_print_hex_word_mem(addr1, true)
    nv_xfer16_mem_mem(addr1, word_to_print)
    jsr PrintHexWord

    nv_bgt16_far(addr1, addr2, BranchTarget)
    .if (expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(less_equal_str)
    jmp Done
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
    //nv_screen_print_hex_word_mem(addr2, true)
    nv_xfer16_mem_mem(addr2, word_to_print)
    jsr PrintHexWord
    
    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either >= or <)
// for the relationship of the two word in memorys.  Use bge16 to do it.
//   addr1: is the address of LSB of word1 (addr1+1 is MSB)
//   addr2: is the address of LSB of word2 (addr2+1 is MSB)
.macro print_bge16(addr1, addr2, expect_to_branch)
{
    lda #1 
    sta passed

    //nv_screen_print_hex_word_mem(addr1, true)
    nv_xfer16_mem_mem(addr1, word_to_print)
    jsr PrintHexWord

    nv_bge16_far(addr1, addr2, BranchTarget)
    .if (expect_to_branch)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(less_than_str)
    jmp Done
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
    //nv_screen_print_hex_word_mem(addr2, true)
    nv_xfer16_mem_mem(addr2, word_to_print)
    jsr PrintHexWord

    jsr PrintPassed
}

#import "../test_util/test_util_code.asm"


