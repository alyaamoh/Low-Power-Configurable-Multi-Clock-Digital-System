module Data_Sync #(parameter NUM_STAGES = 2,BUS_WIDTH = 8)
(
    input   wire    [BUS_WIDTH-1:0]     Unsync_bus                              ,
    input   wire                        bus_enable                              ,
    input   wire                        RST                                     ,
    input   wire                        CLK                                     ,

    output  reg                         enable_pulse                            ,
    output  reg     [BUS_WIDTH-1:0]     Sync_bus                          
);

/********************************************************************************/
/********************************************************************************/

    reg             [NUM_STAGES-1:0]   register                                 ;
    reg                                enable_out                               ;
    wire                               And_out                                  ;

/********************************************************************************/
/****************************Multi Flip Flop*************************************/

    always @(posedge CLK or negedge RST) 
        begin

            if(!RST)
                begin                            
                
                    register   <= 'b0                                           ;
                    enable_out <= 'b0                                           ;

                end

            else
        
                {enable_out,register} <= {register[NUM_STAGES-1:0],bus_enable}  ;

        end

/********************************************************************************/
/*******************************Pulse Gen****************************************/

    assign  And_out = (~enable_out) & register[NUM_STAGES-1]                    ;

/********************************************************************************/
/*****************************Enable Pulse***************************************/

    always@(posedge CLK or negedge RST)
        begin
            
            if(!RST)
                                            
                enable_pulse   <= 'b0                                           ; 

            else
        
                enable_pulse <= And_out                                         ;

        end

/********************************************************************************/
/********************************************************************************/

    always@(posedge CLK or negedge RST)
        begin

            if(!RST)
            
                Sync_bus <= 'b0                                                 ;
            
            else 
                if(And_out)

                    Sync_bus <= Unsync_bus                                      ;

        end

endmodule