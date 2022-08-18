/********************************************************************************************/
/********************************************************************************************/
/**************************		Author: Alyaa Mohamed    ************************************/
/**************************		Module: ALU_tb	     	 ************************************/
/********************************************************************************************/
/********************************************************************************************/

`timescale 1ns/1ps

module ALU_tb();

	parameter 	A_WIDTH_tb 		 = 8								,
				B_WIDTH_tb 		 = 8 								,
				OUT_WIDTH_tb 	 = 8								, 
				ALU_FUN_WIDTH_tb = 4								;
			
/********************************************************************************************/
/**********************************Internal Signals******************************************/

	reg [A_WIDTH_tb-1:0] 		A_tb								;
	reg [B_WIDTH_tb-1:0] 		B_tb								;
	reg [ALU_FUN_WIDTH_tb-1:0] 	ALU_FUN_tb							;
	reg							ALU_EN_tb							;
	reg 		  				CLK_tb								;
	reg							RST_tb								;


	wire  [OUT_WIDTH_tb-1:0] 	ALU_OUT_tb							;
	wire						OUT_VALID_tb						;

/********************************************************************************************/
/*********************************Clock Period***********************************************/

    localparam              CLK_PERIOD      = 100                   ;

/********************************************************************************************/
/********************************************************************************************/

	initial
	  begin
	
		$dumpfile("ALU_tb.vcd") 									;
		$dumpvars 													;
								
		A_tb 		= 'b0											;
		B_tb 		= 'b0											;
		ALU_FUN_tb 	= 'b0											;
		ALU_EN_tb	= 'b0											;
		CLK_tb 		= 'b0											;
		RST_tb		= 'b0											;
								
		$monitor ("\nOUT_VALID = %b\n",OUT_VALID_tb)				;

/********************************************************************************************/
/***********************************Test Cases***********************************************/
		#CLK_PERIOD
		RST_tb = 'b1												;

		$display ("\nArithmetic Operations Tests")					;					
		$display ("\n\nTEST CASE 1")								;	

		#CLK_PERIOD					

		A_tb = 'd5													;
		B_tb = 'd2													;
		ALU_EN_tb  = 'b1											;

		ALU_FUN_tb = 'b0000											;

		#(CLK_PERIOD*3)

		if(ALU_OUT_tb != 'd7)
			
			$display ("\nTEST CASE 1 IS FAILED") 					;
		
		else
		
			$display ("\nTEST CASE 1 IS PASSED")					;
								
/********************************************************************************************/
/********************************************************************************************/
								
		$display ("\n\nTEST CASE 2")								;	

		#CLK_PERIOD					

		A_tb = 'd5													;
		B_tb = 'd2													;

		ALU_FUN_tb = 'b0001											;

		#(CLK_PERIOD*3)

		if(ALU_OUT_tb != 'd3)
			  
			$display ("\nTEST CASE 2 IS FAILED") 					;
			
		else
			
			$display ("\nTEST CASE 2 IS PASSED")					;
								
/********************************************************************************************/
/********************************************************************************************/
								
		$display ("\n\nTEST CASE 3")								;	

		#CLK_PERIOD					

		A_tb = 'd5													;
		B_tb = 'd2													;

		ALU_FUN_tb = 'b0010											;

		#(CLK_PERIOD*3)

		if(ALU_OUT_tb != 'd10)
			  
			$display ("\nTEST CASE 3 IS FAILED") 					;
			
		else
			
			$display ("\nTEST CASE 3 IS PASSED")					;
								
/********************************************************************************************/
/********************************************************************************************/
								
		$display ("\n\nTEST CASE 4")								;	

		#CLK_PERIOD						

		A_tb = 'd4													;
		B_tb = 'd2													;

		ALU_FUN_tb = 'b0011											;

		#(CLK_PERIOD*3)

		if(ALU_OUT_tb != 'd2)
			  
			$display ("\nTEST CASE 4 IS FAILED") 					;
			
		else
			
			$display ("\nTEST CASE 4 IS PASSED")					;
								
/********************************************************************************************/
/********************************************************************************************/

		$display ("\n\n Logic Operations Tests")					;						
		$display ("\n\nTEST CASE 5")								;	

		#CLK_PERIOD					

		A_tb = 'd5													;
		B_tb = 'd2													;

		ALU_FUN_tb = 'b0100											;

		#(CLK_PERIOD*3)

		if(ALU_OUT_tb != 'd0)
			  
			$display ("\nTEST CASE 5 IS FAILED") 					;
			
		else
			
			$display ("\nTEST CASE 5 IS PASSED")					;
								
/********************************************************************************************/
/********************************************************************************************/
								
		$display ("\n\nTEST CASE 6")								;	

		#CLK_PERIOD						

		A_tb = 'd5													;
		B_tb = 'd2													;

		ALU_FUN_tb = 'b0101											;

		#(CLK_PERIOD*3)

		if(ALU_OUT_tb != 'd7)
			  
			$display ("\nTEST CASE 6 IS FAILED") 					;
			
		else
			
			$display ("\nTEST CASE 6 IS PASSED")					;
								
/********************************************************************************************/
/********************************************************************************************/
								
		$display ("\n\nTEST CASE 7")								;	

		#CLK_PERIOD						

		A_tb = 'd5													;
		B_tb = 'd4													;

		ALU_FUN_tb = 'b0110											;

		#(CLK_PERIOD*3)

		if(ALU_OUT_tb != 'b1111_1011)
			  
			$display ("\nTEST CASE 7 IS FAILED") 					;
			
		else
			
			$display ("\nTEST CASE 7 IS PASSED")					;
								
/********************************************************************************************/
/********************************************************************************************/
								
		$display ("\n\nTEST CASE 8")								;	

		#CLK_PERIOD						

		A_tb = 'd5													;
		B_tb = 'd2													;

		ALU_FUN_tb = 'b0111											;

		#(CLK_PERIOD*3)

		if(ALU_OUT_tb != 'b1111_1000)
			  
			$display ("\nTEST CASE 8 IS FAILED") 					;
			
		else
			
			$display ("\nTEST CASE 8 IS PASSED")					;
								
/********************************************************************************************/
/********************************************************************************************/

		$display ("\n\nCMP Operations Tests")						;			
		$display ("\n\nTEST CASE 9")								;	

		#CLK_PERIOD						

		A_tb = 'd5													;
		B_tb = 'd2													;

		ALU_FUN_tb = 'b1000											;

		#(CLK_PERIOD*3)

		if(ALU_OUT_tb != 'd0)
			  
			$display ("\nTEST CASE 9 IS FAILED") 					;
			
		else
			
			$display ("\nTEST CASE 9 IS PASSED")					;
								
/********************************************************************************************/
/********************************************************************************************/
								
		$display ("\n\nTEST CASE 10")								;	

		#CLK_PERIOD						

		A_tb = 'd5													;
		B_tb = 'd5													;

		ALU_FUN_tb = 'b1001											;

		#(CLK_PERIOD*3)

		if(ALU_OUT_tb != 16'd1)
			  
			$display ("\nTEST CASE 10 IS FAILED") 					;
			
		else
			
			$display ("\nTEST CASE 10 IS PASSED")					;
								
/********************************************************************************************/
/********************************************************************************************/
								
		$display ("\n\nTEST CASE 11")								;	

		#CLK_PERIOD					

		A_tb = 'd5													;
		B_tb = 'd2													;

		ALU_FUN_tb = 'b1001											;

		#(CLK_PERIOD*3)

		if(ALU_OUT_tb != 16'd0)
			  
			$display ("\nTEST CASE 11 IS FAILED") 					;
			
		else
			
			$display ("\nTEST CASE 11 IS PASSED")					;						

/********************************************************************************************/
/********************************************************************************************/
								
		$display ("\n\nTEST CASE 12")								;	

		#CLK_PERIOD						

		A_tb = 'd5													;
		B_tb = 'd2													;

		ALU_FUN_tb = 'b1010											;

		#(CLK_PERIOD*3)

		if(ALU_OUT_tb != 'd2)
			  
			$display ("\nTEST CASE 12 IS FAILED") 					;
			
		else
			
			$display ("\nTEST CASE 12 IS PASSED")					;

/********************************************************************************************/
/********************************************************************************************/
								
		$display ("\n\nTEST CASE 13")								;	

		#CLK_PERIOD						

		A_tb = 'd2													;
		B_tb = 'd5													;

		ALU_FUN_tb = 'b1010											;

		#(CLK_PERIOD*3)

		if(ALU_OUT_tb != 'd0)
			  
			$display ("\nTEST CASE 13 IS FAILED") 					;
			
		else
			
			$display ("\nTEST CASE 13 IS PASSED")					;
								
/********************************************************************************************/
/********************************************************************************************/
								
		$display ("\n\nTEST CASE 14")								;	

		#CLK_PERIOD					

		A_tb = 'd2													;
		B_tb = 'd5													;

		ALU_FUN_tb = 'b1011											;

		#(CLK_PERIOD*3)

		if(ALU_OUT_tb != 'd3)
			  
			$display ("\nTEST CASE 14 IS FAILED") 					;
			
		else
			
			$display ("\nTEST CASE 14 IS PASSED")					;
								
/********************************************************************************************/
/********************************************************************************************/
								
		$display ("\n\nTEST CASE 15")								;	

		#CLK_PERIOD						

		A_tb = 'd5													;
		B_tb = 'd2													;

		ALU_FUN_tb = 'b1011											;

		#(CLK_PERIOD*3)

		if(ALU_OUT_tb != 'd0)
			  
			$display ("\nTEST CASE 15 IS FAILED") 					;
			
		else
			
			$display ("\nTEST CASE 15 IS PASSED")					;						

/********************************************************************************************/
/********************************************************************************************/

		$display ("\n\nShift Operations Tests")						;					
		$display ("\n\nTEST CASE 16")								;	

		#CLK_PERIOD						

		A_tb = 'd5													;
		B_tb = 'd2													;

		ALU_FUN_tb = 'b1100											;

		#(CLK_PERIOD*3)

		if(ALU_OUT_tb != 'd2)
			  
			$display ("\nTEST CASE 16 IS FAILED") 					;
			
		else
			
			$display ("\nTEST CASE 16 IS PASSED")					;
								
/********************************************************************************************/
/********************************************************************************************/
								
		$display ("\n\nTEST CASE 17")								;	

		#CLK_PERIOD						

		A_tb = 'd5													;
		B_tb = 'd2													;

		ALU_FUN_tb = 'b1101											;

		#(CLK_PERIOD*3)

		if(ALU_OUT_tb != 'd10)
			  
			$display ("\nTEST CASE 17 IS FAILED") 					;
			
		else
			
			$display ("\nTEST CASE 17 IS PASSED")					;
								
/********************************************************************************************/
/********************************************************************************************/
								
		$display ("\n\nTEST CASE 18")								;	

		#CLK_PERIOD						

		A_tb = 'd5													;
		B_tb = 'd2													;

		ALU_FUN_tb = 'b1110											;

		#(CLK_PERIOD*3)

		if(ALU_OUT_tb != 'd1)
			  
			$display ("\nTEST CASE 18 IS FAILED") 					;
			
		else
			
			$display ("\nTEST CASE 18 IS PASSED")					;
								
/********************************************************************************************/
/********************************************************************************************/
								
		$display ("\n\nTEST CASE 19")								;	

		#CLK_PERIOD						

		A_tb = 'd5													;
		B_tb = 'd2													;

		ALU_FUN_tb = 'b1111											;

		#(CLK_PERIOD*3)

		if(ALU_OUT_tb != 'd4)
			  
			$display ("\nTEST CASE 19 IS FAILED") 					;
			
		else
			
			$display ("\nTEST CASE 19 IS PASSED")					;

		#(CLK_PERIOD*10)

		$finish														;	  

	  end

/********************************************************************************************/
/*********************************Clock Generator********************************************/

    always #(CLK_PERIOD*0.5) CLK_tb = !CLK_tb			    		;

/********************************************************************************************/
/******************************Instantiation Of The Top Module*******************************/

	ALU_Top #(.A_WIDTH(A_WIDTH_tb)	, .B_WIDTH(B_WIDTH_tb) , .OUT_WIDTH(OUT_WIDTH_tb) , .ALU_FUN_WIDTH(ALU_FUN_WIDTH_tb))
	DUT
	(	
		.A(A_tb)													,
		.B(B_tb)													,
		.ALU_FUN(ALU_FUN_tb)										,
		.ALU_EN(ALU_EN_tb)											,
		.CLK(CLK_tb)												,
		.RST(RST_tb)												,
		
		
		.ALU_OUT(ALU_OUT_tb)										,	
		.OUT_VALID(OUT_VALID_tb)
	);


endmodule