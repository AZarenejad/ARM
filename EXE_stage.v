module EXE_stage(input clk, rst, wb_en_in, mem_r_en_in, mem_w_en_in, status_w_en_in, branch_taken_in, immd,
    input[31:0] pc_in, val_Rn, val_Rm_in, MEM_wb_value, WB_wb_value, input [3:0] exe_cmd, dest_in, status_reg_in,
	input [23:0] signed_immd_24, input [11:0] shift_operand, input [1:0] alu_mux_sel_src1, alu_mux_sel_src2,
	output wb_en_out, mem_r_en_out, mem_w_en_out, status_w_en_out, branch_taken_out,
	output [3:0] dest_out, status_register, output [31:0] alu_res, val_Rm_out, branch_address);

	wire is_mem_command;
	wire [31:0] val2;
	wire [31:0] alu_mux_src1, alu_mux_src2;

	assign wb_en_out = wb_en_in;
	assign mem_r_en_out = mem_r_en_in;
	assign mem_w_en_out = mem_w_en_in;
	assign status_w_en_out = status_w_en_in;
	assign branch_taken_out = branch_taken_in;
	assign dest_out = dest_in;

	assign is_mem_command = mem_r_en_in | mem_w_en_in;

	// branch_address = PC_in + signed_immd_24;
	adder #(.WORD_LENGTH(32)) adder(.in1(pc_in), .in2({signed_immd_24[23], signed_immd_24[23], signed_immd_24[23], signed_immd_24[23],
			signed_immd_24[23], signed_immd_24[23],signed_immd_24, 2'b0}), .out(branch_address));	

	multiplexer_3_to_1 alu_src1_mux(.in1(val_Rn), .in2(WB_wb_value), .in3(MEM_wb_value), .sel(alu_mux_sel_src1), .out(alu_mux_src1));

	multiplexer_3_to_1 alu_src2_mux(.in1(val_Rm_in), .in2(WB_wb_value), .in3(MEM_wb_value), .sel(alu_mux_sel_src2), .out(alu_mux_src2));
	
	Val2_generator val2_generator(.Rm(alu_mux_src2), .shift_operand(shift_operand), .immd(immd),
			.is_mem_command(is_mem_command), .val2_out(val2)
	);

	assign val_Rm_out = alu_mux_src2;

	ALU alu(.alu_in1(alu_mux_src1), .alu_in2(val2), .alu_command(exe_cmd), .cin(status_reg_in[2]),
			.alu_out(alu_res), .status_register(status_register)
	);

endmodule



module EXE_stage_register(
	input clk, rst, freeze, wb_en_in, mem_r_en_in, mem_w_en_in, branch_taken_in, input [31:0] alu_res_in, val_Rm_in,
	input [3:0] dest_in, output wb_en_out, mem_r_en_out, mem_w_en_out, branch_taken_out,
	output [31:0] alu_res_out, val_Rm_out, output [3:0] dest_out
);
	
	register #(.WORD_LENGTH(1)) exe_mem_reg_wb_en(.clk(clk), .rst(rst), .ld(~freeze), .in(wb_en_in), .out(wb_en_out));

	register #(.WORD_LENGTH(1)) exe_mem_reg_mem_r_en(.clk(clk), .rst(rst), .ld(~freeze), .in(mem_r_en_in), .out(mem_r_en_out));

	register #(.WORD_LENGTH(1)) exe_mem_reg_mem_w_en(.clk(clk), .rst(rst), .ld(~freeze), .in(mem_w_en_in), .out(mem_w_en_out));

	register #(.WORD_LENGTH(32)) exe_mem_reg_alu_res(.clk(clk), .rst(rst), .ld(~freeze), .in(alu_res_in), .out(alu_res_out));

	register #(.WORD_LENGTH(32)) exe_mem_reg_val_Rm(.clk(clk), .rst(rst), .ld(~freeze), .in(val_Rm_in), .out(val_Rm_out));

	register #(.WORD_LENGTH(4)) exe_mem_reg_dest(.clk(clk), .rst(rst), .ld(~freeze), .in(dest_in), .out(dest_out));
	
	register #(.WORD_LENGTH(1)) exe_mem_reg_branch_taken(.clk(clk), .rst(rst), .ld(~freeze), .in(branch_taken_in), .out(branch_taken_out));
	
endmodule

module EXE_stage_module(input clk, rst, freeze, input[31:0] pc_in,
	input wb_en_in, mem_r_en_in, mem_w_en_in, status_w_en_in, branch_taken_in, immd,
	input [3:0] exe_cmd, dest_in, status_reg_in,
	input [31:0] val_Rn, val_Rm_in, MEM_wb_value, WB_wb_value,
	input [23:0] signed_immd_24,
	input [11:0] shift_operand,
	input [1:0] alu_mux_sel_src1, alu_mux_sel_src2,

    output wb_en_out, mem_r_en_out, mem_w_en_out, wb_en_hazard_in, status_w_en_out, branch_taken_out,
	output [31:0] alu_res_out, val_Rm_out, branch_address_out,
	output [3:0] dest_out, dest_hazard_in, status_register_out
);

	wire wb_en_middle, mem_r_en_middle, mem_w_en_middle, branch_taken_middle;
	wire [31:0] alu_res_middle, val_Rm_middle;
	wire [3:0] dest_middle;

    assign wb_en_hazard_in = wb_en_in;
    assign dest_hazard_in = dest_in;

    EXE_stage exe_stage(.clk(clk), .rst(rst), .pc_in(pc_in), .wb_en_in(wb_en_in), .mem_r_en_in(mem_r_en_in), .mem_w_en_in(mem_w_en_in),
            .status_w_en_in(status_w_en_in), .branch_taken_in(branch_taken_in), .immd(immd), .exe_cmd(exe_cmd), .val_Rn(val_Rn),
			.val_Rm_in(val_Rm_in), .dest_in(dest_in), .signed_immd_24(signed_immd_24), .shift_operand(shift_operand), .status_reg_in(status_reg_in),
        
            .alu_mux_sel_src1(alu_mux_sel_src1), .alu_mux_sel_src2(alu_mux_sel_src2),
            .MEM_wb_value(MEM_wb_value), .WB_wb_value(WB_wb_value),

            .wb_en_out(wb_en_middle), .mem_r_en_out(mem_r_en_middle), .mem_w_en_out(mem_w_en_middle), .dest_out(dest_middle),
            .alu_res(alu_res_middle), .val_Rm_out(val_Rm_middle), .status_w_en_out(status_w_en_out),
            .branch_taken_out(branch_taken_middle), .status_register(status_register_out), .branch_address(branch_address_out)
	);

    EXE_stage_register exe_stage_reg( .clk(clk), .rst(rst), .freeze(freeze), .wb_en_in(wb_en_middle),
            .mem_r_en_in(mem_r_en_middle), .mem_w_en_in(mem_w_en_middle), .alu_res_in(alu_res_middle),
            .val_Rm_in(val_Rm_middle), .dest_in(dest_middle), .branch_taken_in(branch_taken_middle),
	
            .wb_en_out(wb_en_out), .mem_r_en_out(mem_r_en_out), .mem_w_en_out(mem_w_en_out), .alu_res_out(alu_res_out),
            .val_Rm_out(val_Rm_out), .dest_out(dest_out), .branch_taken_out(branch_taken_out)
        );
	
endmodule
