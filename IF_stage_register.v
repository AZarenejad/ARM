module IF_stage_register (input clk, rst, freeze, flush,
	input[31:0] pc_in, instruction_in,
	output wire[31:0] pc, instruction
);

flush_register #(.WORD_LENGTH(32)) reg_pc_in(.clk(clk), .rst(rst), .flush(flush),
		.ld(~freeze), .in(pc_in), .out(pc));

flush_register #(.WORD_LENGTH(32)) reg_instruction(.clk(clk), .rst(rst), .flush(flush),
		.ld(~freeze), .in(instruction_in), .out(instruction));

endmodule