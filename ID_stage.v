module ID_stage(input rst, clk, reg_file_wb_en, hazard, input[31:0] pc_in, instruction_in, reg_file_wb_data,
	input [3:0] status_register, reg_file_wb_address,
	output[31:0] pc, reg_file_out1, reg_file_out2,
	output mem_read_en_out, mem_write_en_out, wb_enable_out, immediate_out, branch_taken_out,
	status_write_enable_out, ignore_hazard_out, two_src,
	output [3: 0] execute_command_out, dest_reg_out, output [23:0] signed_immediate,
	output [11:0] shift_operand, output wire [3:0] reg_file_second_src_out, reg_file_first_src_out
);

	wire[3: 0] execute_command;

	wire[3:0] reg_file_src1, reg_file_src2;
	
	wire mem_read, mem_write, wb_enable, immediate, branch_taken, status_write_enable, cond_state, control_unit_mux_enable;

	wire[9:0] control_unit_mux_in, control_unit_mux_out;
		
	
	// Control Unit
	// Instruction[27:26] ==> mode
	// Instruction[24:21] ==> opcode
	controller control_unit(.mode(instruction_in[27 : 26]), .opcode(instruction_in[24 : 21]),
		.s(instruction_in[20]), .immediate_in(instruction_in[25]), .execute_command(execute_command),
		.mem_read(mem_read), .mem_write(mem_write), .wb_enable(wb_enable), .immediate(immediate),
		.branch_taken(branch_taken), .status_write_enable(status_write_enable), .ignore_hazard(ignore_hazard_out)
	);

	
	// Instruction[15:12] ==> Rd
	// Instruction[3:0] ==> Rm
	multiplexer_2_to_1 #(.WORD_LENGTH(4)) reg_file_src2_mux(.in1(instruction_in[15:12]), .in2(instruction_in[3:0]),
			.sel1(mem_write), .sel2(~mem_write), .out(reg_file_src2));
	
	assign reg_file_second_src_out = reg_file_src2;
	assign reg_file_first_src_out = reg_file_src1;

	// Instruction[19:16] ==> Rn
	assign reg_file_src1 = instruction_in[19:16];
	
	// Register file
	register_file register_file(.clk(clk), .rst(rst), .src1(reg_file_src1), .src2(reg_file_src2),
		.dest_wb(reg_file_wb_address), .result_wb(reg_file_wb_data), .write_back_en(reg_file_wb_en),
		.reg1(reg_file_out1), .reg2(reg_file_out2)
	);
	
	// Conditional Check
	// Instruction[31:28] ==> cond
	condition_check conditional_check(.cond(instruction_in[31:28]),.status_register(status_register),.cond_state(cond_state));
	
	// Other components
	assign control_unit_mux_in = {execute_command, mem_read, mem_write, immediate, wb_enable, branch_taken, status_write_enable};
	
	assign control_unit_mux_enable = hazard | (~cond_state);
	
	// Number of control signals = 6
	multiplexer_2_to_1 #(.WORD_LENGTH(10)) control_unit_mux(.in1(control_unit_mux_in), .in2(10'b0), .sel1(~control_unit_mux_enable),
			.sel2(control_unit_mux_enable), .out(control_unit_mux_out));
	
	assign {execute_command_out, mem_read_en_out, mem_write_en_out, immediate_out, wb_enable_out,
		branch_taken_out, status_write_enable_out} = control_unit_mux_out;
	
	assign pc = pc_in;
	
	
	// instruction[25] ==> I
	assign two_src = (~instruction_in[25]) | mem_write_en_out;
	assign shift_operand = instruction_in[11:0];
	assign dest_reg_out = instruction_in[15:12];
	assign signed_immediate = instruction_in[23:0];
	
endmodule


module ID_stage_register( input clk, rst, freeze, flush,
	input mem_read_en_in, mem_write_en_in, wb_enable_in, immediate_in, branch_taken_in, status_write_enable_in,
	input [31:0] pc_in, reg_file_in1, reg_file_in2,			
	input [3:0] execute_command_in, dest_reg_in, status_reg_in, src1_addr_in, src2_addr_in,
	input [23:0] signed_immediate_in,
	input [11:0] shift_operand_in,

	output wire mem_read_en_out, mem_write_en_out, wb_enable_out, immediate_out, branch_taken_out, status_write_enable_out,
	output wire [31:0] pc_out, reg_file_out1, reg_file_out2,
	output wire [3: 0] execute_command_out, dest_reg_out, status_reg_out, src1_addr_out, src2_addr_out,
	output wire [23:0] signed_immediate_out,
	output wire [11:0] shift_operand_out
);

flush_register #(.WORD_LENGTH(32)) id_exe_reg_pc_in(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(pc_in), .out(pc_out));

flush_register #(.WORD_LENGTH(1)) id_exe_reg_mem_read_en_in(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(mem_read_en_in), .out(mem_read_en_out));

flush_register #(.WORD_LENGTH(1)) id_exe_reg_mem_write_en_in(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(mem_write_en_in), .out(mem_write_en_out));

flush_register #(.WORD_LENGTH(1)) id_exe_reg_wb_enable_in(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(wb_enable_in), .out(wb_enable_out));

flush_register #(.WORD_LENGTH(1)) id_exe_reg_immediate_in(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(immediate_in), .out(immediate_out));

flush_register #(.WORD_LENGTH(1)) id_exe_reg_branch_taken_in(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(branch_taken_in), .out(branch_taken_out));

flush_register #(.WORD_LENGTH(1)) id_exe_reg_status_write_enable_in(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(status_write_enable_in), .out(status_write_enable_out));

