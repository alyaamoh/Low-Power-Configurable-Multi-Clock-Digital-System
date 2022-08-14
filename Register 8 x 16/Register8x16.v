/********************************************************************************************/
/********************************************************************************************/
/**************************		Author: Alyaa Mohamed    ************************************/
/**************************		Module: Register8x16	 ************************************/
/********************************************************************************************/
/********************************************************************************************/

module Register8x16 #(parameter WIDTH = 16, DEPTH = 8, ADDRESS_WIDTH = 4)			
(			
	input 	wire [WIDTH-1:0] 			WrData					,
	input 	wire [ADDRESS_WIDTH-1:0] 	Address					,
	input 	wire		  				WrEn					,
	input 	wire		  				RdEn					,
	input 	wire		  				CLK						,
	input 	wire		  				RST						,

	output 	reg	 [WIDTH-1:0]			RdData					,
	output	reg							RdData_Valid			,
	output	wire [WIDTH-1:0]			REG0					,
	output	wire [WIDTH-1:0]			REG1					,
	output	wire [WIDTH-1:0]			REG2					,
	output	wire [WIDTH-1:0]			REG3					
);

	reg 		 [WIDTH-1:0] 			Register [DEPTH-1:0]	;

	integer 							i						;

/********************************************************************************************/
/********************************************************************************************/

	assign REG0 = Register[0]									;
	assign REG1 = Register[1]									;
	assign REG2 = Register[2]									;
	assign REG3 = Register[3]									;

/********************************************************************************************/
/********************************************************************************************/

	always@(posedge CLK or negedge RST)
		begin
		
			if(!RST)
				begin
				
					RdData       <= 'b0							;
					RdData_Valid <= 'b0							;
				
					for ( i = 0 ; i < DEPTH ; i = i + 1 )
						
						Register[i] <= 'd0						;
				
				end
			else
				begin
				
					if(WrEn)
						begin

							Register[Address] <= WrData 		;
							RdData_Valid 	  <= 'b0			;
						
						end
					else if(RdEn)	
						begin

							RdData <= Register[Address]			;
							RdData_Valid <= 'b1					;
						
						end
					else

						RdData_Valid <= 'b0						;	
				
				end
		
		end

endmodule