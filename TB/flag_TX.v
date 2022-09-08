module flag_TX #(parameter DATA_WIDTH = 8)
(
    input wire      [DATA_WIDTH     -1 : 0]         TX_IN               ,
    input wire        						        TX_VLD              ,
    input wire                                      REF_CLK             ,
    input wire                                      RST_REF             ,

    output reg       [DATA_WIDTH     -1 : 0]        TX_send             ,
    output reg                                      vld
);

    reg       [3:0]                         cnt_TX                      ;
    reg                                     done                        ;

    always@(posedge REF_CLK or negedge RST_REF)
            begin

                if(!RST_REF)
                    begin
                
                        TX_send <= 'b0                                  ;
                        vld     <= 'b0                                  ;
                        cnt_TX  <= 'b0                                  ;
                
                    end
                else if(cnt_TX == 'b1111)
                    begin
                
                        TX_send <= 'b0                                  ;
                        vld     <= 'b0                                  ;
                        cnt_TX  <= 'b0                                  ;
                
                    end 
                else if(TX_VLD)
                    begin
                
                        TX_send <= TX_IN                                ;
                        vld     <= 'b1                                  ;
                        cnt_TX  <= cnt_TX + 'b1                         ;
                
                    end    
            
            end
     

endmodule