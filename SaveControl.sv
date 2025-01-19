`include "parameter_define.sv"

module SaveControl(RegVal2 ,DM_datain ,MemWrite ,MemWHB ,web_sel ,DM_web );
input [1:0]  web_sel ;
input [2:0]  MemWHB ;
input [31:0] RegVal2 ;
input MemWrite;
output logic [3:0]  DM_web;
output logic [31:0] DM_datain;

always_comb begin
  if(MemWrite != 1'b1)
    begin
      DM_web = 4'b1111;
      DM_datain = RegVal2;
    end  
  else 
    begin
      case(MemWHB)
	   `WORD:begin
           DM_web = 4'b0000;
           DM_datain = RegVal2; 
		       end
		 
		 `HALF:begin
		    if(web_sel[1]==1'b0)begin
			      DM_web = 4'b1100;
            DM_datain = {16'd0,RegVal2[15:0]}; 
			 end
			 else begin
			      DM_web = 4'b0011;
            DM_datain = {RegVal2[15:0], 16'd0}; 
			 end
		 end
		 
		 `BYTE:begin
          if(web_sel == 2'd1)begin
            DM_web = 4'b1101;
            DM_datain = {16'd0,RegVal2[7:0],8'd0};
          end
          else if(web_sel == 2'd2)begin
            DM_web = 4'b1011;
            DM_datain = {8'd0,RegVal2[7:0],16'd0};
          end
          else if(web_sel == 2'd3)begin
            DM_web = 4'b0111;
            DM_datain = {RegVal2[7:0],24'd0};
          end
          else begin
            DM_web = 4'b1110;
            DM_datain = RegVal2; 
          end
		 end
		 
		 default:begin
		        DM_web = 4'b1111;
            DM_datain = RegVal2;
		 end
	 endcase
  end
end
endmodule
