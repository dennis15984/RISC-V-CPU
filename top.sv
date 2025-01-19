`include "../src/CPU.sv"
`include "../src/SRAM_wrapper.sv"
module top (clk,rst);
input clk,rst;

logic DM_CS ,IM_CS ,DM_OE ,IM_OE ;
logic [3:0]  DM_WEB ,IM_WEB ;
logic [13:0] DM_Addr ,IM_Addr;
logic [31:0] DM_DO ,IM_DO; 
logic [31:0] DM_DI ,IM_DI;

CPU cpu
(.clk(clk), .rst(rst), 
.IM_cs(IM_CS), .IM_oe(IM_OE), .IM_web(IM_WEB), .IM_addr(IM_Addr), .IM_datain(IM_DI), .IM_dataout(IM_DO),  
.DM_cs(DM_CS), .DM_oe(DM_OE), .DM_web(DM_WEB), .DM_addr(DM_Addr), .DM_datain(DM_DI), .DM_dataout(DM_DO));
        
SRAM_wrapper IM1
( .CK(clk), .CS(IM_CS), .OE(IM_OE), .WEB(IM_WEB), .A(IM_Addr), .DI(IM_DI), .DO(IM_DO)); 

SRAM_wrapper DM1
( .CK(clk), .CS(DM_CS), .OE(DM_OE), .WEB(DM_WEB), .A(DM_Addr), .DI(DM_DI), .DO(DM_DO));
endmodule
