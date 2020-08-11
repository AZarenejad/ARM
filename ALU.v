module ALU(input [31:0] alu_in1, alu_in2, input [3:0] alu_command, input cin, 
        output wire [31:0] alu_out, output wire [3:0] status_register);
    
    wire z, n;
    reg v, cout;
    assign status_register = {z, cout, n, v};

    assign z = (alu_out == 8'b0 ? 1 : 0);
    assign n = alu_out[31];

    reg [31:0] alu_out_temp;
    assign alu_out = alu_out_temp;
	
	
	always @(*) begin
	    cout = 1'b0;
        v = 1'b0;
	
		case(alu_command)
            // MOV_EXE
            4'b0001:
                alu_out_temp = alu_in2;
            
            // MOVN_EXE
            4'b1001:
                alu_out_temp = ~alu_in2; 

            // ADD_EXE
			4'b0010:
                begin
                    {cout, alu_out_temp} = alu_in1 + alu_in2;
                    v = ((alu_in1[31] == alu_in2[31])
                            & (alu_out_temp[31] != alu_in1[31]));
                end

            // ADC_EXE
			4'b0011:
                begin
                    {cout, alu_out_temp} = alu_in1 + alu_in2 + cin;
                    v = ((alu_in1[31] == alu_in2[31])
                            & (alu_out_temp[31] != alu_in1[31]));
                end
            
            // SUB_EXE
			4'b0100:
                begin
                    {cout, alu_out_temp} = {alu_in1[31], alu_in1} - {alu_in2[31], alu_in2};
                    v = ((alu_in1[31] == ~alu_in2[31])
                            & (alu_out_temp[31] != alu_in1[31]));
                end

            // SBC_EXE
			4'b0101:
                begin
                    {cout, alu_out_temp} = {alu_in1[31], alu_in1} - {alu_in2[31], alu_in2} - 33'd1;
                    v = ((alu_in1[31] == ~alu_in2[31])
                            & (alu_out_temp[31] != alu_in1[31]));
                end
            
            // AND_EXE
			4'b0110:
                alu_out_temp = alu_in1 & alu_in2;
            
            // ORR_EXE
			4'b0111:
                alu_out_temp = alu_in1 | alu_in2;
            
            // EOR_EXE
			4'b1000:
                alu_out_temp = alu_in1 ^ alu_in2;
            
            // CMP_EXE
			4'b1100: begin
					{cout, alu_out_temp} = {alu_in1[31], alu_in1} - {alu_in2[31], alu_in2};
                    v = ((alu_in1[31] == ~alu_in2[31])
                            & (alu_out_temp[31] != alu_in1[31]));
				end
            
            // TST_EXE
			4'b1110:
                alu_out_temp = alu_in1 & alu_in2;
            
            // LDR_EXE
			4'b1010:
                alu_out_temp = alu_in1 + alu_in2;
            
            // STR_EXE
			4'b1010:
                alu_out_temp = alu_in1 + alu_in2;

		endcase
	end

endmodule
