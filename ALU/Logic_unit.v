/********************************************************************************************/
/********************************************************************************************/
/**************************		Author: Alyaa Mohamed    ************************************/
/**************************		Module: Logic_unit	 	 ************************************/
/********************************************************************************************/
/********************************************************************************************/

module Logic_unit #(parameter 	A_WIDTH = 8	, B_WIDTH = 8 , OUT_WIDTH = 8, ALU_FUN_WIDTH = 2)									
 (																
	input  wire [A_WIDTH-1:0] 			A									,
	input  wire [B_WIDTH-1:0] 			B									,
	input  wire [ALU_FUN_WIDTH-1:0] 	ALU_FUN								,
	input  wire 						Logic_Enable						,
	input  wire 		  				CLK									,
	input  wire							RST									,
		
	output reg  [OUT_WIDTH-1:0] 		Logic_OUT							,
	output reg							OUT_VALID					
 );	
	
	
	reg 		[OUT_WIDTH-1:0] 		Logic_Result						;
	reg									VALID								;
	
/********************************************************************************************/
/*********************************Registers For The Outputs**********************************/
	
	always@(posedge CLK or negedge RST)	
		begin	

			if(!RST)
				begin

					Logic_OUT <= 'b0										;
					OUT_VALID <= 'b0										;
				
				end
			else
				begin
				
					Logic_OUT <= Logic_Result								;
					OUT_VALID <= VALID										;
				
				end
		end	

/********************************************************************************************/
/**************************************Logic Operations**************************************/	
	
	always@(*)	
		begin	

			VALID = 1'b0													;

			if (Logic_Enable)		
				begin		
						
					case (ALU_FUN)	
						'b00: 	 Logic_Result = 	A & B					;
						'b01: 	 Logic_Result = 	A | B					;
						'b10: 	 Logic_Result =   ~(A & B)					;
						'b11:	 Logic_Result =   ~(A | B)					;
						default: Logic_Result =   'd0						;
					endcase
					
					VALID = 'b1												;

				end
			else
				begin

					Logic_Result = 'b0										;
					VALID = 'b0												;
				
				end
		end


endmodule