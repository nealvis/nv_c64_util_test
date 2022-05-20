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
dot_str: .text@".\$00"
//conv124s_str: .text@" CONV S \$00"
//conv124u_str: .text@" CONV U \$00"
//conv16u_124u_str: .text@"16UTO124U \$00"
//rnd124u_str: .text@" RND U\$00"
//rnd124s_str: .text@" RND S \$00"
//abs124s_str: .text@" ABS S \$00"
//ops124s_str: .text@" OPS S \$00"

title_str: .text @"MATH124\$00"          // null terminated string to print
                                        // via the BASIC routine
title_rnd124u_str: .text @"RND124U \$00"
title_rnd124s_str: .text @"RND124S \$00"

title_adc124u_str: .text @"ADC124U \$00"
title_adc124s_str: .text @"ADC124S \$00"
title_time_str: .text @"TIME \$00"
title_conv124uTo16u_str: .text @"124U 2 16U \$00"
title_conv124sTo16s_str: .text @"124S 2 16S \$00"
title_conv16uTo124u_str: .text @"16U 2 124U \$00"
title_abs124s_str: .text @"ABS124S \$00"
title_ops124s_str: .text @"OPS124S \$00"
title_create124u_str: .text @"CREATE124U \$00"
title_create124s_str: .text @"CREATE124S \$00"
title_closest124u_str: .text @"CLOSEST124U \$00"
title_closest124s_str: .text @"CLOSEST124S \$00"
title_build124u_str: .text @"BUILD124U \$00"
title_build124s_str: .text @"BUILD124S \$00"
title_build_close_124u_str: .text @"BLD CLOSE124U \$00"
title_build_close_124s_str: .text @"BLD CLOSE124S \$00"


#import "../test_util/test_util_op124_data.asm"
#import "../test_util/test_util_op16_data.asm"
//#import "../test_util/test_util_op8_data.asm"


*=$1000 "Main Start"


.var row = 0

    nv_screen_print_str(normal_control_str)
    nv_screen_clear()
    nv_screen_plot_cursor(row++, 32)
    nv_screen_print_str(title_str)

    //test_time_adc124s(0)

    test_adc124s(0)
    test_adc124u(0)

    test_build_close124s(0)
    test_build_close124u(0)

    test_build124s(0)
    test_build124u(0)

    test_closest124s(0)
    test_closest124u(0)
    test_create124u(0)
    test_create124s(0)

    test_conv16uTo124u(0)
    test_conv124uTo16u(0)
    test_conv124sTo16s(0)

    test_abs124s(0)
    test_ops124s(0)

    test_rnd124u(0)
    test_rnd124s(0)

    rts

//////////////////////////////////////////////////////////////////////
.macro CallCorrectAdc124s(op1_fp124s, op2_fp124s, result_fp124s)
{
    .const CALL_NEW = 2
    .const CALL_NEW_RUIN_OPS = 3

    .var routine_to_call = CALL_NEW_RUIN_OPS
    //.var routine_to_call = CALL_NEW

    .if (routine_to_call == CALL_NEW_RUIN_OPS)
    {
        //jsr NvAdc124sRuinOps
        nv_call_NvAdc124sRuinOps(op1_fp124s, op2_fp124s, result_fp124s)
    }
    else
    {
        //jsr NvAdc124s
        nv_call_NvAdc124s(op1_fp124s, op2_fp124s, result_fp124s)
    }

}

//////////////////////////////////////////////////////////////////////////////
//
.macro test_time_adc124s(init_row)
{
    .var row = init_row
    //.var use_jiffy_counter = false 
    .var use_jiffy_counter = true

    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_time_str)
    nv_screen_print_str(title_adc124s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) 

    ldy #$5
    sty outer_count

    .if (use_jiffy_counter)
    {
        // start jiffy timer at 0
        lda #$0
        sta $a2
        sta $a1
        sta $a0
    }
    else
    {
        // turn off maskable interupts
        sei
    }


TopOuter:

    ldx #$FF
    stx inner_count
