`include "parameter_define.sv"

module Forwarding_Unit(forwardA ,forwardB ,RegAddr1 ,RegAddr2 ,MEM_RdAddr ,WB_RdAddr ,MEM_RegWrite ,WB_RegWrite);
input MEM_RegWrite ,WB_RegWrite ;    
input [4:0] RegAddr1 ,RegAddr2 ,MEM_RdAddr ,WB_RdAddr;        
output logic [1:0] forwardA, forwardB;
always_comb begin
    priority if(MEM_RegWrite && MEM_RdAddr == RegAddr1)begin
         if(WB_RegWrite && WB_RdAddr == RegAddr2)begin
            forwardA = `MEMRDA;
            forwardB = `WBRDB;
            end
         else begin
            forwardA = `MEMRDA;
            forwardB = `NOFB;
            end
     end
	  
     else if(MEM_RegWrite && MEM_RdAddr == RegAddr2)begin
         if(WB_RegWrite && WB_RdAddr == RegAddr1)begin
            forwardA = `WBRDA;
            forwardB = `MEMRDB;
            end
         else begin
            forwardA = `NOFA;
            forwardB = `MEMRDB;
            end 
     end
	  
     else if(WB_RegWrite && WB_RdAddr == RegAddr1)begin
         forwardA = `WBRDA;
         forwardB = `NOFB;
     end
	  
     else if(WB_RegWrite && WB_RdAddr == RegAddr2)begin
         forwardA = `NOFA;
         forwardB = `WBRDB;
     end
	  
     else begin
         forwardA = `NOFA;
         forwardB = `NOFB;
     end
end
endmodule
