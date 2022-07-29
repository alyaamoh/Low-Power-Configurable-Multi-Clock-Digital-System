module UART_TX #( parameter WIDTH = 8 )
(
    input   wire  [WIDTH-1:0]   P_DATA                  ,
    input   wire                DATA_VALID              ,
    input   wire                PAR_EN                  ,
    input   wire                PAR_TYP                 ,
    input   wire                CLK                     ,
    input   wire                RST                     ,

    output  wire                 TX_OUT                 ,
    output  wire                 Busy
);

/********************************************************************************************/
/********************************************************************************************/

    wire                        ser_done                ;
    wire                        ser_en                  ;
    wire                        ser_data                ;
    wire                        par_bit                 ;
    wire       [1:0]            mux_sel                 ;

/********************************************************************************************/
/********************************************************************************************/

    MUX mux
    (
        .ser_data(ser_data)                             ,
        .mux_sel(mux_sel)                               ,
        .start_bit(1'b0)                                ,
        .stop_bit(1'b1)                                 ,
        .par_bit(par_bit)                               ,
        .CLK(CLK)                                       ,
        .RST(RST)                                       ,

        .TX_OUT(TX_OUT)      
    );

/********************************************************************************************/
/********************************************************************************************/

    serializer #(.WIDTH(WIDTH))
    serial
    (
        .P_DATA(P_DATA)                                 ,
        .ser_en(ser_en)                                 ,
        .CLK(CLK)                                       ,
        .RST(RST)                                       ,

        .ser_done(ser_done)                             ,
        .ser_data(ser_data)
    );

/********************************************************************************************/
/********************************************************************************************/

    parity_calc #(.WIDTH(WIDTH))
    parity
    (
        .P_DATA(P_DATA)                                 ,
        .DATA_VALID(DATA_VALID)                         ,
        .PAR_TYP(PAR_TYP)                               ,
        .CLK(CLK)                                       ,
        .RST(RST)                                       ,

        .par_bit(par_bit)
    );

/********************************************************************************************/
/********************************************************************************************/

    FSM fsm
    (
        .DATA_VALID(DATA_VALID)                         ,
        .PAR_EN(PAR_EN)                                 ,
        .ser_done(ser_done)                             ,
        .CLK(CLK)                                       ,
        .RST(RST)                                       ,

        .ser_en(ser_en)                                 ,
        .mux_sel(mux_sel)                               ,
        .Busy(Busy)
    );

endmodule