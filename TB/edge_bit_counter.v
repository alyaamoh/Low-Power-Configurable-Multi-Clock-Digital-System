module edge_bit_counter #(parameter PRESCALE_WIDTH = 6)
(
    input   wire                                enable              ,
    input   wire    [PRESCALE_WIDTH - 1 : 0]    Prescale            ,
    input   wire                                CLK                 ,
    input   wire                                RST                 ,

    output  reg     [PRESCALE_WIDTH - 2 : 0]    bit_cnt             ,
    output  reg     [PRESCALE_WIDTH - 1 :0]     edge_cnt
);

/********************************************************************************************/
/********************************************************************************************/

    wire                    edge_cnt_done                           ;

/********************************************************************************************/
/********************************************************************************************/

    assign edge_cnt_done = (edge_cnt == (Prescale-1)) ? 1'b1 : 1'b0 ; 

/********************************************************************************************/
/********************************************************************************************/

    always@(posedge CLK or negedge RST)
        begin

            if(!RST)
                    
                edge_cnt <= 'b0                                     ;
    
            else if (enable) 
                
                if(!edge_cnt_done) 

                    edge_cnt <= edge_cnt + 'b1                      ;

                else

                    edge_cnt <= 'b0                                 ;

            else
                    
                edge_cnt <= 'b0                                     ;

        end

/********************************************************************************************/
/********************************************************************************************/

    always@(posedge CLK or negedge RST)
        begin

            if(!RST)

                bit_cnt <= 'b0                                      ;
                
            else if(enable) 
                begin

                    if (edge_cnt_done) 
                
                        bit_cnt <= bit_cnt + 'd1                    ;
                        
                end
            else

                bit_cnt <= 'b0                                      ;

        end    

endmodule