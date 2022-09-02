/********************************************************************************************/
/********************************************************************************************/
/**************************		Author: Alyaa Mohamed    ************************************/
/**************************		Module: Shift_unit	 	 ************************************/
/********************************************************************************************/
/********************************************************************************************/

module Shift_unit #(parameter 	A_WIDTH = 8	, B_WIDTH = 8 , OUT_WIDTH = 16, ALU_FUN_WIDTH = 2)									
 (																
	input  wire [A_WIDTH-1:0] 			A									,
	input  wire [B_WIDTH-1:0] 			B									,
	input  wire [ALU_FUN_WIDTH-1:0] 	ALU_FUN								,
	input  wire 						Shift_Enable						,
	input  wire 		  				CLK									,
	input  wire							RST									,
		
	output reg  [OUT_WIDTH-1:0] 		Shift_OUT							,
	output reg							OUT_VALID	
 );


	reg 		[OUT_WIDTH-1:0] 		Shift_Result						;
	reg									VALID								;
	
/********************************************************************************************/
/*********************************Registers For The Outputs**********************************/
	
	always@(posedge CLK or negedge RST)	
		begin	
			
			if(!RST)
				begin
				
					Shift_OUT <= 'b0										;
					OUT_VALID <= 'b0										;

				end
			else
				begin
				
					Shift_OUT <= Shift_Result								;
					OUT_VALID <= VALID										;

				end
	
		end	
	
/********************************************************************************************/
/**************************************Shift Operations**************************************/
	
	always@(*)	
		begin	
				
			VALID = 1'b0													;

			if (Shift_Enable)	
				begin	
					
					case (ALU_FUN)
						'b00: 	 Shift_Result = A >> 1'b1					;				
						'b01: 	 Shift_Result = A << 1'b1					;
						'b10:	 Shift_Result = B >> 1'b1					;
						'b11: 	 Shift_Result = B << 1'b1					;
						default: Shift_Result = 'd0							;
					endcase
					
					VALID = 'b1												;

				end
			else
				begin

					Shift_Result = 'b0										;
					VALID = 'b0												;
				
				end
		end

endmodule