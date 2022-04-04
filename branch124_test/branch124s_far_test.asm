//////////////////////////////////////////////////////////////////////////////
// branch124s_far_test.asm
// Copyright(c) 2022 Neal Smith.
// License: MIT. See LICENSE file in root directory.
//////////////////////////////////////////////////////////////////////////////
// This program demonstrates and tests the fixed point 12.4s branch far 
// operations in nv_branch124_macs.asm

// import all nv_c64_util macros and data.  The data
// will go in default place
#import "../../nv_c64_util/nv_c64_util_macs_and_data.asm"
#import "../../nv_c64_util_test/test_util/test_util_op124_data.asm"
//#import "../../nv_c64_util/nv_screen_macs.asm"
//#import "../../nv_c64_util/nv_keyboard_macs.asm"

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

title_str: .text @"BRANCH124S FAR\$00"          // null terminated string to print
                                           // via the BASIC routine
title_cmp124s_str: .text @"TEST CMP124S FAR \$00"
title_beq124s_str: .text @"TEST BEQ124S FAR \$00"
title_bne124s_str: .text @"TEST BNE124S FAR \$00"
title_blt124s_str: .text @"TEST BLT124S FAR \$00"
title_ble124s_str: .text @"TEST BLE124S FAR \$00"
title_bgt124s_str: .text @"TEST BGT124S FAR \$00"
title_bge124s_str: .text @"TEST BGE124S FAR \$00"

result: .word $0000

op1: .word $FFFF
op2: .word $FFFF
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


*=$1000 "Main Start"

.var row = 0

    nv_screen_print_str(normal_control_str)
    nv_screen_clear()
    nv_screen_plot_cursor(row++, 23)
    nv_screen_print_str(title_str)

    // signed tests
    test_beq124s(0)
    test_bne124s(0)
    test_blt124s(0)
    test_ble124s(0)
    test_bgt124s(0)
    test_bge124s(0)

    rts


