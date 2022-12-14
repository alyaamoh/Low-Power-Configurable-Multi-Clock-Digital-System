module FSM_RX #(parameter PRESCALE_WIDTH = 6)
(
    input   wire                            RX_IN                   ,
    input   wire                            PAR_EN                  ,
    input   wire  [PRESCALE_WIDTH - 1 :0]   edge_cnt                ,
    input   wire  [PRESCALE_WIDTH - 2 :0]   bit_cnt                 ,
    input   wire  [PRESCALE_WIDTH - 1 :0]   Prescale               ,
    input   wire                            stp_err                 ,
    input   wire                            strt_glitch             ,
    input   wire                            par_err                 ,
    input   wire                            CLK                     ,
    input   wire                            RST                     ,

    output  reg                             dat_samp_en             ,
    output  reg                             enable                  ,
    output  reg                             deser_en                ,
    output  reg                             data_valid              ,
    output  reg                             stp_chk_en              ,
    output  reg                             strt_chk_en             ,
    output  reg                             par_chk_en              
);

/********************************************************************************************/
/********************************************************************************************/

    reg           [6:0]	    current_state	                        ;
    reg           [6:0]	    next_state		                        ;

/********************************************************************************************/
/********************************************************************************************/

    localparam	            IDLE     = 7'b0000001                   ,
                            Start    = 7'b0000010                   ,
				            Data     = 7'b0000100                   ,
				            Parity   = 7'b0001000                   ,
				            Stop     = 7'b0010000                   ,
				            Err_chk  = 7'b0100000                   ,
                            flag1    = 7'b1100100                   ,
				            Data_vld = 7'b1000000                   ;

/********************************************************************************************/
/********************************************************************************************/

    always @ (posedge CLK or negedge RST)
        begin

            if(!RST)
            
                current_state <= IDLE                               ;
            
            else
            
                current_state <= next_state                         ;
            
        end

/********************************************************************************************/
/********************************************************************************************/

    always @ (*)
        begin

            case(current_state)
                IDLE : 
                    begin

                        if(!RX_IN)

                            next_state = Start                      ;
                        
                        else
                        
                            next_state = IDLE                       ; 			
                    
                    end

/********************************************************************************************/
/********************************************************************************************/                    
                
                Start :
                    begin

                        if( (bit_cnt == 'd0) && (edge_cnt == (Prescale - 'b1)) )
                            begin

                                if(!strt_glitch)                    
                                    
                                    next_state = Data               ;
                                    
                                else 
                                    
                                    next_state = IDLE               ;       
                                            
                            end
                        else
                        
                            next_state = Start                      ; 			
                                    
                    end

/********************************************************************************************/
/********************************************************************************************/

                Data :
                    begin

                        if( (bit_cnt == 'd8) && (edge_cnt == (Prescale - 'b1)) )
                            begin

                                if(PAR_EN)
                                
                                    next_state = Parity             ;
                                
                                else
                                
                                    next_state = Stop               ;
                                                    
                            end
                        else
                        
                            next_state = Data                       ; 			    			  
                    
                    end 

/********************************************************************************************/
/********************************************************************************************/

                Parity : 
                    begin

                        if( (bit_cnt == 'd9) && (edge_cnt == (Prescale - 'b1)) )
                        
                            next_state = Stop                       ; 
                        
                        else
                        
                            next_state = Parity                     ; 			
                                    
                    end

/********************************************************************************************/
/********************************************************************************************/

                Stop : 
                    begin
                        
                        if( (bit_cnt == 'd10) && (edge_cnt == (Prescale - 'b1)) )
                        
                            next_state = Err_chk                    ;    
                        
                        else
                        
                            next_state = Stop                       ; 			
                                
                    end	

/********************************************************************************************/
/********************************************************************************************/

                Err_chk : 
                    begin

                        if(par_err | stp_err)
                        
                            next_state = IDLE                       ; 
                        
                        else
                        
                            next_state = flag1                      ; 	    				
                                    
                    end	

/********************************************************************************************/
/********************************************************************************************/                    
                flag1: next_state = Data_vld                        ;

/********************************************************************************************/
/********************************************************************************************/

                Data_vld : 
                    begin

                        if(!RX_IN)

                            next_state = Start                      ;
                        
                        else
                        
                            next_state = IDLE                       ; 						
                    
                    end	

/********************************************************************************************/
/********************************************************************************************/
                
                default: 
                    begin
                    
                        next_state = IDLE                           ; 
                    
                    end	

            endcase

        end 

