module MEMtoWB(clk ,rst ,RdAddr_in ,RegWrite_in ,MemReWr_in ,MemWHB_in ,RdVal_in ,
                        RdAddr_out ,RegWrite_out ,MemReWr_out ,MemWHB_out ,  RdVal_out);

input clk, rst, RegWrite_in;
input [1:0] MemReWr_in;
input [2:0] MemWHB_in;
input [4:0] RdAddr_in;
input [31:0] RdVal_in;

output logic RegWrite_out;
output logic [1:0] MemReWr_out;
output logic [2:0] MemWHB_out;
output logic [4:0] RdAddr_out;
output logic [31:0] RdVal_out;

always_ff @(posedge clk, posedge rst)begin
  if(rst)begin
    RdAddr_out<=   5'b0;
    RegWrite_out<= 1'b0;
    MemReWr_out<=  2'b0;
    MemWHB_out<=   3'b0;
    RdVal_out<=    32'b0;	 
  end
  else begin
    RdAddr_out<=   RdAddr_in;
    RegWrite_out<= RegWrite_in;
    MemReWr_out<=  MemReWr_in;
    MemWHB_out<=   MemWHB_in;
    RdVal_out<=    RdVal_in;
  end
end
endmodule
