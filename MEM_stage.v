
module MEM_stage(input clk, rst, wb_en_in, mem_r_en_in, mem_w_en_in, input [31:0] alu_res_in, val_Rm,
	input [3:0] dest_in, output wb_en_out, mem_r_en_out, ready, output [31:0] mem_out, alu_res_out, output [3:0] dest_out);
	
	assign wb_en_out = wb_en_in;
	assign mem_r_en_out = mem_r_en_in;
	assign alu_res_out = alu_res_in;
	assign dest_out = dest_in;

    memory mem(.clk(clk), .rst(rst), .mem_read(mem_r_en_in), .mem_write(mem_w_en_in),
            .address(alu_res_in), .write_data(val_Rm), .read_data(mem_out), .ready(ready));

endmodule


module mem_stage_register(input clk, rst, freeze, wb_en_in, mem_r_en_in,
	input [31:0] alu_res_in, mem_res_in, input [3:0] dest_in,
	output wb_en_out, mem_r_en_out, output [31:0] alu_res_out, mem_res_out , output [3:0] dest_out);
	
	register #(.WORD_LENGTH(1)) mem_wb_reg_wb_en(.clk(clk), .rst(rst), .ld(~freeze), .in(wb_en_in), .out(wb_en_out));

	register #(.WORD_LENGTH(1)) mem_wb_reg_mem_r_en(.clk(clk), .rst(rst), .ld(~freeze), .in(mem_r_en_in), .out(mem_r_en_out));

	register #(.WORD_LENGTH(32)) mem_wb_reg_alu_res(.clk(clk), .rst(rst), .ld(~freeze), .in(alu_res_in), .out(alu_res_out));

	register #(.WORD_LENGTH(32)) mem_wb_reg_val_Rm(.clk(clk), .rst(rst), .ld(~freeze), .in(mem_res_in), .out(mem_res_out));

	register #(.WORD_LENGTH(4)) mem_wb_reg_dest(.clk(clk), .rst(rst), .ld(~freeze), .in(dest_in), .out(dest_out));
	
endmodule


module MEM_stage_module(input clk, rst, freeze, wb_en_in, mem_r_en_in, mem_w_en_in, input [31:0] alu_res_in, val_Rm,
 						input [3:0] dest_in, output wb_en_out, mem_r_en_out, output [31:0] alu_res_out, mem_res_out,
						output [3:0] dest_out, output wb_en_hazard_in, ready, output [3:0] dest_hazard_in);

    wire wb_en_middle, mem_r_en_middle;
	wire [31:0] alu_res_middle, mem_res_middle;
	wire [3:0] dest_middle;

    assign wb_en_hazard_in = wb_en_in;
    assign dest_hazard_in = dest_in;

	MEM_stage memory_stage(.clk(clk), .rst(rst), .wb_en_in(wb_en_in), .mem_r_en_in(mem_r_en_in), .mem_w_en_in(mem_w_en_in),
            .alu_res_in(alu_res_in), .val_Rm(val_Rm), .dest_in(dest_in),
            .wb_en_out(wb_en_middle), .mem_r_en_out(mem_r_en_middle), .mem_out(mem_res_middle), .alu_res_out(alu_res_middle),
            .dest_out(dest_middle), .ready(ready));

    mem_stage_register mem_stage_reg(.clk(clk), .rst(rst), .freeze(freeze), .wb_en_in(wb_en_middle),
                                .mem_r_en_in(mem_r_en_middle), .alu_res_in(alu_res_middle),
                                .mem_res_in(mem_res_middle), .dest_in(dest_middle),
                                .wb_en_out(wb_en_out), .mem_r_en_out(mem_r_en_out), .alu_res_out(alu_res_out),
                                .mem_res_out(mem_res_out), .dest_out(dest_out));
	
endmodule

