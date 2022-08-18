/********************************************************************************************/
/********************************************************************************************/
/**************************		Author: Alyaa Mohamed    ************************************/
/**************************		Module: UART	         ************************************/
/********************************************************************************************/
/********************************************************************************************/

module UART #(parameter DATA_WIDTH = 8, PRESCALE_WIDTH = 6) 
(
    input   wire                                PAR_EN              ,
    input   wire   [PRESCALE_WIDTH - 1 : 0]     Prescale            ,
    input   wire                                PAR_TYP             ,

    input   wire                                RX_CLK              ,
    input   wire                                TX_CLK              ,
    input   wire                                RST                 ,

    input   wire                                RX_IN               ,

    input   wire   [DATA_WIDTH - 1 : 0]         TX_P_DATA           ,
    input   wire                                TX_DATA_VALID       ,

    output  wire   [DATA_WIDTH - 1 : 0]         RX_OUT_P_DATA       ,
    output  wire                                RX_OUT_data_valid   ,

    output  wire                                TX_OUT              ,
    output  wire                                TX_Busy
);
    

/*****************************************************************************************/
/*****************************Instantiation Of The Modules********************************/

    UART_RX #(.DATA_WIDTH(DATA_WIDTH), .PRESCALE_WIDTH(PRESCALE_WIDTH)) 
    RX
    (
        .PAR_EN(PAR_EN)                                             ,
        .RX_IN(RX_IN)                                               ,
        .Prescale(Prescale)                                         ,
        .PAR_TYP(PAR_TYP)                                           ,
        .CLK(RX_CLK)                                                ,
        .RST(RST)                                                   ,

        .P_DATA(RX_OUT_P_DATA)                                      ,
        .data_valid(RX_OUT_data_valid)
    );

/*****************************************************************************************/
/*****************************************************************************************/

    UART_TX #(.WIDTH(DATA_WIDTH))
    TX
    (
        .P_DATA(TX_P_DATA)                                          ,
        .DATA_VALID(TX_DATA_VALID)                                  ,
        .PAR_EN(PAR_EN)                                             ,
        .PAR_TYP(PAR_TYP)                                           ,
        .CLK(TX_CLK)                                                ,
        .RST(RST)                                                   ,

        .TX_OUT(TX_OUT)                                             ,
        .Busy(TX_Busy)
    );

endmodule