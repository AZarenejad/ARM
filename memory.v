
module memory(input clk, rst, mem_read, mem_write,input[31:0] address, write_data,
            output wire[31:0] read_data, output ready);
	
	reg[31:0] data[0:63];
	wire[31:0] diff = address - 32'd1024;
	wire [31:0] address4k = {2'b0, diff[31:2]};

	assign ready = 1'b1;

	assign read_data = (mem_read == 1'b1) ? data[address4k] : 32'b0;

	always @(posedge clk, posedge rst) begin
		if (rst) begin

			data[0] = 32'b00010000_00000000_00000000_00000000;
			data[1] = 32'b11000000_00100010_00000000_00000000;
			data[2] = 32'b00000000_01100100_00000000_00000000;
			data[3] = 32'b00000000_10100110_00000000_00000000;

		end
		else if (mem_write) begin
			data[address4k] <= write_data;

		end
	end

endmodule
