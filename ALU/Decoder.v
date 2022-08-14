/********************************************************************************************/
/********************************************************************************************/
/**************************		Author: Alyaa Mohamed   *************************************/
/**************************		Module: Decoder	       **************************************/
/********************************************************************************************/
/********************************************************************************************/

module Decoder #(parameter OUT_WIDTH = 8, ALU_FUN_WIDTH = 2)
(
	input 	wire  [ALU_FUN_WIDTH-1:0] 			ALU_FUN					,
	input   wire								ALU_EN					,
	input	wire  [OUT_WIDTH-1:0]				Arith_OUT				,
	input	wire  [OUT_WIDTH-1:0]				Logic_OUT				,
	input	wire  [OUT_WIDTH-1:0]				CMP_OUT					,
	input	wire  [OUT_WIDTH-1:0]				Shift_OUT				,
	input   wire								Valid_Arith				,
	input   wire								Valid_Logic				,
	input   wire								Valid_CMP				,
	input   wire								Valid_Shift				,
	input 	wire								CLK						,
	input	wire								RST						,

	output  reg									OUT_VALID				,
	output  reg	  [OUT_WIDTH-1:0]				ALU_OUT					,
	output  reg 								Arith_Enable			,
	output 	reg 								Logic_Enable			,
	output 	reg 								CMP_Enable				,
	output 	reg 								Shift_Enable
);

	reg  		  [OUT_WIDTH-1:0] 				Result_out				;
	reg											Valid					;

/********************************************************************************************/
/********************************************************************************************/

	always@(posedge CLK or negedge RST)
		begin

			if(!RST)
				begin

					ALU_OUT   <= 'b0					;
					OUT_VALID <= 'b0					;
				
				end
			else
				begin
				
					ALU_OUT   <= Result_out				;
					OUT_VALID <= Valid					;
				
				end
		end

	always@(*)
		begin
		
			if(ALU_EN)
				begin

					Arith_Enable = 1'b0										;
					Logic_Enable = 1'b0										;
					CMP_Enable	 = 1'b0										;
					Shift_Enable = 1'b0										;
					Result_out   = 'b0										;

					Valid = 1'b0											;

					case (ALU_FUN)				
						'b00:
							begin

								Arith_Enable = 1'b1							;
								Logic_Enable = 1'b0							;
								CMP_Enable	 = 1'b0							;
								Shift_Enable = 1'b0							;
								Result_out	 = Arith_OUT					;
								Valid		 = Valid_Arith					;
							
							end

/********************************************************************************************/
/********************************************************************************************/

						'b01:
							begin

								Arith_Enable = 1'b0							;
								Logic_Enable = 1'b1							;
								CMP_Enable	 = 1'b0							;
								Shift_Enable = 1'b0							;
								Result_out	 = Logic_OUT					;
								Valid		 = Valid_Logic					;
							
							end

/********************************************************************************************/
/********************************************************************************************/

						'b10: 
							begin

								Arith_Enable = 1'b0							;
								Logic_Enable = 1'b0							;
								CMP_Enable	 = 1'b1							;
								Shift_Enable = 1'b0							;
								Result_out	 = CMP_OUT						;
								Valid		 = Valid_CMP					;
							
							end

/********************************************************************************************/
/********************************************************************************************/

						'b11: 
							begin

								Arith_Enable = 1'b0							;
								Logic_Enable = 1'b0							;
								CMP_Enable	 = 1'b0							;
								Shift_Enable = 1'b1							;
								Result_out	 = Shift_OUT					;
								Valid		 = Valid_Shift					;
							
							end

/********************************************************************************************/
/********************************************************************************************/

						default:
							begin

								Arith_Enable = 1'b0							;
								Logic_Enable = 1'b0							;
								CMP_Enable	 = 1'b0							;
								Shift_Enable = 1'b0							;
								Result_out	 = 'b0							;
								Valid		 = 'b0							;
							
							end
					endcase
				end
			else
				begin

					Arith_Enable = 1'b0										;
					Logic_Enable = 1'b0										;
					CMP_Enable	 = 1'b0										;
					Shift_Enable = 1'b0										;
					Result_out	 = 'b0										;
					Valid		 = 'b0										;
				
				end
		end


endmodule