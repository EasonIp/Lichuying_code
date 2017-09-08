`timescale 1ns/1ps

module div_freq2n_tb;

	reg clk, rst_n;
	
	wire clk_out;
	
	div_freq2n #(.CNT_NUM(5)) dut (.clk(clk), .rst_n(rst_n), .clk_out(clk_out));

	initial
		begin
			clk = 1;
			rst_n = 0;
			#200.1
			rst_n = 1;
			
			#2000 $stop;
		end

	always #10 clk = ~clk;

endmodule
