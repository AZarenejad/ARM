module EXE_stage_module(
    input clk, rst, freeze,
	input[31:0] pc_in,
	input wb_en_in, mem_r_en_in, mem_w_en_in, status_w_en_in, branch_taken_in, immd,
	input [3:0] exe_cmd,
	input [31:0] val_Rn, val_Rm_in,
	input [3:0] dest_in,
	input [23:0] signed_immd_24,
	input [11:0] shift_operand,
	input [3:0] status_reg_in,

	//forwarding inputs:
	input [1:0] alu_mux_sel_src1, alu_mux_sel_src2,
	input [31:0] MEM_wb_value, WB_wb_value,

    output wb_en_out, mem_r_en_out, mem_w_en_out,
	output [31:0] alu_res_out, val_Rm_out,
	output [3:0] dest_out,

    output wb_en_hazard_in,
    output [3:0] dest_hazard_in,
	output status_w_en_out, branch_taken_out,
	output [3:0] status_register_out,
	output[31:0] branch_address_out
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
