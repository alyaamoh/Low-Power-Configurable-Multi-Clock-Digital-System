module MUX
(
    input   wire                ser_data                ,
    input   wire    [1:0]       mux_sel                 ,
    input   wire                start_bit               ,
    input   wire                stop_bit                ,
    input   wire                par_bit                 ,
    input   wire                CLK                     ,
    input   wire                RST                     ,

    output  reg                 TX_OUT      
);

/********************************************************************************************/
/********************************************************************************************/

    always@(posedge CLK or negedge RST)
    
        begin
        
            if(!RST)
                
                TX_OUT <= 1'd1				            ;
                
            else
                begin

                    case(mux_sel)
                    
                        2'b00:   TX_OUT <= start_bit    ;
                        2'b01:   TX_OUT <= stop_bit     ;
                        2'b10:   TX_OUT <= ser_data     ;
                        2'b11:   TX_OUT <= par_bit      ;
                        default: TX_OUT <= 1'd1		    ;
                    
                    endcase
            
                end
        
        end

endmodule