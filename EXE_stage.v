module EX_Stage(
	input clk, rst, wb_en_in, mem_r_en_in, mem_w_en_in, status_w_en_in, branch_taken_in, immd,
    input[31:0] pc_in,
	input [3:0] exe_cmd,
	input [31:0] val_Rn, val_Rm_in,
	input [3:0] dest_in,
	input [23:0] signed_immd_24,
	input [11:0] shift_operand,
	input [3:0] status_reg_in,

	input [1:0] alu_mux_sel_src1, alu_mux_sel_src2,
	input [31:0] MEM_wb_value, WB_wb_value,

	output wb_en_out, mem_r_en_out, mem_w_en_out, status_w_en_out, branch_taken_out,
	output [3:0] dest_out,
	output [31:0] alu_res, val_Rm_out,
	output [3:0] status_register,
	output[31:0] branch_address
);

	wire is_mem_command;
	wire [31:0] val2;
	wire [31:0] alu_mux_src1, alu_mux_src2;

	assign wb_en_out = wb_en_in;
	assign mem_r_en_out = mem_r_en_in;
	assign mem_w_en_out = mem_w_en_in;
	assign status_w_en_out = status_w_en_in;
	assign branch_taken_out = branch_taken_in;
	assign dest_out = dest_in;

	assign is_mem_command = mem_r_en_in | mem_w_en_in;

	// branch_address = PC_in + signed_immd_24;
	adder #(.WORD_LENGTH(32)) adder(.in1(pc_in), .in2({signed_immd_24[23],
			signed_immd_24[23], signed_immd_24[23], signed_immd_24[23],
			signed_immd_24[23], signed_immd_24[23],signed_immd_24, 2'b0}),
			.out(branch_address)
	);	

	// ####### ALU src 1 MUX #######
	multiplexer_3_to_1 alu_src1_mux(.in1(val_Rn), .in2(WB_wb_value), .in3(MEM_wb_value), .sel(alu_mux_sel_src1), .out(alu_mux_src1));

	// ####### Val2 Generator #######
	multiplexer_3_to_1 alu_src2_mux(.in1(val_Rm_in), .in2(WB_wb_value), .in3(MEM_wb_value), .sel(alu_mux_sel_src2), .out(alu_mux_src2));
	
	Val2_generator val2_generator(.Rm(alu_mux_src2), .shift_operand(shift_operand), .immd(immd),
			.is_mem_command(is_mem_command), .val2_out(val2)
	);

	assign val_Rm_out = alu_mux_src2;

	// ####### ALU #######
	ALU alu(.alu_in1(alu_mux_src1), .alu_in2(val2), .alu_command(exe_cmd), .cin(status_reg_in[2]),
			.alu_out(alu_res), .status_register(status_register)
	);

endmodule
