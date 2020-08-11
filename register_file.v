module register_file(input clk, rst, input [3:0] src1, src2, dest_wb, input[31:0] result_wb,
                    input write_back_en, output [31:0] reg1, reg2);
                    
    integer counter = 0;
    reg[31:0] data[0:15];

    assign reg1 = data[src1];
    assign reg2 = data[src2];

    always @(negedge clk, posedge rst) begin
		if (rst) begin
			for(counter=0; counter < 16; counter=counter+1)
				data[counter] <= counter;
        end
        else if (write_back_en) data[dest_wb] = result_wb;
	end

endmodule