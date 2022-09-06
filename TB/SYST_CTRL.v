module SYST_CTRL #(parameter ADDRESS_WIDTH = 4, ALU_FUN_WIDTH = 4, ALU_OUT_WIDTH = 16, DATA_WIDTH = 8)
(
    input wire [DATA_WIDTH    - 1 : 0]		RdData					                ,
    input wire						        RdData_Valid			                ,

    input wire [ALU_OUT_WIDTH - 1 : 0] 	    ALU_OUT					                ,	
    input wire						        ALU_OUT_VALID                           ,

    input wire [DATA_WIDTH    - 1 : 0]      RX_P_DATA                               ,
    input wire                              RX_data_valid                           ,

    input wire                              TX_Busy                                 ,

    input wire		  				        REF_CLK					                ,
    input wire		  				        RST						                ,


    output reg [DATA_WIDTH    - 1 : 0]      WrData					                ,
    output reg [ADDRESS_WIDTH - 1 : 0] 	    Address					                ,
    output reg		  				        WrEn					                ,
    output reg		  				        RdEn					                ,

    output reg                              CLK_EN                                  ,
    output reg                              CLK_DIV_EN                              ,  

    output reg [ALU_FUN_WIDTH - 1 : 0] 	    ALU_FUN					                ,
    output reg						        ALU_EN					                ,   

    output reg [DATA_WIDTH    - 1 : 0]      TX_P_DATA                               ,
    output reg                              TX_DATA_VALID           					
);

/********************************************************************************************/
/********************************************************************************************/

    reg        [3 : 0]	                    current_state	                        ;
    reg        [3 : 0]	                    next_state		                        ;

/********************************************************************************************/
/********************************************************************************************/

    localparam [3 : 0]      IDLE                = 4'b0000                           ,
				            RF_Wr_Addr          = 4'b0001                           ,
				            RF_Wr_Data          = 4'b0010                           ,
				            RF_Rd_Addr          = 4'b0011                           ,
                            ALU_OPER_W_OP_A     = 4'b0100                           ,
                            ALU_OPER_W_OP_B     = 4'b0101                           ,
                            ALU_FUN_ST          = 4'b0110                           ,
                            ALU_Result          = 4'b0111                           ,
                            RF_Rd_Wait          = 4'b1000                           ,
                            TX_Send             = 4'b1001                           ,
                            TX_ALU2             = 4'b1010                           ;
                            
/********************************************************************************************/
/********************************************************************************************/

    localparam [7 : 0]      RF_WRITE_CMD        = 8'hAA                             ,
                            RF_READ_CMD         = 8'hBB                             ,
                            ALU_W_OP_CMD        = 8'hCC                             ,
                            ALU_WN_OP_CMD       = 8'hDD                             ;

/********************************************************************************************/
/********************************************************************************************/

    reg        [ADDRESS_WIDTH - 1 : 0]          Address_REG                         ;
    reg                                         Address_En                          ;

    reg        [DATA_WIDTH    - 1 : 0]          TX_DATA_REG                         ;
    reg        [DATA_WIDTH    - 1 : 0]          TX_DATA_MUX_OUT                     ;
    reg        [1                 : 0]          MUX_SEL                             ;

/********************************************************************************************/
/********************************************************************************************/

    always @ (posedge REF_CLK or negedge RST)
        begin

            if(!RST)
            
                current_state <= IDLE                                               ;
            
            else
            
                current_state <= next_state                                         ;
            
        end

/********************************************************************************************/
/********************************************************************************************/

    always @ (*)
        begin

            case(current_state)

                IDLE : 
                    begin

                        if(RX_data_valid)
                            begin
                            
                                case(RX_P_DATA)

                                    RF_WRITE_CMD  : next_state = RF_Wr_Addr         ;
                                    RF_READ_CMD   : next_state = RF_Rd_Addr         ;
                                    ALU_W_OP_CMD  : next_state = ALU_OPER_W_OP_A    ;
                                    ALU_WN_OP_CMD : next_state = ALU_FUN_ST         ;
                                    default       : next_state = IDLE               ;

                                endcase

                            end

                        else

                            next_state = IDLE                                       ;

                    end       

/********************************************************************************************/
/********************************************************************************************/

                RF_Wr_Addr :
                    begin

                        if(RX_data_valid)
                        
                            next_state = RF_Wr_Data                                 ;
                        
                        else
                        
                            next_state = RF_Wr_Addr                                 ;

                    end   

/********************************************************************************************/
/********************************************************************************************/

                RF_Wr_Data : 
                    begin
                        
                        if(RX_data_valid)
                        
                            next_state = IDLE                                       ;
                        
                        else
                        
                            next_state = RF_Wr_Data                                 ;

                    end             

/********************************************************************************************/
/********************************************************************************************/

                RF_Rd_Addr : 
                    begin
                        
                        if(RX_data_valid)
                        
                            next_state = RF_Rd_Wait                                 ;
                        
                        else
                        
                            next_state = RF_Rd_Addr                                 ;

                    end 

