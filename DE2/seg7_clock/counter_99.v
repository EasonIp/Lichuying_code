module counter_99 (clk, rst_n, data);

	input clk, rst_n;
	
	output reg [23:0] data;

	reg clk_10ms;
	
	parameter T10ms = 25000;		// half width of 10ms / 20ns = 250_000
	reg [19:0] count;

	always @ (posedge clk or negedge rst_n)
		begin
			if (!rst_n)
				begin
					count <= 0;
					clk_10ms <= 1;
				end
			else
				begin
					if (count < T10ms - 1)
						count <= count + 20'd1;
					else
						begin
							count <= 0;
							clk_10ms <= ~clk_10ms;
						end
				end
		end
	
	always @ (posedge clk_10ms or negedge rst_n)
		begin
			if (!rst_n)
				data <= 24'h000000;									// BCD clock 00:00:00
			else
				begin
					if (data == 24'h636363)							// BCD clock 99:99:99
						data <= 24'h000000;
					else
						begin
							if (data[15:0] == 16'h6363)			// BCD clock xx:59:99
								begin
									data[15:0] <= 16'h0000;
									data[23:16] <= data[23:16] + 8'h1;
								end
							else
								begin
									if (data[7:0] == 8'h63)			// BCD clock xx:xx:99
										begin
											data[7:0] <= 8'h00;
											data[23:8] <= data[23:8] + 8'h1;
										end
									else
										data <= data + 24'h1;		// BCD clock xx:xx:xx
								end
						end
				end
		end

endmodule
