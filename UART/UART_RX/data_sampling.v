module data_sampling #(parameter FRAME_WIDTH = 11)
(
    input   wire  [(FRAME_WIDTH-1)*2:0]     edge_cnt        ,
    input   wire                            dat_samp_en     ,
    input   wire                            RX_IN           ,
    input   wire  [5:0]                     Prescale        ,
    input   wire                            CLK             ,
    input   wire                            RST             ,

    output  reg                             sampled_bit
);

always@(posedge CLK or negedge RST)
begin

    if(!RST)
    sampled_bit <= 1'b0;
    else if(dat_samp_en)
    begin
        
    end

end


endmodule