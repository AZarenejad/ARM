module ID_stage(
	input clk,
	input rst,
	input[31:0] pc_in,
	input [31:0] instruction_in,
	input [3:0] status_register,
	input [31:0] reg_file_wb_data,
	input [3:0] reg_file_wb_address,
	input reg_file_wb_en, hazard,
		
	output[31:0] pc,
	output mem_read_en_out, mem_write_en_out,
		wb_enable_out, immediate_out,
		branch_taken_out, status_write_enable_out, ignore_hazard_out,
	output [3: 0] execute_command_out,
	output [31:0] reg_file_out1, reg_file_out2,
	output two_src,
	output [3:0] dest_reg_out,
	output [23:0] signed_immediate,
	output [11:0] shift_operand,
	output wire [3:0] reg_file_second_src_out, reg_file_first_src_out
);

	wire[3: 0] execute_command;

	wire[3:0] reg_file_src1, reg_file_src2;
	
	wire mem_read, mem_write,
		wb_enable, immediate,
		branch_taken, status_write_enable,
		cond_state, control_unit_mux_enable;

	// Number of control signals = 6
	wire[4 + 6 - 1 : 0] control_unit_mux_in, control_unit_mux_out;
		
	
	// Control Unit
	// Instruction[27:26] ==> mode
	// Instruction[24:21] ==> opcode
	controller control_unit(
		.mode(instruction_in[27 : 26]), .opcode(instruction_in[24 : 21]),
		.s(instruction_in[20]), .immediate_in(instruction_in[25]),
		.execute_command(execute_command),
		.mem_read(mem_read), .mem_write(mem_write),
		.wb_enable(wb_enable), .immediate(immediate),
		.branch_taken(branch_taken),
		.status_write_enable(status_write_enable),
		.ignore_hazard(ignore_hazard_out)
	);

	
	// Instruction[15:12] ==> Rd
	// Instruction[3:0] ==> Rm
	multiplexer_2_to_1 #(.WORD_LENGTH(4)) reg_file_src2_mux(
			.in1(instruction_in[15:12]), .in2(instruction_in[3:0]),
			.sel1(mem_write), .sel2(~mem_write),
			.out(reg_file_src2));
	
	assign reg_file_second_src_out = reg_file_src2;
	assign reg_file_first_src_out = reg_file_src1;

	// Instruction[19:16] ==> Rn
	assign reg_file_src1 = instruction_in[19:16];
	
	// Register file
	register_file register_file(.clk(clk), .rst(rst), .src1(reg_file_src1), .src2(reg_file_src2),
		.dest_wb(reg_file_wb_address),
		.result_wb(reg_file_wb_data),
		.write_back_en(reg_file_wb_en),
		.reg1(reg_file_out1), .reg2(reg_file_out2)
	);
	
	// Conditional Check
	// Instruction[31:28] ==> cond
	condition_check conditional_check(
		.cond(instruction_in[31:28]),
		.status_register(status_register),
		.cond_state(cond_state)
    );
	
	// Other components
	assign control_unit_mux_in = {execute_command, mem_read, mem_write,
			immediate, wb_enable, branch_taken,
			status_write_enable};
	
	assign control_unit_mux_enable = hazard | (~cond_state);
	
	// Number of control signals = 6
	// @TODO: Check the control_unit_mux_enable
	multiplexer_2_to_1 #(.WORD_LENGTH(4 + 6)) control_unit_mux(
			 .in1(control_unit_mux_in), .in2(10'b0),
			 .sel1(~control_unit_mux_enable),
			 .sel2(control_unit_mux_enable),
			 .out(control_unit_mux_out));
	
	assign {execute_command_out, mem_read_en_out, mem_write_en_out, immediate_out, wb_enable_out,
		branch_taken_out, status_write_enable_out} = control_unit_mux_out;
	
	assign pc = pc_in;
	
	// @TODO: Change this name
	// @TODO: Check the operands: mem_write_en_out or mem_write
	// instruction[25] ==> I
	assign two_src = (~instruction_in[25]) | mem_write_en_out;
	assign shift_operand = instruction_in[11:0];
	assign dest_reg_out = instruction_in[15:12];
	assign signed_immediate = instruction_in[23:0];
	
endmodule