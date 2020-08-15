`timescale 1ns/1ns

module test_bench();
    reg clk = 0, rst, en_forwarding;

    arm uut(clk, rst, en_forwarding);

    always #100 clk = ~clk;

    initial begin
        en_forwarding = 0;
        rst = 1;
        #100;
        rst = 0;
    end

endmodule

