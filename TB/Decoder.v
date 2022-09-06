module Decoder #(parameter ALU_FUN_WIDTH = 2)
(
	input 	wire  [ALU_FUN_WIDTH-1:0] 			ALU_FUN					,
	input   wire								ALU_EN					,

	output  reg 								Arith_Enable			,
	output 	reg 								Logic_Enable			,
	output 	reg 								CMP_Enable				,
	output 	reg 								Shift_Enable
);

/********************************************************************************************/
/********************************************************************************************/

	always@(*)
		begin
		
			if(ALU_EN)
				begin

					Arith_Enable = 1'b0										;
					Logic_Enable = 1'b0										;
					CMP_Enable	 = 1'b0										;
					Shift_Enable = 1'b0										;

					case (ALU_FUN)				
						'b00:
							begin

								Arith_Enable = 1'b1							;
								Logic_Enable = 1'b0							;
								CMP_Enable	 = 1'b0							;
								Shift_Enable = 1'b0							;
							
							end

/********************************************************************************************/
/********************************************************************************************/

						'b01:
							begin

								Arith_Enable = 1'b0							;
								Logic_Enable = 1'b1							;
								CMP_Enable	 = 1'b0							;
								Shift_Enable = 1'b0							;
							
							end

/********************************************************************************************/
/********************************************************************************************/

						'b10: 
							begin

								Arith_Enable = 1'b0							;
								Logic_Enable = 1'b0							;
								CMP_Enable	 = 1'b1							;
								Shift_Enable = 1'b0							;
							
							end

/********************************************************************************************/
/********************************************************************************************/

						'b11: 
							begin

								Arith_Enable = 1'b0							;
								Logic_Enable = 1'b0							;
								CMP_Enable	 = 1'b0							;
								Shift_Enable = 1'b1							;
							
							end

/********************************************************************************************/
/********************************************************************************************/

						default:
							begin

								Arith_Enable = 1'b0							;
								Logic_Enable = 1'b0							;
								CMP_Enable	 = 1'b0							;
								Shift_Enable = 1'b0							;
							
							end
					endcase
				end
			else
				begin

					Arith_Enable = 1'b0										;
					Logic_Enable = 1'b0										;
					CMP_Enable	 = 1'b0										;
					Shift_Enable = 1'b0										;
				
				end
		end


endmodule