/********************************************************************************************/
/********************************************************************************************/
/**************************		Author: Alyaa Mohamed    ************************************/
/**************************		Module: BIT_SYNC	     ************************************/
/********************************************************************************************/
/********************************************************************************************/

module BIT_SYNC #(parameter NUM_STAGES = 2, BUS_WIDTH = 1)
(
    input   wire [BUS_WIDTH-1:0]    ASYNCH                          								,
    input   wire                    RST                             								,
    input   wire                    CLK                             								,

    output  reg  [BUS_WIDTH-1:0]    SYNC
);

/********************************************************************************/
/*****************************Internal Signals***********************************/

    reg          [NUM_STAGES-1:0]   register    [BUS_WIDTH-1:0]   									;
	integer 						counter															;

/********************************************************************************/
/********************************************************************************/

	always @(posedge CLK or negedge RST) 
		begin

			if(!RST)

				for (counter = 0 ; counter < BUS_WIDTH ; counter = counter + 1 ) 
					begin

						register[counter] <= 'b0													;
						SYNC[counter]	  <= 'b0													;
					
					end                            	                                                                                      
				
			else
				begin

					for (counter = 0 ; counter < BUS_WIDTH ; counter = counter + 1 ) 

						{SYNC[counter],register[counter]} <= {register[counter],ASYNCH[counter]}	;
							
				end	
		end

endmodule