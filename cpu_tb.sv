module cpu_tb();
    // Clock and reset signals
    logic clk;
    logic rst;
    
    // Memory interface signals
    logic IM_cs, DM_cs;
    logic IM_oe, DM_oe;
    logic [3:0] IM_web, DM_web;
    logic [13:0] IM_addr, DM_addr;
    logic [31:0] IM_datain, IM_dataout;
    logic [31:0] DM_datain, DM_dataout;
    
    // File reading variables
    int i;
    int file;
    string line;
    logic [31:0] instruction;

    // Helper function to get memory word
    function logic [31:0] get_mem_word(input int addr);
        return {DM1.i_SRAM.Memory_byte3[addr],
                DM1.i_SRAM.Memory_byte2[addr],
                DM1.i_SRAM.Memory_byte1[addr],
                DM1.i_SRAM.Memory_byte0[addr]};
    endfunction

    // Helper function to convert hex character to 4-bit value
    function logic [3:0] hex_to_4bit(input byte hex_char);
        if (hex_char >= "0" && hex_char <= "9")
            return hex_char - "0";
        else if (hex_char >= "a" && hex_char <= "f")
            return hex_char - "a" + 10;
        else if (hex_char >= "A" && hex_char <= "F")
            return hex_char - "A" + 10;
        else
            return 4'h0;
    endfunction

    // Helper function to print registers
    function void print_registers();
        $display("\nRegister File Contents:");
        $display("----------------------");
        for (int i = 0; i < 32; i += 4) begin
            $display("x%-2d: %8h    x%-2d: %8h    x%-2d: %8h    x%-2d: %8h",
                i, cpu_inst.RF.RegMem[i],
                i+1, cpu_inst.RF.RegMem[i+1],
                i+2, cpu_inst.RF.RegMem[i+2],
                i+3, cpu_inst.RF.RegMem[i+3]);
        end
    endfunction

    // Helper function to print data memory contents
    function void print_data_mem();
        $display("\nData Memory Contents:");
        $display("--------------------");
        for (int i = 0; i < 16; i += 4) begin
            $display("Word[%2d]: %8h    Word[%2d]: %8h    Word[%2d]: %8h    Word[%2d]: %8h",
                i, get_mem_word(i),
                i+1, get_mem_word(i+1),
                i+2, get_mem_word(i+2),
                i+3, get_mem_word(i+3));
        end
    endfunction

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Reset generation
    initial begin
        rst = 1;
        #20 rst = 0;
    end
    
    // CPU instantiation
    CPU cpu_inst (
        .clk(clk),
        .rst(rst),
        .IM_cs(IM_cs),
        .DM_cs(DM_cs),
        .IM_oe(IM_oe),
        .DM_oe(DM_oe),
        .IM_web(IM_web),
        .DM_web(DM_web),
        .IM_addr(IM_addr),
        .DM_addr(DM_addr),
        .IM_datain(IM_datain),
        .IM_dataout(IM_dataout),
        .DM_datain(DM_datain),
        .DM_dataout(DM_dataout)
    );

    // Instruction Memory
    SRAM_wrapper IM1 (
        .CK(clk),
        .CS(IM_cs),
        .OE(IM_oe),
        .WEB(IM_web),
        .A(IM_addr),
        .DI(IM_datain),
        .DO(IM_dataout)
    );

    // Data Memory
    SRAM_wrapper DM1 (
        .CK(clk),
        .CS(DM_cs),
        .OE(DM_oe),
        .WEB(DM_web),
        .A(DM_addr),
        .DI(DM_datain),
        .DO(DM_dataout)
    );

    // Main test sequence
    initial begin
        i = 0;
        
        // Initialize memories
        for (int idx = 0; idx < 16384; idx++) begin
            // Initialize both memories to 0
            IM1.i_SRAM.Memory_byte0[idx] = 8'h00;
            IM1.i_SRAM.Memory_byte1[idx] = 8'h00;
            IM1.i_SRAM.Memory_byte2[idx] = 8'h00;
            IM1.i_SRAM.Memory_byte3[idx] = 8'h00;
            
            DM1.i_SRAM.Memory_byte0[idx] = 8'h00;
            DM1.i_SRAM.Memory_byte1[idx] = 8'h00;
            DM1.i_SRAM.Memory_byte2[idx] = 8'h00;
            DM1.i_SRAM.Memory_byte3[idx] = 8'h00;
        end

        // Load test.mem into instruction memory
        file = $fopen("test.mem", "r");
        if (file) begin
            while (!$feof(file) && i < 1024) begin
                void'($fgets(line, file));
                // Skip comment lines and empty lines
                if (line.len() > 0 && line[0] != "/" && line[1] != "/") begin
                    // Read 8 hex characters for the instruction
                    if (line.len() >= 8) begin
                        instruction[31:28] = hex_to_4bit(line[0]);
                        instruction[27:24] = hex_to_4bit(line[1]);
                        instruction[23:20] = hex_to_4bit(line[2]);
                        instruction[19:16] = hex_to_4bit(line[3]);
                        instruction[15:12] = hex_to_4bit(line[4]);
                        instruction[11:8]  = hex_to_4bit(line[5]);
                        instruction[7:4]   = hex_to_4bit(line[6]);
                        instruction[3:0]   = hex_to_4bit(line[7]);
                        
                        // Store in instruction memory
                        IM1.i_SRAM.Memory_byte3[i] = instruction[31:24];
                        IM1.i_SRAM.Memory_byte2[i] = instruction[23:16];
                        IM1.i_SRAM.Memory_byte1[i] = instruction[15:8];
                        IM1.i_SRAM.Memory_byte0[i] = instruction[7:0];
                        
                        i = i + 1;
                    end
                end
            end
            $fclose(file);
        end else begin
            $display("Error: Could not open test.mem");
            $finish;
        end

        // Wait for reset
        @(negedge rst);
        
        // Run program 
        repeat(2000) @(posedge clk);
        
        // Print final state
        print_registers();
        print_data_mem();
        
        $stop;
    end

endmodule