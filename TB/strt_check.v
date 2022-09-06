module strt_check 
(
    input   wire        strt_chk_en                         ,
    input   wire        sampled_bit                         ,
    input   wire        CLK                                 ,
    input   wire        RST                                 ,

    output  reg         strt_glitch
);

/********************************************************************************************/
/********************************************************************************************/

    always@(posedge CLK or negedge RST)
        begin

            if(!RST)
            
                strt_glitch <= 1'b0                         ;
            
            else if(strt_chk_en)

                strt_glitch <= sampled_bit                  ;

        end
    
endmodule