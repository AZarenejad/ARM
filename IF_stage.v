module IF_Stage(input clk, rst, freeze, branch_taken, input[31:0] branchAddr, output[31:0] pc, instruction);

	reg pc_write_en;
	wire[31:0] pc_in, pc_out;

    register #(.WORD_LENGTH(32)) pc_register(.clk(clk), .rst(rst), .ld(~freeze), .in(pc_in), .out(pc_out));

    adder #(.WORD_LENGTH(32)) pc_adder(.in1(pc_out), .in2(4), .out(pc));

    multiplexer_2_to_1 #(.WORD_LENGTH(32)) pc_multiplexer(.in1(pc), .in2(branchAddr), .sel1(~branch_taken), .sel2(branch_taken), .out(pc_in));

	reg[31:0] instruction_write_data;
	wire[31:0] read_data;

	assign instruction = read_data;

	instruction_memory instruction_mem(.clk(clk), .rst(rst), .address(pc_out),
                                    .write_data(instruction_write_data), .mem_read(1'b1),
                                    .mem_write(1'b0), .read_data(read_data));
	
endmodule