flush_register #(.WORD_LENGTH(4)) id_exe_reg_execute_command_in(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(execute_command_in), .out(execute_command_out));

flush_register #(.WORD_LENGTH(32)) id_exe_reg_reg_file_in1(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(reg_file_in1), .out(reg_file_out1));

flush_register #(.WORD_LENGTH(32)) id_exe_reg_reg_file_in2(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(reg_file_in2), .out(reg_file_out2));

flush_register #(.WORD_LENGTH(4)) id_exe_reg_dest_reg_in(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(dest_reg_in), .out(dest_reg_out));

flush_register #(.WORD_LENGTH(24)) id_exe_id_exe_reg_signed_immediate_in(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(signed_immediate_in), .out(signed_immediate_out));

flush_register #(.WORD_LENGTH(12)) id_exe_reg_shift_operand_in(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(shift_operand_in), .out(shift_operand_out));

flush_register #(.WORD_LENGTH(4)) id_exe_reg_status_reg_in(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(status_reg_in), .out(status_reg_out));

flush_register #(.WORD_LENGTH(4)) id_exe_forwarding_reg_in1(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(src1_addr_in), .out(src1_addr_out));

flush_register #(.WORD_LENGTH(4)) id_exe_forwarding_reg_in2(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(src2_addr_in), .out(src2_addr_out));
		
endmodule


module ID_stage_module(input clk, rst, flush, freeze, reg_file_wb_en, hazard,
		input[31:0] pc_in, instruction_in, reg_file_wb_data, input [3:0] status_reg_in, reg_file_wb_address,	
		output wire two_src_out, ignore_hazard_out,
		output wire [3:0] reg_file_second_src_out, reg_file_first_src_out, execute_command_out, dest_reg_out, status_reg_out,
		output wire [3:0] staged_reg_file_second_src_out, staged_reg_file_first_src_out,
		output wire [31:0] pc_out, reg_file_out1, reg_file_out2,
		output wire mem_read_en_out, mem_write_en_out, wb_enable_out, immediate_out, branch_taken_out, status_write_enable_out,
		output wire [23:0] signed_immediate_out, output wire [11:0] shift_operand_out);
	
	wire[31:0] pc_middle;

	wire mem_read_en_middle, mem_write_en_middle, wb_enable_middle, immediate_middle, branch_taken_middle, status_write_enable_middle;
		
	wire [3: 0] execute_command_middle;
	wire [31:0] reg_file_middle1, reg_file_middle2;
	wire [3:0] dest_reg_middle;
	wire [23:0] signed_immediate_middle;
	wire [11:0] shift_operand_middle;
	wire [3:0] src1_addr_middle, src2_addr_middle;

	ID_stage ID_stage( .clk(clk), .rst(rst), .pc_in(pc_in), .instruction_in(instruction_in), .status_register(status_reg_in), 
	.reg_file_wb_data(reg_file_wb_data), .reg_file_wb_address(reg_file_wb_address), .reg_file_wb_en(reg_file_wb_en), .hazard(hazard),
	.pc(pc_middle), .mem_read_en_out(mem_read_en_middle), .mem_write_en_out(mem_write_en_middle),
	.wb_enable_out(wb_enable_middle), .immediate_out(immediate_middle), .branch_taken_out(branch_taken_middle),
	.status_write_enable_out(status_write_enable_middle), .execute_command_out(execute_command_middle),
	.reg_file_out1(reg_file_middle1), .reg_file_out2(reg_file_middle2), .dest_reg_out(dest_reg_middle),
	.signed_immediate(signed_immediate_middle), .shift_operand(shift_operand_middle), .two_src(two_src_out),
	.reg_file_second_src_out(reg_file_second_src_out), .reg_file_first_src_out(reg_file_first_src_out),
	.ignore_hazard_out(ignore_hazard_out));

	assign src1_addr_middle = reg_file_first_src_out;
	assign src2_addr_middle = reg_file_second_src_out;
		
	ID_stage_register ID_stage_reg(.clk(clk), .rst(rst), .flush(flush), .freeze(freeze), .pc_in(pc_middle), 
	.mem_read_en_in(mem_read_en_middle), .mem_write_en_in(mem_write_en_middle), .wb_enable_in(wb_enable_middle),
	.immediate_in(immediate_middle), .branch_taken_in(branch_taken_middle), .status_write_enable_in(status_write_enable_middle),
	.execute_command_in(execute_command_middle), .reg_file_in1(reg_file_middle1),
	.reg_file_in2(reg_file_middle2), .dest_reg_in(dest_reg_middle),
	.signed_immediate_in(signed_immediate_middle), .shift_operand_in(shift_operand_middle),
	.status_reg_in(status_reg_in), .src1_addr_in(src1_addr_middle), .src2_addr_in(src2_addr_middle), .pc_out(pc_out),			
	.mem_read_en_out(mem_read_en_out), .mem_write_en_out(mem_write_en_out), .wb_enable_out(wb_enable_out),
	.immediate_out(immediate_out), .branch_taken_out(branch_taken_out),
	.status_write_enable_out(status_write_enable_out), .execute_command_out(execute_command_out),
	.reg_file_out1(reg_file_out1), .reg_file_out2(reg_file_out2), .dest_reg_out(dest_reg_out),
	.signed_immediate_out(signed_immediate_out), .shift_operand_out(shift_operand_out),
	.status_reg_out(status_reg_out), .src1_addr_out(staged_reg_file_first_src_out), .src2_addr_out(staged_reg_file_second_src_out));
		
endmodule