/********************************************************************************************/
/********************************************************************************************/

    always @ (*)
        begin

            dat_samp_en = 'b0                                       ;
            enable      = 'b0                                       ;
            deser_en    = 'b0                                       ;
            data_valid  = 'b0                                       ;
            stp_chk_en  = 'b0                                       ;
            strt_chk_en = 'b0                                       ;
            par_chk_en  = 'b0                                       ;
            
            case(current_state)
                IDLE : 
                    begin

                        if(!RX_IN)
                            begin

                                dat_samp_en = 'b1                   ;
                                enable      = 'b1                   ;
                                deser_en    = 'b0                   ;
                                data_valid  = 'b0                   ;
                                stp_chk_en  = 'b0                   ;
                                strt_chk_en = 'b1                   ;
                                par_chk_en  = 'b0                   ;

                            end
                        else
                            begin

                                dat_samp_en = 'b0                   ;
                                enable      = 'b0                   ;
                                deser_en    = 'b0                   ;
                                data_valid  = 'b0                   ;
                                stp_chk_en  = 'b0                   ;
                                strt_chk_en = 'b0                   ;
                                par_chk_en  = 'b0                   ;

                            end 			
                    
                    end

/********************************************************************************************/
/********************************************************************************************/

                Start :
                    begin

                        dat_samp_en = 'b1                           ;
                        enable      = 'b1                           ;
                        deser_en    = 'b0                           ;
                        data_valid  = 'b0                           ;
                        stp_chk_en  = 'b0                           ;
                        strt_chk_en = 'b1                           ;
                        par_chk_en  = 'b0                           ;	
                                    
                    end

/********************************************************************************************/
/********************************************************************************************/

                Data :
                    begin

                        dat_samp_en = 'b1                           ;
                        enable      = 'b1                           ;
                        deser_en    = 'b1                           ;
                        data_valid  = 'b0                           ;
                        stp_chk_en  = 'b0                           ;
                        strt_chk_en = 'b0                           ;
                        par_chk_en  = 'b0                           ;	
                                    
                    end
/********************************************************************************************/
/********************************************************************************************/

                Parity : 
                    begin

                        dat_samp_en = 'b1                           ;
                        enable      = 'b1                           ;
                        deser_en    = 'b0                           ;
                        data_valid  = 'b0                           ;
                        stp_chk_en  = 'b0                           ;
                        strt_chk_en = 'b0                           ;
                        par_chk_en  = 'b1                           ;	
                                    
                    end

/********************************************************************************************/
/********************************************************************************************/

                Stop : 
                    begin

                        dat_samp_en = 'b1                           ;
                        enable      = 'b1                           ;
                        deser_en    = 'b0                           ;
                        data_valid  = 'b0                           ;
                        stp_chk_en  = 'b1                           ;
                        strt_chk_en = 'b0                           ;
                        par_chk_en  = 'b0                           ;	
                                    
                    end

/********************************************************************************************/
/********************************************************************************************/

                Err_chk : 
                    begin

                        dat_samp_en = 'b1                           ;
                        enable      = 'b0                           ;
                        deser_en    = 'b0                           ;
                        data_valid  = 'b0                           ;
                        stp_chk_en  = 'b0                           ;
                        strt_chk_en = 'b0                           ;
                        par_chk_en  = 'b0                           ;	
                                    
                    end

/********************************************************************************************/
/********************************************************************************************/

                Data_vld : 
                    begin

                        dat_samp_en = 'b0                           ;
                        enable      = 'b0                           ;
                        deser_en    = 'b0                           ;
                        data_valid  = 'b1                           ;
                        stp_chk_en  = 'b0                           ;
                        strt_chk_en = 'b0                           ;
                        par_chk_en  = 'b0                           ;	
                                    
                    end	

/********************************************************************************************/
/********************************************************************************************/

                flag1:
                    begin

                        dat_samp_en = 'b0                           ;
                        enable      = 'b0                           ;
                        deser_en    = 'b0                           ;
                        data_valid  = 'b1                           ;
                        stp_chk_en  = 'b0                           ;
                        strt_chk_en = 'b0                           ;
                        par_chk_en  = 'b0                           ;	
                                    
                    end

/********************************************************************************************/
/********************************************************************************************/

                default: 
                    begin

                        dat_samp_en = 'b0                           ;
                        enable      = 'b0                           ;
                        deser_en    = 'b0                           ;
                        data_valid  = 'b0                           ;
                        stp_chk_en  = 'b0                           ;
                        strt_chk_en = 'b0                           ;
                        par_chk_en  = 'b0                           ;	
                                    
                    end	

            endcase

        end

endmodule