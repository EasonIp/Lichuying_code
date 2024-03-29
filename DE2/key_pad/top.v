module top (clk, rst_n, col, row, hex0,hex1,hex2,hex3,hex4,hex5,hex6,hex7);

	input clk, rst_n;
	input [3:0] row;
	
	output [3:0] col;
	output [6:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7;
	
	wire [3:0] data;
	wire flag;
	wire [31:0] data8;
	
	key_pad k1 (.clk(clk), .rst_n(rst_n), .col(col), .row(row), .data(data), .flag(flag));
	
	pre_seg7 p1 (.clk(clk), .rst_n(rst_n), .data(data), .flag(flag), .data8(data8));

	seg7 s7 (.rst_n(rst_n), .data(data8[31:28]), .hex(hex7));
	seg7 s6 (.rst_n(rst_n), .data(data8[27:24]), .hex(hex6));
	seg7 s5 (.rst_n(rst_n), .data(data8[23:20]), .hex(hex5));
	seg7 s4 (.rst_n(rst_n), .data(data8[19:16]), .hex(hex4));
	seg7 s3 (.rst_n(rst_n), .data(data8[15:12]), .hex(hex3));
	seg7 s2 (.rst_n(rst_n), .data(data8[11: 8]), .hex(hex2));
	seg7 s1 (.rst_n(rst_n), .data(data8[ 7: 4]), .hex(hex1));
	seg7 s0 (.rst_n(rst_n), .data(data8[ 3: 0]), .hex(hex0));
                                         
endmodule
