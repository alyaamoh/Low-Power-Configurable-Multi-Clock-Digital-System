`timescale 1ns/1ps

module TOP_tb();

    parameter   ADDRESS_WIDTH_tb        = 4                 , 
                REG_DEPTH_tb            = 16                , 
                ALU_FUN_WIDTH_tb        = 4                 , 
                ALU_OUT_WIDTH_tb        = 16                , 
                DATA_WIDTH_tb           = 8                 , 
                NUM_STAGES_tb           = 2                 , 
                PRESCALE_WIDTH_tb       = 6                 ;
                    
/********************************************************************************************/
/********************************************************************************************/

    parameter   WR_NUM_OF_FRAMES        = 3                 ,
                RD_NUM_OF_FRAMES        = 2                 ,
                ALU_WP_NUM_OF_FRAMES    = 4                 ,
                ALU_NP_NUM_OF_FRAMES    = 2                 ;            

/********************************************************************************************/
/********************************************************************************************/

    reg                                 RST_tb              ; 
    reg                                 UART_CLK_tb         ; 
    reg                                 REF_CLK_tb          ; 
    reg                                 RX_IN_tb            ; 
    reg    [DATA_WIDTH_tb - 1 : 0]      UART_Config_tb      ;
    reg    [DATA_WIDTH_tb - 1 : 0]      DIV_RATIO_tb        ;
    wire                                TX_OUT_tb           ; 
    reg                                 TX_CLK_TB;
    reg    [2                 : 0]      Data_Stimulus_En    ;
    reg    [6                 : 0]      count = 0           ;

/********************************************************************************************/
/********************************************************************************************/

    localparam  CLK_PERIOD_REF          = 20                ;
    localparam  CLK_PERIOD_UART         = 100               ;

/********************************************************************************************/
/********************************************************************************************/

    reg   [(WR_NUM_OF_FRAMES*11-1)+3:0]         WR_CMD     = 'b110_01110111_0_110_00000101_0_110_10101010_0 ;
    reg   [(RD_NUM_OF_FRAMES*11-1)+2:0]         RD_CMD     = 'b111_00000010_0_110_10111011_0 ;
    reg   [(ALU_WP_NUM_OF_FRAMES*11-1)+3:0]     ALU_WP_CMD = 'b11_00000001_0_110_00000011_0_110_00000101_0_110_11001100_0 ;
    reg   [(ALU_NP_NUM_OF_FRAMES*11-1)+2:0]     ALU_NP_CMD = 'b111_00000001_0_110_11011101_0 ;

/********************************************************************************************/
/********************************************************************************************/

    initial
        begin
                
            $dumpfile("TOP_tb.vcd") 		                ;
            $dumpvars 							            ;
            
            $monitor("\n\nTX OUT = %b\n\n",TX_OUT_tb)       ;
            
            RST_tb              = 'b0                       ;      
            UART_CLK_tb         = 'b0                       ;
            REF_CLK_tb          = 'b0                       ;
            RX_IN_tb            = 'b1                       ;
            UART_Config_tb      = 'b001000_0_1              ;
            DIV_RATIO_tb        = 32'b1000                  ;

            #CLK_PERIOD_REF
            RST_tb      = 'b1                               ; 

            #CLK_PERIOD_REF
            Data_Stimulus_En    = 'b1                       ;

            #(CLK_PERIOD_REF*4000)
            $finish                                         ;

        end

/********************************************************************************************/
/********************************************************************************************/

    always @ (posedge DUT.CLK_DIV.o_div_clk)
        begin
            
            if(Data_Stimulus_En && count < 6'd46 )
                begin

                    RX_IN_tb <=  ALU_WP_CMD[count]          ;
                    count <= count + 6'b1                   ;
                
                end	
            else
                
                RX_IN_tb <= 1'b1                            ;  
        
        end

/********************************************************************************************/
/********************************************************************************************/

    always #(CLK_PERIOD_REF/2)  REF_CLK_tb =! REF_CLK_tb    ;

/********************************************************************************************/
/********************************************************************************************/

    always #(CLK_PERIOD_UART/2) UART_CLK_tb =! UART_CLK_tb  ;

/********************************************************************************************/
/********************************************************************************************/

    TOP #(.ADDRESS_WIDTH(ADDRESS_WIDTH_tb), .REG_DEPTH(REG_DEPTH_tb), .ALU_FUN_WIDTH(ALU_FUN_WIDTH_tb), .ALU_OUT_WIDTH(ALU_OUT_WIDTH_tb), .DATA_WIDTH(DATA_WIDTH_tb), .NUM_STAGES(NUM_STAGES_tb), .PRESCALE_WIDTH(PRESCALE_WIDTH_tb))
    DUT
    (
        .RST(RST_tb)                                        ,
        .UART_CLK(UART_CLK_tb)                              ,
        .REF_CLK(REF_CLK_tb)                                ,
        .RX_IN(RX_IN_tb)                                    ,
        .UART_Config(UART_Config_tb)                        ,
        .DIV_RATIO(DIV_RATIO_tb)                            ,

        .TX_OUT(TX_OUT_tb)               
    );

endmodule