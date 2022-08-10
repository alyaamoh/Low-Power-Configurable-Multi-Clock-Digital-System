module data_sampling
(
    input   wire    [5:0]       edge_cnt                                    ,
    input   wire                dat_samp_en                                 ,
    input   wire                RX_IN                                       ,
    input   wire    [5:0]       Prescale                                    ,
    input   wire                CLK                                         ,
    input   wire                RST                                         ,

    output  reg                 sampled_bit     
);      

/********************************************************************************************/
/********************************************************************************************/

    wire            [5:0]       num_samples                                 ;
    reg             [5:0]       samples                                     ;
    reg             [5:0]       counter                                     ;

    reg             [5:0]       ones                                        ;
    reg             [5:0]       zeroes                                      ;
    reg             [5:0]       i                                           ;

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
                
                if(counter == num_samples)
                
                    counter <= 'b0                                          ; 

                else
                    
                    counter <= counter + 'b1                                ;

            end
        end

/********************************************************************************************/
/********************************************************************************************/

    always@(posedge CLK or negedge RST)
        begin

            if(!RST)

                samples <= 'b0                                              ;

            else if(dat_samp_en)            
            begin           

                if(edge_cnt == (num_samples + counter) )            

                    samples[counter] <= RX_IN                               ;   

                else            

                    samples <= 'b0                                          ;    

            end

        end

/********************************************************************************************/
/********************************************************************************************/

    always@(posedge CLK or negedge RST)
        begin

            if(!RST)
                begin
                        sampled_bit <= 'b0                                  ;
                        ones        <= 'b0                                  ;
                        zeroes      <= 'b0                                  ;
                end
            else if(dat_samp_en)
                begin

                    for( i = 'b0 ; i < num_samples ; i = i + 'd1 )
                        begin

                            if(samples[i])

                                ones <= ones + 'b1                          ;
                            
                            else
                            
                                zeroes <= zeroes + 'b1                      ;

                        end 
                
                    if(ones > zeroes)
                    
                        sampled_bit <= 1'b1                                 ;
                    
                    else
                    
                        sampled_bit <= 1'b0                                 ;

                end

        end

endmodule