//////////////////////////////////////////////////////////////////////////////
// string_test.asm
// Copyright(c) 2022 Neal Smith.
// License: MIT. See LICENSE file in root directory.
//////////////////////////////////////////////////////////////////////////////
// This program tests the string operations in the nv_c64_util 
// repository in the files that start with nv_string_  
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

// program variables
carry_str: .text @"(C) \$00"
carry_and_overflow_str:  .text @"(CV) \$00"
overflow_str:  .text @"(V) \$00"
plus_str: .text @"+\$00"
minus_str: .text @"-\$00"
equal_str: .text@"=\$00"
greater_than_str: .text@">\$00"
less_than_str: .text@"<\$00"
copy_str: .text@"->\$00"
dot_str: .text@".\$00"
quote_left_str: .text@"\$27\$00"
quote_right_str: .text@"\$27\$00"

// temp string used to print a char
temp_char_str: .word $0000

title_str: .text @"STRING\$00"         // null terminated string to print
                                        // via the BASIC routine
title_str_cmp: .text @"CMP\$00"
title_str_cpy: .text @"CPY\$00"
title_str_cat_char: .text @"CAT CHAR\$00"
title_str_trim_end: .text @"TRIM END \$00"

.const CMP_EQUAL = 0
.const CMP_LESS = -1
.const CMP_GREATER = 1


//#import "../test_util/test_util_op124_data.asm"
//#import "../test_util/test_util_op16_data.asm"
//#import "../test_util/test_util_op8_data.asm"
#import "../test_util/test_util_string_data.asm"


*=$1000 "Main Start"


.var row = 0

    nv_screen_print_str(normal_control_str)
    nv_screen_clear()
    nv_screen_plot_cursor(row++, 32)
    nv_screen_print_str(title_str)

    test_str_cmp(0)
    test_str_cpy(0)
    test_str_cat_a(0)
    test_str_trim_end(0)

    rts

//////////////////////////////////////////////////////////////////////////////
//
.macro test_str_cmp(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_str_cmp)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_str_cmp(opStr_ABCD, opStr_ABCD, result8, CMP_EQUAL)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_str_cmp(opStr_ABCD, opStr_EFGH, result8, CMP_LESS)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_str_cmp(opStr_EFGH, opStr_ABCD, result8, CMP_GREATER)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_str_cmp(opStr_ABCD, opStr_ABCZ, result8, CMP_LESS)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_str_cmp(opStr_ABCD, opStr_ABC, result8, CMP_GREATER)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_str_cmp(opStr_A, opStr_ABCD, result8, CMP_LESS)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_str_cmp(opStr_empty, opStr_empty, result8, CMP_EQUAL)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_str_cmp(opStr_empty, opStr_ABC, result8, CMP_LESS)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_str_cmp(opStr_EFGH, opStr_empty, result8, CMP_GREATER)

    wait_and_clear_at_row(row, title_str)
} 
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//
.macro test_str_cpy(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_str_cpy)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_str_cpy(opStr_ABCD, result_str)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_str_cpy(opStr_empty, result_str)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_str_cpy(opStr_A, result_str)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_str_cpy(opStr_0to9, result_str)

    wait_and_clear_at_row(row, title_str)
} 

//////////////////////////////////////////////////////////////////////////////
//
.macro test_str_cat_a(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_str_cat_char)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_str_cat_a(opStr_ABC, 'D', opStr_ABCD)  // $44 is 'D'

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_str_cat_a(opStr_empty, $41, opStr_A)  // $41 is 'A'

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_str_cat_a(opStr_EFG, 'H', opStr_EFGH)  

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_str_cat_a(opStr_0to9, 'A', opStr_0to9A)

    wait_and_clear_at_row(row, title_str)
} 


//////////////////////////////////////////////////////////////////////////////
//
.macro test_str_trim_end(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_str_trim_end)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_str_trim_end(opStr_ABCD, 'D', opStr_ABC)  

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_str_trim_end(opStr_012_pt_3400, '0', opStr_012_pt_34)  

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_str_trim_end(opStr_A, 'A', opStr_empty)  

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_str_trim_end(opStr_AA, 'A', opStr_empty)  

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_str_trim_end(opStr_AAA, 'A', opStr_empty)  

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_str_trim_end(opStr_empty, 'A', opStr_empty)  

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_str_trim_end(opStr_ABCD, '0', opStr_ABCD)  


    wait_and_clear_at_row(row, title_str)
} 


//////////////////////////////////////////////////////////////////////////////
//                          Print macros 
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified string comparison at the current 
// curor location.
// nv_str_cmp is used to do the comparison  
.macro print_str_cmp(op1, op2, result, expected_cmp)
{
    lda #1
    sta passed

    nv_screen_print_str(quote_left_str)
    nv_screen_print_str(op1)
    nv_screen_print_str(quote_right_str)
    
    // set up string 1 parameter
    lda #<op1
    sta nv_str1_ptr
    lda #>op1
    sta nv_str1_ptr+1

    // set up string 2 parameter
    lda #<op2
    sta nv_str2_ptr
    lda #>op2
    sta nv_str2_ptr+1

    jsr NvStrCmp

    bne NotEq
// Equal here
    .if (expected_cmp != CMP_EQUAL)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(equal_str)
    jmp PrintOp2

NotEq:
    bcs GreaterOrEqual
// less than here
    .if (expected_cmp != CMP_LESS)
    {
        lda #0 
        sta passed
    }
    nv_screen_print_str(less_than_str)
    jmp PrintOp2

// Greater here
GreaterOrEqual:
    .if (expected_cmp != CMP_GREATER)
    {
        lda #0 
        sta passed
    }

    nv_screen_print_str(greater_than_str)

PrintOp2:
    nv_screen_print_str(quote_left_str)
    nv_screen_print_str(op2)
    nv_screen_print_str(quote_right_str)
    jsr PrintPassed

}


