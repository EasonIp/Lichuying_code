module key_filter (clk, rst_n, key_n, click_n);

	input clk, rst_n;
	input key_n;
	
	output reg click_n;
	
	parameter MASK_TIME = 500_000;	// 10ms/20ns=500_000,for checking key hold time

	reg [18:0] cnt;
	reg state;
	
	localparam	s0 = 1'b0,
					s1 = 1'b1;
					
	always @ (posedge clk or negedge rst_n)
		begin
			if (!rst_n)
				begin
					cnt <= 0;
					click_n <= 1;
					state <= s0;
				end
			else
				begin
					case (state)
					s0	:	begin
								if (key_n)
									begin
										cnt <= 0;
										click_n <= 1;
										state <= s0;
									end
								else
									begin
										if (cnt < MASK_TIME - 1)
											begin
												cnt <= cnt + 19'b1;
												state <= s0;
											end
										else
											begin
												cnt <= 0;
												click_n <= 0;
												state <= s1;
											end
									end
							end
					
					s1	:	begin
								if (!key_n)
									begin
										cnt <= 0;
										click_n <= 0;
										state <= s1;
									end
								else
									begin
										if (cnt < MASK_TIME - 1)
											begin
												cnt <= cnt + 19'b1;
												state <= s1;
											end
										else
											begin
												cnt <= 0;
												click_n <= 1;
												state <= s0;
											end
									end
							end
					
					default	:	state <= s0;
					
					endcase
				end
		end

endmodule
