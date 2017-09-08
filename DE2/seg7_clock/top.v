module top (clk, rst_n, hex0,hex1,hex2,hex3,hex4,hex5,hex6,hex7, LCD_ON, LCD_BLON, LCD_RW, LCD_EN, LCD_RS, LCD_DATA);


	input clk, rst_n;
	
	output [6:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7;
	
	inout [7:0]	LCD_DATA;			//	LCD Data bus 8 bits
	output LCD_ON;					//	LCD Power ON/OFF
	output LCD_BLON;				//	LCD Back Light ON/OFF
	output LCD_RW;					//	LCD Read/Write Select, 0 = Write, 1 = Read
	output LCD_EN;					//	LCD Enable
	output LCD_RS;					//	LCD Command/Data Select, 0 = Command, 1 = Data
	
	wire [31:0] data, data_clk;

	clock_controller  #(.T10ms(250_000))
		clock_controller_inst (.clk(clk), .rst_n(rst_n), .data(data));

	b2bcd_99 b2bcd_99_inst1 (.din(data[31:24]), .dout(data_clk[31:24])); 
	b2bcd_99 b2bcd_99_inst2 (.din(data[23:16]), .dout(data_clk[23:16])); 
	b2bcd_99 b2bcd_99_inst3 (.din(data[15: 8]), .dout(data_clk[15: 8])); 
	b2bcd_99 b2bcd_99_inst4 (.din(data[ 7: 0]), .dout(data_clk[ 7: 0])); 
	                                                    
	seg7 seg7_inst7 (.rst_n(rst_n), .data(data_clk[31:28]), .hex(hex7));
	seg7 seg7_inst6 (.rst_n(rst_n), .data(data_clk[27:24]), .hex(hex6));
	seg7 seg7_inst5 (.rst_n(rst_n), .data(data_clk[23:20]), .hex(hex5));
	seg7 seg7_inst4 (.rst_n(rst_n), .data(data_clk[19:16]), .hex(hex4));
	seg7 seg7_inst3 (.rst_n(rst_n), .data(data_clk[15:12]), .hex(hex3));
	seg7 seg7_inst2 (.rst_n(rst_n), .data(data_clk[11: 8]), .hex(hex2));
	seg7 seg7_inst1 (.rst_n(rst_n), .data(data_clk[ 7: 4]), .hex(hex1));
	seg7 seg7_inst0 (.rst_n(rst_n), .data(data_clk[ 3: 0]), .hex(hex0));
	
	assign	LCD_ON		=	1'b1;
	assign	LCD_BLON	=	1'b1;

	Reset_Delay r0 (.iCLK(clk), .oRESET(DLY_RST));

	LCD_TEST u5 (.iCLK(clk), .iRST_N(DLY_RST), .data_clk(data_clk), .LCD_DATA(LCD_DATA), .LCD_RW(LCD_RW), .LCD_EN(LCD_EN), .LCD_RS(LCD_RS)	);
                                                                              
endmodule
