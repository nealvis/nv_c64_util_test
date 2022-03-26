//////////////////////////////////////////////////////////////////////////////
// math_fp124_test.asm
// Copyright(c) 2022 Neal Smith.
// License: MIT. See LICENSE file in root directory.
//////////////////////////////////////////////////////////////////////////////
// This program tests the fixed point 12.4 math operations in the nv_c64_util 
// repository in the file nv_math124_macs.asm 
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

// program variables
carry_str: .text @"(C) \$00"
carry_and_overflow_str:  .text @"(CV) \$00"
overflow_str:  .text @"(V) \$00"
plus_str: .text @"+\$00"
minus_str: .text @"-\$00"
equal_str: .text@"=\$00"
rnd_str: .text@" RND \$00"

title_str: .text @"MATH124\$00"          // null terminated string to print
                                        // via the BASIC routine
title_adc124u_str: .text @"TEST ADC124U \$00"
title_adc124s_str: .text @"TEST ADC124S \$00"
title_conv124u_str: .text @"TEST CONV124U \$00"
title_conv124s_str: .text @"TEST CONV124S \$00"

/*
title_adc16_mem8u_str: .text @"TEST ADC16 MEM8U \$00"
title_adc16_a8u_str: .text @"TEST ADC16 A8U \$00"

title_adc16_8s_str: .text @"TEST ADC16 8S \$00"
title_adc16_immediate_str: .text @"TEST ADC16 IMMED\$00"
title_lsr16_str: .text @"TEST LSR16 \$00"
title_asl16_str: .text @"TEST ASL16 \$00"
title_sbc16_str: .text @"TEST SBC16 \$00"
*/

#import "../test_util/test_util_op124_data.asm"
//#import "../test_util/test_util_op16_data.asm"
//#import "../test_util/test_util_op8_data.asm"


*=$1000 "Main Start"


.var row = 0

    nv_screen_print_str(normal_control_str)
    nv_screen_clear()
    nv_screen_plot_cursor(row++, 33)
    nv_screen_print_str(title_str)

    test_conv124u(0)
    test_conv124s(0)
    test_adc124u(0)
    test_adc124s(0)

/*
    test_adc16_immediate(0)
    test_adc16_8u(false, 0)
    test_adc16_8u(true, 0)
    test_adc16_8s(0)
    test_lsr16(0)
    test_asl16(0)
*/
    rts

