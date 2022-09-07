module TOP #(parameter ADDRESS_WIDTH = 4, REG_DEPTH = 16, ALU_FUN_WIDTH = 4, ALU_OUT_WIDTH = 16, DATA_WIDTH = 8, NUM_STAGES = 2, PRESCALE_WIDTH = 6)
(
    input   wire                            RST                     ,
    input   wire                            UART_CLK                ,
    input   wire                            REF_CLK                 ,
    input   wire                            RX_IN                   ,
    input   wire  [DATA_WIDTH     -1 : 0]   UART_Config             ,
    input   wire  [DATA_WIDTH     -1 : 0]   DIV_RATIO               ,

    output  wire                            TX_OUT                           
);

/*****************************************************************************************/
/*****************************************************************************************/

    wire                                    RST_UART                ;
    wire                                    RST_REF                 ;

    wire                                    TX_CLK                  ;
    wire      [DATA_WIDTH     -1 : 0]       TX_IN                   ;
    wire        						    TX_VLD                  ;
    wire      [DATA_WIDTH     -1 : 0]       TX_SYNC                 ;
    wire        						    TX_VLD_SYNC             ;
    wire                                    TX_Busy                 ;	
    wire                                    TX_Busy_SYNC            ;

    wire      [DATA_WIDTH     -1 : 0]       RX_OUT                  ;
    wire         						    RX_V_OUT                ;
    wire      [DATA_WIDTH     -1 : 0]	    RX_SYNC                 ;
    wire                                    RX_V_SYNC               ;

    wire                                    CLKDIV_EN               ;

    wire                                    CLKG_EN                 ;
    wire                                    ALU_CLK                 ;

    wire      [DATA_WIDTH    - 1 : 0]		RdData	                ;	
    wire						            RdData_Valid            ;
    wire      [DATA_WIDTH    - 1 : 0]       WrData			        ;
    wire      [ADDRESS_WIDTH - 1 : 0] 	    Address			        ;
    wire		  				            WrEn			        ;
    wire		  				            RdEn			        ;

    wire      [ALU_OUT_WIDTH - 1 : 0] 	    ALU_OUT	                ;		
    wire						            ALU_OUT_VALID           ; 
    wire      [ALU_FUN_WIDTH - 1 : 0] 	    ALU_FUN	                ;
    wire						            ALU_EN	                ;
    wire      [DATA_WIDTH    -1 : 0]        Operand_A               ;
    wire      [DATA_WIDTH    -1 : 0]        Operand_B               ;

    wire       [DATA_WIDTH    -1 : 0]        TX_send                ;
    wire                                     vld                    ;

/*****************************************************************************************/
/*****************************************************************************************/

    RST_Sync #(.NUM_STAGES(NUM_STAGES))
    RST_UART_SYNC
    (
        .RST(RST)                                                   ,
        .CLK(UART_CLK)                                              ,

        .Sync_RST(RST_UART)    
    );

/*****************************************************************************************/
/*****************************************************************************************/

    RST_Sync #(.NUM_STAGES(NUM_STAGES))
    RST_REF_SYNC
    (
        .RST(RST)                                                   ,
        .CLK(REF_CLK)                                               ,

        .Sync_RST(RST_REF)    
    );

/*****************************************************************************************/
/*****************************************************************************************/

    Data_Sync #(.NUM_STAGES(NUM_STAGES), .BUS_WIDTH(DATA_WIDTH))
    DATA_UART_SYNC
    (
        .Unsync_bus(TX_send)                                          ,
        .bus_enable(vld)                                         ,
        .RST(RST_UART)                                              ,
        .CLK(TX_CLK)                                                ,  

        .enable_pulse(TX_VLD_SYNC)                                  ,
        .Sync_bus(TX_SYNC)                          
    );

/*****************************************************************************************/
/*****************************************************************************************/

    Data_Sync #(.NUM_STAGES(NUM_STAGES), .BUS_WIDTH(DATA_WIDTH))
    DATA_REF_SYNC
    (
        .Unsync_bus(RX_OUT)                                         ,
        .bus_enable(RX_V_OUT)                                       ,
        .RST(RST_REF)                                               ,
        .CLK(REF_CLK)                                               ,

        .enable_pulse(RX_V_SYNC)                                    ,
        .Sync_bus(RX_SYNC)                          
    );

/*****************************************************************************************/
/*****************************************************************************************/

    BIT_SYNC #(.NUM_STAGES(NUM_STAGES), .BUS_WIDTH(1))
    bit_sync
    (
        .ASYNCH(TX_Busy)                          				    ,
        .RST(RST_REF)                             				    ,
        .CLK(REF_CLK)                             				    ,

        .SYNC(TX_Busy_SYNC)
    );

