module PCReg (pcin,pcout ,clk ,pc_stall ,rst );
input [31:0]pcin;
input clk,rst,pc_stall;
output logic [31:0]pcout;
always_ff@( posedge rst , posedge clk) begin
  if (rst) 
    pcout<= 32'd0;
  else if(~pc_stall)
    pcout<= pcin;
  end
endmodule