//////////////////////////////////////////////////////////////////////////////
//
.macro test_adc124s(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_adc124s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       V
    print_adc124s(op124_0031, op124_0010, result124, $0041, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       V
    print_adc124s(op124_0031, op124_8010, result124, $0021, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       V
    print_adc124s(op124_8010, op124_8010, result124, $8020, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       V
    print_adc124s(op124_7FFF, op124_0010, result124, $FFF1, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       V
    print_adc124s(op124_8000, op124_8010, result124, $8010, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       V
    print_adc124s(op124_FFFF, op124_8010, result124, $7FF1, true)

    wait_and_clear_at_row(row, title_str)
} 
    



//////////////////////////////////////////////////////////////////////////////
//
.macro test_adc124u(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_adc124u_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    
    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       C     V
    print_adc124u(op124_7FFF, op124_0010, result124, $800F, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       C     V
    print_adc124u(op124_8000, op124_8000, result124, $0000, true, true)
    
    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       C     V
    print_adc124u(op124_FFF0, op124_0030, result124, $0020, true, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       C     V 
    print_adc124u(op124_0010, op124_FFF8, result124, $0008, true, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       C     V
    print_adc124u(op124_FFF0, op124_FFF0, result124, $FFE0, true, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       C     V  
    print_adc124u(op124_FFF0, op124_0038, result124, $0028, true, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       C     V 
    print_adc124u(op124_FFF8, op124_0030, result124, $0028, true, false)

    wait_and_clear_at_row(row, title_str)
}



//////////////////////////////////////////////////////////////////////////////
//
.macro test_conv124u(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_conv124u_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //            
    print_conv124u(op124_0030, result16, $0003)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //             
    print_conv124u(op124_FFF7, result16, $0FFF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           
    print_conv124u(op124_FFF8, result16, $1000)

    wait_and_clear_at_row(row, title_str)
}

//////////////////////////////////////////////////////////////////////////////
//
.macro test_conv124s(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_conv124s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //             
    print_conv124s(op124_0030, result16, $0003)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //              
    print_conv124s(op124_FFF7, result16, $F801)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //            
    print_conv124s(op124_FFF8, result16, $F800)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //            
    print_conv124s(op124_FFFC, result16, $F800)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //            
    print_conv124s(op124_FFF4, result16, $F801)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //            
    print_conv124s(op124_0038, result16, $0004)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //            
    print_conv124s(op124_0034, result16, $0003)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //            
    print_conv124s(op124_003C, result16, $0004)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //            
    print_conv124s(op124_7FFF, result16, $0800)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //            
    print_conv124s(op124_800F, result16, $FFFF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //            
    print_conv124s(op124_8007, result16, $0000)

    ////////    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //            
    print_conv124s(op124_8034, result16, $FFFD)

    /////////////////////
    nv_screen_plot_cursor(row++, 0) //            
    print_conv124s(op124_8038, result16, $FFFC)

    wait_and_clear_at_row(row, title_str)
}


/*

//////////////////////////////////////////////////////////////////////////////
//
.macro test_adc16_8u(use_a, init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    .if (use_a)
    {
        nv_screen_print_str(title_adc16_a8u_str)
    }
    else
    {
        nv_screen_print_str(title_adc16_mem8u_str)
    }
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       C     V      N
    print_adc16_8u(use_a, op16_FFFF, op8_FF, result, $00FE, true, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       C     V      N
    print_adc16_8u(use_a, op16_0001, op8_02, result, $0003, false, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       C     V      N
    print_adc16_8u(use_a, op16_0001, op8_FF, result, $0100, false, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       C     V      N
    print_adc16_8u(use_a, op16_FFFF, op8_00, result, $FFFF, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       C     V      N
    print_adc16_8u(use_a, op16_00FF, op8_01, result, $0100, false, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       C     V      N
    print_adc16_8u(use_a, op16_00FF, op8_7F, result, $017E, false, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       C     V      N
    print_adc16_8u(use_a, op16_FF00, op8_FF, result, $FFFF, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       C     V      N
    print_adc16_8u(use_a, op16_7FFF, op8_01, result, $8000, false, true, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       C     V      N
    print_adc16_8u(use_a, op16_BEEF, op8_0F, result, $BEFE, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       C     V      N
    print_adc16_8u(use_a, op16_BEEF, op8_F0, result, $BFDF, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       C     V      N
    print_adc16_8u(use_a, op16_FFFF, op8_F0, result, $00EF, true, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       C     V      N
    print_adc16_8u(use_a, op16_FFFF, op8_FF, result, $00FE, true, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       C     V      N
    print_adc16_8u(use_a, op16_7FFF, op8_FF, result, $80FE, false, true, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       C     V      N
    print_adc16_8u(use_a, op16_7FFF, op8_01, result, $8000, false, true, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       C     V      N
    print_adc16_8u(use_a, op16_7FFF, op8_02, result, $8001, false, true, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       C     V      N
    print_adc16_8u(use_a, op16_FFFE, op8_02, result, $0000, true, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       C     V      N
    print_adc16_8u(use_a, op16_FFFE, op8_01, result, $FFFF, false, false, true)

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
    nv_screen_plot_cursor(row++, 0) //               C     V      N
    print_adc16_8s(op16_FFFF, op8_FF, result, $FFFE, true, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                C      V      N
    print_adc16_8s(op16_0001, op8_02, result, $0003, false, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                C     V      N
    print_adc16_8s(op16_0001, op8_FF, result, $0000, true, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                   C     V      N
    print_adc16_8s(op16_FFFF, op8_00, result, $FFFF, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //               C     V      N
    print_adc16_8s(op16_0001, op8_80, result, $FF81, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                C     V      N
    print_adc16_8s(op16_0080, op8_80, result, $0000, true, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //              C     V      N
    print_adc16_8s(op16_0081, op8_80, result, $0001, true, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                C     V      N
    print_adc16_8s(op16_00FF, op8_01, result, $0100, false, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //               C     V      N
    print_adc16_8s(op16_00FF, op8_7F, result, $017E, false, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                C     V      N
    print_adc16_8s(op16_FF00, op8_FF, result, $FEFF, true, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //               C     V      N
    print_adc16_8s(op16_7FFF, op8_01, result, $8000, false, true, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                C     V      N
    print_adc16_8s(op16_BEEF, op8_0F, result, $BEFE, false, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //               C     V      N
    print_adc16_8s(op16_BEEF, op8_F0, result, $BEDF, true, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //               C     V      N
    print_adc16_8s(op16_FFFF, op8_F0, result, $FFEF, true, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //               C     V      N
    print_adc16_8s(op16_FFFF, op8_FF, result, $FFFE, true, false, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //               C     V      N
    print_adc16_8s(op16_7FFF, op8_FF, result, $7FFE, true, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //               C     V      N
    print_adc16_8s(op16_7FFF, op8_01, result, $8000, false, true, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //               C     V      N
    print_adc16_8s(op16_7FFF, op8_02, result, $8001, false, true, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //               C     V      N
    print_adc16_8s(op16_FFFE, op8_02, result, $0000, true, false, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //               C     V      N
    print_adc16_8s(op16_FFFE, op8_01, result, $FFFF, false, false, true)

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
    print_lsr16(op16_8000, 0, $8000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op16_8000, 1, $4000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op16_8000, 2, $2000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op16_8000, 3, $1000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op16_8000, 4, $0800, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op16_8000, 5, $0400, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op16_8000, 6, $0200, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op16_8000, 7, $0100, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op16_8000, 8, $0080, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op16_8000, 9, $0040, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op16_8000, 10, $0020, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op16_8000, 11, $0010, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op16_8000, 12, $0008, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op16_8000, 13, $0004, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op16_8000, 14, $0002, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op16_8000, 15, $0001, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op16_8000, 16, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op16_FFFF, 1, $7FFF, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op16_FFFF, 2, $3FFF, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_lsr16(op16_FFFF, 3, $1FFF, true)

    wait_and_clear_at_row(row, title_str)

}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_asl16(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_asl16_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_asl16(op16_8000, 0, $8000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_asl16(op16_8000, 1, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_asl16(op16_8000, 2, $0000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_asl16(op16_0001, 0, $0001, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_asl16(op16_0001, 1, $0002, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_asl16(op16_0001, 2, $0004, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_asl16(op16_0001, 3, $0008, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_asl16(op16_0001, 4, $0010, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_asl16(op16_0001, 5, $0020, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_asl16(op16_0001, 6, $0040, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_asl16(op16_0001, 7, $0080, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_asl16(op16_0001, 8, $0100, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_asl16(op16_0001, 9, $0200, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_asl16(op16_0001, 10, $0400, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_asl16(op16_0001, 11, $0800, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_asl16(op16_0001, 12, $1000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_asl16(op16_0001, 13, $2000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_asl16(op16_0001, 14, $4000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_asl16(op16_0001, 15, $8000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_asl16(op16_0001, 16, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_asl16(op16_0001, 17, $0000, false)

    wait_and_clear_at_row(row, title_str)

}
*/

//////////////////////////////////////////////////////////////////////////////
//                          Print macros 
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified addition at the current curor location
// nv_adc124u is used to do the addition.  
.macro print_adc124s(op1, op2, result, expected_result, 
                    expect_overflow_set)
{
    lda #1
    sta passed

    nv_xfer16_mem_mem(op1, fp124_to_print)
    jsr PrintHexFP124

    nv_screen_print_str(plus_str)

    nv_xfer16_mem_mem(op2, fp124_to_print)
    jsr PrintHexFP124

    nv_screen_print_str(equal_str)

    nv_adc124s(op1, op2, result)

    php
    nv_beq16_immed(result, expected_result, ResultGood)
    lda #0 
    sta passed

ResultGood:
    nv_xfer16_mem_mem(result, fp124_to_print)
    jsr PrintHexFP124

    plp
    //pass_or_fail_carry(expect_carry_set)
    pass_or_fail_overflow(expect_overflow_set)

    jsr PrintPassed
}



//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified addition at the current curor location
// nv_adc124u is used to do the addition.  
.macro print_adc124u(op1, op2, result, expected_result, 
                    expect_carry_set, expect_overflow_set)
{
    lda #1
    sta passed

    nv_xfer16_mem_mem(op1, fp124_to_print)
    jsr PrintHexFP124

    nv_screen_print_str(plus_str)

    nv_xfer16_mem_mem(op2, fp124_to_print)
    jsr PrintHexFP124

    nv_screen_print_str(equal_str)

    nv_adc124u(op1, op2, result)

    php
    nv_beq16_immed(result, expected_result, ResultGood)
    lda #0 
    sta passed

ResultGood:
    nv_xfer16_mem_mem(result, fp124_to_print)
    jsr PrintHexFP124

    plp
    pass_or_fail_carry(expect_carry_set)
    pass_or_fail_overflow(expect_overflow_set)

    jsr PrintPassed
}

//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified rounding operation at the current 
// curor location.  nv_rnd124u_mem16u is used to do the rounding.  
.macro print_conv124u(op1, result, expected_result)
{
    lda #1
    sta passed

    nv_screen_print_str(rnd_str)

    nv_xfer16_mem_mem(op1, fp124_to_print)
    jsr PrintHexFP124

    nv_screen_print_str(equal_str)

    nv_conv124u_mem16u(op1, result)

    nv_beq16_immed(result, expected_result, ResultGood)
    lda #0 
    sta passed

ResultGood:
    nv_xfer16_mem_mem(result, word_to_print)
    jsr PrintHexWord
    
    jsr PrintPassed
}

//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified rounding operation at the current 
// curor location.  nv_conv124s_mem16s is used to do the rounding.  
.macro print_conv124s(op1, result, expected_result)
{
    lda #1
    sta passed

    nv_screen_print_str(rnd_str)

    nv_xfer16_mem_mem(op1, fp124_to_print)
    jsr PrintHexFP124

    nv_screen_print_str(equal_str)

    nv_conv124s_mem16s(op1, result)

    //php
    nv_beq16_immed(result, expected_result, ResultGood)
    lda #0 
    sta passed

ResultGood:
    nv_xfer16_mem_mem(result, word_to_print)
    jsr PrintHexWord
    
    //plp
    //pass_or_fail_carry(expect_carry_set)

    jsr PrintPassed
}



/*
//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified addition at the current curor location
// nv_adc16x_mem16x_mem8u or nv_adc16x_mem16x_a8u is used to do the addition.  
// it will look like this with no carry:
//    $2222 + $33 = $2255
// or look like this if there is a carry:
//    $FFFF + $01 = (C) $0000
.macro print_adc16_8u(use_a, op16, op8, result, expected_result, 
                      expect_carry_set, expect_overflow_set, expect_neg_set)
{
    lda #1
    sta passed

    //nv_screen_print_hex_word_mem(op16, true)
    nv_xfer16_mem_mem(op16, word_to_print)
    jsr PrintHexWord

    nv_screen_print_str(plus_str)

    //nv_screen_print_hex_byte_mem(op8, true)
    lda op8
    jsr PrintHexByteAccum
    
    nv_screen_print_str(equal_str)
    .if (use_a)
    {
        lda op8
        nv_adc16x_mem16x_a8u(op16, result)
    }
    else
    {
        nv_adc16x_mem16x_mem8u(op16, op8, result)
    }
    php
    nv_beq16_immed(result, expected_result, ResultGood)
    lda #0 
    sta passed

ResultGood:
    //nv_screen_print_hex_word_mem(result, true)
    nv_xfer16_mem_mem(result, word_to_print)
    jsr PrintHexWord
    plp
    pass_or_fail_status_flags(expect_carry_set, expect_overflow_set, 
                              expect_neg_set)
    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified addition at the current curor location
// nv_adc16_8s us used to do the addition.  
// it will look like this with no carry:
//    $2222 + $33 = $2255
// or look like this if there is a carry:
//    $FFFF + $01 = (C) $0000
.macro print_adc16_8s(op16, op8, result, expected_result, 
                      expect_carry_set, expect_overflow_set, expect_neg_set)
{
    lda #1
    sta passed

    //nv_screen_print_hex_word_mem(op16, true)
    nv_xfer16_mem_mem(op16, word_to_print)
    jsr PrintHexWord

    nv_screen_print_str(plus_str)

    //nv_screen_print_hex_byte_mem(op8, true)
    lda op8
    jsr PrintHexByteAccum

    nv_screen_print_str(equal_str)

    nv_adc16x_mem16x_mem8s(op16, op8, result)
    php
    nv_beq16_immed(result, expected_result, ResultGood)
    lda #0 
    sta passed

ResultGood:
    //nv_screen_print_hex_word_mem(result, true)
    nv_xfer16_mem_mem(result, word_to_print)
    jsr PrintHexWord
    plp
    pass_or_fail_status_flags(expect_carry_set, expect_overflow_set, 
                              expect_neg_set)

    jsr PrintPassed
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
    lda #1 
    sta passed
    
    //nv_screen_print_hex_word_mem(op1, true)
    nv_xfer16_mem_mem(op1, word_to_print)
    jsr PrintHexWord

    nv_screen_print_str(plus_str)

    //nv_screen_print_hex_word_immed(num, true)
    nv_store16_immed(word_to_print, num)
    jsr PrintHexWord
        
    nv_screen_print_str(equal_str)

    nv_adc16x_mem_immed(op1, num, result)
    php
    nv_beq16_immed(result, expected_result, ResultGood)
    lda #0 
    sta passed

ResultGood:
    //nv_screen_print_hex_word_mem(result, true)
    nv_xfer16_mem_mem(result, word_to_print)
    jsr PrintHexWord

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
.macro print_lsr16(op1, num_rots, expected_result, expect_carry_set)
{
    lda #1 
    sta passed

    lda op1
    sta temp_lsr16
    lda op1+1
    sta temp_lsr16 + 1

    //nv_screen_print_hex_word_mem(temp_lsr16, true)
    nv_xfer16_mem_mem(temp_lsr16, word_to_print)
    jsr PrintHexWord
    
    nv_screen_print_str(lsr_str)
    
    //nv_screen_print_hex_word_immed(num_rots, true)
    nv_store16_immed(word_to_print, num_rots)
    jsr PrintHexWord

    nv_screen_print_str(equal_str)

    nv_lsr16u_mem16u_immed8u(temp_lsr16, num_rots)
    php
    nv_beq16_immed(temp_lsr16, expected_result, ResultGood)
    lda #0 
    sta passed

ResultGood:
    //nv_screen_print_hex_word_mem(temp_lsr16, true)
    nv_xfer16_mem_mem(temp_lsr16, word_to_print)
    jsr PrintHexWord

    plp
    pass_or_fail_carry(expect_carry_set)

    jsr PrintPassed

}

temp_lsr16: .word 0


//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specifiied shift left at the current 
// cursor position.  nv_asl16_xxxx will be used to do the operation.
// it will look like this
//   $0001 << 3 = $0008 PASSED
// op1 is the address of the LSB of the 16 bit number to shift
// num_rots is the number of rotations to do
.macro print_asl16(op1, num_rots, expected_result, expect_carry_set)
{
    lda #1 
    sta passed

    lda op1
    sta temp_asl16
    lda op1+1
    sta temp_asl16 + 1

    //nv_screen_print_hex_word_mem(temp_asl16, true)
    nv_xfer16_mem_mem(temp_asl16, word_to_print)
    jsr PrintHexWord
    
    nv_screen_print_str(asl_str)
    
    //nv_screen_print_hex_word_immed(num_rots, true)
    nv_store16_immed(word_to_print, num_rots)
    jsr PrintHexWord

    nv_screen_print_str(equal_str)

    nv_asl16u_mem16u_immed8u(temp_asl16, num_rots)
    php
    nv_beq16_immed(temp_asl16, expected_result, ResultGood)
    lda #0 
    sta passed

ResultGood:
    //nv_screen_print_hex_word_mem(temp_asl16, true)
    nv_xfer16_mem_mem(temp_asl16, word_to_print)
    jsr PrintHexWord

    plp
    pass_or_fail_carry(expect_carry_set)
    //pass_or_fail_status_flags(expect_carry_set, expect_overflow_set, 
    //                          expect_neg_set)

    jsr PrintPassed

}

temp_asl16: .word 0

*/

#import "../test_util/test_util_code.asm"