//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified string copy at the current 
// curor location.
// NvStrCpy is used to do the string copy  
.macro print_str_cpy(src_addr, dest_addr)
{
    lda #1
    sta passed

    nv_screen_print_str(quote_left_str)
    nv_screen_print_str(src_addr)
    nv_screen_print_str(quote_right_str)
    
    // set up string 1 parameter
    lda #<src_addr
    sta nv_str1_ptr
    lda #>src_addr
    sta nv_str1_ptr+1

    // set up string 2 parameter
    lda #<dest_addr
    sta nv_str2_ptr
    lda #>dest_addr
    sta nv_str2_ptr+1

    // zero out the dest string
    lda #$00
    sta dest_addr
    
    // do string copy
    jsr NvStrCpy

    // now do a string compare to make sure the copy worked
    jsr NvStrCmp

    beq IsEqual
    
    // Not Equal here
    lda #0 
    sta passed

IsEqual:
    nv_screen_print_str(copy_str)

    nv_screen_print_str(quote_left_str)
    nv_screen_print_str(dest_addr)
    nv_screen_print_str(quote_right_str)

    jsr PrintPassed

}

//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified string comparison at the current 
// curor location.
// subroutine NvStrCatChar_a is used to do the concatenation  
.macro print_str_cat_a(str_addr, char_to_cat, expected_str_addr)
{
    lda #1
    sta passed

    // copy the source str to a temp result string so we don't
    // mess with the original string which is used for other tests

    // set up string 1 parameter
    lda #<str_addr
    sta nv_str1_ptr
    lda #>str_addr
    sta nv_str1_ptr+1

    // set up string 2 parameter
    lda #<result_str
    sta nv_str2_ptr
    lda #>result_str
    sta nv_str2_ptr+1
    
    // do string copy
    jsr NvStrCpy    

    // now result string should be the passed string addr

    nv_screen_print_str(quote_left_str)
    nv_screen_print_str(result_str)
    nv_screen_print_str(quote_right_str)

    nv_screen_print_str(plus_str)
    
    nv_screen_print_str(quote_left_str)
    lda #char_to_cat
    sta temp_char_str
    nv_screen_print_str(temp_char_str)
    nv_screen_print_str(quote_right_str)

    
    // set up string 1 parameter
    lda #<result_str
    sta nv_str1_ptr
    lda #>result_str
    sta nv_str1_ptr+1

    // load accum with the char to concatenate
    lda #char_to_cat
    
    // do the concatenation of the char to the string (result_str)
    jsr NvStrCatChar_a

    // setup a string compare with the expected result and the 
    // actual result_str.  
    // string 1 parameter is already set to result_str above
    // set up string 2 parameter to expected result string
    lda #<expected_str_addr
    sta nv_str2_ptr
    lda #>expected_str_addr
    sta nv_str2_ptr+1

    // now do a string compare to make sure the copy worked
    jsr NvStrCmp

    beq IsEqual
    
    // Not Equal here
    lda #0 
    sta passed

IsEqual:
    nv_screen_print_str(copy_str)

    nv_screen_print_str(quote_left_str)
    nv_screen_print_str(result_str)
    nv_screen_print_str(quote_right_str)

    jsr PrintPassed

}

//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified string trim end function 
// curor location.
// nv_str_trim_end is used to do the comparison  
.macro print_str_trim_end(str_addr, char_to_trim, expected_str_addr)
{
    lda #1
    sta passed

    // copy the source str to a temp result string so we don't
    // mess with the original string which is used for other tests

    // set up string 1 parameter
    lda #<str_addr
    sta nv_str1_ptr
    lda #>str_addr
    sta nv_str1_ptr+1

    // set up string 2 parameter
    lda #<result_str
    sta nv_str2_ptr
    lda #>result_str
    sta nv_str2_ptr+1
    
    // do string copy
    jsr NvStrCpy    

    // now result string should be the passed string addr
    // we'll operate on this string to leave the parameter intact

    nv_screen_print_str(quote_left_str)
    nv_screen_print_str(result_str)
    nv_screen_print_str(quote_right_str)

    nv_screen_print_str(minus_str)
    
    nv_screen_print_str(quote_left_str)
    lda #char_to_trim
    sta temp_char_str
    nv_screen_print_str(temp_char_str)
    nv_screen_print_str(quote_right_str)

    
    // set up string 1 parameter
    lda #<result_str
    sta nv_str1_ptr
    lda #>result_str
    sta nv_str1_ptr+1

    // load accum with the char to trim
    lda #char_to_trim
    
    // do the concatenation of the char to the string (result_str)
    jsr NvStrTrimEnd

    // setup a string compare with the expected result and the 
    // actual result_str.  
    // string 1 parameter is already set to result_str above
    // set up string 2 parameter to expected result string
    lda #<expected_str_addr
    sta nv_str2_ptr
    lda #>expected_str_addr
    sta nv_str2_ptr+1

    // now do a string compare to make sure the copy worked
    jsr NvStrCmp

    beq IsEqual
    
    // Not Equal here
    lda #0 
    sta passed

IsEqual:
    nv_screen_print_str(copy_str)

    nv_screen_print_str(quote_left_str)
    nv_screen_print_str(result_str)
    nv_screen_print_str(quote_right_str)

    jsr PrintPassed

}



#import "../test_util/test_util_code.asm"
