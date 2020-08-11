
module memory(input clk, rst, mem_read, mem_write,input[31:0] address, write_data,
            output wire[31:0] read_data, output ready);
	
	reg[7:0] data[0:511];
	wire [31:0] address4k = {address[31:2], 2'b0} - 32'd1024;
	
	wire [31:0] address4k_p1 = {address4k[31:2], 2'b01}; // address4k + 1
	wire [31:0] address4k_p2 = {address4k[31:2], 2'b10}; // address4k + 2
	wire [31:0] address4k_p3 = {address4k[31:2], 2'b11}; // address4k + 3

	assign ready = 1'b1;
	assign read_data = (mem_read == 1'b1) ? 
			{data[address4k], data[address4k_p1], data[address4k_p2], data[address4k_p3]}
			: 32'b0;

	always @(posedge clk, posedge rst) begin
		if (rst) begin
			data[0] <= 8'b00010000;
			data[1] <= 8'b00000000;
			data[2] <= 8'b00000000;
			data[3] <= 8'b00000000;
			
			data[4] <= 8'b11000000;
			data[5] <= 8'b00100010;
			data[6] <= 8'b00000000;
			data[7] <= 8'b00000000;
			
			data[8] <= 8'b00000000;
			data[9] <= 8'b01100100;
			data[10] <= 8'b00000000;
			data[11] <= 8'b00000000;
			
			data[12] <= 8'b00000000;
			data[13] <= 8'b10100110;
			data[14] <= 8'b00000000;
			data[15] <= 8'b00000000;
		end
		else if (mem_write) begin
			data[address4k_p3] = write_data[7:0];
			// write to data[address + 1]
			data[address4k_p2] = write_data[15:8];
			
			// write to data[address + 2]
			data[address4k_p1] = write_data[23:16];

			// write to data[address + 3]
			data[address4k] = write_data[31:24];
		end
	end

endmodule