TopInner:

    .if (!use_jiffy_counter)
    {
        lda #NV_COLOR_LITE_BLUE               // change border color to  
        sta $D020                              // visualize timing

        nv_sprite_wait_specific_scanline(51)         // wait for particular scanline.

        lda #NV_COLOR_GREEN                    // change border color to  
        sta $D020                              // visualize timing
    }

    //print_adc124s(op124_FFFF, op124_8001, result124, $8000, true)
    //nv_xfer124_mem_mem(op124_FFFF, NvAdc124sOp1)
    //nv_xfer124_mem_mem(op124_8001, NvAdc124sOp2)
    CallCorrectAdc124s(op124_FFFF, op124_8001, 0)

    //print_adc124s(op124_FFFF, op124_8007, result124, $7FFA, true)
    //nv_xfer124_mem_mem(op124_FFFF, NvAdc124sOp1)
    //nv_xfer124_mem_mem(op124_8007, NvAdc124sOp2)
    CallCorrectAdc124s(op124_FFFF, op124_8007, 0)

    //print_adc124s(op124_FFFE, op124_8001, result124, $FFFF, false)
    //nv_xfer124_mem_mem(op124_FFFE, NvAdc124sOp1)
    //nv_xfer124_mem_mem(op124_8001, NvAdc124sOp2)
    CallCorrectAdc124s(op124_FFFE, op124_8001, 0)

    //print_adc124s(op124_0031, op124_8010, result124, $0021, false)
    //nv_xfer124_mem_mem(op124_0031, NvAdc124sOp1)
    //nv_xfer124_mem_mem(op124_0010, NvAdc124sOp2)
    CallCorrectAdc124s(op124_0031, op124_0010, 0)

    //print_adc124s(op124_0031, op124_8010, result124, $0021, false)
    //nv_xfer124_mem_mem(op124_0031, NvAdc124sOp1)
    //nv_xfer124_mem_mem(op124_8010, NvAdc124sOp2)
    CallCorrectAdc124s(op124_0031, op124_8010, 0)

    //print_adc124s(op124_8010, op124_8010, result124, $8020, false)
    //nv_xfer124_mem_mem(op124_8010, NvAdc124sOp1)
    //nv_xfer124_mem_mem(op124_8010, NvAdc124sOp2)
    CallCorrectAdc124s(op124_8010, op124_8010, 0)

    //print_adc124s(op124_7FFF, op124_0010, result124, $FFF1, true)
    //nv_xfer124_mem_mem(op124_7FFF, NvAdc124sOp1)
    //nv_xfer124_mem_mem(op124_0010, NvAdc124sOp2)
    CallCorrectAdc124s(op124_7FFF, op124_0010, 0)

    //print_adc124s(op124_8000, op124_8010, result124, $8010, false)
    //nv_xfer124_mem_mem(op124_8000, NvAdc124sOp1)
    //nv_xfer124_mem_mem(op124_8010, NvAdc124sOp2)
    CallCorrectAdc124s(op124_8000, op124_8010, 0)

    //print_adc124s(op124_FFFF, op124_8010, result124, $7FF1, true)
    //nv_xfer124_mem_mem(op124_FFFF, NvAdc124sOp1)
    //nv_xfer124_mem_mem(op124_8010, NvAdc124sOp2)
    CallCorrectAdc124s(op124_FFFF, op124_8010, 0)

    //print_adc124s(op124_7FFF, op124_0001, result124, $8000, true)
    //nv_xfer124_mem_mem(op124_7FFF, NvAdc124sOp1)
    //nv_xfer124_mem_mem(op124_0001, NvAdc124sOp2)
    CallCorrectAdc124s(op124_7FFF, op124_0001, 0)

    //print_adc124s(op124_FFFF, op124_7FFF, result124, $0000, false)
    //nv_xfer124_mem_mem(op124_FFFF, NvAdc124sOp1)
    //nv_xfer124_mem_mem(op124_7FFF, NvAdc124sOp2)
    CallCorrectAdc124s(op124_FFFF, op124_7FFF, 0)

    //print_adc124s(op124_0031, op124_8038, result124, $8007, false)
    //nv_xfer124_mem_mem(op124_0031, NvAdc124sOp1)
    //nv_xfer124_mem_mem(op124_8038, NvAdc124sOp2)
    CallCorrectAdc124s(op124_0031, op124_8038, 0)

    //print_adc124s(op124_8031, op124_0038, result124, $0007, false)
    //nv_xfer124_mem_mem(op124_8031, NvAdc124sOp1)
    //nv_xfer124_mem_mem(op124_0038, NvAdc124sOp2)
    CallCorrectAdc124s(op124_8031, op124_0038, 0)

    .if (!use_jiffy_counter)
    {
        lda #NV_COLOR_LITE_BLUE               // change border color to  
        sta $D020                              // visualize timing
    }
    dec inner_count
    beq DoneInner
    jmp TopInner
DoneInner:

    dec outer_count
    beq DoneOuter
    jmp TopOuter

DoneOuter:
    
    .if (use_jiffy_counter)
    {
        lda $a0
        nv_screen_print_hex_byte_a(true) 

        lda $a1
        nv_screen_print_hex_byte_a(false) 

        lda $a2
        nv_screen_print_hex_byte_a(false) 
    }
    else
    {
        // enable interupts again
        cli

    }
    .eval row = row+2
    nv_screen_plot_cursor(row++, 0) 

    nv_screen_print_str(title_adc124s_str)

    wait_and_clear_at_row(row, title_str)

}

