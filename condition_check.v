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

        // temp_condition <= 1'b1;
        // temp_condition <= (cond == 4'b0000) ? z : // COND_EQ
        // (cond == 4'b0001) ? ~z : // COND_NE
        // (cond == 4'b0010) ? c : // COND_CS_HS
        // (cond == 4'b0011) ? ~c : // COND_CC_LO
        // (cond == 4'b0100) ? n : // COND_MI
        // (cond == 4'b0101) ? ~n : // COND_PL
        // (cond == 4'b0110) ? v : // COND_VS
        // (cond == 4'b0111) ? ~v : // COND_VC
        // (cond == 4'b1000) ? c & ~z : // COND_HI
        // (cond == 4'b1001) ?  ~c & z : // COND_LS
        // (cond == 4'b1010) ? (n & v) | (~n & ~v) : // COND_GE
        // (cond == 4'b1011) ? (n & ~v) | (~n & v) : // COND_LT
        // (cond == 4'b1100) ?  ~z & ((n & v) | (~n & ~v)) : // COND_GT
        // (cond == 4'b1101) ?  z | ((n & ~v) | (~n & v)) : // COND_LE
        // (cond == 4'b1110) ? 1'b1 : temp_condition;

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