
module register(clk, rst, ld, in, out);

	parameter WORD_LENGTH = 32;
	input clk, rst, ld;
	input[WORD_LENGTH-1 :0] in;
	output reg[WORD_LENGTH-1:0] out;

	always@(posedge clk, posedge rst) 
	begin
		if (rst) out <= 0;
		else if (ld) out <= in;
	end
	
endmodule


module status_register(input clk, rst, ld, input [3:0] data_in, output reg[3:0] data_out);

	always@(negedge clk, posedge rst) 
	begin
		if (rst) data_out <= 0;
		else if (ld) data_out <= data_in;
	end
	
endmodule