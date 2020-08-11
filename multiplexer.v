module multiplexer_2_to_1(in1, in2, sel1, sel2, out);
    parameter WORD_LENGTH = 32;
    input[WORD_LENGTH-1:0] in1, in2;
    input sel1, sel2;
    output[WORD_LENGTH-1:0] out;

    assign out = sel1 ? in1 : (sel2 ? in2 : out);
    
endmodule




module multiplexer_3_to_1(in1, in2, in3, sel, out);
  
	parameter WORD_LENGTH = 32;
	input [WORD_LENGTH - 1:0] in1, in2, in3;
	input [1:0] sel;
	output [WORD_LENGTH - 1:0] out;
	

    // forwarding
    //  00 ==> sel from ID
    //  01 ==> sel from write back
    //  10 ==> self from memory
	assign out = (sel == 2'b00) ? in1 :
			((sel == 2'b01) ? in2 :
			((sel == 2'b10) ? in3 : out)); 
	
endmodule