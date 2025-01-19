`include "parameter_define.sv"

module LoadSignExtend(MemWHB, DM_dataout, LoadoutVal);
input [2:0]  MemWHB;
input [31:0] DM_dataout;
output logic [31:0] LoadoutVal;

always_comb begin
    case(MemWHB)
	   `WORD:
		  LoadoutVal=DM_dataout;
       `BYTE:
		  LoadoutVal={{24{DM_dataout[7]}}, DM_dataout[7:0]};
	   `BYTEU:
		  LoadoutVal={24'b0,DM_dataout[7:0]};
	   `HALF:
		  LoadoutVal={{16{DM_dataout[15]}},DM_dataout[15:0]};
	   `HALFU:
		  LoadoutVal={16'b0, DM_dataout[15:0]};
	  
		default:
		  LoadoutVal=32'd0;
	 endcase
end
endmodule 