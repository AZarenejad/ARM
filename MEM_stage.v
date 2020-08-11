
module MEM_stage(input clk, rst,
	input wb_en_in, mem_r_en_in, mem_w_en_in,
	input [31:0] alu_res_in, val_Rm,
	input [3:0] dest_in,

	output wb_en_out, mem_r_en_out,
	output [31:0] mem_out, alu_res_out,
	output [3:0] dest_out,
	output ready);
	
	assign wb_en_out = wb_en_in;
	assign mem_r_en_out = mem_r_en_in;
	assign alu_res_out = alu_res_in;
	assign dest_out = dest_in;

    memory mem(.clk(clk), .rst(rst), .mem_read(mem_r_en_in), .mem_write(mem_w_en_in),
            .address(alu_res_in), .write_data(val_Rm), .read_data(mem_out), .ready(ready));

endmodule