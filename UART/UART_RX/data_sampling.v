/********************************************************************************************/
/********************************************************************************************/
/**************************		Author: Alyaa Mohamed    ************************************/
/**************************		Module: data_sampling	 ************************************/
/********************************************************************************************/
/********************************************************************************************/

module data_sampling #(parameter PRESCALE_WIDTH = 6)
(
    input   wire    [PRESCALE_WIDTH - 1 : 0]        edge_cnt                ,
    input   wire                                    dat_samp_en             ,
    input   wire                                    RX_IN                   ,
    input   wire    [PRESCALE_WIDTH - 1 : 0]        Prescale                ,
    input   wire                                    CLK                     ,
    input   wire                                    RST                     ,

    output  reg                                     sampled_bit     
);      

/********************************************************************************************/
/********************************************************************************************/

    wire            [PRESCALE_WIDTH - 1 : 0]       num_samples              ;
    reg             [PRESCALE_WIDTH - 1 : 0]       counter                  ;
    reg             [PRESCALE_WIDTH - 1 : 0]       ones                     ;
    reg             [PRESCALE_WIDTH - 1 : 0]       zeroes                   ;

/********************************************************************************************/
/********************************************************************************************/

    assign num_samples = ( Prescale >> 2 ) + 'd1                            ;

/********************************************************************************************/
/********************************************************************************************/

    always@(posedge CLK or negedge RST)
        begin
            if(!RST)

                counter <= 'b0                                              ;
                

            else if(dat_samp_en)
                begin
                    
                    if((edge_cnt >= num_samples) && (counter != num_samples))
                    
                        counter <= counter + 'b1                            ;

                    else
                        
                        counter <= 'd0                                      ;

                end
        end

/********************************************************************************************/
/********************************************************************************************/

    always@(posedge CLK or negedge RST)
        begin

            if(!RST)
                begin
                
                    ones        <= 'b0                                      ;
                    zeroes      <= 'b0                                      ;   
                    sampled_bit <= 'b0                                      ; 
                
                end
            else if(dat_samp_en)            
                begin           

                    if((edge_cnt >= num_samples) && (counter != num_samples))           
                        begin  
                            
                            if(RX_IN)

                                ones <= ones + 'b1                          ;
                                        
                            else
                                        
                                zeroes <= zeroes + 'b1                      ; 
                        
                        end
                    else            
                        begin
                        
                            if(ones > zeroes)
                                begin
                                    
                                    sampled_bit <= 1'b1                     ;
                                    ones        <= 'b0                      ;
                                    zeroes      <= 'b0                      ;
                                
                                end
                            else
                                
                                begin
                                    
                                    sampled_bit <= 1'b0                     ;
                                    ones        <= 'b0                      ;
                                    zeroes      <= 'b0                      ;
                                
                                end  
                        end
                end

        end

endmodule