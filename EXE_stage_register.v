module EXE_stage_register(
	input clk, rst, freeze, wb_en_in, mem_r_en_in, mem_w_en_in, branch_taken_in,
	input [31:0] alu_res_in, val_Rm_in,
	input [3:0] dest_in,
	
	output wb_en_out, mem_r_en_out, mem_w_en_out,
	output [31:0] alu_res_out, val_Rm_out,
	output [3:0] dest_out,
	output branch_taken_out
);
	
	register #(.WORD_LENGTH(1)) reg_wb_en(.clk(clk), .rst(rst), .ld(~freeze), .in(wb_en_in), .out(wb_en_out));

	register #(.WORD_LENGTH(1)) reg_mem_r_en(.clk(clk), .rst(rst), .ld(~freeze), .in(mem_r_en_in), .out(mem_r_en_out));

	register #(.WORD_LENGTH(1)) reg_mem_w_en(.clk(clk), .rst(rst), .ld(~freeze), .in(mem_w_en_in), .out(mem_w_en_out));

	register #(.WORD_LENGTH(32)) reg_alu_res(.clk(clk), .rst(rst), .ld(~freeze), .in(alu_res_in), .out(alu_res_out));

	register #(.WORD_LENGTH(32)) reg_val_Rm(.clk(clk), .rst(rst), .ld(~freeze), .in(val_Rm_in), .out(val_Rm_out));

	register #(.WORD_LENGTH(4)) reg_dest(.clk(clk), .rst(rst), .ld(~freeze), .in(dest_in), .out(dest_out));
	
	register #(.WORD_LENGTH(1)) reg_branch_taken(.clk(clk), .rst(rst), .ld(~freeze), .in(branch_taken_in), .out(branch_taken_out));
	
endmodule

