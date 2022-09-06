module ALU_Top #(parameter 	A_WIDTH = 8	, B_WIDTH = 8 , OUT_WIDTH = 16, ALU_FUN_WIDTH = 4)
(	
	input  wire [A_WIDTH-1:0] 			A							,
	input  wire [B_WIDTH-1:0] 			B							,
	input  wire [ALU_FUN_WIDTH-1:0] 	ALU_FUN						,
	input  wire							ALU_EN						,
	input  wire 		  				CLK							,
	input  wire							RST							,
	
	
	output reg  [OUT_WIDTH-1:0] 		ALU_OUT						,	
	output reg							OUT_VALID
);

/********************************************************************************************/
/********************************************************************************************/

	wire 								Arith_en					;
	wire 								Logic_en					;
	wire 								CMP_en						;
	wire 								Shift_en					;

	wire        [OUT_WIDTH-1:0]			Arith_OUT					;
	wire        [OUT_WIDTH-1:0]			Logic_OUT					;
	wire        [OUT_WIDTH-1:0]			CMP_OUT						;
	wire        [OUT_WIDTH-1:0]			Shift_OUT					;

	wire								Valid_Arith					;
	wire								Valid_Logic					;
	wire								Valid_CMP					;
	wire								Valid_Shift					;


/********************************************************************************************/
/********************************************************************************************/
	reg  		[OUT_WIDTH-1:0] 		Result_out					;
	reg									Valid						;

/********************************************************************************************/
/********************************************************************************************/

	always@(posedge CLK or negedge RST)
		begin

			if(!RST)
				begin

					ALU_OUT   <= 'b0								;
					OUT_VALID <= 'b0								;

				end			
			else			
				begin			

					ALU_OUT   <= Result_out							;
					OUT_VALID <= Valid								;

				end
		end

/********************************************************************************************/
/********************************************************************************************/

	always@(*)
		begin
		
			if(ALU_EN)
				begin
					Result_out   = 'b0								;
					Valid = 1'b0									;

					case (ALU_FUN[3:2])				
						'b00:
							begin

								Result_out	 = Arith_OUT			;
								Valid		 = Valid_Arith			;
							
							end

/********************************************************************************************/
/********************************************************************************************/

						'b01:
							begin

								Result_out	 = Logic_OUT			;
								Valid		 = Valid_Logic			;
							
							end

/********************************************************************************************/
/********************************************************************************************/

						'b10: 
							begin

								Result_out	 = CMP_OUT				;
								Valid		 = Valid_CMP			;
							
							end

/********************************************************************************************/
/********************************************************************************************/

						'b11: 
							begin

								Result_out	 = Shift_OUT			;
								Valid		 = Valid_Shift			;
							
							end

/********************************************************************************************/
/********************************************************************************************/

						default:
							begin

								Result_out	 = 'b0					;
								Valid		 = 'b0					;
							
							end
					endcase
				end
			else
				begin

					Result_out	 = 'b0								;
					Valid		 = 'b0								;
				
				end
		end	

/********************************************************************************************/
/********************************************************************************************/

	Decoder #(.ALU_FUN_WIDTH (ALU_FUN_WIDTH-2))
	D1
	(																
		.ALU_FUN(ALU_FUN[3:2])										,
		.ALU_EN(ALU_EN)												,
										
		.Arith_Enable(Arith_en)										,
		.Logic_Enable(Logic_en)										,
		.CMP_Enable(CMP_en)											,
		.Shift_Enable(Shift_en)
	);

/********************************************************************************************/
/********************************************************************************************/
 
	Arithmetic_unit #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH), .OUT_WIDTH(OUT_WIDTH), .ALU_FUN_WIDTH(ALU_FUN_WIDTH-2))		
	Arith 
	(			
		.A(A)													,
		.B(B)													,
		.ALU_FUN(ALU_FUN[1:0])									,
		.Arith_Enable(Arith_en)									,
		.CLK(CLK)												,
		.RST(RST)												,
						
		.Arith_OUT(Arith_OUT)									,						
		.OUT_VALID(Valid_Arith)	
	);

/********************************************************************************************/
/********************************************************************************************/

	Logic_unit #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH), .OUT_WIDTH(OUT_WIDTH), .ALU_FUN_WIDTH(ALU_FUN_WIDTH-2))			
	Logic 
	(				
		.A(A)														,
		.B(B)														,
		.ALU_FUN(ALU_FUN[1:0])										,
		.Logic_Enable(Logic_en)										,
		.CLK(CLK)													,
		.RST(RST)													,
				
		.Logic_OUT(Logic_OUT)										,
		.OUT_VALID(Valid_Logic)			
	);		

/********************************************************************************************/
/********************************************************************************************/

	CMP_unit #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH), .OUT_WIDTH(OUT_WIDTH), .ALU_FUN_WIDTH(ALU_FUN_WIDTH-2))			
	CMP
	(		
		.A(A)														,
		.B(B)														,
		.ALU_FUN(ALU_FUN[1:0])										,
		.CMP_Enable(CMP_en)											,
		.CLK(CLK)													,
		.RST(RST)													,
				
		.CMP_OUT(CMP_OUT)											,
		.OUT_VALID(Valid_CMP)
	);	  			

/********************************************************************************************/
/********************************************************************************************/
	
	Shift_unit #(.A_WIDTH(A_WIDTH), .B_WIDTH(B_WIDTH), .OUT_WIDTH(OUT_WIDTH), .ALU_FUN_WIDTH(ALU_FUN_WIDTH-2))				
	Shift 
	(							
		.A(A)														,
		.B(B)														,
		.ALU_FUN(ALU_FUN[1:0])										,
		.Shift_Enable(Shift_en)										,
		.CLK(CLK)													,
		.RST(RST)													,
		
		.Shift_OUT(Shift_OUT)										,
		.OUT_VALID(Valid_Shift)								
	);

 endmodule