# Create work library
vlib work

# Compile design files in correct order
vlog -sv parameter_define.sv
vlog -sv PCReg.sv
vlog -sv IFtoID.sv
vlog -sv RegFile.sv
vlog -sv Control_Unit.sv
vlog -sv Immediate_Unit.sv
vlog -sv IDtoEXE.sv
vlog -sv ALU.sv
vlog -sv MUX.sv
vlog -sv MUX3.sv
vlog -sv ConditionChecker.sv
vlog -sv EXEtoMEM.sv
vlog -sv MEMtoWB.sv
vlog -sv Forwarding_Unit.sv
vlog -sv LoadSignExtend.sv
vlog -sv SaveControl.sv
vlog -sv HazardDetection.sv
vlog -sv CSR.sv
vlog -sv SRAM.sv
vlog -sv SRAM_wrapper.sv
vlog -sv CPU.sv
vlog -sv cpu_tb.sv

# Start simulation
vsim -c cpu_tb

# Run simulation
run -all