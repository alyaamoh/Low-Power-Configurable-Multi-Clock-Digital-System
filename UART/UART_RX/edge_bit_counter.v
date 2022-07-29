module edge_bit_counter #(parameter FRAME_WIDTH = 11)
(
    input   wire                        enable                          ,
    input   wire                        CLK                             ,
    input   wire                        RST                             ,

    output  reg  [FRAME_WIDTH-1:0]      bit_cnt                         ,
    output  reg  [(FRAME_WIDTH-1)*2:0]  edge_cnt
);

/********************************************************************************************/
/********************************************************************************************/

    always@(posedge CLK or negedge RST)
        begin

            if(!RST)
                begin

                    bit_cnt  <= 'b0                                     ;
                    edge_cnt <= 'b0                                     ;
                
                end
            else if(enable)
                begin
                
                    bit_cnt  <= bit_cnt  + 'd1                          ;
                    edge_cnt <= edge_cnt + 'd2                          ;
                
                end

        end

endmodule