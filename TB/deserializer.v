module deserializer #(parameter DATA_WIDTH = 8, PRESCALE_WIDTH = 6)
(
    input   wire                            deser_en                            ,
    input   wire                            sampled_bit                         ,
    input   wire                            CLK                                 ,
    input   wire                            RST                                 ,
    input   wire [PRESCALE_WIDTH - 1 :0]    edge_cnt                            ,
    input   wire [PRESCALE_WIDTH - 1 : 0]   Prescale                            ,

    output  reg  [DATA_WIDTH - 1 : 0]       P_DATA
);

/********************************************************************************************/
/********************************************************************************************/

    reg          [DATA_WIDTH - 1 : 0]               bit_index                   ; 

/********************************************************************************************/
/********************************************************************************************/

    always@(posedge CLK or negedge RST)
        begin

            if(!RST)
                begin
            
                    P_DATA      <= 'b0                                          ;
                    bit_index   <= 1'b0                                         ;
            
                end
            else if(deser_en && (bit_index != DATA_WIDTH) && (edge_cnt == (Prescale-1) ) )
                begin
                    
                    P_DATA[bit_index]   <= sampled_bit                          ;
                    bit_index           <= bit_index + 1'b1                     ;
                
                end
            
            if (bit_index == DATA_WIDTH)
            
                bit_index <= 'b0                                                ;
                
                
        end

endmodule