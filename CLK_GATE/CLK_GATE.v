/********************************************************************************************/
/********************************************************************************************/
/**************************		Author: Alyaa Mohamed    **************************************/
/**************************		Module: CLK_GATE	       **************************************/
/********************************************************************************************/
/********************************************************************************************/

module CLK_GATE 
(
  input   wire      CLK_EN              ,
  input   wire      CLK                 ,

  output  reg       GATED_CLK
);

/********************************************************************************************/
/********************************************************************************************/

  reg               Latch_Out           ;

/********************************************************************************************/
/********************************************************************************************/

  always @(CLK or CLK_EN)
    begin
      if(!CLK)      

        Latch_Out <= CLK_EN             ;

    end

/********************************************************************************************/
/********************************************************************************************/

  assign  GATED_CLK = CLK && Latch_Out  ;

endmodule