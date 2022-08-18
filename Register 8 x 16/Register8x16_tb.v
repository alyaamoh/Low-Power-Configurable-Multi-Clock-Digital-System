/********************************************************************************************/
/********************************************************************************************/
/**************************		Author: Alyaa Mohamed    ************************************/
/**************************		Module: Register8x16_tb	 ************************************/
/********************************************************************************************/
/********************************************************************************************/

`timescale 1ns/1ps

module Register8x16_tb ()									;

	parameter 	WIDTH_tb 	     = 16						,
				DEPTH_tb 	     = 8						,
	 		  	ADDRESS_WIDTH_tb = 4						;

/********************************************************************************************/
/***********************************Internal Signals*****************************************/

	reg 	[WIDTH_tb-1:0] 			WrData_tb				;
	reg 	[ADDRESS_WIDTH_tb-1:0] 	Address_tb				;
	reg		  						WrEn_tb					;
	reg		  						RdEn_tb					;
	reg		  						CLK_tb					;
	reg		  						RST_tb					;

	wire 	[WIDTH_tb-1:0]			RdData_tb				;
	wire							RdData_Valid_tb			;
	wire    [WIDTH_tb-1:0]			REG0_tb					;
	wire    [WIDTH_tb-1:0]			REG1_tb					;
	wire    [WIDTH_tb-1:0]			REG2_tb					;
	wire    [WIDTH_tb-1:0]			REG3_tb					;

/********************************************************************************************/
/****************************************Clock Period****************************************/

	localparam              CLK_PERIOD      = 100           ;

/********************************************************************************************/
/********************************************************************************************/

	initial
		begin
		
			$dumpfile("Register8x16_tb.vcd") 				;
			$dumpvars 										;
			
			WrData_tb 	= 'd0								;
			Address_tb 	= 'd0								;
			WrEn_tb 	= 'd0								;
			RdEn_tb		= 'd0								;
			CLK_tb		= 'd0								;
			RST_tb		= 'd0								;

			$monitor("\nRdData_Valid = %b\n",RdData_Valid_tb);

/********************************************************************************************/
/*******************************Load Values To The Register**********************************/
			
			$display ("\n\nLoad the first value")			;	

			#CLK_PERIOD	
			
			WrEn_tb 	= 'd1								;
			RdEn_tb		= 'd0								;
			WrData_tb 	= 'd2								;
			Address_tb 	= 'd0								;
			RST_tb		= 'd1								;

			#CLK_PERIOD

/********************************************************************************************/
/********************************************************************************************/
			
			$display ("\n\nLoad the second value")			;	
			
			#CLK_PERIOD						
			
			WrEn_tb 	= 'd1								;
			RdEn_tb		= 'd0								;
			WrData_tb 	= 'd4								;
			Address_tb 	= 'd1								;


			#CLK_PERIOD

/********************************************************************************************/
/*******************************Read The Values From The Register****************************/

			$display ("\n\nRead the first value")			;	
			
			#CLK_PERIOD						
			
			WrEn_tb 	= 'd0								;
			RdEn_tb		= 'd1								;
			WrData_tb 	= 'd0								;
			Address_tb 	= 'd0								;

			#CLK_PERIOD
			
			if( REG0_tb != 'd2 )
				
				$display ("\nTEST CASE  IS FAILED\n") 		;
				
			else
				
				 $display ("\nTEST CASE  IS PASSED\n")		;						

/********************************************************************************************/
/********************************************************************************************/

			$display ("\n\nRead the second value")			;
			
			#CLK_PERIOD
			
			WrEn_tb 	= 'd0								;
			RdEn_tb		= 'd1								;
			WrData_tb 	= 'd0								;
			Address_tb 	= 'd1								;

			#CLK_PERIOD
			
			if( RdData_tb != 'd4 )
				
				$display ("\nTEST CASE  IS FAILED\n") 		;
				
			else
				
				 $display ("\nTEST CASE  IS PASSED\n")		;	 

/********************************************************************************************/
/********************************************************************************************/
			
			$display ("\n\nLoad the third value")			;	
			
			#CLK_PERIOD						
			
			WrEn_tb 	= 'd1								;
			RdEn_tb		= 'd0								;
			WrData_tb 	= 'd6								;
			Address_tb 	= 'd8								;


			#CLK_PERIOD

/********************************************************************************************/
/********************************************************************************************/

			#(CLK_PERIOD*10)

			$finish;	
		
		end
		
/********************************************************************************************/
/**********************************Clock Generator*******************************************/		
		
	always #(CLK_PERIOD*0.5) CLK_tb = !CLK_tb			;
		
/********************************************************************************************/
/*****************************Instantiation The Module***************************************/		
		
	Register8x16 #(.WIDTH(WIDTH_tb), .DEPTH(DEPTH_tb), .ADDRESS_WIDTH(ADDRESS_WIDTH_tb))	
	DUT					
	(			

		.WrData(WrData_tb)									,
		.Address(Address_tb)								,
		.WrEn(WrEn_tb)										,
		.RdEn(RdEn_tb)										,
		.CLK(CLK_tb)										,
		.RST(RST_tb)										,
		
		.RdData(RdData_tb)									,
		.RdData_Valid(RdData_Valid_tb)						,	
		.REG0(REG0_tb)										,
		.REG1(REG1_tb)										,
		.REG2(REG2_tb)										,
		.REG3(REG3_tb)					

	);
	
endmodule	