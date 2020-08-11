module ID_stage_register(
	input clk, rst, freeze, flush,
	input mem_read_en_in, mem_write_en_in, wb_enable_in, immediate_in, branch_taken_in, status_write_enable_in,
	input [31:0] pc_in,			
	input [3:0] execute_command_in,
	input [31:0] reg_file_in1,
	input [31:0] reg_file_in2,
	input [3:0] dest_reg_in,
	input [23:0] signed_immediate_in,
	input [11:0] shift_operand_in,
	input [3:0] status_reg_in,
	input [3:0] src1_addr_in, src2_addr_in,

	output wire mem_read_en_out,
	output wire mem_write_en_out,
	output wire wb_enable_out,
	output wire immediate_out,
	output wire branch_taken_out,
	output wire status_write_enable_out,
	output wire [31:0] pc_out,
	output wire [3: 0] execute_command_out,
	output wire [31:0] reg_file_out1,
	output wire [31:0] reg_file_out2,
	output wire [3:0] dest_reg_out,
	output wire [23:0] signed_immediate_out,
	output wire [11:0] shift_operand_out,
	output wire [3:0] status_reg_out,
	output wire [3:0] src1_addr_out, src2_addr_out
);

flush_register #(.WORD_LENGTH(32)) reg_pc_in(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(pc_in), .out(pc_out));

flush_register #(.WORD_LENGTH(1)) reg_mem_read_en_in(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(mem_read_en_in), .out(mem_read_en_out));

flush_register #(.WORD_LENGTH(1)) reg_mem_write_en_in(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(mem_write_en_in), .out(mem_write_en_out));

flush_register #(.WORD_LENGTH(1)) reg_wb_enable_in(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(wb_enable_in), .out(wb_enable_out));

flush_register #(.WORD_LENGTH(1)) reg_immediate_in(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(immediate_in), .out(immediate_out));

flush_register #(.WORD_LENGTH(1)) reg_branch_taken_in(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(branch_taken_in), .out(branch_taken_out));

flush_register #(.WORD_LENGTH(1)) reg_status_write_enable_in(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(status_write_enable_in), .out(status_write_enable_out));

flush_register #(.WORD_LENGTH(4)) reg_execute_command_in(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(execute_command_in), .out(execute_command_out));

flush_register #(.WORD_LENGTH(32)) reg_reg_file_in1(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(reg_file_in1), .out(reg_file_out1));

flush_register #(.WORD_LENGTH(32)) reg_reg_file_in2(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(reg_file_in2), .out(reg_file_out2));

flush_register #(.WORD_LENGTH(4)) reg_dest_reg_in(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(dest_reg_in), .out(dest_reg_out));

flush_register #(.WORD_LENGTH(24)) reg_signed_immediate_in(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(signed_immediate_in), .out(signed_immediate_out));

flush_register #(.WORD_LENGTH(12)) reg_shift_operand_in(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(shift_operand_in), .out(shift_operand_out));

flush_register #(.WORD_LENGTH(4)) reg_status_reg_in(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(status_reg_in), .out(status_reg_out));

flush_register #(.WORD_LENGTH(4)) forwarding_reg_in1(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(src1_addr_in), .out(src1_addr_out));

flush_register #(.WORD_LENGTH(4)) forwarding_reg_in2(.clk(clk), .rst(rst), .flush(flush), .ld(~freeze), .in(src2_addr_in), .out(src2_addr_out));
		
endmodule
