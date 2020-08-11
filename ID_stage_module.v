module ID_stage_module(
		input clk,
		input rst,
		input flush,
		input freeze, 
		input[31:0] pc_in,
		input [31: 0] instruction_in,
		input [3:0] status_reg_in,
		
		input [31:0] reg_file_wb_data,
		input [3:0] reg_file_wb_address,
		input reg_file_wb_en, hazard,
			
		output wire two_src_out, ignore_hazard_out,
		output wire [3:0] reg_file_second_src_out, reg_file_first_src_out,
	
		output wire [31:0] pc_out,
		output wire mem_read_en_out, mem_write_en_out,
			wb_enable_out, immediate_out,
			branch_taken_out, status_write_enable_out,
			
		output wire [3: 0] execute_command_out,
		output wire [31:0] reg_file_out1, reg_file_out2,
		output wire [3:0] dest_reg_out,
		output wire [23:0] signed_immediate_out,
		output wire [11:0] shift_operand_out,
		output wire [3:0] status_reg_out,

		output wire [3:0] staged_reg_file_second_src_out, staged_reg_file_first_src_out
);
	
	wire[31:0] pc_middle;

	wire mem_read_en_middle, mem_write_en_middle,
		wb_enable_middle, immediate_middle,
		branch_taken_middle, status_write_enable_middle;
		
	wire [3: 0] execute_command_middle;
	wire [31:0] reg_file_middle1, reg_file_middle2;
	wire [3:0] dest_reg_middle;
	wire [23:0] signed_immediate_middle;
	wire [11:0] shift_operand_middle;
	wire [3:0] src1_addr_middle, src2_addr_middle;

	ID_stage ID_stage(
			.clk(clk), .rst(rst), .pc_in(pc_in),
			.instruction_in(instruction_in),
			.status_register(status_reg_in), 

			.reg_file_wb_data(reg_file_wb_data),
			.reg_file_wb_address(reg_file_wb_address),
			.reg_file_wb_en(reg_file_wb_en),
			.hazard(hazard),

			.pc(pc_middle),			
			.mem_read_en_out(mem_read_en_middle),
			.mem_write_en_out(mem_write_en_middle),
			.wb_enable_out(wb_enable_middle),
			.immediate_out(immediate_middle),
			.branch_taken_out(branch_taken_middle),
			.status_write_enable_out(status_write_enable_middle),
			.execute_command_out(execute_command_middle),
			.reg_file_out1(reg_file_middle1),
			.reg_file_out2(reg_file_middle2),
			.dest_reg_out(dest_reg_middle),
			.signed_immediate(signed_immediate_middle),
			.shift_operand(shift_operand_middle),
			
			.two_src(two_src_out),
			.reg_file_second_src_out(reg_file_second_src_out),
			.reg_file_first_src_out(reg_file_first_src_out),
			.ignore_hazard_out(ignore_hazard_out)
		);

	assign src1_addr_middle = reg_file_first_src_out;
	assign src2_addr_middle = reg_file_second_src_out;
		
	ID_stage_register ID_stage_reg(
		.clk(clk),
		.rst(rst),
		.flush(flush),
		.freeze(freeze),
	
		.pc_in(PC_middle),			
		.mem_read_en_in(mem_read_en_middle),
		.mem_write_en_in(mem_write_en_middle),
		.wb_enable_in(wb_enable_middle),
		.immediate_in(immediate_middle),
		.branch_taken_in(branch_taken_middle),
		.status_write_enable_in(status_write_enable_middle),
		.execute_command_in(execute_command_middle),
		.reg_file_in1(reg_file_middle1),
		.reg_file_in2(reg_file_middle2),
		.dest_reg_in(dest_reg_middle),
		.signed_immediate_in(signed_immediate_middle),
		.shift_operand_in(shift_operand_middle),
		.status_reg_in(status_reg_in),
		.src1_addr_in(src1_addr_middle),
		.src2_addr_in(src2_addr_middle),

		.pc_out(pc_out),			
		.mem_read_en_out(mem_read_en_out),
		.mem_write_en_out(mem_write_en_out),
		.wb_enable_out(wb_enable_out),
		.immediate_out(immediate_out),
		.branch_taken_out(branch_taken_out),
		.status_write_enable_out(status_write_enable_out),
		.execute_command_out(execute_command_out),
		.reg_file_out1(reg_file_out1),
		.reg_file_out2(reg_file_out2),
		.dest_reg_out(dest_reg_out),
		.signed_immediate_out(signed_immediate_out),
		.shift_operand_out(shift_operand_out),
		.status_reg_out(status_reg_out),
		.src1_addr_out(staged_reg_file_first_src_out),
		.src2_addr_out(staged_reg_file_second_src_out)
	);
		
endmodule