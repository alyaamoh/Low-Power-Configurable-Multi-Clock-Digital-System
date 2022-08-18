/********************************************************************************************/
/********************************************************************************************/
/**************************		Author: Alyaa Mohamed    ************************************/
/**************************		Module: Arithmetic_unit	 ************************************/
/********************************************************************************************/
/********************************************************************************************/

module Arithmetic_unit #(parameter 	A_WIDTH = 8	, B_WIDTH = 8 , OUT_WIDTH = 8, ALU_FUN_WIDTH = 2)						
						
 (									
	input  wire [A_WIDTH-1:0] 			A												,
	input  wire [B_WIDTH-1:0] 			B												,
	input  wire [ALU_FUN_WIDTH-1:0] 	ALU_FUN											,
	input  wire 						Arith_Enable									,
	input  wire 		  				CLK												,
	input  wire							RST												,
						
	output reg  [OUT_WIDTH-1:0] 		Arith_OUT										,						
	output reg							OUT_VALID							
 );				
				
				
	reg 		[OUT_WIDTH-1:0] 		Arith_Result									;
	reg									VALID											;
	
/********************************************************************************************/
/*********************************Registers For The Outputs**********************************/
	
	always@(posedge CLK or negedge RST)	
		begin	
			
			if(!RST)
				begin

					Arith_OUT <= 'b0													;
					OUT_VALID <= 'b0													;
				
				end
			else
				begin
					
					Arith_OUT <= Arith_Result											;
					OUT_VALID <= VALID													;
				
				end
	
		end	

/********************************************************************************************/
/**********************************Arithmetic Operations*************************************/	
	
	always@(*)	
		begin	

			VALID = 1'b0																;

			if (Arith_Enable)		
				begin		
						
					case (ALU_FUN)	
						'b00: Arith_Result = A + B 										; 							
						'b01: Arith_Result = A - B 										; 
						'b10: Arith_Result = A * B 										; 
						'b11: Arith_Result = A / B 										; 
						default: Arith_Result = 'b0										;
					endcase

					VALID = 'b1															;

				end
			else
				begin

					Arith_Result = 'b0													;
					VALID = 'b0															;
				
				end

		end


endmodule