module IF_Stage(input clk, rst, freeze, branch_taken, input[31:0] branchAddr, output[31:0] pc, instruction);

	wire[31:0] pc_in, pc_out;

    register #(.WORD_LENGTH(32)) pc_register(.clk(clk), .rst(rst), .ld(~freeze), .in(pc_in), .out(pc_out));

    adder #(.WORD_LENGTH(32)) pc_adder(.in1(pc_out), .in2(4), .out(pc));

    multiplexer_2_to_1 #(.WORD_LENGTH(32)) pc_multiplexer(.in1(pc), .in2(branchAddr), .sel1(~branch_taken), .sel2(branch_taken), .out(pc_in));

	instruction_memory instruction_mem(.clk(clk), .rst(rst), .address(pc_out), .mem_read(1'b1), .read_data(instruction));
	
endmodule


module IF_stage_register (input clk, rst, freeze, flush, input[31:0] pc_in, instruction_in, output wire[31:0] pc, instruction);

flush_register #(.WORD_LENGTH(32)) reg_pc_in(.clk(clk), .rst(rst), .flush(flush),
		.ld(~freeze), .in(pc_in), .out(pc));

flush_register #(.WORD_LENGTH(32)) reg_instruction(.clk(clk), .rst(rst), .flush(flush),
		.ld(~freeze), .in(instruction_in), .out(instruction));

endmodule


module IF_stage_module(input clk, rst, freeze_in, branch_taken_in, flush_in, input[31:0] branchAddr_in,
    output wire [31:0] pc_out, instruction_out);
	wire [31:0] pc_middle;
	wire [31:0] instruction_middle;

    IF_Stage IF_stage(.clk(clk), .rst(rst), .freeze(freeze_in), .branch_taken(branch_taken_in), .branchAddr(branchAddr_in),
    .pc(pc_middle), .instruction(instruction_middle));

    IF_stage_register IF_stage_reg(.clk(clk), .rst(rst), .freeze(freeze_in), .flush(flush_in), .pc_in(pc_middle), 
    .instruction_in(instruction_middle), .pc(pc_out), .instruction(instruction_out));

endmodule