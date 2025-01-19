module EXEtoMEM(clk, rst ,alures_in ,alures_out ,
                MemWHB_in ,MemWHB_out ,MemReWr_in ,MemReWr_out ,RegVal2_in ,RegVal2_out ,alu_res_pc4_in ,alu_res_pc4_out ,
		        pcadd4_in ,pcadd4_out ,RegWrite_in ,RegWrite_out ,RdAddr_in ,RdAddr_out ,CSR_sel_in ,CSR_sel_out ,instr_in ,instr_out);

input clk , rst ,alu_res_pc4_in ,RegWrite_in ,CSR_sel_in ;
input [1:0] MemReWr_in;
input [2:0] MemWHB_in;
input [4:0] RdAddr_in;
input [31:0] pcadd4_in ,RegVal2_in ,alures_in ,instr_in ;

output logic [1:0] MemReWr_out;
output logic [2:0] MemWHB_out;
output logic [4:0] RdAddr_out;
output logic [31:0] pcadd4_out, RegVal2_out, alures_out, instr_out;
output logic alu_res_pc4_out, RegWrite_out, CSR_sel_out;

always_ff @(posedge clk, posedge rst)begin
  if(rst)
   begin
     pcadd4_out<=       32'd0;
     RdAddr_out<=        5'd0; 
	 RegWrite_out<=      1'b0;
	 MemReWr_out<=       2'd0; 
	 MemWHB_out<=        3'd0; 
	 alu_res_pc4_out<=   1'b0;
	 CSR_sel_out<=       1'b0;  
	 alures_out<=        32'd0;      
	 RegVal2_out<=       32'd0; 
	 instr_out<=         32'd0;
	 end

  else 
    begin
     pcadd4_out<=        pcadd4_in;
     RdAddr_out<=        RdAddr_in; 
	 RegWrite_out<=      RegWrite_in;
	 MemReWr_out<=       MemReWr_in; 
	 MemWHB_out<=        MemWHB_in; 
	 alu_res_pc4_out<=   alu_res_pc4_in; 
	 CSR_sel_out<=       CSR_sel_in; 
	 alures_out<=        alures_in;     
	 RegVal2_out<=       RegVal2_in;  
	 instr_out<=         instr_in;
  end
end
endmodule
