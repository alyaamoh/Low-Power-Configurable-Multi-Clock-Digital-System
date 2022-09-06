module UART_RX #(parameter DATA_WIDTH = 8, PRESCALE_WIDTH = 6) 
(
    input   wire                                PAR_EN          ,
    input   wire                                RX_IN           ,
    input   wire   [PRESCALE_WIDTH - 1 : 0]     Prescale        ,
    input   wire                                PAR_TYP         ,
    input   wire                                CLK             ,
    input   wire                                RST             ,

    output  wire   [DATA_WIDTH - 1 : 0]         P_DATA          ,
    output  wire                                data_valid
);

/********************************************************************************************/
/********************************************************************************************/

    wire                                        dat_samp_en     ;
    wire           [PRESCALE_WIDTH - 1 :0]      edge_cnt        ;
    wire           [PRESCALE_WIDTH - 2 :0]      bit_cnt         ;
    wire                                        enable          ;
    wire                                        sampled_bit     ;
    wire                                        deser_en        ;
    wire                                        stp_chk_en      ;
    wire                                        stp_err         ;
    wire                                        strt_chk_en     ;
    wire                                        strt_glitch     ;
    wire                                        par_chk_en      ;
    wire                                        par_err         ;

/********************************************************************************************/
/********************************************************************************************/

    data_sampling #(.PRESCALE_WIDTH(PRESCALE_WIDTH))
    sampler
    (
        .edge_cnt(edge_cnt)                                     ,
        .dat_samp_en(dat_samp_en)                               ,
        .RX_IN(RX_IN)                                           ,
        .Prescale(Prescale)                                     ,
        .CLK(CLK)                                               ,
        .RST(RST)                                               ,

        .sampled_bit(sampled_bit)     
    ); 

/********************************************************************************************/
/********************************************************************************************/

    deserializer #(.DATA_WIDTH(DATA_WIDTH),.PRESCALE_WIDTH(PRESCALE_WIDTH))
    deser
    (
        .deser_en(deser_en)                                     ,
        .sampled_bit(sampled_bit)                               ,
        .edge_cnt(edge_cnt)                                     ,
        .Prescale(Prescale)                                     ,
        .CLK(CLK)                                               ,
        .RST(RST)                                               ,

        .P_DATA(P_DATA)
    );

/********************************************************************************************/
/********************************************************************************************/

    edge_bit_counter #(.PRESCALE_WIDTH(PRESCALE_WIDTH))
    edge_bit_cnt
    (
        .enable(enable)                                         ,
        .Prescale(Prescale)                                     ,
        .CLK(CLK)                                               ,
        .RST(RST)                                               ,

        .bit_cnt(bit_cnt)                                       ,
        .edge_cnt(edge_cnt)
    );

/********************************************************************************************/
/********************************************************************************************/

    FSM_RX #(.PRESCALE_WIDTH(PRESCALE_WIDTH))
    FSM
    (
        .RX_IN(RX_IN)                                           ,
        .PAR_EN(PAR_EN)                                         ,
        .edge_cnt(edge_cnt)                                     ,
        .bit_cnt(bit_cnt)                                       ,
        .Prescale(Prescale)                                     ,
        .stp_err(stp_err)                                       ,
        .strt_glitch(strt_glitch)                               ,
        .par_err(par_err)                                       ,
        .CLK(CLK)                                               ,
        .RST(RST)                                               ,

        .dat_samp_en(dat_samp_en)                               ,
        .enable(enable)                                         ,
        .deser_en(deser_en)                                     ,
        .data_valid(data_valid)                                 ,
        .stp_chk_en(stp_chk_en)                                 ,
        .strt_chk_en(strt_chk_en)                               ,
        .par_chk_en(par_chk_en)              
    );

/********************************************************************************************/
/********************************************************************************************/

    parity_check #(.DATA_WIDTH(DATA_WIDTH))
    par_chk
    (
        .PAR_TYP(PAR_TYP)                                       ,
        .par_chk_en(par_chk_en)                                 ,
        .sampled_bit(sampled_bit)                               ,
        .P_DATA(P_DATA)                                         ,
        .CLK(CLK)                                               ,
        .RST(RST)                                               ,

        .par_err(par_err)
    );

/********************************************************************************************/
/********************************************************************************************/

    stop_check 
    stp_chk
    (
        .stp_chk_en(stp_chk_en)                                 ,
        .sampled_bit(sampled_bit)                               ,
        .CLK(CLK)                                               ,
        .RST(RST)                                               ,

        .stp_err(stp_err)
    );

/********************************************************************************************/
/********************************************************************************************/

    strt_check
    strt_chk 
    (
        .strt_chk_en(strt_chk_en)                               ,
        .sampled_bit(sampled_bit)                               ,
        .CLK(CLK)                                               ,
        .RST(RST)                                               ,

        .strt_glitch(strt_glitch)
    );

endmodule