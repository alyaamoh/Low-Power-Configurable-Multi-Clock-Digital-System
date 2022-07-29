module serializer #(parameter WIDTH = 8)
(
    input   wire [WIDTH-1:0]    P_DATA                       ,
    input   wire                ser_en                       ,
    input   wire                CLK                          ,
    input   wire                RST                          ,

    output  reg                 ser_done                     ,
    output  reg                 ser_data
);

/********************************************************************************************/
/********************************************************************************************/

   integer                     bit_index                     ;         

/********************************************************************************************/
/********************************************************************************************/

    always@(posedge CLK or negedge RST)

        begin
        
            if(!RST)
                begin
                
                    ser_data  <= 1'd0				         ;
                    ser_done  <= 1'd0                        ;
                    bit_index <= 1'b0                        ;

                end
            else if(ser_en)
                begin

                    if(bit_index == WIDTH-1)
                        begin

                            ser_data <= P_DATA[bit_index]    ;
                            ser_done  <= 1'd1                ;
                            bit_index <= 1'b0                ;
                        
                        end
                    else
                        begin

                            ser_data <= P_DATA[bit_index]    ;
                            bit_index <= bit_index + 1       ;
                            ser_done  <= 1'd0                ;
                        
                        end
            
                end
        
        end

endmodule