outer_count: .byte 0
inner_count: .byte 0

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
    print_adc124s(op124_0058, op124_8012, result124, $0046, false)  // 5.5 + -1.125 = 4.375

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       V
    print_adc124s(op124_0046, op124_8012, result124, $0034, false)  // 4.375 + -1.125 = 3.25

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       V
    print_adc124s(op124_0034, op124_8012, result124, $0022, false)   // 3.25 + -1.125 = 2.125

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       V
    print_adc124s(op124_0022, op124_8012, result124, $0010, false)   // 2.125 + -1.125 = 1.0

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       V
    print_adc124s(op124_0010, op124_8012, result124, $8002, false)   // 1.0 + -1.125 = -0.125

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       V
    print_adc124s(op124_8002, op124_8012, result124, $8014, false)   // -0.125 + -1.125 = -1.25



    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       V
    print_adc124s(op124_FFFF, op124_8001, result124, $8000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       V
    print_adc124s(op124_FFFF, op124_8007, result124, $7FFA, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       V
    print_adc124s(op124_FFFE, op124_8001, result124, $FFFF, false)

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

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       V
    print_adc124s(op124_7FFF, op124_0001, result124, $8000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       V
    print_adc124s(op124_FFFF, op124_7FFF, result124, $0000, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       V
    print_adc124s(op124_0031, op124_8038, result124, $8007, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                       V
    print_adc124s(op124_8031, op124_0038, result124, $0007, false)

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
.macro test_conv16uTo124u(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_conv16uTo124u_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                V         
    print_conv16uTo124u(op124_0030, result16, $0300, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //                V
    print_conv16uTo124u(op16_FFF7, result16, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //               V
    print_conv16uTo124u(op16_FFFF, result16, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //               V
    print_conv16uTo124u(op16_0FFF, result16, $FFF0, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //               V
    print_conv16uTo124u(op16_1FFF, result16, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //               V
    print_conv16uTo124u(op16_2FFF, result16, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //               V
    print_conv16uTo124u(op16_4FFF, result16, $0000, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //               V
    print_conv16uTo124u(op16_8FFF, result16, $0000, true)



    wait_and_clear_at_row(row, title_str)
}




//////////////////////////////////////////////////////////////////////////////
//
.macro test_conv124uTo16u(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_conv124uTo16u_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //            
    print_conv124uTo16u(op124_0030, result16, $0003)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //             
    print_conv124uTo16u(op124_FFF7, result16, $0FFF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           
    print_conv124uTo16u(op124_FFF8, result16, $1000)


    // the tests below test that operation works using same operand as result

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //  
    nv_xfer124_mem_mem(op124_0030, result16)          
    print_conv124uTo16u(result16, result16, $0003)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //  
    nv_xfer124_mem_mem(op124_FFF7, result16)          
    print_conv124uTo16u(result16, result16, $0FFF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //   
    nv_xfer124_mem_mem(op124_FFF8, result16)                      
    print_conv124uTo16u(result16, result16, $1000)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_conv124sTo16s(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_conv124sTo16s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //             
    print_conv124sTo16s(op124_0030, result16, $0003)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //              
    print_conv124sTo16s(op124_FFF7, result16, $F801)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //            
    print_conv124sTo16s(op124_FFF8, result16, $F800)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //            
    print_conv124sTo16s(op124_FFFC, result16, $F800)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //            
    print_conv124sTo16s(op124_FFF4, result16, $F801)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //            
    print_conv124sTo16s(op124_0038, result16, $0004)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //            
    print_conv124sTo16s(op124_0034, result16, $0003)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //            
    print_conv124sTo16s(op124_003C, result16, $0004)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //            
    print_conv124sTo16s(op124_7FFF, result16, $0800)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //            
    print_conv124sTo16s(op124_800F, result16, $FFFF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //            
    print_conv124sTo16s(op124_8007, result16, $0000)

    //////////////////////
    nv_screen_plot_cursor(row++, 0) //            
    print_conv124sTo16s(op124_8034, result16, $FFFD)

    /////////////////////
    nv_screen_plot_cursor(row++, 0) //            
    print_conv124sTo16s(op124_8038, result16, $FFFC)


    // tests below are testing that result and operand can be same memory location

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) // 
    nv_xfer124_mem_mem(op124_003C, result16)           
    print_conv124sTo16s(result16, result16, $0004)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_xfer124_mem_mem(op124_7FFF, result16)           
    print_conv124sTo16s(result16, result16, $0800)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_xfer124_mem_mem(op124_800F, result16)           
    print_conv124sTo16s(result16, result16, $FFFF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_xfer124_mem_mem(op124_8007, result16)
    print_conv124sTo16s(result16, result16, $0000)

    wait_and_clear_at_row(row, title_str)
}


//////////////////////////////////////////////////////////////////////////////
//
.macro test_rnd124u(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_rnd124u_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           V        
    print_rnd124u(op124_0030, result124, $0030, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           V        
    print_rnd124u(op124_0031, result124, $0030, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           V        
    print_rnd124u(op124_0032, result124, $0030, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           V        
    print_rnd124u(op124_0034, result124, $0030, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           V        
    print_rnd124u(op124_0037, result124, $0030, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           V        
    print_rnd124u(op124_0038, result124, $0040, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           V        
    print_rnd124u(op124_003C, result124, $0040, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           V        
    print_rnd124u(op124_003E, result124, $0040, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           V        
    print_rnd124u(op124_003F, result124, $0040, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           V  
    print_rnd124u(op124_FFF7, result124, $FFF0, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           V
    print_rnd124u(op124_FFF8, result124, $FFF0, true)

    wait_and_clear_at_row(row, title_str)
}

//////////////////////////////////////////////////////////////////////////////
//
.macro test_rnd124s(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_rnd124s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           V        
    print_rnd124s(op124_0030, result124, $0030, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           V        
    print_rnd124s(op124_0031, result124, $0030, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           V        
    print_rnd124s(op124_0032, result124, $0030, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           V        
    print_rnd124s(op124_0034, result124, $0030, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           V        
    print_rnd124s(op124_0037, result124, $0030, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           V        
    print_rnd124s(op124_0038, result124, $0040, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           V        
    print_rnd124s(op124_003C, result124, $0040, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           V        
    print_rnd124s(op124_003E, result124, $0040, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           V        
    print_rnd124s(op124_003F, result124, $0040, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           V  
    print_rnd124s(op124_8030, result124, $8030, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           V  
    print_rnd124s(op124_8037, result124, $8030, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           V  
    print_rnd124s(op124_8038, result124, $8040, false)


    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           C  
    print_rnd124s(op124_FFF7, result124, $FFF0, false)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           C
    print_rnd124s(op124_FFF8, result124, $FFF0, true)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0) //           C
    print_rnd124s(op124_7FF8, result124, $7FF0, true)


    wait_and_clear_at_row(row, title_str)
}

//////////////////////////////////////////////////////////////////////////////
//
.macro test_abs124s(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_abs124s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_abs124s(op124_0030, result124, $0030)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_abs124s(op124_8030, result124, $0030)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_abs124s(op124_FFFF, result124, $7FFF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_abs124s(op124_0000, result124, $0000)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_abs124s(op124_8000, result124, $0000)

    wait_and_clear_at_row(row, title_str)
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//
.macro test_ops124s(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_ops124s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ops124s(op124_0030, result124, $8030)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ops124s(op124_8030, result124, $0030)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ops124s(op124_FFFF, result124, $7FFF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ops124s(op124_0000, result124, $8000)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ops124s(op124_8000, result124, $0000)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_ops124s(op124_0001, result124, $8001)

    wait_and_clear_at_row(row, title_str)
}
//
//////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////
//
.macro test_create124u(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_create124u_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_create124(false, 0, $000, $0, $0000)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_create124(false, 0, $FFF, $F, $FFFF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_create124(false, 0, $0FF, $F, $0FFF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_create124(false, 0, $0F, $7, $00F7)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_create124(false, 0, $00, $6, $0006)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_create124(false, 0, $123, $0, $1230)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_create124(false, 0, $123, $4, $1234)

    wait_and_clear_at_row(row, title_str)
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//
.macro test_build124u(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_build124u_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build124(false, 0, $000, $0, $0000)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build124(false, 0, $FFF, $F, $FFFF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build124(false, 0, $0FF, $F, $0FFF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build124(false, 0, $0F, $7, $00F7)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build124(false, 0, $00, $6, $0006)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build124(false, 0, $123, $0, $1230)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build124(false, 0, $123, $4, $1234)

    wait_and_clear_at_row(row, title_str)
}
//
//////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////
//
.macro test_create124s(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_create124s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_create124(true, 0, $000, $0, $0000)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_create124(true, 0, $7FF, $F, $7FFF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_create124(true, 1, $0FF, $F, $8FFF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_create124(true, 0, $0F, $7, $00F7)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_create124(true, 0, $00, $6, $0006)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_create124(true, 1, $00, $6, $8006)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_create124(true, 0, $123, $0, $1230)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_create124(true, 0, $123, $4, $1234)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_create124(true, 1, $123, $4, $9234)

    wait_and_clear_at_row(row, title_str)
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//
.macro test_build124s(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_build124s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build124(true, 0, $000, $0, $0000)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build124(true, 0, $7FF, $F, $7FFF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build124(true, 1, $0FF, $F, $8FFF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build124(true, 0, $0F, $7, $00F7)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build124(true, 0, $00, $6, $0006)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build124(true, 1, $00, $6, $8006)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build124(true, 0, $123, $0, $1230)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build124(true, 0, $123, $4, $1234)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build124(true, 1, $123, $4, $9234)

    wait_and_clear_at_row(row, title_str)
}
//
//////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////
//
.macro test_closest124s(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_closest124s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(true, 0.0, $0000)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(true, 1.0, $0010)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(true, 1.5, $0018)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(true, -1.0, $8010)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(true, -1.5, $8018)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(true, -2047.9375, $FFFF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(true, 2047.9375, $7FFF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(true, 1.25, $0014)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(true, -1.25, $8014)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(true, 3.0625, $0031)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(true, 3.0625, $0031)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(true, 3.125, $0032)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(true, 3.4325, $0037)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(true, 3.4, $0036)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(true, 3.3, $0035)

    wait_and_clear_at_row(row, title_str)
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//
.macro test_build_close124s(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_build_close_124s_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++


    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(true, -1.1, $8012)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(true, 0.0, $0000)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(true, 1.0, $0010)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(true, 1.5, $0018)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(true, 1.51, $0018)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(true, 1.49, $0018)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(true, -1.51, $8018)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(true, -1.49, $8018)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(true, -1.0, $8010)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(true, -1.5, $8018)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(true, -2047.9375, $FFFF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(true, 2047.9375, $7FFF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(true, 1.25, $0014)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(true, -1.25, $8014)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(true, 3.0625, $0031)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(true, 3.0625, $0031)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(true, 3.125, $0032)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(true, 3.4325, $0037)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(true, 3.4, $0036)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(true, 3.3, $0035)

    wait_and_clear_at_row(row, title_str)
}
//
//////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////
//
.macro test_closest124u(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_closest124u_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(false, 0.0, $0000)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(false, 1.0, $0010)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(false, 1.5, $0018)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(false, 2047.0, $7FF0)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(false, 2047.5, $7FF8)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(false, 2048.0, $8000)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(false, 1.25, $0014)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(false, 4095.25, $FFF4)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(false, 4095.9375, $FFFF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(false, 3.0625, $0031)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(false, 3.125, $0032)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(false, 3.4325, $0037)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(false, 3.4, $0036)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_closest124(false, 3.3, $0035)

    wait_and_clear_at_row(row, title_str)
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//
.macro test_build_close124u(init_row)
{
    .var row = init_row
    
    //////////////////////////////////////////////////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    nv_screen_print_str(title_build_close_124u_str)
    //////////////////////////////////////////////////////////////////////////
    .eval row++

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(false, 0.0, $0000)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(false, 1.0, $0010)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(false, 1.5, $0018)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(false, 1.51, $0018)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(false, 1.49, $0018)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(false, 2047.0, $7FF0)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(false, 2047.5, $7FF8)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(false, 2048.0, $8000)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(false, 1.25, $0014)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(false, 4095.25, $FFF4)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(false, 4095.9375, $FFFF)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(false, 3.0625, $0031)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(false, 3.125, $0032)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(false, 3.4325, $0037)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(false, 3.4, $0036)

    /////////////////////////////
    nv_screen_plot_cursor(row++, 0)
    print_build_closest124(false, 3.3, $0035)

    wait_and_clear_at_row(row, title_str)
}
//
//////////////////////////////////////////////////////////////////////////////




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

    nv_xfer124_mem_mem(op1, fp124_to_print)
    jsr PrintHexFP124

    nv_screen_print_str(plus_str)

    nv_xfer124_mem_mem(op2, fp124_to_print)
    jsr PrintHexFP124

    nv_screen_print_str(equal_str)

    //nv_adc124s(op1, op2, result)
    //nv_xfer124_mem_mem(op1, NvAdc124sOp1)
    //nv_xfer124_mem_mem(op2, NvAdc124sOp2)
    //jsr NvAdc124sOld
    CallCorrectAdc124s(op1, op2, result)
    //nv_xfer124_mem_mem(NvAdc124sResult, result)

    php
    nv_beq16_immed(result, expected_result, ResultGood)
    lda #0 
    sta passed

ResultGood:
    nv_xfer124_mem_mem(result, fp124_to_print)
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

    nv_xfer124_mem_mem(op1, fp124_to_print)
    jsr PrintHexFP124

    nv_screen_print_str(plus_str)

    nv_xfer124_mem_mem(op2, fp124_to_print)
    jsr PrintHexFP124

    nv_screen_print_str(equal_str)

    nv_adc124u(op1, op2, result)

    php
    nv_beq16_immed(result, expected_result, ResultGood)
    lda #0 
    sta passed

ResultGood:
    nv_xfer124_mem_mem(result, fp124_to_print)
    jsr PrintHexFP124

    plp
    pass_or_fail_carry(expect_carry_set)
    pass_or_fail_overflow(expect_overflow_set)

    jsr PrintPassed
}

//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified conversion operation at the current 
// curor location.  
// converts a 16u value to fp124u value
//   op16u is the value to convert
//   result124u will contain the result
// nv_conv_mem16u_mem124u is used to do the conversion  
.macro print_conv16uTo124u(op16u, result124u, expected_result, expect_overflow_set)
{
    lda #1
    sta passed

    nv_xfer16_mem_mem(op16u, word_to_print)
    jsr PrintHexWord

    nv_screen_print_str(equal_str)

    nv_conv16u_mem124u(op16u, result124u)
    php
    nv_beq16_immed(result124u, expected_result, ResultGood)
    lda #0 
    sta passed

ResultGood:
    nv_xfer124_mem_mem(result124u, fp124_to_print)
    jsr  PrintHexFP124

    nv_screen_print_str(equal_str)

    nv_xfer124_mem_mem(result124u, nv_fp124_to_print)
    jsr NvScreenPrintDecFP124u


    plp
    pass_or_fail_overflow(expect_overflow_set)

    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified conversion operation at the current 
// curor location.  
// converts fp124u to 16u rounding off the decimal to whole number
//   op1 is the fp124u value to convert
//   result will contain the converted 16u value
// nv_conv124u_mem16u is used to do the conversion.  
.macro print_conv124uTo16u(op1, result, expected_result)
{
    lda #1
    sta passed

    //nv_screen_print_str(conv124u_str)

    nv_xfer124_mem_mem(op1, fp124_to_print)
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
// curor location.  nv_rnd124u is used to do the rounding.  
.macro print_rnd124u(op1, result, expected_result, expect_overflow_set)
{
    lda #1
    sta passed

    // copy the op1 to the result because the operation is in place
    nv_xfer16_mem_mem(op1, result)

    //nv_screen_print_str(rnd124u_str)

    nv_xfer124_mem_mem(op1, fp124_to_print)
    jsr PrintHexFP124

    nv_screen_print_str(equal_str)

    nv_rnd124u(result)
    php

    nv_beq16_immed(result, expected_result, ResultGood)
    lda #0 
    sta passed

ResultGood:
    nv_xfer124_mem_mem(result, fp124_to_print)
    jsr PrintHexFP124
    
    nv_screen_print_str(equal_str)
    nv_xfer124_mem_mem(result, nv_fp124_to_print)
    jsr NvScreenPrintDecFP124u

    plp
    pass_or_fail_overflow(expect_overflow_set)

    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified rounding operation at the current 
// curor location.  nv_rnd124s is used to do the rounding.  
.macro print_rnd124s(op1, result, expected_result, expect_overflow_set)
{
    lda #1
    sta passed

    // copy the op1 to the result because the operation is in place
    nv_xfer16_mem_mem(op1, result)

    //nv_screen_print_str(rnd124s_str)

    nv_xfer124_mem_mem(op1, fp124_to_print)
    jsr PrintHexFP124

    nv_screen_print_str(equal_str)

    nv_rnd124s(result)
    php

    nv_beq16_immed(result, expected_result, ResultGood)
    lda #0 
    sta passed

ResultGood:
    nv_xfer124_mem_mem(result, fp124_to_print)
    jsr PrintHexFP124
    
    nv_screen_print_str(equal_str)
    nv_xfer124_mem_mem(result, nv_fp124_to_print)
    jsr NvScreenPrintDecFP124s

    plp
    pass_or_fail_overflow(expect_overflow_set)

    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified conversion operation at the current 
// curor location.  
//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified conversion operation at the current 
// curor location.  The decimal part is rounded to nearest whole number
// Converts fp124s to 16s rounding off the decimal to nearest whole number
// nv_conv124s_mem16s is used to do the conversion. 
//   op1 is the fp124s value to convert
//   result will contain the converted 16u value
// nv_conv124u_mem16u is used to do the conversion.  
.macro print_conv124sTo16s(op1, result, expected_result)
{
    lda #1
    sta passed

    //nv_screen_print_str(conv124s_str)

    nv_xfer124_mem_mem(op1, fp124_to_print)
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

//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified abs operation at the current 
// curor location.  nv_abs124s is used to do the rounding.  
.macro print_abs124s(op1, result, expected_result)
{
    lda #1
    sta passed

    // copy the op1 to the result because the operation is in place
    nv_xfer16_mem_mem(op1, result)

    //nv_screen_print_str(abs124s_str)

    nv_xfer124_mem_mem(op1, fp124_to_print)
    jsr PrintHexFP124

    nv_screen_print_str(equal_str)

    nv_abs124s(result)
    php

    nv_beq16_immed(result, expected_result, ResultGood)
    lda #0 
    sta passed

ResultGood:
    nv_xfer124_mem_mem(result, fp124_to_print)
    jsr PrintHexFP124
    
    nv_screen_print_str(equal_str)
    nv_xfer124_mem_mem(result, nv_fp124_to_print)
    jsr NvScreenPrintDecFP124s

    plp
    //pass_or_fail_overflow(expect_overflow_set)

    jsr PrintPassed
}

//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified abs operation at the current 
// curor location.  nv_abs124s is used to do the rounding.  
.macro print_ops124s(op1, result, expected_result)
{
    lda #1
    sta passed

    // copy the op1 to the result because the operation is in place
    nv_xfer16_mem_mem(op1, result)

    nv_xfer124_mem_mem(op1, fp124_to_print)
    jsr PrintHexFP124

    nv_screen_print_str(equal_str)

    nv_ops124s(result)
    php

    nv_beq16_immed(result, expected_result, ResultGood)
    lda #0 
    sta passed

ResultGood:
    nv_xfer124_mem_mem(result, fp124_to_print)
    jsr PrintHexFP124
    
    nv_screen_print_str(equal_str)
    nv_xfer124_mem_mem(result, nv_fp124_to_print)
    jsr NvScreenPrintDecFP124s

    plp
    //pass_or_fail_overflow(expect_overflow_set)

    jsr PrintPassed
}

//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified create fp124 operation at the current 
// curor location.  nv_create124s/u is used to do the creation. 
// macro params
//  create_signed: if true then create an fp124s else create fp124u
//  sign: if creating fp124s then this is the sign to use, a 0 or 1
//        if creating an fp124u then this is ignored
//  left: is the left of point
//  right: is the right of point.
//  expected_result: is the expected bits for the created fp124s/u
.macro print_create124(create_signed, sign, left, right, expected_result)
{
    lda #1
    sta passed

    .if (create_signed)
    {
        .if (sign == 1)
        {   
            nv_screen_print_str(minus_str)

        }
        .if (sign == 0)
        {
            nv_screen_print_str(plus_str)
        }
    }

    nv_store16_immed(word_to_print, left)
    jsr PrintHexWord

    nv_screen_print_str(dot_str)

    nv_store16_immed(byte_to_print, right)
    jsr PrintHexByte

    nv_screen_print_str(equal_str)

    .if (create_signed)
    {
        nv_create124s(sign, left, right, result124)
    }
    else
    {
        nv_create124u(left, right, result124)
    }   

    php
    .if (create_signed)
    {
        nv_beq124s_immed(result124, expected_result, ResultGood)
    }
    else
    {
        nv_beq124u_immed(result124, expected_result, ResultGood)
    }
    lda #0 
    sta passed

ResultGood:
    nv_xfer124_mem_mem(result124, fp124_to_print)
    jsr PrintHexFP124

    nv_screen_print_str(equal_str)
    .if(create_signed)
    {
        nv_xfer124_mem_mem(result124, nv_fp124_to_print)
        jsr NvScreenPrintDecFP124s
    }
    else
    {
        nv_xfer124_mem_mem(result124, nv_fp124_to_print)
        jsr NvScreenPrintDecFP124u
    }
    
    plp

    jsr PrintPassed
}

//////////////////////////////////////////////////////////////////////////////
// inline macro to print the specified create fp124 operation at the current 
// curor location.  nv_create124s/u is used to do the creation. 
// macro params
//  create_signed: if true then create an fp124s else create fp124u
//  sign: if creating fp124s then this is the sign to use, a 0 or 1
//        if creating an fp124u then this is ignored
//  left: is the left of point
//  right: is the right of point.
//  expected_result: is the expected bits for the created fp124s/u
.macro print_build124(create_signed, sign, left, right, expected_result)
{
    lda #1
    sta passed

    .if (create_signed)
    {
        .if (sign == 1)
        {   
            nv_screen_print_str(minus_str)

        }
        .if (sign == 0)
        {
            nv_screen_print_str(plus_str)
        }
    }

    nv_store16_immed(word_to_print, left)
    jsr PrintHexWord

    nv_screen_print_str(dot_str)

    nv_store16_immed(byte_to_print, right)
    jsr PrintHexByte

    nv_screen_print_str(equal_str)

    .var actual_result = 0
    .if (create_signed)
    {
        .eval actual_result = NvBuildFp124s(sign, left, right)
        nv_store16_immed(result124, actual_result)
    }
    else
    {
        .eval actual_result = NvBuildFp124u(left, right)
        nv_store16_immed(result124, actual_result)
    }   

    php
    .if (create_signed)
    {
        nv_beq124s_immed(result124, expected_result, ResultGood)
    }
    else
    {
        nv_beq124u_immed(result124, expected_result, ResultGood)
    }
    lda #0 
    sta passed

ResultGood:
    nv_xfer124_mem_mem(result124, fp124_to_print)
    jsr PrintHexFP124

    nv_screen_print_str(equal_str)
    .if(create_signed)
    {
        nv_xfer124_mem_mem(result124, nv_fp124_to_print)
        jsr NvScreenPrintDecFP124s
    }
    else
    {
        nv_xfer124_mem_mem(result124, nv_fp124_to_print)
        jsr NvScreenPrintDecFP124u
    }
    
    plp

    jsr PrintPassed
}


//////////////////////////////////////////////////////////////////////////////
// inline macro to create and print the closest specified fp124 at
// the current cursor location.  nv_closest124(s|u)_immedflot is used 
// to do the operation. 
// macro params
//  create_signed: if true then create an fp124s else create fp124u
//  flt_num: is a regular floating point number like 325.4 for which
//           the closest fp124 value will be created.
//  expected_result: is the expected bits for the created fp124s/u
.macro print_closest124(create_signed, flt_num, expected_result)
{
    lda #1
    sta passed

    screen_print_decimal_immed(flt_num)

    nv_screen_print_str(equal_str)

    .if (create_signed)
    {
        nv_closest124s_immedflt(flt_num, result124)
        
    }
    else
    {
        nv_closest124u_immedflt(flt_num, result124)
    }   

    php
    .if (create_signed)
    {
        nv_beq124s_immed(result124, expected_result, ResultGood)
    }
    else
    {
        nv_beq124u_immed(result124, expected_result, ResultGood)
    }
    lda #0 
    sta passed

ResultGood:
    .if (create_signed)
    {
        nv_xfer124_mem_mem(result124, nv_fp124_to_print)
        jsr NvScreenPrintDecFP124s
    }
    else
    {
        nv_xfer124_mem_mem(result124, nv_fp124_to_print)
        jsr NvScreenPrintDecFP124u
    }
    plp

    jsr PrintPassed
}

//////////////////////////////////////////////////////////////////////////////
// inline macro to create and print the closest specified fp124 at
// the current cursor location.  nv_closest124(s|u)_immedflt is used 
// to do the operation. 
// macro params
//  create_signed: if true then create an fp124s else create fp124u
//  flt_num: is a regular floating point number like 325.4 for which
//           the closest fp124 value will be created.
//  expected_result: is the expected bits for the created fp124s/u
.macro print_build_closest124(create_signed, flt_num, expected_result)
{
    lda #1
    sta passed

    screen_print_decimal_immed(flt_num)

    nv_screen_print_str(equal_str)

    .if (create_signed)
    {
        //nv_closest124s_immedflt(flt_num, result124)
        .var build_result = NvBuildClosest124s(flt_num)
        nv_store16_immed(result124, build_result)
    }
    else
    {
        //nv_closest124u_immedflt(flt_num, result124)
        .var build_result = NvBuildClosest124u(flt_num)
        nv_store16_immed(result124, build_result)
    }   

    php
    .if (create_signed)
    {
        nv_beq124s_immed(result124, expected_result, ResultGood)
    }
    else
    {
        nv_beq124u_immed(result124, expected_result, ResultGood)
    }
    lda #0 
    sta passed

ResultGood:
    .if (create_signed)
    {
        nv_xfer124_mem_mem(result124, nv_fp124_to_print)
        jsr NvScreenPrintDecFP124s
    }
    else
    {
        nv_xfer124_mem_mem(result124, nv_fp124_to_print)
        jsr NvScreenPrintDecFP124u
    }
    plp

    jsr PrintPassed
}


#import "../../nv_c64_util/nv_math124_code.asm"
#import "../test_util/test_util_code.asm"
