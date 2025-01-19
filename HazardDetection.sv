module HazardDetection(RegAddr1 ,RegAddr2 ,pc_stall ,IF_flush ,IF_stall ,ID_stall ,ID_flush ,BranchorJump ,RdAddr ,MemRead);
input [4:0] RegAddr1, RegAddr2, RdAddr;
input  MemRead;
input  BranchorJump; 

output logic pc_stall ,IF_stall ,IF_flush ,ID_stall ,ID_flush;

always_comb begin
    if(MemRead && (RdAddr == RegAddr1 || RdAddr == RegAddr2))begin //load-use data hazard
        pc_stall = 1'b1;
        IF_stall = 1'b1;
        IF_flush = 1'b0;
        ID_stall = 1'b0;
        ID_flush = 1'b1;      
    end
    else if(BranchorJump)begin 
        pc_stall = 1'b0;
        IF_stall = 1'b0;
        IF_flush = 1'b1;
        ID_stall = 1'b0;
        ID_flush = 1'b1; 
    end
    else begin
        pc_stall = 1'b0;
        IF_stall = 1'b0;
        IF_flush = 1'b0;
        ID_stall = 1'b0;
        ID_flush = 1'b0; 
    end
end
endmodule
