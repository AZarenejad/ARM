module controller(input[1:0] mode, input[3:0] opcode, input s, immediate_in,
        output wire[3:0] execute_command,
        output wire mem_read, mem_write, wb_enable, immediate, branch_taken, status_write_enable, ignore_hazard);

   
    reg mem_read_reg, mem_write_reg,
            wb_enable_reg, branch_taken_reg, status_write_enable_reg, ignore_hazard_reg;
    reg [3:0] execute_command_reg;
        
    assign immediate = immediate_in;
    assign status_write_enable = s;
    
    assign execute_command = execute_command_reg;
    assign mem_read = mem_read_reg;
    assign mem_write = mem_write_reg;
    assign wb_enable = wb_enable_reg;
    assign branch_taken = branch_taken_reg;
    assign ignore_hazard = ignore_hazard_reg;

        always @(mode, opcode, s) begin

        wb_enable_reg = 1'b0;
        mem_write_reg = 1'b0;
        mem_read_reg = 1'b0;
        branch_taken_reg = 1'b0;
        ignore_hazard_reg = 1'b0;


        wb_enable_reg = ((mode == 2'b00 && opcode == 4'b1101) || (mode == 2'b00 && opcode == 4'b1111)
                        || (mode == 2'b00 && opcode == 4'b0100) || (mode == 2'b00 && opcode == 4'b0101)
                        || (mode == 2'b00 && opcode == 4'b0010) || (mode == 2'b00 && opcode == 4'b0110)
                        || (mode == 2'b00 && opcode == 4'b0000) || (mode == 2'b00 && opcode == 4'b1100)
                        || (mode == 2'b00 && opcode == 4'b0001) || (mode == 2'b00 && opcode == 4'b0100)
                        || (mode == 2'b01 && s == 1'b1)) ? 1'b1 : 1'b0;
        
        mem_write_reg = (mode == 2'b01 && s == 1'b0 ) ? 1'b1 : 1'b0;

        mem_read_reg = (mode == 2'b01 && s == 1'b1) ? 1'b1 : 1'b0;

        branch_taken_reg = (mode == 2'b10) ? 1'b1 : 1'b0;

        ignore_hazard_reg = ((mode == 2'b10) || (mode == 2'b00 && opcode == 4'b1101) ||
                            (mode == 2'b00 && opcode == 4'b1111)) ? 1'b1 : 1'b0;

        execute_command_reg = (mode == 2'b00 && opcode == 4'b1101) ? 4'b0001 :
                        (mode == 2'b00 && opcode == 4'b1111) ? 4'b1001 :
                        (mode == 2'b00 && opcode == 4'b0100) ? 4'b0010 :
                        (mode == 2'b00 && opcode == 4'b0101) ? 4'b0011 :
                        (mode == 2'b00 && opcode == 4'b0010) ? 4'b0100 :
                        (mode == 2'b00 && opcode == 4'b0110) ? 4'b0101 :
                        (mode == 2'b00 && opcode == 4'b0000) ? 4'b0110 :
                        (mode == 2'b00 && opcode == 4'b1100) ? 4'b0111 :
                        (mode == 2'b00 && opcode == 4'b0001) ? 4'b1000 :
                        (mode == 2'b00 && opcode == 4'b1010) ? 4'b1100 :
                        (mode == 2'b00 && opcode == 4'b1000) ? 4'b1110 :
                        (mode == 2'b00 && opcode == 4'b0100) ? 4'b1010 :
                        (mode == 2'b01) ? 4'b0010 : 4'bx;
    end
    
endmodule
