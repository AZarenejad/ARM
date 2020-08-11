module mem_stage_register(input clk, rst, input freeze, input wb_en_in, mem_r_en_in,
	input [31:0] alu_res_in, mem_res_in,
	input [3:0] dest_in,

	output wb_en_out, mem_r_en_out,
	output [31:0] alu_res_out, mem_res_out,
	output [3:0] dest_out
);
	
	register #(.WORD_LENGTH(1)) reg_wb_en(.clk(clk), .rst(rst), .ld(~freeze), .in(wb_en_in), .out(wb_en_out));

	register #(.WORD_LENGTH(1)) reg_mem_r_en(.clk(clk), .rst(rst), .ld(~freeze), .in(mem_r_en_in), .out(mem_r_en_out));

	register #(.WORD_LENGTH(32)) reg_alu_res(.clk(clk), .rst(rst), .ld(~freeze), .in(alu_res_in), .out(alu_res_out));

	register #(.WORD_LENGTH(32)) reg_val_Rm(.clk(clk), .rst(rst), .ld(~freeze), .in(mem_res_in), .out(mem_res_out));

	register #(.WORD_LENGTH(4)) reg_dest(.clk(clk), .rst(rst), .ld(~freeze), .in(dest_in), .out(dest_out));
	
endmodule

