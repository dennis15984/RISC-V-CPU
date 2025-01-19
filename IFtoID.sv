module IFtoID(pcadd4_in,pcadd4_out,pc_in,pc_out,instr_mux,instr_in,instr_out,clk,rst,IF_stall,IF_flush);
  input [31:0] pc_in ,pcadd4_in, instr_in ;
  input IF_stall ,IF_flush ,clk , rst ;
  output logic[31:0] pc_out ,pcadd4_out ,instr_out;
  output logic[1:0] instr_mux ;
always_ff @( posedge rst , posedge clk ) begin 
  if(rst)begin
    pc_out<= 32'd0;
    instr_out<= 32'd0;
    pcadd4_out<= 32'd0;
    instr_mux<= 2'd1; 
    end

  else if (IF_flush)begin
    pc_out<= 32'd0;
    instr_out<= 32'd0;
    pcadd4_out<= 32'd0;
    instr_mux<= 2'd1;
  end

  else if(~IF_stall)begin 
    pc_out<= pc_in;
    instr_out<= instr_in;
    pcadd4_out<= pcadd4_in;
    instr_mux<= 2'd0;
  end

  else begin
    instr_out<= instr_in;
    instr_mux<= 2'd2;
  end
end
  
endmodule