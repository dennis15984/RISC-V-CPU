module MUX(in1,in2,out,sel);
input [31:0] in1,in2;
input sel;//
output logic [31:0] out;
always_comb begin //
  out=(sel==1'b0)?in1:in2;
end
endmodule 