/*****************************************************************************************/
/*****************************************************************************************/

    ClkDiv #(.WIDTH(4))
    CLK_DIV
    (
        .i_ref_clk(UART_CLK)                                        ,
        .i_rst_n(RST_UART)                                          ,
        .i_clk_en(CLKDIV_EN)                                        ,
        .i_div_ratio(DIV_RATIO[3:0])                                ,

        .o_div_clk(TX_CLK)
    );

/*****************************************************************************************/
/*****************************************************************************************/

    CLK_GATE
    CLK_G 
    (
    .CLK_EN(CLKG_EN)                                                ,
    .CLK(REF_CLK)                                                   ,

    .GATED_CLK(ALU_CLK)
    );

/*****************************************************************************************/
/*****************************************************************************************/

    UART #(.DATA_WIDTH(DATA_WIDTH), .PRESCALE_WIDTH(PRESCALE_WIDTH))
    UART_TX_RX 
    (
        .PAR_EN(UART_Config[0])                                     ,
        .Prescale({1'b0,UART_Config[6:2]})                          ,
        .PAR_TYP(UART_Config[1])                                    ,

        .RX_CLK(UART_CLK)                                             ,
        .TX_CLK(TX_CLK)                                             ,
        .RST(RST_UART)                                              ,

        .RX_IN(RX_IN)                                               ,

        .TX_P_DATA(TX_SYNC)                                         ,
        .TX_DATA_VALID(TX_VLD_SYNC)                                 ,

        .RX_OUT_P_DATA(RX_OUT)                                      ,
        .RX_OUT_data_valid(RX_V_OUT)                                ,

        .TX_OUT(TX_OUT)                                             ,
        .TX_Busy(TX_Busy)
    );

/*****************************************************************************************/
/*****************************************************************************************/

    SYST_CTRL #(.ADDRESS_WIDTH(ADDRESS_WIDTH), .ALU_FUN_WIDTH(ALU_FUN_WIDTH), .ALU_OUT_WIDTH(ALU_OUT_WIDTH), .DATA_WIDTH(DATA_WIDTH))
    CTRL
    (
        .RdData(RdData)					                            ,
        .RdData_Valid(RdData_Valid)			                        ,

        .ALU_OUT(ALU_OUT)					                        ,	
        .ALU_OUT_VALID(ALU_OUT_VALID)                               ,

        .RX_P_DATA(RX_SYNC)                                         ,
        .RX_data_valid(RX_V_SYNC)                                   ,

        .TX_Busy(TX_Busy_SYNC)                                      ,

        .REF_CLK(REF_CLK)					                        ,
        .RST(RST_REF)						                        ,


        .WrData(WrData)					                            ,
        .Address(Address)					                        ,
        .WrEn(WrEn)					                                ,
        .RdEn(RdEn)					                                ,

        .CLK_EN(CLKG_EN)                                            ,
        .CLK_DIV_EN(CLKDIV_EN)                                      ,  

        .ALU_FUN(ALU_FUN)					                        ,
        .ALU_EN(ALU_EN)					                            ,   

        .TX_P_DATA(TX_IN)                                           ,
        .TX_DATA_VALID(TX_VLD)           					
    );

/*****************************************************************************************/
/*****************************************************************************************/

    Register8x16 #(.WIDTH(DATA_WIDTH), .DEPTH(REG_DEPTH), .ADDRESS_WIDTH(ADDRESS_WIDTH))
    REG			
    (			
        .WrData(WrData)					                            ,
        .Address(Address)					                        ,
        .WrEn(WrEn)					                                ,
        .RdEn(RdEn)					                                ,
        .CLK(REF_CLK)						                        ,
        .RST(RST_REF)						                        ,

        .RdData(RdData)					                            ,
        .RdData_Valid(RdData_Valid)			                        ,
        .REG0(Operand_A)					                        ,
        .REG1(Operand_B)					                        				
    );

/*****************************************************************************************/
/*****************************************************************************************/

    ALU_Top #(.A_WIDTH(DATA_WIDTH), .B_WIDTH(DATA_WIDTH), .OUT_WIDTH(ALU_OUT_WIDTH), .ALU_FUN_WIDTH(ALU_FUN_WIDTH))
    ALU
    (	
        .A(Operand_A)							                    ,
        .B(Operand_B)							                    ,
        .ALU_FUN(ALU_FUN)						                    ,
        .ALU_EN(ALU_EN)						                        ,
        .CLK(ALU_CLK)							                    ,
        .RST(RST_REF)							                    ,
        
        
        .ALU_OUT(ALU_OUT)						                    ,	
        .OUT_VALID(ALU_OUT_VALID)
    );

/*****************************************************************************************/
/*****************************************************************************************/

    flag_TX #(.DATA_WIDTH(DATA_WIDTH))
    flag
    (
        .TX_IN(TX_IN)                                               ,
        .TX_VLD(TX_VLD)                                             ,
        .REF_CLK(REF_CLK)                                           ,
        .RST_REF(RST_REF)                                           ,
                            
        .TX_send(TX_send)                                           ,
        .vld(vld)
    );

endmodule