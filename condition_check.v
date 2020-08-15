module condition_check (input [3:0] cond, status_register, output wire cond_state);

    wire z, c, n, v;
    
    // z ==> zero
    // c ==> carry
    // n ==> negative
    // v ==> overflow
    assign {z, c, n, v} = status_register;

	reg temp_condition;
	
	assign cond_state = temp_condition;

    always @(*) begin

        case(cond)
            // COND_EQ
            4'b0000 : begin
                temp_condition <= z;
            end

            // COND_NE
            4'b0001 : begin
                temp_condition <= ~z;
            end

            // COND_CS_HS
            4'b0010 : begin
                temp_condition <= c;
            end

            // COND_CC_LO
            4'b0011 : begin
                temp_condition <= ~c;
            end

            // COND_MI
            4'b0100 : begin
                temp_condition <= n;
            end

            // COND_PL
            4'b0101 : begin
                temp_condition <= ~n;
            end

            // COND_VS
            4'b0110 : begin
                temp_condition <= v;
            end

            // COND_VC
            4'b0111 : begin
                temp_condition <= ~v;
            end

            // COND_HI
            4'b1000 : begin
                temp_condition <= c & ~z;
            end

            // COND_LS
            4'b1001 : begin
                temp_condition <= ~c & z;
            end

            // COND_GE
            4'b1010 : begin
                temp_condition <= (n & v) | (~n & ~v);
            end

            // COND_LT
            4'b1011 : begin
                temp_condition <= (n & ~v) | (~n & v);
            end

            // COND_GT
            4'b1100 : begin
                temp_condition <= ~z & ((n & v) | (~n & ~v));
            end

            // COND_LE
            4'b1101 : begin
                temp_condition <= z | ((n & ~v) | (~n & v));
            end

            // COND_AL 
            4'b1110 : begin
                temp_condition <= 1'b1;
            end
        endcase
    end
endmodule