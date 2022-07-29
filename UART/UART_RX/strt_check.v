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

                if(sampled_bit != 1'b0)

                    strt_glitch <= 1'b1                     ;

        end
    
endmodule