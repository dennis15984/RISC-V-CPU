module MUX3(in1 ,in2 ,in3 ,sel ,out);
  input [1:0] sel;
  input [31:0] in1 ,in2 ,in3;
  output logic [31:0] out;

  always_comb begin
    case(sel)
	   2'b00 : out = in1;
		 2'b01 : out = in2;
		 2'b10 : out = in3;
		 default : out = in1;
    endcase
  end
endmodule
