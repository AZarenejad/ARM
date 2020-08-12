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

        mem_write_reg = 1'b0;
        mem_read_reg = 1'b0;
        wb_enable_reg = 1'b0;
        branch_taken_reg = 1'b0;
        ignore_hazard_reg = 1'b0;
        
            case (mode)
                // ARITHMETHIC_TYPE
                2'b00 : begin
                
                    case(opcode)
                        // MOV 
                        4'b1101 : begin
                            wb_enable_reg = 1'b1;
                            execute_command_reg = 4'b0001;
                            ignore_hazard_reg = 1'b1;
                        end

                        // MOVN
                        4'b1111 : begin 
                            wb_enable_reg = 1'b1;
                            execute_command_reg = 4'b1001;
                            ignore_hazard_reg = 1'b1;
                        end

                        // ADD
                        4'b0100 : begin 
                            wb_enable_reg = 1'b1;
                            execute_command_reg = 4'b0010;
                        end

                        // ADC
                        4'b0101 : begin 
                            wb_enable_reg = 1'b1;
                            execute_command_reg = 4'b0011;
                        end

                        // SUB
                        4'b0010 : begin
                            wb_enable_reg = 1'b1;
                            execute_command_reg = 4'b0100;
                        end

                        // SBC
                        4'b0110 : begin 
                            wb_enable_reg = 1'b1;
                            execute_command_reg = 4'b0101;
                        end

                        // AND
                        4'b0000 : begin 
                            wb_enable_reg = 1'b1;
                            execute_command_reg = 4'b0110;
                        end

                        // ORR
                        4'b1100 : begin 
                            wb_enable_reg = 1'b1;
                            execute_command_reg = 4'b0111;
                        end

                        // EOR
                        4'b0001 : begin 
                            wb_enable_reg = 1'b1;
                            execute_command_reg = 4'b1000;
                        end

                        // CMP
                        4'b1010 :
                            execute_command_reg = 4'b1100;

                        // TST
                        4'b1000 :
                            execute_command_reg = 4'b1110;

                        // LDR
                        4'b0100 : begin 
                            wb_enable_reg = 1'b1;
                            execute_command_reg = 4'b1010;
                        end

                        // STR
                        4'b0100 :
                            execute_command_reg = 4'b1010;
                endcase
            end

            // MEMORY_TYPE
            2'b01 : begin
                // ADD
                execute_command_reg = 4'b0010;
                case (s)
                    1'b1 : begin
                        mem_read_reg = 1'b1;
                        wb_enable_reg = 1'b1;
                    end
                    1'b0 : begin
                        mem_write_reg = 1'b1;
                    end
                endcase
            end
            
            // BRANCH_TYPE
            2'b10 : begin
                branch_taken_reg = 1'b1;
                ignore_hazard_reg = 1'b1;
            end
        endcase
    end
    
endmodule