/********************************************************************************************/
/********************************************************************************************/

                RF_Rd_Wait:
                    begin
                        if(RdData_Valid)

                            next_state = TX_Send                                    ;
                        
                        else
                        
                            next_state = RF_Rd_Wait                                 ;
                    end

/********************************************************************************************/
/********************************************************************************************/

                ALU_OPER_W_OP_A : 
                    begin
                        
                        if(RX_data_valid)
                        
                            next_state = ALU_OPER_W_OP_B                            ;
                        
                        else
                        
                            next_state = ALU_OPER_W_OP_A                            ;

                    end  

/********************************************************************************************/
/********************************************************************************************/

                ALU_OPER_W_OP_B :
                    begin
                        
                        if(RX_data_valid)
                        
                            next_state = ALU_FUN_ST                                 ;
                        
                        else
                        
                            next_state = ALU_OPER_W_OP_B                            ;

                    end   

/********************************************************************************************/
/********************************************************************************************/

                ALU_FUN_ST : 
                    begin
                        
                        if(RX_data_valid)
                        
                            next_state = ALU_Result                                 ;
                        
                        else
                        
                            next_state = ALU_FUN_ST                                 ;

                    end   

/********************************************************************************************/
/********************************************************************************************/                    
                
                ALU_Result :
                    begin

                        if(ALU_OUT_VALID )
                        
                            next_state = TX_Send                                    ;
                        
                        else 
                        
                            next_state = ALU_Result                                 ;

                    end  

