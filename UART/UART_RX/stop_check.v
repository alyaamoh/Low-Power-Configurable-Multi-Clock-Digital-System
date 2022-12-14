/********************************************************************************************/
/********************************************************************************************/
/**************************		Author: Alyaa Mohamed    ************************************/
/**************************		Module: stop_check       ************************************/
/********************************************************************************************/
/********************************************************************************************/

module stop_check 
(
    input   wire        stp_chk_en                      ,
    input   wire        sampled_bit                     ,
    input   wire        CLK                             ,
    input   wire        RST                             ,

    output  reg         stp_err
);

/********************************************************************************************/
/********************************************************************************************/

    always@(posedge CLK or negedge RST)
        begin

            if(!RST)
            
                stp_err <= 1'b0                         ;
            
            else if(stp_chk_en)
                begin
                    if(sampled_bit != 1'b1)

                        stp_err <= 1'b1                 ;
                    else

                        stp_err <= 1'b0                 ;
                end    

        end

endmodule