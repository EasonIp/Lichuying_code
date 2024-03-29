module divider (clk, rst_n, clk_out);

	input clk, rst_n;
	
	output clk_out;

	parameter WIDTH = 5;			// WIDTH = 3

	wire out_clk_1, out_clk_2;
	
	div_freq #(.HW(WIDTH>>1), .LW((WIDTH+1)>>1)) 
		d1 (.clk(clk), .rst_n(rst_n), .clk_out(out_clk_1));
	
	div_freq #(.HW(WIDTH>>1), .LW((WIDTH+1)>>1)) 
		d2 (.clk(~clk), .rst_n(rst_n), .clk_out(out_clk_2));
	
	assign clk_out = (WIDTH & 1'b1) ? (out_clk_1 || out_clk_2) : out_clk_1;

endmodule
