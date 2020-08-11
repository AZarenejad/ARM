module WB_stage( input clk, rst, mem_read_enable, wb_enable_in,
        input [31:0] alu_result,
        input [31:0] data_memory,
        input [3:0] wb_dest_in,
        output wire wb_enable_out,
        output wire [3:0] wb_dest_out,
	    output wire [31:0] wb_value);

	multiplexer_2_to_1 #(.WORD_LENGTH(32)) wb_stage_mux(.in1(data_memory), .in2(alu_result),
		.sel1(mem_read_enable), .sel2(~mem_read_enable), .out(wb_value));
		
	assign wb_dest_out = wb_dest_in;
	assign wb_enable_out = wb_enable_in;

endmodule