//////////////////////////////////////////////////////////////////////////////
// mul8_test.asm
// Copyright(c) 2021 Neal Smith.
// License: MIT. See LICENSE file in root directory.
//////////////////////////////////////////////////////////////////////////////
// This program is a tester for the 8 bit multiplication macros in
// nv_math8_*.asm files in the nv_c64_util repository

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
result16: .word $0000


// program variables
bit_str: .text @" BIT \$00"
times_str: .text @" * \$00"
equal_str: .text@" = \$00"
minus_str: .text@" - \$00"
transform_str: .text@" -> \$00"

title_str: .text @"MUL8\$00"          // null terminated string to print
                                        // via the BASIC routine
title_mul8_mem_mem_1_str: .text @"TEST MUL8 MEM MEM 1\$00"
title_mul8_mem_mem_2_str: .text @"TEST MUL8 MEM MEM 2\$00"
title_mul8_mem_mem_3_str: .text @"TEST MUL8 MEM MEM 3\$00"


title_mul8_immed_a_1_str: .text @"TEST MUL8 IMMED A 1\$00"

#import "../test_util/test_util_op8_data.asm"

*=$1000 "Main Start"

.var row = 0

    nv_screen_print_str(normal_control_str)
    nv_screen_clear()
    nv_screen_plot_cursor(row++, 33)
    nv_screen_print_str(title_str)

    test_mul8_mem_mem_1(0)
    test_mul8_mem_mem_2(0)
    test_mul8_mem_mem_3(0)

    test_mul8_immed_a_1(0)



    rts
//////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////
//
.macro test_mul8_immed_a_1(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_mul8_immed_a_1_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)   
    print_mul8_immed_a($01, op8_01, $0001, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_immed_a($01, op8_02, $0002, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_immed_a($02, op8_02, $0004, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_immed_a($07, op8_00, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_immed_a($00, op8_04, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_immed_a($00, op8_00, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_immed_a($00, op8_00, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_immed_a($01, op8_03, $0003, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_immed_a($FF, op8_FF, $FE01, false)

    wait_and_clear_at_row(row, title_str)

}




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
    nv_screen_plot_cursor(row++, 0) //         Z
    print_mul8_mem_mem(op8_01, op8_01, $0001, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //         Z
    print_mul8_mem_mem(op8_01, op8_02, $0002, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //         Z
    print_mul8_mem_mem(op8_02, op8_02, $0004, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //         Z
    print_mul8_mem_mem(op8_07, op8_00, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //         Z
    print_mul8_mem_mem(op8_00, op8_04, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //         Z
    print_mul8_mem_mem(op8_00, op8_00, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //         Z
    print_mul8_mem_mem(op8_01, op8_00, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //         Z
    print_mul8_mem_mem(op8_01, op8_03, $0003, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //         Z
    print_mul8_mem_mem(op8_FF, op8_FF, $FE01, false)

    wait_and_clear_at_row(row, title_str)

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
    print_mul8_mem_mem(op8_01, op8_00, $0000, true) // 0

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_01, $0001, false) // 1

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_02, $0002, false) // 2

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_04, $0004, false) // 4

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_08, $0008, false) // 8

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_10, $0010, false) // 16

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_20, $0020, false) //32

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_40, $0040, false) //64

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_80, $0080, false) //128

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_FF, op8_01, $00FF, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_FF, op8_02, $01FE, false)


    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_04, $0004, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_08, $0008, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_10, $0010, false) // 16

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_20, $0020, false) //32

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_40, $0040, false) //64

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_01, op8_80, $0080, false) //128

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_FF, op8_80, $7F80, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_99, op8_10, $0990, false)


    wait_and_clear_at_row(row, title_str)

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
    print_mul8_mem_mem(op8_01, op8_3F, $003F, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_02, op8_3F, $007E, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_03, op8_3F, $00BD, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_04, op8_3F, $00FC, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_05, op8_3F, $013B, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_06, op8_3F, $017A, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_3F, op8_01, $003F, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_3F, op8_02, $007E, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_3F, op8_03, $00BD, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_3F, op8_04, $00FC, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_3F, op8_05, $013B, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_3F, op8_06, $017A, false)




    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_7D, op8_02, $00FA, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_7D, op8_7D, $3D09, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_7D, op8_FF, $7C83, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_FF, op8_7D, $7C83, false)
  
    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_mul8_mem_mem(op8_FF, op8_FF, $FE01, false)


    wait_and_clear_at_row(row, title_str)

}


//////////////////////////////////////////////////////////////////////////////
//                          Print macros 
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
.macro print_mul8_mem_mem(addr1, addr2, expected_result, 
                          expect_zero_set)
{
    // set passed to true until evidence of a fail below
    lda #1
    sta passed

    // put some garbage in the result
    nv_store16_immed(result16, $BEEF)

    // print the first operand
    lda addr1
    jsr PrintHexByteAccum 

    // print multiplication operator *
    nv_screen_print_str(times_str)

    // print the second operand
    lda addr2
    jsr PrintHexByteAccum  // print result of operation in accum

    // print = sign
    nv_screen_print_str(equal_str)


    // do multiplication
    nv_mul8_mem_mem(addr1, addr2, result16, NV_PROCSTAT_ZERO)
    php  // save proc status flags on stack

    // if match expected result then skip setting passed to false
    nv_beq16_immed(result16, expected_result, GoodResult)
    ldx #0
    stx passed

GoodResult:

    // print the result
    //nv_screen_print_hex_word_mem(result16, true)
    nv_xfer16_mem_mem(result16, word_to_print)
    jsr PrintHexWord

    plp // pull processor status flags from stack back to register
    pass_or_fail_zero(expect_zero_set)   // check zero is right

    // print if passed or failed
    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
.macro print_mul8_immed_a(num, addr2, expected_result, expect_zero_set)
{
    // set passed to true until evidence of a fail below
    lda #1
    sta passed

    // put some garbage in the result
    nv_store16_immed(result16, $BEEF)

    // print the first operand
    lda #num
    jsr PrintHexByteAccum 

    // print multiplication operator *
    nv_screen_print_str(times_str)

    // print the second operand
    lda addr2
    jsr PrintHexByteAccum  // print result of operation in accum

    // print = sign
    nv_screen_print_str(equal_str)

    // do multiplication
    lda addr2
    nv_mul8_immed_a(num, result16, NV_PROCSTAT_ZERO)
    php // push processor status flags to stack

    // if match expected result then skip setting passed to false
    nv_beq16_immed(result16, expected_result, GoodResult)
    ldx #0
    stx passed

GoodResult:
    
    // print the result
    //nv_screen_print_hex_word_mem(result16, true)
    nv_xfer16_mem_mem(result16, word_to_print)
    jsr PrintHexWord

    plp // pull processor status flags back off the stack
    pass_or_fail_zero(expect_zero_set)   // check zero is right

    // print if passed or failed
    jsr PrintPassed
}


#import "../test_util/test_util_code.asm"

