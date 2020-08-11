module Val2_generator(input [31:0] Rm, input [11:0] shift_operand, input immd, is_mem_command, 
                            output wire [31:0] val2_out);

    reg [31:0] imd_shifted;
    reg [31:0] rm_rotate;
    integer i;
    integer j;

    assign val2_out = (is_mem_command == 1'b0) ? 
        (
            // (immd == 1'b1) ? {24'b0, shift_operand[7:0]} // need for loop here.
            (immd == 1'b1) ? 
            (
                (shift_operand[11:8] == 4'b0) ? {24'b0, shift_operand[7:0]} : imd_shifted
            )
            // LSL_SHIFT_STATE
            : (shift_operand[6:5] == 2'b00) ? Rm << {1'b0, shift_operand[11:7]}
            // LSR_SHIFT_STATE
            : (shift_operand[6:5] == 2'b01) ? Rm >> {1'b0, shift_operand[11:7]}
            // ASR_SHIFT_STATE
            : (shift_operand[6:5] == 2'b10) ? Rm >>> {1'b0, shift_operand[11:7]}
            // ROR_SHIFT_STATE       
            : ((shift_operand[6:5] == 2'b11) && (shift_operand[11:8] == 4'b0)) ? Rm
            : rm_rotate
        )
        : {20'b0, shift_operand};
    
    
    always @(*) begin
        rm_rotate = Rm;
        for (i = 0; i < {1'b0, shift_operand[11:7]}; i = i + 1) begin
            rm_rotate = {rm_rotate[0], rm_rotate[31:1]}; 
        end
    end


    always @(*) begin
        imd_shifted = {24'b0, shift_operand[7:0]};
        for (j = 0; j < {1'b0, shift_operand[11:8]}; j = j + 1) begin
            imd_shifted = {imd_shifted[1], imd_shifted[0], imd_shifted[31:2]}; 
        end
    end
    
endmodule