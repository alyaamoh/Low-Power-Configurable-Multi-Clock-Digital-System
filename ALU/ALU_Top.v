/********************************************************************************************/
/********************************************************************************************/
/**************************		Author: Alyaa Mohamed  **************************************/
/**************************		Module: ALU_Top	       **************************************/
/********************************************************************************************/
/********************************************************************************************/

module ALU_Top #(parameter 	A_WIDTH = 8	, B_WIDTH = 8 , OUT_WIDTH = 8, ALU_FUN_WIDTH = 4)
(	
	input  wire [A_WIDTH-1:0] 			A							,
	input  wire [B_WIDTH-1:0] 			B							,
	input  wire [ALU_FUN_WIDTH-1:0] 	ALU_FUN						,
	input  wire							ALU_EN						,
	input  wire 		  				CLK							,
	input  wire							RST							,
	
	
	output wire  [OUT_WIDTH-1:0] 		ALU_OUT						,	
	output wire							OUT_VALID
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


	Decoder #(.OUT_WIDTH(OUT_WIDTH), .ALU_FUN_WIDTH (ALU_FUN_WIDTH-2))
	D1
	(																
		.ALU_FUN(ALU_FUN[3:2])										,
		.ALU_EN(ALU_EN)												,
		.Arith_OUT(Arith_OUT)										,
		.Logic_OUT(Logic_OUT)										,
		.CMP_OUT(CMP_OUT)											,
		.Shift_OUT(Shift_OUT)										,
		.Valid_Arith(Valid_Arith)									,
		.Valid_Logic(Valid_Logic)									,
		.Valid_CMP(Valid_CMP)										,
		.Valid_Shift(Valid_Shift)									,
		.CLK(CLK)													,
		.RST(RST)													,
										
		.ALU_OUT(ALU_OUT)													,								
		.OUT_VALID(OUT_VALID)										,								
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