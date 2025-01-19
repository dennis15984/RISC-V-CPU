module CSR (clk ,rst ,instr ,csr_data);
input clk,rst;
input [31:0] instr;
output logic [31:0] csr_data;
logic [63:0] cc_count;
logic [63:0] instret;
logic [63:0] csr_cycle;
always_ff @(posedge rst , posedge clk) begin
    if(rst) begin
      cc_count <= 64'b0;  
    end
    else 
      cc_count <= cc_count + 64'b1;  
end

always_ff @(posedge rst , posedge clk) begin
    if(rst)begin
      instret <= 64'b0;  
    end

    else if(instr[1:0]==2'b11)begin
        instret <= instret + 64'b1;
    end
    
    else begin
        instret <= instret;
    end
end

always_comb begin
    csr_cycle = cc_count - 64'b11;
end

always_comb begin
    case ({instr[27],instr[21]})
        2'b01: csr_data = instret[31:0]; 
        2'b10: csr_data = csr_cycle[63:32];
        2'b11: csr_data = instret[63:32];
        default: csr_data = csr_cycle[31:0];
    endcase
end
endmodule