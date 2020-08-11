module IF_stage_module(input clk, rst, freeze_in, branch_taken_in, flush_in, input[31:0] branchAddr_in,
    output wire [31:0] pc_out, instruction_out
);
	wire [31:0] pc_middle;
	wire [31:0] instruction_middle;

    IF_Stage IF_stage(
            .clk(clk),
            .rst(rst),
            .freeze(freeze_in),
            .branch_taken(branch_taken_in),
            .branchAddr(branchAddr_in),
        	.pc(pc_middle),
	        .instruction(instruction_middle)
    );

    IF_stage_register IF_stage_reg(
            .clk(clk),
            .rst(rst),
            .freeze(freeze_in),
            .flush(flush_in),
            .pc_in(pc_middle),
            .instruction_in(instruction_middle),
            .pc(pc_out),
            .instruction(instruction_out)
    );

endmodule