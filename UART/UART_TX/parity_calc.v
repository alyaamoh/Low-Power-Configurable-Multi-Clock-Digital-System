module parity_calc #(parameter WIDTH = 8)
(
    input   wire [WIDTH-1:0]    P_DATA                  ,
    input   wire                DATA_VALID              ,
    input   wire                PAR_TYP                 ,
    input   wire                CLK                     ,
    input   wire                RST                     ,

    output  reg                 par_bit
);

/********************************************************************************************/
/********************************************************************************************/

    always@(posedge CLK or negedge RST)

        begin
        
            if(!RST)
                
                par_bit <= 1'd0				            ;
                
            else if(DATA_VALID)
                begin

                    case(PAR_TYP)
                    
                        1'b0:    par_bit <= ^P_DATA     ;
                        1'b1:    par_bit <= ~^P_DATA    ;
                        default: par_bit <= 1'd0		;
                    
                    endcase
            
                end
        
        end

endmodule