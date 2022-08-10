module deserializer #(parameter DATA_WIDTH = 8)
(
    input   wire                        deser_en                                ,
    input   wire                        sampled_bit                             ,
    input   wire                        CLK                                     ,
    input   wire                        RST                                     ,

    output  reg [DATA_WIDTH - 1 : 0]    P_DATA
);

/********************************************************************************************/
/********************************************************************************************/

    integer                         bit_index                                   ; 

/********************************************************************************************/
/********************************************************************************************/

    always@(posedge CLK or negedge RST)
        begin

            if(!RST)
                begin
            
                    P_DATA      <= 'b0                                          ;
                    bit_index   <= 1'b0                                         ;
            
                end
            else if(deser_en && (bit_index != DATA_WIDTH) )
                begin
                    
                    P_DATA[bit_index]   <= sampled_bit                          ;
                    bit_index           <= bit_index + 1'b1                     ;
                
                end
                
        end

endmodule