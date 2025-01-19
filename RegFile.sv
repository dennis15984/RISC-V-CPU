module RegFile (ReAddr1,ReAddr2,WrAddr,WrVal,Val1,Val2,RegWrite,clk,rst);
  input RegWrite,clk,rst;
  input [4:0]ReAddr1,ReAddr2,WrAddr;
  input [31:0] WrVal; //32bit
  output [31:0] Val1,Val2;

  logic [31:0] RegMem [0:31];//declair array 

  always_ff @( posedge rst,posedge clk ) begin 
    if(rst)begin
      for(integer i=0;i<32;i++)begin
        RegMem[i]<=32'd0;    
      end
    end

    else if(WrAddr!=5'b0 && RegWrite==1'b1)
       RegMem[WrAddr] <= WrVal;
    end
    
    assign Val1 = (ReAddr1==5'b0)? 32'b0 :(RegWrite && WrAddr==ReAddr1) ? WrVal : RegMem[ReAddr1]; 

    assign Val2 = (ReAddr2==5'b0)? 32'b0 :(RegWrite && WrAddr==ReAddr2) ? WrVal : RegMem[ReAddr2]; 

  
endmodule
