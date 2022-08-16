/********************************************************************************************/
/********************************************************************************************/
/**************************		Author: Alyaa Mohamed    ************************************/
/**************************		Module: CMP_unit	 	 ************************************/
/********************************************************************************************/
/********************************************************************************************/

module CMP_unit #(parameter 	A_WIDTH = 8	, B_WIDTH = 8 , OUT_WIDTH = 8, ALU_FUN_WIDTH = 2)									
 (																
	input  wire [A_WIDTH-1:0] 			A											,
	input  wire [B_WIDTH-1:0] 			B											,
	input  wire [ALU_FUN_WIDTH-1:0] 	ALU_FUN										,
	input  wire 						CMP_Enable									,
	input  wire 		  				CLK											,
	input  wire							RST											,
									
	output reg  [OUT_WIDTH-1:0] 		CMP_OUT										,
	output reg							OUT_VALID
 );	
	
	
	reg 		[OUT_WIDTH-1:0] 		CMP_Result									;
	reg									VALID										;

/********************************************************************************************/
/********************************************************************************************/	
	
	always@(posedge CLK or negedge RST)	
		begin	
			
			if(!RST)
				begin

					CMP_OUT   <= 'b0												;
					OUT_VALID <= 'b0												;
				
				end
			
			else
				begin

					CMP_OUT   <= CMP_Result											;
					OUT_VALID <= VALID												;
					
				end
		end	
	
/********************************************************************************************/
/********************************************************************************************/
	
	always@(*)	
		begin	
				
			VALID = 1'b0															;

			if (CMP_Enable)	
				begin	
					
					case (ALU_FUN)
						'b01: CMP_Result = (A == B) ? 'd1 : 'd0 					;				
						'b10: CMP_Result = (A > B)  ? 'd2 : 'd0 					;
						'b11: CMP_Result = (A < B)  ? 'd3 : 'd0 					;
						default: CMP_Result = 'd0  									;
					endcase

					VALID = 'b1														;

				end
			else
				begin
					
					CMP_Result = 'b0												;
					VALID = 'b0														;
				
				end

		end


endmodule