/********************************************************************************************/
/********************************************************************************************/

                TX_Send:
                    begin

                        if(TX_Busy)
                            
                            next_state = TX_Send                                    ;
                        
                        else if (ALU_OUT [DATA_WIDTH*2-1:DATA_WIDTH] != 'b0) 
                        
                            next_state = TX_ALU2                                    ;

                        else

                            next_state = IDLE                                       ;    
                    
                    end

/********************************************************************************************/
/********************************************************************************************/

                TX_ALU2:
                    begin

                        if(TX_Busy)
                        
                            next_state = TX_ALU2                                    ;
                        
                        else
                        
                            next_state = IDLE                                       ;
                    
                    end

/********************************************************************************************/
/********************************************************************************************/
               
                default: next_state = IDLE                                          ;

            endcase

        end

/********************************************************************************************/
/********************************************************************************************/

    always @ (*)
        begin

            WrData		  = 'b0                                                     ;
            Address_En    = 'b0                                                     ;
            WrEn		  = 'b0                                                     ;
            RdEn		  = 'b0                                                     ;
            CLK_EN        = 'b0                                                     ;
            CLK_DIV_EN    = 'b1                                                     ;
            ALU_FUN		  = 'b0                                                     ;
            ALU_EN		  = 'b0                                                     ;
            //MUX_SEL       = 'b00                                                    ;
            TX_DATA_VALID = 'b0                                                     ;
            TX_P_DATA     = 'b0                                                     ;
            Address       = 'b0                                                     ;

            case(current_state)

                IDLE : 
                    begin

                        WrData		  = 'b0                                         ;
                        Address_En    = 'b0                                         ;
                        WrEn		  = 'b0                                         ;
                        RdEn		  = 'b0                                         ;
                        CLK_EN        = 'b0                                         ;
                        CLK_DIV_EN    = 'b1                                         ;
                        ALU_FUN		  = 'b0                                         ;
                        ALU_EN		  = 'b0                                         ;
                        MUX_SEL       = 'b00                                        ;
                        TX_DATA_VALID = 'b0                                         ;
                        TX_P_DATA     = 'b0                                         ;
                    
                    end       

/********************************************************************************************/
/********************************************************************************************/

                RF_Wr_Addr :
                    begin

                        if(RX_data_valid)
                        
                            Address_En = 'b1                                        ;
                        
                        else
                        
                            Address_En = 'b0                                        ;

                    end        

/********************************************************************************************/
/********************************************************************************************/

                RF_Wr_Data : 
                    begin
                        
                        if(RX_data_valid)
                        
                            begin

                                WrEn		= 'b1                                   ;
                                WrData		= RX_P_DATA                             ;
                                Address     = Address_REG                           ;

                            end
                        
                        else
                        
                            begin

                                WrEn		= 'b0                                   ;
                                WrData		= RX_P_DATA                             ;
                                Address     = Address_REG                           ;
                                
                            end

                    end             

/********************************************************************************************/
/********************************************************************************************/

                RF_Rd_Addr : 
                    begin

                        if(RX_data_valid)
                        
                            Address_En = 'b1                                        ;
                        
                        else
                        
                            Address_En = 'b0                                        ;

                    end

/********************************************************************************************/
/********************************************************************************************/

                RF_Rd_Wait:
                    begin

                        RdEn		= 'b1                                           ;
                        Address     = Address_REG                                   ;
                        
                        if(RdData_Valid)
                            
                            MUX_SEL     = 'b10                                      ;

                        else
                        
                            MUX_SEL     = 'b00                                      ;
                      
                    end

/********************************************************************************************/
/********************************************************************************************/

                ALU_OPER_W_OP_A : 
                    begin
                        
                        if(RX_data_valid)
                        
                            begin

                                WrEn		= 'b1                                   ;
                                WrData		= RX_P_DATA                             ;
                                Address     = 'b0                                   ;
                                ALU_EN      = 'b0                                   ;

                            end
                        
                        else
                        
                            begin

                                WrEn		= 'b0                                   ;
                                WrData		= RX_P_DATA                             ;
                                Address     = 'b0                                   ;
                                ALU_EN      = 'b0                                   ;
                                
                            end

                    end  

/********************************************************************************************/
/********************************************************************************************/

                ALU_OPER_W_OP_B :
                    begin
                        
                        if(RX_data_valid)
                        
                            begin

                                WrEn		= 'b1                                   ;
                                WrData		= RX_P_DATA                             ;
                                Address     = 'b1                                   ;
                                ALU_EN      = 'b0                                   ;

                            end
                        
                        else
                        
                            begin

                                WrEn		= 'b0                                   ;
                                WrData		= RX_P_DATA                             ;
                                Address     = 'b1                                   ;
                                ALU_EN      = 'b0                                   ;
                                
                            end

                    end   

/********************************************************************************************/
/********************************************************************************************/

                ALU_FUN_ST : 
                    begin
                        
                        CLK_EN = 'b1                                                ;
                        
                        if(RX_data_valid)
                        
                            begin

                                ALU_EN = 'b1                                        ;	
                                ALU_FUN	= RX_P_DATA                                 ;
                            
                            end
                        
                        else
                        
                            begin

                                ALU_EN = 'b0                                        ;	
                                ALU_FUN	= RX_P_DATA                                 ;
                            
                            end

                    end   

/********************************************************************************************/
/********************************************************************************************/

                ALU_Result :
                    begin

                        CLK_EN = 'b1                                                ;
                        ALU_EN = 'b1                                                ;
                        
                        if(ALU_OUT_VALID )
                        begin
                            ALU_EN      = 'b0                                       ;
                            MUX_SEL     = 'b01                                      ;
                        end
                        else
                         
                            MUX_SEL     = 'b00                                      ;

                    end  

/********************************************************************************************/
/********************************************************************************************/

                TX_Send:
                    begin

                        if (TX_Busy) 
                            begin

                                TX_DATA_VALID = 'b0                                 ;
                                TX_P_DATA     = TX_DATA_REG                         ;
                            
                            end
                        else
                            begin
                            
                                TX_DATA_VALID = 'b1                                 ;
                                TX_P_DATA     = TX_DATA_REG                         ;
                                
                                if(ALU_OUT [DATA_WIDTH*2-1:DATA_WIDTH] != 'b0) 
                                
                                    MUX_SEL = 'b11                                  ;

                                else

                                    MUX_SEL = 'b00                                  ;    
                            
                            end
                    end

/********************************************************************************************/
/********************************************************************************************/
                
                TX_ALU2:
                    begin

                        if(TX_Busy)
                            begin

                                TX_DATA_VALID = 'b0                                 ;
                                TX_P_DATA     = TX_DATA_REG                         ;
                            
                            end
                        else
                            begin

                                TX_DATA_VALID = 'b1                                 ;
                                TX_P_DATA     = TX_DATA_REG                         ;
                            
                            end
                    
                    end

/********************************************************************************************/
/********************************************************************************************/

                default:
                    begin

                        WrData		  = 'b0                                         ;
                        Address_En    = 'b0                                         ;
                        WrEn		  = 'b0                                         ;
                        RdEn		  = 'b0                                         ;
                        CLK_EN        = 'b0                                         ;
                        CLK_DIV_EN    = 'b1                                         ;
                        ALU_FUN		  = 'b0                                         ;
                        ALU_EN		  = 'b0                                         ;
                        MUX_SEL       = 'b00                                        ;
                        TX_DATA_VALID = 'b0                                         ;
                        TX_P_DATA     = 'b0                                         ;
                    
                    end

            endcase

        end

/********************************************************************************************/
/********************************************************************************************/

    always@(*)
        begin
            
            case(MUX_SEL)
        
                'b00    :   TX_DATA_MUX_OUT = 'b0                                   ;
                'b01    :   TX_DATA_MUX_OUT = ALU_OUT [DATA_WIDTH:0]                ;
                'b11    :   TX_DATA_MUX_OUT = ALU_OUT [DATA_WIDTH*2-1:DATA_WIDTH]   ;
                'b10    :   TX_DATA_MUX_OUT = RdData                                ;
                default :   TX_DATA_MUX_OUT = 'b0                                   ;
        
            endcase
        
        end

/********************************************************************************************/
/********************************************************************************************/

    always@(posedge REF_CLK or negedge RST)
        begin
            if(!RST)

                TX_DATA_REG <= 'b0                                                  ;
            
            else 
            
                TX_DATA_REG <= TX_DATA_MUX_OUT                                      ;
    
        end

/********************************************************************************************/
/********************************************************************************************/

    always@(posedge REF_CLK or negedge RST)
        begin
            if(!RST)
                
                Address_REG <= 'b0                                                  ;
            
            else if(Address_En)
            
                Address_REG <= RX_P_DATA                                            ;
        
        end

endmodule