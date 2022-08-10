module parity_check #(parameter DATA_WIDTH = 8)
(
    input   wire                        PAR_TYP                                 ,
    input   wire                        par_chk_en                              ,
    input   wire                        sampled_bit                             ,
    input   wire    [DATA_WIDTH-1:0]    P_DATA                                  ,
    input   wire                        CLK                                     ,
    input   wire                        RST                                     ,

    output  reg                         par_err
);

/********************************************************************************************/
/********************************************************************************************/

    reg                                 par_bit                                 ;

/********************************************************************************************/
/*********************************Calculate the parity***************************************/

    always @(posedge CLK or negedge RST)
        begin

            if(!RST)
            
                par_bit <= 1'b0                                                 ;
            
            else if(par_chk_en)
                begin

                    case(PAR_TYP)
                    
                        1'b0:    par_bit <= ^P_DATA                             ;
                        1'b1:    par_bit <= ~^P_DATA                            ;
                        default: par_bit <= 1'd0		                        ;
                    
                    endcase
                
                end

        end

/********************************************************************************************/
/**********************************Check the Error*******************************************/

    always @(posedge CLK or negedge RST)
        begin

            if(!RST)
            
                par_err <= 1'b0                                                 ;
            
            else if(par_chk_en)
                begin

                    if(par_bit != sampled_bit)

                        par_err <= 1'b1                                         ;
                
                end

        end

    
endmodule