//////////////////////////////////////////////////////////////////////////////
// Test the beq124s macro
.macro test_beq124s(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_beq124s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124(true, op124_0000, op124_0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124(true, op124_0000, op124_8000, true)
    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124(true, op124_8000, op124_0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124(true, op124_8000, op124_8000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124(true, op124_8030, op124_0030, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124(true, op124_0030, op124_8030, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124(true, op124_0038, op124_0038, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124(true, op124_FE00, op124_7E00, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124(true, op124_FE00, op124_FE00, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124(true, op124_7E00, op124_7E00, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124(true, op124_8034, op124_0034, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124(true, op124_0034, op124_8034, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124(true, op124_0034, op124_0034, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_beq124(true, op124_8034, op124_8034, true)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
// Test the bne124s macro
.macro test_bne124s(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_bne124s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124(true, op124_0000, op124_0000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124(true, op124_0000, op124_8000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124(true, op124_8000, op124_0000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124(true, op124_8000, op124_8000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124(true, op124_8030, op124_0030, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124(true, op124_0030, op124_8030, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124(true, op124_0030, op124_0031, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124(true, op124_8030, op124_8031, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124(true, op124_FFFF, op124_FFF7, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124(true, op124_FFF7, op124_FFF7, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124(true, op124_FE00, op124_7E00, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124(true, op124_7E00, op124_7F00, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bne124(true, op124_7E00, op124_7E00, false)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
// Test the blt124s macro
.macro test_blt124s(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_blt124s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124(true, op124_0000, op124_0000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124(true, op124_0000, op124_8000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124(true, op124_8000, op124_0000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124(true, op124_8000, op124_8000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124(true, op124_8030, op124_0030, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124(true, op124_0030, op124_8030, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124(true, op124_0030, op124_0031, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124(true, op124_8030, op124_8031, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124(true, op124_FFFF, op124_FFF7, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124(true, op124_FFF7, op124_FFF7, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124(true, op124_FE00, op124_7E00, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124(true, op124_7E00, op124_7F00, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_blt124(true, op124_7E00, op124_7E00, false)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
// Test the ble124s macro
.macro test_ble124s(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_ble124s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124(true, op124_0000, op124_0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124(true, op124_0000, op124_8000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124(true, op124_8000, op124_0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124(true, op124_8000, op124_8000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124(true, op124_8030, op124_0030, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124(true, op124_0030, op124_8030, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124(true, op124_0030, op124_0031, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124(true, op124_8030, op124_8031, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124(true, op124_FFFF, op124_FFF7, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124(true, op124_FFF7, op124_FFF7, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124(true, op124_FE00, op124_7E00, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124(true, op124_7E00, op124_7F00, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ble124(true, op124_7E00, op124_7E00, true)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
// Test the bgt124s macro
.macro test_bgt124s(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_bgt124s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124(true, op124_0000, op124_0000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124(true, op124_0000, op124_8000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124(true, op124_8000, op124_0000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124(true, op124_8000, op124_8000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124(true, op124_8030, op124_0030, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124(true, op124_0030, op124_8030, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124(true, op124_0030, op124_0031, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124(true, op124_8030, op124_8031, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124(true, op124_FFFF, op124_FFF7, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124(true, op124_FFF7, op124_FFF7, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124(true, op124_FE00, op124_7E00, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124(true, op124_7E00, op124_7F00, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bgt124(true, op124_7E00, op124_7E00, false)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
// Test the bge124s macro
.macro test_bge124s(init_row)
{
    .var row = init_row

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_bge124s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124(true, op124_0000, op124_0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124(true, op124_0000, op124_8000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124(true, op124_8000, op124_0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124(true, op124_8000, op124_8000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124(true, op124_8030, op124_0030, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124(true, op124_0030, op124_8030, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124(true, op124_0030, op124_0031, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124(true, op124_8030, op124_8031, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124(true, op124_FFFF, op124_FFF7, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124(true, op124_FFF7, op124_FFF7, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124(true, op124_FE00, op124_7E00, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124(true, op124_7E00, op124_7F00, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_bge124(true, op124_7E00, op124_7E00, true)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//                          Print macros 
//////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either = or != ) 
// for the relationship of the two word in memorys.  Use beq124u to do it.
//   addr1: is the address of LSB of one fp124u (addr1+1 is MSB)
//   addr2: is the address of LSB of the other fp124u (addr2+1 is MSB)
.macro print_beq124(signed, addr1, addr2, expect_to_branch)
{
    lda #1 
    sta passed

    nv_xfer124_mem_mem(addr1, fp124_to_print)
    jsr PrintHexFP124
   
    .if (signed)
    {
        nv_beq124s_far(addr1, addr2, BranchTarget)
    }
    else
    {
        nv_beq124u_far(addr1, addr2, BranchTarget)
    }
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
    nv_xfer124_mem_mem(addr2, fp124_to_print)
    jsr PrintHexFP124

    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either != or = ) 
// for the relationship of the two word in memorys.  Use bne124u to do it.
//   addr1: is the address of LSB of one fp124u (addr1+1 is MSB)
//   addr2: is the address of LSB of the other fp124u (addr2+1 is MSB)
.macro print_bne124(signed, addr1, addr2, expect_to_branch)
{
    lda #1 
    sta passed

    nv_xfer124_mem_mem(addr1, fp124_to_print)
    jsr PrintHexFP124
    .if (signed)   
    {
        nv_bne124s_far(addr1, addr2, BranchTarget)
    }
    else
    {
        nv_bne124u_far(addr1, addr2, BranchTarget)
    }
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
    nv_xfer124_mem_mem(addr2, fp124_to_print)
    jsr PrintHexFP124

    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either < or >= ) 
// for the relationship of the two word in memorys.  Use blt124u to do it.
//   addr1: is the address of LSB of fp124 s/u (addr1+1 is MSB)
//   addr2: is the address of LSB of other fp124 s/u (addr2+1 is MSB)
.macro print_blt124(signed, addr1, addr2, expect_to_branch)
{
    lda #1 
    sta passed

    nv_xfer124_mem_mem(addr1, fp124_to_print)
    jsr PrintHexFP124
       
    .if (signed)   
    {
        nv_blt124s_far(addr1, addr2, BranchTarget)
    }
    else
    {
        nv_blt124u_far(addr1, addr2, BranchTarget)
    }
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
    nv_xfer124_mem_mem(addr2, fp124_to_print)
    jsr PrintHexFP124

    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either <= or >)
// for the relationship of the two word in memorys.  Use ble124u to do it.
//   addr1: is the address of LSB of fp124u (addr1+1 is MSB)
//   addr2: is the address of LSB of another fp124u (addr2+1 is MSB)
.macro print_ble124(signed, addr1, addr2, expect_to_branch)
{
    lda #1 
    sta passed

    nv_xfer124_mem_mem(addr1, fp124_to_print)
    jsr PrintHexFP124
    
    .if (signed)   
    {
        nv_ble124s_far(addr1, addr2, BranchTarget)
    }
    else
    {
        nv_ble124u_far(addr1, addr2, BranchTarget)
    }
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
    nv_xfer124_mem_mem(addr2, fp124_to_print)
    jsr PrintHexFP124


    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either > or <= ) 
// for the relationship of the two word in memorys.  Use bgt124u to do it.
//   addr1: is the address of LSB of fp124u (addr1+1 is MSB
//   addr2: is the address of LSB of another fp124u (addr2+1 is MSB)
.macro print_bgt124(signed, addr1, addr2, expect_to_branch)
{
    lda #1
    sta passed

    nv_xfer124_mem_mem(addr1, fp124_to_print)
    jsr PrintHexFP124

    .if (signed)   
    {
        nv_bgt124s_far(addr1, addr2, BranchTarget)
    }
    else
    {
        nv_bgt124u_far(addr1, addr2, BranchTarget)
    }
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
    nv_xfer124_mem_mem(addr2, fp124_to_print)
    jsr PrintHexFP124
    
    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// Print to current screen location the expression (either >= or <)
// for the relationship of the two word in memorys.  Use bge124u to do it.
//   addr1: is the address of LSB of fp124u (addr1+1 is MSB)
//   addr2: is the address of LSB of another fp124u (addr2+1 is MSB)
.macro print_bge124(signed, addr1, addr2, expect_to_branch)
{
    lda #1 
    sta passed

    nv_xfer124_mem_mem(addr1, fp124_to_print)
    jsr PrintHexFP124
   
    .if (signed)   
    {
        nv_bge124s_far(addr1, addr2, BranchTarget)
    }
    else
    {
        nv_bge124u_far(addr1, addr2, BranchTarget)
    }

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
    nv_xfer124_mem_mem(addr2, fp124_to_print)
    jsr PrintHexFP124

    jsr PrintPassed
}


#import "../test_util/test_util_code.asm"

